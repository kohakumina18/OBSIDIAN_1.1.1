#!/usr/bin/env python3
"""Build the governed PPJ master project-process Canvas and companion note."""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import shutil
from collections import defaultdict
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SNAPSHOT = ROOT / "03_Projects/_Registry/Portfolio_Snapshots/PPJ_PORTFOLIO_SNAPSHOT_20260918.json"
CANVAS = ROOT / "03_Projects/Canvas/PPJ_Project_Process_Map.canvas"
NOTE = ROOT / "02_BA_Knowledge/Enterprise_Architecture/PPJ_Project_Process_Map.md"
REPORT = ROOT / "10_Reports/PPJ_PROJECT_PROCESS_MAP_BUILD_20260919.md"
BACKUP_ROOT = ROOT / "99_Attachments/Audit/PPJ_Project_Process_Map_Backup"


DOMAIN_ORDER = [
    "Merchandising",
    "Fabric / Textiles Technique",
    "Sourcing / Purchasing",
    "Warehouse",
    "Production + Wash",
    "QC / TQM",
    "Logistics / EXIM",
    "Finance / Accounting",
    "Administration",
    "HR",
    "Internal Chatbot & AI Platforms",
    "External Collaboration",
]


# Canonical process meaning. Each tuple is: end-to-end process, human control, final output.
PROCESS = {
    "FIN_FinanceManagement_v1.2.0": (
        "WFX / DWH / Databricks -> source validation -> finance rules and Q&A -> OC exceptions + factory performance -> Accounting review -> Power BI / management decision",
        "Accounting approves sources, thresholds, exception severity and reconciled results.",
        "Trusted finance control, exception ownership and management insight.",
    ),
    "MER_CostingAgenticPlatform_v1.1.0": (
        "Garment requirement + technical history -> Sew/Wash/BOM/Consumption/Similar-Style agents -> Costing Orchestrator -> cost and quotation package -> expert review -> MER quotation decision",
        "IED, Wash, Technical and MER experts approve AI proposals before business use.",
        "Reviewed costing / quotation package with confidence and traceability.",
    ),
    "PUR_GDIAutomation_v1.0.0": (
        "Purchasing input + WFX master data -> business validation -> authenticated WFX API lookup -> create/update GDI -> WFX confirmation -> audit",
        "Purchasing confirms controlled submission; errors and duplicates are routed for review.",
        "Auditable GDI transaction and dispatch status in WFX.",
    ),
    "TD_TechnicalKnowledgePlatform_v2.1.0": (
        "Technical sources + documents -> ETL -> standardize keys/versions -> canonical technical model -> sync -> search, costing, pattern, wash and AI applications",
        "Technical users validate completeness, latest-approved version, permissions and reconciliation.",
        "Governed technical knowledge backbone for downstream applications.",
    ),
    "ADMIN_ExpenseManagement_v1.1.0": (
        "Travel request + travelers/plans -> approval -> trip and booking -> advance -> expense submission -> settlement -> close",
        "Manager/Admin/Finance approvals control request, advance, expense and settlement stages.",
        "Traceable end-to-end business-travel and expense record.",
    ),
    "LOG_ExpenseInvoiceProcessing_v1.2.0": (
        "Expense invoice + supplier/region data -> intake/OCR -> mapping -> validation -> tax and regional rules -> exception review -> processing/posting -> audit",
        "Logistics/EXIM users resolve exceptions and approve region-specific treatment.",
        "Validated expense-invoice transaction with regional compliance evidence.",
    ),
    "PUR_MaterialAllocation_v1.1.0": (
        "OC material demand + available stock -> eligibility check -> allocation proposal -> quantity validation -> user confirmation -> WFX transaction -> rollback/audit if required",
        "Purchasing validates OC eligibility, partial allocation and exception handling before submit.",
        "Controlled allocation of surplus material across eligible OCs.",
    ),
    "MER_MarketIntelligence_v1.1.0": (
        "Market + customer + competitor + product signals -> collect/clean -> analyze trends and opportunities -> intelligence summary -> MER review -> commercial decision",
        "Merchandising validates signal quality and distinguishes evidence from assumptions.",
        "Actionable market/customer intelligence for product and commercial decisions.",
    ),
    "MER_InvoiceDataRecheck_v1.1.0": (
        "Costing + commercial cost + invoice data + customer rules -> cross-check -> exception detection -> MER review -> correction / acceptance -> audit output",
        "MER validates customer-specific rules and approves every material exception.",
        "Reusable invoice/cost recheck result beginning with Chico's rules.",
    ),
    "WASH_SamplingManagement_v1.1.0": (
        "Sample request -> planning -> recipe/process preparation -> sample execution -> result capture -> evaluation -> approval -> history and attachments",
        "R&D Wash users review results and approve the sampling outcome.",
        "Group-wide controlled Wash sampling workflow and searchable history.",
    ),
    "PROD_HangingLineIoT_v1.0.0": (
        "Hanging-line machines/sensors -> WISER / INA -> collect and normalize -> production KPI calculation -> dashboard -> line/factory review -> corrective action",
        "Production owners validate source reconciliation and KPI definitions.",
        "Near-real-time line visibility for output, efficiency and exceptions.",
    ),
    "WH_AWBExtraction_v1.1.0": (
        "AWB image + DHL email -> OCR/email parsing -> canonical field mapping -> confidence and validation rules -> human review -> canonical AWB record",
        "Warehouse reviews low-confidence fields, tables, weight and units.",
        "Validated structured AWB data across image and email channels.",
    ),
    "HR_EmployeeDataPlatform_v1.1.0": (
        "Employee/applicant data -> collect or extract -> required-field validation -> standardize/match/deduplicate -> HR review -> Employee Master or prefilled application -> downstream sync",
        "HR controls identity conflicts, corrections, consent, permissions and final confirmation.",
        "Trusted Group Employee Master plus controlled applicant intake.",
    ),
    "SCP_SourcingChatbot_v2.3.0": (
        "Supplier/material/sample data -> ingest and normalize -> index/RAG -> search and comparison -> grounded answer -> user feedback and quality monitoring",
        "Sourcing validates source data, answer traceability and production quality.",
        "One searchable sourcing intelligence and chatbot application.",
    ),
    "FIN_InvoiceDownloader_v1.2.0": (
        "Supplier/e-invoice portals -> authenticate -> download XML/PDF -> validate and merge -> save with structured metadata -> expose to Accounting/EXIM workflows",
        "Operations reviews missing, duplicate, failed and credential-related cases.",
        "Reliable invoice document/data acquisition with audit evidence.",
    ),
    "PUR_InventoryReport_v2.1.0": (
        "WFX inventory and purchasing data -> extract -> reconcile totals -> transform -> tables/filters/reports -> Purchasing review -> enhancement feedback",
        "Purchasing validates totals, refresh timing and operational interpretation.",
        "Operational inventory visibility for purchasing decisions.",
    ),
    "AI_PERRIPlatform_v3.2.0": (
        "User question/request -> intent and permission -> agent/tool selection -> governed data/API call -> controlled answer or action -> audit and feedback",
        "Human approval is mandatory for sensitive or write/action operations.",
        "Permissioned conversational orchestration across PPJ tools and knowledge.",
    ),
    "AI_ApplicationHub_v2.1.0": (
        "User access -> AI application catalogue -> discover/search -> permission check -> launch application -> usage and support feedback",
        "Application owners govern catalogue entries, access and support ownership.",
        "Single internal access layer for approved AI applications.",
    ),
    "FAB_FabricDatamart_v2.2.0": (
        "Fabric/hanger/material data -> Directus import/admin -> validation and correction -> fabric master + QR information/design -> attach/use on hanger -> search/support",
        "FD users approve data corrections, permissions and QR usage.",
        "Governed Fabric + Hanger + QR reference datamart.",
    ),
    "CPD_VisualSampleDatamart_v1.1.0": (
        "3D samples + images + visual assets -> ingest -> tag/standardize metadata -> visual library -> image search -> user selection -> asset maintenance",
        "CPD/3D Design validates asset quality, metadata and search relevance.",
        "Searchable 3D/visual sample library; separate from FD Fabric Datamart.",
    ),
    "ACC_GRNSupplierInvoiceBot_v2.3.0": (
        "Supplier invoice + GRN/system data -> validation -> matching and business rules -> transaction preparation -> automated data entry -> target system -> exception handling -> audit",
        "Accounting reviews exceptions and controls production support.",
        "Auditable supplier-invoice/GRN processing and system entry.",
    ),
    "PUR_AdhocIndentSouth_v1.0.0": (
        "Indent input -> field and business validation -> prepare transaction -> submit to WFX -> confirmation/status -> exception handling -> operational support",
        "Purchasing reviews invalid or changed inputs and WFX compatibility exceptions.",
        "Stable South-region indent automation.",
    ),
    "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0": (
        "User IT/ERP issue -> intent -> GLPI/helpdesk knowledge retrieval -> troubleshooting answer -> ticket/escalation when unresolved -> knowledge feedback",
        "IT Helpdesk validates guidance and owns escalation and knowledge maintenance.",
        "Faster IT support with controlled handoff to human service.",
    ),
    "QC_DefectDetection_v1.0.0": (
        "Inspection image + labeled dataset -> AI detection -> defect classification + confidence -> QC confirmation -> accept/rework decision -> quality metrics",
        "QC/TQM owns labels, confirms results and approves operational decisions.",
        "Measured defect-detection capability when dataset/resources are ready.",
    ),
    "QC_ThreadTraceability_v1.0.0": (
        "RFID/thread identity -> scan/read -> link to production event -> build traceability chain -> connect quality/product record -> QC/customer business decision",
        "QC, MER and factory users validate feasibility and customer value before PoC.",
        "Thread-to-product traceability evidence if the business case is approved.",
    ),
    "PPJxStratova.AI": (
        "Historical vendor/use-case proposal -> technical and commercial evaluation -> PoC discussion -> management decision -> close -> retain lessons",
        "Leadership controlled the historical go/no-go decision; current PoC stays in Discovery Register.",
        "Closed historical evaluation record without reusing it for the new discovery.",
    ),
    "PPJxNUNOX.ScanTrial": (
        "Fabric/garment sample -> scan/capture -> image-quality and metadata check -> digital-library ingest -> user evaluation -> partnership/implementation decision",
        "Business and leadership confirm trial evidence before any commitment.",
        "Evidence for fabric/garment digitization and digital-library feasibility.",
    ),
    "EXT_AcademicCollaboration_v1.1.0": (
        "PPJ business problem -> academic problem framing + dataset -> student/research prototype -> benchmark -> PPJ expert evaluation -> handoff or stop decision",
        "PPJ owners approve scope, data boundaries, benchmark and production boundary.",
        "Evaluated academic prototype and talent/research collaboration outcome.",
    ),
    "WASH_COWASH_v2.0.0": (
        "Wash operations + machine/output data -> capture -> standardize -> KPI/delay/rework calculation -> dashboard -> owner review -> operational action",
        "Wash/Production owners must confirm source, KPI, access and technical direction.",
        "Operational Wash visibility if the paused scope is reactivated.",
    ),
    "PUR_HMLabelProcessing_v1.0.0": (
        "Customer/label input -> extract customer rules -> transform and validate -> Label-O processing -> exception handling -> business review",
        "Purchasing decides whether a scalable rules model justifies reactivation.",
        "Controlled label-processing result; currently On Hold for scalability/value.",
    ),
    "ACC_InventoryReport_v1.0.0": (
        "Inventory transactions -> extract -> quantity/value/period reconciliation -> Accounting report -> Accounting review -> close",
        "Accounting validated the historical report and closure.",
        "Closed Accounting inventory-control report history.",
    ),
    "MER_POCommit_v1.1.0": (
        "Customer order -> scenario validation -> MER PO preparation -> manual exception handling -> WFX PO record -> completion/close",
        "MER reviewed scenarios not covered by automation.",
        "Closed PO Commit history covering the validated customer scenarios.",
    ),
    "EXIM.ExpenseInvoices.Automation.v1.1": (
        "Expense invoice -> extract/map -> validate -> automated system entry -> exception review -> audit -> historical close",
        "EXIM/Accounting reviewed exceptions; successor scope moved to LOG_ExpenseInvoiceProcessing_v1.2.0.",
        "Closed predecessor history retained separately from the current project.",
    ),
    "AI.Automation.Workshop.202606": (
        "Business needs + participants -> workshop planning -> demonstrations and working sessions -> feedback/ideas -> action capture -> close",
        "Facilitators and business participants validated takeaways.",
        "Closed workshop event and captured improvement opportunities.",
    ),
    "AI.Automation.Workshop.Analysis.202606": (
        "Workshop notes + feedback -> consolidate -> classify themes/opportunities -> analyze value/feasibility -> recommendations -> close",
        "AI/Automation team reviewed and prioritized conclusions.",
        "Closed workshop analysis and recommendation record.",
    ),
    "VITAS.Sharing.202606": (
        "Industry updates/cases -> prepare sharing content -> presentation/discussion -> networking and feedback -> lessons captured -> close",
        "Participants validated relevance and follow-up items.",
        "Closed VITAS sharing event with retained knowledge.",
    ),
}


def args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Build PPJ project process map")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Plan only; default")
    mode.add_argument("--apply", action="store_true", help="Backup and write changes")
    return parser.parse_args()


def stable_id(prefix: str, value: str) -> str:
    return f"{prefix}-{hashlib.sha1(value.encode('utf-8')).hexdigest()[:14]}"


def node(node_id: str, kind: str, x: int, y: int, width: int, height: int, **extra: object) -> dict:
    value = {"id": node_id, "type": kind, "x": x, "y": y, "width": width, "height": height}
    value.update(extra)
    return value


def link_target(item: dict) -> str:
    root_file = str(item.get("root_file", "")).removesuffix(".md")
    return f"03_Projects/{root_file}"


def workspace_links(item: dict) -> str:
    workspace = item.get("workspace")
    if not workspace:
        return "[[03_Projects/{0}|Project Note]]".format(str(item.get("root_file", "")).removesuffix(".md"))
    links = []
    home = ROOT / "03_Projects" / str(workspace) / "00_Project_Home.md"
    to_be = ROOT / "03_Projects" / str(workspace) / "03_Process" / "TO_BE_Process.md"
    if home.exists():
        links.append(f"[[03_Projects/{workspace}/00_Project_Home|Home]]")
    if to_be.exists():
        links.append(f"[[03_Projects/{workspace}/03_Process/TO_BE_Process|TO-BE]]")
    return " | ".join(links) if links else f"[[{link_target(item)}|Project Note]]"


def card_color(item: dict) -> str:
    if item.get("delivery_stage") == "CLOSED":
        return "2"
    if item.get("delivery_stream") == "EXTERNAL DEVELOPMENT":
        return "1"
    if item.get("delivery_stage") == "GO-LIVE / PRODUCTION / SUPPORT":
        return "5"
    if item.get("status") == "On Hold":
        return "2"
    return "3"


def build_canvas(projects: list[dict]) -> str:
    grouped: dict[str, list[dict]] = defaultdict(list)
    for item in projects:
        grouped[str(item["domain"])].append(item)
    nodes = [
        node(
            "project-process-title",
            "text",
            0,
            -690,
            11000,
            230,
            text=(
                "# PPJ PROJECT PROCESS MAP\n\n"
                "One registered project = one process card. Read each card from business/data input through processing, human control and final output.\n\n"
                "Source: [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT|Current Snapshot]] | "
                "Architecture: [[02_BA_Knowledge/Enterprise_Architecture/PPJ_Enterprise_Application_AI_Automation_Ecosystem|Enterprise Ecosystem]]"
            ),
            color="5",
        ),
        node(
            "project-process-reading-guide",
            "text",
            0,
            -420,
            11000,
            300,
            text=(
                "## HOW TO READ\n\n"
                "Trigger / Input -> Data preparation -> Rule / AI / Automation processing -> Validation -> Human decision -> Transaction / Output -> Monitoring / Support\n\n"
                "Card colors: active delivery = yellow | production/support = cyan | external collaboration = red | closed/on-hold = orange. "
                "Delivery Stage is current state; it is not a process step. Candidate/discovery items are excluded until registration is approved."
            ),
        ),
    ]
    edges: list[dict] = []
    group_width, group_height = 3600, 2300
    card_width, card_height = 1700, 450
    x_gap, y_gap = 60, 40
    domain_colors = ["3", "4", "6", "1", "5", "2"]
    for domain_index, domain in enumerate(DOMAIN_ORDER):
        col, row = domain_index % 3, domain_index // 3
        gx, gy = col * 3780, row * 2440
        group_id = stable_id("domain", domain)
        items = sorted(grouped.get(domain, []), key=lambda value: (value.get("delivery_stage") == "CLOSED", str(value["code"])))
        nodes.append(node(group_id, "group", gx, gy, group_width, group_height, label=domain.upper(), color=domain_colors[domain_index % len(domain_colors)]))
        nodes.append(
            node(
                stable_id("domain-summary", domain),
                "text",
                gx + 70,
                gy + 50,
                group_width - 140,
                90,
                text=f"## {domain.upper()} | {len(items)} REGISTERED PROJECTS",
            )
        )
        for index, item in enumerate(items):
            flow, control, output = PROCESS[item["code"]]
            cx = gx + 70 + (index % 2) * (card_width + x_gap)
            cy = gy + 170 + (index // 2) * (card_height + y_gap)
            text = (
                f"<!-- PPJ_PROJECT_PROCESS:{item['code']} -->\n\n"
                f"## [[{link_target(item)}|{item['code']}]]\n\n"
                f"Stage: {item.get('delivery_stage')} | Status: {item.get('status')}\n\n"
                f"PROCESS\n{flow}\n\n"
                f"HUMAN CONTROL\n{control}\n\n"
                f"OUTPUT\n{output}\n\n"
                f"{workspace_links(item)}"
            )
            nodes.append(node(stable_id("process", item["code"]), "text", cx, cy, card_width, card_height, text=text, color=card_color(item)))
    return json.dumps({"nodes": nodes, "edges": edges}, ensure_ascii=False, separators=(",", ":")) + "\n"


def build_note(projects: list[dict]) -> str:
    grouped: dict[str, list[dict]] = defaultdict(list)
    for item in projects:
        grouped[str(item["domain"])].append(item)
    lines = [
        "---",
        "type: portfolio_project_process_map",
        "source_event: PPJ-PORTFOLIO-SNAPSHOT-20260918",
        f"last_generated: {dt.date.today().isoformat()}",
        "status: governed_view",
        "---",
        "",
        "# PPJ Project Process Map",
        "",
        "This note and its Canvas explain the end-to-end process of every registered PPJ portfolio project.",
        "",
        "Canvas: [[03_Projects/Canvas/PPJ_Project_Process_Map]]",
        "",
        "Reading model:",
        "",
        "```text",
        "Trigger / Input -> Data preparation -> Rule / AI / Automation processing -> Validation -> Human decision -> Transaction / Output -> Monitoring / Support",
        "```",
        "",
        "Candidate and discovery items are excluded until canonical registration is approved.",
        "",
    ]
    for domain in DOMAIN_ORDER:
        items = sorted(grouped.get(domain, []), key=lambda value: (value.get("delivery_stage") == "CLOSED", str(value["code"])))
        lines.extend([f"## {domain}", ""])
        for item in items:
            flow, control, output = PROCESS[item["code"]]
            lines.extend(
                [
                    f"### [[{link_target(item)}|{item['code']}]]",
                    "",
                    f"- Delivery: `{item.get('delivery_stream')}` / `{item.get('delivery_stage')}`",
                    f"- Status: `{item.get('status')}`",
                    f"- Process: {flow}",
                    f"- Human control: {control}",
                    f"- Output: {output}",
                    f"- Workspace: {workspace_links(item)}",
                    "",
                ]
            )
    lines.extend(
        [
            "Related Concepts",
            "[[Business Process Design]]",
            "[[System Thinking]]",
            "[[Data Governance]]",
            "[[Human in the Loop]]",
            "",
            "Methods",
            "[[Impact Analysis]]",
            "[[Data Mapping]]",
            "[[Requirement Elicitation]]",
            "",
            "Deliverables",
            "[[Process Documentation]]",
            "[[Decision_Driven_BRD]]",
            "[[Automation Flow]]",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> int:
    options = args()
    snapshot = json.loads(SNAPSHOT.read_text(encoding="utf-8-sig"))
    projects = [item for item in snapshot["projects"] if not item.get("candidate")]
    codes = {str(item["code"]) for item in projects}
    if codes != set(PROCESS):
        missing = sorted(codes - set(PROCESS))
        extra = sorted(set(PROCESS) - codes)
        raise SystemExit(f"Process map mismatch. Missing={missing}; Extra={extra}")
    unknown_domains = sorted({str(item["domain"]) for item in projects} - set(DOMAIN_ORDER))
    if unknown_domains:
        raise SystemExit(f"Domain order is missing: {unknown_domains}")

    desired = {CANVAS: build_canvas(projects), NOTE: build_note(projects)}
    changed = [path for path, content in desired.items() if not path.exists() or path.read_text(encoding="utf-8-sig") != content]
    print("PPJ Project Process Map")
    print("Mode:", "Apply" if options.apply else "DryRun")
    print("Registered projects:", len(projects))
    print("Domains:", len(DOMAIN_ORDER))
    print("Files to create/update:", len(changed))
    for path in changed:
        print(" -", path.relative_to(ROOT))
    if not options.apply:
        return 0

    stamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    backup = BACKUP_ROOT / stamp
    for path in changed:
        if path.exists():
            target = backup / path.relative_to(ROOT)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, target)
    for path, content in desired.items():
        if path not in changed:
            continue
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8", newline="\n")

    report = (
        "---\n"
        "type: process_map_build_report\n"
        f"date: {dt.date.today().isoformat()}\n"
        "status: applied\n"
        "---\n\n"
        "# PPJ Project Process Map Build\n\n"
        f"- Registered project cards: {len(projects)}\n"
        f"- Primary-domain groups: {len(DOMAIN_ORDER)}\n"
        f"- Canvas: `{CANVAS.relative_to(ROOT).as_posix()}`\n"
        f"- Companion note: `{NOTE.relative_to(ROOT).as_posix()}`\n"
        f"- Backup root: `{backup.relative_to(ROOT).as_posix()}`\n"
        "- Candidate/discovery records excluded from project cards.\n"
        "- No registry, project state, task or delivery-stage data changed.\n"
    )
    REPORT.parent.mkdir(parents=True, exist_ok=True)
    REPORT.write_text(report, encoding="utf-8", newline="\n")
    print("Backup root:", backup.relative_to(ROOT))
    print("Report:", REPORT.relative_to(ROOT))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
