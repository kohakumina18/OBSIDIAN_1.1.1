"""Generate PPJ_Digital_Application_AI_Automation_Ecosystem.canvas from the vault.

Dry run (validates, writes nothing):   python scripts/build_ppj_ecosystem_canvas.py
Write the Canvas:                      python scripts/build_ppj_ecosystem_canvas.py --write
One-line summary (used by the watcher): add --quiet
Independent check of the result:       python scripts/validate_ppj_ecosystem_canvas.py

The Canvas is kept in sync automatically: watch_ppj_executive_canvas.py (in --apply mode) runs this with --write
whenever the portfolio snapshot changes, so a project registered, renamed or moved on any device is reflected here.
Hand edits to the .canvas are overwritten by the next run.

Project data comes from the portfolio snapshot (the vault's own registry); the WFX / GTAS / third-party inventory
comes from the owner's operating-systems diagram recorded in PPJ_Operational_Systems_Landscape.md.

Built to be run unattended on any device, so the output depends only on the vault contents:
  - dates come from the snapshot, never from the clock;
  - the file is written in Obsidian's own canvas format (tabs, one object per line), LF, atomically, and only
    when its content changes - so opening the canvas in Obsidian does not create a diff for git to carry;
  - a project the curated table does not know is placed by its domain instead of aborting the run;
  - the file is NOT written if a structural check fails (duplicate ids, orphan edges, overlaps, missing projects).

Readability rules (the Canvas is read zoomed out, where body text is a few pixels high):
  - anything that must be legible at overview zoom is a Markdown heading: project name, code, status,
    group titles, system names; body text is detail for zooming in;
  - each project draws at most ONE business-affinity line; integration, planned and data lines are always drawn;
  - edge labels are the category word, plus a two- or three-word qualifier only for INTEGRATION and PLANNED;
  - WFX modules are ordered by the position of the projects that point at them, so lines run roughly parallel.
"""
from __future__ import annotations

import datetime as dt
import json
import math
import os
import re
import sys
from pathlib import Path


def _arg(name: str, default: str | None = None) -> str | None:
    return sys.argv[sys.argv.index(name) + 1] if name in sys.argv else default


VAULT = Path(_arg("--vault") or Path(__file__).resolve().parents[1])
SNAP = VAULT / "03_Projects/_Registry/Portfolio_Snapshots/PPJ_PORTFOLIO_SNAPSHOT_20260918.json"
OUT = VAULT / "03_Projects/Canvas/PPJ_Digital_Application_AI_Automation_Ecosystem.canvas"
DIAGRAM = "99_Attachments/PPJ_Operational_Systems_Landscape_Diagram.png"

snap = json.loads(SNAP.read_text("utf-8-sig"))
projects = {p["code"]: p for p in snap["projects"]}
RECONCILED = dt.date.fromisoformat(snap["last_verified"]).strftime("%d/%m/%Y")

# ---------------------------------------------------------------- geometry
CARD_W, CARD_H, PITCH, HDR = 1450, 520, 570, 170
CORRIDOR = 900               # free space between a domain column and the centre stack, for the lines
LX, LW = 0, 1650             # left domain column
CX, CW = LX + LW + CORRIDOR, 5400          # centre stack
RX, RW = CX + CW + CORRIDOR, 1650          # right domain column
QX, QW = RX + RW + 300, 3200               # far-right periphery
PX, PW = -4600, 3200                       # far-left periphery; wide margin for the Technical -> Costing curve
TOTAL_W = RX + RW
GAP = 200

# ------------------------------------------------------------------ colours
C_PROD, C_ACTIVE, C_AMBER, C_HOLD = "4", "5", "3", "2"
C_MAINT, C_CLOSED = "#6f8fa8", "#8c8c8c"
C_WFX, C_3P, C_GTAS, C_DATA, C_SHARED = "6", "#a0522d", "#5c6bc0", "#26a69a", "#d81b60"

nodes: list[dict] = []
edges: list[dict] = []
ids: set[str] = set()
rect: dict[str, tuple[float, float, float, float]] = {}
kind: dict[str, str] = {}
notices: list[str] = []      # worth reading, never blocks the write
problems: list[str] = []     # structural: blocks the write


def _add(n: dict, k: str) -> None:
    if n["id"] in ids:
        problems.append(f"duplicate id {n['id']}")
        return
    ids.add(n["id"])
    rect[n["id"]] = (n["x"], n["y"], n["width"], n["height"])
    kind[n["id"]] = k
    nodes.append(n)


# Obsidian renders h1/h2/h3 at roughly 2.0 / 1.6 / 1.35 times body size.
_HEAD = {"# ": (2.0, 52), "## ": (1.6, 42), "### ": (1.35, 35)}


def est_height(body: str, w: float) -> float:
    h = 44.0
    for line in body.split("\n"):
        if not line.strip():
            h += 12
            continue
        factor, lh = 1.0, 26
        for prefix, spec in _HEAD.items():
            if line.startswith(prefix):
                factor, lh = spec
                break
        visible = re.sub(r"\[\[[^\]|]*\|([^\]]*)\]\]", r"\1", line)      # a wikilink shows its alias only
        cpl = max(10, (w - 40) / (8.6 * factor))
        h += math.ceil(len(visible) / cpl) * lh
    return h


def text(nid, x, y, w, h, body, color=None):
    need = est_height(body, w)
    if need > h:
        notices.append(f"{nid}: text needs ~{need:.0f} > {h}")
    n = {"id": nid, "type": "text", "x": int(x), "y": int(y), "width": int(w), "height": int(h), "text": body}
    if color:
        n["color"] = color
    _add(n, "text")


def group(gid, x, y, w, h, label, color=None, title=None):
    """A group plus a large heading inside its top band: Obsidian draws group labels too small to read zoomed out."""
    n = {"id": gid, "type": "group", "x": int(x), "y": int(y), "width": int(w), "height": int(h), "label": label}
    if color:
        n["color"] = color
    _add(n, "group")
    heading = title or label
    hw = int(min(w - 60, len(heading) * 17.2 + 120))        # as wide as the h1 text needs; position chosen later
    text("hdr-" + gid, x + 30, y + 20, hw, HDR - 40, "# " + heading)


def slug(s: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


def pid(code: str) -> str:
    return "proj-" + slug(code)


# ------------------------------------------------------------ vault links
def resolve_link(p: dict) -> str | None:
    root = p.get("root_file")
    if not root:
        return None
    base = VAULT / "03_Projects"
    cand = base / root
    if not cand.exists():
        hits = sorted(h for h in base.rglob(Path(root).name) if "_Registry" not in h.parts and "Canvas" not in h.parts)
        if not hits:
            hits = sorted((VAULT / "02_BA_Knowledge").rglob(Path(root).name))
        if not hits:
            return None
        cand = hits[0]
    rel = cand.relative_to(VAULT).with_suffix("").as_posix()
    return f"[[{rel}|{p['code']}]]"


# ----------------------------------------------------- status classification
def status_class(p: dict) -> str:
    lc = (p.get("lifecycle") or "").lower()
    if "closed" in lc:
        return "closed"
    if "on hold" in lc:
        return "hold"
    if "production" in lc:
        return "production"
    if "maintenance" in lc or lc == "support":
        return "maint"
    if any(k in lc for k in ("uat", "pre-go-live", "evaluation", "pre-poc", "analysis", "product design", "rollout")):
        return "amber"
    return "active"


CLASS_COLOR = {"production": C_PROD, "active": C_ACTIVE, "amber": C_AMBER, "hold": C_HOLD,
               "maint": C_MAINT, "closed": C_CLOSED}
CLASS_LABEL = {"production": "Production / Operational", "active": "Active / Development",
               "amber": "UAT / Evaluation / Analysis", "hold": "On Hold", "maint": "Maintenance / Support",
               "closed": "Closed / Archived"}

# ------------------------------------------------------------ project table
# zone, friendly name, type (class label), capability, optional system-of-record line, optional note
P = {
    "MER_CostingAgenticPlatform_v1.1.0": ("MER", "Agentic Costing Platform", "AI APPLICATION (agents / decision support)",
        "Costing and quotation package: Sew Agent, Wash Agent, BOM, consumption, similar style. AI proposes, domain expert approves.",
        None, "Also relates to: Bill of Material, GTAS Costing."),
    "MER_MarketIntelligence_v1.1.0": ("MER", "Market Intelligence", "AI APPLICATION (data intelligence)",
        "Market, customer, product and material opportunity signals from external data and internal history.",
        "Intelligence layer - not a system of record.", "Data input: Enterprise Data / DWH and sales / PO / fabric history (no line drawn)."),
    "MER_InvoiceDataRecheck_v1.1.0": ("MER", "Invoice Data Recheck", "AUTOMATION (audit / rule engine)",
        "Cross-check costing, commercial and invoice data with configurable customer rule packs; exceptions go to human review.", None, None),
    "MER_POCommit_v1.1.0": ("MER", "PO Commit Automation", "AUTOMATION",
        "Customer order to MER PO creation; about 70-80% of customer scenarios covered. Historical record.", None,
        "Historical affinity: Buyer Order Management (no line drawn for closed projects)."),
    "AI_PERRIPlatform_v3.2.0": ("SHARED", "PERRI Enterprise Chatbot", "INTERNAL PLATFORM (shared AI channel)",
        "Enterprise Q&A and orchestration: intent, agent / tool, controlled response. Not a business-domain application.", None,
        "Enterprise knowledge access: no per-project dependency drawn."),
    "AI_ApplicationHub_v2.1.0": ("SHARED", "PPJ AI Hub", "INTERNAL PLATFORM (shared AI access layer)",
        "AI application discovery, access and launch layer. Not the project registry.", None,
        "No project is drawn as using AI Hub - none is confirmed."),
    "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0": ("SHARED", "GLPI Helpdesk AI Chatbot", "AI APPLICATION (IT helpdesk)",
        "IT helpdesk Q&A, troubleshooting, ERP support and resolved-issue knowledge. Separate from PERRI.", None, None),
    "HR_EmployeeDataPlatform_v1.1.0": ("HR", "HR Employee Data Platform", "WORKFLOW (data standardization)",
        "Employee data collection, validation and standardization into an Employee Master; applicant extraction / prefill.", None, None),
    "ADMIN_ExpenseManagement_v1.1.0": ("ADMIN", "Business Travel & Expense Management", "WORKFLOW",
        "Request, approval, trip, advance, expense, settlement; multi-traveler requests. E-office integration is in scope.", None,
        "E-office service has lapsed: reopening needs a paid contract and the vendor is re-quoting (BOD review 24/09) - "
        "integration blocked. Also relates to: HRIS, Finance."),
    "SCP_SourcingChatbot_v2.3.0": ("SRC", "Sourcing AI Chatbot", "AI APPLICATION (RAG / chatbot)",
        "Supplier, material and sample search, comparison and sourcing knowledge retrieval.", None,
        "Attached to WFX Inventory Control - supplier data sits in Inventory (owner decision 2026-09-25). "
        "Also relates to: MMSx, Raw Material Planning."),
    "PUR_AdhocIndentSouth_v1.0.0": ("SRC", "Adhoc Indent Automation (South)", "AUTOMATION (rule-based)",
        "Repeated Adhoc Indent processing for the South region; WFX compatibility.", None, None),
    "PUR_HMLabelProcessing_v1.0.0": ("SRC", "H&M Label-O Processing", "AUTOMATION (rule-based)",
        "H&M Label-O processing; paused pending a scalable business case.", None, None),
    "PUR_InventoryReport_v2.1.0": ("SRC", "Purchasing Inventory Report", "DATA PLATFORM (reporting / visibility)",
        "Purchasing inventory and material visibility. A data-visibility layer, not an automation bot.", None,
        "Also relates to: WFX Inventory Control, MMSx."),
    "PUR_MaterialAllocation_v1.1.0": ("SRC", "Material Allocation Automation", "AUTOMATION (workflow / transaction)",
        "Surplus-material unreserve and reallocation across OCs. First Sewing / Embroidery flow validated.", None,
        "Also relates to: WFX Raw Material Planning, Purchase Order Management."),
    "PUR_GDIAutomation_v1.0.0": ("SRC", "GDI Automation", "AUTOMATION (API-first transaction)",
        "Goods dispatch / GDI data entry through WFX GET / POST APIs; API specification and UAT still ahead.",
        "System of Record: WFX.", "Also relates to: WFX Logistics In-bound, Inventory Control."),
    "FIN_FinanceManagement_v1.2.0": ("FIN", "Finance AI Management", "AI APPLICATION (finance analytics platform)",
        "WS1 financial Q&A; WS2 OC cost and profitability control; WS3 factory cost integrity. Cross-system finance intelligence.",
        "Data sources: WFX Finance + DWH + Power BI + GTAS BI Report / Financial Statements. Not a financial system of record.", None),
    "FIN_InvoiceDownloader_v1.2.0": ("FIN", "Invoice Downloader", "AUTOMATION",
        "Downloads VNPT e-invoice files: session / cookie management and file retrieval. No accounting entry.", None, None),
    "ACC_GRNSupplierInvoiceBot_v2.3.0": ("FIN", "GRN Supplier Invoice Bot", "AUTOMATION (transaction bot)",
        "Validation, business rules and automated data entry for GRN and supplier invoices.", None,
        "Also relates to: WFX Logistics In-bound (GRN), Purchase Order Management."),
    "ACC_InventoryReport_v1.0.0": ("FIN", "Accounting Inventory Report", "DATA PLATFORM (reporting)",
        "Accounting inventory reporting. Distinct from the Purchasing Inventory Report.", None, None),
    "EXIM.ExpenseInvoices.Automation.v1.1": ("FIN", "EXIM Expense Invoice Bot (legacy)", "AUTOMATION",
        "Legacy EXIM expense-invoice automation, replaced by LOG_ExpenseInvoiceProcessing_v1.2.2.", None,
        "Not in the 35-item baseline; present in the vault registry."),
    "LOG_ExpenseInvoiceProcessing_v1.2.2": ("WHL", "Expense Invoice Processing", "AUTOMATION (regional invoice)",
        "Expense invoices: regional and tax rules, validation, exceptions. Used by Finance, Logistics in-bound, export / import and "
        "other units. Regions: HCM, Da Nang, Nha Trang, Ha Noi.", None,
        "One project - confirmed by the owner 2026-09-25 (see gap note 1)."),
    "WH_AWBExtraction_v1.1.0": ("WHL", "AWB Document Intelligence", "AI APPLICATION (document intelligence)",
        "AWB image OCR and DHL email parsing into one validated canonical AWB record; human validation.", None,
        "Also relates to: Logistics In-bound. Nothing is attached to GTAS Transportation (BOD review 24/09)."),
    "PROD_HangingLineIoT_v1.0.0": ("PROD", "Hanging Line IoT", "IOT",
        "Production hanging-line digitalization and monitoring. IoT / operational, not an LLM application.", None,
        "Attached to WFX Production Management AND Reporting & Analysis (owner decision 2026-09-25). "
        "Also relates to: Production Planning."),
    "WASH_SamplingManagement_v1.1.0": ("PROD", "Wash Sampling Management Portal", "WORKFLOW",
        "Wash sample request, planning, result and approval in the PPJ Group Portal.", None,
        "Also relates to: WFX Production Management."),
    "WASH_COWASH_v2.0.0": ("PROD", "COWASH Wash Operations", "SYSTEM / APPLICATION (production wash platform)",
        "Wash production workflow and operational data. Distinct from the sampling portal.", None,
        "Also relates to: WFX QC."),
    "QC_DefectDetection_v1.0.0": ("QC", "AI Defect Detection", "AI APPLICATION (computer vision)",
        "Image, defect detection, classification, QC review. Vendor proposal and NDA only - not an approved PoC.", None,
        "Stream: EXTERNAL DEVELOPMENT. Also relates to: WFX QA, Production Management."),
    "QC_ThreadTraceability_v1.0.0": ("QC", "RFID Thread Traceability", "POC / EVALUATION",
        "RFID thread identification and traceability. Business case only; no PoC approved.", None,
        "Stream: EXTERNAL DEVELOPMENT. No operational integration assumed."),
    "TD_TechnicalKnowledgePlatform_v2.1.0": ("FAB", "Technical Knowledge Platform", "DATA PLATFORM (knowledge foundation)",
        "Reusable technical knowledge for pattern, BOM, consumption, costing, sew, wash and technical search.",
        "Knowledge / data foundation - not an ERP system of record.", None),
    "FAB_FabricDatamart_v2.2.0": ("FAB", "Fabric Datamart", "DATA PLATFORM (datamart)",
        "Fabric, Hanger, QR and material reference data (Directus). Separate from CPD.", None, None),
    "CPD_VisualSampleDatamart_v1.1.0": ("FAB", "Visual Sample Datamart", "DATA PLATFORM (datamart)",
        "3D / visual sample library and image search. Separate from FD.", None, None),
    "PPJxStratova.AI": ("FAB", "Stratova AI (historical)", "ARCHIVED (former AI PoC)",
        "Closed in the vault registry. The current pattern-generation PoC is tracked as DISCOVERY_PatternGenerationPoC (zone 06).", None,
        "Business affinity: Gerber, ShapeShifter - no integration confirmed."),
    "PPJxNUNOX.ScanTrial": ("POC", "NUNOX Scan Trial", "POC / EVALUATION",
        "Fabric scanning and Fabric / Garment Digital Library evaluation. Session outcome unconfirmed.", None,
        "Stream: EXTERNAL DEVELOPMENT. No operational integration assumed."),
    "EXT_AcademicCollaboration_v1.1.0": ("COLLAB", "Academic Collaboration (UIT)", "COLLABORATION",
        "Academic collaboration: prototypes, research, competitions, talent pipeline. Not a production application.", None,
        "Stream: EXTERNAL DEVELOPMENT."),
    "AI.Automation.Workshop.202606": ("ARCH", "AI Automation Workshop (June 2026)", "ARCHIVED (enablement)",
        "Workshop record. No active tasks.", None, None),
    "AI.Automation.Workshop.Analysis.202606": ("ARCH", "Workshop Analysis (June 2026)", "ARCHIVED (enablement)",
        "Workshop analysis record. No active tasks.", None, "Not in the 35-item baseline; present in the vault registry."),
    "VITAS.Sharing.202606": ("ARCH", "VITAS Sharing (June 2026)", "ARCHIVED (external engagement)",
        "External sharing record. No active tasks.", None, None),
}

# Code used in the 35-item baseline, where it differs from the vault's canonical code
# (the vault adopted <DEPARTMENT>_<APPLICATION>_v<M>.<m>.<p> on 2026-09-18).
BASELINE = {
    "MER_CostingAgenticPlatform_v1.1.0": "COSTING.AGENTIC.PLATFORM.v1.1",
    "MER_MarketIntelligence_v1.1.0": "MER.MARKET.INTELLIGENCE.v1.1",
    "MER_InvoiceDataRecheck_v1.1.0": "MER.INVOICE.DATA.RECHECK.v1.1",
    "MER_POCommit_v1.1.0": "MER.PO.Commit.v1.1",
    "AI_PERRIPlatform_v3.2.0": "PPJ.PERRI.Chatbot.v3.2",
    "AI_ApplicationHub_v2.1.0": "PPJ.AI.Hub.v2.1",
    "HR_EmployeeDataPlatform_v1.1.0": "HR.SSPFD.Workflow.v1.1",
    "ADMIN_ExpenseManagement_v1.1.0": "Admin Expense Management.v1.1",
    "SCP_SourcingChatbot_v2.3.0": "SCP.SOURCING.CHATBOT.v2.3",
    "PUR_AdhocIndentSouth_v1.0.0": "PUR.Adhoc.Indent.South.v1.0",
    "PUR_HMLabelProcessing_v1.0.0": "PUR.HM.LabelO.Processing.Automation.v1.0",
    "PUR_InventoryReport_v2.1.0": "PUR.Inventory.Report.v2.1",
    "PUR_MaterialAllocation_v1.1.0": "PUR.Material.Allocation.v1.1",
    "PUR_GDIAutomation_v1.0.0": "PUR.GDI.Automation.v1.0",
    "FIN_FinanceManagement_v1.2.0": "FIN.AI.FINANCE.MANAGEMENT.v1.2",
    "FIN_InvoiceDownloader_v1.2.0": "PPJ.InvoiceDownloader.v1.2",
    "ACC_GRNSupplierInvoiceBot_v2.3.0": "ACC.GRNInvoiceMatching.v2.3 (vault calls this name misleading)",
    "ACC_InventoryReport_v1.0.0": "ACC.Inventory.Report.v1.0",
    "LOG_ExpenseInvoiceProcessing_v1.2.2": "PPJ.ExpenseInvoices.v1.1 + LOG.EXPENSE.INVOICES.V1.2 (one project, confirmed 2026-09-25)",
    "WH_AWBExtraction_v1.1.0": "WH.AWB.EXTRACTION.v1.1",
    "PROD_HangingLineIoT_v1.0.0": "PROD.IOT.CHuyenTreo.v1.0",
    "WASH_SamplingManagement_v1.1.0": "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1",
    "WASH_COWASH_v2.0.0": "PROD.COWASH.v2.0",
    "QC_DefectDetection_v1.0.0": "PPJxQSee.AI",
    "QC_ThreadTraceability_v1.0.0": "QC.Primo1D.RFID.Thread.v1.0",
    "TD_TechnicalKnowledgePlatform_v2.1.0": "TD.TechnicalKnowledge.Platform.v2.1",
    "FAB_FabricDatamart_v2.2.0": "FD.Datamart.v2.2",
    "CPD_VisualSampleDatamart_v1.1.0": "CPD.Datamart.v1.1",
    "EXT_AcademicCollaboration_v1.1.0": "PPJ.UIT.ACADEMIC.COLLABORATION.v1.1",
}

# Where a project the curated table does not know is placed: by its Primary Domain.
DOMAIN_ZONE = {
    "Merchandising": "MER", "Sourcing / Purchasing": "SRC", "Finance / Accounting": "FIN",
    "Production + Wash": "PROD", "QC / TQM": "QC", "Warehouse": "WHL", "Logistics / EXIM": "WHL", "HR": "HR",
    "Administration": "ADMIN", "Fabric / Textiles Technique": "FAB", "Internal Chatbot & AI Platforms": "SHARED",
    "External Collaboration": "COLLAB",
}
# Preferred order inside a zone; anything else in the zone follows in registry order.
# SRC: Inventory Report sits between Material Allocation and GDI so both of its data lines are short and straight.
ZONE_ORDER = {
    "MER": ["MER_CostingAgenticPlatform_v1.1.0", "MER_MarketIntelligence_v1.1.0", "MER_InvoiceDataRecheck_v1.1.0", "MER_POCommit_v1.1.0"],
    "SRC": ["SCP_SourcingChatbot_v2.3.0", "PUR_AdhocIndentSouth_v1.0.0", "PUR_HMLabelProcessing_v1.0.0",
            "PUR_MaterialAllocation_v1.1.0", "PUR_InventoryReport_v2.1.0", "PUR_GDIAutomation_v1.0.0"],
    "WHL": ["WH_AWBExtraction_v1.1.0", "LOG_ExpenseInvoiceProcessing_v1.2.2"],
    "HR": ["HR_EmployeeDataPlatform_v1.1.0"],
    "ADMIN": ["ADMIN_ExpenseManagement_v1.1.0"],
    "FIN": ["FIN_FinanceManagement_v1.2.0", "FIN_InvoiceDownloader_v1.2.0", "ACC_GRNSupplierInvoiceBot_v2.3.0",
            "ACC_InventoryReport_v1.0.0", "EXIM.ExpenseInvoices.Automation.v1.1"],
    "QC": ["QC_DefectDetection_v1.0.0", "QC_ThreadTraceability_v1.0.0"],
    "PROD": ["PROD_HangingLineIoT_v1.0.0", "WASH_SamplingManagement_v1.1.0", "WASH_COWASH_v2.0.0"],
    "SHARED": ["AI_PERRIPlatform_v3.2.0", "AI_ApplicationHub_v2.1.0", "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"],
    "FAB": ["TD_TechnicalKnowledgePlatform_v2.1.0", "FAB_FabricDatamart_v2.2.0", "CPD_VisualSampleDatamart_v1.1.0", "PPJxStratova.AI"],
    "POC": ["PPJxNUNOX.ScanTrial"],
    "COLLAB": ["EXT_AcademicCollaboration_v1.1.0"],
    "ARCH": ["AI.Automation.Workshop.202606", "AI.Automation.Workshop.Analysis.202606", "VITAS.Sharing.202606"],
}

registered = {c: p for c, p in projects.items() if not p.get("candidate")}
for code in [c for c in P if c not in registered]:            # curated but gone (renamed / removed)
    del P[code]
    notices.append(f"curated project {code} is no longer registered - card dropped; its lines are skipped")
for code, p in registered.items():                            # registered but not curated (new / renamed)
    if code in P:
        continue
    closed = "closed" in (p.get("lifecycle") or "").lower()
    zone = "ARCH" if (closed and p.get("domain") == "External Collaboration") else DOMAIN_ZONE.get(p.get("domain"), "NEW")
    P[code] = (zone, code, "UNCLASSIFIED (curate in scripts/build_ppj_ecosystem_canvas.py)",
               " ".join((p.get("outcome") or "").split())[:220], None, "Placed automatically by domain; no curated card yet.")
    notices.append(f"{code}: not in the curated table - placed in zone {zone} by domain '{p.get('domain')}'")


def zone_codes(zone: str) -> list[str]:
    listed = [c for c in ZONE_ORDER.get(zone, []) if c in P and P[c][0] == zone]
    return listed + [c for c, v in P.items() if v[0] == zone and c not in listed]


def card(code: str, x: int, y: int) -> None:
    zone, friendly, klass, cap, sor, note = P[code]
    p = projects[code]
    link = resolve_link(p)
    lines = [f"# {friendly}", f"## {link}" if link else f"## {code}", f"## {p['lifecycle']}",
             f"### {klass}", "", f"Domain: {p['domain']}"]
    if code in BASELINE:
        lines.append(f"Baseline code: {BASELINE[code]}")
    lines.append(f"Capability: {cap}")
    if sor:
        lines.append(sor)
    if note:
        lines.append(note)
    if not link:
        lines.append("Vault Link: Not found")
    text(pid(code), x, y, CARD_W, CARD_H, "\n".join(lines), CLASS_COLOR[status_class(p)])


def column_group(gid, label, x, y, w, codes, color=None, title=None):
    h = HDR + max(1, len(codes)) * PITCH
    group(gid, x, y, w, h, label, color, title)
    for i, c in enumerate(codes):
        card(c, x + (w - CARD_W) // 2, y + HDR + i * PITCH)
    return y + h


# =================================================================== TOP ZONE
PANEL_W = (TOTAL_W - 2 * 300) // 3
text("eco-title", 0, -1700, TOTAL_W, 260,
     "# PPJ GROUP - Digital Application, AI & Automation Ecosystem\n"
     "## ERP -> Enterprise Applications -> Internal Systems -> AI & Automation")
text("eco-subtitle", 0, -1420, TOTAL_W, 200,
     f"### Portfolio Baseline: 19/09/2026  |  Vault Reconciliation: {RECONCILED} (portfolio snapshot)\n"
     "Generated From: PPJ AI & Automation Portfolio (vault registry) + PPJ operating-systems landscape "
     "([[02_BA_Knowledge/Enterprise_Architecture/PPJ_Operational_Systems_Landscape|Operational Systems Landscape]]). "
     "Regenerated automatically when the portfolio snapshot changes.")

text("eco-exec-summary", 0, -1180, PANEL_W, 900,
     "# PPJ DIGITAL EVOLUTION\n\n"
     "### 1. WFX provides the ERP transaction backbone.\n"
     "### 2. Third-party enterprise applications provide specialized capabilities.\n"
     "### 3. GTAS applications were built internally to fill operational capability gaps.\n"
     "### 4. AI & Automation projects add an intelligence and automation layer across existing processes.\n"
     "### 5. Shared data, knowledge and AI platforms serve reusable cross-functional capabilities.\n"
     "### 6. AI does not replace the ERP; it augments ERP, enterprise systems and decisions.")

text("eco-principles", PANEL_W + 300, -1180, PANEL_W, 900,
     "# ARCHITECTURE PRINCIPLES\n\n"
     "### - WFX remains core ERP / transaction backbone.\n"
     "### - AI projects augment rather than duplicate source systems.\n"
     "### - System of record must remain explicit.\n"
     "### - Prefer API-based integration where available.\n"
     "### - Business affinity does not imply technical integration.\n"
     "### - Human review remains required for uncertain AI decisions.\n"
     "### - Reusable data / knowledge layers serve multiple projects.\n"
     "### - Shared AI services reduce duplicate implementations.\n"
     "### - Status and lifecycle are independent from business domain.")

cur = {k: 0 for k in CLASS_LABEL}
for p in registered.values():
    cur[status_class(p)] += 1
text("eco-inventory", 2 * (PANEL_W + 300), -1180, TOTAL_W - 2 * (PANEL_W + 300), 900,
     "# PORTFOLIO INVENTORY\n\n"
     "## Baseline 19/09/2026 - 35 initiatives\n"
     "### Active / Dev 16 | Production 6 | Maintenance 4 | Closed 4 | On Hold 3 | Evaluation 2\n\n"
     f"## Current Vault {RECONCILED} - {len(registered)} registered records\n"
     f"### Production {cur['production']} | Active / Dev {cur['active']} | UAT / Eval / Analysis {cur['amber']} | "
     f"Maintenance {cur['maint']} | On Hold {cur['hold']} | Closed {cur['closed']}\n\n"
     "Baseline is kept unchanged. Bucket definitions differ - see the gap notes.")

# ============================================================ LEFT COLUMN
# Fabric / Technical sits under Merchandising in the same column: Technical Knowledge feeds the Costing platform,
# and with both cards on one column that line runs down the outer margin instead of across other cards.
y_end = column_group("grp-mer", "04.2 MERCHANDISING", LX, 0, LW, zone_codes("MER"))
y_end = column_group("grp-src", "04.1 SOURCING / PURCHASING", LX, y_end + GAP, LW, zone_codes("SRC"))
y_end = column_group("grp-fab", "04.7 FABRIC / TEXTILES TECHNIQUE", LX, y_end + GAP, LW, zone_codes("FAB"))

# ============================================================ RIGHT COLUMN
ry = column_group("grp-hr", "04.8 HR", RX, 0, RW, zone_codes("HR"))
ry = column_group("grp-admin", "04.9 ADMINISTRATION", RX, ry + GAP, RW, zone_codes("ADMIN"))
ry = column_group("grp-fin", "04.3 FINANCE / ACCOUNTING", RX, ry + GAP, RW, zone_codes("FIN"))
ry = column_group("grp-qc", "04.5 QC / TQM", RX, ry + GAP, RW, zone_codes("QC"))
ry = column_group("grp-prod", "04.4 PRODUCTION + WASH", RX, ry + GAP, RW, zone_codes("PROD"))
ry = column_group("grp-whl", "04.6 WAREHOUSE / LOGISTICS", RX, ry + GAP, RW, zone_codes("WHL"))

# ============================================================ EDGE SPEC
# Declared before the centre stack is laid out, because WFX module order is derived from it.
# Category: A INTEGRATION (confirmed), B PLANNED, C AFFINITY (business capability only), D DATA dependency.
S = pid
EDGE_SPEC = [
    # --- integration / planned: always drawn
    (S("PUR_MaterialAllocation_v1.1.0"), "wfx-inventory-control", "A", "validated flow", "right", "left"),
    (S("FIN_InvoiceDownloader_v1.2.0"), "tp-vnpt-e-invoice", "A", "VNPT download", "left", "right"),
    (S("MER_CostingAgenticPlatform_v1.1.0"), "gtas-ied", "B", "GTAS/IED contract", "right", "left"),
    (S("PUR_GDIAutomation_v1.0.0"), "wfx-purchase-order-management", "B", "WFX API", "right", "left"),
    (S("ADMIN_ExpenseManagement_v1.1.0"), "tp-e-office", "B", "E-office, blocked", "left", "right"),
    # --- data dependencies: always drawn
    (S("TD_TechnicalKnowledgePlatform_v2.1.0"), S("MER_CostingAgenticPlatform_v1.1.0"), "D", "", "left", "left"),
    (S("PUR_InventoryReport_v2.1.0"), S("PUR_MaterialAllocation_v1.1.0"), "D", "", "top", "bottom"),
    (S("PUR_InventoryReport_v2.1.0"), S("PUR_GDIAutomation_v1.0.0"), "D", "", "bottom", "top"),
    (S("FIN_FinanceManagement_v1.2.0"), "wfx-finance", "D", "", "left", "right"),
    (S("FIN_FinanceManagement_v1.2.0"), "data-dwh", "D", "", "left", "right"),
    (S("FIN_FinanceManagement_v1.2.0"), "tp-power-bi", "D", "", "left", "right"),
    (S("FIN_FinanceManagement_v1.2.0"), "gtas-bi-report", "D", "", "left", "right"),
    (S("PROD_HangingLineIoT_v1.0.0"), "tp-iot-wiser-ina", "D", "", "left", "right"),
    ("wfx-core", "data-dwh", "D", "", "bottom", "top"),
    (S("FAB_FabricDatamart_v2.2.0"), S("TD_TechnicalKnowledgePlatform_v2.1.0"), "D", "", "top", "bottom"),
    (S("CPD_VisualSampleDatamart_v1.1.0"), S("TD_TechnicalKnowledgePlatform_v2.1.0"), "D", "", "left", "left"),
    (S("TD_TechnicalKnowledgePlatform_v2.1.0"), "data-technical-knowledge", "D", "", "right", "left"),
    # --- business affinity: the primary one per project; the others are named on the card instead
    (S("MER_CostingAgenticPlatform_v1.1.0"), "wfx-budgeting-costing", "C", "", "right", "left"),
    (S("MER_MarketIntelligence_v1.1.0"), "wfx-buyer-order-management", "C", "", "right", "left"),
    (S("MER_InvoiceDataRecheck_v1.1.0"), "wfx-budgeting-costing", "C", "", "right", "left"),
    (S("SCP_SourcingChatbot_v2.3.0"), "wfx-inventory-control", "C", "", "right", "left"),
    (S("PUR_AdhocIndentSouth_v1.0.0"), "wfx-purchase-order-management", "C", "", "right", "left"),
    (S("PUR_HMLabelProcessing_v1.0.0"), "wfx-purchase-order-management", "C", "", "right", "left"),
    (S("WH_AWBExtraction_v1.1.0"), "wfx-logistics-in-bound", "C", "", "left", "right"),
    (S("LOG_ExpenseInvoiceProcessing_v1.2.2"), "grp-wfx", "C", "WFX charge rules", "left", "right"),
    (S("HR_EmployeeDataPlatform_v1.1.0"), "tp-hris", "C", "", "left", "right"),
    (S("ACC_GRNSupplierInvoiceBot_v2.3.0"), "wfx-finance", "C", "", "left", "right"),
    (S("QC_DefectDetection_v1.0.0"), "wfx-qc", "C", "", "left", "right"),
    (S("PROD_HangingLineIoT_v1.0.0"), "wfx-production-management", "C", "", "left", "right"),
    (S("PROD_HangingLineIoT_v1.0.0"), "wfx-reporting-analysis", "C", "", "left", "right"),
    (S("WASH_SamplingManagement_v1.1.0"), "wfx-sampling", "C", "", "left", "right"),
    (S("WASH_COWASH_v2.0.0"), "wfx-production-management", "C", "", "left", "right"),
    (S("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"), "tp-glpi", "C", "", "right", "right"),
]
CURVED = {(S("TD_TechnicalKnowledgePlatform_v2.1.0"), S("MER_CostingAgenticPlatform_v1.1.0")),
          (S("CPD_VisualSampleDatamart_v1.1.0"), S("TD_TechnicalKnowledgePlatform_v2.1.0")),
          (S("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"), "tp-glpi")}


def centre_y(nid: str) -> float | None:
    r = rect.get(nid)
    return None if r is None else r[1] + r[3] / 2


def ordered_modules(names: list[str], slot_y: list[float]) -> list[str]:
    """Order WFX modules by the mean height of the projects pointing at them, so lines run roughly parallel.
    A module nobody points at keeps its original slot height, so the order stays stable and deterministic."""
    def key(item):
        i, name = item
        ys = [centre_y(f) for f, t, *_ in EDGE_SPEC if t == "wfx-" + slug(name) and centre_y(f) is not None]
        return (sum(ys) / len(ys) if ys else slot_y[i], i)
    return [n for _, n in sorted(enumerate(names), key=key)]


# ============================================================ CENTRE STACK
# --- shared AI platforms (rows of three)
sy = 0
sh_codes = zone_codes("SHARED")
sh_rows = max(1, math.ceil(len(sh_codes) / 3))
sh = HDR + sh_rows * PITCH + 220 + 40
group("grp-shared", CX, sy, CW, sh, "04.10 SHARED AI PLATFORMS (enterprise capabilities, not domain apps)", C_SHARED,
      "04.10 SHARED AI PLATFORMS")
sx0 = CX + (CW - (3 * CARD_W + 2 * 150)) // 2
for i, c in enumerate(sh_codes):
    card(c, sx0 + (i % 3) * (CARD_W + 150), sy + HDR + (i // 3) * PITCH)
text("shared-note", sx0, sy + HDR + sh_rows * PITCH, 3 * CARD_W + 300, 220,
     "### Enterprise capabilities, not business-domain applications.\n"
     "Conceptual direction: business AI applications -> PPJ AI Hub -> shared AI services / governance / knowledge / models. "
     "Lines to AI Hub or PERRI are drawn only where documentation confirms use. None is confirmed today.")
y_gtas = sy + sh + GAP

# --- GTAS
NW, NH, NP = 1200, 150, 190
xs4 = [CX + 120 + c * 1320 for c in range(4)]
gtas_layout = [          # gtas_layout[c] is column c; lines from the left column land on column 0, from the right on column 3
    ["GTAS Costing", "GTAS IED", "GTAS Transportation", "GTAS Sampling"],
    ["GTAS Consumption", "GTAS Coats Integration", "GTAS Mixable", "GTAS Inventory"],
    ["GTAS Compliance", "GTAS FQM", "GTAS QC", "GTAS ECUS"],
    ["GTAS BI Report", "GTAS Financial Statements", "GTAS Production", "GTAS Salary"],
]
gh = HDR + 3 * NP + NH + 40
group("grp-gtas", CX, y_gtas, CW, gh, "03 GTAS INTERNAL APPLICATIONS - Legacy Internal Development", C_GTAS)
for c, col in enumerate(gtas_layout):
    for r, name in enumerate(col):
        body = f"## {name}"
        note = {"GTAS Costing": "starred in the source diagram",
                "GTAS Compliance": "BOD review: no user, dropped from the BOD slide",
                "GTAS Transportation": "BOD review: nothing attached"}.get(name)
        if note:
            body += "\n" + note
        text("gtas-" + slug(name.replace("GTAS ", "")), xs4[c], y_gtas + HDR + r * NP, NW, NH, body, C_GTAS)
y_3p = y_gtas + gh + GAP

# --- third party
TW, TH, TP = 1200, 170, 210
tp_nodes = {
    "MMSx": (0, 0, "Material management", "diagram"),
    "Gerber": (0, 1, "Pattern / technical design (CAD)", "diagram"),
    "ShapeShifter": (0, 2, "Technical / pattern / product development", "diagram"),
    "FastReactPlan": (1, 0, "Production planning", "diagram"),
    "GLPI": (3, 0, "Helpdesk / ITSM", "vault"),
    "HRIS": (3, 1, "Human Resources Information System", "diagram"),
    "E-office": (3, 2, "Document receiving, workflow, digital signing", "diagram"),
    "VNPT E-Invoice": (3, 3, "Electronic invoice source", "vault"),
    "Power BI": (3, 4, "Reporting / BI", "vault"),
    "IoT / WISER / INA": (3, 5, "Machine and production-line data", "vault"),
}
th = HDR + 5 * TP + TH + 40
group("grp-3p", CX, y_3p, CW, th, "02 THIRD-PARTY ENTERPRISE APPLICATIONS", C_3P)
for name, (c, r, purpose, src) in tp_nodes.items():
    origin = "on the operating-systems diagram" if src == "diagram" else "vault-confirmed, not on the diagram"
    text("tp-" + slug(name), xs4[c], y_3p + HDR + r * TP, TW, TH, f"## {name}\n{purpose} ({origin})", C_3P)
text("tp-note", xs4[1], y_3p + HDR + TP, 2 * TW + 120, 4 * TP - 40,
     "### On the owner's operating-systems diagram:\n### HRIS, E-office, MMSx, FastReactPlan, Gerber, ShapeShifter\n\n"
     "### Confirmed by vault documents, not on the diagram:\n### VNPT E-Invoice, Power BI, GLPI, IoT / WISER / INA\n\n"
     "Only listed applications are drawn. No further vendor application is assumed.")
y_wfx = y_3p + th + GAP

# --- WFX
MW, MH, MP = 1350, 150, 190
# Split by the side of the canvas their business owners sit on: merchandising / sourcing on the left,
# finance, production, quality and logistics on the right.
wfx_left = ["Buyer Order Management", "Budgeting & Costing", "Bill of Material", "Style Library", "BrandPLM",
            "Raw Material Planning", "Purchase Order Management", "Inventory Control"]
wfx_right = ["Finance", "Sampling", "QC", "QA", "Production Planning", "Production Management",
             "Logistics In-bound", "Logistics Out-bound"]
# The two descriptors printed at the centre of the owner's WFX diagram. They are not modules, but a project can be
# attached to them (the hanging-line IoT feeds Reporting & Analysis), so they get a node each. One per column keeps
# both columns nine rows tall.
wfx_descriptor_left = ["Time & Action Tracking"]
wfx_descriptor_right = ["Reporting & Analysis"]
slots = [y_wfx + HDR + i * MP + MH / 2 for i in range(9)]
wfx_left = ordered_modules(wfx_left + wfx_descriptor_left, slots)
wfx_right = ordered_modules(wfx_right + wfx_descriptor_right, slots)
WFX_ROWS = 9
wh = HDR + WFX_ROWS * MP - (MP - MH) + 40
group("grp-wfx", CX, y_wfx, CW, wh, "01 WFX ERP CORE - Core Enterprise Transaction System", C_WFX)
lx, rx_ = CX + 100, CX + CW - 100 - MW
def wfx_body(name: str) -> str:
    if name in wfx_descriptor_left + wfx_descriptor_right:
        return f"## {name}\ncentre descriptor in the source diagram"
    return f"## {name}" + ("\nhighlighted in the source diagram" if name == "Production Planning" else "")


for i, name in enumerate(wfx_left):
    text("wfx-" + slug(name), lx, y_wfx + HDR + i * MP, MW, MH, wfx_body(name), C_WFX)
for i, name in enumerate(wfx_right):
    text("wfx-" + slug(name), rx_, y_wfx + HDR + i * MP, MW, MH, wfx_body(name), C_WFX)
hx = lx + MW + 100
text("wfx-core", hx, y_wfx + HDR, rx_ - 100 - hx, WFX_ROWS * MP - (MP - MH),
     "# WFX ERP\n## Core Enterprise Transaction System\n\n"
     "### Textiles / Garments\n\n"
     "16 modules, named from the owner's operating-systems diagram. WFX is the system of record for orders, purchasing, "
     "material, inventory and operational transactions. AI and automation augment WFX; they do not replace it. "
     "Not every AI use case writes back to WFX.", C_WFX)
y_data = y_wfx + wh + GAP

# --- data foundation
DW, DH, DP = 1550, 190, 230
right_edge = CX + CW - 100          # level with the right-hand WFX / GTAS nodes, so lines reach it through the corridor
xs3 = [CX + 120, CX + 120 + (right_edge - DW - (CX + 120)) // 2, right_edge - DW]
data_nodes = [
    ("data-technical-knowledge", 0, 1, "Technical Knowledge", "Realised by TD_TechnicalKnowledgePlatform_v2.1.0 (zone 04.7)"),
    ("data-doc-retrieval", 1, 0, "Document / Knowledge Retrieval", "Conceptual foundation layer"),
    ("data-dwh", 2, 0, "Enterprise Data / DWH", "DWH / Databricks - confirmed in the 2026-09-18 ecosystem note"),
    ("data-master", 0, 0, "Master Data", "Conceptual foundation layer"),
    ("data-workflow", 1, 1, "Workflow & Process Data", "Conceptual foundation layer"),
    ("data-reporting", 2, 1, "Reporting & Analytics", "Power BI - confirmed in the Finance AI project documents"),
]
dh = HDR + DP + DH + 40
group("grp-data", CX, y_data, CW, dh, "05 DATA / KNOWLEDGE FOUNDATION", C_DATA)
for nid, c, r, name, src in data_nodes:
    text(nid, xs3[c], y_data + HDR + r * DP, DW, DH, f"## {name}\n{src}", C_DATA)
y_flow = y_data + dh + GAP

# --- capability flows (bottom centre; explanatory, no lines)
text("flow-labels", CX, y_flow, CW, 1000,
     "# CAPABILITY FLOWS (explanatory - not integrations)\n\n"
     "### SOURCING: Supplier > Material > Search > Decision\n"
     "### PURCHASING: PO > Material > Allocation > Dispatch\n"
     "### MERCHANDISING: Market > Costing > Quotation > PO\n"
     "### PRODUCTION: Planning > Production > Wash > QC\n"
     "### FINANCE: Transaction > Reporting > Cost Control > RCA\n"
     "### LOGISTICS: Shipment > AWB > Tracking > Invoice\n"
     "### ADMIN: Request > Approval > Booking > Advance > Expense > Settlement\n"
     "### TECHNICAL: Fabric > Pattern > BOM > Knowledge > Costing")

# ========================================================= FAR-LEFT PERIPHERY
if (VAULT / DIAGRAM).exists():        # the source of the WFX / GTAS / third-party layers, shown at the top left
    _add({"id": "source-systems-diagram", "type": "file", "x": PX, "y": -1700, "width": PW, "height": 1785,
          "file": DIAGRAM}, "file")
poc_y = y_3p
registry_link = "[[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER|{}]]" if (VAULT / "03_Projects/_Registry/PPJ_DISCOVERY_REGISTER.md").exists() else "{}"


def discovery_card(d: dict, x: int, y: int) -> str:
    nid = "poc-" + slug(d["label"])
    qs = d.get("open_questions") or []
    lines = ["# " + d["label"].replace("DISCOVERY_", ""), "## " + registry_link.format(d["label"]),
             f"## {d['status']}", "### VENDOR EVALUATION (discovery item, not a project)", "",
             "Scope: " + " ".join((d.get("scope") or "").split())[:230]]
    if qs:
        lines.append("Open: " + "; ".join(qs[:4]) + (" ..." if len(qs) > 4 else ""))
    lines.append("No operational integration assumed.")
    text(nid, x, y, CARD_W, CARD_H, "\n".join(lines), C_AMBER)
    return nid


def candidate_card(p: dict, x: int, y: int) -> str:
    nid = "poc-cand-" + slug(p["code"])
    target = p.get("link_target") or ""
    title = f"[[{target}|{p['code']}]]" if target and (VAULT / (target + ".md")).exists() else p["code"]
    text(nid, x, y, CARD_W, CARD_H,
         f"# {p['code']}\n## {title}\n## {p['lifecycle']}\n### CANDIDATE (not a registered project)\n\n"
         f"Capability: {' '.join((p.get('outcome') or '').split())[:200]}\nCanonical code not confirmed.", C_AMBER)
    return nid


discoveries = list(snap.get("discovery", []))
candidates = [p for p in snap["projects"] if p.get("candidate")]
first = [d for d in discoveries if d["label"] == "DISCOVERY_PatternGenerationPoC"]
rest = [d for d in discoveries if d["label"] != "DISCOVERY_PatternGenerationPoC"]
poc_slots: list[tuple[str, object]] = [("d", d) for d in first] + [("c", c) for c in candidates] \
    + [("p", c) for c in zone_codes("POC")] + [("d", d) for d in rest]
poc_h = HDR + max(1, math.ceil(len(poc_slots) / 2)) * PITCH
group("grp-poc", PX, poc_y, PW, poc_h, "06 POC / VENDOR EVALUATION (evaluation only)")
for i, (k, item) in enumerate(poc_slots):
    x, y = PX + 100 + (i % 2) * (CARD_W + 100), poc_y + HDR + (i // 2) * PITCH
    if k == "d":
        discovery_card(item, x, y)
    elif k == "p":
        card(item, x, y)
    else:
        candidate_card(item, x, y)

# legend (far left, below PoC)
ly = poc_y + poc_h + GAP
group("grp-legend", PX, ly, PW, HDR + 3 * 820, "09 LEGEND")
text("legend-nodes", PX + 100, ly + HDR, PW - 200, 780,
     "# NODE CATEGORIES\n"
     "### WFX ERP - purple\n### Third-Party System - brown\n### GTAS Internal System - indigo\n"
     "### Data / Knowledge Platform - teal\n### Shared AI Platform - pink group\n"
     "### Project card colour = STATUS (below)\n\n"
     "The class is on each card under the status: AI APPLICATION | AUTOMATION | WORKFLOW | DATA PLATFORM | "
     "INTERNAL PLATFORM | IOT | POC / EVALUATION | COLLABORATION | ARCHIVED")
text("legend-edges", PX + 100, ly + HDR + 820, PW - 200, 780,
     "# LINES\n"
     "### INTEGRATION - confirmed operational integration (green)\n"
     "### PLANNED - in scope or in development (orange)\n"
     "### DATA - data / knowledge dependency (blue)\n"
     "### AFFINITY - same business capability, no integration confirmed (grey)\n\n"
     "The label always names the category; colour is never the only signal. Each project draws at most one "
     "AFFINITY line; its other related systems are listed on the card.")
text("legend-status", PX + 100, ly + HDR + 1640, PW - 200, 780,
     "# STATUS COLOUR\n"
     "### Green - Production / Operational\n### Blue - Active / Development\n"
     "### Yellow - UAT / Evaluation / Analysis\n### Orange - On Hold\n"
     "### Grey-blue - Maintenance / Support\n### Grey - Closed / Archived\n\n"
     "The exact source status is written on each card under the project code.")

# ======================================================== FAR-RIGHT PERIPHERY
qy = column_group("grp-collab", "07 EXTERNAL COLLABORATION", QX, 0, 1650, zone_codes("COLLAB"))
qy = column_group("grp-arch", "08 ARCHIVED / CLOSED ENABLEMENT", QX, qy + GAP, 1650, zone_codes("ARCH"))
if zone_codes("NEW"):
    qy = column_group("grp-new", "04.11 NEW / UNCLASSIFIED (not yet curated)", QX, qy + GAP, 1650, zone_codes("NEW"),
                      title="04.11 NEW / UNCLASSIFIED")
guide_y = qy + GAP
text("guide", QX, guide_y, QW, 1300,
     "# HOW TO READ THIS CANVAS\n\n"
     "### Centre, top to bottom: shared AI platforms, GTAS, third-party, WFX ERP core, data / knowledge foundation.\n"
     "### Left and right: AI & Automation projects by business domain.\n"
     "### Position is not architecture. A line exists only where a vault document supports it.\n\n"
     "It is a layered ecosystem, not a strict dependency stack. The line label says how strong the relationship is; "
     "no line means no relationship is documented. Most links are AFFINITY - nothing is drawn as INTEGRATION unless "
     "a validated flow exists.")
gap_y = guide_y + 1300 + GAP
GAPS = [
    ("gap-1", "## GAP 1 - Expense invoices: RESOLVED\n\n"
     "The 35-item baseline lists PPJ.ExpenseInvoices.v1.1 and LOG.EXPENSE.INVOICES.V1.2 as two projects. On 2026-09-25 the "
     "owner confirmed they are ONE project, recorded as LOG_ExpenseInvoiceProcessing_v1.2.2 "
     "(DEC-20260925-EXPENSE-INVOICE-ONE-PROJECT). Both baseline names stay on the card as aliases.\n\n"
     "Still open: whether the earlier Export exclusion applies.\n\n"
     "The vault also holds two closed records outside the baseline: EXIM.ExpenseInvoices.Automation.v1.1 and "
     "AI.Automation.Workshop.Analysis.202606 - hence 36 records at the time of writing."),
    ("gap-2", "## GAP 2 - Canonical codes and status\n\n"
     "ACC.GRNInvoiceMatching.v2.3 (baseline) vs ACC_GRNSupplierInvoiceBot_v2.3.0 (vault canonical). The vault says the "
     "GRNInvoiceMatching name is misleading; the canonical code is used.\n\n"
     "PPJxStratova.AI: baseline says Active PoC; vault says Closed and tracks the live PoC as DISCOVERY_PatternGenerationPoC. "
     "Vault used.\n\n"
     "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0: baseline says Merchandising / Shared; vault domain is Internal Chatbot & AI Platforms. "
     "Vault used."),
    ("gap-3", "## GAP 3 - Systems inventory\n\n"
     "Source: owner's operating-systems diagram. GTAS has 16 applications, not 15: GTAS Costing was missing from the list "
     "in circulation.\n\n"
     "MMSx (diagram) vs MMX (2026-09-18 ecosystem note): treated as one system, name unconfirmed.\n\n"
     "The Finance AI canvas also names GTAS Factory, Quantity, Efficiency and ID. None is on the diagram; alias or "
     "separate application is unconfirmed.\n\n"
     "The red star on GTAS Costing and the green highlight on Production Planning are shown but their meaning is not stated.\n\n"
     "BOD review 24/09: GTAS Compliance has no user and is dropped from the BOD slide; nothing is attached to GTAS "
     "Transportation. Both stay here because this canvas records the whole landscape."),
    ("gap-4", "## GAP 4 - Relationship evidence\n\n"
     "No document confirms an integration at WFX-module or GTAS-application level. Those links are AFFINITY.\n\n"
     "Exceptions drawn stronger: PUR_MaterialAllocation validated flow into WFX (INTEGRATION, validated flow only); "
     "FIN_InvoiceDownloader to VNPT (INTEGRATION); PUR_GDIAutomation WFX API, ADMIN_ExpenseManagement E-office and "
     "MER_CostingAgenticPlatform GTAS/IED contract are in scope but not delivered (PLANNED).\n\n"
     "Status counts: baseline buckets and the recomputed buckets differ (e.g. UAT and Analysis are one bucket here), so the "
     "two rows are not directly comparable."),
]
GAP_H = 640
group("grp-gap", QX, gap_y, QW, HDR + len(GAPS) * (GAP_H + 40), f"DATA / GOVERNANCE GAP (curated notes, written {RECONCILED})",
      title="DATA / GOVERNANCE GAPS")
for i, (gid, body) in enumerate(GAPS):
    text(gid, QX + 100, gap_y + HDR + i * (GAP_H + 40), QW - 200, GAP_H, body)

# ====================================================================== EDGES
PREFIX = {"A": "INTEGRATION", "B": "PLANNED", "C": "AFFINITY", "D": "DATA"}
COLOUR = {"A": "4", "B": "2", "D": "5"}
# One AFFINITY line per project keeps the canvas readable; the owner can allow more for a project.
AFFINITY_MAX = {S("PROD_HangingLineIoT_v1.0.0"): 2}      # Production AND Reporting & Analysis - owner decision 2026-09-25
affinity_seen: dict[str, int] = {}
for f, t, cat, qualifier, fs, ts in EDGE_SPEC:
    # A curated line whose endpoint has gone (a project was renamed or removed) is skipped, not fatal.
    if f not in ids or t not in ids:
        notices.append(f"skipped line {f} -> {t}: endpoint not on the canvas (renamed or removed?)")
        continue
    if cat == "C":
        if affinity_seen.get(f, 0) >= AFFINITY_MAX.get(f, 1):
            notices.append(f"extra AFFINITY line from {f} dropped (limit {AFFINITY_MAX.get(f, 1)} per project)")
            continue
        affinity_seen[f] = affinity_seen.get(f, 0) + 1
    e = {"id": f"e{len(edges)+1:03d}-{f[:18]}-{t[:18]}", "fromNode": f, "fromSide": fs, "toNode": t, "toSide": ts,
         "label": PREFIX[cat] + (f" | {qualifier}" if qualifier else "")}
    if cat in COLOUR:
        e["color"] = COLOUR[cat]
    edges.append(e)
if "poc-discovery-patterngenerationpoc" in ids and candidates:
    cid = "poc-cand-" + slug(candidates[0]["code"])
    edges.append({"id": f"e{len(edges)+1:03d}-{cid[:18]}-poc-discovery-pat", "fromNode": cid, "fromSide": "left",
                  "toNode": "poc-discovery-patterngenerationpoc", "toSide": "right", "label": "DATA | benchmark",
                  "color": "5"})


# ================================================================= VALIDATION
def sock(nid, side):
    x, y, w, h = rect[nid]
    return {"left": (x, y + h / 2), "right": (x + w, y + h / 2), "top": (x + w / 2, y), "bottom": (x + w / 2, y + h)}[side]


def seg_hits_rect(p, q, r, pad=6):
    x, y, w, h = r
    x0, y0, x1, y1 = x - pad, y - pad, x + w + pad, y + h + pad
    t0, t1 = 0.0, 1.0
    dx, dy = q[0] - p[0], q[1] - p[1]
    for pp, qq in ((-dx, p[0] - x0), (dx, x1 - p[0]), (-dy, p[1] - y0), (dy, y1 - p[1])):
        if pp == 0:
            if qq < 0:
                return False
        else:
            r_ = qq / pp
            if pp < 0:
                if r_ > t1:
                    return False
                t0 = max(t0, r_)
            else:
                if r_ < t0:
                    return False
                t1 = min(t1, r_)
    return t0 <= t1


def straight_lines():
    for e in edges:
        if (e["fromNode"], e["toNode"]) not in CURVED:
            yield e, sock(e["fromNode"], e["fromSide"]), sock(e["toNode"], e["toSide"])


# Group headings sit left, centre or right in their group's top band - whichever no line runs through.
by_id = {n["id"]: n for n in nodes}
for hid in sorted(i for i in ids if i.startswith("hdr-")):
    gx, gy, gw, _ = rect[hid[4:]]
    hx, hy, hwid, hh = rect[hid]
    best = None
    for cx_ in (gx + 30, gx + (gw - hwid) // 2, gx + gw - 30 - hwid):
        hits = sum(1 for e, p, q in straight_lines()
                   if hid not in (e["fromNode"], e["toNode"]) and seg_hits_rect(p, q, (cx_, hy, hwid, hh)))
        if best is None or hits < best[0]:
            best = (hits, cx_)
    by_id[hid]["x"] = int(best[1])
    rect[hid] = (int(best[1]), hy, hwid, hh)

for e in edges:
    for k in ("fromNode", "toNode"):
        if e[k] not in ids:
            problems.append(f"orphan edge {e['id']}")
proj_nodes = [i for i in ids if i.startswith("proj-")]
if len(set(proj_nodes)) != len(registered) or len(proj_nodes) != len(registered):
    problems.append(f"project nodes {len(proj_nodes)} != registered records {len(registered)}")
leafs = [i for i in ids if kind[i] != "group"]
for i, a in enumerate(leafs):
    ax, ay, aw, ah = rect[a]
    for b in leafs[i + 1:]:
        bx, by, bw, bh = rect[b]
        if ax < bx + bw and bx < ax + aw and ay < by + bh and by < ay + ah:
            problems.append(f"overlap {a} / {b}")
groups = [i for i in ids if kind[i] == "group"]
for a in leafs:
    ax, ay, aw, ah = rect[a]
    if ay < -200 or a in ("guide", "flow-labels"):   # title zone and standalone panels by design
        continue
    inside = [g for g in groups if rect[g][0] <= ax and ax + aw <= rect[g][0] + rect[g][2]
              and rect[g][1] <= ay and ay + ah <= rect[g][1] + rect[g][3]]
    if len(inside) != 1:
        problems.append(f"{a} inside {len(inside)} groups")
for i, a in enumerate(groups):
    ax, ay, aw, ah = rect[a]
    for b in groups[i + 1:]:
        bx, by, bw, bh = rect[b]
        if ax < bx + bw and bx < ax + aw and ay < by + bh and by < ay + ah:
            problems.append(f"group overlap {a} / {b}")
for e in edges:                       # a line running behind a card misleads, but it should not stop the sync
    if (e["fromNode"], e["toNode"]) in CURVED:
        continue
    p, q = sock(e["fromNode"], e["fromSide"]), sock(e["toNode"], e["toSide"])
    for n in leafs:
        if n not in (e["fromNode"], e["toNode"]) and seg_hits_rect(p, q, rect[n]):
            notices.append(f"line {e['fromNode']} -> {e['toNode']} crosses {n}")
            break

ordered = [n for n in nodes if n["type"] == "group"] + [n for n in nodes if n["type"] != "group"]


def obsidian_canvas_json(doc_nodes: list[dict], doc_edges: list[dict]) -> str:
    """Serialize exactly as Obsidian saves a canvas: tab indents, one compact object per line, no final newline.

    Obsidian rewrites the file in this format whenever the canvas is opened and saved. Writing any other format
    means Obsidian and this builder keep rewriting each other's bytes, and every device commits the churn.
    """
    one = lambda o: json.dumps(o, ensure_ascii=False, separators=(",", ":"))
    return ("{\n\t\"nodes\":[\n" + ",\n".join("\t\t" + one(n) for n in doc_nodes) + "\n\t],\n"
            "\t\"edges\":[\n" + ",\n".join("\t\t" + one(e) for e in doc_edges) + "\n\t],\n"
            "\t\"metadata\":{\n\t\t\"version\":\"1.0-1.0\",\n\t\t\"frontmatter\":{}\n\t}\n}")


payload = obsidian_canvas_json(ordered, edges)
json.loads(payload)  # must parse


def write_if_changed(path: Path, data: str) -> str:
    """LF endings on every OS, atomic replace, and no write at all when nothing changed.

    'Nothing changed' is judged on content, not bytes: if Obsidian has re-saved the file in a slightly different
    layout but the nodes and edges are the same, the file is left alone rather than fought over.
    """
    raw = data.encode("utf-8")
    if path.exists():
        current = path.read_bytes()
        if current == raw:
            return "unchanged"
        try:
            if json.loads(current.decode("utf-8-sig")) == json.loads(data):
                return "unchanged (same content, Obsidian formatting kept)"
        except (ValueError, UnicodeDecodeError):
            pass
    tmp = path.with_name(path.name + ".ppj-sync-tmp")        # gitignored suffix
    tmp.write_bytes(raw)
    os.replace(tmp, path)
    return "written"


report = {
    "nodes": len(ordered), "edges": len(edges), "project_nodes": len(proj_nodes),
    "wfx_modules": len(wfx_left) + len(wfx_right) - len(wfx_descriptor_left + wfx_descriptor_right),
    "third_party": len(tp_nodes),
    "gtas": sum(len(c) for c in gtas_layout),
    "links_missing": [c for c in P if resolve_link(projects[c]) is None],
    "notices": notices, "problems": problems, "classes": cur,
    "bbox": (min(r[0] for r in rect.values()), min(r[1] for r in rect.values()),
             max(r[0] + r[2] for r in rect.values()), max(r[1] + r[3] for r in rect.values())),
}
exit_code = 0
if problems:
    report["result"] = "BLOCKED - canvas not written"
    exit_code = 2
elif "--write" in sys.argv:
    report["result"] = write_if_changed(OUT, payload)
    report["path"] = str(OUT)
else:
    try:
        same = OUT.exists() and json.loads(OUT.read_text("utf-8-sig")) == json.loads(payload)
    except ValueError:
        same = False
    report["result"] = "dry run - up to date" if same else "dry run - would write"
if "--layout-json" in sys.argv:   # optional: geometry dump for a layout preview
    Path(_arg("--layout-json")).write_text(
        json.dumps({"rect": rect, "kind": kind, "edges": edges}), "utf-8")

if "--quiet" in sys.argv:
    tail = f"; {len(problems)} problem(s): {'; '.join(problems[:3])}" if problems else ""
    print(f"ecosystem canvas: {report['result']} ({len(proj_nodes)} projects, {len(edges)} edges, "
          f"{len(notices)} notice(s)){tail}")
else:
    print(json.dumps(report, indent=2, ensure_ascii=False))
sys.exit(exit_code)
