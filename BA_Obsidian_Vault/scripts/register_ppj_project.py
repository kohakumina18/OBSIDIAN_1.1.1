#!/usr/bin/env python3
"""Atomically register one PPJ project and its lifecycle-driven workspace.

Dry-run is the default. Apply requires complete registration metadata, creates
backups, stages every file, validates the staged state, and rolls back on error.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import sys
import tempfile
from datetime import date, datetime
from pathlib import Path

from sync_ppj_project_boards import load_local_tasks
from upgrade_ppj_project_workspaces import (
    COMMAND_CENTER,
    GLOBAL_CANVAS,
    LEDGER_PATH,
    MEMORY_INDEX_PATH,
    MEMORY_ROOT,
    PROJECT_ROOT,
    REGISTRY_PATH,
    VAULT_ROOT,
    WORKSPACE_DIRECTORIES,
    Project,
    active_documents,
    build_project_board,
    classify_lifecycle,
    command_center_workspace_block,
    detect_project_types,
    discover_projects,
    identity_key,
    read_text,
    registry_workspace_block,
    render_document,
    replace_managed_block,
    unique,
    validate_project_board,
    yaml_quote,
)

TODAY = date.today().isoformat()
MODULE_INDEX = PROJECT_ROOT / "_Registry" / "PPJ_PROJECT_MODULE_INDEX.md"
ALIAS_MAP = PROJECT_ROOT / "_Registry" / "PPJ_PROJECT_ALIAS_MAP.md"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Register one canonical PPJ project")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Plan only; default")
    mode.add_argument("--apply", action="store_true", help="Apply after explicit approval")
    parser.add_argument("--force", action="store_true", help="Allow non-exact alias warnings; never overwrites an existing project")
    parser.add_argument("--project-name", required=True)
    parser.add_argument("--department", required=True)
    parser.add_argument("--object", required=True)
    parser.add_argument("--characteristic", required=True)
    parser.add_argument("--version", default="")
    parser.add_argument("--cluster", required=True)
    parser.add_argument("--phase", required=True)
    parser.add_argument("--priority", required=True)
    parser.add_argument("--outcome", required=True)
    parser.add_argument("--business-owner", required=True)
    parser.add_argument("--ba", required=True)
    parser.add_argument("--technical-members", action="append", default=[])
    parser.add_argument("--business-problem", required=True)
    parser.add_argument("--target-users", required=True)
    parser.add_argument("--source-data", required=True)
    parser.add_argument("--next-action", required=True)
    parser.add_argument("--create-canvas-card", action="store_true")
    return parser.parse_args()


def safe_basename(value: str) -> str:
    value = re.sub(r'[\\/:*?"<>|]+', "-", value.strip())
    value = re.sub(r"\s+", ".", value)
    value = re.sub(r"\.{2,}", ".", value).strip(".-")
    if not value:
        raise ValueError("Project name does not produce a safe filename")
    return value


def clean_cell(value: str) -> str:
    return re.sub(r"\s+", " ", value).strip().replace("|", "/")


def append_before_marker(text: str, row: str, marker: str) -> str:
    if row in text:
        return text
    if marker in text:
        before, after = text.split(marker, 1)
        return before.rstrip() + "\n" + row + "\n\n" + marker + after
    return text.rstrip() + "\n" + row + "\n"


def registered_projects_block(existing: str, row: str) -> str:
    start = "<!-- PPJ_REGISTERED_PROJECTS_START -->"
    end = "<!-- PPJ_REGISTERED_PROJECTS_END -->"
    match = re.search(re.escape(start) + r"(.*?)" + re.escape(end), existing, re.S)
    rows: list[str] = []
    if match:
        rows = [line for line in match.group(1).splitlines() if line.startswith("|")][2:]
    if row not in rows:
        rows.append(row)
    content = "\n".join(
        [
            "## Registered Project Additions",
            "",
            "| Project Name | Canonical Filename | Phase | Cluster / Portfolio Group | BA / Coordination | Technical Members | Department | Status / Priority | Progress | Blocker | Decision Needed | Next Action | Related Deliverable | Related System | Source File | Data Quality Score | Notes |",
            "| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---: | --- |",
            *rows,
        ]
    )
    return replace_managed_block(existing, start, end, content)


def module_index_block(existing: str, project_name: str) -> str:
    start = "<!-- PPJ_REGISTERED_PROJECT_MODULES_START -->"
    end = "<!-- PPJ_REGISTERED_PROJECT_MODULES_END -->"
    match = re.search(re.escape(start) + r"(.*?)" + re.escape(end), existing, re.S)
    links = []
    if match:
        links = re.findall(r"(?m)^- \[\[([^\]]+)\]\]$", match.group(1))
    if project_name not in links:
        links.append(project_name)
    content = "## Registered Projects\n\n" + "\n".join(f"- [[{item}]]" for item in sorted(links, key=str.casefold))
    return replace_managed_block(existing, start, end, content)


def add_canvas_card(canvas_text: str, project: Project) -> str:
    canvas = json.loads(canvas_text)
    nodes = canvas.setdefault("nodes", [])
    project_file = project.note_path.relative_to(VAULT_ROOT).as_posix()
    if any(node.get("type") == "file" and node.get("file") == project_file for node in nodes):
        return canvas_text
    numeric_x = [node.get("x", 0) for node in nodes if isinstance(node.get("x", 0), (int, float))]
    x = int(max(numeric_x, default=0)) + 420
    node_id = "ppj-project-" + hashlib.sha1(project.code.encode("utf-8")).hexdigest()[:12]
    nodes.append(
        {
            "id": node_id,
            "type": "file",
            "file": project_file,
            "x": x,
            "y": 0,
            "width": 340,
            "height": 120,
        }
    )
    nodes.append(
        {
            "id": node_id + "-board",
            "type": "text",
            "text": f"Project Board: [[03_Projects/{project.folder_name}/Project_Executive_Board]]",
            "x": x,
            "y": 124,
            "width": 340,
            "height": 34,
            "color": "6",
        }
    )
    return json.dumps(canvas, ensure_ascii=False, indent=2).rstrip() + "\n"


def project_note(args: argparse.Namespace, code: str, source_event: str) -> str:
    technical = json.dumps(args.technical_members, ensure_ascii=False)
    return f"""---
type: project
project_name: {yaml_quote(args.project_name)}
project_code: {yaml_quote(code)}
canonical_code: {yaml_quote(code)}
current_file: {yaml_quote(code + '.md')}
department: {yaml_quote(args.department)}
object: {yaml_quote(args.object)}
project_characteristic: {yaml_quote(args.characteristic)}
version: {yaml_quote(args.version)}
phase: {yaml_quote(args.phase)}
lifecycle: {yaml_quote(args.phase)}
cluster: {yaml_quote(args.cluster)}
priority: {yaml_quote(args.priority)}
business_owner: {yaml_quote(args.business_owner)}
ba_coordination: {yaml_quote(args.ba)}
technical_members: {technical}
status: "Registered"
last_updated: {yaml_quote(TODAY)}
last_verified: {yaml_quote(TODAY)}
source_event: {yaml_quote(source_event)}
confidence: "Needs Confirmation"
---

# {args.project_name}

<!-- PPJ_PROJECT_KNOWLEDGE_START -->
## Business Problem

{args.business_problem}

## Business Outcome

{args.outcome}

## Target Users

{args.target_users}

## Systems / Data

{args.source_data}

## Next Action

{args.next_action}

## Workspace

- [[{code}/00_Project_Home|Project Workspace]]
- [[{code}/Project_Executive_Board|Project Executive Board]]
<!-- PPJ_PROJECT_KNOWLEDGE_END -->
"""


def memory_card(args: argparse.Namespace, code: str, source_event: str) -> str:
    return f"""---
type: project_memory
project_name: {yaml_quote(args.project_name)}
project_file: {yaml_quote(code + '.md')}
project_code: {yaml_quote(code)}
department: {yaml_quote(args.department)}
cluster: {yaml_quote(args.cluster)}
phase: {yaml_quote(args.phase)}
status: "Registered"
priority: {yaml_quote(args.priority)}
business_owner: {yaml_quote(args.business_owner)}
ba_coordination: [{yaml_quote(args.ba)}]
technical_members: {json.dumps(args.technical_members, ensure_ascii=False)}
stakeholders: []
systems: []
data_sources: [{yaml_quote(args.source_data)}]
last_verified: {yaml_quote(TODAY)}
confidence: "Needs Confirmation"
workspace_path: {yaml_quote('03_Projects/' + code)}
project_home: {yaml_quote('03_Projects/' + code + '/00_Project_Home.md')}
project_board: {yaml_quote('03_Projects/' + code + '/Project_Executive_Board.canvas')}
task_folder: {yaml_quote('03_Projects/' + code + '/Tasks')}
documentation_status: "Workspace Created"
source_event: {yaml_quote(source_event)}
---

# Project Memory: {args.project_name}

## One-Line Understanding

{args.department} project for {args.object}: {args.characteristic}.

## Business Meaning

{args.business_problem}

## Outcome

{args.outcome}

## What This Project Is

{args.characteristic}

## What This Project Is Not

Not a replacement or merger of another canonical project unless separately approved.

## Key Users

{args.target_users}

## Systems / Data

{args.source_data}

## Current Phase / Status

{args.phase} / Registered

## Known Risks

Needs Confirmation

## Decisions Needed

Confirm scope, ownership, source-of-truth and lifecycle gate.

## Next Actions

{args.next_action}

## Do Not Drift Rules

- Do not invent owners, systems, tables, dates, rules or implementation status.
- Do not merge or rename this project without approval.

## Source Links

- [[{code}]]
- [[03_Projects/{code}/00_Project_Home|Project Workspace]]
"""


def build_project(args: argparse.Namespace, code: str, note_path: Path, memory_path: Path, source_event: str) -> Project:
    lifecycle_class = classify_lifecycle(args.phase, "Registration / Business Discovery")
    understanding = f"{args.department} project for {args.object}: {args.characteristic}."
    project = Project(
        code=code,
        note_path=note_path,
        memory_path=memory_path,
        folder=PROJECT_ROOT / code,
        primary_domain=args.department,
        secondary_domains=args.cluster,
        lifecycle=args.phase,
        progress="Not Started",
        current_gate="Registration / Business Discovery",
        priority=args.priority,
        business_owner=args.business_owner,
        primary_users=args.target_users,
        ba_coordination=[args.ba],
        technical_members=args.technical_members,
        cluster=args.cluster,
        understanding=understanding,
        outcome=args.outcome,
        latest_update="Project registered; business discovery and source confirmation are pending.",
        scope=[args.object, args.characteristic],
        out_of_scope=["Unapproved expansion or merger with another canonical project"],
        risks=["Scope, rules, data ownership and acceptance require confirmation."],
        blockers=["Needs Confirmation"],
        decisions=["Confirm business rules, source of truth and delivery ownership."],
        actions=[args.next_action],
        dependencies=[args.source_data],
        systems=[],
        data_sources=[args.source_data],
        confidence="Needs Confirmation",
        last_verified=TODAY,
        source_event=source_event,
        lifecycle_class=lifecycle_class,
        project_types=[],
        aliases={identity_key(code), identity_key(args.project_name), identity_key(note_path.name)},
    )
    project.project_types = detect_project_types(code, args.cluster, understanding, lifecycle_class)
    return project


def stage_and_commit(changes: dict[Path, str], project_folder: Path, backup_root: Path) -> None:
    existing_backups: dict[Path, Path] = {}
    committed: list[Path] = []
    project_folder_existed = project_folder.exists()
    staging_parent = VAULT_ROOT / "99_Attachments" / "Audit"
    staging_parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=".ppj-register-", dir=staging_parent) as temp_name:
        temp_root = Path(temp_name)
        staged: dict[Path, Path] = {}
        for target, content in changes.items():
            relative = target.relative_to(VAULT_ROOT)
            staged_path = temp_root / relative
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
                    existing_backups[target] = backup
            for directory in WORKSPACE_DIRECTORIES:
                (project_folder / directory).mkdir(parents=True, exist_ok=True)
            for target, staged_path in staged.items():
                target.parent.mkdir(parents=True, exist_ok=True)
                os.replace(staged_path, target)
                committed.append(target)
        except Exception:
            for target in reversed(committed):
                backup = existing_backups.get(target)
                if backup and backup.exists():
                    shutil.copy2(backup, target)
                elif target.exists():
                    target.unlink()
            if not project_folder_existed and project_folder.exists():
                shutil.rmtree(project_folder)
            raise


def main() -> int:
    args = parse_args()
    code = safe_basename(args.project_name)
    if args.version and args.version.casefold() not in code.casefold():
        code = f"{code}.{safe_basename(args.version)}"
    note_path = PROJECT_ROOT / f"{code}.md"
    memory_path = MEMORY_ROOT / f"{code}.memory.md"
    project_folder = PROJECT_ROOT / code
    exact_conflicts = [path for path in [note_path, memory_path, project_folder] if path.exists()]
    searchable = "\n".join(read_text(path) for path in [MEMORY_INDEX_PATH, REGISTRY_PATH, ALIAS_MAP])
    alias_warning = identity_key(code) in identity_key(searchable)
    hard_stops: list[str] = []
    if exact_conflicts:
        hard_stops.append("Existing canonical assets: " + ", ".join(str(path.relative_to(VAULT_ROOT)) for path in exact_conflicts))
    if alias_warning and not args.force:
        hard_stops.append("Canonical name or alias already appears in memory/index/registry")
    required_sources = [MEMORY_INDEX_PATH, REGISTRY_PATH, MODULE_INDEX, COMMAND_CENTER, GLOBAL_CANVAS, LEDGER_PATH]
    missing_sources = [path for path in required_sources if not path.exists()]
    if missing_sources:
        hard_stops.append("Missing governance sources: " + ", ".join(str(path.relative_to(VAULT_ROOT)) for path in missing_sources))

    source_event = f"PPJ-PROJECT-REGISTRATION-{code}-{TODAY.replace('-', '')}"
    project = build_project(args, code, note_path, memory_path, source_event)
    active = active_documents(project)
    files_to_create = [note_path, memory_path, project_folder / "Project_Executive_Board.canvas"] + [project_folder / item for item in active]
    files_to_update = [MEMORY_INDEX_PATH, REGISTRY_PATH, MODULE_INDEX, COMMAND_CENTER, LEDGER_PATH]
    if args.create_canvas_card:
        files_to_update.append(GLOBAL_CANVAS)

    print("PPJ Project Registration")
    print(f"Mode: {'Apply' if args.apply else 'DryRun'}")
    print(f"Project: {project.code}")
    print(f"Lifecycle class: {project.lifecycle_class}")
    print(f"Lifecycle-activated documents: {len(active)}")
    print("Files to create:")
    for path in files_to_create:
        print(f" - {path.relative_to(VAULT_ROOT)}")
    print("Files to update:")
    for path in files_to_update:
        print(f" - {path.relative_to(VAULT_ROOT)}")
    print("Hard stops:")
    for item in hard_stops or ["None"]:
        print(f" - {item}")
    if not args.apply:
        print("DryRun only. No files were modified.")
        return 0 if not hard_stops else 2
    if hard_stops:
        print("Apply refused because hard stops exist.", file=sys.stderr)
        return 2

    existing_projects, discovery_stops, discovery_warnings = discover_projects(None)
    if discovery_stops:
        print("Apply refused because existing portfolio discovery has hard stops:", file=sys.stderr)
        for item in discovery_stops:
            print(f" - {item}", file=sys.stderr)
        return 2
    for existing in existing_projects:
        tasks, task_warnings = load_local_tasks(existing)
        existing.tasks = tasks
        discovery_warnings.extend(task_warnings)
    all_projects = sorted(existing_projects + [project], key=lambda item: item.code.casefold())

    index_row = (
        f"| [[{code}]] | [[{code}.memory]] | [[{code}]] | {clean_cell(args.cluster)} | "
        f"{clean_cell(args.phase)} | {clean_cell(args.priority)} | {clean_cell(project.understanding)} | "
        f"{clean_cell(args.outcome)} | Registered as new project | Needs Confirmation | {TODAY} |"
    )
    registry_row = (
        f"| {clean_cell(project.code)} | {clean_cell(note_path.name)} | {clean_cell(args.phase)} | "
        f"{clean_cell(args.cluster)} | {clean_cell(args.ba)} | {clean_cell(', '.join(args.technical_members) or 'Needs Confirmation')} | "
        f"{clean_cell(args.department)} | Registered / {clean_cell(args.priority)} | Not Started | Needs Confirmation | "
        f"Confirm business rules and source of truth | {clean_cell(args.next_action)} | TBD | {clean_cell(args.source_data)} | "
        f"{clean_cell(note_path.name)} | 60 | Registered; discovery pending |"
    )
    registry_content = registered_projects_block(read_text(REGISTRY_PATH), registry_row)
    registry_content = replace_managed_block(
        registry_content,
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
        f"| {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} | {clean_cell(project.code)} | project_registration | "
        f"Registered canonical project and lifecycle-driven workspace. | registration_status | none | Registered | "
        f"{source_event} | Needs Confirmation | project note / memory / registry / workspace / local board | {clean_cell(args.next_action)} |"
    )
    changes: dict[Path, str] = {
        note_path: project_note(args, code, source_event),
        memory_path: memory_card(args, code, source_event),
        MEMORY_INDEX_PATH: append_before_marker(
            read_text(MEMORY_INDEX_PATH), index_row, "<!-- PPJ_DOMAIN_MEMORY_INDEX_OVERLAY_START -->"
        ),
        REGISTRY_PATH: registry_content,
        MODULE_INDEX: module_index_block(read_text(MODULE_INDEX), code),
        COMMAND_CENTER: command_content,
        LEDGER_PATH: read_text(LEDGER_PATH).rstrip() + "\n" + ledger_row,
    }
    for relative_path in active:
        changes[project_folder / relative_path] = render_document(project, relative_path)
    board = build_project_board(project, [])
    validate_project_board(board)
    changes[project_folder / "Project_Executive_Board.canvas"] = json.dumps(board, ensure_ascii=False, indent=2)
    if args.create_canvas_card:
        changes[GLOBAL_CANVAS] = add_canvas_card(read_text(GLOBAL_CANVAS), project)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    backup_root = VAULT_ROOT / "99_Attachments" / "Audit" / "Project_Registration_Backup" / timestamp
    try:
        stage_and_commit(changes, project_folder, backup_root)
    except Exception as exc:
        print(f"Apply failed and was rolled back: {exc}", file=sys.stderr)
        return 1
    print(f"Project registered: {project.code}")
    print(f"Backup: {backup_root.relative_to(VAULT_ROOT)}")
    for warning in unique(discovery_warnings):
        print(f"Warning: {warning}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
