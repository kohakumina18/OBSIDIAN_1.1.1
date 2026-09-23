#!/usr/bin/env python3
"""Atomically create one evidence-based task and synchronize governance assets."""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import sys
import tempfile
from datetime import date, datetime
from pathlib import Path

from sync_ppj_project_boards import load_local_tasks, merge_preserved_nodes
from upgrade_ppj_project_workspaces import (
    COMMAND_CENTER,
    LEDGER_PATH,
    PRIORITY_ORDER,
    REGISTRY_PATH,
    STATUS_TO_LANE,
    PlannedTask,
    VAULT_ROOT,
    build_project_board,
    command_center_workspace_block,
    discover_projects,
    extract_frontmatter,
    fm_scalar,
    identity_key,
    read_text,
    registry_workspace_block,
    replace_managed_block,
    slug_id,
    unique,
    validate_project_board,
    yaml_quote,
)

TODAY = date.today().isoformat()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Create a PPJ project task")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Plan only; default")
    mode.add_argument("--apply", action="store_true", help="Create after explicit approval")
    parser.add_argument("--project", required=True, help="Canonical code, alias, or current project filename")
    parser.add_argument("--title", required=True, help="Task title")
    parser.add_argument("--priority", choices=sorted(PRIORITY_ORDER), default="TBD")
    parser.add_argument("--owner", default="Needs Confirmation")
    parser.add_argument("--due", default="")
    parser.add_argument("--status", choices=list(STATUS_TO_LANE), default="backlog")
    parser.add_argument("--acceptance", required=True, help="One concise acceptance condition")
    parser.add_argument("--source-event", default="")
    return parser.parse_args()


def validate_due(value: str) -> None:
    if not value:
        return
    if not re.fullmatch(r"\d{4}-\d{2}-\d{2}", value):
        raise ValueError("--due must be empty or YYYY-MM-DD")
    date.fromisoformat(value)


def next_task_number(task_root: Path, prefix: str) -> int:
    highest = 0
    pattern = re.compile(rf"^{re.escape(prefix)}-TASK-(\d+)$", re.I)
    for path in task_root.glob("*.md"):
        fm, _, _ = extract_frontmatter(read_text(path))
        task_id = fm_scalar(fm, "task_id")
        match = pattern.match(task_id)
        if match:
            highest = max(highest, int(match.group(1)))
    return highest + 1


def duplicate_title(task_root: Path, title: str) -> Path | None:
    target = identity_key(title)
    for path in task_root.glob("*.md"):
        fm, _, _ = extract_frontmatter(read_text(path))
        existing = fm_scalar(fm, "title")
        if existing and identity_key(existing) == target:
            return path
    return None


def render_task(args: argparse.Namespace, project, task_id: str) -> str:
    source_event = args.source_event or project.source_event or "Needs Confirmation"
    return f"""---
type: project_task
project: {yaml_quote(project.code)}
task_id: {yaml_quote(task_id)}
title: {yaml_quote(args.title.strip())}
status: {args.status}
priority: {args.priority}
owner: {yaml_quote(args.owner.strip() or 'Needs Confirmation')}
due: {yaml_quote(args.due)}
source_event: {yaml_quote(source_event)}
created: {TODAY}
updated: {TODAY}
blocked_by: []
depends_on: []
acceptance: {yaml_quote(args.acceptance.strip())}
---

# {args.title.strip()}

## Project

[[../00_Project_Home|{project.code}]]

## Acceptance

{args.acceptance.strip()}

## Source Event

{source_event}

## Notes

TBD
"""


def stage_and_commit(changes: dict[Path, str], backup_root: Path) -> None:
    backups: dict[Path, Path] = {}
    committed: list[Path] = []
    staging_parent = VAULT_ROOT / "99_Attachments" / "Audit"
    staging_parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=".ppj-task-", dir=staging_parent) as temp_name:
        temp_root = Path(temp_name)
        staged: dict[Path, Path] = {}
        for target, content in changes.items():
            staged_path = temp_root / target.relative_to(VAULT_ROOT)
            staged_path.parent.mkdir(parents=True, exist_ok=True)
            staged_path.write_text(content.rstrip() + "\n", encoding="utf-8")
            if target.suffix == ".canvas":
                json.loads(staged_path.read_text(encoding="utf-8"))
            staged[target] = staged_path
        try:
            for target in changes:
                if target.exists():
                    backup = backup_root / target.relative_to(VAULT_ROOT)
                    backup.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(target, backup)
                    backups[target] = backup
            for target, staged_path in staged.items():
                target.parent.mkdir(parents=True, exist_ok=True)
                os.replace(staged_path, target)
                committed.append(target)
        except Exception:
            for target in reversed(committed):
                backup = backups.get(target)
                if backup and backup.exists():
                    shutil.copy2(backup, target)
                elif target.exists():
                    target.unlink()
            raise


def main() -> int:
    args = parse_args()
    try:
        validate_due(args.due)
    except ValueError as exc:
        print(f"Validation error: {exc}", file=sys.stderr)
        return 2

    projects, hard_stops, warnings = discover_projects(args.project)
    if len(projects) != 1:
        hard_stops.append(f"Expected one canonical project; resolved {len(projects)}")
    if hard_stops:
        print("Hard stops:")
        for item in hard_stops:
            print(f" - {item}")
        return 2
    project = projects[0]
    if not project.folder.exists():
        print(
            f"Hard stop: workspace does not exist for {project.code}: {project.folder.relative_to(VAULT_ROOT)}",
            file=sys.stderr,
        )
        return 2

    task_root = project.folder / "Tasks"
    duplicate = duplicate_title(task_root, args.title) if task_root.exists() else None
    if duplicate:
        print(f"Hard stop: duplicate task title exists: {duplicate.relative_to(VAULT_ROOT)}", file=sys.stderr)
        return 2

    prefix = slug_id(project.code)
    number = next_task_number(task_root, prefix) if task_root.exists() else 1
    task_id = f"{prefix}-TASK-{number:03d}"
    title_slug = re.sub(r"[^A-Za-z0-9]+", "-", args.title.strip()).strip("-")[:60]
    filename = f"{task_id}_{title_slug or 'task'}.md"
    task_path = task_root / filename

    print("PPJ New Project Task")
    print(f"Mode: {'Apply' if args.apply else 'DryRun'}")
    print(f"Project: {project.code}")
    print(f"Task ID: {task_id}")
    print(f"Status / Lane: {args.status} -> {STATUS_TO_LANE[args.status]}")
    print(f"Priority: {args.priority}")
    print(f"Owner: {args.owner or 'Needs Confirmation'}")
    print(f"Due: {args.due or 'TBD'}")
    print(f"Task file: {task_path.relative_to(VAULT_ROOT)}")
    print(f"Board: {(project.folder / 'Project_Executive_Board.canvas').relative_to(VAULT_ROOT)}")
    print(f"Registry: {REGISTRY_PATH.relative_to(VAULT_ROOT)}")
    print(f"Command Center: {COMMAND_CENTER.relative_to(VAULT_ROOT)}")
    print(f"Update ledger: {LEDGER_PATH.relative_to(VAULT_ROOT)}")
    for warning in warnings:
        print(f"Warning: {warning}")
    if not args.apply:
        print("DryRun only. No files were modified.")
        return 0

    all_projects, discovery_stops, discovery_warnings = discover_projects(None)
    if discovery_stops:
        print("Apply refused because portfolio discovery has hard stops:", file=sys.stderr)
        for item in discovery_stops:
            print(f" - {item}", file=sys.stderr)
        return 2
    target = next((item for item in all_projects if identity_key(item.code) == identity_key(project.code)), None)
    if target is None:
        print("Apply refused because the target project was not found in the portfolio set.", file=sys.stderr)
        return 2
    for item in all_projects:
        tasks, task_warnings = load_local_tasks(item)
        item.tasks = tasks
        discovery_warnings.extend(task_warnings)

    source_event = args.source_event or target.source_event or "Needs Confirmation"
    new_task = PlannedTask(
        title=args.title.strip(),
        status=args.status,
        priority=args.priority,
        owner=args.owner.strip() or "Needs Confirmation",
        due=args.due,
        acceptance=args.acceptance.strip(),
        source_event=source_event,
        task_id=task_id,
        filename=filename,
    )
    target.tasks.append(new_task)
    target.tasks.sort(
        key=lambda item: (
            list(STATUS_TO_LANE).index(item.status),
            PRIORITY_ORDER[item.priority],
            item.title.casefold(),
        )
    )
    board_path = target.folder / "Project_Executive_Board.canvas"
    board = build_project_board(target, target.tasks)
    if board_path.exists():
        try:
            board = merge_preserved_nodes(json.loads(read_text(board_path)), board)
        except json.JSONDecodeError as exc:
            print(f"Apply refused because the existing board is invalid JSON: {exc}", file=sys.stderr)
            return 2
    validate_project_board(board)

    registry_content = replace_managed_block(
        read_text(REGISTRY_PATH),
        "<!-- PPJ_PROJECT_WORKSPACE_REGISTRY_START -->",
        "<!-- PPJ_PROJECT_WORKSPACE_REGISTRY_END -->",
        registry_workspace_block(all_projects),
    )
    command_content = replace_managed_block(
        read_text(COMMAND_CENTER),
        "<!-- PPJ_PROJECT_WORKSPACES_START -->",
        "<!-- PPJ_PROJECT_WORKSPACES_END -->",
        command_center_workspace_block(all_projects),
    )
    ledger_row = (
        f"| {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} | {target.code} | task_created | "
        f"Created {task_id}: {args.title.strip().replace('|', '/')} | task_count | "
        f"{len(target.tasks) - 1} | {len(target.tasks)} | {source_event.replace('|', '/')} | "
        f"{args.acceptance.strip().replace('|', '/')} | task / local board / registry / command center | "
        f"Execute or review task according to lane and owner. |"
    )
    changes = {
        task_path: render_task(args, target, task_id),
        board_path: json.dumps(board, ensure_ascii=False, indent=2),
        REGISTRY_PATH: registry_content,
        COMMAND_CENTER: command_content,
        LEDGER_PATH: read_text(LEDGER_PATH).rstrip() + "\n" + ledger_row,
    }
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    backup_root = VAULT_ROOT / "99_Attachments" / "Audit" / "Project_Task_Backup" / timestamp
    try:
        stage_and_commit(changes, backup_root)
    except Exception as exc:
        print(f"Task creation failed and was rolled back: {exc}", file=sys.stderr)
        return 1
    print(f"Task created: {task_path.relative_to(VAULT_ROOT)}")
    print("Project board and governance summaries synchronized atomically.")
    print(f"Backup: {backup_root.relative_to(VAULT_ROOT)}")
    for warning in unique(warnings + discovery_warnings):
        print(f"Warning: {warning}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
