"""Generate PPJ_Digital_Application_AI_Automation_Ecosystem.canvas from the vault.

Dry run (validates, writes nothing):   python scripts/build_ppj_ecosystem_canvas.py
Write the Canvas:                      python scripts/build_ppj_ecosystem_canvas.py --write
One-line summary (used by the watcher): add --quiet
Independent check of the result:       python scripts/validate_ppj_ecosystem_canvas.py

The Canvas is kept in sync automatically: watch_ppj_executive_canvas.py (in --apply mode) runs this with --write
whenever the portfolio snapshot changes, so a project registered, renamed or moved on any device is reflected here.
Hand edits to the .canvas are overwritten by the next run.

Project data comes from the portfolio snapshot (the vault's own registry); the WFX / GTAS / third-party inventory
comes from the owner's operating-systems diagram recorded in PPJ_Operational_Systems_Landscape.md. Project-to-module
relationships come from the BOD-review connection matrix (see EDGE_SPEC and CONNECTION_CHANGELOG.md).

Built to be run unattended on any device, so the output depends only on the vault contents:
  - dates come from the snapshot, never from the clock;
  - the file is written in Obsidian's own canvas format (tabs, one object per line), LF, atomically, and only
    when its content changes - so opening the canvas in Obsidian does not create a diff for git to carry;
  - a project the curated table does not know is placed by its domain instead of aborting the run;
  - the file is NOT written if a structural check fails (duplicate ids, orphan edges, overlaps, missing projects).

Two reading levels (BOD review 24/09/2026):
  - zoomed out: coverage. Every WFX / GTAS module carries a status-aware badge when a project touches it
    (see COVERAGE); project-to-module lines are hidden by the PPJ Canvas Focus plugin
    (.obsidian/plugins/ppj-canvas-focus), which reveals a node's own lines on hover / click;
  - zoomed in / hover: exact relationships. Every line's label starts with its type
    (INTEGRATION | PLANNED | DATA | KNOWLEDGE | AFFINITY) and says PRIMARY where it is the project's main module.

Typography: the plugin enlarges text per node role (ROLE_TYPE below mirrors its styles.css), sized so names read at
about 40% zoom. Card heights are estimated from those sizes; without the plugin the same Markdown headings render at
Obsidian's smaller defaults, so nothing overflows either way.
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
CARD_W, CARD_MIN_H, CARD_GAP, HDR = 1450, 380, 60, 170
CORRIDOR = 900               # free space between a domain column and the centre stack, for the lines
LX, LW = 0, 1650             # left domain column
CX, CW = LX + LW + CORRIDOR, 5400          # centre stack
RX, RW = CX + CW + CORRIDOR, 1650          # right domain column
QX, QW = RX + RW + 300, 3200               # far-right periphery
PX, PW = -4600, 3200                       # far-left periphery
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


# ------------------------------------------------------------- typography
# Font px per Markdown prefix for each node role; MUST match .obsidian/plugins/ppj-canvas-focus/styles.css.
# Sized for ~40% zoom on a 1080p screen: 75px project title -> 30px on screen, 52px status -> 21px.
ROLE_TYPE = {
    "project": {"# ": 75, "## ": 42, "### ": 52, "p": 46},
    "wfx": {"# ": 70, "p": 34},
    "gtas": {"# ": 64, "p": 34},
    "system": {"## ": 56, "p": 34},
    "core": {"# ": 88, "## ": 60, "### ": 50, "p": 34},
    "title": {"# ": 80},
}
ROLE_PAD_X, ROLE_PAD_Y = 28, 20      # node inner padding set by the same stylesheet


def role_of(nid: str) -> str | None:
    if nid.startswith(("proj-", "poc-")):
        return "project"
    if nid == "wfx-core":
        return "core"
    if nid.startswith("wfx-"):
        return "wfx"
    if nid.startswith("gtas-"):
        return "gtas"
    if nid.startswith(("tp-", "data-")) and nid != "tp-note":
        return "system"
    if nid.startswith("hdr-"):
        return "title"
    return None


# Obsidian's own sizes (no plugin): h1/h2/h3 at roughly 2.0 / 1.6 / 1.35 times body size.
_HEAD = {"# ": (2.0, 52), "## ": (1.6, 42), "### ": (1.35, 35)}


def _visible(line: str) -> str:
    line = re.sub(r"\[\[[^\]|]*\|([^\]]*)\]\]", r"\1", line)      # a wikilink shows its alias only
    return line.replace("**", "")


def est_height(body: str, w: float, role: str | None = None) -> float:
    if role is None:
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
            cpl = max(10, (w - 40) / (8.6 * factor))
            h += math.ceil(len(_visible(line)) / cpl) * lh
        return h
    sizes = ROLE_TYPE[role]
    h = 2 * ROLE_PAD_Y + (40.0 if role == "project" else 24.0)        # padding + border / rounding margin
    for line in body.split("\n"):
        if not line.strip():
            h += 0.3 * sizes.get("p", 34)
            continue
        prefix = next((p for p in ("### ", "## ", "# ") if line.startswith(p)), None)
        size = sizes.get(prefix, sizes.get("p", 34)) if prefix else sizes.get("p", 34)
        heading = prefix is not None
        text_ = _visible(line[len(prefix):] if prefix else line)
        cpl = max(6, (w - 2 * ROLE_PAD_X) / (size * (0.64 if heading else 0.58)))
        lines = 1 if len(text_) <= cpl else math.ceil(len(text_) * 1.06 / cpl)   # 6% word-wrap waste once it wraps
        h += lines * size * (1.15 if heading else 1.3) + 0.15 * size
    return h


def text(nid, x, y, w, h, body, color=None):
    need = est_height(body, w, role_of(nid))
    if need > h:
        notices.append(f"{nid}: text needs ~{need:.0f} > {h}")
    n = {"id": nid, "type": "text", "x": int(x), "y": int(y), "width": int(w), "height": int(h), "text": body}
    if color:
        n["color"] = color
    _add(n, "text")


def _hdr_box(heading: str, w: float) -> tuple[int, int]:
    size = ROLE_TYPE["title"]["# "]
    hw = int(min(w - 60, len(heading) * size * 0.72 + 2 * ROLE_PAD_X + 40))
    return hw, int(math.ceil(est_height("# " + heading, hw, "title") / 10) * 10)


def band(label: str, w: float, title: str | None = None) -> int:
    """Height of a group's top band: its large heading plus margin."""
    return max(HDR, _hdr_box(title or label, w)[1] + 40)


def group(gid, x, y, w, h, label, color=None, title=None):
    """A group plus a large heading inside its top band: Obsidian draws group labels too small to read zoomed out."""
    n = {"id": gid, "type": "group", "x": int(x), "y": int(y), "width": int(w), "height": int(h), "label": label}
    if color:
        n["color"] = color
    _add(n, "group")
    heading = title or label
    hw, hh = _hdr_box(heading, w)
    text("hdr-" + gid, x + 30, y + 20, hw, hh, "# " + heading)   # x is chosen later (whichever spot no line crosses)
    return band(label, w, title)


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
# zone, friendly name, type, capability (one sentence; a second line only where the BOD asked for it).
# Detail lives in the linked project note - the card is an executive summary, not the BRD.
P = {
    "MER_MarketIntelligence_v1.1.0": ("MER", "Market Intelligence", "AI APPLICATION - data intelligence",
        "Product, customer and material opportunities from DWH, order history, Style Library and external market "
        "signals. An intelligence layer, not a WFX transaction app."),
    "MER_POCommit_v1.1.0": ("MER", "PO Commit Automation", "AUTOMATION",
        "Customer order to order processing to PO, ready for production; covered about 70-80% of customer "
        "scenarios. Historical record."),
    "MER_InvoiceDataRecheck_v1.1.0": ("MER", "Invoice Data Recheck", "AUTOMATION - audit / rule engine",
        "Cross-checks costing, commercial and invoice data against configurable per-customer rules, across "
        "multiple customers; exceptions go to human review."),
    "MER_CostingAgenticPlatform_v1.1.0": ("MER", "Agentic Costing Platform", "AI APPLICATION - agents / decision support",
        "Similar-style retrieval, technical data and consumption to a costing recommendation. Sew Agent and Wash "
        "Agent are parts of this platform; a domain expert confirms."),
    "AI_PERRIPlatform_v3.2.0": ("SHARED", "PERRI Enterprise Chatbot", "INTERNAL PLATFORM - shared AI channel",
        "Enterprise Q&A and orchestration channel shared by every domain; not attached to any single WFX module."),
    "AI_ApplicationHub_v2.1.0": ("SHARED", "PPJ AI Hub", "INTERNAL PLATFORM - AI access / governance",
        "AI application access, orchestration and governance foundation; not attached to any single WFX module."),
    "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0": ("SHARED", "GLPI AI Helpdesk (Merchandising)",
        "AI APPLICATION - helpdesk / knowledge assistant",
        "AI helpdesk for merchandisers: enterprise systems, WFX usage, merchandising process, SOP, troubleshooting "
        "and previously resolved issues."),
    "HR_EmployeeDataPlatform_v1.1.0": ("HR", "HR Employee Data Platform", "WORKFLOW - data standardization",
        "Employee data collection, validation and standardization into an Employee Master on HRIS; applicant "
        "extraction / prefill."),
    "ADMIN_ExpenseManagement_v1.1.0": ("ADMIN", "Business Travel & Expense Management", "WORKFLOW",
        "PPJ internal Admin application outside WFX: request, approval, advance, expense, settlement. E-office "
        "link blocked: service stopped, reopening fee under re-quote."),
    "SCP_SourcingChatbot_v2.3.0": ("SRC", "Sourcing AI Chatbot", "AI APPLICATION - RAG / chatbot",
        "Supplier, material and sample search, comparison and sourcing knowledge from WFX Inventory Control and "
        "Raw Material Planning."),
    "PUR_InventoryReport_v2.1.0": ("SRC", "Purchasing Inventory Report", "DATA PLATFORM - reporting / visibility",
        "Material, stock and availability visibility from WFX Inventory Control and MMSx. Reporting, not an "
        "automation bot."),
    "PUR_MaterialAllocation_v1.1.0": ("SRC", "Material Allocation Automation", "AUTOMATION - workflow / transaction",
        "Surplus material: unreserve, find an eligible OC, reallocate, validate. First Sewing / Embroidery flow "
        "validated."),
    "PUR_AdhocIndentSouth_v1.0.0": ("SRC", "Adhoc Indent Automation (South)", "AUTOMATION - rule-based",
        "Rule-based processing of repeated Adhoc Indents for the South region into WFX purchasing."),
    "PUR_GDIAutomation_v1.0.0": ("SRC", "GDI Automation", "AUTOMATION - API-first transaction",
        "Goods dispatch / goods issue posted to WFX Logistics Out-bound through the WFX API; API development and "
        "integration preparation."),
    "PUR_HMLabelProcessing_v1.0.0": ("SRC", "H&M Label-O Processing", "AUTOMATION - rule-based",
        "H&M Label-O processing; paused pending a scalable business case."),
    "FIN_FinanceManagement_v1.2.0": ("FIN", "Finance AI Management", "AI APPLICATION - finance analytics / control",
        "WS1 financial reporting foundation | WS2 OC cost, profitability and variance control | WS3 factory cost "
        "integrity: salary, overhead, performance.\n"
        "BOD drill-down: Group > Company > Division > Sales Group > OC. Analytics and control, not a financial "
        "system of record."),
    "ACC_GRNSupplierInvoiceBot_v2.3.0": ("FIN", "GRN Supplier Invoice Bot", "AUTOMATION - transaction bot",
        "PO, GRN, supplier invoice, validation and matching, then accounting entry."),
    "FIN_InvoiceDownloader_v1.2.0": ("FIN", "Invoice Downloader", "AUTOMATION",
        "Downloads source invoice files from VNPT E-Invoice; session handling updated for VNPT's new protection "
        "layer. No accounting posting."),
    "ACC_InventoryReport_v1.0.0": ("FIN", "Accounting Inventory Report", "DATA PLATFORM - reporting",
        "Accounting inventory reporting. Distinct from the Purchasing Inventory Report."),
    "EXIM.ExpenseInvoices.Automation.v1.1": ("FIN", "EXIM Expense Invoice Bot (legacy)", "AUTOMATION",
        "Legacy EXIM expense-invoice automation, replaced by Expense Invoice Processing (LOG_ExpenseInvoiceProcessing)."),
    "WH_AWBExtraction_v1.1.0": ("WHL", "AWB Document Intelligence", "AI APPLICATION - document intelligence",
        "AWB image OCR and DHL shipment email in one project: parse, normalize, match by AWB number, validate, "
        "human review."),
    "LOG_ExpenseInvoiceProcessing_v1.2.2": ("WHL", "Expense Invoice Processing", "AUTOMATION - expense invoices",
        "One application used by several units: shared expense invoices and Logistics / EXIM. Regional tax "
        "templates and charge rules; UAT / rollout in HCM, Da Nang, Nha Trang, Ha Noi."),
    "PROD_HangingLineIoT_v1.0.0": ("PROD", "Hanging Line IoT", "IOT",
        "Hanging-line digitization and production visibility, read through WFX Reporting & Analysis; a future data "
        "source for Smart Factory analytics."),
    "WASH_SamplingManagement_v1.1.0": ("PROD", "Wash Sampling Management Portal", "WORKFLOW",
        "Wash sample request, planning, result and approval in the PPJ Group Portal."),
    "WASH_COWASH_v2.0.0": ("PROD", "COWASH Wash Operations", "SYSTEM - wash production (vendor)",
        "Wash production workflow and operational data. Distinct from the sampling portal."),
    "QC_DefectDetection_v1.0.0": ("QC", "AI Defect Detection", "AI APPLICATION - computer vision (vendor)",
        "Defect detection and classification with QC review. Vendor proposal and NDA only; not an approved PoC."),
    "QC_ThreadTraceability_v1.0.0": ("QC", "RFID Thread Traceability", "POC / EVALUATION",
        "RFID thread identification and traceability. Business case only; no PoC approved."),
    "TD_TechnicalKnowledgePlatform_v2.1.0": ("FAB", "Technical Knowledge Platform", "DATA PLATFORM - knowledge foundation",
        "Technical knowledge from Style Library, BOM, GTAS IED and Consumption; the foundation of the Agentic "
        "Costing Platform. Not an ERP system of record."),
    "FAB_FabricDatamart_v2.2.0": ("FAB", "Fabric Datamart", "DATA PLATFORM - datamart",
        "Fabric, hanger, QR and material reference data (Directus). Separate from CPD."),
    "CPD_VisualSampleDatamart_v1.1.0": ("FAB", "Visual Sample Datamart", "DATA PLATFORM - datamart",
        "3D / visual sample library and image search. Separate from FD."),
    "PPJxNUNOX.ScanTrial": ("POC", "NUNOX Scan Trial", "POC / EVALUATION",
        "Fabric scanning and fabric / garment digital library evaluation; outcome unconfirmed."),
    "EXT_AcademicCollaboration_v1.1.0": ("COLLAB", "Academic Collaboration (UIT)", "COLLABORATION",
        "Prototypes, research, competitions and talent pipeline with UIT. Not a production application."),
    "PPJxStratova.AI": ("ARCH", "Stratova AI (historical record)", "ARCHIVED - former AI PoC",
        "Closed record. The active pattern-generation PoC continues as Pattern Generation PoC (zone 06): one active "
        "PoC, not two."),
    "AI.Automation.Workshop.202606": ("ARCH", "AI Automation Workshop (June 2026)", "ARCHIVED - enablement",
        "Workshop record. No active tasks."),
    "AI.Automation.Workshop.Analysis.202606": ("ARCH", "Workshop Analysis (June 2026)", "ARCHIVED - enablement",
        "Workshop analysis record. No active tasks."),
    "VITAS.Sharing.202606": ("ARCH", "VITAS Sharing (June 2026)", "ARCHIVED - external engagement",
        "External sharing record. No active tasks."),
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
    "ACC_GRNSupplierInvoiceBot_v2.3.0": "ACC.GRNInvoiceMatching.v2.3",
    "ACC_InventoryReport_v1.0.0": "ACC.Inventory.Report.v1.0",
    "LOG_ExpenseInvoiceProcessing_v1.2.2": "PPJ.ExpenseInvoices.v1.1 + LOG.EXPENSE.INVOICES.V1.2 (one application)",
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
# Preferred order inside a zone; anything else in the zone follows in registry order. The order tells the BOD's
# capability stories top to bottom: market -> order -> commercial control -> costing, which sits directly above
# the Technical Knowledge Platform (FAB group), so Technical + Costing read as one cluster; in purchasing the
# Inventory -> Allocation -> Indent -> GDI chain runs in sequence.
ZONE_ORDER = {
    "MER": ["MER_MarketIntelligence_v1.1.0", "MER_POCommit_v1.1.0", "MER_InvoiceDataRecheck_v1.1.0",
            "MER_CostingAgenticPlatform_v1.1.0"],
    "FAB": ["TD_TechnicalKnowledgePlatform_v2.1.0", "FAB_FabricDatamart_v2.2.0", "CPD_VisualSampleDatamart_v1.1.0"],
    "SRC": ["SCP_SourcingChatbot_v2.3.0", "PUR_InventoryReport_v2.1.0", "PUR_MaterialAllocation_v1.1.0",
            "PUR_AdhocIndentSouth_v1.0.0", "PUR_GDIAutomation_v1.0.0", "PUR_HMLabelProcessing_v1.0.0"],
    "WHL": ["WH_AWBExtraction_v1.1.0", "LOG_ExpenseInvoiceProcessing_v1.2.2"],
    "HR": ["HR_EmployeeDataPlatform_v1.1.0"],
    "ADMIN": ["ADMIN_ExpenseManagement_v1.1.0"],
    "FIN": ["FIN_FinanceManagement_v1.2.0", "ACC_GRNSupplierInvoiceBot_v2.3.0", "FIN_InvoiceDownloader_v1.2.0",
            "ACC_InventoryReport_v1.0.0", "EXIM.ExpenseInvoices.Automation.v1.1"],
    "QC": ["QC_DefectDetection_v1.0.0", "QC_ThreadTraceability_v1.0.0"],
    "PROD": ["PROD_HangingLineIoT_v1.0.0", "WASH_SamplingManagement_v1.1.0", "WASH_COWASH_v2.0.0"],
    "SHARED": ["AI_PERRIPlatform_v3.2.0", "AI_ApplicationHub_v2.1.0", "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"],
    "POC": ["PPJxNUNOX.ScanTrial"],
    "COLLAB": ["EXT_AcademicCollaboration_v1.1.0"],
    "ARCH": ["PPJxStratova.AI", "AI.Automation.Workshop.202606", "AI.Automation.Workshop.Analysis.202606",
             "VITAS.Sharing.202606"],
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
               " ".join((p.get("outcome") or "").split())[:200] + " Placed automatically by domain; no curated card yet.")
    notices.append(f"{code}: not in the curated table - placed in zone {zone} by domain '{p.get('domain')}'")


def zone_codes(zone: str) -> list[str]:
    listed = [c for c in ZONE_ORDER.get(zone, []) if c in P and P[c][0] == zone]
    return listed + [c for c, v in P.items() if v[0] == zone and c not in listed]


def card_text(code: str) -> str:
    """# name / ## canonical code (link) / ### status / TYPE / capability / baseline alias - 4-6 lines."""
    _zone, friendly, klass, cap = P[code]
    p = projects[code]
    link = resolve_link(p)
    lines = [f"# {friendly}", f"## {link}" if link else f"## {code}", f"### {p['lifecycle']}", "",
             f"**{klass}**", *cap.split("\n")]
    if code in BASELINE:
        lines.append(f"Baseline: {BASELINE[code]}")
    if not link:
        lines.append("Vault Link: Not found")
    return "\n".join(lines)


def fit_height(body: str, w: int = CARD_W, minimum: int = CARD_MIN_H) -> int:
    return max(minimum, int(math.ceil(est_height(body, w, "project") / 10) * 10))


def card(code: str, x: int, y: int, h: int) -> None:
    text(pid(code), x, y, CARD_W, h, card_text(code), CLASS_COLOR[status_class(projects[code])])


def column_group(gid, label, x, y, w, codes, color=None, title=None):
    top = band(label, w, title)
    heights = [fit_height(card_text(c)) for c in codes]
    h = top + (sum(heights) + CARD_GAP * len(heights) if codes else CARD_MIN_H + CARD_GAP)
    group(gid, x, y, w, h, label, color, title)
    cy = y + top
    for c, ch in zip(codes, heights):
        card(c, x + (w - CARD_W) // 2, cy, ch)
        cy += ch + CARD_GAP
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
     "### 4. AI & Automation selectively augment specific modules and business flows.\n"
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
# Fabric / Technical sits directly under Merchandising: the Technical Knowledge Platform feeds the Costing
# platform (the last Merchandising card), so Technical + Costing read as one cluster, as the BOD asked.
y_end = column_group("grp-mer", "04.2 MERCHANDISING", LX, 0, LW, zone_codes("MER"))
y_end = column_group("grp-fab", "04.7 FABRIC / TEXTILES TECHNIQUE", LX, y_end + GAP, LW, zone_codes("FAB"),
                     title="04.7 FABRIC / TECHNICAL")
y_end = column_group("grp-src", "04.1 SOURCING / PURCHASING", LX, y_end + GAP, LW, zone_codes("SRC"))

# ============================================================ RIGHT COLUMN
ry = column_group("grp-hr", "04.8 HR", RX, 0, RW, zone_codes("HR"))
ry = column_group("grp-admin", "04.9 ADMINISTRATION", RX, ry + GAP, RW, zone_codes("ADMIN"))
ry = column_group("grp-fin", "04.3 FINANCE / ACCOUNTING", RX, ry + GAP, RW, zone_codes("FIN"),
                  title="04.3 FINANCE / ACCOUNTING")
ry = column_group("grp-qc", "04.5 QC / TQM", RX, ry + GAP, RW, zone_codes("QC"))
ry = column_group("grp-prod", "04.4 PRODUCTION + WASH", RX, ry + GAP, RW, zone_codes("PROD"))
ry = column_group("grp-whl", "04.6 WAREHOUSE / LOGISTICS", RX, ry + GAP, RW, zone_codes("WHL"),
                  title="04.6 WAREHOUSE / LOGISTICS")

# ============================================================ EDGE SPEC
# The connection matrix from the BOD review of 24/09/2026, as corrected against the meeting recording
# (08_Meeting_Notes/PPJ-PROJECTS-REPORT/BOD_REVIEW_20260924_Madame_Phuong.md). Every change from the previous
# edition is listed in 03_Projects/Canvas/CONNECTION_CHANGELOG.md. Do not add a line without a documented source.
#
# Type: A INTEGRATION (confirmed), B PLANNED (in scope / in development), D DATA (data dependency / source),
#       K KNOWLEDGE (knowledge / RAG / reference), C AFFINITY (business relationship, no technical integration).
# PRIMARY marks the project's main module. Lines are hover-only (PPJ Canvas Focus plugin), so there is no longer a
# one-affinity-line-per-project limit.
S = pid
PATTERN_POC = "poc-discovery-patterngenerationpoc"
PRIMARY = True
EDGE_SPEC = [
    # --- MERCHANDISING
    (S("MER_POCommit_v1.1.0"), "wfx-buyer-order-management", "C", "", PRIMARY),
    (S("MER_POCommit_v1.1.0"), "wfx-purchase-order-management", "C", "", PRIMARY),
    (S("MER_POCommit_v1.1.0"), "wfx-style-library", "D", "", False),
    (S("MER_POCommit_v1.1.0"), "wfx-production-planning", "D", "downstream", False),
    (S("MER_CostingAgenticPlatform_v1.1.0"), "wfx-budgeting-costing", "C", "", PRIMARY),
    (S("MER_CostingAgenticPlatform_v1.1.0"), "wfx-style-library", "D", "", False),
    (S("MER_CostingAgenticPlatform_v1.1.0"), "wfx-bill-of-material", "D", "", False),
    (S("MER_CostingAgenticPlatform_v1.1.0"), "gtas-costing", "D", "", False),
    (S("MER_CostingAgenticPlatform_v1.1.0"), "gtas-ied", "B", "GTAS/IED contract", False),
    (S("MER_CostingAgenticPlatform_v1.1.0"), "gtas-consumption", "D", "", False),
    (S("MER_InvoiceDataRecheck_v1.1.0"), "wfx-budgeting-costing", "C", "", PRIMARY),
    (S("MER_InvoiceDataRecheck_v1.1.0"), "wfx-buyer-order-management", "C", "", PRIMARY),
    (S("MER_InvoiceDataRecheck_v1.1.0"), "wfx-finance", "D", "reference", False),
    (S("MER_MarketIntelligence_v1.1.0"), "data-dwh", "D", "", PRIMARY),
    (S("MER_MarketIntelligence_v1.1.0"), "wfx-buyer-order-management", "D", "order history", False),
    (S("MER_MarketIntelligence_v1.1.0"), "wfx-style-library", "D", "", False),
    (S("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"), "tp-glpi", "C", "", PRIMARY),
    (S("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"), "wfx-buyer-order-management", "K", "", False),
    (S("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"), "wfx-budgeting-costing", "K", "", False),
    (S("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"), "wfx-style-library", "K", "", False),
    (S("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"), "wfx-purchase-order-management", "K", "", False),
    # --- SOURCING / PURCHASING
    (S("SCP_SourcingChatbot_v2.3.0"), "wfx-inventory-control", "K", "", PRIMARY),
    (S("SCP_SourcingChatbot_v2.3.0"), "wfx-raw-material-planning", "K", "", False),
    (S("PUR_InventoryReport_v2.1.0"), "wfx-inventory-control", "D", "", PRIMARY),
    (S("PUR_InventoryReport_v2.1.0"), "tp-mmsx", "D", "", False),
    (S("PUR_InventoryReport_v2.1.0"), S("PUR_MaterialAllocation_v1.1.0"), "D", "", False),
    (S("PUR_InventoryReport_v2.1.0"), S("PUR_GDIAutomation_v1.0.0"), "D", "", False),
    (S("PUR_MaterialAllocation_v1.1.0"), "wfx-inventory-control", "A", "validated flow", PRIMARY),
    (S("PUR_MaterialAllocation_v1.1.0"), "wfx-raw-material-planning", "D", "", False),
    (S("PUR_MaterialAllocation_v1.1.0"), "wfx-purchase-order-management", "D", "", False),
    (S("PUR_MaterialAllocation_v1.1.0"), "wfx-buyer-order-management", "D", "OC context", False),
    (S("PUR_GDIAutomation_v1.0.0"), "wfx-logistics-out-bound", "B", "WFX API", PRIMARY),
    (S("PUR_GDIAutomation_v1.0.0"), "wfx-inventory-control", "D", "", False),
    (S("PUR_GDIAutomation_v1.0.0"), "wfx-purchase-order-management", "D", "", False),
    (S("PUR_GDIAutomation_v1.0.0"), "wfx-buyer-order-management", "D", "OC / FPO context", False),
    (S("PUR_AdhocIndentSouth_v1.0.0"), "wfx-purchase-order-management", "C", "", PRIMARY),
    (S("PUR_AdhocIndentSouth_v1.0.0"), "wfx-raw-material-planning", "C", "", False),
    (S("PUR_AdhocIndentSouth_v1.0.0"), "wfx-inventory-control", "C", "", False),
    (S("PUR_HMLabelProcessing_v1.0.0"), "wfx-purchase-order-management", "C", "", PRIMARY),
    # --- FINANCE / ACCOUNTING
    (S("FIN_FinanceManagement_v1.2.0"), "wfx-finance", "D", "", PRIMARY),
    (S("FIN_FinanceManagement_v1.2.0"), "wfx-buyer-order-management", "D", "OC", False),
    (S("FIN_FinanceManagement_v1.2.0"), "wfx-budgeting-costing", "D", "", False),
    (S("FIN_FinanceManagement_v1.2.0"), "wfx-inventory-control", "D", "", False),
    (S("FIN_FinanceManagement_v1.2.0"), "wfx-production-management", "D", "", False),
    (S("FIN_FinanceManagement_v1.2.0"), "data-dwh", "D", "", False),
    (S("FIN_FinanceManagement_v1.2.0"), "tp-power-bi", "D", "", False),
    (S("FIN_FinanceManagement_v1.2.0"), "gtas-bi-report", "D", "", False),
    (S("FIN_FinanceManagement_v1.2.0"), "gtas-financial-statements", "D", "", False),
    (S("FIN_FinanceManagement_v1.2.0"), "gtas-salary", "D", "WS3", False),
    (S("FIN_FinanceManagement_v1.2.0"), "gtas-production", "D", "WS3", False),
    (S("ACC_GRNSupplierInvoiceBot_v2.3.0"), "wfx-logistics-in-bound", "C", "GRN", PRIMARY),
    (S("ACC_GRNSupplierInvoiceBot_v2.3.0"), "wfx-finance", "C", "", PRIMARY),
    (S("ACC_GRNSupplierInvoiceBot_v2.3.0"), "wfx-purchase-order-management", "D", "", False),
    (S("ACC_GRNSupplierInvoiceBot_v2.3.0"), "wfx-inventory-control", "D", "", False),
    (S("FIN_InvoiceDownloader_v1.2.0"), "tp-vnpt-e-invoice", "A", "VNPT download", PRIMARY),
    (S("LOG_ExpenseInvoiceProcessing_v1.2.2"), "wfx-finance", "C", "expense invoice", PRIMARY),
    (S("LOG_ExpenseInvoiceProcessing_v1.2.2"), "wfx-logistics-in-bound", "C", "", False),
    # --- WAREHOUSE / LOGISTICS (GTAS Transportation deliberately has no line: no confirmed application)
    (S("WH_AWBExtraction_v1.1.0"), "wfx-logistics-in-bound", "C", "", PRIMARY),
    # --- ADMINISTRATION (the project is itself the Admin application; it sits outside WFX)
    (S("ADMIN_ExpenseManagement_v1.1.0"), "tp-e-office", "B", "E-office (fee blocked)", False),
    (S("ADMIN_ExpenseManagement_v1.1.0"), "tp-hris", "D", "master data", False),
    (S("ADMIN_ExpenseManagement_v1.1.0"), "wfx-finance", "C", "downstream", False),
    # --- TECHNICAL / FABRIC: one Technical -> Costing capability story
    (S("TD_TechnicalKnowledgePlatform_v2.1.0"), S("MER_CostingAgenticPlatform_v1.1.0"), "D", "foundation", False),
    (S("TD_TechnicalKnowledgePlatform_v2.1.0"), "wfx-style-library", "D", "", False),
    (S("TD_TechnicalKnowledgePlatform_v2.1.0"), "wfx-bill-of-material", "D", "", False),
    (S("TD_TechnicalKnowledgePlatform_v2.1.0"), "gtas-ied", "D", "", False),
    (S("TD_TechnicalKnowledgePlatform_v2.1.0"), "gtas-consumption", "D", "", False),
    (S("TD_TechnicalKnowledgePlatform_v2.1.0"), "data-technical-knowledge", "D", "", False),
    (S("FAB_FabricDatamart_v2.2.0"), S("TD_TechnicalKnowledgePlatform_v2.1.0"), "D", "", False),
    (S("CPD_VisualSampleDatamart_v1.1.0"), S("TD_TechnicalKnowledgePlatform_v2.1.0"), "D", "", False),
    (PATTERN_POC, S("TD_TechnicalKnowledgePlatform_v2.1.0"), "C", "pattern", PRIMARY),
    (PATTERN_POC, "wfx-style-library", "C", "", False),
    (PATTERN_POC, S("MER_CostingAgenticPlatform_v1.1.0"), "C", "", False),
    # --- PRODUCTION / WASH (BOD: IoT hanger reads through Reporting & Analysis, the centre of WFX)
    (S("PROD_HangingLineIoT_v1.0.0"), "wfx-core", "C", "Reporting/Analysis", PRIMARY),
    (S("PROD_HangingLineIoT_v1.0.0"), "wfx-production-planning", "D", "", False),
    (S("PROD_HangingLineIoT_v1.0.0"), "wfx-production-management", "D", "", False),
    (S("PROD_HangingLineIoT_v1.0.0"), "tp-iot-wiser-ina", "D", "", False),
    (S("WASH_SamplingManagement_v1.1.0"), "wfx-sampling", "C", "", PRIMARY),
    (S("WASH_COWASH_v2.0.0"), "wfx-production-management", "C", "", PRIMARY),
    # --- HR (Finance WS3 carries the salary / production data; HR itself is not a WFX integration)
    (S("HR_EmployeeDataPlatform_v1.1.0"), "tp-hris", "C", "", PRIMARY),
    # --- foundation (always lightly visible)
    ("wfx-core", "data-dwh", "D", "", False),
]
# PERRI and AI Hub draw no lines on purpose: shared enterprise channels, not attached to single modules.
# Project -> project lines that would run straight through the cards between them loop out to the side instead.
SIDES = {
    (S("PUR_InventoryReport_v2.1.0"), S("PUR_GDIAutomation_v1.0.0")): ("left", "left"),
    (S("CPD_VisualSampleDatamart_v1.1.0"), S("TD_TechnicalKnowledgePlatform_v2.1.0")): ("left", "left"),
    (S("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"), "tp-glpi"): ("right", "right"),
}
CURVED = set(SIDES)

# ------------------------------------------------------------- coverage
# A WFX / GTAS module is badged when a project touches it; the badge shows the most advanced status among them.
#   ● live coverage (production / support / maintenance)   ◐ in development / UAT / planned
#   ○ evaluation, on hold or historical only
# BOD 24/09 [T 21:29-22:18, 28:32-29:20]: no star on QC, Production Planning or Production Management - no
# automation there yet. Their lines still show on hover; only the badge is withheld.
NO_BADGE = {"wfx-qc", "wfx-production-planning", "wfx-production-management"}
BADGE = {3: "●", 2: "◐", 1: "○"}
BADGE_LABEL = {3: "live", 2: "in development / planned", 1: "evaluation / on hold / historical"}


def coverage_level(nid: str) -> int:
    if nid.startswith("poc-"):
        return 1
    code = next((c for c in P if pid(c) == nid), None)
    if code is None:
        return 0
    cls = status_class(projects[code])
    lc = (projects[code].get("lifecycle") or "").lower()
    if cls in ("production", "maint"):
        return 3
    if cls in ("hold", "closed") or any(k in lc for k in ("evaluation", "pre-poc")):
        return 1
    return 2


coverage: dict[str, int] = {}
for f, t, *_ in EDGE_SPEC:
    for module, other in ((t, f), (f, t)):
        if module.startswith(("wfx-", "gtas-")) and other.startswith(("proj-", "poc-")) and module not in NO_BADGE:
            coverage[module] = max(coverage.get(module, 0), coverage_level(other))


def badged(nid: str, name: str) -> str:
    lvl = coverage.get(nid, 0)
    return f"{BADGE[lvl]} {name}" if lvl else name


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
sh_rows = [sh_codes[i:i + 3] for i in range(0, max(1, len(sh_codes)), 3)] or [[]]
row_h = [max([fit_height(card_text(c)) for c in row] or [CARD_MIN_H]) for row in sh_rows]
sh_band = band("04.10 SHARED AI PLATFORMS (enterprise capabilities, not domain apps)", CW, "04.10 SHARED AI PLATFORMS")
sh = sh_band + sum(row_h) + CARD_GAP * len(row_h) + 220 + 40
group("grp-shared", CX, sy, CW, sh, "04.10 SHARED AI PLATFORMS (enterprise capabilities, not domain apps)", C_SHARED,
      "04.10 SHARED AI PLATFORMS")
sx0 = CX + (CW - (3 * CARD_W + 2 * 150)) // 2
ry_ = sy + sh_band
for row, rh in zip(sh_rows, row_h):
    for i, c in enumerate(row):
        card(c, sx0 + i * (CARD_W + 150), ry_, rh)
    ry_ += rh + CARD_GAP
text("shared-note", sx0, ry_, 3 * CARD_W + 300, 220,
     "### Enterprise capabilities, not business-domain applications.\n"
     "PERRI and AI Hub are shared channels: they are deliberately not attached to individual WFX modules. "
     "Lines are drawn only where documentation confirms use.")
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
gtas_title = "03 GTAS INTERNAL APPLICATIONS"
gband = band("03 GTAS INTERNAL APPLICATIONS - Legacy Internal Development", CW, gtas_title)
gh = gband + 3 * NP + NH + 40
group("grp-gtas", CX, y_gtas, CW, gh, "03 GTAS INTERNAL APPLICATIONS - Legacy Internal Development", C_GTAS, gtas_title)
for c, col in enumerate(gtas_layout):
    for r, name in enumerate(col):
        nid = "gtas-" + slug(name.replace("GTAS ", ""))
        text(nid, xs4[c], y_gtas + gband + r * NP, NW, NH, "# " + badged(nid, name), C_GTAS)
y_3p = y_gtas + gh + GAP

# --- third party
TW, TH, TP = 1200, 200, 230
tp_nodes = {
    "MMSx": (0, 0, "Material management", "diagram"),
    "Gerber": (0, 1, "Pattern / technical design (CAD)", "diagram"),
    "ShapeShifter": (0, 2, "Technical / pattern / product development", "diagram"),
    "FastReactPlan": (1, 0, "Production planning", "diagram"),
    "GLPI": (3, 0, "Helpdesk / ITSM", "vault"),
    "HRIS": (3, 1, "Human Resources Information System", "diagram"),
    "E-office": (3, 2, "Documents, workflow, digital signing", "diagram"),
    "VNPT E-Invoice": (3, 3, "Electronic invoice source", "vault"),
    "Power BI": (3, 4, "Reporting / BI", "vault"),
    "IoT / WISER / INA": (3, 5, "Machine and production-line data", "vault"),
}
tp_title = "02 THIRD-PARTY ENTERPRISE APPLICATIONS"
tband = band(tp_title, CW)
th = tband + 5 * TP + TH + 40
group("grp-3p", CX, y_3p, CW, th, tp_title, C_3P)
for name, (c, r, purpose, src) in tp_nodes.items():
    text("tp-" + slug(name), xs4[c], y_3p + tband + r * TP, TW, TH, f"## {name}\n{purpose}", C_3P)
text("tp-note", xs4[1], y_3p + tband + TP, 2 * TW + 120, 4 * TP - 40,
     "### On the owner's operating-systems diagram:\n### HRIS, E-office, MMSx, FastReactPlan, Gerber, ShapeShifter\n\n"
     "### Confirmed by vault documents, not on the diagram:\n### VNPT E-Invoice, Power BI, GLPI, IoT / WISER / INA\n\n"
     "Only listed applications are drawn. No further vendor application is assumed. "
     "E-office: service stopped; reopening needs a fee (vendor re-quoting, BOD 24/09).")
y_wfx = y_3p + th + GAP

# --- WFX
MW, MH, MP = 1350, 160, 200
# Split by the side of the canvas their business owners sit on: merchandising / sourcing on the left,
# finance, production, quality and logistics on the right.
wfx_left = ["Buyer Order Management", "Budgeting & Costing", "Bill of Material", "Style Library", "BrandPLM",
            "Raw Material Planning", "Purchase Order Management", "Inventory Control"]
wfx_right = ["Finance", "Sampling", "QC", "QA", "Production Planning", "Production Management",
             "Logistics In-bound", "Logistics Out-bound"]
wfx_title = "01 WFX ERP CORE"
wband = band("01 WFX ERP CORE - Core Enterprise Transaction System", CW, wfx_title)
slots = [y_wfx + wband + i * MP + MH / 2 for i in range(8)]
wfx_left = ordered_modules(wfx_left, slots)
wfx_right = ordered_modules(wfx_right, slots)
wh = wband + 8 * MP - (MP - MH) + 40
group("grp-wfx", CX, y_wfx, CW, wh, "01 WFX ERP CORE - Core Enterprise Transaction System", C_WFX, wfx_title)
lx, rx_ = CX + 100, CX + CW - 100 - MW
for i, name in enumerate(wfx_left):
    nid = "wfx-" + slug(name)
    text(nid, lx, y_wfx + wband + i * MP, MW, MH, "# " + badged(nid, name), C_WFX)
for i, name in enumerate(wfx_right):
    nid = "wfx-" + slug(name)
    text(nid, rx_, y_wfx + wband + i * MP, MW, MH, "# " + badged(nid, name), C_WFX)
hx = lx + MW + 100
core_cov = max([coverage_level(f) for f, t, *_ in EDGE_SPEC if t == "wfx-core" and f.startswith(("proj-", "poc-"))]
               or [0])
# Reporting & Analysis is the core's only h2: the plugin styles the badge as the first letter of that heading.
text("wfx-core", hx, y_wfx + wband, rx_ - 100 - hx, 8 * MP - (MP - MH),
     "# WFX ERP\n### Core Enterprise Transaction System\n\n"
     f"## {(BADGE[core_cov] + ' ') if core_cov else ''}Reporting & Analysis\n### Time & Action Tracking\n"
     "### Textiles / Garments\n\n"
     "16 modules, named from the owner's operating-systems diagram. WFX is the system of record for orders, "
     "purchasing, material, inventory and operational transactions. AI and automation augment WFX; they do not "
     "replace it.", C_WFX)
y_data = y_wfx + wh + GAP

# --- data foundation
DW, DH, DP = 1550, 190, 230
right_edge = CX + CW - 100          # level with the right-hand WFX / GTAS nodes, so lines reach it through the corridor
xs3 = [CX + 120, CX + 120 + (right_edge - DW - (CX + 120)) // 2, right_edge - DW]
data_nodes = [
    ("data-technical-knowledge", 0, 1, "Technical Knowledge", "Realised by the Technical Knowledge Platform (04.7)"),
    ("data-doc-retrieval", 1, 0, "Document / Knowledge Retrieval", "Conceptual foundation layer"),
    ("data-dwh", 2, 0, "Enterprise Data / DWH", "DWH / Databricks - confirmed in the 2026-09-18 ecosystem note"),
    ("data-master", 0, 0, "Master Data", "Conceptual foundation layer"),
    ("data-workflow", 1, 1, "Workflow & Process Data", "Conceptual foundation layer"),
    ("data-reporting", 2, 1, "Reporting & Analytics", "Power BI - confirmed in the Finance AI project documents"),
]
data_title = "05 DATA / KNOWLEDGE FOUNDATION"
dband = band(data_title, CW)
dh = dband + DP + DH + 40
group("grp-data", CX, y_data, CW, dh, data_title, C_DATA)
for nid, c, r, name, src in data_nodes:
    text(nid, xs3[c], y_data + dband + r * DP, DW, DH, f"## {name}\n{src}", C_DATA)
y_flow = y_data + dh + GAP

# --- capability stories (bottom centre; explanatory, no lines)
text("flow-labels", CX, y_flow, CW, 1250,
     "# CAPABILITY STORIES\n"
     "## SYSTEM > DATA > AUTOMATION > AI / ANALYTICS > CONTROL > DECISION > BUSINESS OUTCOME\n\n"
     "### COMMERCIAL & MARKET INTELLIGENCE: Market Intelligence\n"
     "### ORDER PROCESSING: PO Commit (historical) > future Customer Order Processing\n"
     "### COSTING & TECHNICAL INTELLIGENCE: Technical Knowledge Platform > Agentic Costing > Pattern Generation PoC\n"
     "### SOURCING INTELLIGENCE: Sourcing AI Chatbot\n"
     "### MATERIAL & PURCHASING EXECUTION: Inventory Report > Material Allocation > Adhoc Indent > GDI\n"
     "### PRODUCTION INTELLIGENCE: Hanging Line IoT > future Smart Factory\n"
     "### FINANCE & BUSINESS CONTROL: Finance AI > GRN Invoice Matching > Expense Invoice Processing\n"
     "### ENTERPRISE SUPPORT / WORKFLOW: GLPI AI Helpdesk, Business Travel & Expense, AWB, PERRI")

# ========================================================= FAR-LEFT PERIPHERY
if (VAULT / DIAGRAM).exists():        # the source of the WFX / GTAS / third-party layers, shown at the top left
    _add({"id": "source-systems-diagram", "type": "file", "x": PX, "y": -1700, "width": PW, "height": 1785,
          "file": DIAGRAM}, "file")
poc_y = y_3p
registry_link = "[[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER|{}]]" if (VAULT / "03_Projects/_Registry/PPJ_DISCOVERY_REGISTER.md").exists() else "{}"
ALIASES = {"DISCOVERY_PatternGenerationPoC": "Also: PPJxStratova.AI - the closed Stratova record (zone 08). "
                                             "No production integration."}


def discovery_text(d: dict) -> str:
    lines = ["# " + d["label"].replace("DISCOVERY_", ""), "## " + registry_link.format(d["label"]),
             f"### {d['status']}", "", "**VENDOR EVALUATION - discovery item, not a project**",
             "Scope: " + " ".join((d.get("scope") or "").split())[:150].rstrip() + ("..." if len(d.get("scope") or "") > 150 else "")]
    lines.append(ALIASES.get(d["label"], "No operational integration assumed."))
    return "\n".join(lines)


def candidate_text(p: dict) -> str:
    target = p.get("link_target") or ""
    title = f"[[{target}|{p['code']}]]" if target and (VAULT / (target + ".md")).exists() else p["code"]
    return (f"# {p['code']}\n## {title}\n### {p['lifecycle']}\n\n**CANDIDATE - not a registered project**\n"
            f"{' '.join((p.get('outcome') or '').split())[:150]}\nCanonical code not confirmed.")


discoveries = list(snap.get("discovery", []))
candidates = [p for p in snap["projects"] if p.get("candidate")]
first = [d for d in discoveries if d["label"] == "DISCOVERY_PatternGenerationPoC"]
rest = [d for d in discoveries if d["label"] != "DISCOVERY_PatternGenerationPoC"]
poc_slots: list[tuple[str, str, str, str | None]] = (           # (node id, text, colour)
    [("poc-" + slug(d["label"]), discovery_text(d), C_AMBER) for d in first]
    + [("poc-cand-" + slug(c["code"]), candidate_text(c), C_AMBER) for c in candidates]
    + [(pid(c), card_text(c), CLASS_COLOR[status_class(projects[c])]) for c in zone_codes("POC")]
    + [("poc-" + slug(d["label"]), discovery_text(d), C_AMBER) for d in rest])
poc_rows = [poc_slots[i:i + 2] for i in range(0, len(poc_slots), 2)] or [[]]
poc_row_h = [max([fit_height(t) for _, t, _ in row] or [CARD_MIN_H]) for row in poc_rows]
poc_title = "06 POC / VENDOR EVALUATION"
pband = band("06 POC / VENDOR EVALUATION (evaluation only)", PW, poc_title)
poc_h = pband + sum(poc_row_h) + CARD_GAP * len(poc_row_h)
group("grp-poc", PX, poc_y, PW, poc_h, "06 POC / VENDOR EVALUATION (evaluation only)", None, poc_title)
py_ = poc_y + pband
for row, rh in zip(poc_rows, poc_row_h):
    for i, (nid, body, colour) in enumerate(row):
        text(nid, PX + 100 + i * (CARD_W + 100), py_, CARD_W, rh, body, colour)
    py_ += rh + CARD_GAP

# legend (far left, below PoC)
ly = poc_y + poc_h + GAP
lband = band("09 LEGEND", PW)
group("grp-legend", PX, ly, PW, lband + 4 * 820, "09 LEGEND")
text("legend-coverage", PX + 100, ly + lband, PW - 200, 780,
     "# MODULE COVERAGE BADGE\n"
     f"### {BADGE[3]} live AI / automation coverage (production / support) - green\n"
     f"### {BADGE[2]} in development / UAT / planned - blue\n"
     f"### {BADGE[1]} evaluation, on hold or historical only - grey\n"
     "### no badge - no project touches this module yet\n\n"
     "Badge = the most advanced project touching the module. By BOD decision (24/09) QC, Production Planning and "
     "Production Management carry no badge yet; their lines still show on hover.")
text("legend-nodes", PX + 100, ly + lband + 820, PW - 200, 780,
     "# NODE CATEGORIES\n"
     "### WFX ERP - purple\n### Third-Party System - brown\n### GTAS Internal System - indigo\n"
     "### Data / Knowledge Platform - teal\n### Shared AI Platform - pink group\n"
     "### Project card colour = STATUS (below)\n\n"
     "The type is on each card under the status: AI APPLICATION | AUTOMATION | WORKFLOW | DATA PLATFORM | "
     "INTERNAL PLATFORM | IOT | POC / EVALUATION | COLLABORATION | ARCHIVED")
text("legend-edges", PX + 100, ly + lband + 1640, PW - 200, 780,
     "# LINES (shown on hover / click)\n"
     "### INTEGRATION - confirmed system integration (green, solid)\n"
     "### PLANNED - planned or in development (orange, dashed)\n"
     "### DATA - data dependency / source (blue, dashed)\n"
     "### KNOWLEDGE - knowledge / RAG / reference (cyan, dotted)\n"
     "### AFFINITY - business relationship, no integration (grey, dotted)\n\n"
     "The label always names the type, and PRIMARY marks a project's main module. Lines of closed projects are grey.")
text("legend-status", PX + 100, ly + lband + 2460, PW - 200, 780,
     "# STATUS COLOUR\n"
     "### Green - Production / Operational\n### Blue - Active / Development\n"
     "### Yellow - UAT / Evaluation / Analysis\n### Orange - On Hold\n"
     "### Grey-blue - Maintenance / Support\n### Grey - Closed / Archived\n\n"
     "The exact source status is written on each card under the project code.")

# ======================================================== FAR-RIGHT PERIPHERY
qy = column_group("grp-collab", "07 EXTERNAL COLLABORATION", QX, 0, 1650, zone_codes("COLLAB"))
qy = column_group("grp-arch", "08 ARCHIVED / CLOSED ENABLEMENT", QX, qy + GAP, 1650, zone_codes("ARCH"),
                  title="08 ARCHIVED / CLOSED")
if zone_codes("NEW"):
    qy = column_group("grp-new", "04.11 NEW / UNCLASSIFIED (not yet curated)", QX, qy + GAP, 1650, zone_codes("NEW"),
                      title="04.11 NEW / UNCLASSIFIED")
guide_y = qy + GAP
text("guide", QX, guide_y, QW, 1750,
     "# HOW TO READ THIS CANVAS\n\n"
     "### Zoomed out - coverage: a badge on a WFX / GTAS module means AI / automation already touches it.\n"
     "### Hover or click - detail: the exact modules, systems and projects, with the line type.\n"
     "### Centre, top to bottom: shared AI platforms, GTAS, third-party, WFX ERP core, data / knowledge foundation. "
     "Left and right: AI & Automation projects by business domain.\n\n"
     "## INTERACTION\n"
     "### - Hover an AI / Automation project: show its connected enterprise modules\n"
     "### - Hover a WFX / GTAS module: show the AI / Automation projects related to it\n"
     "### - Click: pin the focus    - Esc or click the background: reset\n"
     "### - Command 'PPJ Canvas Focus: Toggle presentation / editing mode'\n\n"
     "A line exists only where a vault document or the BOD connection matrix supports it; no line means no "
     "relationship is documented. Interaction needs the PPJ Canvas Focus plugin (enabled in this vault).")
gap_y = guide_y + 1750 + GAP
GAPS = [
    ("gap-1", "## GAP 1 - Expense invoices\n\n"
     "The 35-item baseline lists PPJ.ExpenseInvoices.v1.1 and LOG.EXPENSE.INVOICES.V1.2 as two projects. The vault "
     "registry maps both to ONE project, LOG_ExpenseInvoiceProcessing_v1.2.2, and the BOD review recording "
     "(24/09, T 03:09-04:39) describes one application extended to several units.\n\n"
     "Drawn as one card carrying both baseline names; primary line to WFX Finance.\n\n"
     "Vault also holds two closed records outside the baseline: EXIM.ExpenseInvoices.Automation.v1.1 and "
     "AI.Automation.Workshop.Analysis.202606."),
    ("gap-2", "## GAP 2 - Canonical codes and status\n\n"
     "ACC.GRNInvoiceMatching.v2.3 (baseline) vs ACC_GRNSupplierInvoiceBot_v2.3.0 (vault canonical); canonical used.\n\n"
     "Stratova: one active PoC representation - Pattern Generation PoC (zone 06, discovery register). The closed "
     "PPJxStratova.AI record is kept in zone 08 for traceability.\n\n"
     "GLPI chatbot: described as the merchandising AI helpdesk per the owner's update; not heard in the part of the "
     "24/09 recording received. Vault domain stays Internal Chatbot & AI Platforms."),
    ("gap-3", "## GAP 3 - Systems inventory\n\n"
     "Source: owner's operating-systems diagram. GTAS has 16 applications, not 15: GTAS Costing was missing from the list "
     "in circulation.\n\n"
     "MMSx (diagram) vs MMX (2026-09-18 ecosystem note): treated as one system, name unconfirmed.\n\n"
     "The diagram stars GTAS Costing and highlights Production Planning without stating why. BOD 24/09 suggested "
     "dropping GTAS Compliance from the BOD view (unused); it is still shown."),
    ("gap-4", "## GAP 4 - Relationship evidence\n\n"
     "INTEGRATION only where validated: Material Allocation to WFX Inventory Control, Invoice Downloader to VNPT. "
     "PLANNED: GDI via WFX API, Costing via the GTAS/IED contract, Admin to E-office (blocked by the reopening fee). "
     "Everything else is DATA, KNOWLEDGE or AFFINITY.\n\n"
     "Recording over analysis (24/09): Sourcing chatbot reads Inventory Control, not MMSx; the IoT hanger reads "
     "through Reporting & Analysis; no badge on QC / Production modules; no line to GTAS Transportation. "
     "QSee to WFX QC dropped (vendor evaluation, not in the matrix)."),
]
GAP_H = 640
gap_title = "DATA / GOVERNANCE GAPS"
gpband = band(f"DATA / GOVERNANCE GAP (curated notes, written {RECONCILED})", QW, gap_title)
group("grp-gap", QX, gap_y, QW, gpband + len(GAPS) * (GAP_H + 40),
      f"DATA / GOVERNANCE GAP (curated notes, written {RECONCILED})", None, gap_title)
for i, (gid, body) in enumerate(GAPS):
    text(gid, QX + 100, gap_y + gpband + i * (GAP_H + 40), QW - 200, GAP_H, body)

# ====================================================================== EDGES
PREFIX = {"A": "INTEGRATION", "B": "PLANNED", "C": "AFFINITY", "D": "DATA", "K": "KNOWLEDGE"}
COLOUR = {"A": "4", "B": "2", "D": "#1e88e5", "K": "5"}          # AFFINITY stays Obsidian's default grey


def auto_sides(f: str, t: str) -> tuple[str, str]:
    fx, fy, fw, fh = rect[f]
    tx, ty, tw, th_ = rect[t]
    if tx >= fx + fw:
        return "right", "left"
    if tx + tw <= fx:
        return "left", "right"
    return ("bottom", "top") if ty + th_ / 2 > fy + fh / 2 else ("top", "bottom")


for f, t, cat, qualifier, primary in EDGE_SPEC:
    # A curated line whose endpoint has gone (a project was renamed or removed) is skipped, not fatal.
    if f not in ids or t not in ids:
        notices.append(f"skipped line {f} -> {t}: endpoint not on the canvas (renamed or removed?)")
        continue
    src_code = next((c for c in P if pid(c) == f), None)
    src_cls = status_class(projects[src_code]) if src_code else None
    quals = (["PRIMARY"] if primary else []) + ([qualifier] if qualifier else [])
    if src_cls == "closed":
        quals.append("historical")
    elif src_cls == "hold":
        quals.append("on hold")
    fs, ts = SIDES.get((f, t)) or auto_sides(f, t)
    e = {"id": f"e{len(edges)+1:03d}-{f[:18]}-{t[:18]}", "fromNode": f, "fromSide": fs, "toNode": t, "toSide": ts,
         "label": " | ".join([PREFIX[cat]] + quals)}
    if src_cls == "closed":
        e["color"] = C_CLOSED
    elif cat in COLOUR:
        e["color"] = COLOUR[cat]
    edges.append(e)
if "poc-discovery-patterngenerationpoc" in ids and candidates:
    cid = "poc-cand-" + slug(candidates[0]["code"])
    edges.append({"id": f"e{len(edges)+1:03d}-{cid[:18]}-poc-discovery-pat", "fromNode": cid, "fromSide": "left",
                  "toNode": "poc-discovery-patterngenerationpoc", "toSide": "right", "label": "DATA | benchmark",
                  "color": COLOUR["D"]})


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


def is_relation(e: dict) -> bool:
    """A project line: hidden until hovered, so it may cross cards. Everything else is always visible."""
    return e["fromNode"].startswith(("proj-", "poc-")) or e["toNode"].startswith(("proj-", "poc-"))


def straight_lines():
    for e in edges:
        if (e["fromNode"], e["toNode"]) not in CURVED and not is_relation(e):
            yield e, sock(e["fromNode"], e["fromSide"]), sock(e["toNode"], e["toSide"])


# Group headings sit left, centre or right in their group's top band - whichever no always-visible line runs through.
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
    if kind.get(e["toNode"]) == "group" or kind.get(e["fromNode"]) == "group":
        problems.append(f"edge {e['id']} attaches to a whole group - point it at a module")
if len({e["id"] for e in edges}) != len(edges):
    problems.append("duplicate edge ids")
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
for e, p, q in straight_lines():      # an always-visible line behind a card misleads, but it should not stop the sync
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
    "wfx_modules": len(wfx_left) + len(wfx_right), "third_party": len(tp_nodes),
    "gtas": sum(len(c) for c in gtas_layout),
    "coverage": {k: BADGE[v] for k, v in sorted(coverage.items())},
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
