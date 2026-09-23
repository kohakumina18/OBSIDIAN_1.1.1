#!/usr/bin/env python3
"""Synchronize PPJ delivery_stream/stage between Executive Canvas and vault.

Default mode is dry-run. A Canvas-to-vault apply is intentionally explicit and
reopening CLOSED additionally requires --approve-reopen or --force.
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import re
import sys
from pathlib import Path
from typing import Any

import ppj_canvas_state_lib as lib


SYNC_START = "<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_START -->"
SYNC_END = "<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_END -->"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    direction = parser.add_mutually_exclusive_group(required=True)
    direction.add_argument("--from-canvas", action="store_true", help="Treat saved card geometry as proposed delivery_stream and delivery_stage")
    direction.add_argument("--to-canvas", action="store_true", help="Align Canvas with persisted snapshot state")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Preview only (default)")
    mode.add_argument("--apply", action="store_true", help="Back up and write approved changes")
    scope = parser.add_mutually_exclusive_group()
    scope.add_argument("--project", action="append", help="Canonical code; repeat for more than one")
    scope.add_argument("--all", action="store_true", help="Process every registered project (default)")
    parser.add_argument("--force", action="store_true", help="Override protected transition checks")
    parser.add_argument("--approve-reopen", action="store_true", help="Explicitly allow CLOSED -> active transition")
    parser.add_argument("--approve-rename", action="store_true", help="Explicitly allow a canonical code rename typed into a card heading")
    parser.add_argument("--ignore-card-edits", action="store_true", help="Treat card text as display-only and read geometry alone")
    parser.add_argument("--reflow", action="store_true", help="Rebuild and sort the whole Executive Canvas")
    parser.add_argument("--verbose", action="store_true")
    return parser.parse_args()


def json_text(value: dict[str, Any]) -> str:
    return json.dumps(value, ensure_ascii=False, indent=2) + "\n"


def stage(changes: dict[Path, str], path: Path, content: str) -> None:
    old = path.read_text(encoding="utf-8-sig") if path.exists() else None
    if path.suffix == ".canvas" and old is not None and lib.canvas_semantic_equal(old, content):
        return
    if old != content:
        changes[path] = content


def state_block(item: dict[str, Any]) -> str:
    gate = str(item.get("gate", "")).replace("|", "\\|")
    return (
        "## Executive Delivery State\n\n"
        f"| Field | Current |\n|---|---|\n"
        f"| Delivery Stream | {item.get('delivery_stream', '')} |\n"
        f"| Delivery Stage | {item.get('delivery_stage', '')} |\n"
        f"| Detailed Lifecycle | {item.get('lifecycle', '')} |\n"
        f"| Status | {item.get('status', '')} |\n"
        f"| Current Gate | {gate} |\n"
        f"| Stage Entered | {item.get('stage_entered_date', 'Needs Confirmation')} |\n"
        f"| Last Verified | {item.get('last_verified', '')} |"
    )


def update_note(path: Path, item: dict[str, Any], changes: dict[Path, str]) -> None:
    if not path.exists():
        return
    old = path.read_text(encoding="utf-8-sig")
    new = lib.update_frontmatter(old, {
        "phase": item["delivery_stage"], "delivery_stream": item["delivery_stream"], "delivery_stage": item["delivery_stage"],
        "lifecycle": item["lifecycle"], "status": item["status"],
        "current_gate": item.get("gate", "Needs Confirmation"),
        "stage_entered_date": item.get("stage_entered_date", "Needs Confirmation"),
        "last_verified": item["last_verified"], "source_event": item["source_event"],
    })
    new = lib.replace_block(new, SYNC_START, SYNC_END, state_block(item), near_top=True)
    stage(changes, path, new)


def project_paths(item: dict[str, Any]) -> list[Path]:
    paths: list[Path] = []
    root = item.get("root_file")
    memory = item.get("memory_file")
    workspace = item.get("workspace")
    if memory:
        paths.append(lib.ROOT / "03_Projects/_Registry/Project_Memory" / memory)
    if root:
        paths.append(lib.ROOT / "03_Projects" / root)
    if workspace:
        base = lib.ROOT / "03_Projects" / workspace
        paths.extend(base / rel for rel in (
            "00_Project_Home.md", "01_Management/Project_Profile.md",
            "01_Management/Project_Plan.md", "01_Management/Milestones.md",
            "01_Management/Weekly_Status.md", "10_Governance/Change_Log.md",
        ))
    return paths


def update_change_log(path: Path, item: dict[str, Any], move: dict[str, str], changes: dict[Path, str]) -> None:
    if not path.exists():
        return
    old = changes.get(path, path.read_text(encoding="utf-8-sig"))
    event = item["source_event"]
    if event in old:
        return
    row = (f"- {item['last_verified']} | `{event}` | Delivery Stream: {move['old_stream']} -> {move['new_stream']}; "
           f"Delivery Stage: {move['old']} -> {move['new']} | {move['kind']} | Source: Executive Canvas geometry.")
    stage(changes, path, old.rstrip() + "\n\n" + row + "\n")


def update_local_board(path: Path, item: dict[str, Any], changes: dict[Path, str]) -> None:
    if not path.exists():
        return
    try:
        doc = json.loads(path.read_text(encoding="utf-8-sig"))
    except json.JSONDecodeError:
        return
    summary = next((x for x in doc.get("nodes", []) if x.get("id") == "summary"), None)
    if not summary:
        return
    text = str(summary.get("text", ""))
    fields = {
        "Delivery Stream": item["delivery_stream"],
        "Delivery Stage": item["delivery_stage"], "Lifecycle": item["lifecycle"],
        "Status": item["status"], "Gate": item.get("gate", "Needs Confirmation"),
        "Last Verified": item["last_verified"],
    }
    for label, value in fields.items():
        if re.search(rf"(?m)^{re.escape(label)}:", text):
            text = re.sub(rf"(?m)^{re.escape(label)}:.*$", f"{label}: {value}", text)
        else:
            text += f"\n{label}: {value}"
    summary["text"] = text
    stage(changes, path, json_text(doc))


def update_view_canvas(path: Path, projects: dict[str, dict[str, Any]], changes: dict[Path, str]) -> None:
    if not path.exists():
        return
    try:
        doc = json.loads(path.read_text(encoding="utf-8-sig"))
    except json.JSONDecodeError:
        return
    touched = False
    for node in doc.get("nodes", []):
        match = lib.VIEW_MARKER.search(str(node.get("text", "")))
        if not match or match.group(1).strip() not in projects:
            continue
        item = projects[match.group(1).strip()]
        text = str(node["text"])
        for label, value in (("Delivery Stream", item["delivery_stream"]), ("Delivery Stage", item["delivery_stage"]), ("Lifecycle", item["lifecycle"]), ("Status", item["status"]), ("Gate", item.get("gate", ""))):
            text = re.sub(rf"(?m)^{re.escape(label)}:.*$", f"{label}: {value}", text)
        if text != node["text"]:
            node["text"] = text
            touched = True
    if touched:
        stage(changes, path, json_text(doc))


def roadmap_canvas(snapshot: dict[str, Any], config: dict[str, Any]) -> str:
    nodes = []
    projects = lib.registered_projects(snapshot)
    index = 0
    for row, stream in enumerate(lib.stream_names(config)):
        for col, name in enumerate(lib.stage_names(config)):
            values = [f"{x['code']} | {x.get('lifecycle')} | {x.get('status')} | {x.get('gate')}" for x in projects if x.get("delivery_stream") == stream and x.get("delivery_stage") == name]
            values = values or ["No current registered project"]
            nodes.append({"id": f"road-{index}", "type": "text", "text": f"## {stream} / {name}\n\n" + "\n".join(f"- {x}" for x in values), "x": col * 660, "y": row * 1800, "width": 600, "height": max(420, 120 + len(values) * 90)})
            index += 1
    return json_text({"nodes": nodes, "edges": []})


def align_existing_canvas(canvas: dict[str, Any], snapshot: dict[str, Any], config: dict[str, Any], scope: set[str]) -> dict[str, Any]:
    resolution = lib.resolve_canvas(canvas, config, snapshot)
    if resolution["errors"]:
        return lib.render_executive_canvas(snapshot, config)
    projects = {x["code"]: x for x in lib.registered_projects(snapshot)}
    groups = resolution["groups"]
    cards = resolution["cards"]
    # Existing valid board: retain manual layout unless a card must change lane.
    occupied: dict[str, list[tuple[float, float]]] = {x: [] for x in groups}
    for code, card in cards.items():
        current_stage = resolution["assignments"][code]
        current_stream = resolution["stream_assignments"][code]
        current_key = lib.group_key(current_stream, current_stage)
        if code not in scope or (projects[code]["delivery_stage"] == current_stage and projects[code]["delivery_stream"] == current_stream):
            occupied[current_key].append((float(card["y"]), float(card["y"]) + float(card["height"])))
    for code, item in projects.items():
        if code not in scope:
            continue
        card = cards[code]
        target_stage = item["delivery_stage"]
        target_stream = item["delivery_stream"]
        target_key = lib.group_key(target_stream, target_stage)
        card["text"] = lib.project_card_text(item)
        card["id"] = lib.stable_project_id(code)
        if resolution["assignments"][code] == target_stage and resolution["stream_assignments"][code] == target_stream:
            continue
        group = groups[target_key]
        height = float(card.get("height", 310))
        y = float(group["y"]) + 185
        while any(not (y + height + 20 <= a or y >= b + 20) for a, b in occupied[target_key]):
            y += height + 30
        card["x"] = float(group["x"]) + 30
        card["y"] = y
        occupied[target_key].append((y, y + height))
        group["height"] = max(float(group["height"]), y + height + 40 - float(group["y"]))
    # Refresh status-reference panel without introducing duplicate project markers.
    ref = next((x for x in canvas.get("nodes", []) if x.get("id") == "ppj-side-attention-note"), None)
    if ref:
        attention = [x for x in projects.values() if x.get("status") in ("On Hold", "Blocked", "Waiting", "Pending Decision", "External Collaboration")]
        ref["text"] = "## Status overlays\n\n" + "\n".join(f"- {x['code']}: {x.get('status')} | Stream: {x.get('delivery_stream')} | Stage: {x.get('delivery_stage')} | Gate: {x.get('gate')}" for x in attention) + "\n\nThese are attention references, not duplicate project cards."
    return canvas


# A canonical code is a distinctive token, so it is matched on word boundaries
# rather than as a loose substring: LOG_X_v1.2.0 must not also rewrite
# LOG_X_v1.2.01. A trailing "." is allowed so a code ending a sentence matches.
def rewrite_codes(value: Any, rename_map: dict[str, str]) -> Any:
    if isinstance(value, str):
        for old, new in rename_map.items():
            value = re.sub(rf"(?<![A-Za-z0-9_]){re.escape(old)}(?![A-Za-z0-9_])", new, value)
        return value
    if isinstance(value, list):
        return [rewrite_codes(x, rename_map) for x in value]
    if isinstance(value, dict):
        return {k: rewrite_codes(v, rename_map) for k, v in value.items()}
    return value


# Append-only history. Rewriting a code here would falsify the record of the
# rename itself - the ledger row reads "old -> new" and both sides must survive.
RENAME_EXEMPT = ("PPJ_PROJECT_UPDATE_LEDGER.md", "Change_Log.md")


def rewrite_code_references(rename_map: dict[str, str], changes: dict[Path, str]) -> None:
    """Carry a rename across the project system of record.

    The overlay blocks inside the registry are rebuilt from the snapshot, but
    the rest of 03_Projects is not: static registry rows (alias map, naming
    dictionary, domain model), workspace documents, task notes and the other
    portfolio canvases all hold the code as plain text and would otherwise keep
    pointing at the retired one.

    The sweep stops at 03_Projects on purpose. Daily notes, meeting notes,
    decision logs and reports record what was true when they were written;
    rewriting a code there would falsify the account rather than update it.
    """
    if not rename_map:
        return
    targets: set[Path] = {x for x in changes if x.suffix in (".md", ".json", ".canvas")}
    for pattern in ("03_Projects/**/*.md", "03_Projects/**/*.canvas", "03_Projects/**/*.json"):
        targets.update(lib.ROOT.glob(pattern))
    for path in sorted(targets):
        if path.name in RENAME_EXEMPT:
            continue
        text = changes.get(path)
        if text is None:
            if not path.exists():
                continue
            text = path.read_text(encoding="utf-8-sig")
        # JSON and Canvas files are rewritten through the parsed document, not
        # as raw text: in the file a newline inside a string is the two
        # characters \ and n, so a word-boundary match would see the "n" as the
        # preceding character and skip a code that starts a line.
        if path.suffix in (".json", ".canvas"):
            try:
                document = json.loads(text)
            except json.JSONDecodeError:
                continue
            updated = rewrite_codes(document, rename_map)
            rewritten = text if updated == document else json_text(updated)
        else:
            rewritten = rewrite_codes(text, rename_map)
        if rewritten != text:
            stage(changes, path, rewritten)


def update_field_change_log(path: Path, item: dict[str, Any], edits: list[dict[str, str]], changes: dict[Path, str]) -> None:
    if not path.exists():
        return
    old = changes.get(path, path.read_text(encoding="utf-8-sig"))
    event = item["source_event"]
    detail = "; ".join(f"{x['field']}: {x['old'] or '(empty)'} -> {x['new']}" for x in edits)
    row = (f"- {item['last_verified']} | `{event}` | {detail} | card-edit | "
           f"Source: Executive Canvas card text.")
    if row in old:
        return
    stage(changes, path, old.rstrip() + "\n\n" + row + "\n")


def persist_transitions(
    snapshot: dict[str, Any],
    config: dict[str, Any],
    transitions: list[dict[str, str]],
    canvas: dict[str, Any],
    field_edits: list[dict[str, str]] | None = None,
    renames: list[dict[str, str]] | None = None,
) -> dict[Path, str]:
    changes: dict[Path, str] = {}
    today = dt.date.today().isoformat()
    stamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    event = f"PPJ-EXECUTIVE-CANVAS-SYNC-{stamp}"
    by_code = {x["code"]: x for x in snapshot["projects"]}
    field_edits = field_edits or []
    renames = renames or []
    touched: dict[str, dict[str, Any]] = {}

    # Typed card facts are applied before geometry. Where a stage change makes a
    # typed lifecycle/status impossible, the geometry invariants below correct
    # it - position stays the stronger signal, as elsewhere in this model.
    edits_by_code: dict[str, list[dict[str, str]]] = {}
    for edit in field_edits:
        item = by_code[edit["code"]]
        item[edit["field"]] = edit["new"]
        item["last_verified"] = today
        item["source_event"] = event
        edits_by_code.setdefault(edit["code"], []).append(edit)
        touched[edit["code"]] = item

    for move in transitions:
        item = by_code[move["code"]]
        old_stage, new_stage = move["old"], move["new"]
        old_stream, new_stream = move["old_stream"], move["new_stream"]
        item["delivery_stream"] = new_stream
        item["delivery_stage"] = new_stage
        item["stage_entered_date"] = today
        item["last_verified"] = today
        item["source_event"] = event
        if new_stage == "CLOSED":
            item["lifecycle"], item["status"] = "Closed", "Closed"
        elif old_stage == "CLOSED":
            item["lifecycle"], item["status"] = lib.default_lifecycle(new_stage), "Active"
        elif not lib.lifecycle_compatible(str(item.get("lifecycle", "")), new_stage):
            item["lifecycle"] = lib.default_lifecycle(new_stage)
        if new_stream == "EXTERNAL DEVELOPMENT":
            item["status"] = "External Collaboration"
        elif old_stream == "EXTERNAL DEVELOPMENT" and item.get("status") == "External Collaboration":
            item["status"] = "On Hold" if "on hold" in str(item.get("lifecycle", "")).lower() else "Active"
        touched[move["code"]] = item
        workspace = item.get("workspace")
        if workspace:
            update_change_log(lib.ROOT / "03_Projects" / workspace / "10_Governance/Change_Log.md", item, move, changes)

    # A canonical code rename only rewrites the snapshot identity. Every derived
    # artefact - card marker, registry overlays, note frontmatter - is
    # regenerated from it further down. Files and folders named after the old
    # code are left alone and reported instead; renaming those is a separate,
    # link-breaking operation.
    rename_map: dict[str, str] = {}
    for rename in renames:
        item = by_code[rename["code"]]
        item["code"] = rename["new_code"]
        item["last_verified"] = today
        item["source_event"] = event
        rename_map[rename["code"]] = rename["new_code"]
        touched[rename["code"]] = item
    if rename_map:
        # Mutate each project in place so `by_code` and `touched` keep pointing
        # at the same objects; `code` is already correct and must not be
        # rewritten a second time.
        for project in snapshot["projects"]:
            for key, value in list(project.items()):
                if key != "code":
                    project[key] = rewrite_codes(value, rename_map)

    for code, item in touched.items():
        for path in project_paths(item):
            update_note(path, item, changes)
        workspace = item.get("workspace")
        if workspace:
            base = lib.ROOT / "03_Projects" / workspace
            update_local_board(base / "Project_Executive_Board.canvas", item, changes)
            if code in edits_by_code:
                update_field_change_log(base / "10_Governance/Change_Log.md", item, edits_by_code[code], changes)

    snapshot["last_verified"] = today
    snapshot["source_event"] = event
    stage(changes, lib.SNAPSHOT_JSON, json_text(snapshot))
    stage(changes, lib.SNAPSHOT_MD, lib.snapshot_markdown(snapshot))
    overlay = lib.stage_overlay(lib.registered_projects(snapshot))
    for name in ("PPJ_PROJECT_REGISTRY.md", "PPJ_PROJECT_MEMORY_INDEX.md", "PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md"):
        path = lib.ROOT / "03_Projects/_Registry" / name
        old = path.read_text(encoding="utf-8-sig")
        stage(changes, path, lib.replace_block(old, SYNC_START, SYNC_END, overlay, near_top=True))
    command = lib.ROOT / "03_Projects/PROJECT_COMMAND_CENTER.md"
    old = command.read_text(encoding="utf-8-sig")
    stage(changes, command, lib.replace_block(old, SYNC_START, SYNC_END, overlay, near_top=True))

    # Preserve the user's just-saved geometry; refresh only card state text.
    # A renamed card still carries its old marker here, so it is resolved
    # through rename_map - otherwise the card would keep the stale code and the
    # next run would read the rename all over again.
    projects = {x["code"]: x for x in lib.registered_projects(snapshot)}
    for node in canvas.get("nodes", []):
        marker = lib.PROJECT_MARKER.search(str(node.get("text", "")))
        if not marker:
            continue
        code = rename_map.get(marker.group(1).strip(), marker.group(1).strip())
        if code in projects:
            node["text"] = lib.project_card_text(projects[code])
    stage(changes, lib.CANVAS_PATH, json_text(canvas))
    for name in ("PPJ_Portfolio.canvas", "PPJ_Domain_Encapsulation.canvas"):
        update_view_canvas(lib.ROOT / "03_Projects/Canvas" / name, projects, changes)
    stage(changes, lib.ROOT / "03_Projects/Canvas/PPJ_Roadmap_2026.canvas", roadmap_canvas(snapshot, config))

    # Before the ledger rows are appended, so the "old -> new" record they carry
    # is not itself rewritten.
    rewrite_code_references(rename_map, changes)

    ledger = lib.ROOT / "03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md"
    old = ledger.read_text(encoding="utf-8-sig")
    rows = [f"| {today} | {x['code']} | delivery_stream / delivery_stage | {x['old_stream']} / {x['old']} -> {x['new_stream']} / {x['new']} | {x['kind']} | Executive Canvas geometry | {event} | Strong | Registry / notes / boards / canvases | Validate next gate and status. |" for x in transitions]
    rows += [f"| {today} | {rename_map.get(x['code'], x['code'])} | {x['field']} | {x['old'] or '(empty)'} -> {x['new']} | card-edit | Executive Canvas card text | {event} | Strong | Registry / notes / boards / canvases | Confirm the typed value is correct. |" for x in field_edits]
    rows += [f"| {today} | {x['new_code']} | code | {x['code']} -> {x['new_code']} | rename | Executive Canvas card heading | {event} | Strong | Registry / notes / boards / canvases | Files and folders still carry the old code; rename them separately if required. |" for x in renames]
    stage(changes, ledger, old.rstrip() + "\n" + "\n".join(rows) + "\n")
    return changes


def write_audit(args: argparse.Namespace, direction: str, transitions: list[dict[str, str]], errors: list[str], changes: dict[Path, str], applied: bool, backups: tuple[Path, Path] | None = None, field_edits: list[dict[str, str]] | None = None, renames: list[dict[str, str]] | None = None) -> Path:
    field_edits = field_edits or []
    renames = renames or []
    stamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    path = lib.AUDIT_ROOT / f"PPJ_EXECUTIVE_CANVAS_SYNC_LOG_{stamp}.md"
    lines = [f"# PPJ Executive Canvas Sync Log - {stamp}", "", f"- Direction: `{direction}`", f"- Mode: `{'APPLY' if applied else 'DRY RUN'}`", f"- Scope: `{', '.join(args.project or ['ALL'])}`", f"- Proposed transitions: {len(transitions)}", f"- Card field edits: {len(field_edits)}", f"- Code renames: {len(renames)}", f"- Files changed: {len(changes)}", f"- Errors/rejections: {len(errors)}"]
    if backups:
        lines += [f"- State backup: `{backups[0].relative_to(lib.ROOT)}`", f"- Canvas backup: `{backups[1].relative_to(lib.ROOT)}`"]
    lines += ["", "## Transitions", ""] + ([f"- `{x['code']}`: `{x['old_stream']} / {x['old']}` -> `{x['new_stream']} / {x['new']}` ({x['kind']})" for x in transitions] or ["- None"])
    lines += ["", "## Card Field Edits", ""] + ([f"- `{x['code']}`.`{x['field']}`: `{x['old'] or '(empty)'}` -> `{x['new']}`" for x in field_edits] or ["- None"])
    lines += ["", "## Code Renames", ""] + ([f"- `{x['code']}` -> `{x['new_code']}` (files and folders keep the old code)" for x in renames] or ["- None"])
    lines += ["", "## Errors / Rejections", ""] + ([f"- {x}" for x in errors] or ["- None"])
    lines += ["", "## Changed Files", ""] + ([f"- `{x.relative_to(lib.ROOT)}`" for x in sorted(changes)] or ["- None"])
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return path


def main() -> int:
    args = parse_args()
    config = lib.load_config()
    snapshot = lib.load_snapshot()
    projects = {x["code"]: x for x in lib.registered_projects(snapshot)}
    scope = set(args.project or projects)
    unknown = sorted(scope - set(projects))
    if unknown:
        print("Unknown/unregistered project: " + ", ".join(unknown), file=sys.stderr)
        return 2
    try:
        canvas = json.loads(lib.CANVAS_PATH.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Cannot read Executive Canvas: {exc}", file=sys.stderr)
        return 2

    transitions: list[dict[str, str]] = []
    field_edits: list[dict[str, str]] = []
    renames: list[dict[str, str]] = []
    errors: list[str] = []
    changes: dict[Path, str] = {}
    direction = "from-canvas" if args.from_canvas else "to-canvas"
    if args.from_canvas:
        resolution = lib.resolve_canvas(canvas, config, snapshot)
        errors.extend(resolution["errors"])
        if not errors:
            stages = lib.stage_names(config)
            for code in sorted(scope):
                old, new = projects[code].get("delivery_stage"), resolution["assignments"].get(code)
                old_stream = projects[code].get("delivery_stream")
                new_stream = resolution["stream_assignments"].get(code)
                if old == new and old_stream == new_stream:
                    continue
                stage_kind = "reopen" if old == "CLOSED" and new != "CLOSED" else lib.transition_kind(old, new, stages)
                kind = stage_kind if old_stream == new_stream else ("stream-change" if stage_kind == "unchanged" else f"stream-change/{stage_kind}")
                if stage_kind == "reopen" and not (args.approve_reopen or args.force):
                    errors.append(f"reopen rejected for {code}; use --approve-reopen after review")
                    continue
                transitions.append({"code": code, "old_stream": old_stream, "new_stream": new_stream, "old": old, "new": new, "kind": kind})
        if not errors and not args.ignore_card_edits:
            for code in sorted(scope):
                card = resolution["cards"].get(code)
                if card is None or lib.card_is_pristine(str(card.get("text", "")), projects[code]):
                    continue
                rename = lib.card_code_rename(str(card.get("text", "")), projects[code])
                if rename:
                    if rename in projects:
                        errors.append(f"rename rejected for {code}: {rename} is already a registered project")
                    elif args.approve_rename or args.force:
                        renames.append({"code": code, "new_code": rename})
                    else:
                        errors.append(f"canonical code rename {code} -> {rename} rejected; use --approve-rename after review")
                for field, value in lib.card_field_edits(str(card.get("text", "")), projects[code]).items():
                    field_edits.append({"code": code, "field": field, "old": " ".join(str(projects[code].get(field, "")).split()), "new": value})
        if not errors and (transitions or field_edits or renames):
            changes = persist_transitions(snapshot, config, transitions, canvas, field_edits, renames)
    else:
        resolution = lib.resolve_canvas(canvas, config, snapshot)
        if args.reflow or resolution["errors"]:
            desired = lib.render_executive_canvas(snapshot, config)
            if resolution["errors"] and args.verbose:
                print("Structural repair: " + "; ".join(resolution["errors"]))
        else:
            desired = align_existing_canvas(canvas, snapshot, config, scope)
        stage(changes, lib.CANVAS_PATH, json_text(desired))

    applied = bool(args.apply and not errors)
    backups = None
    if applied and changes:
        stamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S_%f")
        backups = lib.backup_and_write(changes, stamp)
    audit = write_audit(args, direction, transitions, errors, changes, applied, backups, field_edits, renames)
    print(f"Direction: {direction}")
    print(f"Mode: {'APPLY' if args.apply else 'DRY RUN'}")
    print(f"Transitions: {len(transitions)}")
    for move in transitions:
        print(f"  {move['code']}: {move['old_stream']} / {move['old']} -> {move['new_stream']} / {move['new']} ({move['kind']})")
    print(f"Card field edits: {len(field_edits)}")
    for edit in field_edits:
        print(f"  {edit['code']}.{edit['field']}: {edit['old'] or '(empty)'} -> {edit['new']}")
    print(f"Code renames: {len(renames)}")
    for rename in renames:
        print(f"  {rename['code']} -> {rename['new_code']}")
    print(f"Errors/rejections: {len(errors)}")
    for error in errors:
        print(f"  ERROR: {error}")
    print(f"Files to change: {len(changes)}")
    if args.verbose:
        for path in sorted(changes):
            print(f"  {path.relative_to(lib.ROOT)}")
    print(f"Audit log: {audit.relative_to(lib.ROOT)}")
    if errors:
        print("Safe to Apply: False")
        return 2
    print("Safe to Apply: True")
    if args.apply:
        print(f"Applied files: {len(changes)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
