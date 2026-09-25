import json
import re
from collections import Counter
from pathlib import Path

V = Path(__file__).resolve().parents[1]
CANVAS = V / "03_Projects/Canvas/PPJ_Digital_Application_AI_Automation_Ecosystem.canvas"
raw = CANVAS.read_text("utf-8")
doc = json.loads(raw)
nodes, edges = doc["nodes"], doc["edges"]
byid = {n["id"]: n for n in nodes}
res = []


def check(name, ok, detail=""):
    res.append((name, ok, detail))


check("JSON parses; only nodes/edges/metadata keys", set(doc) == {"nodes", "edges", "metadata"})
check("unique node ids", len(byid) == len(nodes))
check("unique edge ids", len({e['id'] for e in edges}) == len(edges))
check("no orphan edges", all(e["fromNode"] in byid and e["toNode"] in byid for e in edges))
allowed_node_keys = {"id", "type", "x", "y", "width", "height", "text", "label", "color", "file"}
check("node keys are spec keys", all(set(n) <= allowed_node_keys for n in nodes))
allowed_edge_keys = {"id", "fromNode", "fromSide", "toNode", "toSide", "label", "color"}
check("edge keys are spec keys", all(set(e) <= allowed_edge_keys for e in edges))
check("sides valid", all(e["fromSide"] in ("top", "bottom", "left", "right") and e["toSide"] in ("top", "bottom", "left", "right") for e in edges))
check("all coordinates integers", all(isinstance(n[k], int) for n in nodes for k in ("x", "y", "width", "height")))
check("every edge label starts with its category",
      all(re.match(r"^(INTEGRATION|PLANNED|AFFINITY|DATA|KNOWLEDGE)( \| [^|]+)*$", e.get("label", "")) for e in edges),
      str([e.get("label") for e in edges if not re.match(r"^(INTEGRATION|PLANNED|AFFINITY|DATA|KNOWLEDGE)( \| [^|]+)*$", e.get("label", ""))]))
# Lines are hover-only (PPJ Canvas Focus plugin) since the 24/09 BOD review, so the old one-AFFINITY-line-per-project
# limit is gone; labels only show on hover and may carry "PRIMARY" plus a short qualifier.
check("edge labels stay short (<= 40 chars)", all(len(e["label"]) <= 40 for e in edges),
      str([e["label"] for e in edges if len(e["label"]) > 40]))
check("no line attaches to a whole group", all(byid[e[k]]["type"] != "group" for e in edges for k in ("fromNode", "toNode")))
# Vault canvas-label rule: ASCII only, except the three module-coverage badges inside text nodes.
BADGES = set("\u25cf\u25d0\u25cb")
non_ascii = {c for c in raw if ord(c) > 127} - BADGES
check("ASCII only apart from coverage badges (vault canvas-label rule)", not non_ascii, str(sorted(non_ascii)))
check("group labels and edge labels are pure ASCII",
      all(n.get("label", "").isascii() for n in nodes) and all(e.get("label", "").isascii() for e in edges))

# CHECK 1 / 2 : the 35 baseline initiatives + canonical codes
snap = json.loads((V / "03_Projects/_Registry/Portfolio_Snapshots/PPJ_PORTFOLIO_SNAPSHOT_20260918.json").read_text("utf-8-sig"))
regs = [p["code"] for p in snap["projects"] if not p.get("candidate")]
proj_nodes = [n for n in nodes if n["id"].startswith("proj-")]
check("one project node per registered record", len(proj_nodes) == len(regs), f"{len(proj_nodes)} nodes / {len(regs)} records")
check("file nodes point at real files", all((V / n["file"]).exists() for n in nodes if n["type"] == "file"))
check("LF line endings only (same bytes on every OS)", b"\r" not in CANVAS.read_bytes())
heads = Counter()
for n in proj_nodes:
    code_line = n["text"].splitlines()[1]          # line 0 is the friendly name, line 1 the code
    m = re.search(r"\|([^\]]+)\]\]", code_line) or re.search(r"## (.+)", code_line)
    heads[m.group(1).strip()] += 1
check("project name and code are headings (legible zoomed out)",
      all(n["text"].startswith("# ") and n["text"].splitlines()[1].startswith("## ") for n in proj_nodes))
check("each canonical code appears exactly once", all(heads[c] == 1 for c in regs), str([c for c in regs if heads[c] != 1]))
BASE35 = """PPJ.UIT.ACADEMIC.COLLABORATION.v1.1|PPJxQSee.AI|QC.Primo1D.RFID.Thread.v1.0|SCP.SOURCING.CHATBOT.v2.3|PUR.Adhoc.Indent.South.v1.0|
PUR.Material.Allocation.v1.1|PUR.Inventory.Report.v2.1|PUR.GDI.Automation.v1.0|PUR.HM.LabelO.Processing.Automation.v1.0|
COSTING.AGENTIC.PLATFORM.v1.1|MER.MARKET.INTELLIGENCE.v1.1|MER.INVOICE.DATA.RECHECK.v1.1|MER.PO.Commit.v1.1|PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0|
PROD.IOT.CHuyenTreo.v1.0|PROD.COWASH.v2.0|WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1|FIN.AI.FINANCE.MANAGEMENT.v1.2|ACC.GRNInvoiceMatching.v2.3|
ACC.Inventory.Report.v1.0|PPJ.ExpenseInvoices.v1.1|PPJ.InvoiceDownloader.v1.2|PPJ.PERRI.Chatbot.v3.2|PPJ.AI.Hub.v2.1|HR.SSPFD.Workflow.v1.1|
TD.TechnicalKnowledge.Platform.v2.1|FD.Datamart.v2.2|CPD.Datamart.v1.1|PPJxStratova.AI|PPJxNUNOX.ScanTrial|Admin Expense Management.v1.1|
WH.AWB.EXTRACTION.v1.1|LOG.EXPENSE.INVOICES.V1.2|AI.Automation.Workshop.202606|VITAS.Sharing.202606""".replace("\n", "").split("|")
proj_text = "\n".join(n["text"] for n in proj_nodes)
missing35 = [b for b in BASE35 if b not in proj_text]
check("all 35 baseline names findable on a project card", len(BASE35) == 35 and not missing35, str(missing35))

# CHECK 3-6 : specific canonical names
check("Invoice recheck shown by canonical code, not as a Chico's project",
      "MER_InvoiceDataRecheck_v1.1.0" in proj_text and "CHICOS" not in "\n".join(
          re.sub(r"\[\[[^\]]*\]\]", "", n.get("text", "")) for n in nodes))
check("Finance AI is v1.2", "FIN_FinanceManagement_v1.2.0" in proj_text)
check("GRN bot uses the vault canonical code", "ACC_GRNSupplierInvoiceBot_v2.3.0" in proj_text)
check("Purchasing inventory report is v2.1", "PUR_InventoryReport_v2.1.0" in proj_text)

# CHECK 7 : forbidden relationships
def targets(src_code_fragment):
    src = [n["id"] for n in proj_nodes if src_code_fragment in n["id"]]
    return {e["toNode"] for e in edges if e["fromNode"] in src}


forbidden = {
    "fin-financemanagement": {"gtas-ied"},
    "acc-grnsupplierinvoicebot": {"gtas-coats-integration"},
    "wh-awbextraction": {"tp-shapeshifter"},
    "pur-hmlabelprocessing": {"gtas-salary"},
    "scp-sourcingchatbot": {"gtas-ecus"},
    "td-technicalknowledgeplatform": {"gtas-qc"},
    "mer-marketintelligence": {"gtas-sampling"},
}
bad = {k: sorted(targets(k) & v) for k, v in forbidden.items() if targets(k) & v}
check("no misleading relationships from the old infographic", not bad, str(bad))
check("no 'INTEGRATION' edge unless validated / confirmed",
      {(e["fromNode"], e["toNode"]) for e in edges if e["label"].startswith("INTEGRATION")} ==
      {("proj-pur-materialallocation-v1-1-0", "wfx-inventory-control"), ("proj-fin-invoicedownloader-v1-2-0", "tp-vnpt-e-invoice")})

# CHECK 11-13 : visual honesty
def color_of(code_fragment):
    return next(n.get("color") for n in proj_nodes if code_fragment in n["id"])


check("Closed items are grey", all(color_of(f) == "#8c8c8c" for f in
      ("acc-inventoryreport", "mer-pocommit", "exim-expenseinvoices", "ai-automation-workshop-202606", "vitas", "ppjxstratova")))
check("PoC / evaluation items are not green", all(color_of(f) not in ("4",) for f in ("qc-threadtraceability", "ppjxnunox", "qc-defectdetection")))
check("On Hold items are orange", all(color_of(f) == "2" for f in ("qc-defectdetection", "wash-cowash", "pur-hmlabelprocessing")))

# structure counts
count = lambda p: sum(1 for n in nodes if n["id"].startswith(p))
check("16 WFX modules", sum(1 for n in nodes if n["id"].startswith("wfx-") and n["id"] != "wfx-core") == 16)
check("16 GTAS applications", count("gtas-") == 16)
check("10 third-party nodes (+1 note)", sum(1 for n in nodes if n["id"].startswith("tp-") and n["id"] != "tp-note") == 10)
check("all domain zones labelled", all(any(z in n.get("label", "") for n in nodes) for z in
      ("04.1", "04.2", "04.3", "04.4", "04.5", "04.6", "04.7", "04.8", "04.9", "04.10", "06 ", "07 ", "08 ", "09 ", "05 ", "01 ", "02 ", "03 ")))

# wikilinks must resolve
bad_links = []
for n in nodes:
    for target in re.findall(r"\[\[([^\]|]+)", n.get("text", "")):
        cand = V / (target + ".md")
        if not cand.exists() and not (V / target).exists():
            bad_links.append(target)
check("every wikilink resolves to a real file", not bad_links, str(bad_links))
resolved = sum(len(re.findall(r"\[\[", n.get("text", ""))) for n in proj_nodes)
check("project links resolved", resolved == len(regs), f"{resolved}/{len(regs)}")

# CHECK 14 : the BOD connection matrix (24/09/2026 review, corrected against the recording - see
# 03_Projects/Canvas/CONNECTION_CHANGELOG.md). Kept here independently of the builder: every project line on the
# canvas must be in this table, and every entry in the table must be drawn. Type letters: A INTEGRATION,
# B PLANNED, D DATA, K KNOWLEDGE, C AFFINITY.
MATRIX = """
mer-pocommit: C wfx-buyer-order-management, C wfx-purchase-order-management, D wfx-style-library, D wfx-production-planning
mer-costingagenticplatform: C wfx-budgeting-costing, D wfx-style-library, D wfx-bill-of-material, D gtas-costing, B gtas-ied, D gtas-consumption
mer-invoicedatarecheck: C wfx-budgeting-costing, C wfx-buyer-order-management, D wfx-finance
mer-marketintelligence: D data-dwh, D wfx-buyer-order-management, D wfx-style-library
ppj-glpi-helpdesk: C tp-glpi, K wfx-buyer-order-management, K wfx-budgeting-costing, K wfx-style-library, K wfx-purchase-order-management
scp-sourcingchatbot: K wfx-inventory-control, K wfx-raw-material-planning
pur-inventoryreport: D wfx-inventory-control, D tp-mmsx, D proj-pur-materialallocation, D proj-pur-gdiautomation
pur-materialallocation: A wfx-inventory-control, D wfx-raw-material-planning, D wfx-purchase-order-management, D wfx-buyer-order-management
pur-gdiautomation: B wfx-logistics-out-bound, D wfx-inventory-control, D wfx-purchase-order-management, D wfx-buyer-order-management
pur-adhocindentsouth: C wfx-purchase-order-management, C wfx-raw-material-planning, C wfx-inventory-control
pur-hmlabelprocessing: C wfx-purchase-order-management
fin-financemanagement: D wfx-finance, D wfx-buyer-order-management, D wfx-budgeting-costing, D wfx-inventory-control, D wfx-production-management, D data-dwh, D tp-power-bi, D gtas-bi-report, D gtas-financial-statements, D gtas-salary, D gtas-production
acc-grnsupplierinvoicebot: C wfx-logistics-in-bound, C wfx-finance, D wfx-purchase-order-management, D wfx-inventory-control
fin-invoicedownloader: A tp-vnpt-e-invoice
log-expenseinvoiceprocessing: C wfx-finance, C wfx-logistics-in-bound
wh-awbextraction: C wfx-logistics-in-bound
admin-expensemanagement: B tp-e-office, D tp-hris, C wfx-finance
td-technicalknowledgeplatform: D proj-mer-costingagenticplatform, D wfx-style-library, D wfx-bill-of-material, D gtas-ied, D gtas-consumption, D data-technical-knowledge
fab-fabricdatamart: D proj-td-technicalknowledgeplatform
cpd-visualsampledatamart: D proj-td-technicalknowledgeplatform
poc-discovery-patterngenerationpoc: C proj-td-technicalknowledgeplatform, C wfx-style-library, C proj-mer-costingagenticplatform
prod-hanginglineiot: C wfx-core, D wfx-production-planning, D wfx-production-management, D tp-iot-wiser-ina
wash-samplingmanagement: C wfx-sampling
wash-cowash: C wfx-production-management
hr-employeedataplatform: C tp-hris
poc-cand-cpd-in-house-pattern-generation: D poc-discovery-patterngenerationpoc
wfx-core: D data-dwh
"""
LETTER = {"A": "INTEGRATION", "B": "PLANNED", "D": "DATA", "K": "KNOWLEDGE", "C": "AFFINITY"}


def node_for(fragment):
    hits = [i for i in byid if i == fragment or i.startswith(fragment + "-") or i.startswith("proj-" + fragment + "-")
            or i == "proj-" + fragment]
    return hits[0] if len(hits) == 1 else None


expected, unresolved = set(), []
for row in MATRIX.strip().splitlines():
    src, rest = row.split(": ")
    for item in rest.split(", "):
        letter, dst = item.split(" ")
        f, t = node_for(src), node_for(dst)
        if not f or not t:
            unresolved.append(f"{src} -> {dst}")
            continue
        expected.add((f, t, LETTER[letter]))
drawn = {(e["fromNode"], e["toNode"], e["label"].split(" |")[0]) for e in edges}
check("every matrix entry resolves to a node", not unresolved, str(unresolved))
check("no connection outside the BOD matrix", not (drawn - expected), str(sorted(drawn - expected)))
check("every BOD matrix connection is drawn", not (expected - drawn), str(sorted(expected - drawn)))
shared = [i for i in byid if i.startswith(("proj-ai-perriplatform", "proj-ai-applicationhub"))]
check("PERRI and AI Hub are not attached to modules", not [e for e in edges if e["fromNode"] in shared or e["toNode"] in shared])
check("GDI's primary line is Logistics Out-bound, not Purchase Order Management",
      any(e["fromNode"].startswith("proj-pur-gdiautomation") and e["toNode"] == "wfx-logistics-out-bound"
          and "PRIMARY" in e["label"] for e in edges)
      and not any(e["fromNode"].startswith("proj-pur-gdiautomation") and e["toNode"] == "wfx-purchase-order-management"
                  and "PRIMARY" in e["label"] for e in edges))
check("Market Intelligence has DATA lines only",
      all(e["label"].startswith("DATA") for e in edges if e["fromNode"].startswith("proj-mer-marketintelligence")))

# Module coverage badges (BOD 24/09): badge on modules a project touches; none on QC / Production / unused modules.
def badge(nid):
    first = byid[nid]["text"].split("\n")[0]
    return next((c for c in first if c in BADGES), None)


BADGED = ["wfx-buyer-order-management", "wfx-budgeting-costing", "wfx-bill-of-material", "wfx-purchase-order-management",
          "wfx-style-library", "wfx-inventory-control", "wfx-raw-material-planning", "wfx-finance", "wfx-logistics-in-bound",
          "wfx-logistics-out-bound", "wfx-sampling", "gtas-costing", "gtas-ied", "gtas-consumption", "gtas-bi-report",
          "gtas-financial-statements", "gtas-salary", "gtas-production"]
UNBADGED = ["wfx-qc", "wfx-qa", "wfx-brandplm", "wfx-production-planning", "wfx-production-management",
            "gtas-transportation", "gtas-compliance"]
check("coverage badge on every module with a project relationship", all(badge(i) for i in BADGED),
      str([i for i in BADGED if not badge(i)]))
check("no badge on QC / QA / BrandPLM / Production modules / GTAS Transportation", not any(badge(i) for i in UNBADGED),
      str([i for i in UNBADGED if badge(i)]))
check("GTAS Transportation has no line", not [e for e in edges if "gtas-transportation" in (e["fromNode"], e["toNode"])])

fail = [r for r in res if not r[1]]
for name, ok, d in res:
    print(("PASS  " if ok else "FAIL  ") + name + (f"   [{d}]" if d and not ok else ""))
print(f"\nnodes={len(nodes)} edges={len(edges)} project_nodes={len(proj_nodes)} links_resolved={resolved} "
      f"kinds={dict(Counter(e['label'].split(' |')[0] for e in edges))} "
      f"badges={sum(1 for n in nodes if n['id'].startswith(('wfx-', 'gtas-')) and badge(n['id']))}")
print("VALIDATION:", "PASS" if not fail else f"FAIL ({len(fail)})")
