#!/usr/bin/env python3
"""Build the PPJ enterprise ecosystem and managed portfolio diagrams safely."""

from __future__ import annotations

import argparse
import collections
import datetime as dt
import hashlib
import html
import json
import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CANVAS_ROOT = ROOT / "03_Projects" / "Canvas"
DOC_PATH = ROOT / "02_BA_Knowledge" / "Enterprise_Architecture" / "PPJ_Enterprise_Application_AI_Automation_Ecosystem.md"
REPORT_PATH = ROOT / "10_Reports" / "PPJ_ENTERPRISE_ECOSYSTEM_DIAGRAM_UPDATE_20260918.md"
SOURCE_EVENT = "PPJ-ENTERPRISE-ECOSYSTEM-20260918"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Update PPJ enterprise ecosystem Canvas and diagram artifacts")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Plan only; default")
    mode.add_argument("--apply", action="store_true", help="Backup and write changes")
    parser.add_argument("--source", type=Path, help="User-provided ecosystem Markdown/text source")
    return parser.parse_args()


def stable_id(prefix: str, value: str) -> str:
    digest = hashlib.sha256(value.encode("utf-8")).hexdigest()[:12]
    return f"{prefix}-{digest}"


def text_node(node_id: str, x: int, y: int, width: int, height: int, text: str, color: str | None = None) -> dict:
    node = {"id": node_id, "type": "text", "x": x, "y": y, "width": width, "height": height, "text": text}
    if color:
        node["color"] = color
    return node


def group_node(node_id: str, x: int, y: int, width: int, height: int, label: str, color: str | None = None) -> dict:
    node = {"id": node_id, "type": "group", "x": x, "y": y, "width": width, "height": height, "label": label}
    if color:
        node["color"] = color
    return node


def file_node(node_id: str, x: int, y: int, width: int, height: int, file_path: str) -> dict:
    return {"id": node_id, "type": "file", "x": x, "y": y, "width": width, "height": height, "file": file_path}


def edge(edge_id: str, source: str, target: str, label: str | None = None, from_side: str = "right", to_side: str = "left") -> dict:
    item = {
        "id": edge_id,
        "fromNode": source,
        "fromSide": from_side,
        "toNode": target,
        "toSide": to_side,
    }
    if label:
        item["label"] = label
    return item


def canvas_text(nodes: list[dict], edges: list[dict]) -> str:
    return json.dumps({"nodes": nodes, "edges": edges}, ensure_ascii=False, separators=(",", ":")) + "\n"


BUSINESS_STAGES = [
    ("market", "CUSTOMER / MARKET", "MER_MarketIntelligence_v1.1.0"),
    ("mer", "MERCHANDISING", "MER_CostingAgenticPlatform_v1.1.0\nMER_InvoiceDataRecheck_v1.1.0"),
    ("tech", "TECHNICAL DEVELOPMENT", "TD_TechnicalKnowledgePlatform_v2.1.0\nFAB_FabricDatamart_v2.2.0\nCPD_VisualSampleDatamart_v1.1.0"),
    ("source", "SOURCING", "SCP_SourcingChatbot_v2.3.0"),
    ("purchase", "PURCHASING", "PUR_GDIAutomation_v1.0.0\nPUR_MaterialAllocation_v1.1.0\nPUR_AdhocIndentSouth_v1.0.0\nPUR_InventoryReport_v2.1.0"),
    ("warehouse", "WAREHOUSE / MATERIAL", "WH_AWBExtraction_v1.1.0"),
    ("production", "PRODUCTION", "PROD_HangingLineIoT_v1.0.0"),
    ("wash", "WASH", "WASH_SamplingManagement_v1.1.0\nWASH_COWASH_v2.0.0"),
    ("qc", "QC / TQM", "QC_DefectDetection_v1.0.0\nQC_ThreadTraceability_v1.0.0"),
    ("logistics", "LOGISTICS / EXIM", "LOG_ExpenseInvoiceProcessing_v1.2.0"),
    ("finance", "FINANCE / ACCOUNTING", "FIN_FinanceManagement_v1.2.0\nFIN_InvoiceDownloader_v1.2.0\nACC_GRNSupplierInvoiceBot_v2.3.0"),
]


def build_ecosystem_canvas() -> str:
    nodes: list[dict] = [
        text_node("ecosystem-title", 0, -420, 11200, 220, "# PPJ ENTERPRISE APPLICATION + AI & AUTOMATION ECOSYSTEM\n\nWFX = transaction backbone | GTAS/internal apps = PPJ application layer | Data + AI = intelligence and automation layer", "5"),
        file_node("architecture-reference", 0, -170, 900, 150, "02_BA_Knowledge/Enterprise_Architecture/PPJ_Enterprise_Application_AI_Automation_Ecosystem.md"),
        group_node("layer-business", 0, 100, 11200, 620, "LAYER 1 - BUSINESS PROCESS", "3"),
        group_node("layer-erp", 0, 900, 11200, 500, "LAYER 2 - CORE ERP", "4"),
        group_node("layer-specialized", 0, 1580, 11200, 520, "LAYER 3 - SPECIALIZED / THIRD-PARTY", "1"),
        group_node("layer-internal", 0, 2280, 11200, 520, "LAYER 4 - INTERNAL PPJ APPLICATIONS", "6"),
        group_node("layer-data-ai", 0, 2980, 11200, 580, "LAYER 5 - DATA + AI + AUTOMATION", "5"),
        group_node("layer-control", 0, 3740, 11200, 520, "HUMAN CONTROL + CONTROLLED EXECUTION", "2"),
    ]
    edges: list[dict] = []
    stage_ids: list[str] = []
    for index, (key, label, projects) in enumerate(BUSINESS_STAGES):
        node_id = f"business-{key}"
        stage_ids.append(node_id)
        x = 70 + index * 1000
        nodes.append(text_node(node_id, x, 230, 860, 360, f"## {label}\n\n{projects}", "3"))
        if index:
            edges.append(edge(f"edge-business-{index}", stage_ids[index - 1], node_id, "business flow"))

    nodes.extend([
        text_node("wfx", 600, 1000, 3000, 280, "# WFX ERP\nMaster Data | Order | Purchasing | Material | Inventory | Operational Transaction", "4"),
        text_node("erp-rule", 4200, 1000, 3000, 280, "# ERP CONTROL\nValidation | Permission | Transaction Status | Audit | Error Handling | Rollback", "4"),
        text_node("erp-boundary", 7800, 1000, 2700, 280, "# ARCHITECTURE RULE\nAI does not replace WFX or GTAS. Not every AI use case writes back to WFX.", "4"),
        text_node("mmx", 400, 1680, 1800, 280, "## MMX\nMaterial | Inventory | Warehouse", "1"),
        text_node("eoffice", 2450, 1680, 1800, 280, "## eOffice\nDocument | Workflow | Sign / Approval", "1"),
        text_node("vnpt", 4500, 1680, 1800, 280, "## VNPT e-Invoice\nElectronic invoice | Accounting process", "1"),
        text_node("iot", 6550, 1680, 1800, 280, "## IoT / WISER / INA\nMachine and production-line data", "1"),
        text_node("external", 8600, 1680, 1800, 280, "## EXTERNAL PLATFORMS\nCourier | Supplier | Customer | Academic / Vendor", "1"),
        text_node("gtas", 400, 2380, 2400, 280, "# GTAS / IED\nPPJ-specific costing, technical and operational applications", "6"),
        text_node("datamarts", 3200, 2380, 2400, 280, "# DATAMARTS\nFabric | Visual Sample | Technical Knowledge | Sourcing", "6"),
        text_node("portals", 6000, 2380, 2400, 280, "# INTERNAL PORTALS\nWash Sampling | Admin Expense | AI Applications", "6"),
        text_node("utilities", 8800, 2380, 1800, 280, "# UTILITIES\nReporting | Search | Workflow", "6"),
        text_node("dwh", 400, 3080, 2200, 320, "# DWH / DATABRICKS\nETL | Curated Data | Lineage | Analytics", "5"),
        text_node("perri", 3000, 3080, 2200, 320, "# PERRI / AI HUB\nIntent | Agent / Tool | Controlled response or action", "5"),
        text_node("automation", 5600, 3080, 2200, 320, "# AI + AUTOMATION\nOCR | RAG | Agents | Anomaly | RPA | API", "5"),
        text_node("ai-pattern", 8200, 3080, 2400, 320, "# OPERATING PATTERN\nRead -> Understand -> Validate -> Recommend -> Automate", "5"),
        text_node("human", 800, 3840, 2600, 280, "# HUMAN CONFIRM\nDomain expert validates recommendation, exception and business decision.", "2"),
        text_node("permission", 4300, 3840, 2600, 280, "# GOVERNANCE\nOwner | Permission | Evidence | Version | Audit | Fallback", "2"),
        text_node("execute", 7800, 3840, 2600, 280, "# WRITE BACK / EXECUTE\nControlled API or user-confirmed transaction into the target system.", "2"),
    ])

    edges.extend([
        edge("e-business-wfx", "business-purchase", "wfx", "transaction", "bottom", "top"),
        edge("e-business-gtas", "business-tech", "gtas", "technical / costing", "bottom", "top"),
        edge("e-wfx-specialized", "wfx", "mmx", "material data", "bottom", "top"),
        edge("e-wfx-vnpt", "wfx", "vnpt", "invoice data", "bottom", "top"),
        edge("e-wfx-iot", "wfx", "iot", "operations", "bottom", "top"),
        edge("e-wfx-gtas", "wfx", "gtas", "ERP integration", "bottom", "top"),
        edge("e-specialized-dwh", "external", "dwh", "source data", "bottom", "top"),
        edge("e-internal-dwh", "datamarts", "dwh", "curated data", "bottom", "top"),
        edge("e-dwh-perri", "dwh", "perri", "governed context"),
        edge("e-perri-auto", "perri", "automation", "agent / tool"),
        edge("e-auto-pattern", "automation", "ai-pattern", "controlled capability"),
        edge("e-pattern-human", "ai-pattern", "human", "review", "bottom", "top"),
        edge("e-human-governance", "human", "permission", "approve"),
        edge("e-governance-execute", "permission", "execute", "authorize"),
        edge("e-execute-wfx", "execute", "wfx", "controlled write-back", "top", "bottom"),
    ])
    return canvas_text(nodes, edges)


def build_data_flow_canvas() -> str:
    nodes: list[dict] = [
        text_node("data-title", 0, -360, 10200, 190, "# PPJ DATA, AI AND CONTROLLED TRANSACTION FLOW\n\nOperational sources become governed data; AI assists; people confirm; target systems execute.", "5"),
        file_node("architecture-reference", 0, -140, 850, 130, "02_BA_Knowledge/Enterprise_Architecture/PPJ_Enterprise_Application_AI_Automation_Ecosystem.md"),
        group_node("g-source", 0, 100, 1700, 2700, "SOURCE SYSTEMS", "3"),
        group_node("g-data", 2000, 100, 1700, 2700, "INTEGRATION + DATA", "4"),
        group_node("g-ai", 4000, 100, 1700, 2700, "AI + AUTOMATION", "5"),
        group_node("g-human", 6000, 100, 1700, 2700, "HUMAN CONTROL", "2"),
        group_node("g-execute", 8000, 100, 2000, 2700, "CONTROLLED EXECUTION", "6"),
    ]
    source_nodes = [
        ("src-wfx", "WFX ERP\nOrder | PO | Material | Inventory | Transaction"),
        ("src-gtas", "GTAS / IED\nCosting | Technical | Operational Apps"),
        ("src-third", "THIRD-PARTY\nMMX | eOffice | VNPT | IoT | Courier"),
        ("src-doc", "DOCUMENTS\nInvoice | AWB | Email | Image | Techpack"),
        ("src-ext", "EXTERNAL DATA\nMarket | Supplier | Customer | Academic"),
    ]
    data_nodes = [
        ("data-api", "API / CONNECTOR\nAuthentication | Contract | Retry"),
        ("data-etl", "ETL / STANDARDIZATION\nKeys | Types | Mapping | Quality"),
        ("data-dwh", "DWH / DATABRICKS\nCurated | Lineage | Analytics"),
        ("data-marts", "DOMAIN DATAMARTS\nFabric | Technical | Visual | Sourcing"),
        ("data-record", "CANONICAL RECORDS\nEmployee | AWB | Invoice | Material"),
    ]
    ai_nodes = [
        ("ai-read", "READ / EXTRACT\nOCR | Email Parser | API Read"),
        ("ai-understand", "UNDERSTAND\nRAG | Classification | Similarity"),
        ("ai-validate", "VALIDATE / DETECT\nRules | Exceptions | Anomaly"),
        ("ai-recommend", "RECOMMEND\nCosting | Search | Decision Support"),
        ("ai-automate", "AUTOMATE\nAgent | Workflow | RPA | API"),
    ]
    human_nodes = [
        ("human-owner", "BUSINESS OWNER\nScope | Rule | Acceptance"),
        ("human-user", "DOMAIN USER\nReview | Correct | Confirm"),
        ("human-exception", "EXCEPTION QUEUE\nLow confidence | Conflict | Failure"),
        ("human-approval", "APPROVAL\nPermission | Evidence | Decision"),
        ("human-fallback", "FALLBACK\nManual process | Recovery"),
    ]
    execute_nodes = [
        ("exec-draft", "DRAFT / PREVIEW\nNo business transaction yet"),
        ("exec-api", "CONTROLLED API\nIdempotency | Retry | Timeout"),
        ("exec-write", "WRITE BACK\nWFX | GTAS | Portal | Target System"),
        ("exec-audit", "AUDIT\nInput | Decision | User | Result"),
        ("exec-monitor", "MONITOR / SUPPORT\nSLA | Defect | Adoption | Change"),
    ]
    columns = [(source_nodes, 100, "3"), (data_nodes, 2100, "4"), (ai_nodes, 4100, "5"), (human_nodes, 6100, "2"), (execute_nodes, 8100, "6")]
    for items, x, color in columns:
        for index, (node_id, label) in enumerate(items):
            nodes.append(text_node(node_id, x, 260 + index * 490, 1500 if x < 8000 else 1800, 330, f"## {label}", color))
    edges: list[dict] = []
    for index, source_id in enumerate([item[0] for item in source_nodes]):
        edges.append(edge(f"source-data-{index}", source_id, data_nodes[min(index, len(data_nodes) - 1)][0], "ingest"))
    for index in range(5):
        edges.append(edge(f"data-ai-{index}", data_nodes[index][0], ai_nodes[index][0], "governed input"))
        edges.append(edge(f"ai-human-{index}", ai_nodes[index][0], human_nodes[index][0], "review / control"))
        edges.append(edge(f"human-exec-{index}", human_nodes[index][0], execute_nodes[index][0], "approved"))
    edges.extend([
        edge("audit-feedback", "exec-audit", "data-dwh", "feedback / evidence", "left", "right"),
        edge("monitor-owner", "exec-monitor", "human-owner", "operational feedback", "left", "right"),
    ])
    return canvas_text(nodes, edges)


def build_end_to_end_canvas() -> str:
    nodes: list[dict] = [
        text_node("e2e-title", 0, -360, 10600, 190, "# PPJ END-TO-END BUSINESS PROCESS + APPLICATION / AI COVERAGE\n\nCustomer and market -> order and material -> production and quality -> logistics and finance", "5"),
        file_node("architecture-reference", 0, -140, 900, 130, "02_BA_Knowledge/Enterprise_Architecture/PPJ_Enterprise_Application_AI_Automation_Ecosystem.md"),
        group_node("g-business", 0, 100, 10600, 780, "PRIMARY BUSINESS FLOW", "3"),
        group_node("g-support", 0, 1080, 10600, 600, "PARALLEL ENTERPRISE SERVICES", "6"),
        group_node("g-backbone", 0, 1880, 10600, 650, "SYSTEM + DATA + AI BACKBONE", "5"),
        group_node("g-control", 0, 2730, 10600, 480, "CONTROL PRINCIPLE", "2"),
    ]
    edges: list[dict] = []
    for index, (key, label, projects) in enumerate(BUSINESS_STAGES):
        node_id = f"stage-{key}"
        x = 60 + index * 950
        nodes.append(text_node(node_id, x, 230, 820, 510, f"## {index + 1}. {label}\n\n{projects}", "3"))
        if index:
            edges.append(edge(f"business-flow-{index}", f"stage-{BUSINESS_STAGES[index - 1][0]}", node_id))
    support = [
        ("support-admin", "ADMINISTRATION\nADMIN_ExpenseManagement_v1.1.0\nTravel -> Advance -> Expense -> Settlement"),
        ("support-hr", "HR\nHR_EmployeeDataPlatform_v1.1.0\nEmployee data -> Trusted Employee Master"),
        ("support-ai", "AI PLATFORMS\nAI_PERRIPlatform_v3.2.0\nAI_ApplicationHub_v2.1.0"),
        ("support-ext", "EXTERNAL COLLABORATION\nEXT_AcademicCollaboration_v1.1.0\nVendor / academic discovery and evaluation"),
    ]
    for index, (node_id, label) in enumerate(support):
        nodes.append(text_node(node_id, 180 + index * 2550, 1190, 2200, 350, f"## {label}", "6"))
    backbone = [
        ("back-wfx", "WFX ERP\nOperational transaction backbone"),
        ("back-gtas", "GTAS / IED\nPPJ application layer"),
        ("back-third", "THIRD-PARTY\nMMX | eOffice | VNPT | IoT"),
        ("back-data", "DWH / DATABRICKS\nGoverned analytics and AI data"),
        ("back-ai", "AI / AUTOMATION\nOCR | RAG | Agents | API | RPA"),
    ]
    for index, (node_id, label) in enumerate(backbone):
        nodes.append(text_node(node_id, 160 + index * 2050, 2000, 1800, 350, f"## {label}", "5"))
        if index:
            edges.append(edge(f"backbone-{index}", backbone[index - 1][0], node_id))
    nodes.extend([
        text_node("control-pattern", 500, 2830, 4600, 260, "# AI OPERATING PATTERN\nRead -> Understand -> Validate -> Recommend -> Automate -> Human Confirm", "2"),
        text_node("control-execute", 5500, 2830, 4600, 260, "# EXECUTION BOUNDARY\nOnly approved, permissioned and auditable actions write back or execute.", "2"),
    ])
    edges.extend([
        edge("control-link", "control-pattern", "control-execute", "approved action"),
        edge("wfx-purchase", "back-wfx", "stage-purchase", "transaction services", "top", "bottom"),
        edge("gtas-tech", "back-gtas", "stage-tech", "technical / costing", "top", "bottom"),
        edge("third-production", "back-third", "stage-production", "machine / platform data", "top", "bottom"),
        edge("data-finance", "back-data", "stage-finance", "analytics", "top", "bottom"),
        edge("ai-mer", "back-ai", "stage-mer", "assist", "top", "bottom"),
        edge("ai-source", "back-ai", "stage-source", "search / compare", "top", "bottom"),
        edge("ai-warehouse", "back-ai", "stage-warehouse", "extract / validate", "top", "bottom"),
        edge("ai-qc", "back-ai", "stage-qc", "detect / classify", "top", "bottom"),
    ])
    return canvas_text(nodes, edges)


def with_architecture_reference(path: Path) -> str:
    current = path.read_text(encoding="utf-8-sig")
    data = json.loads(current)
    expected = file_node("architecture-reference", -760, -420, 680, 220, "02_BA_Knowledge/Enterprise_Architecture/PPJ_Enterprise_Application_AI_Automation_Ecosystem.md")
    matching = [node for node in data.get("nodes", []) if node.get("id") == "architecture-reference"]
    if matching == [expected]:
        return current
    data["nodes"] = [node for node in data.get("nodes", []) if node.get("id") != "architecture-reference"]
    data["nodes"].append(expected)
    return json.dumps(data, ensure_ascii=False, separators=(",", ":")) + "\n"


def update_executive_board(path: Path) -> str:
    """Add a visible, registry-driven summary without rebuilding delivery lanes."""
    import ppj_canvas_state_lib as state

    current = path.read_text(encoding="utf-8-sig")
    data = json.loads(current)
    snapshot = state.load_snapshot()
    projects = state.registered_projects(snapshot)
    stage_counts = collections.Counter(str(item.get("delivery_stage", "TBD")) for item in projects)
    stream_counts = collections.Counter(str(item.get("delivery_stream", "TBD")) for item in projects)
    status_counts = collections.Counter(str(item.get("status", "TBD")) for item in projects)

    config = state.load_config()
    stage_labels = {
        "UAT / PRE-GO-LIVE": "UAT",
        "GO-LIVE / PRODUCTION / SUPPORT": "GO-LIVE / SUPPORT",
    }
    stage_line = " | ".join(
        f"{stage_labels.get(item['name'], item['name'])}: {stage_counts.get(item['name'], 0)}"
        for item in config["stages"]
    )

    def priority_key(item: dict) -> tuple[int, str]:
        value = str(item.get("priority", ""))
        if value.startswith("P") and value[1:].isdigit():
            return int(value[1:]), str(item.get("code", ""))
        return 999, str(item.get("code", ""))

    priorities = [item for item in sorted(projects, key=priority_key) if priority_key(item)[0] < 999][:5]
    priority_line = " | ".join(
        f"{item.get('priority')} {item.get('code')} ({stage_labels.get(str(item.get('delivery_stage')), str(item.get('delivery_stage')))})"
        for item in priorities
    )
    internal_projects = [item for item in projects if item.get("delivery_stream") == "INTERNAL DEVELOPMENT"]
    external_projects = [item for item in projects if item.get("delivery_stream") == "EXTERNAL DEVELOPMENT"]
    internal_stages = collections.Counter(str(item.get("delivery_stage", "TBD")) for item in internal_projects)
    external_stages = collections.Counter(str(item.get("delivery_stage", "TBD")) for item in external_projects)
    attention = sum(status_counts.get(value, 0) for value in ("On Hold", "Blocked", "Waiting", "Pending Decision", "External Collaboration"))
    verified = snapshot.get("last_verified", "Needs Confirmation")
    summary_text = (
        f"# EXECUTIVE PORTFOLIO SUMMARY | AS OF {verified}\n\n"
        f"Registered: {len(projects)} | Internal: {stream_counts.get('INTERNAL DEVELOPMENT', 0)} | "
        f"External: {stream_counts.get('EXTERNAL DEVELOPMENT', 0)} | Active: {status_counts.get('Active', 0)} | "
        f"Support: {status_counts.get('Support', 0)} | Closed: {status_counts.get('Closed', 0)} | Attention: {attention}\n\n"
        f"Stages | {stage_line}\n\n"
        f"Top priorities | {priority_line}\n\n"
        "Direction | Standardize Data -> Standardize Rules -> Standardize APIs -> Scale Automation / AI\n\n"
        "[[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT|Current Snapshot]] | "
        "[[03_Projects/Canvas/PPJ_Project_Process_Map|Project Process Map]] | "
        "[[02_BA_Knowledge/Enterprise_Architecture/PPJ_Enterprise_Application_AI_Automation_Ecosystem|Enterprise Ecosystem]] | "
        "[[10_Reports/PPJ_ENTERPRISE_ECOSYSTEM_DIAGRAM_UPDATE_20260918|Diagram Update Report]]"
    )
    expected_nodes = {
        "ppj-executive-summary": text_node("ppj-executive-summary", 0, -350, 6570, 240, summary_text, "5"),
        "ppj-executive-summary-strip-internal": text_node(
            "ppj-executive-summary-strip-internal",
            0,
            60,
            6570,
            90,
            (
                f"## INTERNAL SUMMARY | {len(internal_projects)} PROJECTS | "
                f"ANALYSIS {internal_stages.get('ANALYSIS', 0)} | DESIGN {internal_stages.get('DESIGN', 0)} | "
                f"DEVELOPMENT {internal_stages.get('DEVELOPMENT', 0)} | UAT {internal_stages.get('UAT / PRE-GO-LIVE', 0)} | "
                f"GO-LIVE / SUPPORT {internal_stages.get('GO-LIVE / PRODUCTION / SUPPORT', 0)} | CLOSED {internal_stages.get('CLOSED', 0)}"
            ),
            "5",
        ),
        "ppj-executive-summary-strip-external": text_node(
            "ppj-executive-summary-strip-external",
            8960,
            80,
            6570,
            70,
            (
                f"## EXTERNAL SUMMARY | {len(external_projects)} PROJECTS | "
                f"ANALYSIS {external_stages.get('ANALYSIS', 0)} | DESIGN {external_stages.get('DESIGN', 0)} | "
                f"DEVELOPMENT {external_stages.get('DEVELOPMENT', 0)} | UAT {external_stages.get('UAT / PRE-GO-LIVE', 0)} | "
                f"GO-LIVE / SUPPORT {external_stages.get('GO-LIVE / PRODUCTION / SUPPORT', 0)} | CLOSED {external_stages.get('CLOSED', 0)}"
            ),
            "5",
        ),
        "architecture-reference": file_node(
            "architecture-reference",
            6640,
            -350,
            760,
            240,
            "02_BA_Knowledge/Enterprise_Architecture/PPJ_Enterprise_Application_AI_Automation_Ecosystem.md",
        ),
    }
    nodes = data.get("nodes", [])
    by_id = {node.get("id"): node for node in nodes}
    for node_id, expected in expected_nodes.items():
        if node_id in by_id:
            by_id[node_id].clear()
            by_id[node_id].update(expected)
        else:
            nodes.append(expected)

    guide = by_id.get("executive-reading-guide")
    if guide:
        guide.update(
            {
                "x": 7470,
                "y": -350,
                "width": 1420,
                "height": 240,
                "text": (
                    "## CONTROL RULES\n\n"
                    "Card center inside exactly one lane controls Delivery Stream + Delivery Stage. "
                    "Status overlays do not create duplicate cards. CLOSED reopen requires approval.\n\n"
                    "Save Canvas -> watcher validates -> Registry/project state is synchronized."
                ),
            }
        )

    legacy_note = by_id.get("055d52458bf213df")
    if legacy_note:
        legacy_note.update(
            {
                "x": 6670,
                "y": 1680,
                "width": 700,
                "height": 150,
                "text": (
                    "## Legacy alias resolved: AWB-OCR-EMAILS\n\n"
                    "Resolved to [[03_Projects/WH_AWBExtraction_v1.1.0|WH_AWBExtraction_v1.1.0]]. "
                    "This is a reference note, not a separate delivery card."
                ),
            }
        )
    unregistered_note = by_id.get("5d4f15ab3465e645")
    if unregistered_note:
        unregistered_note.update(
            {
                "x": 6670,
                "y": 1490,
                "width": 700,
                "height": 150,
                "text": (
                    "## BAOCAO THANH KHOAN - MRS MAI THUY WISER\n\n"
                    "Registration pending. Preserved outside the delivery stream until canonical approval. "
                    "See [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER|Discovery Register]]."
                ),
            }
        )

    updated = json.dumps(data, ensure_ascii=False, separators=(",", ":")) + "\n"
    return current if json.loads(current) == data else updated


def mermaid_ecosystem() -> str:
    return """flowchart TB
  subgraph L1[\"LAYER 1 - BUSINESS PROCESS\"]
    MARKET[\"Customer / Market\"] --> MER[\"Merchandising\"] --> TECH[\"Technical Development\"] --> SCP[\"Sourcing\"] --> PUR[\"Purchasing\"] --> WH[\"Warehouse / Material\"] --> PROD[\"Production\"] --> WASH[\"Wash\"] --> QC[\"QC / TQM\"] --> LOG[\"Logistics / EXIM\"] --> FIN[\"Finance / Accounting\"]
  end
  subgraph L2[\"LAYER 2 - CORE ERP\"]
    WFX[\"WFX ERP: Master Data / Order / Purchasing / Material / Inventory / Transaction\"]
  end
  subgraph L3[\"LAYER 3 - SPECIALIZED / THIRD-PARTY\"]
    MMX[\"MMX\"]
    EOFFICE[\"eOffice\"]
    VNPT[\"VNPT e-Invoice\"]
    IOT[\"IoT / WISER / INA\"]
    EXT[\"External Platforms\"]
  end
  subgraph L4[\"LAYER 4 - INTERNAL PPJ APPLICATIONS\"]
    GTAS[\"GTAS / IED\"]
    MARTS[\"Datamarts\"]
    PORTALS[\"Internal Portals\"]
  end
  subgraph L5[\"LAYER 5 - DATA + AI + AUTOMATION\"]
    DWH[\"DWH / Databricks\"] --> PERRI[\"PERRI / AI Hub\"] --> AUTO[\"OCR / RAG / Agents / RPA / API\"] --> HUMAN[\"Human Confirm\"] --> EXEC[\"Controlled Write-back / Execute\"]
  end
  L1 --> WFX
  WFX --> L3
  WFX --> L4
  L3 --> DWH
  L4 --> DWH
  EXEC --> WFX
"""


def mermaid_end_to_end() -> str:
    stage_lines = []
    for index, (key, label, projects) in enumerate(BUSINESS_STAGES):
        project_html = projects.replace("\n", "<br/>")
        stage_lines.append(f'  {key.upper()}["{label}<br/>{project_html}"]')
        if index:
            stage_lines.append(f"  {BUSINESS_STAGES[index - 1][0].upper()} --> {key.upper()}")
    return "flowchart LR\n" + "\n".join(stage_lines) + "\n  DATA[\"DWH / Databricks\"] --- MER\n  DATA --- PROD\n  DATA --- FINANCE\n  AI[\"AI + Automation\"] --- MER\n  AI --- SOURCE\n  AI --- PURCHASE\n  AI --- WAREHOUSE\n  AI --- QC\n"


def d2_ecosystem() -> str:
    return """direction: down
business: "LAYER 1 - BUSINESS PROCESS" {
  market: "Customer / Market"
  merchandising: "Merchandising"
  technical: "Technical Development"
  sourcing: "Sourcing"
  purchasing: "Purchasing"
  warehouse: "Warehouse / Material"
  production: "Production"
  wash: "Wash"
  qc: "QC / TQM"
  logistics: "Logistics / EXIM"
  finance: "Finance / Accounting"
  market -> merchandising -> technical -> sourcing -> purchasing -> warehouse -> production -> wash -> qc -> logistics -> finance
}
erp: "LAYER 2 - CORE ERP" { wfx: "WFX ERP - Operational Transaction Backbone" }
third_party: "LAYER 3 - SPECIALIZED / THIRD-PARTY" { systems: "MMX | eOffice | VNPT e-Invoice | IoT / WISER / INA | External Platforms" }
internal: "LAYER 4 - INTERNAL PPJ APPLICATIONS" { apps: "GTAS / IED | Datamarts | Internal Portals" }
data_ai: "LAYER 5 - DATA + AI + AUTOMATION" {
  dwh: "DWH / Databricks"
  ai: "PERRI / AI Hub / OCR / RAG / Agents / RPA / API"
  human: "Human Confirm"
  execute: "Controlled Write-back / Execute"
  dwh -> ai -> human -> execute
}
business -> erp
erp -> third_party
erp -> internal
third_party -> data_ai
internal -> data_ai
data_ai.execute -> erp.wfx
"""


def d2_end_to_end() -> str:
    lines = ["direction: right"]
    for key, label, projects in BUSINESS_STAGES:
        safe = projects.replace("\n", "\\n")
        lines.append(f'{key}: "{label}\\n{safe}"')
    for index in range(1, len(BUSINESS_STAGES)):
        lines.append(f"{BUSINESS_STAGES[index - 1][0]} -> {BUSINESS_STAGES[index][0]}")
    lines.extend([
        'wfx: "WFX ERP"',
        'gtas: "GTAS / IED"',
        'third: "Third-party Systems"',
        'data: "DWH / Databricks"',
        'ai: "AI + Automation + Human Control"',
        "wfx -> data",
        "gtas -> data",
        "third -> data",
        "data -> ai",
    ])
    return "\n".join(lines) + "\n"


def svg_box(x: int, y: int, width: int, height: int, title: str, body: str, fill: str) -> str:
    title_escaped = html.escape(title)
    body_lines = body.split("\n")
    parts = [f'<rect x="{x}" y="{y}" width="{width}" height="{height}" rx="16" fill="{fill}" stroke="#334155" stroke-width="2"/>',
             f'<text x="{x + 18}" y="{y + 34}" class="title">{title_escaped}</text>']
    for index, line in enumerate(body_lines):
        parts.append(f'<text x="{x + 18}" y="{y + 64 + index * 22}" class="body">{html.escape(line)}</text>')
    return "".join(parts)


def svg_arrow(x1: int, y1: int, x2: int, y2: int) -> str:
    return f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="#64748b" stroke-width="3" marker-end="url(#arrow)"/>'


def ecosystem_svg() -> str:
    width, height = 2100, 1280
    parts = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
             '<defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto"><path d="M0,0 L0,6 L9,3 z" fill="#64748b"/></marker></defs>',
             '<style>.title{font:700 18px Arial;fill:#0f172a}.body{font:14px Arial;fill:#334155}.layer{font:700 20px Arial;fill:#fff}.main{font:700 30px Arial;fill:#0f172a}</style>',
             '<rect width="100%" height="100%" fill="#f8fafc"/>',
             '<text x="40" y="50" class="main">PPJ Enterprise Application + AI &amp; Automation Ecosystem</text>']
    layers = [
        (90, "LAYER 1 - BUSINESS PROCESS", "#1d4ed8"),
        (330, "LAYER 2 - CORE ERP", "#7c3aed"),
        (530, "LAYER 3 - SPECIALIZED / THIRD-PARTY", "#b45309"),
        (730, "LAYER 4 - INTERNAL PPJ APPLICATIONS", "#047857"),
        (930, "LAYER 5 - DATA + AI + AUTOMATION", "#be123c"),
        (1130, "HUMAN CONTROL + CONTROLLED EXECUTION", "#334155"),
    ]
    for y, label, color in layers:
        parts.append(f'<rect x="40" y="{y}" width="2020" height="54" rx="12" fill="{color}"/><text x="65" y="{y + 35}" class="layer">{label}</text>')
    stage_width = 168
    short_labels = ["CUSTOMER", "MERCHANDISING", "TECHNICAL", "SOURCING", "PURCHASING", "WAREHOUSE", "PRODUCTION", "WASH", "QC / TQM", "LOGISTICS", "FINANCE"]
    for index, short_label in enumerate(short_labels):
        x = 50 + index * 182
        parts.append(svg_box(x, 160, stage_width, 120, short_label, "", "#dbeafe"))
        if index:
            parts.append(svg_arrow(x - 14, 220, x, 220))
    parts.append(svg_box(180, 405, 1740, 85, "WFX ERP", "Master Data | Order | Purchasing | Material | Inventory | Transaction", "#ede9fe"))
    parts.append(svg_box(130, 605, 1840, 85, "SPECIALIZED SYSTEMS", "MMX | eOffice | VNPT e-Invoice | IoT / WISER / INA | External Platforms", "#fef3c7"))
    parts.append(svg_box(130, 805, 1840, 85, "PPJ APPLICATION LAYER", "GTAS / IED | Datamarts | Internal Portals | Reporting / Search / Workflow", "#d1fae5"))
    parts.append(svg_box(130, 1005, 1840, 85, "DATA + AI + AUTOMATION", "DWH / Databricks -> PERRI / AI Hub -> OCR / RAG / Agents / RPA / API", "#ffe4e6"))
    parts.append(svg_box(130, 1190, 1840, 65, "CONTROL", "Human Confirm -> Permission / Evidence / Audit -> Controlled Write-back / Execute", "#e2e8f0"))
    for y1, y2 in [(280, 405), (490, 605), (690, 805), (890, 1005), (1090, 1190)]:
        parts.append(svg_arrow(1050, y1, 1050, y2))
    parts.append("</svg>")
    return "".join(parts)


def end_to_end_svg() -> str:
    width, height = 2600, 920
    parts = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
             '<defs><marker id="arrow" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto"><path d="M0,0 L0,6 L9,3 z" fill="#64748b"/></marker></defs>',
             '<style>.title{font:700 17px Arial;fill:#0f172a}.body{font:13px Arial;fill:#334155}.main{font:700 30px Arial;fill:#0f172a}.lane{font:700 18px Arial;fill:#fff}</style>',
             '<rect width="100%" height="100%" fill="#f8fafc"/>',
             '<text x="40" y="48" class="main">PPJ End-to-End Business Process + Application / AI Coverage</text>',
             '<rect x="40" y="75" width="2520" height="46" rx="10" fill="#1d4ed8"/><text x="60" y="105" class="lane">PRIMARY BUSINESS FLOW</text>']
    box_w = 215
    display_stages = [
        ("CUSTOMER", "Market Intelligence"),
        ("MERCHANDISING", "Costing\nInvoice Recheck"),
        ("TECHNICAL", "Knowledge | Fabric | CPD"),
        ("SOURCING", "Sourcing Chatbot"),
        ("PURCHASING", "GDI | Allocation\nIndent | Inventory"),
        ("WAREHOUSE", "AWB Extraction"),
        ("PRODUCTION", "Hanging Line IoT"),
        ("WASH", "Sampling | COWASH"),
        ("QC / TQM", "Defect | Thread Traceability"),
        ("LOGISTICS", "Expense Invoice Processing"),
        ("FINANCE", "Finance Mgmt\nInvoice | GRN Bot"),
    ]
    for index, (label, body) in enumerate(display_stages):
        x = 40 + index * 230
        parts.append(svg_box(x, 145, box_w, 170, f"{index + 1}. {label}", body, "#dbeafe"))
        if index:
            parts.append(svg_arrow(x - 15, 230, x, 230))
    parts.extend([
        '<rect x="40" y="365" width="2520" height="46" rx="10" fill="#047857"/><text x="60" y="395" class="lane">PARALLEL ENTERPRISE SERVICES</text>',
        svg_box(80, 440, 560, 130, "ADMINISTRATION", "Travel | Advance | Expense | Settlement", "#d1fae5"),
        svg_box(700, 440, 560, 130, "HR", "Employee Data | Trusted Employee Master", "#d1fae5"),
        svg_box(1320, 440, 560, 130, "AI PLATFORMS", "PERRI | AI Hub | Helpdesk", "#d1fae5"),
        svg_box(1940, 440, 560, 130, "EXTERNAL COLLABORATION", "Academic | Vendor | Discovery", "#d1fae5"),
        '<rect x="40" y="620" width="2520" height="46" rx="10" fill="#be123c"/><text x="60" y="650" class="lane">SYSTEM + DATA + AI BACKBONE</text>',
    ])
    backbones = [("WFX ERP", "Transaction"), ("GTAS / IED", "PPJ apps"), ("Third-party", "MMX / eOffice / IoT"), ("DWH / Databricks", "Governed data"), ("AI + Automation", "Assist / validate / automate"), ("Human Control", "Confirm / approve / audit")]
    for index, (title, body) in enumerate(backbones):
        x = 80 + index * 415
        parts.append(svg_box(x, 700, 360, 120, title, body, "#ffe4e6"))
        if index:
            parts.append(svg_arrow(x - 55, 760, x, 760))
    parts.append('<text x="80" y="875" class="title">Principle: AI does not replace WFX or GTAS. Only approved and auditable actions execute or write back.</text>')
    parts.append("</svg>")
    return "".join(parts)


def html_page(title: str, svg: str, source_name: str) -> str:
    return f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>{html.escape(title)}</title>
<style>body{{margin:0;background:#e2e8f0;font-family:Arial,sans-serif;color:#0f172a}}main{{padding:24px}}.panel{{background:white;border-radius:18px;padding:18px;box-shadow:0 8px 28px #0f172a20;overflow:auto}}.meta{{margin:0 0 14px;color:#475569}}svg{{display:block;max-width:none;height:auto}}</style>
</head><body><main><p class="meta">Source: {html.escape(source_name)} | Verified: 2026-09-18 | Offline render</p><div class="panel">{svg}</div></main></body></html>
"""


def architecture_document(source_text: str) -> str:
    frontmatter = """---
type: enterprise_architecture
source_event: PPJ-ENTERPRISE-ECOSYSTEM-20260918
last_verified: 2026-09-18
scope: PPJ enterprise applications, data, AI and automation ecosystem
status: canonical architecture view
---

"""
    alignment = """

---

## Canonical Governance Alignment - 2026-09-18

- WFX is the operational transaction backbone.
- GTAS and PPJ internal applications are the PPJ-specific application layer.
- Data, AI and automation attach to business processes and systems; they do not replace WFX or GTAS.
- Primary Domain follows business owner, primary users and primary business capability.
- Delivery Stream and Delivery Stage remain separate from domain, lifecycle and status.
- FAB_FabricDatamart_v2.2.0 and CPD_VisualSampleDatamart_v1.1.0 remain separate systems.
- External collaboration projects remain in EXTERNAL DEVELOPMENT at their evidenced delivery stage.
- AI recommendations and automated actions require permission, human confirmation, audit and fallback proportional to risk.

Related Canvas and Diagrams

[[PPJ_Enterprise_Application_AI_Automation_Ecosystem]]
[[PPJ_EndToEnd_Process_Automation_Coverage]]
[[PPJ_Data_Flow]]
[[PPJ_Domain_Encapsulation]]
[[PPJ_Portfolio]]
[[PPJ_Executive_Board_v2]]
[[PPJ_Roadmap_2026]]

Related Governance

[[PPJ_PORTFOLIO_CURRENT_SNAPSHOT]]
[[PPJ_PORTFOLIO_DOMAIN_MODEL]]
[[PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX]]
[[PPJ_PROJECT_ALIAS_MAP]]
"""
    cleaned = source_text.lstrip("\ufeff").strip()
    return frontmatter + cleaned + alignment


def update_report(changed: list[Path], unchanged: list[Path], backup_root: Path | None) -> str:
    changed_lines = "\n".join(f"- `{path.relative_to(ROOT).as_posix()}`" for path in changed) or "- None"
    unchanged_lines = "\n".join(f"- `{path.relative_to(ROOT).as_posix()}`" for path in unchanged) or "- None"
    backup_text = backup_root.relative_to(ROOT).as_posix() if backup_root else "Dry-run / no backup created"
    run_date = dt.date.today().isoformat()
    return f"""---
type: diagram_update_report
source_event: {SOURCE_EVENT}
date: {run_date}
status: applied
---

# PPJ Enterprise Ecosystem Diagram Update - 2026-09-18

## Outcome

Updated the managed enterprise architecture, data-flow and end-to-end portfolio diagrams from the user-provided ecosystem specification while retaining the 2026-09-18 canonical project, domain and delivery-state model.

## Scope

- Canonical ecosystem knowledge note
- Enterprise ecosystem Canvas and portable Mermaid, D2, SVG and HTML views
- Data-flow Canvas
- End-to-end process coverage Canvas and portable Mermaid, D2, SVG and HTML views
- Architecture links on Portfolio, Domain, Roadmap and Executive Board canvases
- Project Executive Boards are synchronized separately through `sync_ppj_project_boards.py`

## Changed or Created

{changed_lines}

## Already Current

{unchanged_lines}

## Safety

- Backup root: `{backup_text}`
- No project delivery stage, lifecycle, status or primary domain was changed by this architecture update.
- Personal, meeting, prototype and historical backup canvases were excluded.
- Canvas group labels use ASCII.
- Project cards remain unique on the Executive Board.

## Validation

- JSON parse and duplicate-node checks are required after apply.
- Portfolio consistency audit is required after apply.
- HTML views require visual QA.
"""


def main() -> int:
    args = parse_args()
    apply = bool(args.apply)
    if args.source:
        source_path = args.source.resolve()
        if not source_path.is_file():
            raise SystemExit(f"Source not found: {source_path}")
        source_text = source_path.read_text(encoding="utf-8-sig")
    elif DOC_PATH.exists():
        existing = DOC_PATH.read_text(encoding="utf-8-sig")
        marker = "# PPJ Enterprise Application + AI & Automation Ecosystem"
        if marker not in existing:
            raise SystemExit("Existing architecture note does not contain the expected title")
        source_text = existing[existing.index(marker):].split("\n---\n\n## Canonical Governance Alignment", 1)[0]
    else:
        raise SystemExit("Use --source for the initial build")

    ecosystem_svg_text = ecosystem_svg()
    e2e_svg_text = end_to_end_svg()
    desired: dict[Path, str] = {
        DOC_PATH: architecture_document(source_text),
        CANVAS_ROOT / "PPJ_Enterprise_Application_AI_Automation_Ecosystem.canvas": build_ecosystem_canvas(),
        CANVAS_ROOT / "PPJ_Enterprise_Application_AI_Automation_Ecosystem.mmd": mermaid_ecosystem(),
        CANVAS_ROOT / "PPJ_Enterprise_Application_AI_Automation_Ecosystem.d2": d2_ecosystem(),
        CANVAS_ROOT / "PPJ_Enterprise_Application_AI_Automation_Ecosystem.svg": ecosystem_svg_text,
        CANVAS_ROOT / "PPJ_Enterprise_Application_AI_Automation_Ecosystem.html": html_page("PPJ Enterprise Application + AI & Automation Ecosystem", ecosystem_svg_text, DOC_PATH.relative_to(ROOT).as_posix()),
        CANVAS_ROOT / "PPJ_Data_Flow.canvas": build_data_flow_canvas(),
        CANVAS_ROOT / "PPJ_EndToEnd_Process_Automation_Coverage.canvas": build_end_to_end_canvas(),
        CANVAS_ROOT / "PPJ_EndToEnd_Process_Automation_Coverage.mmd": mermaid_end_to_end(),
        CANVAS_ROOT / "PPJ_EndToEnd_Process_Automation_Coverage.d2": d2_end_to_end(),
        CANVAS_ROOT / "PPJ_EndToEnd_Process_Automation_Coverage.svg": e2e_svg_text,
        CANVAS_ROOT / "PPJ_EndToEnd_Process_Automation_Coverage.html": html_page("PPJ End-to-End Process + Application / AI Coverage", e2e_svg_text, DOC_PATH.relative_to(ROOT).as_posix()),
    }
    for name in ["PPJ_Domain_Encapsulation.canvas", "PPJ_Portfolio.canvas", "PPJ_Roadmap_2026.canvas", "PPJ_Executive_Board_v2.canvas"]:
        path = CANVAS_ROOT / name
        if not path.is_file():
            raise SystemExit(f"Required managed Canvas not found: {path}")
        desired[path] = update_executive_board(path) if name == "PPJ_Executive_Board_v2.canvas" else with_architecture_reference(path)

    changed: list[Path] = []
    unchanged: list[Path] = []
    for path, content in desired.items():
        current = path.read_text(encoding="utf-8-sig") if path.exists() else None
        (unchanged if current == content else changed).append(path)

    print("PPJ Enterprise Ecosystem Diagram Update")
    print(f"Mode: {'Apply' if apply else 'DryRun'}")
    print(f"Artifacts evaluated: {len(desired)}")
    print(f"Create/update: {len(changed)}")
    print(f"Unchanged: {len(unchanged)}")
    for path in changed:
        action = "UPDATE" if path.exists() else "CREATE"
        print(f" - {action}: {path.relative_to(ROOT)}")
    if not apply:
        print("DryRun only. No files were modified.")
        return 0

    stamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    backup_root = ROOT / "99_Attachments" / "Audit" / "Enterprise_Ecosystem_Diagram_Update_Backup" / stamp
    for path in changed:
        if path.exists():
            target = backup_root / path.relative_to(ROOT)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, target)
    for path in changed:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(desired[path], encoding="utf-8", newline="\n")

    report_content = update_report(changed, unchanged, backup_root)
    if REPORT_PATH.exists():
        report_backup = backup_root / REPORT_PATH.relative_to(ROOT)
        report_backup.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(REPORT_PATH, report_backup)
    REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)
    REPORT_PATH.write_text(report_content, encoding="utf-8", newline="\n")
    print(f"Backup root: {backup_root.relative_to(ROOT)}")
    print(f"Report: {REPORT_PATH.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
