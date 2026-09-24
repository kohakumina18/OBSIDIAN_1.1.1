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
check("every edge has a category-prefixed label",
      all(re.match(r"^(INTEGRATION|PLANNED|AFFINITY|DATA) \| ", e.get("label", "")) for e in edges))
check("ASCII only (vault canvas-label rule)", raw.isascii(), "" if raw.isascii() else "non-ascii present")

# CHECK 1 / 2 : the 35 baseline initiatives + canonical codes
snap = json.loads((V / "03_Projects/_Registry/Portfolio_Snapshots/PPJ_PORTFOLIO_SNAPSHOT_20260918.json").read_text("utf-8-sig"))
regs = [p["code"] for p in snap["projects"] if not p.get("candidate")]
proj_nodes = [n for n in nodes if n["id"].startswith("proj-")]
check("one project node per registered record", len(proj_nodes) == len(regs), f"{len(proj_nodes)} nodes / {len(regs)} records")
check("file nodes point at real files", all((V / n["file"]).exists() for n in nodes if n["type"] == "file"))
check("LF line endings only (same bytes on every OS)", b"\r" not in CANVAS.read_bytes())
heads = Counter()
for n in proj_nodes:
    m = re.search(r"\|([^\]]+)\]\]", n["text"].splitlines()[0]) or re.search(r"## (.+)", n["text"].splitlines()[0])
    heads[m.group(1).strip()] += 1
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

fail = [r for r in res if not r[1]]
for name, ok, d in res:
    print(("PASS  " if ok else "FAIL  ") + name + (f"   [{d}]" if d and not ok else ""))
print(f"\nnodes={len(nodes)} edges={len(edges)} project_nodes={len(proj_nodes)} links_resolved={resolved} "
      f"kinds={dict(Counter(e['label'].split(' |')[0] for e in edges))}")
print("VALIDATION:", "PASS" if not fail else f"FAIL ({len(fail)})")
