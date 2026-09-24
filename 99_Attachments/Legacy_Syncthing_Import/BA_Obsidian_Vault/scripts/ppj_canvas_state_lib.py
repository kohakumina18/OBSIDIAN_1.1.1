#!/usr/bin/env python3
"""Shared PPJ Executive Canvas state resolver and persistence helpers."""

from __future__ import annotations

import datetime as dt
import hashlib
import json
import re
import shutil
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
CONFIG_PATH = ROOT / "03_Projects/_Registry/PPJ_EXECUTIVE_CANVAS_STAGE_CONFIG.json"
MANIFEST_PATH = ROOT / "03_Projects/_Registry/PPJ_EXECUTIVE_CANVAS_CONTROL_MANIFEST.md"
CANVAS_PATH = ROOT / "03_Projects/Canvas/PPJ_Executive_Board.canvas"
SNAPSHOT_JSON = ROOT / "03_Projects/_Registry/Portfolio_Snapshots/PPJ_PORTFOLIO_SNAPSHOT_20260824.json"
SNAPSHOT_MD = ROOT / "03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT.md"
AUDIT_ROOT = ROOT / "99_Attachments/Audit"
CANVAS_BACKUP_ROOT = ROOT / "99_Attachments/Canvas_Backup"
STATE_BACKUP_ROOT = AUDIT_ROOT / "PPJ_EXECUTIVE_CANVAS_STATE_SYNC_BACKUP"

PROJECT_MARKER = re.compile(r"<!--\s*PPJ_PROJECT_CARD:([^>]+?)\s*-->")
CANDIDATE_MARKER = re.compile(r"<!--\s*PPJ_CANDIDATE_CARD:([^>]+?)\s*-->")
VIEW_MARKER = re.compile(r"<!--\s*PPJ_PORTFOLIO_VIEW_CARD:([^>]+?)\s*-->")


class StateError(RuntimeError):
    pass


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def load_config() -> dict[str, Any]:
    data = read_json(CONFIG_PATH)
    stages = data.get("stages", [])
    if len(stages) != 8 or len({x["name"] for x in stages}) != 8:
        raise StateError("Stage config must contain exactly eight unique stages")
    streams = data.get("streams", [])
    if len(streams) != 2 or {x.get("name") for x in streams} != {"INTERNAL DEVELOPMENT", "EXTERNAL DEVELOPMENT"}:
        raise StateError("Stage config must contain INTERNAL DEVELOPMENT and EXTERNAL DEVELOPMENT streams")
    expected = {x["name"] for x in stages}
    group_ids: list[str] = []
    for stream in streams:
        if set(stream.get("group_ids", {})) != expected:
            raise StateError(f"Stream {stream.get('name')} must map all eight stages")
        group_ids.extend(stream["group_ids"].values())
    if len(group_ids) != 16 or len(set(group_ids)) != 16:
        raise StateError("The sixteen stream-stage group IDs must be unique")
    return data


def load_snapshot() -> dict[str, Any]:
    data = read_json(SNAPSHOT_JSON)
    if not isinstance(data.get("projects"), list):
        raise StateError("Snapshot JSON has no projects list")
    codes = [x.get("code") for x in data["projects"]]
    if len(codes) != len(set(codes)):
        raise StateError("Snapshot contains duplicate project codes")
    # One-time migration bridge: the 2026-08-24 catalog is the approved source
    # for fields absent from the pre-upgrade snapshot. The next baseline apply
    # persists them, after which this branch is a no-op.
    if any((not x.get("delivery_stage") or not x.get("delivery_stream")) and not x.get("candidate") for x in data["projects"]):
        from apply_ppj_portfolio_snapshot_20260824 import PORTFOLIO
        catalog = {x.code: x for x in PORTFOLIO}
        for item in data["projects"]:
            source = catalog.get(item.get("code"))
            if not source:
                continue
            item.setdefault("delivery_stage", source.delivery_stage)
            item.setdefault("delivery_stream", source.delivery_stream)
            item.setdefault("status", source.status)
            item.setdefault("stage_entered_date", source.stage_entered_date)
    return data


def registered_projects(snapshot: dict[str, Any]) -> list[dict[str, Any]]:
    return [x for x in snapshot["projects"] if not x.get("candidate")]


def stable_project_id(code: str) -> str:
    return "ppj-project-" + hashlib.sha1(code.encode("utf-8")).hexdigest()[:16]


def stage_names(config: dict[str, Any]) -> list[str]:
    return [x["name"] for x in config["stages"]]


def stream_names(config: dict[str, Any]) -> list[str]:
    return [x["name"] for x in config["streams"]]


def group_key(stream: str, stage: str) -> str:
    return f"{stream}|{stage}"


def center_in(node: dict[str, Any], group: dict[str, Any]) -> bool:
    cx = float(node["x"]) + float(node["width"]) / 2
    cy = float(node["y"]) + float(node["height"]) / 2
    return (
        float(group["x"]) <= cx <= float(group["x"]) + float(group["width"])
        and float(group["y"]) <= cy <= float(group["y"]) + float(group["height"])
    )


def resolve_canvas(canvas: dict[str, Any], config: dict[str, Any], snapshot: dict[str, Any]) -> dict[str, Any]:
    nodes = canvas.get("nodes", [])
    by_id = {x.get("id"): x for x in nodes}
    if len(by_id) != len(nodes):
        raise StateError("Canvas contains duplicate node IDs")
    groups: dict[str, dict[str, Any]] = {}
    errors: list[str] = []
    for stream in config["streams"]:
        for stage, group_id in stream["group_ids"].items():
            group = by_id.get(group_id)
            key = group_key(stream["name"], stage)
            if not group or group.get("type") != "group":
                errors.append(f"missing stream-stage group {key} ({group_id})")
            else:
                groups[key] = group

    cards: dict[str, dict[str, Any]] = {}
    for node in nodes:
        marker = PROJECT_MARKER.search(str(node.get("text", "")))
        if not marker:
            continue
        code = marker.group(1).strip()
        if code in cards:
            errors.append(f"duplicate project card marker: {code}")
        cards[code] = node

    expected = {x["code"] for x in registered_projects(snapshot)}
    extra = sorted(set(cards) - expected)
    missing = sorted(expected - set(cards))
    if extra:
        errors.append("unknown project cards: " + ", ".join(extra))
    if missing:
        errors.append("missing project cards: " + ", ".join(missing))

    assignments: dict[str, str] = {}
    stream_assignments: dict[str, str] = {}
    ambiguous: dict[str, list[str]] = {}
    unassigned: list[str] = []
    if len(groups) == 16:
        for code, card in cards.items():
            if code not in expected:
                continue
            hits = [key for key, group in groups.items() if center_in(card, group)]
            if len(hits) == 1:
                stream, stage = hits[0].split("|", 1)
                assignments[code] = stage
                stream_assignments[code] = stream
            elif hits:
                ambiguous[code] = hits
            else:
                unassigned.append(code)
    if ambiguous:
        errors.extend(f"ambiguous card {code}: {', '.join(hits)}" for code, hits in sorted(ambiguous.items()))
    if unassigned:
        errors.append("unassigned cards: " + ", ".join(sorted(unassigned)))
    return {"groups": groups, "cards": cards, "assignments": assignments, "stream_assignments": stream_assignments, "errors": errors}


def root_link(item: dict[str, Any]) -> str:
    root = item.get("root_file")
    if root:
        return f"[[03_Projects/{Path(root).stem}|{item['code']}]]"
    return f"[[07_Decision_Log/DEC-20260824-ADMIN-EXPENSE-DOMAIN|{item['code']}]]"


def project_card_text(item: dict[str, Any]) -> str:
    workspace = item.get("workspace")
    board = f"[[03_Projects/{workspace}/Project_Executive_Board|Local Project Board]]" if workspace else "Needs Confirmation"
    return (
        f"<!-- PPJ_PROJECT_CARD:{item['code']} -->\n\n## {root_link(item)}\n\n"
        f"Domain: {item.get('domain', 'Needs Confirmation')}\n"
        f"Delivery Stream: {item.get('delivery_stream', 'Needs Confirmation')}\n"
        f"Delivery Stage: {item.get('delivery_stage', 'Needs Confirmation')}\n"
        f"Lifecycle: {item.get('lifecycle', 'Needs Confirmation')}\n"
        f"Status: {item.get('status', 'Needs Confirmation')}\n"
        f"Progress: {item.get('progress', 'TBD')}\n"
        f"Priority: {item.get('priority', 'Needs Confirmation')}\n"
        f"Gate: {item.get('gate', 'Needs Confirmation')}\n\n"
        f"Outcome\n- {item.get('outcome', 'Needs Confirmation')}\n\nBoard\n- {board}"
    )


def render_executive_canvas(snapshot: dict[str, Any], config: dict[str, Any]) -> dict[str, Any]:
    stages = stage_names(config)
    streams = stream_names(config)
    registered = registered_projects(snapshot)
    buckets = {(stream, stage): [] for stream in streams for stage in stages}
    for item in registered:
        stage = item.get("delivery_stage")
        stream = item.get("delivery_stream")
        if stage not in stages:
            raise StateError(f"Invalid delivery_stage for {item['code']}: {stage}")
        if stream not in streams:
            raise StateError(f"Invalid delivery_stream for {item['code']}: {stream}")
        buckets[(stream, stage)].append(item)

    def order(item: dict[str, Any]) -> tuple[int, str]:
        match = re.fullmatch(r"P(\d+)", str(item.get("priority", "")))
        return (int(match.group(1)) if match else 99, item["code"])

    definitions = {
        "BACKLOG": "Approved project not yet scheduled for kick-off.",
        "KICK-OFF": "Owner, users, problem, scope and success outcome are being aligned.",
        "ANALYSIS": "Process, rules, data, risks and decisions are being clarified.",
        "DESIGN": "Solution, UX, permissions, data and integration are being designed.",
        "DEVELOPMENT": "Application, automation, data pipeline or AI capability is being built.",
        "UAT / PRE-GO-LIVE": "Business validation, defects, training and readiness review.",
        "GO-LIVE / PRODUCTION / SUPPORT": "Live delivery, rollout, monitoring, support and controlled enhancement.",
        "CLOSED": "Formally completed or closed; history retained, no active delivery.",
    }
    colors = ["6", "5", "3", "5", "4", "2", "4", "1"]
    lane_w, gap_x, card_w, card_h, gap_y = 760, 70, 700, 310, 30
    pipeline_w = len(stages) * lane_w + (len(stages) - 1) * gap_x
    max_internal = max(len(buckets[(streams[0], stage)]) for stage in stages)
    internal_height = max(620, 220 + max_internal * (card_h + gap_y))
    external_base = internal_height + 420
    max_external = max(len(buckets[(streams[1], stage)]) for stage in stages)
    external_height = max(620, 220 + max_external * (card_h + gap_y))
    side_x = pipeline_w + 70
    nodes: list[dict[str, Any]] = [
        {"id": "executive-title", "type": "text", "x": 0, "y": -620, "width": pipeline_w + 830, "height": 250,
         "text": "# PPJ SOFTWARE DELIVERY EXECUTIVE CONTROL\n\nTWO CONTROLLED STREAMS: INTERNAL DEVELOPMENT + EXTERNAL DEVELOPMENT\n\nEach stream follows: BACKLOG -> KICK-OFF -> ANALYSIS -> DESIGN -> DEVELOPMENT -> UAT / PRE-GO-LIVE -> GO-LIVE / PRODUCTION / SUPPORT -> CLOSED\n\nDrag a registered card between stream-stage groups and save. The enabled watcher validates and persists the change automatically.\n\nSnapshot: [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT|Current Portfolio Snapshot]]"},
        {"id": "executive-reading-guide", "type": "text", "x": 0, "y": -340, "width": pipeline_w + 830, "height": 180,
         "text": "## Control rules\n\nDelivery Stream and Delivery Stage are both resolved from card geometry. Lifecycle, Status, Progress, Current Gate, Priority and Primary Domain remain separate. ON HOLD / BLOCKED / WAITING are status overlays, never replacement stages. Candidate initiatives stay outside both streams until registered. CLOSED requires approved closure."},
    ]
    for stream_index, stream_spec in enumerate(config["streams"]):
        stream = stream_spec["name"]
        base_y = 0 if stream_index == 0 else external_base
        row_height = internal_height if stream_index == 0 else external_height
        nodes.append({"id": f"stream-title-{stream_spec['key'].lower()}", "type": "text", "x": 0, "y": base_y, "width": pipeline_w, "height": 130,
                      "text": f"# {stream}\n\nEight-stage software delivery control stream."})
        lane_y = base_y + 160
        for index, stage in enumerate(stages):
            x0 = index * (lane_w + gap_x)
            items = sorted(buckets[(stream, stage)], key=order)
            group_id = stream_spec["group_ids"][stage]
            nodes.append({"id": group_id, "type": "group", "x": x0, "y": lane_y, "width": lane_w, "height": row_height, "label": stage, "color": colors[index]})
            nodes.append({"id": f"{stream_spec['key'].lower()}-lane-guide-{index}", "type": "text", "x": x0 + 30, "y": lane_y + 65, "width": card_w, "height": 95, "text": definitions[stage]})
            if not items:
                nodes.append({"id": f"{stream_spec['key'].lower()}-lane-empty-{index}", "type": "text", "x": x0 + 30, "y": lane_y + 185, "width": card_w, "height": 120, "text": "No current registered project in this stream-stage. The stage remains permanently visible."})
            for row, item in enumerate(items):
                nodes.append({"id": stable_project_id(item["code"]), "type": "text", "x": x0 + 30, "y": lane_y + 185 + row * (card_h + gap_y), "width": card_w, "height": card_h, "text": project_card_text(item)})

    attention = [x for x in registered if x.get("status") in ("On Hold", "Blocked", "Waiting", "Pending Decision", "External Collaboration")]
    nodes.extend([
        {"id": "ppj-side-attention", "type": "group", "x": side_x, "y": 0, "width": 760, "height": 780, "label": "PORTFOLIO ATTENTION", "color": "2"},
        {"id": "ppj-side-attention-note", "type": "text", "x": side_x + 30, "y": 65, "width": 700, "height": 650,
         "text": "## Status overlays\n\n" + "\n".join(f"- {x['code']}: {x.get('status')} | Stream: {x.get('delivery_stream')} | Stage: {x.get('delivery_stage')} | Gate: {x.get('gate')}" for x in attention) + "\n\nThese are attention references, not duplicate project cards."},
        {"id": "ppj-side-domain-review", "type": "group", "x": side_x, "y": 850, "width": 760, "height": 520, "label": "DOMAIN / REGISTRATION REVIEW", "color": "3"},
        {"id": "ppj-side-domain-note", "type": "text", "x": side_x + 30, "y": 915, "width": 700, "height": 390,
         "text": "## Governance review\n\n- [[07_Decision_Log/DEC-20260824-ADMIN-EXPENSE-DOMAIN|Admin Expense domain decision]]\n- [[07_Decision_Log/DEC-20260824-WAREHOUSE-AWB-OCR-REGISTRATION|Warehouse AWB OCR registration/domain]]\n- [[07_Decision_Log/DEC-20260824-CPD-PATTERN-REGISTRATION|CPD Pattern registration]]\n\nThese notes do not create or duplicate canonical project cards."},
        {"id": "ppj-side-candidates", "type": "group", "x": side_x, "y": 1440, "width": 760, "height": 910, "label": "CANDIDATE INITIATIVES", "color": "6"},
    ])
    candidates = [x for x in snapshot["projects"] if x.get("candidate")]
    for row, item in enumerate(candidates):
        target = "03_Projects/_Registry/Project_Update_Proposals/WAREHOUSE_AWB_OCR_CURRENT_INITIATIVE" if item["code"] == "Warehouse AWB OCR" else "03_Projects/_Registry/Project_Update_Proposals/CPD_IN_HOUSE_PATTERN_GENERATION_CURRENT_INITIATIVE"
        text = (f"<!-- PPJ_CANDIDATE_CARD:{item['code']} -->\n\n## [[{target}|{item['code']}]]\n\n"
                f"Registration: {item.get('registration')}\nDomain: {item.get('domain')}\nLifecycle: {item.get('lifecycle')}\nGate: {item.get('gate')}\n\nNot a pipeline project card until registration is approved.")
        nodes.append({"id": "ppj-candidate-" + hashlib.sha1(item["code"].encode()).hexdigest()[:16], "type": "text", "x": side_x + 30, "y": 1510 + row * 360, "width": 700, "height": 320, "text": text})
    return {"nodes": nodes, "edges": []}


def canvas_semantic_equal(left: str, right: str) -> bool:
    try:
        a, b = json.loads(left), json.loads(right)
    except json.JSONDecodeError:
        return left == right
    for doc in (a, b):
        doc.pop("metadata", None)
        doc["nodes"] = sorted(doc.get("nodes", []), key=lambda x: x.get("id", ""))
        doc["edges"] = sorted(doc.get("edges", []), key=lambda x: x.get("id", ""))
    return a == b


def split_frontmatter(text: str) -> tuple[list[str] | None, str]:
    text = text.lstrip("\ufeff")
    if not text.startswith("---\n"):
        return None, text
    end = text.find("\n---", 4)
    if end < 0:
        return None, text
    return text[4:end].splitlines(), text[end + 4:].lstrip("\n")


def update_frontmatter(text: str, fields: dict[str, Any]) -> str:
    lines, body = split_frontmatter(text)
    lines = [] if lines is None else lines
    for key, value in fields.items():
        rendered = json.dumps(value, ensure_ascii=False) if not isinstance(value, (int, float)) else str(value)
        pattern = re.compile(rf"^{re.escape(key)}\s*:")
        for index, line in enumerate(lines):
            if pattern.match(line):
                lines[index] = f"{key}: {rendered}"
                break
        else:
            lines.append(f"{key}: {rendered}")
    return "---\n" + "\n".join(lines) + "\n---\n\n" + body.lstrip("\n")


def replace_block(text: str, start: str, end: str, body: str, *, near_top: bool = False) -> str:
    block = f"{start}\n{body.rstrip()}\n{end}"
    if start in text and end in text:
        return re.sub(re.escape(start) + r".*?" + re.escape(end), block, text, flags=re.S)
    if near_top:
        fm, rest = split_frontmatter(text)
        if fm is not None:
            return "---\n" + "\n".join(fm) + "\n---\n\n" + block + "\n\n" + rest.lstrip("\n")
    return text.rstrip() + "\n\n" + block + "\n"


def stage_overlay(projects: list[dict[str, Any]]) -> str:
    rows = ["## Executive Delivery-State Index", "", "| Project | Delivery Stream | Delivery Stage | Lifecycle | Status | Gate | Last Verified |", "|---|---|---|---|---|---|---|"]
    for item in sorted(projects, key=lambda x: x["code"]):
        vals = [item["code"], item.get("delivery_stream", ""), item.get("delivery_stage", ""), item.get("lifecycle", ""), item.get("status", ""), item.get("gate", ""), item.get("last_verified", "")]
        rows.append("| " + " | ".join(str(x).replace("|", "\\|").replace("\n", " ") for x in vals) + " |")
    return "\n".join(rows)


def snapshot_markdown(snapshot: dict[str, Any]) -> str:
    projects = snapshot["projects"]
    maturity = snapshot.get("portfolio_maturity", "Stage 3 - Controlled Delivery / Early Scale")
    direction = snapshot.get("strategic_direction", "Standardize Data -> Standardize Rules -> Standardize APIs -> Scale Automation / AI")
    lines = ["---", "type: portfolio_current_snapshot", f"source_event: {snapshot.get('source_event', 'PPJ-EXECUTIVE-CANVAS-STATE-SYNC')}", f"last_verified: {snapshot.get('last_verified', dt.date.today().isoformat())}", f"portfolio_maturity: {json.dumps(maturity, ensure_ascii=False)}", "---", "", "# PPJ Portfolio Current Snapshot", "", "This is the fast current-state handoff for a new Codex session. Read it after `AGENTS.md` and before historical reports. Delivery Stream separates internal and external development; Delivery Stage is the shared eight-step position. Lifecycle and Status remain separate.", "", f"- Source Event: `{snapshot.get('source_event')}`", f"- Last Verified: `{snapshot.get('last_verified')}`", f"- Portfolio Maturity: **{maturity}**", f"- Strategic direction: {direction}", "- Candidate/governance records are not canonical registrations.", "", "| Project | Domain | Delivery Stream | Delivery Stage | Detailed Lifecycle | Status | Current Gate | Priority | Current Outcome | Latest Update | Next Action | Confidence |", "|---|---|---|---|---|---|---|---|---|---|---|---|"]
    def cell(value: Any) -> str:
        if isinstance(value, list):
            value = "; ".join(str(x) for x in value) or "No active action"
        return str(value if value not in (None, "") else "Needs Confirmation").replace("|", "\\|").replace("\n", " ")
    for item in projects:
        delivery = "Candidate / Not Registered" if item.get("candidate") else item.get("delivery_stage")
        stream = "Candidate / Not Registered" if item.get("candidate") else item.get("delivery_stream")
        values = [item.get("code"), item.get("domain"), stream, delivery, item.get("lifecycle"), item.get("status"), item.get("gate"), item.get("priority"), item.get("outcome"), item.get("latest"), item.get("next_actions"), item.get("confidence")]
        lines.append("| " + " | ".join(cell(x) for x in values) + " |")
    lines += [
        "", "## Portfolio Backbones", "",
        "- Finance: WFX / Databricks / DWH -> Finance Rules -> OC Control -> Factory Performance -> Power BI / AI.",
        "- Technical + Costing: Technical sources -> ETL -> Technical Data Layer -> Sync -> Technical Platform -> Costing / Pattern / Wash.",
        "- Transactions: WFX API -> Business Validation -> Controlled Transaction -> GDI / future WFX automation -> Audit.",
        "- HR: Employee Data -> Standardization -> Employee Master -> Future HR workflows.",
        "- Sourcing: Supplier / Material Data -> Standardization -> Sourcing Platform -> Sourcing Chatbot -> Decisions.",
        "", "## Portfolio Risks", "",
        "- Data access: Databricks, WFX permissions and source ownership.",
        "- Data quality: Finance, Technical, HR and Sourcing data exists but is not always governed enough for reliable reuse.",
        "- Business-rule governance: Finance, Material Allocation, Expense Invoices and GDI require versioned rules, approval and traceability.",
        "- Integration governance: WFX API requires ownership, authentication, sandbox, rate limits, errors, audit and change management.",
        "- Production governance: production products require owner, SLA, monitoring, defect, enhancement, release and adoption practices.",
        "", "## Governance Exceptions", "",
        "- `Admin Expense Management.v1.1`: registered business initiative; Administration-owned; primary domain needs governance decision.",
        "- `Warehouse AWB OCR`: active enhancement candidate; canonical code and primary domain need governance decisions.",
        "- `CPD In-house Pattern Generation`: internal prototype/evaluation; canonical code is not confirmed; no canonical root project was created.",
    ]
    return "\n".join(lines).rstrip() + "\n"


def default_lifecycle(stage: str) -> str:
    return {
        "BACKLOG": "Backlog", "KICK-OFF": "Kick-Off", "ANALYSIS": "Analysis",
        "DESIGN": "Design", "DEVELOPMENT": "Development",
        "UAT / PRE-GO-LIVE": "UAT / Pre-Go-Live",
        "GO-LIVE / PRODUCTION / SUPPORT": "Production / Support", "CLOSED": "Closed",
    }[stage]


def lifecycle_compatible(lifecycle: str, stage: str) -> bool:
    value = lifecycle.lower()
    terms = {
        "BACKLOG": ("backlog", "not started"),
        "KICK-OFF": ("kick-off", "kickoff", "initiation"),
        "ANALYSIS": ("analysis", "strategic", "evaluation", "problem framing", "business case", "on hold", "active intelligence", "requirement"),
        "DESIGN": ("design", "api integration"),
        "DEVELOPMENT": ("development", "prototype", "build"),
        "UAT / PRE-GO-LIVE": ("uat", "pre-go-live", "stabilization", "validation"),
        "GO-LIVE / PRODUCTION / SUPPORT": ("production", "support", "maintenance", "rollout", "enhancement", "live"),
        "CLOSED": ("closed",),
    }
    return any(term in value for term in terms[stage])


def transition_kind(old: str, new: str, stages: list[str]) -> str:
    a, b = stages.index(old), stages.index(new)
    if b == a + 1:
        return "forward"
    if b > a + 1:
        return "forward-skip"
    if b < a:
        return "backward-rework"
    return "unchanged"


def backup_and_write(changes: dict[Path, str], stamp: str) -> tuple[Path, Path]:
    state_root = STATE_BACKUP_ROOT / stamp
    canvas_root = CANVAS_BACKUP_ROOT / stamp
    state_root.mkdir(parents=True, exist_ok=True)
    (state_root / ".ppj-canvas-state-sync-backup").write_text(stamp + "\n", encoding="utf-8")
    for path in changes:
        if not path.exists():
            continue
        target_root = canvas_root if path.suffix == ".canvas" else state_root
        target = target_root / path.relative_to(ROOT)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, target)
    for path, content in changes.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        temp = path.with_name(path.name + ".ppj-sync-tmp")
        temp.write_text(content, encoding="utf-8")
        temp.replace(path)
    return state_root, canvas_root
