#!/usr/bin/env python3
"""Plan and apply PPJ project workspace upgrades.

Dry-run is the default. Apply is intentionally explicit and creates backups before
changing any existing vault content.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import sys
from dataclasses import dataclass, field
from datetime import date, datetime
from pathlib import Path
from typing import Iterable

SCRIPT_PATH = Path(__file__).resolve()
VAULT_ROOT = SCRIPT_PATH.parent.parent
PROJECT_ROOT = VAULT_ROOT / "03_Projects"
REGISTRY_ROOT = PROJECT_ROOT / "_Registry"
MEMORY_ROOT = REGISTRY_ROOT / "Project_Memory"
GLOBAL_TASK_ROOT = PROJECT_ROOT / "_Tasks"
REPORT_ROOT = VAULT_ROOT / "10_Reports"
GLOBAL_CANVAS = PROJECT_ROOT / "Canvas" / "PPJ_Executive_Board.canvas"
COMMAND_CENTER = PROJECT_ROOT / "PROJECT_COMMAND_CENTER.md"
AGENTS_PATH = VAULT_ROOT / "AGENTS.md"
REGISTRATION_PROTOCOL = REGISTRY_ROOT / "PPJ_PROJECT_REGISTRATION_PROTOCOL.md"
TODAY = date.today().isoformat()

REGISTRY_PATH = REGISTRY_ROOT / "PPJ_PROJECT_REGISTRY.md"
MEMORY_INDEX_PATH = REGISTRY_ROOT / "PPJ_PROJECT_MEMORY_INDEX.md"
NAMING_PATH = REGISTRY_ROOT / "PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md"
DOMAIN_PATH = REGISTRY_ROOT / "PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md"
RESOURCE_PATH = REGISTRY_ROOT / "PPJ_PROJECT_RESOURCE_MATRIX.md"
LEDGER_PATH = REGISTRY_ROOT / "PPJ_PROJECT_UPDATE_LEDGER.md"

EXCLUDED_NOTE_NAMES = {
    "PROJECT_COMMAND_CENTER.md",
    "AI Automation Workshop.md",
    "Workshop Analysis.md",
}
EXCLUDED_CODES = {
    "PROJECT_COMMAND_CENTER",
    "AI.Automation.Workshop.202606",
    "AI.Automation.Workshop.Analysis.202606",
    "PPJ.GenAI.Cloud.Infrastructure.POC.v1.0",
}
EXCLUDED_DIRECTORIES = {
    "_Aliases",
    "_Archive",
    "_Kanban",
    "_Registry",
    "_Tasks",
    "_Templates",
    "Canvas",
    "Project_SmartFlow",
}

BASE_DOCUMENTS = [
    "00_Project_Home.md",
    "01_Management/Project_Profile.md",
    "01_Management/Project_Plan.md",
    "01_Management/Milestones.md",
    "01_Management/Weekly_Status.md",
    "02_Business/Business_Context.md",
    "02_Business/BRD.md",
    "02_Business/Scope_and_Business_Rules.md",
    "03_Process/AS_IS_Process.md",
    "03_Process/TO_BE_Process.md",
    "03_Process/Process_Gaps.md",
    "04_Data/Data_Spec.md",
    "04_Data/Data_Source_Inventory.md",
    "04_Data/Data_Quality_and_Traceability.md",
    "05_Requirements/Functional_Requirements.md",
    "05_Requirements/Use_Cases.md",
    "05_Requirements/Acceptance_Criteria.md",
    "06_Solution/Solution_Overview.md",
    "06_Solution/Integration_Spec.md",
    "07_Test_UAT/UAT_Plan.md",
    "07_Test_UAT/UAT_Cases.md",
    "07_Test_UAT/Defect_Log.md",
    "08_Implementation/Implementation_Plan.md",
    "08_Implementation/Deployment_Checklist.md",
    "09_Operations/User_Manual.md",
    "09_Operations/Support_and_Maintenance.md",
    "10_Governance/Risks_Issues.md",
    "10_Governance/Decision_Log.md",
    "10_Governance/Dependencies.md",
    "10_Governance/Change_Log.md",
]

CORE_DOCUMENTS = [
    "00_Project_Home.md",
    "01_Management/Project_Profile.md",
    "01_Management/Project_Plan.md",
    "01_Management/Milestones.md",
    "01_Management/Weekly_Status.md",
    "02_Business/Business_Context.md",
    "02_Business/Scope_and_Business_Rules.md",
    "10_Governance/Risks_Issues.md",
    "10_Governance/Decision_Log.md",
    "10_Governance/Dependencies.md",
    "10_Governance/Change_Log.md",
]

DISCOVERY_DOCUMENTS = CORE_DOCUMENTS + [
    "02_Business/BRD.md",
    "03_Process/AS_IS_Process.md",
    "03_Process/TO_BE_Process.md",
    "03_Process/Process_Gaps.md",
    "04_Data/Data_Source_Inventory.md",
    "04_Data/Data_Quality_and_Traceability.md",
    "05_Requirements/Functional_Requirements.md",
    "05_Requirements/Use_Cases.md",
    "05_Requirements/Acceptance_Criteria.md",
    "06_Solution/Solution_Overview.md",
]

PRODUCTION_DOCUMENTS = CORE_DOCUMENTS + [
    "04_Data/Data_Spec.md",
    "04_Data/Data_Source_Inventory.md",
    "04_Data/Data_Quality_and_Traceability.md",
    "05_Requirements/Acceptance_Criteria.md",
    "06_Solution/Solution_Overview.md",
    "06_Solution/Integration_Spec.md",
    "07_Test_UAT/UAT_Plan.md",
    "07_Test_UAT/UAT_Cases.md",
    "07_Test_UAT/Defect_Log.md",
    "08_Implementation/Implementation_Plan.md",
    "08_Implementation/Deployment_Checklist.md",
    "09_Operations/User_Manual.md",
    "09_Operations/Support_and_Maintenance.md",
]

EXTERNAL_TRIAL_DOCUMENTS = CORE_DOCUMENTS + [
    "02_Business/BRD.md",
    "03_Process/AS_IS_Process.md",
    "03_Process/TO_BE_Process.md",
    "03_Process/Process_Gaps.md",
    "04_Data/Data_Source_Inventory.md",
    "04_Data/Data_Quality_and_Traceability.md",
    "05_Requirements/Functional_Requirements.md",
    "05_Requirements/Use_Cases.md",
    "05_Requirements/Acceptance_Criteria.md",
    "06_Solution/Solution_Overview.md",
    "06_Solution/Integration_Spec.md",
    "07_Test_UAT/UAT_Plan.md",
    "07_Test_UAT/UAT_Cases.md",
    "07_Test_UAT/Defect_Log.md",
]

WORKSPACE_DIRECTORIES = [
    "01_Management",
    "02_Business",
    "03_Process",
    "04_Data",
    "05_Requirements",
    "06_Solution",
    "07_Test_UAT",
    "08_Implementation",
    "09_Operations",
    "10_Governance",
    "Tasks",
    "Meetings",
    "Evidence",
]

STATUS_TO_LANE = {
    "backlog": "BACKLOG",
    "this_week": "THIS WEEK",
    "in_progress": "IN PROGRESS",
    "blocked": "BLOCKED / WAITING",
    "review": "REVIEW / UAT",
    "done": "DONE",
}
LANE_ORDER = list(STATUS_TO_LANE.values())
PRIORITY_ORDER = {"P0": 0, "P1": 1, "P2": 2, "P3": 3, "TBD": 9}


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig") if path.exists() else ""


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    normalized = content.rstrip() + "\n"
    temp_path = path.with_name(path.name + ".tmp")
    temp_path.write_text(normalized, encoding="utf-8")
    temp_path.replace(path)


def clean_cell(value: str) -> str:
    value = value.strip()
    value = value.replace("`", "")
    return value.strip()


def wiki_parts(value: str) -> tuple[str, str]:
    match = re.search(r"\[\[([^\]]+)\]\]", value)
    if not match:
        cleaned = clean_cell(value)
        return cleaned, cleaned
    inner = match.group(1)
    target, separator, label = inner.partition("|")
    target = target.split("#", 1)[0].strip()
    return target, (label.strip() if separator else target)


def wiki_target(value: str) -> str:
    return wiki_parts(value)[0]


def wiki_label(value: str) -> str:
    return wiki_parts(value)[1]


def clean_filename(value: str) -> str:
    value = wiki_target(value).strip().strip('"\'')
    value = value.replace("\\", "/").split("/")[-1]
    if value.casefold() in {"", "tbd", "needs confirmation", "none", "n/a"}:
        return ""
    if value and not value.lower().endswith(".md"):
        value += ".md"
    return value


def identity_key(value: str) -> str:
    value = wiki_label(value).casefold()
    value = re.sub(r"\.memory$", "", value)
    value = re.sub(r"\.md$", "", value)
    return re.sub(r"[^a-z0-9]+", "", value)


def slug_id(value: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9._-]+", "-", value).strip("-.")
    return cleaned or "PROJECT"


def split_markdown_row(line: str) -> list[str]:
    line = line.strip()
    if not line.startswith("|"):
        return []
    cells: list[str] = []
    current: list[str] = []
    wiki_depth = 0
    in_code = False
    i = 1
    while i < len(line):
        pair = line[i : i + 2]
        char = line[i]
        if pair == "[[":
            wiki_depth += 1
            current.extend(pair)
            i += 2
            continue
        if pair == "]]" and wiki_depth:
            wiki_depth -= 1
            current.extend(pair)
            i += 2
            continue
        if char == "`":
            in_code = not in_code
            current.append(char)
        elif char == "|" and wiki_depth == 0 and not in_code:
            cells.append("".join(current).strip())
            current = []
        else:
            current.append(char)
        i += 1
    if current:
        cells.append("".join(current).strip())
    if cells and not cells[-1]:
        cells.pop()
    return cells


def parse_markdown_tables(text: str) -> list[tuple[list[str], list[dict[str, str]]]]:
    lines = text.splitlines()
    tables: list[tuple[list[str], list[dict[str, str]]]] = []
    i = 0
    while i + 1 < len(lines):
        header = split_markdown_row(lines[i])
        separator = split_markdown_row(lines[i + 1])
        if header and separator and len(separator) >= len(header) and all(
            re.fullmatch(r":?-{3,}:?", cell.replace(" ", "")) for cell in separator[: len(header)]
        ):
            rows: list[dict[str, str]] = []
            i += 2
            while i < len(lines):
                cells = split_markdown_row(lines[i])
                if not cells:
                    break
                padded = cells + [""] * max(0, len(header) - len(cells))
                rows.append({clean_cell(header[j]): padded[j].strip() for j in range(len(header))})
                i += 1
            tables.append(([clean_cell(item) for item in header], rows))
            continue
        i += 1
    return tables


def table_rows_with_headers(path: Path, required: Iterable[str]) -> list[dict[str, str]]:
    required_set = set(required)
    for headers, rows in parse_markdown_tables(read_text(path)):
        if required_set.issubset(set(headers)):
            return rows
    return []


def extract_frontmatter(text: str) -> tuple[dict[str, object], str, str]:
    if not text.startswith("---"):
        return {}, "", text
    match = re.match(r"^---\s*\n(.*?)\n---\s*\n?", text, re.S)
    if not match:
        return {}, "", text
    raw = match.group(1)
    data: dict[str, object] = {}
    lines = raw.splitlines()
    index = 0
    while index < len(lines):
        line = lines[index]
        scalar_match = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if not scalar_match:
            index += 1
            continue
        key, value = scalar_match.groups()
        value = value.strip()
        if value.startswith("[") and not value.rstrip().endswith("]"):
            collected = [value]
            index += 1
            while index < len(lines):
                collected.append(lines[index].strip())
                if lines[index].strip().endswith("]"):
                    break
                index += 1
            value = " ".join(collected)
        if not value:
            items: list[str] = []
            probe = index + 1
            while probe < len(lines):
                list_match = re.match(r"^\s+-\s+(.*)$", lines[probe])
                if not list_match:
                    break
                items.append(list_match.group(1).strip().strip('"\''))
                probe += 1
            if items:
                data[key] = items
                index = probe
                continue
            data[key] = ""
        elif value.startswith("[") and value.endswith("]"):
            try:
                data[key] = json.loads(value.replace("'", '"'))
            except json.JSONDecodeError:
                data[key] = [item.strip().strip('"\'') for item in value[1:-1].split(",") if item.strip()]
        else:
            data[key] = value.strip().strip('"\'')
        index += 1
    body = text[match.end() :]
    return data, raw, body


def fm_scalar(data: dict[str, object], *keys: str, default: str = "") -> str:
    for key in keys:
        value = data.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
        if isinstance(value, (int, float)):
            return str(value)
    return default


def fm_list(data: dict[str, object], *keys: str) -> list[str]:
    for key in keys:
        value = data.get(key)
        if isinstance(value, list):
            return [str(item).strip() for item in value if str(item).strip()]
        if isinstance(value, str) and value.strip():
            return split_items(value)
    return []


def split_items(value: str | list[str] | None) -> list[str]:
    if value is None:
        return []
    if isinstance(value, list):
        raw_items = value
    else:
        normalized = value.replace("\r", "\n")
        if "|" in normalized:
            raw_items = normalized.split("|")
        else:
            raw_items = normalized.splitlines()
    result: list[str] = []
    for item in raw_items:
        item = re.sub(r"^\s*(?:[-*]|\d+[.)])\s*", "", str(item)).strip()
        if item and item.casefold() not in {"tbd", "needs confirmation", "none"}:
            result.append(item)
    return unique(result)


def unique(items: Iterable[str]) -> list[str]:
    seen: set[str] = set()
    result: list[str] = []
    for item in items:
        normalized = re.sub(r"\s+", " ", item).strip()
        key = normalized.casefold()
        if normalized and key not in seen:
            seen.add(key)
            result.append(normalized)
    return result


def extract_section(text: str, headings: Iterable[str]) -> str:
    for heading in headings:
        pattern = re.compile(
            rf"(?ms)^##\s+{re.escape(heading)}\s*$\n(.*?)(?=^##\s+|^<!--|\Z)"
        )
        match = pattern.search(text)
        if match:
            return match.group(1).strip()
    return ""


def section_items(text: str, headings: Iterable[str]) -> list[str]:
    section = extract_section(text, headings)
    if not section:
        return []
    lines = []
    for line in section.splitlines():
        if re.match(r"^\s*(?:[-*]|\d+[.)])\s+", line):
            lines.append(line)
    if lines:
        return split_items(lines)
    paragraphs = [item.strip() for item in re.split(r"\n\s*\n", section) if item.strip()]
    return unique(paragraphs[:5])


def section_summary(text: str, headings: Iterable[str], fallback: str = "TBD") -> str:
    section = extract_section(text, headings)
    if not section:
        return fallback
    section = re.sub(r"\[\[([^\]|]+)\|?([^\]]*)\]\]", lambda m: m.group(2) or m.group(1), section)
    section = re.sub(r"\s+", " ", section).strip()
    return section[:700].rstrip()


def yaml_quote(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def update_frontmatter(text: str, updates: dict[str, str]) -> str:
    data, raw, body = extract_frontmatter(text)
    if not raw:
        lines = ["---"] + [f"{key}: {yaml_quote(value)}" for key, value in updates.items()] + ["---", "", text]
        return "\n".join(lines).rstrip() + "\n"
    lines = raw.splitlines()
    remaining = dict(updates)
    output: list[str] = []
    for line in lines:
        match = re.match(r"^([A-Za-z0-9_-]+):", line)
        if match and match.group(1) in remaining:
            key = match.group(1)
            output.append(f"{key}: {yaml_quote(remaining.pop(key))}")
        else:
            output.append(line)
    for key, value in remaining.items():
        output.append(f"{key}: {yaml_quote(value)}")
    return "---\n" + "\n".join(output) + "\n---\n\n" + body.lstrip("\n")


def replace_managed_block(text: str, start: str, end: str, content: str) -> str:
    block = f"{start}\n{content.rstrip()}\n{end}"
    pattern = re.compile(re.escape(start) + r".*?" + re.escape(end), re.S)
    if pattern.search(text):
        return pattern.sub(block, text, count=1)
    return text.rstrip() + "\n\n" + block + "\n"


def backup_file(path: Path, audit_root: Path, canvas_root: Path | None = None) -> None:
    if not path.exists():
        return
    relative = path.relative_to(VAULT_ROOT)
    destination = audit_root / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(path, destination)
    if canvas_root is not None and path.suffix == ".canvas":
        canvas_destination = canvas_root / relative
        canvas_destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, canvas_destination)


@dataclass
class PlannedTask:
    title: str
    status: str
    priority: str
    owner: str
    due: str
    acceptance: str
    source_event: str
    source_note: str = ""
    task_id: str = ""
    filename: str = ""


@dataclass
class Project:
    code: str
    note_path: Path
    memory_path: Path
    folder: Path
    primary_domain: str
    secondary_domains: str
    lifecycle: str
    progress: str
    current_gate: str
    priority: str
    business_owner: str
    primary_users: str
    ba_coordination: list[str]
    technical_members: list[str]
    cluster: str
    understanding: str
    outcome: str
    latest_update: str
    scope: list[str]
    out_of_scope: list[str]
    risks: list[str]
    blockers: list[str]
    decisions: list[str]
    actions: list[str]
    dependencies: list[str]
    systems: list[str]
    data_sources: list[str]
    confidence: str
    last_verified: str
    source_event: str
    lifecycle_class: str
    project_types: list[str]
    aliases: set[str] = field(default_factory=set)
    tasks: list[PlannedTask] = field(default_factory=list)
    source_rows: dict[str, str] = field(default_factory=dict)

    @property
    def folder_name(self) -> str:
        return self.note_path.stem

    @property
    def memory_link(self) -> str:
        return self.memory_path.relative_to(VAULT_ROOT).with_suffix("").as_posix()


def classify_lifecycle(lifecycle: str, gate: str) -> str:
    text = lifecycle.casefold()
    gate_text = gate.casefold()
    if any(term in text for term in ["closed", "completed", "done", "cancel"]):
        return "F. Closed / Canceled"
    if any(term in text for term in ["external", "trial", "poc", "feasibility", "pre-contact", "partnership", "proposal evaluation"]):
        return "G. External Trial / PoC"
    if any(term in text for term in ["on hold", "pending decision", "re-scope", "resource constraint"]):
        return "E. On Hold / Pending Decision"
    if any(term in text for term in ["backlog", "pending resource", "not started"]):
        return "D. Backlog / Pending Resource"
    if "pending" in text:
        if any(term in gate_text for term in ["on hold", "re-scope", "pending decision", "delayed"]):
            return "E. On Hold / Pending Decision"
        return "D. Backlog / Pending Resource"
    if any(term in text for term in ["production", "support", "maintenance", "internal hub", "business adoption"]):
        return "C. Production / Maintenance"
    if any(term in text for term in ["uat", "stabil", "closeout", "acceptance", "handover"]):
        return "B. UAT / Stabilization"
    return "A. Active / Delivery"


def detect_project_types(code: str, cluster: str, understanding: str, lifecycle_class: str) -> list[str]:
    text = f"{code} {cluster} {understanding}".casefold()
    result: list[str] = []
    external = lifecycle_class.startswith("G") or any(
        term in text for term in ["ppjx", "rfid", "vendor", "trial", "academic collaboration", "vitas"]
    )
    if external and "vitas" not in text:
        result.append("External / PoC")
    if any(term in text for term in ["chatbot", "agentic", "agent platform", "ai hub", "orchestrator"]):
        result.append("AI / Chatbot / Agent")
    if any(
        term in text
        for term in [
            "datamart",
            "report",
            "finance",
            "inventory",
            "market intelligence",
            "technical knowledge",
            "dashboard",
            "data platform",
            "portal",
        ]
    ):
        result.append("Data / Reporting / Finance")
    if any(
        term in text
        for term in [
            "gdi",
            "allocation",
            "invoice",
            "grn",
            "indent",
            "label-o",
            "po commit",
            "workflow",
        ]
    ) and not external:
        result.append("Transaction Automation")
    if lifecycle_class.startswith("D"):
        result.append("Backlog Discovery")
    if lifecycle_class.startswith("E"):
        result.append("Decision / Re-scope")
    if lifecycle_class.startswith("F"):
        result.append("Closeout")
    return unique(result) or ["Standard Delivery"]


def source_rows() -> dict[str, list[dict[str, str]]]:
    return {
        "domain": table_rows_with_headers(DOMAIN_PATH, ["Canonical Code", "Current File", "Primary Domain"]),
        "dictionary": table_rows_with_headers(NAMING_PATH, ["Canonical Code", "Current Note", "Core Meaning"]),
        "index": table_rows_with_headers(MEMORY_INDEX_PATH, ["Project", "Memory Card", "Project Note"]),
        "registry_master": table_rows_with_headers(REGISTRY_PATH, ["Project Name", "Canonical Filename", "Phase"]),
        "registry_overlay": table_rows_with_headers(REGISTRY_PATH, ["Canonical Code", "Current File", "Primary Domain"]),
        "resource": table_rows_with_headers(RESOURCE_PATH, ["Canonical Project Name", "Source File"]),
    }


def load_memory_cards() -> list[tuple[Path, dict[str, object], str]]:
    cards = []
    for path in sorted(MEMORY_ROOT.glob("*.memory.md")):
        text = read_text(path)
        fm, _, body = extract_frontmatter(text)
        cards.append((path, fm, body))
    return cards


def discover_projects(selected_code: str | None = None) -> tuple[list[Project], list[str], list[str]]:
    hard_stops: list[str] = []
    warnings: list[str] = []
    required_sources = [REGISTRY_PATH, MEMORY_INDEX_PATH, NAMING_PATH, DOMAIN_PATH]
    missing_sources = [str(path.relative_to(VAULT_ROOT)) for path in required_sources if not path.exists()]
    if missing_sources:
        hard_stops.append("Missing source-of-truth files: " + ", ".join(missing_sources))
        return [], hard_stops, warnings

    rows = source_rows()
    root_notes = {path.name: path for path in PROJECT_ROOT.glob("*.md") if path.name not in EXCLUDED_NOTE_NAMES}
    memory_cards = load_memory_cards()
    registry_text = read_text(REGISTRY_PATH)

    preferred_by_note: dict[str, str] = {}
    domain_by_code: dict[str, dict[str, str]] = {}
    for row in rows["domain"] + rows["registry_overlay"]:
        code = clean_cell(row.get("Canonical Code", ""))
        current_file = clean_filename(row.get("Current File", ""))
        if code and current_file:
            preferred_by_note[current_file] = code
        if code:
            domain_by_code[code] = {**domain_by_code.get(code, {}), **row}

    dictionary_by_code: dict[str, dict[str, str]] = {}
    note_to_dictionary_code: dict[str, str] = {}
    for row in rows["dictionary"]:
        raw_code = clean_cell(row.get("Canonical Code", ""))
        current_note = clean_filename(row.get("Current Note", ""))
        code = preferred_by_note.get(current_note, raw_code)
        if code:
            dictionary_by_code[code] = row
        if current_note and code:
            note_to_dictionary_code[current_note] = code

    memory_by_code: dict[str, list[tuple[Path, dict[str, object], str]]] = {}
    memory_by_note: dict[str, list[tuple[Path, dict[str, object], str]]] = {}
    for card in memory_cards:
        path, fm, _ = card
        codes = unique(
            [
                fm_scalar(fm, "canonical_code"),
                fm_scalar(fm, "project_code"),
                fm_scalar(fm, "project_name"),
                path.name.removesuffix(".memory.md"),
            ]
        )
        current_files = unique([fm_scalar(fm, "current_file"), fm_scalar(fm, "project_file")])
        for current_file in current_files:
            filename = clean_filename(current_file)
            if filename:
                preferred = preferred_by_note.get(filename)
                if preferred:
                    codes.append(preferred)
                memory_by_note.setdefault(filename, []).append(card)
        for code in unique(codes):
            if code:
                memory_by_code.setdefault(code, []).append(card)

    evidence: dict[str, dict[str, object]] = {}

    def add_evidence(code: str, source: str, row: dict[str, str] | None = None, note: str = "", memory: str = "") -> None:
        code = re.sub(r"\.memory$", "", clean_cell(code))
        if not code or code in EXCLUDED_CODES:
            return
        record = evidence.setdefault(code, {"sources": set(), "rows": {}, "notes": set(), "memories": set()})
        record["sources"].add(source)
        if row:
            record["rows"][source] = {**record["rows"].get(source, {}), **row}
        if note:
            filename = clean_filename(note)
            if filename:
                record["notes"].add(filename)
        if memory:
            record["memories"].add(memory)

    for code, row in domain_by_code.items():
        add_evidence(code, "domain", row, row.get("Current File", ""))
    for code, row in dictionary_by_code.items():
        add_evidence(code, "dictionary", row, row.get("Current Note", ""))
    for row in rows["index"]:
        project_label = wiki_label(row.get("Project", ""))
        note = clean_filename(row.get("Project Note", ""))
        code = preferred_by_note.get(note) or note_to_dictionary_code.get(note) or project_label
        add_evidence(code, "index", row, note, wiki_target(row.get("Memory Card", "")))
    for row in rows["registry_master"]:
        note = clean_filename(row.get("Canonical Filename", ""))
        name = clean_cell(row.get("Project Name", ""))
        code = preferred_by_note.get(note) or note_to_dictionary_code.get(note) or name
        add_evidence(code, "registry", row, note)
    for row in rows["registry_overlay"]:
        add_evidence(row.get("Canonical Code", ""), "registry_overlay", row, row.get("Current File", ""))
    for row in rows["resource"]:
        note = clean_filename(row.get("Source File", ""))
        label = wiki_label(row.get("Canonical Project Name", ""))
        code = preferred_by_note.get(note) or note_to_dictionary_code.get(note) or label
        add_evidence(code, "resource", row, note)
    for path, fm, _ in memory_cards:
        note = clean_filename(fm_scalar(fm, "current_file", "project_file"))
        code = preferred_by_note.get(note) or fm_scalar(fm, "canonical_code", "project_code", "project_name")
        add_evidence(code, "memory", note=note, memory=path.name)

    projects: list[Project] = []
    note_claims: dict[Path, str] = {}
    for code in sorted(evidence, key=str.casefold):
        if code in EXCLUDED_CODES:
            continue
        item = evidence[code]
        candidate_notes = set(item["notes"])
        for card in memory_by_code.get(code, []):
            _, fm, _ = card
            candidate_notes.update(
                clean_filename(value)
                for value in [fm_scalar(fm, "current_file"), fm_scalar(fm, "project_file")]
                if value
            )
        if f"{code}.md" in root_notes:
            candidate_notes.add(f"{code}.md")
        resolved_notes = [root_notes[name] for name in candidate_notes if name in root_notes]
        if not resolved_notes:
            fuzzy_candidates = []
            candidate_keys = {identity_key(name) for name in candidate_notes | {code}}
            for path in root_notes.values():
                if identity_key(path.name) in candidate_keys:
                    fuzzy_candidates.append(path)
            resolved_notes = unique_paths(fuzzy_candidates)
        resolved_notes = unique_paths(resolved_notes)
        if not resolved_notes:
            if code == "PPJ.GenAI.Cloud.Infrastructure.POC.v1.0":
                warnings.append(f"Candidate excluded because no approved root project note exists: {code}")
            continue
        if len(resolved_notes) > 1:
            hard_stops.append(
                f"Ambiguous canonical resolution for {code}: " + ", ".join(path.name for path in resolved_notes)
            )
            continue
        note_path = resolved_notes[0]
        if note_path.name in EXCLUDED_NOTE_NAMES:
            continue
        if note_path in note_claims and note_claims[note_path] != code:
            preferred = preferred_by_note.get(note_path.name)
            if preferred == code:
                projects = [project for project in projects if project.note_path != note_path]
                note_claims[note_path] = code
            elif preferred == note_claims[note_path]:
                continue
            else:
                hard_stops.append(
                    f"Two canonical codes map to {note_path.name}: {note_claims[note_path]} and {code}"
                )
                continue
        else:
            note_claims[note_path] = code

        cards = unique_cards(memory_by_code.get(code, []) + memory_by_note.get(note_path.name, []))
        if len(cards) > 1:
            exact_cards = [
                card
                for card in cards
                if fm_scalar(card[1], "canonical_code", "project_code") == code
                or clean_filename(fm_scalar(card[1], "current_file", "project_file")) == note_path.name
            ]
            cards = unique_cards(exact_cards)
        if len(cards) != 1:
            hard_stops.append(
                f"Expected one project memory card for {code}/{note_path.name}; found {len(cards)}"
            )
            continue
        memory_path, memory_fm, memory_body = cards[0]
        note_text = read_text(note_path)
        note_fm, _, note_body = extract_frontmatter(note_text)
        domain_row = item["rows"].get("domain", {}) or item["rows"].get("registry_overlay", {})
        dictionary_row = item["rows"].get("dictionary", {})
        registry_row = item["rows"].get("registry", {})
        index_row = item["rows"].get("index", {})
        resource_row = item["rows"].get("resource", {})

        primary_domain = first_nonempty(
            fm_scalar(memory_fm, "primary_domain"),
            domain_row.get("Primary Domain", ""),
            fm_scalar(note_fm, "primary_domain"),
            "Needs Confirmation",
        )
        lifecycle = first_nonempty(
            registry_row.get("Phase", ""),
            fm_scalar(memory_fm, "lifecycle", "phase", "status"),
            domain_row.get("Lifecycle", ""),
            fm_scalar(note_fm, "lifecycle", "phase", "status"),
            "Needs Confirmation",
        )
        current_gate = first_nonempty(
            fm_scalar(memory_fm, "current_gate"),
            domain_row.get("Status / Gate", ""),
            registry_row.get("Status / Priority", ""),
            fm_scalar(note_fm, "current_gate"),
            "Needs Confirmation",
        )
        progress = first_nonempty(
            registry_row.get("Progress", ""),
            fm_scalar(memory_fm, "progress"),
            domain_row.get("Progress", ""),
            fm_scalar(note_fm, "progress"),
            "TBD",
        )
        cluster = first_nonempty(
            fm_scalar(memory_fm, "cluster"),
            index_row.get("Cluster", ""),
            dictionary_row.get("Cluster", ""),
            registry_row.get("Cluster / Portfolio Group", ""),
            fm_scalar(note_fm, "cluster"),
            "Needs Confirmation",
        )
        priority = normalize_priority(
            first_nonempty(
                fm_scalar(memory_fm, "priority"),
                index_row.get("Priority", ""),
                resource_row.get("Current Priority", ""),
                fm_scalar(note_fm, "priority"),
                "TBD",
            )
        )
        understanding = first_nonempty(
            section_summary(memory_body, ["One-Line Understanding"], ""),
            dictionary_row.get("Core Meaning", ""),
            "Needs Confirmation",
        )
        outcome = first_nonempty(
            fm_scalar(memory_fm, "current_outcome"),
            section_summary(memory_body, ["Current Outcome", "Outcome"], ""),
            index_row.get("Current Outcome", ""),
            "Needs Confirmation",
        )
        latest_update = first_nonempty(
            fm_scalar(memory_fm, "latest_update_summary"),
            section_summary(memory_body, ["Latest Update Summary"], ""),
            index_row.get("Latest Update", ""),
            "Needs Confirmation",
        )
        risks = first_list(
            split_items(fm_scalar(memory_fm, "known_risks")),
            section_items(memory_body, ["Known Risks", "Known Risks / Blockers"]),
            section_items(note_body, ["Current Risks", "Risks", "Risks and Dependencies"]),
        )
        blockers = first_list(
            split_items(fm_scalar(memory_fm, "known_blockers")),
            section_items(note_body, ["Current Blockers", "Current Risks / Blockers"]),
        )
        decisions = first_list(
            split_items(fm_scalar(memory_fm, "decisions_needed")),
            section_items(memory_body, ["Decisions Needed"]),
            section_items(note_body, ["Decisions Needed", "Current Decisions"]),
        )
        actions = first_list(
            split_items(fm_scalar(memory_fm, "next_actions")),
            section_items(note_body, ["Next Actions", "Immediate Next Actions"]),
            section_items(memory_body, ["Next Actions"]),
        )
        dependencies = first_list(
            fm_list(memory_fm, "dependencies"),
            split_items(fm_scalar(memory_fm, "dependencies")),
            section_items(note_body, ["Dependencies", "Systems / Data and Dependencies"]),
        )
        systems = unique(fm_list(memory_fm, "systems") + section_items(memory_body, ["Systems / Data"]))
        data_sources = unique(fm_list(memory_fm, "data_sources"))
        scope = first_list(
            section_items(memory_body, ["What This Project Is"]),
            section_items(note_body, ["Current Scope", "Scope", "Potential Scope"]),
        )
        out_of_scope = first_list(
            section_items(memory_body, ["What This Project Is Not"]),
            section_items(note_body, ["Out of Scope"]),
        )
        business_owner = first_nonempty(
            fm_scalar(memory_fm, "business_owner"),
            fm_scalar(note_fm, "business_owner", "owner"),
            "Needs Confirmation",
        )
        primary_users = first_nonempty(
            domain_row.get("Owner / Primary Users", ""),
            section_summary(memory_body, ["Key Users"], ""),
            "Needs Confirmation",
        )
        ba_coordination = unique(
            fm_list(memory_fm, "ba_coordination")
            + split_items(resource_row.get("BA / Coordination", ""))
        )
        technical_members = unique(
            fm_list(memory_fm, "technical_members")
            + split_items(resource_row.get("Technical Owner / Members", ""))
        )
        secondary_domains = first_nonempty(
            fm_scalar(memory_fm, "secondary_domains"),
            domain_row.get("Secondary Domains", ""),
            fm_scalar(note_fm, "secondary_domains"),
            "Needs Confirmation",
        )
        last_verified = first_nonempty(
            fm_scalar(memory_fm, "last_verified"),
            fm_scalar(note_fm, "last_verified"),
            TODAY,
        )
        confidence = first_nonempty(
            fm_scalar(memory_fm, "confidence"),
            index_row.get("Confidence", ""),
            fm_scalar(note_fm, "confidence"),
            "Needs Confirmation",
        )
        source_event = first_nonempty(
            fm_scalar(memory_fm, "source_event"),
            fm_scalar(note_fm, "source_event"),
            index_row.get("Latest Update", ""),
            "Needs Confirmation",
        )
        lifecycle_class = classify_lifecycle(lifecycle, current_gate)
        project_types = detect_project_types(code, cluster, understanding, lifecycle_class)
        if "External / PoC" in project_types and lifecycle_class.startswith("A"):
            lifecycle_class = "G. External Trial / PoC"
        aliases = {
            identity_key(code),
            identity_key(note_path.stem),
            identity_key(fm_scalar(memory_fm, "project_name")),
            identity_key(fm_scalar(memory_fm, "project_code")),
            identity_key(fm_scalar(memory_fm, "canonical_code")),
            identity_key(fm_scalar(note_fm, "project_name")),
            identity_key(fm_scalar(note_fm, "project_code")),
            identity_key(fm_scalar(note_fm, "canonical_code")),
        }
        aliases.discard("")
        project = Project(
            code=code,
            note_path=note_path,
            memory_path=memory_path,
            folder=PROJECT_ROOT / note_path.stem,
            primary_domain=primary_domain,
            secondary_domains=secondary_domains,
            lifecycle=lifecycle,
            progress=progress,
            current_gate=current_gate,
            priority=priority,
            business_owner=business_owner,
            primary_users=primary_users,
            ba_coordination=ba_coordination,
            technical_members=technical_members,
            cluster=cluster,
            understanding=understanding,
            outcome=outcome,
            latest_update=latest_update,
            scope=scope,
            out_of_scope=out_of_scope,
            risks=risks,
            blockers=blockers,
            decisions=decisions,
            actions=actions,
            dependencies=dependencies,
            systems=systems,
            data_sources=data_sources,
            confidence=confidence,
            last_verified=last_verified,
            source_event=source_event,
            lifecycle_class=lifecycle_class,
            project_types=project_types,
            aliases=aliases,
            source_rows={source: str(row) for source, row in item["rows"].items()},
        )
        if selected_code and identity_key(selected_code) not in project.aliases:
            continue
        projects.append(project)

    projects.sort(key=lambda item: item.code.casefold())
    if selected_code and not projects:
        hard_stops.append(f"Project could not be resolved: {selected_code}")

    for project in projects:
        if project.folder.exists() and (project.folder / "00_Project_Home.md").exists():
            home_fm, _, _ = extract_frontmatter(read_text(project.folder / "00_Project_Home.md"))
            existing_code = fm_scalar(home_fm, "canonical_code", "project")
            if existing_code and identity_key(existing_code) not in project.aliases:
                hard_stops.append(
                    f"Workspace collision: {project.folder.relative_to(VAULT_ROOT)} belongs to {existing_code}, not {project.code}"
                )

    if selected_code is None:
        by_code = {project.code: project for project in projects}
        fd = by_code.get("FD.Datamart.v2.2")
        cpd = by_code.get("CPD.Datamart.v1.1")
        if not fd or not cpd:
            hard_stops.append("FD.Datamart.v2.2 and CPD.Datamart.v1.1 must both resolve as separate projects")
        elif fd.note_path == cpd.note_path or fd.folder == cpd.folder:
            hard_stops.append("FD.Datamart.v2.2 and CPD.Datamart.v1.1 resolve to the same note/workspace")
        sourcing_projects = [project for project in projects if "sourcingchatbot" in identity_key(project.code)]
        if len(sourcing_projects) != 1:
            hard_stops.append("Sourcing must remain one consolidated canonical project")
        ai_hub = [project for project in projects if identity_key(project.code) == identity_key("PPJ.AI.Hub.v2.1")]
        if len(ai_hub) != 1:
            hard_stops.append("PPJ.AI.Hub.v2.1 must resolve independently")

    if GLOBAL_CANVAS.exists():
        try:
            json.loads(read_text(GLOBAL_CANVAS))
        except json.JSONDecodeError as exc:
            hard_stops.append(f"Global Executive Canvas JSON is invalid: {exc}")

    assign_initial_tasks(projects)
    return projects, unique(hard_stops), unique(warnings)


def unique_paths(paths: Iterable[Path]) -> list[Path]:
    seen: set[Path] = set()
    result: list[Path] = []
    for path in paths:
        resolved = path.resolve()
        if resolved not in seen:
            seen.add(resolved)
            result.append(path)
    return result


def unique_cards(cards: Iterable[tuple[Path, dict[str, object], str]]) -> list[tuple[Path, dict[str, object], str]]:
    seen: set[Path] = set()
    result = []
    for card in cards:
        if card[0] not in seen:
            seen.add(card[0])
            result.append(card)
    return result


def first_nonempty(*values: str) -> str:
    for value in values:
        if value and value.strip() and value.strip().casefold() not in {"tbd", "none"}:
            return value.strip()
    return values[-1].strip() if values else ""


def first_list(*values: list[str]) -> list[str]:
    for value in values:
        if value:
            return unique(value)
    return []


def normalize_priority(value: str) -> str:
    match = re.search(r"\bP([0-3])\b", value.upper())
    return f"P{match.group(1)}" if match else "TBD"


def map_task_status(value: str, current_source: bool) -> str:
    text = value.strip().casefold().replace("-", "_").replace(" ", "_")
    if text in STATUS_TO_LANE:
        return text
    if any(term in text for term in ["done", "closed", "complete"]):
        return "done"
    if any(term in text for term in ["review", "uat", "acceptance"]):
        return "review"
    if "block" in text or "wait" in text:
        return "blocked"
    if "progress" in text or "doing" in text:
        return "in_progress"
    if "week" in text:
        return "this_week"
    if text in {"open", "active"}:
        return "this_week" if current_source else "backlog"
    return "backlog"


def task_title_from_text(text: str) -> str:
    text = re.sub(r"\[\[([^\]|]+)\|?([^\]]*)\]\]", lambda m: m.group(2) or m.group(1), text)
    text = re.sub(r"\s+", " ", text).strip().rstrip(".")
    return text[:100] or "Project action"


def task_limit(project: Project) -> int:
    if project.lifecycle_class.startswith("A") or project.lifecycle_class.startswith("B"):
        return 12
    if project.lifecycle_class.startswith("C"):
        return 6
    if project.lifecycle_class.startswith("F"):
        return 3
    return 5


def assign_initial_tasks(projects: list[Project]) -> None:
    global_tasks = []
    for path in sorted(GLOBAL_TASK_ROOT.glob("*.md")):
        text = read_text(path)
        fm, _, body = extract_frontmatter(text)
        project_value = fm_scalar(fm, "project")
        if not project_value:
            continue
        title_match = re.search(r"(?m)^#\s+(.+)$", body)
        title = title_match.group(1).strip() if title_match else path.stem
        source_event = fm_scalar(fm, "source_event")
        acceptance = first_nonempty(
            section_summary(body, ["Validation", "Acceptance"], ""),
            "Completion evidence is recorded and reviewed by the responsible owner.",
        )
        global_tasks.append(
            {
                "path": path,
                "project_key": identity_key(project_value),
                "title": title,
                "status": fm_scalar(fm, "status", default="backlog"),
                "priority": normalize_priority(fm_scalar(fm, "priority", default="TBD")),
                "owner": fm_scalar(fm, "owner", default="Needs Confirmation"),
                "due": fm_scalar(fm, "due"),
                "source_event": source_event,
                "acceptance": acceptance,
            }
        )
    for project in projects:
        planned: list[PlannedTask] = []
        seen_titles: set[str] = set()
        for item in global_tasks:
            if item["project_key"] not in project.aliases:
                continue
            title_key = identity_key(item["title"])
            if title_key in seen_titles:
                continue
            current_source = bool(project.source_event and item["source_event"] == project.source_event)
            planned.append(
                PlannedTask(
                    title=item["title"],
                    status=map_task_status(item["status"], current_source),
                    priority=item["priority"],
                    owner=item["owner"] or "Needs Confirmation",
                    due=item["due"],
                    acceptance=item["acceptance"],
                    source_event=item["source_event"] or project.source_event,
                    source_note=item["path"].relative_to(VAULT_ROOT).as_posix(),
                )
            )
            seen_titles.add(title_key)
        if not project.lifecycle_class.startswith("F"):
            for action in project.actions:
                if action.casefold().startswith("do not "):
                    continue
                title = task_title_from_text(action)
                title_key = identity_key(title)
                if title_key in seen_titles:
                    continue
                planned.append(
                    PlannedTask(
                        title=title,
                        status=(
                            "backlog"
                            if project.lifecycle_class.startswith(("D", "E", "G"))
                            else "this_week"
                            if project.priority in {"P0", "P1", "P2", "P3"}
                            else "backlog"
                        ),
                        priority=project.priority,
                        owner="Needs Confirmation",
                        due="",
                        acceptance="Completion evidence is recorded and reviewed by the responsible owner.",
                        source_event=project.source_event,
                    )
                )
                seen_titles.add(title_key)
        planned = planned[: task_limit(project)]
        task_prefix = slug_id(project.code)
        for index, task in enumerate(planned, start=1):
            task.task_id = f"{task_prefix}-TASK-{index:03d}"
            title_slug = re.sub(r"[^A-Za-z0-9]+", "-", task.title).strip("-")[:60]
            task.filename = f"{task.task_id}_{title_slug or 'action'}.md"
        project.tasks = planned


def extra_documents(project: Project) -> list[str]:
    extra: list[str] = []
    if "AI / Chatbot / Agent" in project.project_types:
        extra += [
            "06_Solution/AI_Behavior_and_Guardrails.md",
            "06_Solution/Knowledge_and_Tool_Sources.md",
        ]
    if "External / PoC" in project.project_types:
        extra += [
            "01_Management/PoC_Trial_Plan.md",
            "01_Management/Evaluation_Criteria.md",
            "10_Governance/Vendor_and_Commercial_Dependencies.md",
        ]
    if "Backlog Discovery" in project.project_types or "Decision / Re-scope" in project.project_types:
        extra += [
            "01_Management/Next_Gate.md",
            "02_Business/Discovery_Questions.md",
        ]
    if "Closeout" in project.project_types:
        extra += [
            "01_Management/Closeout_Summary.md",
            "01_Management/Lessons_Learned.md",
        ]
    return unique(extra)


def active_documents(project: Project) -> list[str]:
    """Return the lifecycle-activated document pack for a project.

    Existing documents outside this pack are preserved on disk and are never
    deleted. The activation list controls only creation and script-owned refresh.
    """
    lifecycle = project.lifecycle_class[:1]
    if lifecycle in {"A", "B"}:
        documents = BASE_DOCUMENTS
    elif lifecycle == "C":
        documents = PRODUCTION_DOCUMENTS
    elif lifecycle in {"D", "E"}:
        documents = DISCOVERY_DOCUMENTS
    elif lifecycle == "F":
        documents = CORE_DOCUMENTS + ["09_Operations/Support_and_Maintenance.md"]
    elif lifecycle == "G":
        documents = EXTERNAL_TRIAL_DOCUMENTS
    else:
        documents = CORE_DOCUMENTS
    return unique(documents + extra_documents(project))


def documentation_status(project: Project, relative_path: str) -> str:
    if project.lifecycle_class.startswith("D") or project.lifecycle_class.startswith("E"):
        if relative_path.startswith(("07_Test_UAT", "08_Implementation", "09_Operations")):
            return "Not Started / Pending Discovery"
    if project.lifecycle_class.startswith("G"):
        if relative_path.startswith(("07_Test_UAT", "08_Implementation", "09_Operations")):
            return "Not Approved / Trial Only"
    if project.lifecycle_class.startswith("F"):
        if relative_path.startswith(("02_Business", "03_Process", "04_Data", "05_Requirements", "06_Solution", "07_Test_UAT", "08_Implementation")):
            return "Closed / Reference Only"
    return "Current Working Document"


def doc_frontmatter(project: Project, doc_type: str, status: str) -> str:
    return "\n".join(
        [
            "---",
            f"type: {yaml_quote(doc_type)}",
            f"project: {yaml_quote(project.code)}",
            f"source_project: {yaml_quote(project.note_path.name)}",
            f"source_event: {yaml_quote(project.source_event)}",
            f"last_verified: {yaml_quote(project.last_verified)}",
            f"confidence: {yaml_quote(project.confidence)}",
            f"documentation_status: {yaml_quote(status)}",
            'generated_by: "upgrade_ppj_project_workspaces.py"',
            "---",
            "",
        ]
    )


def bullets(items: list[str], fallback: str = "- Needs Confirmation") -> str:
    return "\n".join(f"- {item}" for item in items) if items else fallback


def concise(items: list[str], count: int = 3, fallback: str = "Needs Confirmation") -> str:
    return "; ".join(items[:count]) if items else fallback


def workspace_navigation() -> str:
    return """### Management

- [[01_Management/Project_Profile]]
- [[01_Management/Project_Plan]]
- [[01_Management/Milestones]]
- [[01_Management/Weekly_Status]]

### Business

- [[02_Business/Business_Context]]
- [[02_Business/BRD]]
- [[02_Business/Scope_and_Business_Rules]]

### Process

- [[03_Process/AS_IS_Process]]
- [[03_Process/TO_BE_Process]]
- [[03_Process/Process_Gaps]]

### Data

- [[04_Data/Data_Spec]]
- [[04_Data/Data_Source_Inventory]]
- [[04_Data/Data_Quality_and_Traceability]]

### Requirements

- [[05_Requirements/Functional_Requirements]]
- [[05_Requirements/Use_Cases]]
- [[05_Requirements/Acceptance_Criteria]]

### Solution

- [[06_Solution/Solution_Overview]]
- [[06_Solution/Integration_Spec]]

### Test / UAT

- [[07_Test_UAT/UAT_Plan]]
- [[07_Test_UAT/UAT_Cases]]
- [[07_Test_UAT/Defect_Log]]

### Implementation

- [[08_Implementation/Implementation_Plan]]
- [[08_Implementation/Deployment_Checklist]]

### Operations

- [[09_Operations/User_Manual]]
- [[09_Operations/Support_and_Maintenance]]

### Governance

- [[10_Governance/Risks_Issues]]
- [[10_Governance/Decision_Log]]
- [[10_Governance/Dependencies]]
- [[10_Governance/Change_Log]]

### Project Board

- [[Project_Executive_Board]]
- [[Tasks]]
- [[Meetings]]
- [[Evidence]]"""


def render_project_home(project: Project) -> str:
    status = documentation_status(project, "00_Project_Home.md")
    ba = ", ".join(project.ba_coordination) or "Needs Confirmation"
    technical = ", ".join(project.technical_members) or "Needs Confirmation"
    root_link = f"[[../{project.note_path.stem}]]"
    return doc_frontmatter(project, "project_home", status) + f"""# {project.code}

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | {project.code} |
| Current File | {project.note_path.name} |
| Primary Domain | {project.primary_domain} |
| Secondary Domains | {project.secondary_domains} |
| Lifecycle | {project.lifecycle} |
| Progress | {project.progress} |
| Current Gate | {project.current_gate} |
| Priority | {project.priority} |
| Business Owner | {project.business_owner} |
| Primary Users | {project.primary_users} |
| BA / Coordination | {ba} |
| Technical Members | {technical} |
| Last Verified | {project.last_verified} |
| Confidence | {project.confidence} |

## One-Line Understanding

{project.understanding}

## Business Goal

{project.outcome}

## Current Outcome

{project.outcome}

## Latest Update

{project.latest_update}

## Current Scope

{bullets(project.scope)}

## Current Risks / Blockers

{bullets(unique(project.blockers + project.risks))}

## Decisions Needed

{bullets(project.decisions)}

## Next Actions

{bullets(project.actions)}

## Key Dependencies

{bullets(project.dependencies)}

## Current Deliverables

- Project profile and plan
- Business and requirements pack appropriate to lifecycle
- Data, process and solution documents where applicable
- Governance logs and operational task board

## Workspace Navigation

{workspace_navigation()}

## Source of Truth

Root Project Note:
{root_link}

Project Memory:
[[{project.memory_link}]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
"""


def render_document(project: Project, relative_path: str) -> str:
    if relative_path == "00_Project_Home.md":
        return render_project_home(project)
    status = documentation_status(project, relative_path)
    name = Path(relative_path).stem
    title = name.replace("_", " ")
    frontmatter = doc_frontmatter(project, name.casefold(), status)
    common_source = f"""## Evidence Basis

- Root project note: [[03_Projects/{project.note_path.stem}]]
- Project memory: [[{project.memory_link}]]
- Source event: {project.source_event}
- Last verified: {project.last_verified}
- Confidence: {project.confidence}
"""

    if relative_path == "01_Management/Project_Profile.md":
        body = f"""# Project Profile

## Identity

| Field | Value |
| --- | --- |
| Canonical Code | {project.code} |
| Physical Project Note | {project.note_path.name} |
| Primary Domain | {project.primary_domain} |
| Cluster | {project.cluster} |
| Lifecycle Class | {project.lifecycle_class} |
| Lifecycle | {project.lifecycle} |
| Current Gate | {project.current_gate} |
| Priority | {project.priority} |
| Business Owner | {project.business_owner} |

## One-Line Understanding

{project.understanding}

## Intended Outcome

{project.outcome}

## Users and Delivery Participants

- Primary users: {project.primary_users}
- BA / Coordination: {', '.join(project.ba_coordination) or 'Needs Confirmation'}
- Technical members: {', '.join(project.technical_members) or 'Needs Confirmation'}

## Current Scope

{bullets(project.scope)}

## Explicit Boundaries

{bullets(project.out_of_scope)}

## Current Gate and Next Move

- Gate: {project.current_gate}
- Next actions: {concise(project.actions, 5)}
"""
    elif relative_path == "01_Management/Project_Plan.md":
        body = f"""# Project Plan

## Planning Basis

- Lifecycle: {project.lifecycle}
- Current gate: {project.current_gate}
- Priority: {project.priority}
- Plan status: {status}

## Current Work Packages

1. Confirm scope, ownership and evidence.
2. Complete the current lifecycle gate.
3. Maintain task, risk, decision and dependency traceability.
4. Prepare only the next approved delivery or closeout step.

## Evidence-Based Next Actions

{bullets(project.actions)}

## Dependencies

{bullets(project.dependencies)}

## Planning Controls

- No unapproved scope expansion.
- No invented owner, date, source table or business rule.
- Each milestone requires evidence and responsible-owner confirmation.
"""
    elif relative_path == "01_Management/Milestones.md":
        body = f"""# Milestones

| Milestone | State | Evidence / Exit Condition | Owner | Target |
| --- | --- | --- | --- | --- |
| Current Gate: {project.current_gate} | Current | Gate evidence reviewed | Needs Confirmation | TBD |
| Next Approved Outcome | Planned | {project.outcome} | Needs Confirmation | TBD |
| Operational Handover or Closeout | Not Started | Acceptance, ownership and support confirmed | Needs Confirmation | TBD |

## Notes

Milestone dates remain TBD until confirmed by the responsible owner.
"""
    elif relative_path == "01_Management/Weekly_Status.md":
        body = f"""# Weekly Status

## Current Snapshot

- Lifecycle: {project.lifecycle}
- Progress: {project.progress}
- Gate: {project.current_gate}
- Priority: {project.priority}

## Latest Verified Update

{project.latest_update}

## Current Blockers

{bullets(project.blockers)}

## Decisions Needed

{bullets(project.decisions)}

## Next Actions

{bullets(project.actions)}

## Update Protocol

Weekly updates should change only affected project memory, home, tasks, risks, decisions and relevant working documents.
"""
    elif relative_path == "02_Business/Business_Context.md":
        body = f"""# Business Context

## Business Meaning

{project.understanding}

## Business Goal

{project.outcome}

## Primary Domain and Users

- Primary domain: {project.primary_domain}
- Primary users: {project.primary_users}
- Business owner: {project.business_owner}

## Current Context

{project.latest_update}

## Current Scope

{bullets(project.scope)}

## Known Boundaries

{bullets(project.out_of_scope)}

## Discovery Gaps

- Confirm unresolved ownership, current process, source of truth and measurable outcome.
- Retain TBD or Needs Confirmation where evidence is unavailable.
"""
    elif relative_path == "02_Business/BRD.md":
        body = f"""# Business Requirements Document

## Executive Summary

{project.understanding}

## Business Problem

Needs Confirmation from the current project evidence and responsible business users.

## Objectives

- {project.outcome}

## Users / Stakeholders

- Primary users: {project.primary_users}
- Business owner: {project.business_owner}
- BA / Coordination: {', '.join(project.ba_coordination) or 'Needs Confirmation'}

## Current Process

Needs Confirmation. See [[../03_Process/AS_IS_Process]].

## Pain Points

{bullets(project.risks)}

## Target Process

See [[../03_Process/TO_BE_Process]]. Target flow remains subject to current-gate approval.

## Scope

{bullets(project.scope)}

## Out of Scope

{bullets(project.out_of_scope)}

## Business Requirements

- Deliver the verified project outcome without unapproved scope expansion.
- Preserve review, exception, evidence and traceability controls appropriate to the project type.
- Confirm any missing rule with the responsible business owner.

## Business Rules

See [[Scope_and_Business_Rules]]. Unconfirmed rules remain Needs Confirmation.

## Data Requirements Summary

See [[../04_Data/Data_Spec]] and [[../04_Data/Data_Source_Inventory]].

## Integration Summary

See [[../06_Solution/Integration_Spec]]. No direct transactional write is assumed.

## AI / Automation Scope

Applicable only where confirmed in the project memory, project note or approved update.

## Human Validation

Responsible users must validate outputs before business decisions or transactions when automation or AI is involved.

## Exception / Fallback

Unresolved exceptions must be logged, assigned and handled through an approved manual or system fallback.

## KPI / Measurable Outcome

Needs Confirmation.

## Risks

{bullets(project.risks)}

## Assumptions

- Registry, memory and root project note remain the source of truth.
- Unverified details are not treated as approved requirements.

## Dependencies

{bullets(project.dependencies)}

## Decisions Required

{bullets(project.decisions)}

## Acceptance Summary

See [[../05_Requirements/Acceptance_Criteria]]. Formal acceptance owner and evidence remain Needs Confirmation unless explicitly recorded.
"""
    elif relative_path == "02_Business/Scope_and_Business_Rules.md":
        body = f"""# Scope and Business Rules

## In Scope

{bullets(project.scope)}

## Out of Scope

{bullets(project.out_of_scope)}

## Confirmed Business Rules

- Only rules explicitly supported by the root note, memory, approved weekly update or decision log are confirmed.

## Rules Requiring Confirmation

- Ownership, thresholds, dates, field logic and system behavior not present in current evidence.

## Change Control

Any scope or rule change must include source event, decision owner, impact and effective date.
"""
    elif relative_path == "03_Process/AS_IS_Process.md":
        body = f"""# AS-IS Process

## Status

{status}

## Current Process

Needs Confirmation. Current project evidence does not provide a complete approved AS-IS sequence.

## Known Current Context

{project.latest_update}

## Required Discovery

- Actors and responsibilities
- Trigger and input
- Current steps and systems
- Manual checks and exceptions
- Output and evidence
- Current cycle time and pain points
"""
    elif relative_path == "03_Process/TO_BE_Process.md":
        body = f"""# TO-BE Process

## Status

{status}

## Target Outcome

{project.outcome}

## Proposed Control Pattern

Business Input -> Validation -> Approved Processing / Analysis -> Human Review where required -> Output -> Evidence and Audit Trace

## Approval Boundary

This pattern is not an approved detailed process until business actors, rules, system boundaries and acceptance evidence are confirmed.
"""
    elif relative_path == "03_Process/Process_Gaps.md":
        body = """# Process Gaps

| Step | Current Problem | Root Cause | Impact | Proposed Change | Owner | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| TBD | Needs Confirmation | Needs Confirmation | Needs Confirmation | Complete process discovery | Needs Confirmation | Needs Confirmation |
"""
    elif relative_path == "04_Data/Data_Spec.md":
        body = f"""# Data Specification

## Architecture Separation

Business Source -> Data Warehouse / Data Platform -> Target Application

These layers must remain conceptually separate. WFX, Databricks and the governed Data Warehouse are not interchangeable.

## Known Systems

{bullets(project.systems)}

## Field-Level Specification

| Business Object | Field | Business Definition | Source System | Source Table / API if confirmed | Source Field | Grain | Transformation | Target Field | Owner | Data Quality Rule | Traceability | Confidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Link to source evidence | Needs Confirmation |

## Source Table Rule

No WFX table, Databricks schema, warehouse table or API is assumed. Unknown source tables remain Needs Confirmation.
"""
    elif relative_path == "04_Data/Data_Source_Inventory.md":
        rows = project.data_sources or ["Needs Confirmation"]
        table = "\n".join(
            f"| {source} | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Project memory / root note |"
            for source in rows[:10]
        )
        body = f"""# Data Source Inventory

| Business Source / Dataset | Source System | Owner | Access Method | Refresh / Period | Evidence |
| --- | --- | --- | --- | --- | --- |
{table}

## Platform Boundary

- Business source: operational or approved business evidence.
- Data platform / warehouse: governed storage or processing layer if confirmed.
- Target application: report, portal, bot, workflow or analysis output.
"""
    elif relative_path == "04_Data/Data_Quality_and_Traceability.md":
        body = f"""# Data Quality and Traceability

## Required Controls

- Source identity and owner
- Extraction or event timestamp
- Grain and business key
- Completeness and duplicate checks
- Mapping and transformation evidence
- Exception retention
- Output-to-source traceability
- Approval evidence where required

## Known Risks

{bullets(project.risks)}

## Current Confidence

{project.confidence}
"""
    elif relative_path == "05_Requirements/Functional_Requirements.md":
        body = f"""# Functional Requirements

| ID | Requirement | Source | Priority | Status |
| --- | --- | --- | --- | --- |
| FR-001 | Support the verified current outcome: {project.outcome} | Project memory / root note | {project.priority} | Needs Confirmation |
| FR-002 | Record validation, exception and traceability evidence appropriate to the project | Governance standard | P1 | Needs Confirmation |
| FR-003 | Restrict unapproved actions, data access and scope changes | Governance standard | P1 | Needs Confirmation |

## Requirement Control

Detailed requirements must be approved by business users and linked to use cases and acceptance criteria.
"""
    elif relative_path == "05_Requirements/Use_Cases.md":
        body = f"""# Use Cases

## UC-001 — Deliver Current Project Outcome

- **Use Case ID:** UC-001
- **Name:** Deliver verified project outcome
- **Actor:** {project.primary_users}
- **Trigger:** Approved business need or current task
- **Preconditions:** Scope, access and responsible owner are confirmed
- **Postconditions:** Output and evidence are recorded
- **User Action:** Provide approved input and request the supported outcome
- **System Response:** Validate input, process only approved scope and return a traceable result
- **Main Flow:** Input -> Validation -> Processing -> Review -> Output -> Evidence
- **Alternative Flow:** Missing information is returned for correction or confirmation
- **Exception Flow:** Blocked or invalid processing is logged and routed to fallback
- **Data:** See [[../04_Data/Data_Spec]]
- **Business Rules:** See [[../02_Business/Scope_and_Business_Rules]]
- **AI Behavior if relevant:** See AI guardrails when present; otherwise Not Applicable
"""
    elif relative_path == "05_Requirements/Acceptance_Criteria.md":
        body = f"""# Acceptance Criteria

| ID | Criterion | Evidence | Owner | Status |
| --- | --- | --- | --- | --- |
| AC-001 | Current scope and outcome are approved | Project note / decision record | {project.business_owner} | Needs Confirmation |
| AC-002 | Output can be traced to approved input and source evidence | Test / audit evidence | Needs Confirmation | Needs Confirmation |
| AC-003 | Exceptions and fallback are handled without silent data loss | UAT evidence | Needs Confirmation | Needs Confirmation |
| AC-004 | Required permissions and human validation are enforced | Access / UAT evidence | Needs Confirmation | Needs Confirmation |
| AC-005 | Responsible owner accepts the result for the current lifecycle gate | Acceptance record | Needs Confirmation | Needs Confirmation |
"""
    elif relative_path == "06_Solution/Solution_Overview.md":
        body = f"""# Solution Overview

## Purpose

{project.outcome}

## Current Solution Boundary

- Project type: {', '.join(project.project_types)}
- Known systems: {', '.join(project.systems) or 'Needs Confirmation'}
- Current gate: {project.current_gate}

## Logical Flow

Approved Input -> Validation -> Approved Service / Data Processing -> Business Review -> Output -> Logging and Evidence

## Non-Assumptions

- No direct transactional database write is assumed.
- No unconfirmed API, table, model, device or vendor capability is treated as implemented.
- WFX, Databricks and Data Warehouse responsibilities remain separate.
"""
    elif relative_path == "06_Solution/Integration_Spec.md":
        transaction = "Transaction Automation" in project.project_types
        body = f"""# Integration Specification

## Integration Status

{status}

## Known Systems and Dependencies

- Systems: {', '.join(project.systems) or 'Needs Confirmation'}
- Dependencies: {concise(project.dependencies, 8)}

## Required Integration Contract

| Area | Requirement | Current Evidence |
| --- | --- | --- |
| Trigger | Define approved event, schedule or user action | Needs Confirmation |
| API / Service | Use approved API or service boundary | Needs Confirmation |
| Validation | Validate identity, input, state and business rules | Needs Confirmation |
| Idempotency | Prevent duplicate processing where transactions are involved | {'Required' if transaction else 'Assess Applicability'} |
| Approval | Define human/system approval boundary | Needs Confirmation |
| Rollback | Define safe reversal or compensation | {'Required' if transaction else 'Assess Applicability'} |
| Exception Handling | Log, route and retry only through approved behavior | Needs Confirmation |
| Audit Log | Retain request, result, actor, timestamp and status | Required |
| Fallback | Preserve approved manual or support path | Needs Confirmation |

## Transaction Safety Rule

A direct database write is not assumed to update a transactional system. WFX changes require an approved API or vendor-supported transactional service.
"""
    elif relative_path == "07_Test_UAT/UAT_Plan.md":
        body = f"""# UAT Plan

## Status

{status}

## Objective

Validate the current approved outcome, rules, data, permissions, exception behavior and traceability with responsible business users.

## Entry Criteria

- Approved scope and test data
- Confirmed users and owner
- Testable solution or deliverable
- Known acceptance criteria

## Exit Criteria

- Critical scenarios executed
- Defects recorded and dispositioned
- Exceptions and fallback validated
- Acceptance decision recorded
"""
    elif relative_path == "07_Test_UAT/UAT_Cases.md":
        body = """# UAT Cases

| Case ID | Scenario | Preconditions | User Action | Expected System Response | Evidence | Status |
| --- | --- | --- | --- | --- | --- | --- |
| UAT-001 | Approved main flow | Needs Confirmation | Execute approved scenario | Traceable expected output | TBD | Not Started |
| UAT-002 | Missing or invalid input | Needs Confirmation | Submit invalid/incomplete input | Validation and safe fallback | TBD | Not Started |
| UAT-003 | Permission or approval boundary | Needs Confirmation | Attempt restricted action | Access is denied or routed for approval | TBD | Not Started |
"""
    elif relative_path == "07_Test_UAT/Defect_Log.md":
        body = """# Defect Log

| Defect ID | Date | Summary | Severity | Status | Owner | Evidence | Resolution |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | No defect evidence recorded in this workspace yet | TBD | Not Started | Needs Confirmation | TBD | TBD |
"""
    elif relative_path == "08_Implementation/Implementation_Plan.md":
        body = f"""# Implementation Plan

## Status

{status}

## Implementation Preconditions

- Current gate approved
- Scope and ownership confirmed
- Data and integration boundaries confirmed
- UAT evidence accepted
- Deployment and rollback responsibility assigned

## Planned Steps

1. Confirm release or implementation scope.
2. Prepare environment, data, permissions and support ownership.
3. Execute controlled implementation.
4. Validate business output and monitoring.
5. Record evidence, issues and decision.
"""
    elif relative_path == "08_Implementation/Deployment_Checklist.md":
        body = """# Deployment Checklist

- [ ] Approved release scope
- [ ] Business owner confirmed
- [ ] Technical owner confirmed
- [ ] Access and permissions validated
- [ ] Data source and refresh validated
- [ ] Integration contract validated
- [ ] UAT acceptance recorded
- [ ] Backup / rollback or compensation plan ready
- [ ] Logging and monitoring ready
- [ ] Support and fallback communicated
- [ ] Post-deployment validation completed
"""
    elif relative_path == "09_Operations/User_Manual.md":
        body = f"""# User Manual

## Status

{status}

## Intended Users

{project.primary_users}

## Current Capability

{project.understanding}

## Operating Steps

Needs Confirmation. Detailed steps must be validated against the implemented interface or approved manual process.

## Exceptions and Support

- Stop on validation or permission errors.
- Use the approved fallback.
- Record evidence and contact the confirmed support owner.
"""
    elif relative_path == "09_Operations/Support_and_Maintenance.md":
        body = f"""# Support and Maintenance

## Current Lifecycle

{project.lifecycle}

## Support Ownership

- Business owner: {project.business_owner}
- Technical owner: {', '.join(project.technical_members) or 'Needs Confirmation'}
- Support SLA: Needs Confirmation

## Maintenance Scope

- Defect correction
- Data or configuration correction where approved
- Permission and access support
- Monitoring and audit review
- Enhancement intake through change control

## Current Support Risks

{bullets(project.risks)}
"""
    elif relative_path == "10_Governance/Risks_Issues.md":
        rows = unique(project.blockers + project.risks) or ["Needs Confirmation"]
        table = "\n".join(
            f"| RISK-{index:03d} | {item} | Needs Confirmation | Needs Confirmation | Open | {project.source_event} |"
            for index, item in enumerate(rows, start=1)
        )
        body = f"""# Risks and Issues

| ID | Risk / Issue | Impact | Owner | Status | Source |
| --- | --- | --- | --- | --- | --- |
{table}
"""
    elif relative_path == "10_Governance/Decision_Log.md":
        rows = project.decisions or ["Needs Confirmation"]
        table = "\n".join(
            f"| DEC-{index:03d} | {item} | Open | Needs Confirmation | TBD | {project.source_event} |"
            for index, item in enumerate(rows, start=1)
        )
        body = f"""# Decision Log

| Decision ID | Decision Needed | Status | Decision Owner | Decision / Date | Source |
| --- | --- | --- | --- | --- | --- |
{table}
"""
    elif relative_path == "10_Governance/Dependencies.md":
        rows = project.dependencies or ["Needs Confirmation"]
        table = "\n".join(
            f"| DEP-{index:03d} | {item} | Needs Confirmation | Open | {project.source_event} |"
            for index, item in enumerate(rows, start=1)
        )
        body = f"""# Dependencies

| Dependency ID | Dependency | Owner | Status | Source |
| --- | --- | --- | --- | --- |
{table}
"""
    elif relative_path == "10_Governance/Change_Log.md":
        body = f"""# Change Log

| Date | Change | Source Event | Confidence | Author / Owner |
| --- | --- | --- | --- | --- |
| {TODAY} | Project workspace baseline planned/created | {project.source_event} | {project.confidence} | PPJ workspace automation |
"""
    elif relative_path == "06_Solution/AI_Behavior_and_Guardrails.md":
        body = f"""# AI Behavior and Guardrails

## AI Scope

{project.understanding}

## Required Controls

- Prompt / input contract: Needs Confirmation
- Output contract: Needs Confirmation
- Confidence representation: Required where model output is uncertain
- Human validation: Mandatory for decisions, transactions and sensitive outputs
- Fallback: Approved non-AI or human-review path
- Tool execution: Explicit permission, parameter validation and audit logging
- Permissions: Least privilege and project/domain access boundaries
- Auditability: Input, output, tool call, actor, timestamp and result status
- Hallucination control: Ground answers in approved knowledge and return Needs Confirmation when evidence is absent

## Prohibited Behavior

- Inventing business rules, owners, data or implementation status
- Executing unapproved transactions
- Bypassing permissions or human validation
- Presenting uncertain output as confirmed fact
"""
    elif relative_path == "06_Solution/Knowledge_and_Tool_Sources.md":
        body = f"""# Knowledge and Tool Sources

## Approved Knowledge Sources

- Root project note: [[../{project.note_path.stem}]]
- Project memory: [[{project.memory_link}]]
- Registry and approved update ledger
- Project-specific approved documents and evidence

## Known Systems / Tools

{bullets(project.systems)}

## Source Controls

| Source / Tool | Purpose | Permission Owner | Freshness | Confidence |
| --- | --- | --- | --- | --- |
| Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation |

## Tool Execution Contract

Every tool call requires approved purpose, validated input, permission, observable result, error handling and audit record.
"""
    elif relative_path == "01_Management/PoC_Trial_Plan.md":
        body = f"""# PoC / Trial Plan

## Trial Status

{project.lifecycle}

## Trial Objective

{project.outcome}

## Scope Boundary

This is an evaluation or trial. It is not approved production implementation unless a formal decision says otherwise.

## Trial Inputs

Needs Confirmation: sample set, users, environment, vendor responsibilities and evidence.

## Evaluation Outputs

- Business fit
- Technical feasibility
- Accuracy / quality evidence where applicable
- Security and data handling
- User workflow fit
- Commercial and support implications
- Go / No-Go recommendation
"""
    elif relative_path == "01_Management/Evaluation_Criteria.md":
        body = """# Evaluation Criteria

| Criterion | Measure | Evidence | Threshold | Owner | Status |
| --- | --- | --- | --- | --- | --- |
| Business fit | Confirmed use case and user value | Trial evidence | Needs Confirmation | Needs Confirmation | Not Started |
| Technical feasibility | Integration, operation and support viability | Technical assessment | Needs Confirmation | Needs Confirmation | Not Started |
| Quality / accuracy | Agreed sample results | Evaluation dataset | Needs Confirmation | Needs Confirmation | Not Started |
| Security / data | Approved handling and ownership | Security review | Required | Needs Confirmation | Not Started |
| Commercial viability | Cost, licensing and support model | Vendor proposal | Needs Confirmation | Needs Confirmation | Not Started |
"""
    elif relative_path == "10_Governance/Vendor_and_Commercial_Dependencies.md":
        body = f"""# Vendor and Commercial Dependencies

## Current Dependencies

{bullets(project.dependencies)}

## Required Confirmation

- Vendor role and accountable contact
- Trial versus production scope
- Data ownership and retention
- Model / IP ownership where relevant
- Licensing, cloud, hardware and support cost
- Post-trial operating model
- Exit and data-return terms
"""
    elif relative_path == "01_Management/Next_Gate.md":
        body = f"""# Next Gate

## Current Gate

{project.current_gate}

## Gate Decision

Needs Confirmation.

## Required Evidence

- Business owner and users confirmed
- Problem and outcome validated
- Scope and boundaries agreed
- Data/source and dependency inventory completed
- Delivery or reactivation resources confirmed
- Decision recorded

## Proposed Next Actions

{bullets(project.actions)}
"""
    elif relative_path == "02_Business/Discovery_Questions.md":
        body = """# Discovery Questions

## Business

- What business problem and decision must this project support?
- Who owns the outcome and who performs the current process?
- What is the minimum approved scope and measurable outcome?

## Process

- What triggers the process and what evidence is produced?
- Where are manual checks, delays, exceptions and approvals?

## Data and Systems

- What is the approved business source and source owner?
- What are the grain, keys, refresh, access and quality constraints?
- Which system is the target, and what approved integration exists?

## Governance

- What permissions, fallback, acceptance and support model are required?
"""
    elif relative_path == "01_Management/Closeout_Summary.md":
        body = f"""# Closeout Summary

## Closeout Status

{project.lifecycle}

## Delivered or Preserved Outcome

{project.outcome}

## Evidence Status

Needs Confirmation. Record delivered capability, acceptance, support boundary and unresolved follow-up without creating new active scope.

## Remaining Actions

{bullets(project.actions, '- No active tasks unless explicitly supported by current evidence.')}
"""
    elif relative_path == "01_Management/Lessons_Learned.md":
        body = """# Lessons Learned

## What Worked

Needs Confirmation.

## What Did Not Work

Needs Confirmation.

## Reusable Guidance

- Preserve evidence and decision rationale.
- Do not reactivate a closed project without approval.
- Separate support, enhancement and new-project scope.
"""
    else:
        body = f"# {title}\n\nStatus: {status}\n\nNeeds Confirmation.\n"
    return frontmatter + body.rstrip() + "\n\n" + common_source.rstrip() + "\n"


def render_task(project: Project, task: PlannedTask) -> str:
    due = task.due or ""
    return f"""---
type: project_task
project: {yaml_quote(project.code)}
task_id: {yaml_quote(task.task_id)}
title: {yaml_quote(task.title)}
status: {task.status}
priority: {task.priority}
owner: {yaml_quote(task.owner or 'Needs Confirmation')}
due: {yaml_quote(due)}
source_event: {yaml_quote(task.source_event)}
created: {TODAY}
updated: {TODAY}
blocked_by: []
depends_on: []
acceptance: {yaml_quote(task.acceptance)}
---

# {task.title}

## Project

[[../00_Project_Home|{project.code}]]

## Acceptance

{task.acceptance}

## Source

- Source event: {task.source_event}
- Imported source task: {task.source_note or 'Project memory / root project note'}

## Notes

TBD
"""


def board_node_id(prefix: str, value: str) -> str:
    digest = hashlib.sha1(value.encode("utf-8")).hexdigest()[:12]
    return f"{prefix}-{digest}"


def build_project_board(project: Project, tasks: list[PlannedTask] | None = None) -> dict[str, object]:
    tasks = tasks if tasks is not None else project.tasks
    nodes: list[dict[str, object]] = []
    summary_text = (
        f"{project.code}\n\n"
        f"Domain:\n{project.primary_domain}\n\n"
        f"Lifecycle:\n{project.lifecycle}\n\n"
        f"Progress:\n{project.progress}\n\n"
        f"Gate:\n{project.current_gate}\n\n"
        f"Outcome:\n{project.outcome}\n\n"
        f"Top Blocker:\n{(project.blockers or ['Needs Confirmation'])[0]}\n\n"
        f"Next Milestone:\n{(project.actions or ['Needs Confirmation'])[0]}\n\n"
        f"Last Verified:\n{project.last_verified}"
    )
    nodes.append(
        {
            "id": "ppj-board-metadata",
            "type": "text",
            "text": f"{project.code} — Executive Project Board\nBoard schema: PPJ_PROJECT_BOARD_V1",
            "x": 0,
            "y": -220,
            "width": 760,
            "height": 100,
            "color": "6",
        }
    )
    nodes.append(
        {
            "id": "ppj-exec-summary",
            "type": "text",
            "text": summary_text,
            "x": 0,
            "y": -90,
            "width": 760,
            "height": 560,
            "color": "4",
        }
    )
    attention = (
        "KEY MANAGEMENT ATTENTION\n\n"
        "Top Risks\n"
        + "\n".join(f"- {item}" for item in (project.risks[:3] or ["Needs Confirmation"]))
        + "\n\nDecisions Needed\n"
        + "\n".join(f"- {item}" for item in (project.decisions[:3] or ["Needs Confirmation"]))
        + "\n\nExternal Dependencies\n"
        + "\n".join(f"- {item}" for item in (project.dependencies[:3] or ["Needs Confirmation"]))
    )
    nodes.append(
        {
            "id": "ppj-management-attention",
            "type": "text",
            "text": attention,
            "x": 810,
            "y": -90,
            "width": 500,
            "height": 560,
            "color": "1",
        }
    )
    column_width = 300
    column_gap = 50
    group_y = 560
    tasks_by_lane: dict[str, list[PlannedTask]] = {lane: [] for lane in LANE_ORDER}
    for task in tasks:
        tasks_by_lane[STATUS_TO_LANE[task.status]].append(task)
    for lane_index, lane in enumerate(LANE_ORDER):
        lane_tasks = sorted(
            tasks_by_lane[lane],
            key=lambda item: (PRIORITY_ORDER.get(item.priority, 9), item.title.casefold()),
        )
        x = lane_index * (column_width + column_gap)
        height = max(500, 100 + len(lane_tasks) * 190)
        nodes.append(
            {
                "id": board_node_id("ppj-lane", lane),
                "type": "group",
                "x": x,
                "y": group_y,
                "width": column_width,
                "height": height,
                "label": lane,
                "color": str((lane_index % 6) + 1),
            }
        )
        for task_index, task in enumerate(lane_tasks):
            task_link = f"[[Tasks/{Path(task.filename).stem}]]"
            card_text = (
                f"{task_link}\n\n"
                f"{task.title}\n\n"
                f"Priority: {task.priority}\n"
                f"Owner: {task.owner or 'Needs Confirmation'}\n"
                f"Due: {task.due or 'TBD'}\n\n"
                f"Acceptance\n- {task.acceptance}"
            )
            nodes.append(
                {
                    "id": board_node_id("ppj-task", task.task_id),
                    "type": "text",
                    "text": card_text,
                    "x": x + 20,
                    "y": group_y + 70 + task_index * 190,
                    "width": 260,
                    "height": 155,
                }
            )
    board = {
        "nodes": nodes,
        "edges": [],
        "metadata": {
            "version": "1.0-1.0",
            "frontmatter": {
                "project": project.code,
                "board_type": "project_executive_kanban",
                "last_verified": project.last_verified,
            },
        },
    }
    validate_project_board(board)
    return board


def validate_project_board(board: dict[str, object]) -> None:
    serialized = json.dumps(board, ensure_ascii=False)
    json.loads(serialized)
    node_ids: set[str] = set()
    task_ids: set[str] = set()
    for node in board.get("nodes", []):
        node_id = str(node.get("id", ""))
        if node_id in node_ids:
            raise ValueError(f"Duplicate Canvas node id: {node_id}")
        node_ids.add(node_id)
        if node_id.startswith("ppj-task-"):
            if node_id in task_ids:
                raise ValueError(f"Canvas task appears more than once: {node_id}")
            task_ids.add(node_id)


def root_workspace_section(project: Project) -> str:
    return f"""## Project Workspace

Workspace:
[[{project.folder_name}/00_Project_Home]]

Executive Board:
[[{project.folder_name}/Project_Executive_Board]]

Tasks:
[[{project.folder_name}/Tasks]]

Governance:
[[{project.folder_name}/10_Governance/Decision_Log]]
"""


def update_root_note_content(project: Project, original: str) -> tuple[str, bool, str]:
    start = "<!-- PPJ_PROJECT_KNOWLEDGE_START -->"
    end = "<!-- PPJ_PROJECT_KNOWLEDGE_END -->"
    if start not in original or end not in original:
        return original, False, "Managed project knowledge block is missing"
    start_index = original.index(start) + len(start)
    end_index = original.index(end, start_index)
    block = original[start_index:end_index]
    section = root_workspace_section(project).rstrip()
    section_pattern = re.compile(r"(?ms)^## Project Workspace\s*$.*?(?=^##\s+|\Z)")
    if section_pattern.search(block):
        new_block = section_pattern.sub(section, block, count=1)
    else:
        new_block = block.rstrip() + "\n\n" + section + "\n"
    updated = original[:start_index] + new_block + original[end_index:]
    return updated, updated != original, ""


def command_center_workspace_block(projects: list[Project]) -> str:
    rows = []
    for project in projects:
        open_tasks = sum(task.status != "done" for task in project.tasks)
        blocked_tasks = sum(task.status == "blocked" for task in project.tasks)
        rows.append(
            f"| [[{project.note_path.stem}|{project.code}]] | {project.lifecycle} | "
            f"[[{project.folder_name}/00_Project_Home|Workspace]] | "
            f"[[{project.folder_name}/Project_Executive_Board|Board]] | {open_tasks} | {blocked_tasks} | {TODAY} |"
        )
    return "\n".join(
        [
            "## Project Workspaces",
            "",
            "| Project | Lifecycle | Workspace | Executive Board | Open Tasks | Blocked | Last Sync |",
            "| --- | --- | --- | --- | ---: | ---: | --- |",
            *rows,
        ]
    )


def registry_workspace_block(projects: list[Project]) -> str:
    rows = []
    for project in projects:
        open_tasks = sum(task.status != "done" for task in project.tasks)
        blocked_tasks = sum(task.status == "blocked" for task in project.tasks)
        rows.append(
            f"| {project.code} | {project.note_path.name} | 03_Projects/{project.folder_name} | "
            f"03_Projects/{project.folder_name}/Project_Executive_Board.canvas | Workspace Created | "
            f"{open_tasks} | {blocked_tasks} | {TODAY} |"
        )
    return "\n".join(
        [
            "## Project Workspace Registry Overlay",
            "",
            "| Canonical Code | Current File | Workspace | Project Board | Documentation Status | Open Task Count | Blocked Task Count | Last Workspace Sync |",
            "| --- | --- | --- | --- | --- | ---: | ---: | --- |",
            *rows,
        ]
    )


def agents_workspace_protocol() -> str:
    return """## Project Workspace Registration and Update Protocol

When a newly approved canonical project is registered, create the root project note, project memory card, registry/index entry, right-sized project workspace, Tasks folder, local Executive Project Board, workspace links, and optional portfolio Canvas card in one approved Apply pipeline.

Registration pipeline:

New Project Information -> Canonical Resolution -> Registration Proposal -> Approval -> Root Project Note -> Memory -> Registry -> Workspace -> Documentation Pack -> Initial Tasks -> Project Executive Board -> Portfolio Canvas

When the user provides a project update or weekly report:

1. Identify affected canonical projects.
2. Update project memory and the root project note.
3. Update only relevant workspace documents.
4. Create, move, close or block tasks only when justified.
5. Update Risks / Issues and Decision Log where relevant.
6. Synchronize the local Project Executive Board.
7. Update the Registry.
8. Update portfolio Canvas only when lifecycle, outcome or domain changes.

A blocker update normally changes Memory, Project Home, Risks / Issues, the relevant task and the local Project Board. It does not rewrite the BRD, Data Spec or User Manual unless requirements changed.
"""


def registration_protocol_workspace_content() -> str:
    return """## Automatic Project Workspace Assets

After canonical approval and Apply authorization, registration creates:

1. Root project note.
2. Project memory card.
3. Registry and memory-index entry.
4. Project workspace folder named after the current physical project-note basename.
5. Right-sized baseline documentation pack.
6. Tasks folder and evidence-based initial tasks.
7. Project_Executive_Board.canvas.
8. Root-note and memory workspace links.
9. Optional portfolio Canvas card or project-board reference.

Do not require a separate workspace-creation request after project registration approval.

## Future Update Routing

New update -> canonical resolution -> memory/root update -> affected workspace documents -> task changes -> local board sync -> registry update -> portfolio Canvas only for lifecycle/outcome/domain change.
"""


def global_canvas_update_plan(projects: list[Project]) -> tuple[int, list[str]]:
    if not GLOBAL_CANVAS.exists():
        return 0, ["Global Executive Canvas is missing"]
    try:
        canvas = json.loads(read_text(GLOBAL_CANVAS))
    except json.JSONDecodeError as exc:
        return 0, [f"Global Executive Canvas JSON invalid: {exc}"]
    project_files = {f"03_Projects/{project.note_path.name}": project for project in projects}
    existing_links = {
        node.get("id")
        for node in canvas.get("nodes", [])
        if isinstance(node, dict) and str(node.get("id", "")).startswith("ppj-project-board-link-")
    }
    count = 0
    warnings = []
    for node in canvas.get("nodes", []):
        if not isinstance(node, dict) or node.get("type") != "file":
            continue
        project = project_files.get(node.get("file"))
        if not project:
            continue
        link_id = board_node_id("ppj-project-board-link", project.code)
        if link_id not in existing_links:
            count += 1
    missing_cards = [
        project.code
        for project in projects
        if not any(
            isinstance(node, dict)
            and node.get("type") == "file"
            and node.get("file") == f"03_Projects/{project.note_path.name}"
            for node in canvas.get("nodes", [])
        )
    ]
    if missing_cards:
        warnings.append("No existing global project card for: " + ", ".join(missing_cards))
    return count, warnings


def update_global_canvas(projects: list[Project]) -> tuple[str, int]:
    canvas = json.loads(read_text(GLOBAL_CANVAS))
    nodes = canvas.setdefault("nodes", [])
    project_files = {f"03_Projects/{project.note_path.name}": project for project in projects}
    existing_ids = {str(node.get("id", "")) for node in nodes if isinstance(node, dict)}
    created = 0
    for node in list(nodes):
        if not isinstance(node, dict) or node.get("type") != "file":
            continue
        project = project_files.get(node.get("file"))
        if not project:
            continue
        link_id = board_node_id("ppj-project-board-link", project.code)
        if link_id in existing_ids:
            continue
        nodes.append(
            {
                "id": link_id,
                "type": "text",
                "text": f"Project Board: [[03_Projects/{project.folder_name}/Project_Executive_Board]]",
                "x": int(node.get("x", 0)),
                "y": int(node.get("y", 0)) + int(node.get("height", 120)) + 4,
                "width": int(node.get("width", 340)),
                "height": 34,
                "color": "6",
            }
        )
        existing_ids.add(link_id)
        created += 1
    serialized = json.dumps(canvas, ensure_ascii=False, indent=2)
    json.loads(serialized)
    return serialized, created


def planned_files(project: Project) -> tuple[list[Path], list[Path], list[Path]]:
    documents = [project.folder / item for item in active_documents(project)]
    tasks = [project.folder / "Tasks" / task.filename for task in project.tasks]
    boards = [project.folder / "Project_Executive_Board.canvas"]
    return documents, tasks, boards


def build_plan(projects: list[Project], hard_stops: list[str], warnings: list[str]) -> dict[str, object]:
    workspace_create = [project for project in projects if not project.folder.exists()]
    workspace_existing = [project for project in projects if project.folder.exists()]
    markdown_create: list[Path] = []
    markdown_preserve: list[Path] = []
    boards_create: list[Path] = []
    root_updates = 0
    memory_updates = 0
    per_project = []
    for project in projects:
        try:
            build_project_board(project)
        except Exception as exc:  # noqa: BLE001 - Canvas validation must become a hard stop
            hard_stops.append(f"Proposed Canvas validation failed for {project.code}: {exc}")
        documents, tasks, boards = planned_files(project)
        active_relative = set(active_documents(project))
        inactive_existing = [
            project.folder / item
            for item in unique(BASE_DOCUMENTS + extra_documents(project))
            if item not in active_relative and (project.folder / item).exists()
        ]
        create_docs = [path for path in documents + tasks if not path.exists()]
        preserve_docs = [path for path in documents + tasks if path.exists()]
        create_boards = [path for path in boards if not path.exists()]
        markdown_create.extend(create_docs)
        markdown_preserve.extend(preserve_docs)
        boards_create.extend(create_boards)
        _, root_changed, root_warning = update_root_note_content(project, read_text(project.note_path))
        if root_changed:
            root_updates += 1
        elif root_warning:
            warnings.append(f"{project.code}: {root_warning}; root note would be preserved")
        memory_updates += 1
        per_project.append(
            {
                "code": project.code,
                "note": project.note_path.name,
                "workspace": project.folder.relative_to(VAULT_ROOT).as_posix(),
                "exists": project.folder.exists(),
                "lifecycle": project.lifecycle_class,
                "pack": " + ".join(project.project_types),
                "markdown_create": len(create_docs),
                "markdown_preserve": len(preserve_docs),
                "inactive_preserve": len(inactive_existing),
                "active_documents": len(documents),
                "tasks": len(project.tasks),
                "board_create": bool(create_boards),
            }
        )
    global_canvas_updates, canvas_warnings = global_canvas_update_plan(projects)
    warnings.extend(canvas_warnings)
    return {
        "canonical_count": len(projects),
        "projects": projects,
        "workspace_create": workspace_create,
        "workspace_existing": workspace_existing,
        "markdown_create": unique_paths(markdown_create),
        "markdown_preserve": unique_paths(markdown_preserve),
        "boards_create": unique_paths(boards_create),
        "initial_tasks": sum(len(project.tasks) for project in projects),
        "root_updates": root_updates,
        "memory_updates": memory_updates,
        "registry_updates": len(projects),
        "global_canvas_updates": global_canvas_updates,
        "hard_stops": unique(hard_stops),
        "warnings": unique(warnings),
        "safe_to_apply": not hard_stops,
        "per_project": per_project,
    }


def plan_report(plan: dict[str, object]) -> str:
    project_rows = []
    for item in plan["per_project"]:
        project_rows.append(
            f"| {item['code']} | {item['note']} | {item['lifecycle']} | {item['pack']} | "
            f"{'Existing' if item['exists'] else 'Create'} | {item['markdown_create']} | "
            f"{item['markdown_preserve']} | {item['inactive_preserve']} | {item['tasks']} | "
            f"{'Yes' if item['board_create'] else 'Preserve'} |"
        )
    hard_stops = bullets(plan["hard_stops"], "- None")
    warnings = bullets(plan["warnings"], "- None")
    return f"""# Project Workspace Upgrade Plan — {TODAY}

## Executive Summary

- Canonical projects detected: {plan['canonical_count']}
- Workspaces to create: {len(plan['workspace_create'])}
- Existing workspaces: {len(plan['workspace_existing'])}
- Total Markdown files proposed: {len(plan['markdown_create'])}
- Existing Markdown files preserved: {len(plan['markdown_preserve'])}
- Initial tasks proposed: {plan['initial_tasks']}
- Project Executive Boards proposed: {len(plan['boards_create'])}
- Safe to Apply: {plan['safe_to_apply']}

## Canonical Projects Detected

| Project | Project File | Lifecycle | Documentation Pack | Workspace | Markdown Create | Active Preserve | Inactive Preserve | Initial Tasks | Board |
| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | --- |
{chr(10).join(project_rows)}

## Project Files Resolved

{bullets([f"{project.code} -> {project.note_path.relative_to(VAULT_ROOT).as_posix()}" for project in plan['projects']])}

## Workspaces Already Existing

{bullets([project.folder.relative_to(VAULT_ROOT).as_posix() for project in plan['workspace_existing']], '- None')}

## Workspaces To Create

{bullets([project.folder.relative_to(VAULT_ROOT).as_posix() for project in plan['workspace_create']], '- None')}

## Documentation Pack Selection

Document creation and script-owned refresh are lifecycle-driven. Active delivery and UAT projects receive the full working pack; production projects receive operational and support documents; backlog/on-hold projects receive discovery documents; external trials receive PoC/evaluation documents; closed projects receive governance, support and closeout documents. Existing files outside the active pack are preserved without deletion or refresh.

## Files To Preserve

{bullets([path.relative_to(VAULT_ROOT).as_posix() for path in plan['markdown_preserve']], '- None')}

## Initial Task Count Per Project

{bullets([f"{project.code}: {len(project.tasks)}" for project in plan['projects']])}

## Boards To Create

{bullets([path.relative_to(VAULT_ROOT).as_posix() for path in plan['boards_create']], '- None')}

## Root Notes To Update

- Managed-block workspace links proposed: {plan['root_updates']}
- Root notes will not be moved or renamed.
- User-written content outside PPJ project knowledge markers will be preserved.

## Memory Cards To Update

- Project memory cards proposed for workspace-path metadata: {plan['memory_updates']}

## Registry Updates

- Workspace overlay rows proposed: {plan['registry_updates']}
- Command Center workspace rows proposed: {plan['canonical_count']}

## Global Canvas Links To Update

- Existing project cards receiving compact Project Board references: {plan['global_canvas_updates']}
- No duplicate project cards will be created.

## Hard Stops

{hard_stops}

## Warnings

{warnings}

## Estimated Total Files To Create

- Markdown: {len(plan['markdown_create'])}
- Canvas: {len(plan['boards_create'])}
- Total: {len(plan['markdown_create']) + len(plan['boards_create'])}

## Apply Command

Approval required:

```bash
python3 scripts/upgrade_ppj_project_workspaces.py --apply --all
```
"""


def print_plan(plan: dict[str, object]) -> None:
    print("PPJ Project Workspace Upgrade DryRun")
    print(f"Canonical project count: {plan['canonical_count']}")
    print("Projects selected:")
    for project in plan["projects"]:
        print(f" - {project.code} -> {project.note_path.name}")
    print(f"Workspaces to create: {len(plan['workspace_create'])}")
    print(f"Existing workspaces: {len(plan['workspace_existing'])}")
    print("Project documentation packs:")
    for item in plan["per_project"]:
        print(
            f" - {item['code']}: {item['pack']} ({item['lifecycle']}); "
            f"active docs={item['active_documents']}; inactive existing preserved={item['inactive_preserve']}"
        )
    print(f"Total Markdown files proposed: {len(plan['markdown_create'])}")
    print(f"Initial tasks proposed: {plan['initial_tasks']}")
    print(f"Project Executive Boards proposed: {len(plan['boards_create'])}")
    print(f"Root notes to update: {plan['root_updates']}")
    print(f"Memory cards to update: {plan['memory_updates']}")
    print(f"Registry updates: {plan['registry_updates']}")
    print(f"Global Executive Board updates: {plan['global_canvas_updates']}")
    print("Hard stops:")
    if plan["hard_stops"]:
        for item in plan["hard_stops"]:
            print(f" - {item}")
    else:
        print(" - None")
    print("Warnings:")
    if plan["warnings"]:
        for item in plan["warnings"]:
            print(f" - {item}")
    else:
        print(" - None")
    print(f"Safe to Apply: {plan['safe_to_apply']}")
    report_preview_stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    print(f"Plan report target: 10_Reports/PROJECT_WORKSPACE_UPGRADE_PLAN_{report_preview_stamp}.md")
    if plan["safe_to_apply"]:
        print("Apply command (approval required):")
        print("python3 scripts/upgrade_ppj_project_workspaces.py --apply --all")


def write_generated_document(path: Path, content: str, update_existing: bool, force: bool) -> tuple[str, bool]:
    if not path.exists():
        write_text(path, content)
        return "created", True
    existing = read_text(path)
    if existing == content.rstrip() + "\n":
        return "unchanged", False
    fm, _, _ = extract_frontmatter(existing)
    script_owned = fm_scalar(fm, "generated_by") == "upgrade_ppj_project_workspaces.py"
    if update_existing and script_owned:
        write_text(path, content)
        return "updated", True
    if force and script_owned:
        write_text(path, content)
        return "updated", True
    return "preserved", False


def apply_upgrade(plan: dict[str, object], update_existing: bool, force: bool) -> dict[str, object]:
    if not plan["safe_to_apply"]:
        raise RuntimeError("Apply refused because hard stops exist")
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    audit_root = VAULT_ROOT / "99_Attachments" / "Audit" / "Project_Workspace_Upgrade_Backup" / timestamp
    canvas_root = VAULT_ROOT / "99_Attachments" / "Canvas_Backup" / timestamp
    result = {
        "timestamp": timestamp,
        "backup_path": audit_root,
        "canvas_backup_path": canvas_root,
        "projects_upgraded": [],
        "workspaces_created": 0,
        "documents_created": 0,
        "documents_updated": 0,
        "documents_preserved": 0,
        "inactive_documents_preserved": 0,
        "tasks_created": 0,
        "boards_created": 0,
        "boards_updated": 0,
        "root_notes_updated": 0,
        "memory_cards_updated": 0,
        "registry_updated": False,
        "command_center_updated": False,
        "global_canvas_updated": 0,
        "warnings": list(plan["warnings"]),
        "failures": [],
    }
    existing_to_backup = [
        AGENTS_PATH,
        REGISTRATION_PROTOCOL,
        REGISTRY_PATH,
        COMMAND_CENTER,
        GLOBAL_CANVAS,
        LEDGER_PATH,
    ]
    for project in plan["projects"]:
        existing_to_backup += [project.note_path, project.memory_path]
        documents, tasks, boards = planned_files(project)
        existing_to_backup += [path for path in documents + tasks + boards if path.exists()]
    for path in unique_paths(existing_to_backup):
        backup_file(path, audit_root, canvas_root)

    for project in plan["projects"]:
        try:
            workspace_was_missing = not project.folder.exists()
            project.folder.mkdir(parents=True, exist_ok=True)
            for directory in WORKSPACE_DIRECTORIES:
                (project.folder / directory).mkdir(parents=True, exist_ok=True)
            if workspace_was_missing:
                result["workspaces_created"] += 1
            active_relative = active_documents(project)
            inactive_relative = [
                item
                for item in unique(BASE_DOCUMENTS + extra_documents(project))
                if item not in set(active_relative)
            ]
            result["inactive_documents_preserved"] += sum(
                (project.folder / item).exists() for item in inactive_relative
            )
            for relative_path in active_relative:
                path = project.folder / relative_path
                state, changed = write_generated_document(
                    path, render_document(project, relative_path), update_existing, force
                )
                if state == "created":
                    result["documents_created"] += 1
                elif state == "updated":
                    result["documents_updated"] += 1
                elif state == "preserved":
                    result["documents_preserved"] += 1
            existing_task_titles = {
                identity_key(fm_scalar(extract_frontmatter(read_text(path))[0], "title"))
                for path in (project.folder / "Tasks").glob("*.md")
            }
            for task in project.tasks:
                if identity_key(task.title) in existing_task_titles:
                    continue
                task_path = project.folder / "Tasks" / task.filename
                if task_path.exists():
                    result["documents_preserved"] += 1
                    continue
                write_text(task_path, render_task(project, task))
                existing_task_titles.add(identity_key(task.title))
                result["tasks_created"] += 1
            board_path = project.folder / "Project_Executive_Board.canvas"
            board_content = json.dumps(build_project_board(project), ensure_ascii=False, indent=2)
            if not board_path.exists():
                write_text(board_path, board_content)
                result["boards_created"] += 1
            elif update_existing or force:
                write_text(board_path, board_content)
                result["boards_updated"] += 1
            root_original = read_text(project.note_path)
            root_updated, changed, warning = update_root_note_content(project, root_original)
            if warning:
                result["warnings"].append(f"{project.code}: {warning}")
            elif changed:
                write_text(project.note_path, root_updated)
                result["root_notes_updated"] += 1
            memory_original = read_text(project.memory_path)
            memory_updated = update_frontmatter(
                memory_original,
                {
                    "workspace_path": f"03_Projects/{project.folder_name}",
                    "project_home": f"03_Projects/{project.folder_name}/00_Project_Home.md",
                    "project_board": f"03_Projects/{project.folder_name}/Project_Executive_Board.canvas",
                    "task_folder": f"03_Projects/{project.folder_name}/Tasks",
                    "documentation_status": "Workspace Created",
                },
            )
            if memory_updated != memory_original:
                write_text(project.memory_path, memory_updated)
                result["memory_cards_updated"] += 1
            result["projects_upgraded"].append(project.code)
        except Exception as exc:  # noqa: BLE001 - operation report must retain failures
            result["failures"].append(f"{project.code}: {exc}")

    registry_updated = replace_managed_block(
        read_text(REGISTRY_PATH),
        "<!-- PPJ_PROJECT_WORKSPACE_REGISTRY_START -->",
        "<!-- PPJ_PROJECT_WORKSPACE_REGISTRY_END -->",
        registry_workspace_block(plan["projects"]),
    )
    write_text(REGISTRY_PATH, registry_updated)
    result["registry_updated"] = True

    command_updated = replace_managed_block(
        read_text(COMMAND_CENTER),
        "<!-- PPJ_PROJECT_WORKSPACES_START -->",
        "<!-- PPJ_PROJECT_WORKSPACES_END -->",
        command_center_workspace_block(plan["projects"]),
    )
    write_text(COMMAND_CENTER, command_updated)
    result["command_center_updated"] = True

    agents_updated = replace_managed_block(
        read_text(AGENTS_PATH),
        "<!-- PPJ_PROJECT_WORKSPACE_PROTOCOL_START -->",
        "<!-- PPJ_PROJECT_WORKSPACE_PROTOCOL_END -->",
        agents_workspace_protocol(),
    )
    write_text(AGENTS_PATH, agents_updated)

    protocol_updated = replace_managed_block(
        read_text(REGISTRATION_PROTOCOL),
        "<!-- PPJ_PROJECT_WORKSPACE_REGISTRATION_START -->",
        "<!-- PPJ_PROJECT_WORKSPACE_REGISTRATION_END -->",
        registration_protocol_workspace_content(),
    )
    write_text(REGISTRATION_PROTOCOL, protocol_updated)

    global_canvas_content, global_created = update_global_canvas(plan["projects"])
    write_text(GLOBAL_CANVAS, global_canvas_content)
    result["global_canvas_updated"] = global_created

    plan_path = REPORT_ROOT / f"PROJECT_WORKSPACE_UPGRADE_PLAN_{timestamp}.md"
    result_path = REPORT_ROOT / f"PROJECT_WORKSPACE_UPGRADE_RESULT_{timestamp}.md"
    result["plan_report"] = plan_path
    result["result_report"] = result_path
    ledger_original = read_text(LEDGER_PATH)
    ledger_row = (
        f"| {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} | Portfolio Workspace Upgrade | workspace_upgrade | "
        f"Lifecycle-driven activation applied to {len(result['projects_upgraded'])} projects; "
        f"created {result['documents_created']} documents, updated {result['documents_updated']}, "
        f"and preserved {result['inactive_documents_preserved']} inactive existing documents. | "
        "workspace / documentation pack / task board / registry | previous workspace state | "
        f"timestamped result: {result_path.name} | User-approved Apply | "
        f"{'Strong' if not result['failures'] else 'Needs Review'} | "
        "workspace / registry / command center / local boards | Review timestamped result report. |"
    )
    write_text(LEDGER_PATH, ledger_original.rstrip() + "\n" + ledger_row)
    write_text(plan_path, plan_report(plan))
    write_text(result_path, result_report(result))
    return result


def result_report(result: dict[str, object]) -> str:
    return f"""# Project Workspace Upgrade Result — {result['timestamp']}

## Summary

- Projects upgraded: {len(result['projects_upgraded'])}
- Workspaces created: {result['workspaces_created']}
- Documents created: {result['documents_created']}
- Documents updated: {result['documents_updated']}
- Existing documents preserved: {result['documents_preserved']}
- Inactive lifecycle documents preserved: {result['inactive_documents_preserved']}
- Task notes created: {result['tasks_created']}
- Project boards created: {result['boards_created']}
- Project boards updated: {result['boards_updated']}
- Root notes updated: {result['root_notes_updated']}
- Memory cards updated: {result['memory_cards_updated']}
- Registry updated: {result['registry_updated']}
- Command Center updated: {result['command_center_updated']}
- Global Executive Board links added: {result['global_canvas_updated']}
- Canvas validation: {'PASS' if not result['failures'] else 'REVIEW REQUIRED'}
- Update ledger appended: {LEDGER_PATH.relative_to(VAULT_ROOT).as_posix()}

## Projects Upgraded

{bullets(result['projects_upgraded'], '- None')}

## Backup

- Audit backup: {result['backup_path']}
- Canvas backup: {result['canvas_backup_path']}

## Failures

{bullets(result['failures'], '- None')}

## Warnings

{bullets(unique(result['warnings']), '- None')}

## Next Recommended Actions

1. Run project board synchronization.
2. Run the existing portfolio consistency audit.
3. Review projects marked Needs Confirmation for Business Discovery, ownership, Data Spec and UAT evidence.
"""


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Upgrade canonical PPJ projects into working project workspaces")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Plan only; default")
    mode.add_argument("--apply", action="store_true", help="Apply after explicit approval")
    selection = parser.add_mutually_exclusive_group(required=True)
    selection.add_argument("--project", help="Canonical code, alias, or current project filename")
    selection.add_argument("--all", action="store_true", help="Process all approved canonical projects")
    parser.add_argument("--update-existing", action="store_true", help="Refresh script-generated documents only")
    parser.add_argument("--force", action="store_true", help="Regenerate script-owned artifacts; does not bypass hard stops")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    projects, hard_stops, warnings = discover_projects(args.project)
    plan = build_plan(projects, hard_stops, warnings)
    if not args.apply:
        print_plan(plan)
        return 0 if plan["safe_to_apply"] else 2
    try:
        result = apply_upgrade(plan, args.update_existing, args.force)
    except Exception as exc:  # noqa: BLE001
        print(f"Apply failed: {exc}", file=sys.stderr)
        return 2
    print(f"Projects upgraded: {len(result['projects_upgraded'])}")
    print(f"Workspaces created: {result['workspaces_created']}")
    print(f"Documents created: {result['documents_created']}")
    print(f"Task notes created: {result['tasks_created']}")
    print(f"Project boards created: {result['boards_created']}")
    print(f"Root notes updated: {result['root_notes_updated']}")
    print(f"Memory cards updated: {result['memory_cards_updated']}")
    print(f"Registry updated: {result['registry_updated']}")
    print(f"Global Executive Board updated: {result['global_canvas_updated']}")
    print(f"Backup path: {result['backup_path']}")
    print(f"Result report: {result['result_report']}")
    return 0 if not result["failures"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
