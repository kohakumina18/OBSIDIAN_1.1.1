#!/usr/bin/env python3
"""Synchronize PPJ local project Executive Boards from Tasks/*.md.

Dry-run is the default. Existing executive summary, board metadata, and management
attention nodes are preserved when a board is rebuilt.
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
from datetime import datetime
from pathlib import Path

from upgrade_ppj_project_workspaces import (
    PRIORITY_ORDER,
    STATUS_TO_LANE,
    PlannedTask,
    VAULT_ROOT,
    build_project_board,
    discover_projects,
    extract_frontmatter,
    fm_scalar,
    identity_key,
    read_text,
    unique,
    validate_project_board,
    write_text,
)

PRESERVED_NODE_IDS = {
    "ppj-board-metadata",
    "ppj-exec-summary",
    "ppj-management-attention",
}
ALLOWED_STATUSES = set(STATUS_TO_LANE)
ALLOWED_PRIORITIES = set(PRIORITY_ORDER)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Synchronize PPJ project task boards")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Plan only; default")
    mode.add_argument("--apply", action="store_true", help="Apply after explicit approval")
    selection = parser.add_mutually_exclusive_group(required=True)
    selection.add_argument("--project", help="Canonical code, alias, or current project filename")
    selection.add_argument("--all", action="store_true", help="Synchronize all project workspaces")
    parser.add_argument("--force", action="store_true", help="Rebuild even when generated JSON is unchanged")
    return parser.parse_args()


def load_local_tasks(project) -> tuple[list[PlannedTask], list[str]]:
    task_root = project.folder / "Tasks"
    warnings: list[str] = []
    tasks: list[PlannedTask] = []
    seen_ids: set[str] = set()
    seen_titles: set[str] = set()
    if not task_root.exists():
        return [], [f"Task folder missing: {task_root.relative_to(VAULT_ROOT)}"]
    for path in sorted(task_root.glob("*.md")):
        text = read_text(path)
        fm, _, _ = extract_frontmatter(text)
        if fm_scalar(fm, "type") != "project_task":
            warnings.append(f"Skipped non-project_task file: {path.relative_to(VAULT_ROOT)}")
            continue
        task_project = fm_scalar(fm, "project")
        if identity_key(task_project) not in project.aliases:
            warnings.append(
                f"Skipped task mapped to another project: {path.relative_to(VAULT_ROOT)} ({task_project})"
            )
            continue
        task_id = fm_scalar(fm, "task_id")
        title = fm_scalar(fm, "title")
        status = fm_scalar(fm, "status", default="backlog").casefold()
        priority = fm_scalar(fm, "priority", default="TBD").upper()
        owner = fm_scalar(fm, "owner", default="Needs Confirmation")
        due = fm_scalar(fm, "due")
        source_event = fm_scalar(fm, "source_event", default=project.source_event)
        acceptance = fm_scalar(
            fm,
            "acceptance",
            default="Completion evidence is recorded and reviewed by the responsible owner.",
        )
        if not task_id or not title:
            warnings.append(f"Skipped task missing task_id/title: {path.relative_to(VAULT_ROOT)}")
            continue
        if status not in ALLOWED_STATUSES:
            warnings.append(f"Skipped task with invalid status '{status}': {path.relative_to(VAULT_ROOT)}")
            continue
        if priority not in ALLOWED_PRIORITIES:
            warnings.append(f"Task priority normalized to TBD: {path.relative_to(VAULT_ROOT)}")
            priority = "TBD"
        if task_id in seen_ids:
            warnings.append(f"Duplicate task_id skipped: {task_id}")
            continue
        title_key = identity_key(title)
        if title_key in seen_titles:
            warnings.append(f"Duplicate task title skipped: {title}")
            continue
        seen_ids.add(task_id)
        seen_titles.add(title_key)
        tasks.append(
            PlannedTask(
                title=title,
                status=status,
                priority=priority,
                owner=owner or "Needs Confirmation",
                due=due,
                acceptance=acceptance,
                source_event=source_event,
                task_id=task_id,
                filename=path.name,
            )
        )
    tasks.sort(key=lambda item: (list(STATUS_TO_LANE).index(item.status), PRIORITY_ORDER[item.priority], item.title.casefold()))
    return tasks, warnings


def merge_preserved_nodes(existing: dict[str, object], rebuilt: dict[str, object]) -> dict[str, object]:
    preserved = {
        str(node.get("id")): node
        for node in existing.get("nodes", [])
        if isinstance(node, dict) and str(node.get("id")) in PRESERVED_NODE_IDS
    }
    nodes = []
    for node in rebuilt.get("nodes", []):
        node_id = str(node.get("id", "")) if isinstance(node, dict) else ""
        nodes.append(preserved.get(node_id, node))
    rebuilt["nodes"] = nodes
    return rebuilt


def backup_canvas(path: Path, project_code: str, timestamp: str) -> Path:
    destination = (
        VAULT_ROOT
        / "99_Attachments"
        / "Canvas_Backup"
        / timestamp
        / project_code.replace("/", "-")
        / "Project_Executive_Board.canvas"
    )
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(path, destination)
    return destination


def main() -> int:
    args = parse_args()
    projects, hard_stops, discovery_warnings = discover_projects(args.project)
    warnings = list(discovery_warnings)
    plans = []
    for project in projects:
        if not project.folder.exists():
            hard_stops.append(
                f"Workspace does not exist for {project.code}: {project.folder.relative_to(VAULT_ROOT)}"
            )
            continue
        tasks, task_warnings = load_local_tasks(project)
        warnings.extend(task_warnings)
        board_path = project.folder / "Project_Executive_Board.canvas"
        rebuilt = build_project_board(project, tasks)
        if board_path.exists():
            try:
                existing = json.loads(read_text(board_path))
                rebuilt = merge_preserved_nodes(existing, rebuilt)
            except json.JSONDecodeError as exc:
                hard_stops.append(f"Invalid existing Canvas for {project.code}: {exc}")
                continue
        validate_project_board(rebuilt)
        content = json.dumps(rebuilt, ensure_ascii=False, indent=2).rstrip() + "\n"
        current = read_text(board_path)
        plans.append(
            {
                "project": project,
                "tasks": tasks,
                "path": board_path,
                "content": content,
                "changed": current != content,
                "exists": board_path.exists(),
            }
        )

    hard_stops = unique(hard_stops)
    warnings = unique(warnings)
    print("PPJ Project Board Synchronization")
    print(f"Mode: {'Apply' if args.apply else 'DryRun'}")
    print(f"Projects resolved: {len(projects)}")
    print(f"Boards evaluated: {len(plans)}")
    print(f"Boards to create: {sum(not item['exists'] for item in plans)}")
    print(f"Boards to update: {sum(item['changed'] and item['exists'] for item in plans)}")
    print(f"Task cards: {sum(len(item['tasks']) for item in plans)}")
    print("Hard stops:")
    for item in hard_stops or ["None"]:
        print(f" - {item}")
    print("Warnings:")
    for item in warnings or ["None"]:
        print(f" - {item}")
    print(f"Safe to Apply: {not hard_stops}")

    if not args.apply:
        return 0 if not hard_stops else 2
    if hard_stops:
        print("Apply refused because hard stops exist.", file=sys.stderr)
        return 2

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    changed = 0
    for item in plans:
        if not item["changed"] and not args.force:
            continue
        path = item["path"]
        if path.exists():
            backup_canvas(path, item["project"].code, timestamp)
        write_text(path, item["content"])
        json.loads(read_text(path))
        changed += 1
    print(f"Boards synchronized: {changed}")
    print("Canvas JSON validation: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
