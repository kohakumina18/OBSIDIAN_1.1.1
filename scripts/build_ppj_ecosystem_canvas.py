"""Generate PPJ_Digital_Application_AI_Automation_Ecosystem.canvas from the vault.

Dry run (validates, writes nothing):   python scripts/build_ppj_ecosystem_canvas.py
Write the Canvas:                      python scripts/build_ppj_ecosystem_canvas.py --write
Independent check of the result:       python scripts/validate_ppj_ecosystem_canvas.py

The Canvas is generated, not synchronized: the Executive Canvas watcher does not touch it. Re-run with --write after a
project is added, renamed or changes status. Hand edits to the .canvas are overwritten by --write.

Project data comes from the portfolio snapshot (the vault's own registry); the
WFX / GTAS / third-party inventory comes from the owner's operating-systems
infographic recorded in PPJ_Operational_Systems_Landscape.md.
"""
from __future__ import annotations

import json
import math
import re
import sys
from pathlib import Path

VAULT = Path(__file__).resolve().parents[1]
SNAP = VAULT / "03_Projects/_Registry/Portfolio_Snapshots/PPJ_PORTFOLIO_SNAPSHOT_20260918.json"
OUT = VAULT / "03_Projects/Canvas/PPJ_Digital_Application_AI_Automation_Ecosystem.canvas"
RECONCILED = "24/09/2026"

snap = json.loads(SNAP.read_text("utf-8-sig"))
projects = {p["code"]: p for p in snap["projects"]}

# ---------------------------------------------------------------- geometry
CARD_W, CARD_H, PITCH, PAD, HDR = 1450, 380, 420, 100, 160
CX, CW = 1950, 5400          # centre stack
LX, LW = 0, 1650             # left domain column
RX, RW = 7650, 1650          # right domain column
GAP = 180

# ------------------------------------------------------------------ colours
C_PROD, C_ACTIVE, C_AMBER, C_HOLD = "4", "5", "3", "2"
C_MAINT, C_CLOSED = "#6f8fa8", "#8c8c8c"
C_WFX, C_3P, C_GTAS, C_DATA, C_SHARED = "6", "#a0522d", "#5c6bc0", "#26a69a", "#d81b60"

nodes: list[dict] = []
edges: list[dict] = []
ids: set[str] = set()
rect: dict[str, tuple[float, float, float, float]] = {}
kind: dict[str, str] = {}
warnings: list[str] = []


def _add(n: dict, k: str) -> None:
    assert n["id"] not in ids, f"duplicate id {n['id']}"
    ids.add(n["id"])
    rect[n["id"]] = (n["x"], n["y"], n["width"], n["height"])
    kind[n["id"]] = k
    nodes.append(n)


def est_height(text: str, w: float) -> float:
    cpl = max(20, (w - 40) / 8.6)
    h = 44.0
    for line in text.split("\n"):
        if not line.strip():
            h += 12
            continue
        factor = 1.7 if line.startswith("#") else 1.0
        h += math.ceil(len(line) / (cpl / factor)) * 26 * (1.25 if line.startswith("#") else 1.0)
    return h


def text(nid, x, y, w, h, body, color=None):
    need = est_height(body, w)
    if need > h:
        warnings.append(f"{nid}: text needs ~{need:.0f} > {h}")
    n = {"id": nid, "type": "text", "x": int(x), "y": int(y), "width": int(w), "height": int(h), "text": body}
    if color:
        n["color"] = color
    _add(n, "text")


def group(gid, x, y, w, h, label, color=None):
    n = {"id": gid, "type": "group", "x": int(x), "y": int(y), "width": int(w), "height": int(h), "label": label}
    if color:
        n["color"] = color
    _add(n, "group")


def edge(f, t, cat, label, fs, ts, curve=False):
    assert f in ids and t in ids, f"edge endpoint missing {f} -> {t}"
    prefix = {"A": "INTEGRATION", "B": "PLANNED", "C": "AFFINITY", "D": "DATA"}[cat]
    e = {"id": f"e{len(edges)+1:03d}-{f[:18]}-{t[:18]}", "fromNode": f, "fromSide": fs, "toNode": t, "toSide": ts,
         "label": f"{prefix} | {label}"}
    col = {"A": "4", "B": "2", "D": "5"}.get(cat)
    if col:
        e["color"] = col
    edges.append(e)
    if curve:
        e["_curve"] = True


def slug(s: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


def pid(code: str) -> str:
    return "proj-" + slug(code)


# ------------------------------------------------------------ vault links
_root_cache: dict[str, str | None] = {}


def resolve_link(p: dict) -> str | None:
    root = p.get("root_file")
    if not root:
        return None
    base = VAULT / "03_Projects"
    cand = base / root
    if not cand.exists():
        hits = [h for h in base.rglob(Path(root).name) if "_Registry" not in h.parts and "Canvas" not in h.parts]
        if not hits:
            hits = [h for h in (VAULT / "02_BA_Knowledge").rglob(Path(root).name)]
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
        "Costing and quotation package: Sew Agent, Wash Agent, BOM, consumption, similar style. AI proposes, domain expert approves.", None, None),
    "MER_MarketIntelligence_v1.1.0": ("MER", "Market Intelligence", "AI APPLICATION (data intelligence)",
        "Market, customer, product and material opportunity signals from external data and internal history.",
        "Intelligence layer - not a system of record.", "Data input: Enterprise Data / DWH and sales / PO / fabric history (no edge drawn - see guide)."),
    "MER_InvoiceDataRecheck_v1.1.0": ("MER", "Invoice Data Recheck", "AUTOMATION (audit / rule engine)",
        "Cross-check costing, commercial and invoice data with configurable customer rule packs; exceptions go to human review.", None, None),
    "MER_POCommit_v1.1.0": ("MER", "PO Commit Automation", "AUTOMATION",
        "Customer order to MER PO creation; about 70-80% of customer scenarios covered. Historical record.", None, None),
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
        "Request, approval, trip, advance, expense, settlement; multi-traveler requests. E-office integration is in scope.", None, None),
    "SCP_SourcingChatbot_v2.3.0": ("SRC", "Sourcing AI Chatbot", "AI APPLICATION (RAG / chatbot)",
        "Supplier, material and sample search, comparison and sourcing knowledge retrieval.", None, None),
    "PUR_AdhocIndentSouth_v1.0.0": ("SRC", "Adhoc Indent Automation (South)", "AUTOMATION (rule-based)",
        "Repeated Adhoc Indent processing for the South region; WFX compatibility.", None, None),
    "PUR_HMLabelProcessing_v1.0.0": ("SRC", "H&M Label-O Processing", "AUTOMATION (rule-based)",
        "H&M Label-O processing; paused pending a scalable business case.", None, None),
    "PUR_InventoryReport_v2.1.0": ("SRC", "Purchasing Inventory Report", "DATA PLATFORM (reporting / visibility)",
        "Purchasing inventory and material visibility. A data-visibility layer, not an automation bot.", None, None),
    "PUR_MaterialAllocation_v1.1.0": ("SRC", "Material Allocation Automation", "AUTOMATION (workflow / transaction)",
        "Surplus-material unreserve and reallocation across OCs. First Sewing / Embroidery flow validated.", None, None),
    "PUR_GDIAutomation_v1.0.0": ("SRC", "GDI Automation", "AUTOMATION (API-first transaction)",
        "Goods dispatch / GDI data entry through WFX GET / POST APIs; API specification and UAT still ahead.",
        "System of Record: WFX.", None),
    "FIN_FinanceManagement_v1.2.0": ("FIN", "Finance AI Management", "AI APPLICATION (finance analytics platform)",
        "WS1 financial Q&A; WS2 OC cost and profitability control; WS3 factory cost integrity. Cross-system finance intelligence.",
        "Data sources: WFX + DWH + GTAS / BI sources. Not a financial system of record.", None),
    "FIN_InvoiceDownloader_v1.2.0": ("FIN", "Invoice Downloader", "AUTOMATION",
        "Downloads VNPT e-invoice files: session / cookie management and file retrieval. No accounting entry.", None, None),
    "ACC_GRNSupplierInvoiceBot_v2.3.0": ("FIN", "GRN Supplier Invoice Bot", "AUTOMATION (transaction bot)",
        "Validation, business rules and automated data entry for GRN and supplier invoices.", None,
        "Process affinity also: Logistics In-bound (GRN), Purchase Order Management."),
    "ACC_InventoryReport_v1.0.0": ("FIN", "Accounting Inventory Report", "DATA PLATFORM (reporting)",
        "Accounting inventory reporting. Distinct from the Purchasing Inventory Report.", None, None),
    "EXIM.ExpenseInvoices.Automation.v1.1": ("FIN", "EXIM Expense Invoice Bot (legacy)", "AUTOMATION",
        "Legacy EXIM expense-invoice automation, replaced by LOG_ExpenseInvoiceProcessing_v1.2.2.", None,
        "Not in the 35-item baseline; present in the vault registry."),
    "LOG_ExpenseInvoiceProcessing_v1.2.2": ("WHL", "Expense Invoice Processing", "AUTOMATION (regional invoice)",
        "Logistics / EXIM expense invoices: regional and tax rules, validation, exceptions. Regions: HCM, Da Nang, Nha Trang, Ha Noi.", None,
        "Merged in the vault registry - see gap note 1."),
    "WH_AWBExtraction_v1.1.0": ("WHL", "AWB Document Intelligence", "AI APPLICATION (document intelligence)",
        "AWB image OCR and DHL email parsing into one validated canonical AWB record; human validation.", None, None),
    "PROD_HangingLineIoT_v1.0.0": ("PROD", "Hanging Line IoT", "IOT",
        "Production hanging-line digitalization and monitoring. IoT / operational, not an LLM application.", None, None),
    "WASH_SamplingManagement_v1.1.0": ("PROD", "Wash Sampling Management Portal", "WORKFLOW",
        "Wash sample request, planning, result and approval in the PPJ Group Portal.", None, None),
    "WASH_COWASH_v2.0.0": ("PROD", "COWASH Wash Operations", "SYSTEM / APPLICATION (production wash platform)",
        "Wash production workflow and operational data. Distinct from the sampling portal.", None, None),
    "QC_DefectDetection_v1.0.0": ("QC", "AI Defect Detection", "AI APPLICATION (computer vision)",
        "Image, defect detection, classification, QC review. Vendor proposal and NDA only - not an approved PoC.", None,
        "Stream: EXTERNAL DEVELOPMENT."),
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
    "LOG_ExpenseInvoiceProcessing_v1.2.2": "PPJ.ExpenseInvoices.v1.1 + LOG.EXPENSE.INVOICES.V1.2 (one project in the vault)",
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

missing = [c for c, p in projects.items() if not p.get("candidate") and c not in P]
extra = [c for c in P if c not in projects]
assert not missing and not extra, (missing, extra)


def card(code: str, x: int, y: int) -> None:
    zone, friendly, klass, cap, sor, note = P[code]
    p = projects[code]
    link = resolve_link(p)
    head = f"## {link}" if link else f"## {code}"
    lines = [head, "", friendly, "", f"Domain: {p['domain']}", f"Type: {klass}", f"Status: {p['lifecycle']}"]
    if code in BASELINE:
        lines.append(f"Baseline code: {BASELINE[code]}")
    lines += ["", f"Capability: {cap}"]
    if sor:
        lines.append(sor)
    if note:
        lines.append(note)
    if not link:
        lines.append("Vault Link: Not found")
    text(pid(code), x, y, CARD_W, CARD_H, "\n".join(lines), CLASS_COLOR[status_class(p)])


def column_group(gid, label, x, y, w, codes, color=None):
    h = HDR + len(codes) * PITCH
    group(gid, x, y, w, h, label, color)
    for i, c in enumerate(codes):
        card(c, x + (w - CARD_W) // 2, y + HDR + i * PITCH)
    return y + h


# =================================================================== TOP ZONE
group_order: list[str] = []
text("eco-title", 0, -1500, 9300, 240,
     "# PPJ GROUP\n## Digital Application, AI & Automation Ecosystem")
text("eco-subtitle", 0, -1230, 9300, 260,
     "ERP -> Enterprise Applications -> Internal Systems -> AI & Automation\n\n"
     f"Portfolio Baseline: 19/09/2026  |  Vault Reconciliation: {RECONCILED}\n"
     "Generated From: PPJ AI & Automation Portfolio (vault registry) + PPJ operating-systems landscape "
     "([[02_BA_Knowledge/Enterprise_Architecture/PPJ_Operational_Systems_Landscape|Operational Systems Landscape]])")

text("eco-exec-summary", 0, -940, 3000, 640,
     "## PPJ DIGITAL EVOLUTION\n\n"
     "1. WFX provides the ERP transaction backbone.\n"
     "2. Third-party enterprise applications provide specialized capabilities.\n"
     "3. GTAS applications were built internally to fill operational capability gaps.\n"
     "4. AI & Automation projects now add an intelligence and automation layer across existing processes.\n"
     "5. Shared data, knowledge and AI platforms increasingly serve reusable cross-functional capabilities.\n"
     "6. AI does not replace the ERP; it augments ERP, enterprise systems and business decision-making.")

text("eco-principles", 3200, -940, 3000, 640,
     "## ARCHITECTURE PRINCIPLES\n\n"
     "- WFX remains core ERP / transaction backbone.\n"
     "- AI projects augment rather than duplicate source systems.\n"
     "- System of record must remain explicit.\n"
     "- Prefer API-based integration where available.\n"
     "- Business affinity does not imply technical integration.\n"
     "- Human review remains required for uncertain AI decisions.\n"
     "- Reusable data / knowledge layers serve multiple projects.\n"
     "- Shared AI services reduce duplicate implementations.\n"
     "- Status and lifecycle are independent from business domain.")

# inventory panel (baseline vs recomputed) -- filled after classes are known
regs = [p for p in snap["projects"] if not p.get("candidate")]
cur = {k: 0 for k in CLASS_LABEL}
for p in regs:
    cur[status_class(p)] += 1
assert sum(cur.values()) == len(regs) == 36
text("eco-inventory", 6400, -940, 2900, 640,
     "## PORTFOLIO INVENTORY\n\n"
     "Baseline 19/09/2026 (35 initiatives):\n"
     "Active / Dev 16 | Production 6 | Maintenance 4 | Closed 4 | On Hold 3 | Evaluation 2\n\n"
     f"Current Vault {RECONCILED} ({len(regs)} registered records, recomputed):\n"
     f"Production {cur['production']} | Active / Dev {cur['active']} | UAT / Eval / Analysis {cur['amber']} | "
     f"Maintenance {cur['maint']} | On Hold {cur['hold']} | Closed {cur['closed']}\n\n"
     "Baseline is kept unchanged. Bucket definitions differ - see the gap notes.")

# ============================================================ LEFT COLUMN
y = 0
group_order += ["grp-mer"]
y_end = column_group("grp-mer", "04.2 MERCHANDISING", LX, y, LW,
                     ["MER_CostingAgenticPlatform_v1.1.0", "MER_MarketIntelligence_v1.1.0",
                      "MER_InvoiceDataRecheck_v1.1.0", "MER_POCommit_v1.1.0"])
y_end = column_group("grp-src", "04.1 SOURCING / PURCHASING", LX, y_end + GAP, LW,
                     ["SCP_SourcingChatbot_v2.3.0", "PUR_AdhocIndentSouth_v1.0.0", "PUR_HMLabelProcessing_v1.0.0",
                      "PUR_InventoryReport_v2.1.0", "PUR_MaterialAllocation_v1.1.0", "PUR_GDIAutomation_v1.0.0"])
y_end = column_group("grp-whl", "04.6 WAREHOUSE / LOGISTICS", LX, y_end + GAP, LW,
                     ["WH_AWBExtraction_v1.1.0", "LOG_ExpenseInvoiceProcessing_v1.2.2"])

# ============================================================ RIGHT COLUMN
ry = column_group("grp-hr", "04.8 HR", RX, 0, RW, ["HR_EmployeeDataPlatform_v1.1.0"])
ry = column_group("grp-admin", "04.9 ADMINISTRATION", RX, ry + GAP, RW, ["ADMIN_ExpenseManagement_v1.1.0"])
ry = column_group("grp-fin", "04.3 FINANCE / ACCOUNTING", RX, ry + GAP, RW,
                  ["FIN_FinanceManagement_v1.2.0", "FIN_InvoiceDownloader_v1.2.0", "ACC_GRNSupplierInvoiceBot_v2.3.0",
                   "ACC_InventoryReport_v1.0.0", "EXIM.ExpenseInvoices.Automation.v1.1"])
ry = column_group("grp-qc", "04.5 QC / TQM", RX, ry + GAP, RW,
                  ["QC_DefectDetection_v1.0.0", "QC_ThreadTraceability_v1.0.0"])
ry = column_group("grp-prod", "04.4 PRODUCTION + WASH", RX, ry + GAP, RW,
                  ["PROD_HangingLineIoT_v1.0.0", "WASH_SamplingManagement_v1.1.0", "WASH_COWASH_v2.0.0"])

# ============================================================ CENTRE STACK
# --- shared AI platforms
sy = 0
sh = HDR + CARD_H + 40 + 220 + 40
group("grp-shared", CX, sy, CW, sh, "04.10 SHARED AI PLATFORMS (enterprise capabilities, not domain apps)", C_SHARED)
sx0 = CX + (CW - (3 * CARD_W + 2 * 150)) // 2
for i, c in enumerate(["AI_PERRIPlatform_v3.2.0", "AI_ApplicationHub_v2.1.0", "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"]):
    card(c, sx0 + i * (CARD_W + 150), sy + HDR)
text("shared-note", sx0, sy + HDR + CARD_H + 40, 3 * CARD_W + 300, 220,
     "Conceptual direction: business AI applications -> PPJ AI Hub -> shared AI services / governance / knowledge / models.\n"
     "Edges to AI Hub or PERRI are drawn only where documentation confirms use. None is confirmed today.")
y_gtas = sy + sh + GAP

# --- GTAS
NW, NH, NP = 1200, 130, 170
xs4 = [CX + 120 + c * 1320 for c in range(4)]
gtas_layout = [
    ["GTAS Costing", "GTAS IED", "GTAS Transportation", "GTAS Sampling"],
    ["GTAS Consumption", "GTAS Coats Integration", "GTAS Mixable", "GTAS Inventory"],
    ["GTAS Compliance", "GTAS FQM", "GTAS QC", "GTAS ECUS"],
    ["GTAS BI Report", "GTAS Financial Statements", "GTAS Production", "GTAS Salary"],
]
gh = HDR + 3 * NP + NH + 40
group("grp-gtas", CX, y_gtas, CW, gh, "03 GTAS INTERNAL APPLICATIONS - Legacy Internal Development", C_GTAS)
for c, col in enumerate(gtas_layout):
    for r, name in enumerate(col):
        body = f"**{name}**"
        if name == "GTAS Costing":
            body += "\nstarred in the source diagram"
        text("gtas-" + slug(name.replace("GTAS ", "")), xs4[c], y_gtas + HDR + r * NP, NW, NH, body, C_GTAS)
y_3p = y_gtas + gh + GAP

# --- third party
TW, TH, TP = 1200, 160, 200
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
    text("tp-" + slug(name), xs4[c], y_3p + HDR + r * TP, TW, TH, f"**{name}**\n{purpose}\n({origin})", C_3P)
text("tp-note", xs4[1], y_3p + HDR + TP, 2 * TW + 120, 3 * TP - 40,
     "Six of these are drawn on the owner's operating-systems diagram: HRIS, E-office, MMSx, FastReactPlan, Gerber, ShapeShifter.\n\n"
     "VNPT E-Invoice, Power BI, GLPI and IoT / WISER / INA are confirmed by vault documents but are not on that diagram.\n\n"
     "Only listed applications are drawn. No further vendor application is assumed.")
y_wfx = y_3p + th + GAP

# --- WFX
MW, MH, MP = 1350, 130, 170
wfx_left = ["Buyer Order Management", "Budgeting & Costing", "Bill of Material", "Raw Material Planning",
            "Purchase Order Management", "Inventory Control", "Logistics In-bound", "Logistics Out-bound"]
wfx_right = ["Finance", "Style Library", "BrandPLM", "Sampling", "QC", "QA", "Production Planning",
             "Production Management"]
wh = HDR + 8 * MP - (MP - MH) + 40
group("grp-wfx", CX, y_wfx, CW, wh, "01 WFX ERP CORE - Core Enterprise Transaction System", C_WFX)
lx, rx_ = CX + 100, CX + CW - 100 - MW
for i, name in enumerate(wfx_left):
    text("wfx-" + slug(name), lx, y_wfx + HDR + i * MP, MW, MH, f"**{name}**", C_WFX)
for i, name in enumerate(wfx_right):
    body = f"**{name}**" + ("\nhighlighted in the source diagram" if name == "Production Planning" else "")
    text("wfx-" + slug(name), rx_, y_wfx + HDR + i * MP, MW, MH, body, C_WFX)
hx = lx + MW + 100
text("wfx-core", hx, y_wfx + HDR, rx_ - 100 - hx, 8 * MP - (MP - MH),
     "# WFX ERP\n\nCore Enterprise Transaction System\n\n"
     "Reporting & Analysis\nTime & Action Tracking\nTextiles / Garments\n\n"
     "16 modules, named from the owner's operating-systems diagram. WFX is the system of record for orders, purchasing, "
     "material, inventory and operational transactions.\n\n"
     "AI and automation augment WFX; they do not replace it. Not every AI use case writes back to WFX.", C_WFX)
y_data = y_wfx + wh + GAP

# --- data foundation
DW, DH, DP = 1550, 170, 210
# Last column ends at x=7250, level with the WFX / GTAS right-hand nodes, so an edge from the right-hand domain
# column reaches it through the free corridor instead of crossing a module.
xs3 = [CX + 120, CX + 120 + (7250 - 1550 - (CX + 120)) // 2, 7250 - 1550]
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
    text(nid, xs3[c], y_data + HDR + r * DP, DW, DH, f"**{name}**\n{src}", C_DATA)
y_fab = y_data + dh + GAP

# --- fabric / textiles (bottom centre)
fh = HDR + 2 * PITCH
group("grp-fab", CX, y_fab, 3400, fh, "04.7 FABRIC / TEXTILES TECHNIQUE")
fx = CX + 100
card("TD_TechnicalKnowledgePlatform_v2.1.0", fx, y_fab + HDR)
card("FAB_FabricDatamart_v2.2.0", fx + CARD_W + 100, y_fab + HDR)
card("CPD_VisualSampleDatamart_v1.1.0", fx, y_fab + HDR + PITCH)
card("PPJxStratova.AI", fx + CARD_W + 100, y_fab + HDR + PITCH)

text("flow-labels", CX + 3600, y_fab, 1800, fh,
     "## CAPABILITY FLOWS\n(explanatory - not integrations)\n\n"
     "SOURCING\nSupplier > Material > Search > Decision\n\n"
     "PURCHASING\nPO > Material > Allocation > Dispatch\n\n"
     "MERCHANDISING\nMarket > Costing > Quotation > PO\n\n"
     "PRODUCTION\nPlanning > Production > Wash > QC\n\n"
     "FINANCE\nTransaction > Reporting > Cost Control > RCA\n\n"
     "LOGISTICS\nShipment > AWB > Tracking > Invoice\n\n"
     "ADMIN\nRequest > Approval > Booking > Advance > Expense > Settlement\n\n"
     "TECHNICAL\nFabric > Pattern > BOM > Knowledge > Costing")

# ========================================================= FAR-LEFT PERIPHERY
PX, PW = -3900, 3200
poc_y = y_3p
disc = {d["label"]: d for d in snap["discovery"]}
cand = next(p for p in snap["projects"] if p.get("candidate"))
group("grp-poc", PX, poc_y, PW, 1700, "06 POC / VENDOR EVALUATION (dashed = evaluation only)")
card("PPJxNUNOX.ScanTrial", PX + 100, poc_y + HDR)
d0 = disc["DISCOVERY_PatternGenerationPoC"]
text("poc-discovery-pattern", PX + 100 + CARD_W + 100, poc_y + HDR, CARD_W, CARD_H,
     "## [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER|DISCOVERY_PatternGenerationPoC]]\n\n"
     f"Stratova pattern-generation PoC\n\nStatus: {d0['status']}\nType: POC / EVALUATION (discovery item, not a project)\n\n"
     "Capability: pattern generation; open items include Google DAF approval, funding liability, tolerance and success criteria.\n"
     "Business affinity: Gerber, ShapeShifter - no integration confirmed.", C_AMBER)
text("poc-cpd-candidate", PX + 100 + CARD_W + 100, poc_y + HDR + PITCH, CARD_W, CARD_H,
     "## [[03_Projects/_Registry/Project_Update_Proposals/CPD_IN_HOUSE_PATTERN_GENERATION_CURRENT_INITIATIVE|CPD In-house Pattern Generation]]\n\n"
     f"Internal pattern-generation benchmark\n\nStatus: {cand['lifecycle']}\nType: CANDIDATE (not a registered project)\n\n"
     "Capability: internal benchmark for the Stratova PoC. Canonical code not confirmed.", C_AMBER)
text("poc-wizcore", PX + 100, poc_y + HDR + PITCH, CARD_W, CARD_H,
     f"## Wizcore\n\nStatus: {disc['Wizcore']['status']}\nType: VENDOR EVALUATION (discovery item)\n\n"
     f"Scope: {disc['Wizcore']['scope']}", C_AMBER)
text("poc-faceworks", PX + 100, poc_y + HDR + 2 * PITCH, CARD_W, 260,
     f"## Faceworks AI\n\nStatus: {disc['Faceworks AI']['status']}\nType: VENDOR EVALUATION (discovery item)", C_AMBER)
text("poc-sortech", PX + 100 + CARD_W + 100, poc_y + HDR + 2 * PITCH, CARD_W, 260,
     f"## Sortech\n\nStatus: {disc['Sortech']['status']}\nType: VENDOR EVALUATION (discovery item)", C_AMBER)
text("poc-quanskill", PX + 100, poc_y + HDR + 2 * PITCH + 300, CARD_W, 260,
     f"## Quanskill\n\nStatus: {disc['Quanskill']['status']}\nType: VENDOR EVALUATION (discovery item)\n"
     "Not yet an approved implementation project.", C_AMBER)

# legend (far left, below PoC)
ly = poc_y + 1700 + GAP
group("grp-legend", PX, ly, PW, 2320, "09 LEGEND")
text("legend-nodes", PX + 100, ly + HDR, PW - 200, 700,
     "## NODE CATEGORIES\n\n"
     "WFX ERP - purple\nThird-Party System - brown\nGTAS Internal System - indigo\n"
     "Data / Knowledge Platform - teal\nShared AI Platform - pink group\n"
     "AI / Automation / Workflow / IoT project - card colour = STATUS (right)\n"
     "The Type line on each card names the class:\nAI APPLICATION | AUTOMATION | WORKFLOW | DATA PLATFORM |\n"
     "INTERNAL PLATFORM | IOT | POC / EVALUATION | COLLABORATION | ARCHIVED")
text("legend-edges", PX + 100, ly + HDR + 740, PW - 200, 700,
     "## RELATIONSHIPS (label prefix, never colour alone)\n\n"
     "INTEGRATION | implemented / confirmed operational integration (green line)\n"
     "PLANNED | planned or in-development integration (orange line)\n"
     "AFFINITY | business capability affinity, no technical integration confirmed (plain line)\n"
     "DATA | data / knowledge dependency (blue line)\n\n"
     "Canvas edges cannot be dashed or thinned, so the prefix carries the meaning.")
text("legend-status", PX + 100, ly + HDR + 1480, PW - 200, 680,
     "## STATUS COLOUR (source status text is kept on each card)\n\n"
     "Green - Production / Operational\nBlue - Active / Development / Strategic Active\n"
     "Yellow - UAT / Evaluation / Pre-PoC / Analysis\nOrange - On Hold\n"
     "Grey-blue - Maintenance / Support\nGrey - Closed / Archived")

# ======================================================== FAR-RIGHT PERIPHERY
QX, QW = 9600, 3200
qy = column_group("grp-collab", "07 EXTERNAL COLLABORATION", QX, 0, 1650, ["EXT_AcademicCollaboration_v1.1.0"])
qy = column_group("grp-arch", "08 ARCHIVED / CLOSED ENABLEMENT", QX, qy + GAP, 1650,
                  ["AI.Automation.Workshop.202606", "AI.Automation.Workshop.Analysis.202606", "VITAS.Sharing.202606"])
guide_y = qy + GAP
text("guide", QX, guide_y, QW, 1100,
     "## ARCHITECTURE INTERPRETATION GUIDE\n\n"
     "Read the centre stack top to bottom: shared AI platforms, GTAS internal applications, third-party applications, "
     "WFX ERP core, data / knowledge foundation. It is a layered ecosystem, not a strict dependency stack.\n\n"
     "Domain groups sit left and right of the stack, next to the systems they relate to.\n\n"
     "Position is not architecture. A line exists only where a vault document supports it, and its label says how "
     "strong it is. No line means no relationship is documented.\n\n"
     "Most integrations are therefore drawn as AFFINITY. Nothing is drawn as INTEGRATION unless a validated flow exists.")
gap_y = guide_y + 1100 + GAP
GAPS = [
    ("gap-1", "DATA / GOVERNANCE GAP 1 - Expense invoices merged\n\n"
     "The 35-item baseline lists PPJ.ExpenseInvoices.v1.1 and LOG.EXPENSE.INVOICES.V1.2 as two projects. The vault registry "
     "(PPJ_PORTFOLIO_SNAPSHOT_20260918) already maps both to ONE project, LOG_ExpenseInvoiceProcessing_v1.2.2, and lists a "
     "decision still open: confirm the mapping and whether the earlier Export exclusion applies.\n\n"
     "Drawn as one node (vault registry outranks the baseline). Both baseline names are kept on the card.\n\n"
     "Vault also holds two closed records outside the baseline: EXIM.ExpenseInvoices.Automation.v1.1 and "
     "AI.Automation.Workshop.Analysis.202606 - hence 36 records here."),
    ("gap-2", "DATA / GOVERNANCE GAP 2 - Canonical codes and status\n\n"
     "ACC.GRNInvoiceMatching.v2.3 (baseline) vs ACC_GRNSupplierInvoiceBot_v2.3.0 (vault canonical). The vault says the "
     "GRNInvoiceMatching name is misleading; the canonical code is used.\n\n"
     "PPJxStratova.AI: baseline says Active PoC; vault says Closed and tracks the live PoC as DISCOVERY_PatternGenerationPoC. "
     "Vault used.\n\n"
     "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0: baseline says Merchandising / Shared; vault domain is Internal Chatbot & AI Platforms. "
     "Vault used."),
    ("gap-3", "DATA / GOVERNANCE GAP 3 - Systems inventory\n\n"
     "Source: owner's operating-systems diagram. GTAS has 16 applications, not 15: GTAS Costing was missing from the list "
     "in circulation.\n\n"
     "MMSx (diagram) vs MMX (2026-09-18 ecosystem note): treated as one system, name unconfirmed.\n\n"
     "The Finance AI canvas also names GTAS Factory, Quantity, Efficiency and ID. None is on the diagram; alias or "
     "separate application is unconfirmed.\n\n"
     "The red star on GTAS Costing and the green highlight on Production Planning are shown but their meaning is not stated."),
    ("gap-4", "DATA / GOVERNANCE GAP 4 - Relationship evidence\n\n"
     "No document confirms an integration at WFX-module or GTAS-application level. Those links are AFFINITY.\n\n"
     "Exceptions drawn stronger: PUR_MaterialAllocation validated flow into WFX (INTEGRATION, validated flow only); "
     "FIN_InvoiceDownloader to VNPT (INTEGRATION); PUR_GDIAutomation WFX API, ADMIN_ExpenseManagement E-office and "
     "MER_CostingAgenticPlatform GTAS/IED contract are in scope but not delivered (PLANNED).\n\n"
     "Status counts: baseline buckets and the recomputed buckets differ (e.g. UAT and Analysis are one bucket here), so the "
     "two rows are not directly comparable."),
]
gh_total = HDR + len(GAPS) * 540 + 0
group("grp-gap", QX, gap_y, QW, gh_total, "DATA / GOVERNANCE GAP")
for i, (gid, body) in enumerate(GAPS):
    text(gid, QX + 100, gap_y + HDR + i * 540, QW - 200, 500, body)

# ====================================================================== EDGES
S = pid
# --- Merchandising (left col -> centre-left)
edge(S("MER_CostingAgenticPlatform_v1.1.0"), "wfx-budgeting-costing", "C", "costing capability", "right", "left")
edge(S("MER_CostingAgenticPlatform_v1.1.0"), "wfx-bill-of-material", "C", "BOM input", "right", "left")
edge(S("MER_CostingAgenticPlatform_v1.1.0"), "gtas-ied", "B", "GTAS/IED integration contract to be confirmed", "right", "left")
edge(S("MER_CostingAgenticPlatform_v1.1.0"), "gtas-costing", "C", "costing capability", "right", "left")
edge(S("TD_TechnicalKnowledgePlatform_v2.1.0"), S("MER_CostingAgenticPlatform_v1.1.0"), "D", "technical knowledge input",
     "left", "left", curve=True)
edge(S("MER_MarketIntelligence_v1.1.0"), "wfx-buyer-order-management", "C", "sales / PO history", "right", "left")
edge(S("MER_InvoiceDataRecheck_v1.1.0"), "wfx-budgeting-costing", "C", "costing and commercial data", "right", "left")
edge(S("MER_POCommit_v1.1.0"), "wfx-buyer-order-management", "C", "historical PO commit", "right", "left")
# --- Sourcing / Purchasing
edge(S("SCP_SourcingChatbot_v2.3.0"), "tp-mmsx", "C", "material / sourcing knowledge", "right", "left")
edge(S("SCP_SourcingChatbot_v2.3.0"), "wfx-raw-material-planning", "C", "material requirement", "right", "left")
edge(S("PUR_AdhocIndentSouth_v1.0.0"), "wfx-purchase-order-management", "C", "purchasing transaction process", "right", "left")
edge(S("PUR_HMLabelProcessing_v1.0.0"), "wfx-purchase-order-management", "C", "PO / material workflow", "right", "left")
edge(S("PUR_InventoryReport_v2.1.0"), "wfx-inventory-control", "C", "inventory visibility", "right", "left")
edge(S("PUR_InventoryReport_v2.1.0"), S("PUR_MaterialAllocation_v1.1.0"), "D", "inventory visibility feeds allocation", "bottom", "top")
edge(S("PUR_InventoryReport_v2.1.0"), S("PUR_GDIAutomation_v1.0.0"), "D", "inventory visibility feeds dispatch", "right", "right", curve=True)
edge(S("PUR_MaterialAllocation_v1.1.0"), "wfx-inventory-control", "A", "validated flow only; WFX transaction", "right", "left")
edge(S("PUR_MaterialAllocation_v1.1.0"), "wfx-raw-material-planning", "C", "material requirement", "right", "left")
edge(S("PUR_GDIAutomation_v1.0.0"), "wfx-purchase-order-management", "B", "WFX GET / POST API in development; WFX is SoR", "right", "left")
edge(S("PUR_GDIAutomation_v1.0.0"), "wfx-logistics-in-bound", "C", "dispatch process", "right", "left")
# --- Warehouse / Logistics
edge(S("WH_AWBExtraction_v1.1.0"), "wfx-logistics-in-bound", "C", "shipment / AWB process", "right", "left")
edge(S("WH_AWBExtraction_v1.1.0"), "gtas-transportation", "C", "shipment process", "right", "left")
edge(S("LOG_ExpenseInvoiceProcessing_v1.2.2"), "grp-wfx", "C", "WFX template / additional charge rules (module not named)", "right", "left")
# --- Right column
edge(S("HR_EmployeeDataPlatform_v1.1.0"), "tp-hris", "C", "employee master data", "left", "right")
edge(S("ADMIN_ExpenseManagement_v1.1.0"), "tp-e-office", "B", "E-office integration in scope, not confirmed delivered", "left", "right")
edge(S("ADMIN_ExpenseManagement_v1.1.0"), "tp-hris", "C", "HR / master data", "left", "right")
edge(S("FIN_FinanceManagement_v1.2.0"), "wfx-finance", "D", "WFX Finance data", "left", "right")
edge(S("FIN_FinanceManagement_v1.2.0"), "data-dwh", "D", "DWH / Databricks source", "left", "right")  # right socket: corridor is free
edge(S("FIN_FinanceManagement_v1.2.0"), "tp-power-bi", "D", "Power BI reporting source", "left", "right")
edge(S("FIN_FinanceManagement_v1.2.0"), "gtas-bi-report", "D", "GTAS BI source", "left", "right")
edge(S("FIN_FinanceManagement_v1.2.0"), "gtas-financial-statements", "D", "financial statements source", "left", "right")
edge(S("FIN_InvoiceDownloader_v1.2.0"), "tp-vnpt-e-invoice", "A", "VNPT portal download", "left", "right")
edge(S("ACC_GRNSupplierInvoiceBot_v2.3.0"), "wfx-finance", "C", "accounting posting", "left", "right")
edge(S("QC_DefectDetection_v1.0.0"), "wfx-qc", "C", "quality inspection", "left", "right")
edge(S("QC_DefectDetection_v1.0.0"), "wfx-qa", "C", "quality assurance", "left", "right")
edge(S("QC_DefectDetection_v1.0.0"), "wfx-production-management", "C", "production output", "left", "right")
edge(S("PROD_HangingLineIoT_v1.0.0"), "wfx-production-management", "C", "production line", "left", "right")
edge(S("PROD_HangingLineIoT_v1.0.0"), "wfx-production-planning", "C", "target / WIP", "left", "right")
edge(S("PROD_HangingLineIoT_v1.0.0"), "tp-iot-wiser-ina", "D", "machine / line data", "left", "right")
edge(S("WASH_SamplingManagement_v1.1.0"), "wfx-sampling", "C", "sampling process", "left", "right")
edge(S("WASH_SamplingManagement_v1.1.0"), "wfx-production-management", "C", "wash production", "left", "right")
edge(S("WASH_COWASH_v2.0.0"), "wfx-production-management", "C", "wash production", "left", "right")
edge(S("WASH_COWASH_v2.0.0"), "wfx-qc", "C", "wash quality", "left", "right")
# --- shared / data / fabric
edge(S("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"), "tp-glpi", "C", "GLPI helpdesk knowledge", "right", "right", curve=True)
edge("wfx-core", "data-dwh", "D", "operational transactions ingested", "bottom", "top")
edge(S("FAB_FabricDatamart_v2.2.0"), S("TD_TechnicalKnowledgePlatform_v2.1.0"), "D", "fabric data", "left", "right")
edge(S("CPD_VisualSampleDatamart_v1.1.0"), S("TD_TechnicalKnowledgePlatform_v2.1.0"), "D", "visual sample data", "top", "bottom")
edge(S("TD_TechnicalKnowledgePlatform_v2.1.0"), "data-technical-knowledge", "D", "same capability", "top", "bottom")
edge("poc-cpd-candidate", "poc-discovery-pattern", "D", "internal benchmark", "top", "bottom")

# ================================================================= VALIDATION
def sock(nid, side):
    x, y, w, h = rect[nid]
    return {"left": (x, y + h / 2), "right": (x + w, y + h / 2), "top": (x + w / 2, y), "bottom": (x + w / 2, y + h)}[side]


def seg_hits_rect(p, q, r, pad=6):
    x, y, w, h = r
    x0, y0, x1, y1 = x - pad, y - pad, x + w + pad, y + h + pad
    t0, t1 = 0.0, 1.0
    dx, dy = q[0] - p[0], q[1] - p[1]
    for pp, qq, lo, hi in ((-dx, p[0] - x0, 0, 0), (dx, x1 - p[0], 0, 0), (-dy, p[1] - y0, 0, 0), (dy, y1 - p[1], 0, 0)):
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


problems: list[str] = []
# 1 ids / edge endpoints
for e in edges:
    for k in ("fromNode", "toNode"):
        if e[k] not in ids:
            problems.append(f"orphan edge {e['id']}")
# 2 project nodes: exactly once each
proj_nodes = [i for i in ids if i.startswith("proj-")]
if len(proj_nodes) != 36 or len(set(proj_nodes)) != 36:
    problems.append(f"project node count {len(proj_nodes)} != 36")
# 3 overlap among non-group nodes
leafs = [i for i in ids if kind[i] != "group"]
for i, a in enumerate(leafs):
    ax, ay, aw, ah = rect[a]
    for b in leafs[i + 1:]:
        bx, by, bw, bh = rect[b]
        if ax < bx + bw and bx < ax + aw and ay < by + bh and by < ay + ah:
            problems.append(f"overlap {a} / {b}")
# 4 leaf must sit inside exactly one group (or none for title-zone nodes)
groups = [i for i in ids if kind[i] == "group"]
for a in leafs:
    ax, ay, aw, ah = rect[a]
    if ay < -200 or a in ("guide", "flow-labels"):   # standalone panels by design
        continue
    inside = [g for g in groups if rect[g][0] <= ax and ax + aw <= rect[g][0] + rect[g][2]
              and rect[g][1] <= ay and ay + ah <= rect[g][1] + rect[g][3]]
    if len(inside) != 1:
        problems.append(f"{a} inside {len(inside)} groups")
# 5 groups must not overlap each other
for i, a in enumerate(groups):
    ax, ay, aw, ah = rect[a]
    for b in groups[i + 1:]:
        bx, by, bw, bh = rect[b]
        if ax < bx + bw and bx < ax + aw and ay < by + bh and by < ay + ah:
            problems.append(f"group overlap {a} / {b}")
# 6 edges must not run through a third-party leaf node
for e in edges:
    if e.get("_curve"):
        continue
    p, q = sock(e["fromNode"], e["fromSide"]), sock(e["toNode"], e["toSide"])
    for n in leafs:
        if n in (e["fromNode"], e["toNode"]):
            continue
        if seg_hits_rect(p, q, rect[n]):
            problems.append(f"edge {e['fromNode']} -> {e['toNode']} crosses {n}")
            break
for e in edges:
    e.pop("_curve", None)

ordered = [n for n in nodes if n["type"] == "group"] + [n for n in nodes if n["type"] != "group"]
doc = {"nodes": ordered, "edges": edges, "metadata": {"version": "1.0-1.0", "frontmatter": {}}}
payload = json.dumps(doc, ensure_ascii=False, indent=2) + "\n"
json.loads(payload)  # must parse

report = {
    "nodes": len(ordered), "edges": len(edges), "project_nodes": len(proj_nodes),
    "wfx_modules": len(wfx_left) + len(wfx_right), "third_party": len(tp_nodes),
    "gtas": sum(len(c) for c in gtas_layout),
    "links_missing": [c for c in P if resolve_link(projects[c]) is None],
    "warnings": warnings, "problems": problems, "classes": cur,
    "bbox": (min(r[0] for r in rect.values()), min(r[1] for r in rect.values()),
             max(r[0] + r[2] for r in rect.values()), max(r[1] + r[3] for r in rect.values())),
}
if "--write" in sys.argv:
    OUT.write_text(payload, encoding="utf-8")
    report["written"] = str(OUT)
if "--layout-json" in sys.argv:   # optional: geometry dump for a layout preview
    Path(sys.argv[sys.argv.index("--layout-json") + 1]).write_text(
        json.dumps({"rect": rect, "kind": kind, "edges": edges}), "utf-8")
print(json.dumps(report, indent=2, ensure_ascii=False))
