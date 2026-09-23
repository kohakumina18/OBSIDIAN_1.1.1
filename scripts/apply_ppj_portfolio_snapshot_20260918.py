#!/usr/bin/env python3
"""Idempotent PPJ portfolio synchronization for PPJ-PORTFOLIO-SNAPSHOT-20260918.

Derived from apply_ppj_portfolio_snapshot_20260824.py for the 18/09/2026 naming and
portfolio baseline (DEPARTMENT_APPLICATION_vMAJOR.MINOR.PATCH).


The script is intentionally self-contained.  It defaults to dry-run, preserves
physical project filenames, writes only managed sections in user-authored notes,
backs up every changed file, and validates every generated Canvas before apply.
"""

from __future__ import annotations

import argparse
import copy
import datetime as dt
import hashlib
import json
import re
import shutil
import sys
from dataclasses import dataclass, field
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PROJECTS = ROOT / "03_Projects"
REGISTRY = PROJECTS / "_Registry"
MEMORY = REGISTRY / "Project_Memory"
CANVAS = PROJECTS / "Canvas"
EXEC_BOARD = CANVAS / "PPJ_Executive_Board_v2.canvas"
REPORTS = ROOT / "10_Reports"
EVENT = "PPJ-PORTFOLIO-SNAPSHOT-20260918"
NEW_STYLE = re.compile(r'[A-Z]+_[A-Za-z0-9]+_v\d+\.\d+\.\d+')  # DEPARTMENT_APPLICATION_vMAJOR.MINOR.PATCH
VERIFIED = "2026-09-18"
# The managed-block marker names keep their original date so this run replaces the
# 2026-08-24 blocks in place instead of stacking a second current-state block.
START = "<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->"
END = "<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->"


@dataclass
class Project:
    code: str
    domain: str
    lifecycle: str
    gate: str
    priority: str
    outcome: str
    latest: str
    next_actions: list[str]
    risks: list[str] = field(default_factory=list)
    decisions: list[str] = field(default_factory=list)
    dependencies: list[str] = field(default_factory=list)
    capability: str = ""
    progress: str = "TBD"
    confidence: str = "Strong"
    owner: str = "Needs Confirmation"
    root_file: str | None = None
    memory_file: str | None = None
    workspace: str | None = None
    lane: str = "ACTIVE DELIVERY / UAT"
    candidate: bool = False
    registration: str = "Registered"
    delivery_stage: str = "ANALYSIS"
    status: str = "Active"
    stage_entered_date: str = "Needs Confirmation"
    delivery_stream: str = "INTERNAL DEVELOPMENT"
    legacy: list[str] = field(default_factory=list)
    link_target: str = ""


def p(code, domain, lifecycle, gate, priority, outcome, latest, next_actions,
      *, risks=(), decisions=(), dependencies=(), capability="", progress="TBD",
      owner="Needs Confirmation", root=None, memory=None, workspace=None,
      lane="ACTIVE DELIVERY / UAT", candidate=False, registration="Registered",
      confidence="Strong", legacy=(), link_target=""):
    item = Project(code, domain, lifecycle, gate, priority, outcome, latest,
                   list(next_actions), list(risks), list(decisions), list(dependencies),
                   capability, progress, confidence, owner, root, memory, workspace,
                   lane, candidate, registration)
    item.legacy = list(legacy)
    item.link_target = link_target
    return item


PORTFOLIO = [
    # ---- Strategic ---------------------------------------------------------------
    p("FIN_FinanceManagement_v1.2.0", "Finance / Accounting", "Strategic Active",
      "WS2 OC / Cost Control and WS3 Factory Performance", "P1",
      "Centralized Finance Control Platform for completeness, correct OC/period, actual versus plan, missing cost, profitability, drill-down, factory performance and exception ownership.",
      "No longer merely an AI chatbot. WS1 Finance Q&A (Balance Sheet, P&L, management Q&A) is the foundation; WS2 OC / Cost Control remains the main focus (missing cost, incorrect period, BOM/material, overhead, subcontracting, abnormal margin, duplicate/missing transactions, actual vs plan, invoice/posting completeness); WS3 Factory Performance has now started (Group -> Company -> Region -> Factory -> Production -> Labor -> Cost -> Efficiency). Databricks / DWH access and validated sources remain the key dependency.",
      ["Finalize the WS2 Rule Catalogue and thresholds", "Obtain read-only Databricks access and confirm catalog/schema/table lineage", "Select a Golden OC and run the rules", "Reconcile results with Accounting and finalize exception severity", "Advance WS3 factory-performance source discovery and dimensions (headcount, labor cost, overtime, output, capacity, budget vs actual)"],
      risks=["Databricks / DWH access", "Source ownership and lineage", "Rule and threshold approval", "Incorrect OC linkage"],
      decisions=["Approve WS2 thresholds and exception severity", "Confirm governed sources of truth"],
      dependencies=["WFX / Databricks / DWH -> Finance source control -> Rule Engine -> OC control -> Factory performance -> Power BI / AI"],
      capability="WS1 Finance Q&A (foundation); WS2 OC & Cost Control (main focus); WS3 Factory Performance (started).",
      legacy=["FIN.AI.FINANCE.MANAGEMENT.v1.2", "FIN.AI.FINANCE.MANAGEMENT.v1.1"],
      owner="Accounting", root="FIN.AI.FINANCE.MANAGEMENT.v1.1.md", memory="FIN.AI.FINANCE.MANAGEMENT.v1.1.memory.md", workspace="FIN.AI.FINANCE.MANAGEMENT.v1.1", lane="STRATEGIC ACTIVE"),
    p("MER_CostingAgenticPlatform_v1.1.0", "Merchandising", "Active Development",
      "Sew Agent fixes and Wash Agent development", "P2",
      "Generate a Costing / Quotation Package for Merchandising review and customer quotation through one platform.",
      "One platform, not dozens of projects: SewAgent, WashAgent, BOMAgent, ConsumptionAgent, SimilarStyleAgent and CostingOrchestrator. Current focus: fixing Sew Agent issues, SAM accuracy, machine mapping, operation normalization, historical similar-style retrieval and GTAS/IED integration. Wash (especially Denim): the AI proposes, the Wash expert approves.",
      ["Improve SAM validation and benchmark with a Sew expert", "Confirm the GTAS/IED integration contract", "Connect Technical Data", "Collect Wash cases", "Build the Wash similarity engine with mandatory expert review"],
      risks=["SAM accuracy and expert acceptance", "GTAS/IED integration contract", "Technical Data dependency"],
      dependencies=["TD_TechnicalKnowledgePlatform_v2.1.0 -> Pattern/BOM/Consumption -> Sew/Wash/Costing AI"],
      capability="Garment Requirement -> Operation Breakdown -> Operation Normalization -> Machine Mapping -> SAM -> Cost -> Confidence -> IED / Expert Review; Wash: Requirement -> Attribute Extraction -> Recipe Search -> Process Recommendation -> Cost/Risk -> Wash Expert Review.",
      legacy=["COSTING.AGENTIC.PLATFORM.v1.1", "PPJ.COSTING.AGENT.PLATFORM.v1.1"],
      root="PPJ.COSTING.AGENT.PLATFORM.v1.1.md", memory="COSTING.AGENTIC.PLATFORM.v1.1.memory.md", workspace="PPJ.COSTING.AGENT.PLATFORM.v1.1", lane="STRATEGIC ACTIVE"),
    p("PUR_GDIAutomation_v1.0.0", "Sourcing / Purchasing", "Active Development / WFX API Integration",
      "WFX API integration and GDI data-entry workflow", "P3",
      "Give Purchasing end-to-end package-dispatch tracking through GDI and provide API capability for automated/assisted GDI data entry while preserving WFX transaction control, validation, confirmation and audit.",
      "Increasingly API-oriented rather than UI/RPA-oriented: Purchasing User -> GDI Application -> Validation -> WFX API -> GDI Transaction -> WFX. Two objectives stay separate: the business objective (GDI functionality to track package dispatch end-to-end) and the automation objective (WFX API capability for automated/assisted GDI entry). Critical path: WFX API specification -> Authentication -> GET/master-data APIs -> POST GDI -> Error handling -> UAT -> Production.",
      ["Obtain WFX API authentication and operation documentation", "Confirm create/update/lookup/draft/submit/cancel/status schemas", "Define validation, idempotency, duplicate, retry and timeout controls", "Design audit logging and transaction confirmation"],
      risks=["WFX API ownership and sandbox", "Authentication and rate limits", "Transaction integrity"],
      dependencies=["WFX API -> Business validation -> Controlled GDI transaction -> Confirmation / Audit"],
      capability="PPJ GDI application using supported WFX APIs; never direct-write Databricks as a substitute for WFX transactions.",
      legacy=["PUR.GDI.Automation.v1.0", "PPJ.PUR.GDI.API.AUTOMATION"],
      root="PUR.GDI Automation.md", memory="PUR.GDI.Automation.v1.0.memory.md", workspace="PUR.GDI Automation", lane="STRATEGIC ACTIVE"),
    p("TD_TechnicalKnowledgePlatform_v2.1.0", "Fabric / Textiles Technique", "Sync Validation & Stabilization",
      "Sync validation and canonical technical model", "P5",
      "Technical Data Backbone for Pattern, BOM, Consumption, Construction, documents and historical records; upstream source for Costing, Sew Agent, BOM, Consumption, Pattern, Technical Search and Similar Style.",
      "Past simple ETL development: Source Systems -> ETL -> Technical Knowledge Model -> Sync -> Applications / AI. Initial sync has been demonstrated. Current priority: canonical technical model, source of truth, sync rules, ownership, version control, duplicate management, UAT, permission and traceability.",
      ["Implement incremental sync, error handling and retry", "Add duplicate, missing-key and reconciliation checks", "Govern versions and latest/approved-record logic", "Finalize permissions and prepare Technical UAT"],
      risks=["Sync reliability", "Version governance", "Missing keys and duplicate records", "Technical UAT acceptance"],
      dependencies=["Technical sources -> ETL -> Technical Data Layer -> Sync -> Platform -> Costing / Pattern / Wash / Search"],
      capability="Source -> ETL -> Technical Knowledge Model -> Sync -> Applications / AI.",
      legacy=["TD.TechnicalKnowledge.Platform.v2.1", "TD.TechnicalPlatform_v2.1"],
      root="TD.TechnicalPlatform_v2.1.md", memory="TD.TechnicalKnowledge.Platform.v2.1.memory.md", workspace="TD.TechnicalPlatform_v2.1", lane="STRATEGIC ACTIVE"),
    p("ADMIN_ExpenseManagement_v1.1.0", "Administration", "Active / Requirement Refinement / UAT Preparation",
      "Multi-traveler request model, end-to-end lifecycle and UAT preparation", "P6",
      "Standardize Administration business-travel and expense-management workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement.",
      "Evolved well beyond the initial Travel Request application. Modules: TravelRequest, TravelApproval, TripManagement, Advance, Expense, Settlement. Latest major change: one request can contain multiple travelers, each with a traveler-specific travel plan (origin, destination, stops, dates, flight, hotel/shared room, per diem, customer visit). Management concern: prevent scope creep; the core stays Request -> Approval -> Trip -> Expense -> Settlement.",
      ["Validate the booking workflow and status model", "Model multi-traveler requests with per-traveler travel plans", "Finalize approval matrix, advance, expense submission and settlement", "Define vendor catalogue and expense categories", "Prepare UAT"],
      risks=["Scope creep beyond Request -> Approval -> Trip -> Expense -> Settlement", "Approval/status rules need confirmation", "Multi-traveler data model complexity"],
      capability="TravelRequest / TravelApproval / TripManagement / Advance / Expense / Settlement with multi-traveler requests.",
      progress="~90% (2026-09-15 meeting recap)", owner="Administration",
      legacy=["Admin Expense Management.v1.1", "Business Travel / Admin Expense Management"],
      root="ADMIN_ExpenseManagement_v1.1.0.md", memory="ADMIN_ExpenseManagement_v1.1.0.memory.md", workspace="ADMIN_ExpenseManagement_v1.1.0",
      lane="STRATEGIC ACTIVE"),
    # ---- Active delivery / UAT ------------------------------------------------------
    p("LOG_ExpenseInvoiceProcessing_v1.2.0", "Logistics / EXIM", "Regional Rollout / UAT",
      "Regional rollout, tax rules and invoice validation", "P4",
      "Process Logistics / Import-Export expense invoices with regional and tax rules, invoice validation, user workflow and exception management.",
      "Current Logistics / Import-Export expense-invoice project (Active Regional Rollout / UAT). Focus: regional rollout, tax rules, invoice validation, user workflow and exception management. Replaces the ambiguity created by older EXIM expense-invoice names. Prior guidance (departments/factories except Export; EXIM-first historical) is preserved in project history.",
      ["Close remaining defects and retest", "Confirm mapping and frequent-supplier readiness", "Complete production-readiness review and go-live decision", "Confirm regional and tax rules for each rollout region"],
      risks=["Mapping completeness", "Real-data defects", "Regional / tax-rule variation", "Go-live support readiness"],
      decisions=["Confirm LOG_ExpenseInvoiceProcessing_v1.2.0 is the renamed successor of PPJ.ExpenseInvoices.v1.1 and whether the earlier Export exclusion still applies"],
      capability="Expense-invoice intake, mapping, validation, tax/regional rules and exception handling for Logistics / EXIM and regional rollout.",
      legacy=["PPJ.ExpenseInvoices.v1.1", "PPJ. Expense-Invoices.v1.1", "Accounting Expense Invoices"],
      owner="Logistics / EXIM", root="PPJ. Expense-Invoices.v1.1.md", memory="PPJ.ExpenseInvoices.v1.1.memory.md", workspace="PPJ. Expense-Invoices.v1.1"),
    p("PUR_MaterialAllocation_v1.1.0", "Sourcing / Purchasing", "Validation / Stabilization",
      "Transaction reliability and exception control", "P7",
      "Validate controlled reallocation of surplus material across eligible OCs: Material Requirement -> Availability -> Allocation -> Validation -> WFX Transaction.",
      "Validation / stabilization. The first Sewing/Embroidery flow was validated (surplus OC -> unreserve -> find same Style/Buyer Reference OC -> allocate); general automation is not fully validated. Current work focuses on duplicate prevention, allocation conflict, exception paths, rollback, transaction confirmation and audit trail.",
      ["Test multiple OCs and partial allocation", "Test insufficient stock, duplicates and failure paths", "Validate rollback, audit and user confirmation"],
      risks=["Partial-allocation correctness", "Rollback and duplicate safety", "WFX transaction consistency"],
      capability="Validated for Sewing and Embroidery; broader material scope remains unconfirmed.",
      legacy=["PUR.Material.Allocation.v1.1", "PUR.Material.Allocation.v1.2", "Material Allocation"],
      root="PUR.Material.Allocation.v1.2.md", memory="PUR.Material.Allocation.v1.1.memory.md", workspace="PUR.Material.Allocation.v1.2"),
    p("MER_MarketIntelligence_v1.1.0", "Merchandising", "Active Intelligence", "Market and customer intelligence delivery", "Medium",
      "Turn market, customer, competitor, trend and demand signals into business intelligence for Merchandising.",
      "Active. Current outputs cover product/fabric opportunities, commercial trends and customer-pitching support; external ratings/reviews are not sales evidence.",
      ["Continue validated product/fabric opportunity analysis", "Keep review/rating signals distinct from sales evidence"],
      risks=["External signal interpretation"],
      legacy=["MER.MARKET.INTELLIGENCE.v1.1", "E-commerce Market Intelligence"],
      root="E-commerce Market Intelligence v.2.3.md", memory="MER.MARKET.INTELLIGENCE.v1.1.memory.md", workspace="E-commerce Market Intelligence v.2.3"),
    p("MER_InvoiceDataRecheck_v1.1.0", "Merchandising", "Active", "Multi-customer invoice, cost and data checking", "Medium",
      "Cross-check costing data, commercial cost, invoice data and customer rules, route exceptions to user review.",
      "No longer conceptually limited to Chico's: multi-customer invoice/cost/data checking (Costing Data + Commercial Cost + Invoice Data + Customer Rules -> Cross-check -> Exception -> User Review). Belongs to Merchandising, not Finance, because its business owner and core process are commercial/order-data validation.",
      ["Validate customer-specific recheck rules, starting from the Chico's baseline", "Confirm audit output with Merchandising"],
      risks=["Customer-rule coverage across customers"],
      legacy=["MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1", "ACC.CHICOS.INVOICE.RECHECK-AUDIT.v1.1"],
      root="MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md", memory="MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.memory.md", workspace="MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1"),
    p("WASH_SamplingManagement_v1.1.0", "Production + Wash", "Analysis / Product Design", "Sampling workflow and product design", "Medium",
      "Create a PPJ Group Portal workflow for Wash sample requests, planning, wash samples, results and approval.",
      "Target flow: Sample Request -> Planning -> Wash Sample -> Result -> Approval. Distinct from WASH_COWASH_v2.0.0 (sampling workflows vs production wash operations).",
      ["Confirm sampling workflow, data fields and roles", "Design approval/history and attachment handling"],
      risks=["Workflow ownership", "Do not merge with operational COWASH"],
      legacy=["WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1", "RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1"],
      root="WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md", memory="WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.memory.md", workspace="WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1"),
    p("PROD_HangingLineIoT_v1.0.0", "Production + Wash", "Development", "Source and KPI reconciliation", "Medium",
      "Provide real-time production-line visibility: Production Line -> IoT / Machine Data -> WISER / INA -> Production Metrics -> Dashboard.",
      "Development continues; some target/WIP information still depends on external machine/platform sources, and source and KPI definitions need reconciliation.",
      ["Reconcile source data", "Confirm KPI definitions with Production", "Validate dashboard measures"],
      risks=["Source/KPI reconciliation", "External machine/platform dependency for target/WIP"],
      legacy=["PROD.IOT.CHuyenTreo.v1.0", "PROD.IOT.CHuyenTreo_1", "Chuyen treo ver1"],
      root="PROD.IOT.CHuyenTreo_1.md", memory="PROD.IOT.CHuyenTreo.v1.0.memory.md", workspace="PROD.IOT.CHuyenTreo_1"),
    p("WH_AWBExtraction_v1.1.0", "Warehouse", "Active Development", "AWB image OCR and DHL email extraction; table/cell understanding and weight/unit reliability", "Medium",
      "Canonical umbrella for AWB OCR + DHL email extraction: both channels converge into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates).",
      "Now one project, not two. Channel A: AWB Image -> Document Detection -> OCR -> Table/Structure Understanding -> Cell Boundary Detection -> Field Extraction -> Validation. Channel B: DHL Email -> Email Parsing -> Shipment Detection -> AWB Mapping -> Field Extraction -> Validation. Technical priorities: table structure, cell boundaries, weight/unit reliability, post-processing, validation rules, confidence, human review, logging.",
      ["Improve table structure and cell-boundary understanding", "Improve shipment weight and weight-unit reliability (kg/g/lb/lbs/oz, mixed units)", "Add post-processing and validation rules", "Add confidence scoring and human review", "Add extraction logging and DHL email channel mapping to the Canonical AWB Record"],
      risks=["Mixed-unit weight extraction", "Table/cell-boundary errors"],
      capability="AWB image + DHL email -> Canonical AWB Record with validation, confidence and human review.",
      legacy=["Warehouse AWB OCR", "WH.AWB.EXTRACTION", "AWB-OCR-EMAILS"], owner="Warehouse",
      root="WH_AWBExtraction_v1.1.0.md", memory="WH_AWBExtraction_v1.1.0.memory.md", workspace="WH_AWBExtraction_v1.1.0",
      lane="ACTIVE DELIVERY / UAT"),
    # ---- Production ---------------------------------------------------------------
    p("HR_EmployeeDataPlatform_v1.1.0", "HR", "Production / Expansion", "Production rollout and data-quality monitoring", "P8",
      "Standardize employee data into a trusted Employee Master and Group HR Data Foundation, and support applicant extraction/prefill.",
      "The old name no longer represents the current purpose: Employee Data Collection -> Validation -> Standardization -> Employee Master -> Group HR Data Foundation. Key controls: duplicate employees, missing fields, company mapping, organizational mapping, payroll-sensitive information, permissions, history and ownership.",
      ["Monitor rollout by company/factory", "Track standardization, missing-field, duplicate and matching-success KPIs", "Stabilize applicant extraction and prefill workflow"],
      risks=["Sensitive HR data", "Data-quality consistency across companies/factories"],
      capability="Employee Data Collection -> Validation -> Standardization -> Employee Master -> Group HR Data Foundation; plus applicant extraction/prefill.",
      legacy=["HR.SSPFD.Workflow.v1.1", "HR.SS&PFD.v1.1"],
      root="HR.SS&PFD.v1.1.md", memory="HR.SSPFD.Workflow.v1.1.memory.md", workspace="HR.SS&PFD.v1.1", lane="PRODUCTION"),
    p("SCP_SourcingChatbot_v2.3.0", "Sourcing / Purchasing", "Production", "Production monitoring, data quality and retrieval quality", "P9",
      "One production application for supplier/material intelligence: Supplier Data + Material Data + Search + Comparison + RAG + Chatbot.",
      "Stays one application; do not split into sourcing database / search / RAG / chatbot unless business lifecycles genuinely diverge. Focus: production monitoring, data quality, retrieval quality, supplier/material coverage and answer traceability.",
      ["Clean missing fields, mixed types, duplicates and naming", "Stress-test retrieval with real Sourcing questions", "Monitor adoption and production quality"],
      risks=["Manual external-data input", "Non-standard naming and metadata", "Data-quality drift"],
      capability="Supplier / Material / Sample Intelligence; consolidated search platform and chatbot.",
      legacy=["SCP.SOURCING.CHATBOT.v2.3"],
      root="SCP.SOURCING.CHATBOT.v2.3.md", memory="SCP.SOURCING.CHATBOT.v2.3.memory.md", workspace="SCP.SOURCING.CHATBOT.v2.3", lane="PRODUCTION"),
    p("FIN_InvoiceDownloader_v1.2.0", "Finance / Accounting", "Production", "Operational reliability", "Support",
      "Acquire invoice documents/data: Invoice Source -> Download -> Store -> Structured Metadata (no accounting entry).",
      "Production. Acquires invoice documents/data for XML/PDF/metadata, merge, API and reporting-source use; does not perform accounting entry. Operations focus on portal changes, credentials, retry, missing/duplicate invoices, monitoring and audit.",
      ["Monitor portal and credential changes", "Track retries, missing invoices and duplicates", "Maintain audit evidence"],
      legacy=["PPJ.InvoiceDownloader.v1.2", "PPJ.Invoice Downloader.v1.2", "Invoice Downloader"],
      root="PPJ.Invoice Downloader.v1.2.md", memory="PPJ.InvoiceDownloader.v1.2.memory.md", workspace="PPJ.Invoice Downloader.v1.2", lane="PRODUCTION"),
    p("PUR_InventoryReport_v2.1.0", "Sourcing / Purchasing", "Production", "Post-enhancement support", "Support",
      "Purchasing operational inventory reporting: enhanced visibility, reports, tables, filters and material monitoring.",
      "Production. Purchasing operational inventory report, distinct from the old Accounting Inventory Report; v2.1 is the current canonical enhanced reporting capability (physical filename unchanged).",
      ["Collect operational feedback", "Prioritize validated reporting enhancements"],
      legacy=["PUR.Inventory.Report.v2.1", "PUR.Inventory.Report.v1.0", "Purchasing Inventory Report"],
      root="PUR.Inventory Report.md", memory="PUR.Inventory.Report.v1.0.memory.md", workspace="PUR.Inventory Report", lane="PRODUCTION"),
    p("AI_PERRIPlatform_v3.2.0", "Internal Chatbot & AI Platforms", "Production", "Permissioned production orchestration", "Support",
      "Operate PPJ's conversational orchestration platform: User -> PERRI -> Intent -> Agent / Tool -> Data / Knowledge / API -> Controlled Response / Action.",
      "Production. PERRI is an orchestration platform and should not absorb every business-domain project. Read-only agents and action agents remain distinct; action agents require stronger permissions, approval and audit.",
      ["Maintain permission and approval controls", "Monitor tool execution and audit logs"],
      risks=["Action-agent permissions and audit"],
      legacy=["PPJ.PERRI.Chatbot.v3.2", "PPJ.PERRI.Chatbot", "PERRI Chatbot"],
      root="PPJ.PERRI.Chatbot.md", memory="PPJ.PERRI.Chatbot.v3.2.memory.md", workspace="PPJ.PERRI.Chatbot", lane="PRODUCTION"),
    p("AI_ApplicationHub_v2.1.0", "Internal Chatbot & AI Platforms", "Internal Production Platform", "Platform operations", "Support",
      "AI application discovery, access and launch layer for the internal AI ecosystem.",
      "Platform. PERRI = conversational orchestration; AI Hub = application access layer. AI Hub is not the master project registry and not a container for merged project notes.",
      ["Maintain application catalogue and access", "Keep project registry ownership outside AI Hub"],
      legacy=["PPJ.AI.Hub.v2.1", "PPJ.AI.Hub", "Web Tong Hop Tool"],
      root="PPJ.AI.Hub.v2.1.md", memory="PPJ.AI.Hub.v2.1.memory.md", workspace="PPJ.AI.Hub.v2.1", lane="PRODUCTION"),
    # ---- Maintenance / support --------------------------------------------------------
    p("FAB_FabricDatamart_v2.2.0", "Fabric / Textiles Technique", "Support", "Operational support", "Support",
      "Support the Fabric datamart: Fabric, Hanger, QR and material reference data with Directus, corrections, permissions and users.",
      "Support. Scope remains Fabric + Hanger + QR + Material Reference and is not CPD; do not merge with the visual-sample datamart merely because Costing consumes both.",
      ["Maintain support backlog", "Resolve validated data, QR and permission issues"],
      legacy=["FD.Datamart.v2.2", "FD QR Hanger"],
      root="FD.Datamart.v2.2.md", memory="FD.Datamart.v2.2.memory.md", workspace="FD.Datamart.v2.2", lane="MAINTENANCE / SUPPORT"),
    p("CPD_VisualSampleDatamart_v1.1.0", "Fabric / Textiles Technique", "Maintenance", "Operational maintenance", "Support",
      "Maintain the 3D / visual sample library: 3D, visual samples, images, design assets and image search.",
      "Maintenance / support. CPD remains the visual/3D datamart and is not FD.",
      ["Maintain visual assets and image-search quality"],
      legacy=["CPD.Datamart.v1.1", "CPD Datamart"],
      root="CPD.Datamart.v1.1.md", memory="CPD.Datamart.v1.1.memory.md", workspace="CPD.Datamart.v1.1", lane="MAINTENANCE / SUPPORT"),
    p("ACC_GRNSupplierInvoiceBot_v2.3.0", "Finance / Accounting", "Production Support", "Operational stability and exceptions", "Support",
      "Operational automation bot for supplier invoice / GRN processing and system data entry: Validation -> Matching / Business Rules -> Data Preparation -> Automated Data Entry -> Target System -> Exception Handling.",
      "Production support. Not merely GRN-to-invoice matching; the name ACC_GRNInvoiceMatching is misleading. The approved canonical state is v2.3; the physical filename is retained via mapping.",
      ["Monitor exceptions and stability", "Maintain audit and user support"],
      legacy=["ACC.GRN-SupplierInvoiceBot.v2.3", "ACC.GRNInvoiceMatching", "Accounting GRN Supplier Invoice Bot"],
      root="ACC.GRN-SupplierInvoiceBot.v2.3.md", memory="ACC.GRN-SupplierInvoiceBot.v2.3.memory.md", workspace="ACC.GRN-SupplierInvoiceBot.v2.3", lane="MAINTENANCE / SUPPORT"),
    p("PUR_AdhocIndentSouth_v1.0.0", "Sourcing / Purchasing", "Maintenance", "Operational maintenance", "Support",
      "Maintain the existing stable indent automation (South region) and WFX compatibility.",
      "Maintenance. Stable automation; no major active development unless the business scope is reopened. Current work is support, input changes and minor fixes.",
      ["Handle validated support and compatibility changes"],
      legacy=["PUR.Adhoc.Indent.South.v1.0", "PUR.Adhoc Indent mien Nam", "Adhoc Indent mien Nam"],
      root="PUR.Adhoc Indent mien Nam.md", memory="PUR.Adhoc.Indent.South.v1.0.memory.md", workspace="PUR.Adhoc Indent mien Nam", lane="MAINTENANCE / SUPPORT"),
    p("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0", "Internal Chatbot & AI Platforms", "Maintenance", "IT helpdesk maintenance", "Support",
      "Maintain the IT-specific Helpdesk AI for troubleshooting, FAQ, ERP support and knowledge retrieval.",
      "GLPI AI remains IT-specific and separate from PERRI's general orchestration role. Not listed in the 2026-09-18 naming baseline; legacy canonical code retained.",
      ["Maintain helpdesk knowledge and issue handling"],
      decisions=["Assign a canonical name under the 2026-09-18 naming standard (project is not listed in the baseline)"],
      legacy=["PPJ.GLPI-Helpdesk-AI Chatbot", "GLPI Helpdesk AI Chatbot"],
      root="PPJ.GLPI-Helpdesk-AI Chatbot.md", memory="PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0.memory.md", workspace="PPJ.GLPI-Helpdesk-AI Chatbot", lane="MAINTENANCE / SUPPORT"),
    # ---- On hold / external / decision -----------------------------------------------
    p("QC_DefectDetection_v1.0.0", "QC / TQM", "On Hold", "Reactivation decision", "Hold",
      "Computer-vision inspection: Image -> Defect Detection -> Defect Classification -> QC Review. Named for the business capability, not the vendor.",
      "On Hold (QC/TQM resources / dataset readiness). Reopen only with a usable dataset, a business owner, a measurable accuracy target and an operational evaluation process. Proposal and NDA exist; this is not an approved PoC or implementation.",
      ["Confirm QC and TQM owners", "Define dataset, labeling capability, pilot product and success metrics", "Confirm budget/resources before reactivation"],
      risks=["No owner/resources", "Dataset and labeling readiness"],
      legacy=["PPJxQSee.AI", "PPJxQSee.ai", "QSee.ai"],
      root="PPJxQSee.ai.md", memory="PPJxQSee.AI.memory.md", workspace="PPJxQSee.ai", lane="ON HOLD / DECISION"),
    p("QC_ThreadTraceability_v1.0.0", "QC / TQM", "Pre-PoC / Business Case", "Business/customer case decision", "Decision",
      "Evaluate RFID / thread identification and traceability only when QC need, MER commercial case, customer willingness to pay and factory feasibility align.",
      "Pre-PoC / business case. Current stage remains evaluation rather than full project delivery; no vendor PoC or implementation is approved.",
      ["Confirm QC need and MER commercial case", "Validate customer willingness to pay", "Assess factory feasibility before PoC approval"],
      legacy=["QC.Primo1D.RFID.Thread.v1.0", "PPJ XPrimo1D RFID Thread", "Primo1D RFID Thread"],
      root="PPJ XPrimo1D RFID Thread.md", memory="QC.Primo1D.RFID.Thread.v1.0.memory.md", workspace="PPJ XPrimo1D RFID Thread", lane="ON HOLD / DECISION"),
    p("PPJxStratova.AI", "Fabric / Textiles Technique", "Closed", "Historical record; current Stratova PoC negotiation tracked as DISCOVERY_PatternGenerationPoC", "Closed",
      "Historical closed record of the earlier Stratova evaluation. Do not reuse this code for the current pattern-generation PoC.",
      "Closed. The current Stratova pattern-generation PoC (DAF / commercial / technical scope negotiation) is a discovery initiative outside the canonical registry: see PPJ_DISCOVERY_REGISTER (DISCOVERY_PatternGenerationPoC).",
      [],
      legacy=["PPJxStratova AI", "Stratova AI"],
      root="PPJxStratova AI.md", memory="PPJxStratova.AI.memory.md", workspace="PPJxStratova AI", lane="CLOSED"),
    p("PPJxNUNOX.ScanTrial", "Fabric / Textiles Technique", "Partnership / Digital Library Evaluation", "Working-session outcome unconfirmed", "Decision",
      "Evaluate fabric scanning and Fabric/Garment Digital Library potential.",
      "NUNOX proposed a 17-18 August session, but attendance, demo result and agreement are not confirmed. Not listed in the 2026-09-18 naming baseline; legacy canonical code retained.",
      ["Confirm whether the proposed session occurred", "Record evidence before any partnership or implementation decision"],
      risks=["Session outcome unconfirmed"],
      decisions=["Confirm status and canonical name under the 2026-09-18 naming standard (project is not listed in the baseline)"],
      legacy=["PPJxNUNOX", "NUNOX"],
      root="PPJxNUNOX.md", memory="PPJxNUNOX.ScanTrial.memory.md", workspace="PPJxNUNOX", lane="ON HOLD / DECISION", confidence="Needs Confirmation"),
    p("EXT_AcademicCollaboration_v1.1.0", "External Collaboration", "Active / Problem Framing", "Academic problem package", "Medium",
      "Academic collaboration: UIT, thesis and student projects, competitions, research, prototype development and talent pipeline.",
      "Active / problem framing. Potential first technical topic: 2D Pattern Nesting -> Fabric Utilization -> Waste Reduction. Academic prototypes must not be confused with production CAD replacement.",
      ["Finalize the academic problem package and dataset", "Define benchmark and prototype evaluation boundaries"],
      legacy=["PPJ.UIT.ACADEMIC.COLLABORATION.v1.1"],
      root="PPJ.UIT.ACADEMIC.COLLABORATION.v1.1.md", memory="PPJ.UIT.ACADEMIC.COLLABORATION.v1.1.memory.md", workspace="PPJ.UIT.ACADEMIC.COLLABORATION.v1.1", lane="ON HOLD / DECISION"),
    p("WASH_COWASH_v2.0.0", "Production + Wash", "On Hold", "Delivery paused", "Hold",
      "Production wash operations platform (operational wash data, machine, output, delay, rework); distinct from WASH_SamplingManagement_v1.1.0.",
      "On Hold; delivery paused. Owner, data source, KPI, access and technical direction remain insufficient.",
      ["Confirm owner, source, KPI, access and technical direction before reactivation"],
      legacy=["PROD.COWASH.v2.0", "PROD.COWASH", "COWASH"],
      root="PROD.COWASH.md", memory="PROD.COWASH.v2.0.memory.md", workspace="PROD.COWASH", lane="ON HOLD / DECISION"),
    p("PUR_HMLabelProcessing_v1.0.0", "Sourcing / Purchasing", "On Hold", "Business priority paused", "Hold",
      "Hold H&M Label-O processing automation pending a scalable business case; name shortened to the actual process.",
      "On Hold; business priority paused. Customer-specific hard-coding creates high maintenance and low scalability. Kept in INTERNAL DEVELOPMENT with On Hold status (not Closed).",
      ["Confirm whether a scalable rules model and sufficient value exist"],
      legacy=["PUR.HM.LabelO.Processing.Automation.v1.0", "PUR.HM.LabelO.Processing.Automation", "H&M Label-O Processing"],
      root="PUR.H&M Label-O Processing.md", memory="PUR.HM.LabelO.Processing.Automation.v1.0.memory.md", workspace="PUR.H&M Label-O Processing", lane="ON HOLD / DECISION"),
    # ---- Closed --------------------------------------------------------------------
    p("ACC_InventoryReport_v1.0.0", "Finance / Accounting", "Closed", "Closed / no active follow-up", "Closed",
      "Preserve the completed Accounting inventory-report history with no active delivery.",
      "Closed. Distinct from PUR_InventoryReport_v2.1.0.", [],
      legacy=["ACC.Inventory.Report.v1.0"],
      root="ACC.Inventory.Report.v1.0.md", memory="ACC.Inventory.Report.v1.0.memory.md", workspace="ACC.Inventory.Report.v1.0", lane="CLOSED"),
    p("MER_POCommit_v1.1.0", "Merchandising", "Closed", "Closed", "Closed",
      "Preserve the closed PO Commit project history (Customer Order -> MER PO Creation; ~70-80% of customer scenarios covered).",
      "Closed. No active development unless reopened.", [],
      legacy=["MER.PO.Commit.v1.1", "MER.PO-Commit", "PO Commit"],
      root="MER.PO-Commit.md", memory="MER.PO.Commit.v1.1.memory.md", workspace="MER.PO-Commit", lane="CLOSED"),
    p("EXIM.ExpenseInvoices.Automation.v1.1", "Finance / Accounting", "Closed", "Replaced / Closed; succeeded by LOG_ExpenseInvoiceProcessing_v1.2.0", "Closed",
      "Preserve the closed legacy EXIM Expense Invoice Automation history separately from its successor.",
      "Replaced / Closed. LOG_ExpenseInvoiceProcessing_v1.2.0 is the current Logistics / Import-Export expense-invoice project; histories remain separate.", [],
      dependencies=["Historical predecessor -> LOG_ExpenseInvoiceProcessing_v1.2.0"],
      legacy=["EXIM Expense Invoice Bot"],
      root="EXIM.ExpenseInvoices.Automation.v1.1.md", memory="EXIM.ExpenseInvoices.Automation.v1.1.memory.md", workspace="EXIM.ExpenseInvoices.Automation.v1.1", lane="CLOSED"),
    p("AI.Automation.Workshop.202606", "External Collaboration", "Closed", "Closed event", "Closed",
      "Preserve the June 2026 AI Automation Workshop record.", "Historical; no active tasks.", [],
      legacy=["AI Automation Workshop"],
      root="AI Automation Workshop.md", memory="AI.Automation.Workshop.202606.memory.md", lane="CLOSED"),
    p("AI.Automation.Workshop.Analysis.202606", "External Collaboration", "Closed", "Closed analysis", "Closed",
      "Preserve the June 2026 workshop analysis record.", "Historical; no active tasks.", [],
      legacy=["Workshop Analysis", "AI Automation Workshop Analysis"],
      root="Workshop Analysis.md", memory="AI.Automation.Workshop.Analysis.202606.memory.md", lane="CLOSED"),
    p("VITAS.Sharing.202606", "External Collaboration", "Closed", "Closed event", "Closed",
      "Preserve the June 2026 VITAS sharing record.", "Historical; no active tasks.", [],
      legacy=["VITAS Sharing"],
      root="VITAS Sharing.md", memory="VITAS.Sharing.202606.memory.md", workspace="VITAS Sharing", lane="CLOSED"),
    # ---- Candidate (not registered) ----------------------------------------------------
    p("CPD In-house Pattern Generation", "Fabric / Textiles Technique", "Internal Prototype / Evaluation", "Build-vs-buy benchmark; canonical code pending", "P10",
      "Build an internal pattern-generation benchmark from techpack/image/measurement inputs with Pattern Engineer and CAD validation.",
      "This remains an internal prototype/evaluation and is not a registered canonical project. It is the internal benchmark for the Stratova pattern-generation PoC (DISCOVERY_PatternGenerationPoC).",
      ["Define shared test cases for internal and Stratova evaluation", "Measure manual correction time to a usable production pattern", "Seek registration approval only if warranted"],
      risks=["Canonical code is not confirmed", "Production accuracy and CAD fit"],
      candidate=True, registration="Canonical Code Not Confirmed", lane="GOVERNANCE / CANDIDATE",
      link_target="03_Projects/_Registry/Project_Update_Proposals/CPD_IN_HOUSE_PATTERN_GENERATION_CURRENT_INITIATIVE"),
]

DISCOVERY = [
    {"label": "DISCOVERY_PatternGenerationPoC", "vendor": "Stratova", "status": "DAF / Commercial / Technical Scope Negotiation",
     "scope": "Pattern generation PoC. Do not reuse the historical PPJxStratova.AI code.",
     "open_questions": ["Google DAF approval", "Funding liability", "Rejection responsibility", "Termination clause", "POE/evidence", "Gemini/Vertex cost", "Pattern tolerance", "Success criteria"]},
    {"label": "Wizcore", "vendor": "Wizcore", "status": "Smart Factory Discovery",
     "scope": "Factory -> IoT -> Connectivity -> Integration -> Data -> Dashboard -> Traceability -> Analytics / AI.", "open_questions": []},
    {"label": "Faceworks AI", "vendor": "Faceworks AI", "status": "Technology Assessment",
     "scope": "Potential garment/textile AI capabilities under evaluation.", "open_questions": []},
    {"label": "Sortech", "vendor": "Sortech", "status": "Technology / SI Assessment",
     "scope": "Potentially relevant to invoice automation, GRN workflows, WFX automation, reconciliation, approvals, agentic workflows and smart-factory integration.", "open_questions": []},
    {"label": "Quanskill", "vendor": "Quanskill", "status": "Vendor / Product Evaluation",
     "scope": "Not yet an approved implementation project.", "open_questions": []},
]

DELIVERY_STAGES = [
    "BACKLOG", "KICK-OFF", "ANALYSIS", "DESIGN", "DEVELOPMENT",
    "UAT / PRE-GO-LIVE", "GO-LIVE / PRODUCTION / SUPPORT", "CLOSED",
]

STAGE_BY_CODE = {
    "MER_MarketIntelligence_v1.1.0": "ANALYSIS",
    "QC_DefectDetection_v1.0.0": "ANALYSIS",
    "QC_ThreadTraceability_v1.0.0": "ANALYSIS",
    "PPJxNUNOX.ScanTrial": "ANALYSIS",
    "WASH_COWASH_v2.0.0": "ANALYSIS",
    "PUR_HMLabelProcessing_v1.0.0": "ANALYSIS",
    "FIN_FinanceManagement_v1.2.0": "DESIGN",
    "WASH_SamplingManagement_v1.1.0": "DESIGN",
    "EXT_AcademicCollaboration_v1.1.0": "DESIGN",
    "MER_CostingAgenticPlatform_v1.1.0": "DEVELOPMENT",
    "PUR_GDIAutomation_v1.0.0": "DEVELOPMENT",
    "PROD_HangingLineIoT_v1.0.0": "DEVELOPMENT",
    "WH_AWBExtraction_v1.1.0": "DEVELOPMENT",
    "TD_TechnicalKnowledgePlatform_v2.1.0": "UAT / PRE-GO-LIVE",
    "ADMIN_ExpenseManagement_v1.1.0": "UAT / PRE-GO-LIVE",
    "LOG_ExpenseInvoiceProcessing_v1.2.0": "UAT / PRE-GO-LIVE",
    "PUR_MaterialAllocation_v1.1.0": "UAT / PRE-GO-LIVE",
    "MER_InvoiceDataRecheck_v1.1.0": "UAT / PRE-GO-LIVE",
    "HR_EmployeeDataPlatform_v1.1.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "SCP_SourcingChatbot_v2.3.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "FIN_InvoiceDownloader_v1.2.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "PUR_InventoryReport_v2.1.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "AI_PERRIPlatform_v3.2.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "AI_ApplicationHub_v2.1.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "FAB_FabricDatamart_v2.2.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "CPD_VisualSampleDatamart_v1.1.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "ACC_GRNSupplierInvoiceBot_v2.3.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "PUR_AdhocIndentSouth_v1.0.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "PPJxStratova.AI": "CLOSED",
    "ACC_InventoryReport_v1.0.0": "CLOSED",
    "MER_POCommit_v1.1.0": "CLOSED",
    "EXIM.ExpenseInvoices.Automation.v1.1": "CLOSED",
    "AI.Automation.Workshop.202606": "CLOSED",
    "AI.Automation.Workshop.Analysis.202606": "CLOSED",
    "VITAS.Sharing.202606": "CLOSED",
}

STATUS_BY_CODE = {
    "QC_DefectDetection_v1.0.0": "External Collaboration",
    "WASH_COWASH_v2.0.0": "External Collaboration",
    "PUR_HMLabelProcessing_v1.0.0": "On Hold",
    "QC_ThreadTraceability_v1.0.0": "External Collaboration",
    "PPJxNUNOX.ScanTrial": "External Collaboration",
    "EXT_AcademicCollaboration_v1.1.0": "External Collaboration",
    "PPJxStratova.AI": "Closed",
}

EXTERNAL_DEVELOPMENT_CODES = {
    "QC_DefectDetection_v1.0.0", "QC_ThreadTraceability_v1.0.0", "PPJxStratova.AI",
    "PPJxNUNOX.ScanTrial", "EXT_AcademicCollaboration_v1.1.0",
    "WASH_COWASH_v2.0.0",
}

for _project in PORTFOLIO:
    if _project.candidate:
        _project.delivery_stage = ""
        _project.status = "Candidate"
        _project.delivery_stream = ""
    else:
        _project.delivery_stage = STAGE_BY_CODE[_project.code]
        _project.delivery_stream = "EXTERNAL DEVELOPMENT" if _project.code in EXTERNAL_DEVELOPMENT_CODES else "INTERNAL DEVELOPMENT"
        if _project.code in STATUS_BY_CODE:
            _project.status = STATUS_BY_CODE[_project.code]
        elif _project.delivery_stage == "CLOSED":
            _project.status = "Closed"
        elif _project.lifecycle in ("Support", "Maintenance", "Production Support"):
            _project.status = "Support"
        else:
            _project.status = "Active"


def md_escape(value: str) -> str:
    return value.replace("|", "\\|").replace("\n", " ")


def yaml_quote(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def split_frontmatter(text: str):
    text = text.lstrip("\ufeff")
    if not text.startswith("---\n"):
        return None, text
    end = text.find("\n---", 4)
    if end < 0:
        return None, text
    return text[4:end], text[end + 4:].lstrip("\n")


def update_frontmatter(text: str, fields: dict[str, object]) -> str:
    fm, body = split_frontmatter(text)
    lines = [] if fm is None else fm.splitlines()
    for key, value in fields.items():
        rendered_value = yaml_quote(value) if isinstance(value, str) else json.dumps(value, ensure_ascii=False)
        rendered = f"{key}: {rendered_value}"
        pattern = re.compile(rf"^{re.escape(key)}\s*:")
        found = False
        for i, line in enumerate(lines):
            if pattern.match(line):
                lines[i] = rendered
                found = True
                break
        if not found:
            lines.append(rendered)
    return "---\n" + "\n".join(lines) + "\n---\n\n" + body.rstrip() + "\n"


def replace_managed(text: str, content: str, start=START, end=END, *, after_frontmatter=False) -> str:
    block = f"{start}\n{content.rstrip()}\n{end}"
    pattern = re.compile(re.escape(start) + r".*?" + re.escape(end), re.S)
    if pattern.search(text):
        return pattern.sub(block, text).rstrip() + "\n"
    if after_frontmatter:
        fm, body = split_frontmatter(text)
        if fm is not None:
            return f"---\n{fm}\n---\n\n{block}\n\n{body.rstrip()}\n"
        heading = re.match(r"^(# [^\n]+\n+)(.*)$", text, re.S)
        if heading:
            return f"{heading.group(1)}\n{block}\n\n{heading.group(2).rstrip()}\n"
    return text.rstrip() + "\n\n" + block + "\n"


def project_section(x: Project, *, workspace=False) -> str:
    na = "\n".join(f"- {a}" for a in x.next_actions) or "- No active actions."
    risks = "\n".join(f"- {a}" for a in x.risks) or "- No current portfolio-level risk recorded."
    decisions = "\n".join(f"- {a}" for a in x.decisions) or "- No current portfolio decision recorded."
    deps = "\n".join(f"- {a}" for a in x.dependencies) or "- No current cross-project dependency recorded."
    links = ""
    if x.workspace:
        links = (f"\n## Workspace Links\n\n- [[{x.workspace}/00_Project_Home|Project Home]]\n"
                 f"- [[{x.workspace}/Project_Executive_Board|Project Executive Board]]\n"
                 f"- [[{x.workspace}/Tasks|Tasks]]\n")
    return f"""## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | {x.code} |
| Legacy Code(s) | {'; '.join(x.legacy) or 'None'} |
| Primary Domain | {x.domain} |
| Delivery Stream | {x.delivery_stream or "Candidate / Not Registered"} |
| Delivery Stage | {x.delivery_stage or "Candidate / Not Registered"} |
| Lifecycle | {x.lifecycle} |
| Status | {x.status} |
| Progress | {x.progress} |
| Current Gate | {x.gate} |
| Priority | {x.priority} |
| Business Owner | {x.owner} |
| Registration | {x.registration} |
| Last Verified | {VERIFIED} |
| Confidence | {x.confidence} |

## Executive Summary

{x.outcome}

## Current Capability

{x.capability or x.outcome}

## Latest Update

{x.latest}

## Risks / Blockers

{risks}

## Decisions Needed

{decisions}

## Dependencies

{deps}

## Next Actions

{na}

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `{EVENT}`.
{links}
## Evidence and Confidence

- Date: {VERIFIED}
- Source Event: {EVENT}
- Source: User-approved portfolio current-state snapshot
- Confidence: {x.confidence}
"""


def workspace_section(x: Project) -> str:
    actions = "\n".join(f"- {a}" for a in x.next_actions) or "- No active actions."
    risks = "\n".join(f"- {a}" for a in x.risks) or "- None recorded in the current portfolio snapshot."
    deps = "\n".join(f"- {a}" for a in x.dependencies) or "- None recorded in the current portfolio snapshot."
    return f"""## Current State - {VERIFIED}

| Field | Value |
| --- | --- |
| Canonical Code | {x.code} |
| Domain | {x.domain} |
| Delivery Stream | {x.delivery_stream or "Candidate / Not Registered"} |
| Delivery Stage | {x.delivery_stage or "Candidate / Not Registered"} |
| Lifecycle | {x.lifecycle} |
| Status | {x.status} |
| Progress | {x.progress} |
| Gate | {x.gate} |
| Priority | {x.priority} |
| Outcome | {x.outcome} |
| Source Event | {EVENT} |

### Latest Update

{x.latest}

### Current Risks

{risks}

### Dependencies

{deps}

### Next Actions

{actions}
"""


def snapshot_markdown() -> str:
    import ppj_canvas_state_lib as lib
    return lib.snapshot_markdown(json.loads(snapshot_json()))


def snapshot_json() -> str:
    data = {
        "source_event": EVENT, "last_verified": VERIFIED,
        "portfolio_maturity": "Stage 3 - Controlled Delivery / Early Scale",
        "naming_standard": "<DEPARTMENT>_<APPLICATION>_v<MAJOR>.<MINOR>.<PATCH>",
        "strategic_direction": ["Standardize Data", "Standardize Rules", "Standardize APIs", "Scale Automation / AI Capabilities"],
        "governance_exceptions": GOVERNANCE_EXCEPTIONS,
        "discovery": DISCOVERY,
        "projects": [x.__dict__ for x in PORTFOLIO],
    }
    return json.dumps(data, ensure_ascii=False, indent=2) + "\n"


def registry_table(kind: str) -> str:
    if kind == "memory":
        head = "| Project | Memory Card | Project Note | Domain | Delivery Stream | Delivery Stage | Lifecycle | Status | Priority | Current Gate | Current Outcome | Last Verified |\n| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |"
        rows = []
        for x in PORTFOLIO:
            if x.candidate: continue
            mem = f"[[{Path(x.memory_file).stem}]]" if x.memory_file else "Not root-backed"
            note = f"[[{Path(x.root_file).stem}]]" if x.root_file else "Not root-backed"
            rows.append(f"| {x.code} | {mem} | {note} | {x.domain} | {x.delivery_stream} | {x.delivery_stage} | {x.lifecycle} | {x.status} | {x.priority} | {md_escape(x.gate)} | {md_escape(x.outcome)} | {VERIFIED} |")
    elif kind == "domain":
        head = "| Canonical Project | Primary Domain | Delivery Stream | Delivery Stage | Lifecycle | Status | Registration | Last Verified |\n| --- | --- | --- | --- | --- | --- | --- | --- |"
        rows = [f"| {x.code} | {x.domain} | {x.delivery_stream or 'Candidate / Not Registered'} | {x.delivery_stage or 'Candidate / Not Registered'} | {x.lifecycle} | {x.status} | {x.registration} | {VERIFIED} |" for x in PORTFOLIO]
    elif kind == "aliases":
        head = "| Canonical Code | Legacy / Alias Names | Current Physical File | Workspace | Registration |\n| --- | --- | --- | --- | --- |"
        rows = [f"| {x.code} | {md_escape('; '.join(x.legacy)) or 'None'} | {x.root_file or 'None - governance/candidate record only'} | {x.workspace or 'None'} | {x.registration} |" for x in PORTFOLIO]
    elif kind == "resources":
        head = "| Project | Domain | Owner | Delivery Stream | Delivery Stage | Lifecycle | Status | Priority | Gate | Open Action Count |\n| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |"
        rows = [f"| {x.code} | {x.domain} | {x.owner} | {x.delivery_stream or 'Candidate / Not Registered'} | {x.delivery_stage or 'Candidate / Not Registered'} | {x.lifecycle} | {x.status} | {x.priority} | {md_escape(x.gate)} | {len(x.next_actions)} |" for x in PORTFOLIO]
    else:
        head = "| Canonical Code | Current File | Primary Domain | Delivery Stream | Delivery Stage | Lifecycle | Status | Current Gate | Priority | Current Outcome | Last Verified |\n| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |"
        rows = [f"| {x.code} | {x.root_file or 'None - governance/candidate record only'} | {x.domain} | {x.delivery_stream or 'Candidate / Not Registered'} | {x.delivery_stage or 'Candidate / Not Registered'} | {x.lifecycle} | {x.status} | {md_escape(x.gate)} | {x.priority} | {md_escape(x.outcome)} | {VERIFIED} |" for x in PORTFOLIO]
    return f"## Authoritative Current-State Overlay - {VERIFIED}\n\nSource event: `{EVENT}`. This overlay supersedes older current-state rows below; older rows remain historical evidence.\n\n{head}\n" + "\n".join(rows)


def command_center() -> str:
    sections = ["STRATEGIC ACTIVE", "ACTIVE DELIVERY / UAT", "PRODUCTION", "MAINTENANCE / SUPPORT", "ON HOLD / DECISION", "CLOSED", "GOVERNANCE / CANDIDATE"]
    body = []
    for lane in sections:
        body.append(f"## {lane.title()}")
        body.append("\n| Project | Domain | Lifecycle | Priority | Gate | Outcome |\n| --- | --- | --- | --- | --- | --- |")
        for x in PORTFOLIO:
            if x.lane == lane:
                body.append(f"| {x.code} | {x.domain} | {x.lifecycle} | {x.priority} | {md_escape(x.gate)} | {md_escape(x.outcome)} |")
        body.append("")
    pipeline_rows=[]
    for stream in ("INTERNAL DEVELOPMENT", "EXTERNAL DEVELOPMENT"):
        for delivery_stage in DELIVERY_STAGES:
            projects=[x.code for x in PORTFOLIO if not x.candidate and x.delivery_stream==stream and x.delivery_stage==delivery_stage]
            pipeline_rows.append(f"| {stream} | {delivery_stage} | {'<br>'.join(projects) or 'None'} | {len(projects)} |")
    overlays=("- On Hold: " + ", ".join(x.code for x in PORTFOLIO if x.status=="On Hold") + "\n"
              "- External Development: " + ", ".join(x.code for x in PORTFOLIO if x.delivery_stream=="EXTERNAL DEVELOPMENT") + "\n"
              "- Domains added by the 2026-09-18 baseline: Administration; Warehouse; Logistics / EXIM\n"
              "- Candidate Initiatives: CPD In-house Pattern Generation\n"
              "- Discovery (not registered): " + "; ".join(d["label"] for d in DISCOVERY))
    return f"""---
type: portfolio_command_center
source_event: {EVENT}
last_verified: {VERIFIED}
---

# PPJ Project Command Center

## Portfolio Maturity

**Stage 3 - Controlled Delivery / Early Scale.** The portfolio is converging around Finance control, Technical Data and WFX transaction foundations.

## Top Priorities

| Priority | Project | Management Objective |
| --- | --- | --- |
| P1 | FIN_FinanceManagement_v1.2.0 | Complete WS2 OC / Cost Control and advance WS3 Factory Performance |
| P2 | MER_CostingAgenticPlatform_v1.1.0 | Sew Agent fixes, SAM accuracy and GTAS/IED integration |
| P3 | PUR_GDIAutomation_v1.0.0 | WFX API integration and GDI data-entry workflow |
| P4 | LOG_ExpenseInvoiceProcessing_v1.2.0 | Regional rollout / UAT -> Go-Live |
| P5 | TD_TechnicalKnowledgePlatform_v2.1.0 | Sync validation and canonical technical model |
| P6 | ADMIN_ExpenseManagement_v1.1.0 | Multi-traveler model, end-to-end lifecycle and UAT preparation |
| P7 | PUR_MaterialAllocation_v1.1.0 | Transaction reliability and exception control |
| P8 | HR_EmployeeDataPlatform_v1.1.0 | Production rollout and data quality |
| P9 | SCP_SourcingChatbot_v2.3.0 | Production monitoring, data quality and retrieval quality |
| P10 | CPD In-house Pattern Generation | Build-vs-buy evaluation; candidate only |

## Delivery Pipeline

| Delivery Stream | Stage | Projects | Count |
| --- | --- | --- | ---: |
{chr(10).join(pipeline_rows)}

## Operational Overlays

{overlays}

{chr(10).join(body)}
## Portfolio-level Blockers

- Databricks/WFX access, permissions and source ownership.
- Data quality and lineage across Finance, Technical, HR and Sourcing.
- Versioned business rules and approval for Finance, Material Allocation, Expense Invoices and GDI.
- Production ownership, SLA, monitoring, release and adoption governance.

## Cross-project Dependencies

- Finance foundation: WFX / Databricks / DWH -> rules -> OC control -> factory performance.
- Technical foundation: TD Platform -> Pattern/BOM/Consumption -> Costing/Pattern/Wash/Search.
- Transaction foundation: WFX API -> validation -> controlled transactions -> audit.
- HR and Sourcing foundations: standardized master data before scaled automation/AI.

## Domain / Registration Exceptions

- Governance exceptions and open naming/mapping decisions: see the Governance Exceptions section of [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT]].
- Discovery / vendor assessments are tracked in [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER]] and are not registered projects.
"""


def canvas_doc(title: str, groups: list[tuple[str, list[Project]]], *, links=True) -> str:
    nodes, edges = [], []
    group_w, card_w, card_h, gap = 620, 560, 270, 30
    for gi, (label, items) in enumerate(groups):
        x0 = gi * (group_w + 80)
        height = max(420, 120 + len(items) * (card_h + gap))
        gid = f"group-{gi}"
        nodes.append({"id": gid, "type": "group", "x": x0, "y": 0, "width": group_w, "height": height, "label": label})
        for pi, item in enumerate(items):
            nid = "view-card-" + hashlib.sha1(f"{title}:{item.code}".encode()).hexdigest()[:16]
            y = 80 + pi * (card_h + gap)
            link=card_link(item)
            text = (f"<!-- PPJ_PORTFOLIO_VIEW_CARD:{item.code} -->\n\n## {link}\n\nDomain: {item.domain}\n"
                    f"Delivery Stream: {item.delivery_stream or 'Candidate / Not Registered'}\n"
                    f"Delivery Stage: {item.delivery_stage or 'Candidate / Not Registered'}\nLifecycle: {item.lifecycle}\n"
                    f"Status: {item.status}\nPriority: {item.priority}\nGate: {item.gate}")
            nodes.append({"id": nid, "type": "text", "text": text, "x": x0 + 30, "y": y, "width": card_w, "height": card_h})
    return json.dumps({"nodes": nodes, "edges": edges}, ensure_ascii=False, indent=2) + "\n"


GOVERNANCE_EXCEPTIONS = [
    "`CPD In-house Pattern Generation`: internal prototype/evaluation and benchmark for the Stratova PoC; canonical code is not confirmed; no canonical root project was created.",
    "`WH_AWBExtraction_v1.1.0` and `ADMIN_ExpenseManagement_v1.1.0`: registered by the 2026-09-18 baseline (domains Warehouse and Administration added to the domain model); root notes, memory cards and workspaces were created through `register_ppj_project.py` with owners, technical members and dates still Needs Confirmation.",
    "`LOG_ExpenseInvoiceProcessing_v1.2.0`: mapped as the renamed successor of `PPJ.ExpenseInvoices.v1.1` under Logistics / EXIM; confirm the mapping and whether the earlier Export exclusion still applies.",
    "`PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0` and `PPJxNUNOX.ScanTrial`: not listed in the 2026-09-18 baseline; legacy canonical codes retained until they are named and confirmed.",
]


def card_link(item: Project) -> str:
    if item.root_file:
        return f"[[03_Projects/{Path(item.root_file).stem}|{item.code}]]"
    if item.link_target:
        return f"[[{item.link_target}|{item.code}]]"
    return item.code


def registered_initiative_doc(x: Project) -> str:
    return f"""---
type: registered_initiative
initiative: {yaml_quote(x.code)}
registration_status: {yaml_quote(x.registration)}
primary_domain: {yaml_quote(x.domain)}
source_event: {yaml_quote(EVENT)}
last_verified: {VERIFIED}
---

# {x.code}

Registered as a canonical project by `{EVENT}` (previously the candidate `Warehouse AWB OCR`). Its root project note, memory card and workspace are `WH_AWBExtraction_v1.1.0` (created with `scripts/register_ppj_project.py`).

{project_section(x)}
"""


def discovery_register() -> str:
    rows = "\n".join(
        "| " + " | ".join(md_escape(v) for v in (d["label"], d["vendor"], d["status"], d["scope"], "; ".join(d["open_questions"]) or "-")) + " |"
        for d in DISCOVERY
    )
    return f"""---
type: discovery_register
source_event: {EVENT}
last_verified: {VERIFIED}
---

# PPJ Discovery Register

Vendor and technology discovery activity kept **outside** the canonical project registry until PPJ approves a scope. Entries here are not projects: they have no canonical code, Canvas card, WBS item or workload.

| Label | Vendor | Status | Scope | Open Questions |
| --- | --- | --- | --- | --- |
{rows}

## Rules

- Do not reuse the historical `PPJxStratova.AI` code for the current pattern-generation PoC; use the temporary label `DISCOVERY_PatternGenerationPoC`.
- Promote an entry to a registered project only through the registration protocol (`PPJ_PROJECT_REGISTRATION_PROTOCOL`) after scope approval.
- Vendor names do not appear in canonical project names unless the vendor defines the business product.
"""


DOMAIN_ADDITIONS_START = "<!-- PPJ_DOMAIN_ADDITIONS_20260918_START -->"
DOMAIN_ADDITIONS_END = "<!-- PPJ_DOMAIN_ADDITIONS_20260918_END -->"


def domain_model_text() -> str:
    path = REGISTRY / "PPJ_PORTFOLIO_DOMAIN_MODEL.md"
    old = path.read_text(encoding="utf-8-sig")
    block = """## Additional Official Domains (2026-09-18 baseline)

Added from the 2026-09-18 naming baseline, where the canonical department prefix is the business owner. These extend the Official Domains table above; the Canonical Placement table below is historical and superseded by `PPJ_PORTFOLIO_CURRENT_SNAPSHOT`.

| Primary Domain | Capability | Projects |
| --- | --- | --- |
| Administration | Business travel, advance, expense and settlement workflows | ADMIN_ExpenseManagement_v1.1.0 |
| Warehouse | Shipment documents, AWB and courier data extraction | WH_AWBExtraction_v1.1.0 |
| Logistics / EXIM | Import-export and logistics expense-invoice processing, regional and tax rules | LOG_ExpenseInvoiceProcessing_v1.2.0 |"""
    return replace_managed(old, block, DOMAIN_ADDITIONS_START, DOMAIN_ADDITIONS_END)


def patch_executive_canvas(canvas: dict, snapshot: dict, config: dict) -> dict:
    """Update the live Executive Board in place, keeping the user's layout.

    Cards are matched by the PPJ_PROJECT_CARD marker (canonical or legacy code),
    rewritten from the snapshot, and moved only when their stream/stage group
    differs from the snapshot.  Unrelated nodes (notes, side panels) are kept.
    """
    import ppj_canvas_state_lib as lib
    nodes = canvas["nodes"]
    by_id = {n["id"]: n for n in nodes}
    projects = {x["code"]: x for x in lib.registered_projects(snapshot)}
    alias = {code: code for code in projects}
    for item in projects.values():
        for old in item.get("legacy", []):
            alias.setdefault(old, item["code"])
    groups = {}
    for stream in config["streams"]:
        for stage, group_id in stream["group_ids"].items():
            if group_id not in by_id:
                raise ValueError(f"Executive canvas is missing group {group_id}")
            groups[(stream["name"], stage)] = by_id[group_id]

    cards = {}
    for node in nodes:
        marker = lib.PROJECT_MARKER.search(str(node.get("text", "")))
        if not marker:
            continue
        old = marker.group(1).strip()
        code = alias.get(old)
        if code is None:
            raise ValueError(f"Executive canvas card has no registered project: {old}")
        if code in cards:
            raise ValueError(f"Executive canvas has two cards for {code}")
        cards[code] = node

    def free_slot(group, mover):
        inside = [n for n in nodes if n is not mover and n.get("type") != "group" and lib.center_in(n, group)]
        bottom = max((n["y"] + n["height"] for n in inside), default=group["y"] + 160)
        return group["x"] + 30, bottom + 30

    def by_priority(item):
        match = re.fullmatch(r"P(\d+)", str(item.get("priority", "")))
        return (int(match.group(1)) if match else 99, item["code"])

    moved = []
    for item in sorted(projects.values(), key=by_priority):
        code = item["code"]
        target = groups[(item["delivery_stream"], item["delivery_stage"])]
        node = cards.get(code)
        if node is None:
            node = {"id": lib.stable_project_id(code), "type": "text", "x": 0, "y": 0, "width": 700, "height": 310, "text": ""}
            nodes.append(node)
            cards[code] = node
            moved.append(code)
        elif not lib.center_in(node, target):
            moved.append(code)
        node["text"] = lib.project_card_text(item)
        node["id"] = lib.stable_project_id(code)
        if code in moved:
            node["x"], node["y"] = free_slot(target, node)

    # Groups must still contain the cards; equalize the height of each stream row.
    for stream in config["streams"]:
        row = [groups[(stream["name"], stage)] for stage in stream["group_ids"]]
        need = 0
        for group in row:
            inside = [n for n in nodes if n.get("type") != "group" and lib.center_in(n, group)]
            need = max(need, max((n["y"] + n["height"] for n in inside), default=0) + 40 - group["y"])
        for group in row:
            group["height"] = max(group["height"], need)

    # Drop "empty stage" placeholders for groups that now hold a card.
    card_nodes = list(cards.values())

    def is_stale_placeholder(node) -> bool:
        if "-lane-empty-" not in str(node.get("id")):
            return False
        return any(lib.center_in(node, g) and any(lib.center_in(c, g) for c in card_nodes) for g in groups.values())

    nodes[:] = [n for n in nodes if not is_stale_placeholder(n)]

    attention = [x for x in projects.values() if x.get("status") in ("On Hold", "Blocked", "Waiting", "Pending Decision", "External Collaboration")]
    for node in nodes:
        if node["id"] == "ppj-side-attention-note":
            node["text"] = ("## Status overlays\n\n" + "\n".join(
                f"- {x['code']}: {x.get('status')} | Stream: {x.get('delivery_stream')} | Stage: {x.get('delivery_stage')} | Gate: {x.get('gate')}" for x in attention)
                + "\n\nThese are attention references, not duplicate project cards.")
        elif node["id"] == "ppj-side-domain-note":
            node["text"] = ("## Governance review\n\n"
                            "- [[07_Decision_Log/DEC-20260824-ADMIN-EXPENSE-DOMAIN|Admin Expense domain decision]] (resolved 2026-09-18)\n"
                            "- [[07_Decision_Log/DEC-20260824-WAREHOUSE-AWB-OCR-REGISTRATION|Warehouse AWB registration/domain]] (resolved 2026-09-18)\n"
                            "- [[07_Decision_Log/DEC-20260824-CPD-PATTERN-REGISTRATION|CPD Pattern registration]] (pending)\n"
                            "- [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER|Discovery register]] (vendor assessments, not projects)\n\n"
                            "These notes do not create or duplicate canonical project cards.")

    candidates = {x["code"]: x for x in snapshot["projects"] if x.get("candidate")}
    kept = []
    for node in nodes:
        marker = lib.CANDIDATE_MARKER.search(str(node.get("text", "")))
        if marker:
            item = candidates.get(marker.group(1).strip())
            if item is None:
                continue  # candidate was registered or retired; the project card carries it now
            target = item.get("link_target") or ""
            node["text"] = (f"<!-- PPJ_CANDIDATE_CARD:{item['code']} -->\n\n## [[{target}|{item['code']}]]\n\n"
                            f"Registration: {item.get('registration')}\nDomain: {item.get('domain')}\nLifecycle: {item.get('lifecycle')}\nGate: {item.get('gate')}\n\nNot a pipeline project card until registration is approved.")
        kept.append(node)
    nodes[:] = kept

    result = lib.resolve_canvas(canvas, config, snapshot)
    if result["errors"]:
        raise ValueError("Executive canvas validation failed: " + "; ".join(result["errors"]))
    for code, item in projects.items():
        if result["assignments"].get(code) != item["delivery_stage"] or result["stream_assignments"].get(code) != item["delivery_stream"]:
            raise ValueError(f"Executive canvas placement mismatch for {code}")
    return canvas


def executive_control_canvas() -> str:
    """Patch the live Executive Board (PPJ_Executive_Board_v2.canvas) in place."""
    import ppj_canvas_state_lib as control
    canvas = json.loads(EXEC_BOARD.read_text(encoding="utf-8-sig"))
    patched = patch_executive_canvas(canvas, json.loads(snapshot_json()), control.load_config())
    return json.dumps(patched, ensure_ascii=False, indent=2) + "\n"


def specialized_canvas(name: str) -> str:
    if name == "PPJ_Executive_Board_v2.canvas":
        return executive_control_canvas()
    if name == "PPJ_Portfolio.canvas":
        labels = ["STRATEGIC ACTIVE", "ACTIVE DELIVERY / UAT", "PRODUCTION", "MAINTENANCE / SUPPORT", "ON HOLD / DECISION", "CLOSED", "GOVERNANCE / CANDIDATE"]
        return canvas_doc(name, [(z, [x for x in PORTFOLIO if x.lane == z]) for z in labels])
    if name == "PPJ_Data_Flow.canvas":
        flows = [
            ("FINANCE FOUNDATION", "WFX / Databricks / DWH\n-> Finance Source Control\n-> Rule Engine\n-> OC Control\n-> Factory Performance\n-> Power BI / AI"),
            ("TECHNICAL + COSTING FOUNDATION", "Technical Sources\n-> ETL\n-> Technical Data Layer\n-> Sync\n-> TD_TechnicalKnowledgePlatform\n-> Costing / Pattern / Wash"),
            ("TRANSACTION FOUNDATION", "WFX API\n-> Business Validation\n-> Controlled Transaction\n-> GDI / Future WFX Automation\n-> Audit"),
            ("HR DATA FOUNDATION", "Employee Data\n-> Standardization\n-> Employee Master\n-> Future HR Workflows"),
            ("SOURCING DATA FOUNDATION", "External Supplier / Material Data\n-> Standardization\n-> Sourcing Platform\n-> Sourcing Chatbot"),
        ]
        nodes = [{"id": f"flow-{i}", "type": "text", "text": f"{a}\n\n{b}", "x": i*680, "y": 0, "width": 600, "height": 420} for i,(a,b) in enumerate(flows)]
        return json.dumps({"nodes": nodes, "edges": []}, indent=2) + "\n"
    if name == "PPJ_Roadmap_2026.canvas":
        buckets=[]
        for stream in ("INTERNAL DEVELOPMENT", "EXTERNAL DEVELOPMENT"):
            for delivery_stage in DELIVERY_STAGES:
                values=[f"{x.code} | {x.lifecycle} | {x.gate}" for x in PORTFOLIO if not x.candidate and x.delivery_stream==stream and x.delivery_stage==delivery_stage]
                buckets.append((f"{stream} / {delivery_stage}",values or ["No current registered project"]))
        nodes=[]
        for i,(label,vals) in enumerate(buckets):
            row=i//8; col=i%8
            nodes.append({"id":f"road-{i}","type":"text","text":"## "+label+"\n\n"+"\n".join(f"- {v}" for v in vals),"x":col*660,"y":row*1800,"width":600,"height":max(420,120+len(vals)*90)})
        return json.dumps({"nodes":nodes,"edges":[]},indent=2)+"\n"
    domains = sorted({x.domain for x in PORTFOLIO if not x.candidate and x.domain != "Needs Domain Governance Decision"})
    groups = [(d, [x for x in PORTFOLIO if not x.candidate and x.domain == d]) for d in domains]
    groups.append(("DOMAIN GOVERNANCE REVIEW", [x for x in PORTFOLIO if x.domain == "Needs Domain Governance Decision"]))
    groups.append(("CANDIDATE / CANONICAL CODE PENDING", [x for x in PORTFOLIO if x.candidate and x.domain != "Needs Domain Governance Decision"]))
    return canvas_doc(name, groups)


def local_board(x: Project, task_files: list[Path], staged: dict[Path, str] | None = None) -> str:
    if x.lifecycle == "Closed":
        nodes = [{"id":"summary","type":"text","text":f"{x.code}\n\nDomain: {x.domain}\nDelivery Stream: {x.delivery_stream}\nDelivery Stage: {x.delivery_stage}\nLifecycle: Closed\nStatus: {x.status}\nGate: {x.gate}\nOutcome: {x.outcome}\nLast Verified: {VERIFIED}","x":0,"y":0,"width":720,"height":400}]
        return json.dumps({"nodes":nodes,"edges":[]},indent=2)+"\n"
    lanes = ["BACKLOG", "THIS WEEK", "IN PROGRESS", "BLOCKED / WAITING", "REVIEW / UAT", "DONE"]
    status_lane = {"backlog":0,"this_week":1,"in_progress":2,"blocked":3,"review":4,"done":5}
    nodes=[]
    for i,label in enumerate(lanes):
        nodes.append({"id":f"lane-{i}","type":"group","x":i*600,"y":500,"width":540,"height":max(650,180+len(task_files)*190),"label":label})
    summary = (f"{x.code}\n\nDomain: {x.domain}\nDelivery Stream: {x.delivery_stream}\nDelivery Stage: {x.delivery_stage}\nLifecycle: {x.lifecycle}\nStatus: {x.status}\nProgress: {x.progress}\nGate: {x.gate}\n"
               f"Outcome: {x.outcome}\nTop Blocker: {(x.risks or ['None recorded'])[0]}\nNext Milestone: {(x.next_actions or ['No active milestone'])[0]}\nPriority: {x.priority}\nLast Verified: {VERIFIED}")
    nodes.append({"id":"summary","type":"text","text":summary,"x":0,"y":0,"width":1140,"height":420})
    counts=[0]*6
    for i,path in enumerate(sorted(task_files)):
        text = (staged or {}).get(path, path.read_text(encoding="utf-8-sig") if path.exists() else "")
        m=re.search(r"^status:\s*[\"']?([^\n\"']+)",text,re.M)
        status=(m.group(1).strip() if m else "backlog").lower().replace(" ","_")
        li=status_lane.get(status,0); row=counts[li]; counts[li]+=1
        rel=path.relative_to(ROOT).as_posix()
        nodes.append({"id":f"task-{i}","type":"file","file":rel,"x":li*600+30,"y":570+row*180,"width":480,"height":140})
    return json.dumps({"nodes":nodes,"edges":[]},ensure_ascii=False,indent=2)+"\n"


def task_text(x: Project, idx: int, action: str, status: str) -> str:
    task_id = f"{re.sub(r'[^A-Za-z0-9.-]+','-',x.code)}-20260918-TASK-{idx:03d}"
    return f"""---
type: project_task
project: {yaml_quote(x.code)}
task_id: {yaml_quote(task_id)}
title: {yaml_quote(action)}
status: {yaml_quote(status)}
priority: {yaml_quote(x.priority)}
owner: "Needs Confirmation"
due: ""
source_event: {yaml_quote(EVENT)}
created: {yaml_quote(VERIFIED)}
updated: {yaml_quote(VERIFIED)}
acceptance: "Completion evidence is recorded and reviewed by the responsible business owner."
---

# {action}

## Project

[[../00_Project_Home|{x.code}]]

## Outcome

{x.outcome}

## Acceptance

Completion evidence is recorded and reviewed by the responsible business owner.

## Source

- Source event: `{EVENT}`
- Last verified: `{VERIFIED}`
"""


def candidate_doc(x: Project) -> str:
    return f"""---
type: candidate_initiative
initiative: {yaml_quote(x.code)}
initiative_status: {yaml_quote(x.lifecycle)}
registration_status: {yaml_quote(x.registration)}
primary_domain: {yaml_quote(x.domain)}
source_event: {yaml_quote(EVENT)}
last_verified: {VERIFIED}
---

# {x.code}

{project_section(x)}

This record is intentionally not a canonical root project note.
"""


def decision_doc(decision_id: str, title: str, body: str, status: str = "Pending Decision") -> str:
    footer = ("No domain, code, owner, date or approval should be invented before the decision is recorded."
              if status == "Pending Decision" else "Resolution recorded by the approved portfolio snapshot; the original question is kept above for history.")
    return f"""---
type: decision
decision_id: {decision_id}
status: {status}
source_event: {EVENT}
last_verified: {VERIFIED}
---

# {title}

{body}

{footer}
"""


def plan_report() -> str:
    renamed = sum(1 for x in PORTFOLIO if x.legacy and NEW_STYLE.fullmatch(x.code))
    return f"""# PPJ Portfolio Snapshot Update Plan - {VERIFIED}

- Source Event: `{EVENT}`
- Baseline: 18/09/2026 naming and portfolio baseline (`DEPARTMENT_APPLICATION_vMAJOR.MINOR.PATCH`)
- Mode: idempotent managed-section synchronization; physical filenames and folders are retained
- Canonical records: {sum(not x.candidate for x in PORTFOLIO)} ({renamed} renamed to the new standard)
- Candidate initiatives: {sum(x.candidate for x in PORTFOLIO)}
- Discovery items (outside registry): {len(DISCOVERY)}
- Safety: validate mappings and Canvas JSON, dry-run, back up every changed file, apply without `--force`, audit.

## Synchronization Scope

Snapshot (Markdown + JSON), memory cards, root-note managed regions, existing workspaces, right-sized tasks, local boards, registry overlays with legacy-to-canonical alias mapping, Command Center, domain model additions, discovery register, decision/candidate records, four generated global canvases, an in-place patch of the live Executive Board (`PPJ_Executive_Board_v2.canvas`) and the final audit/report.
"""


def result_report(stats: dict) -> str:
    def group(stage, stream="INTERNAL DEVELOPMENT"):
        return ", ".join(x.code for x in PORTFOLIO if not x.candidate and x.delivery_stage == stage and x.delivery_stream == stream) or "none"
    return f"""# PPJ Portfolio Snapshot Update Result - {VERIFIED}

## Executive Summary

The 18/09/2026 naming and portfolio baseline (`{EVENT}`) is now the authoritative current-state overlay. Canonical codes follow `<DEPARTMENT>_<APPLICATION>_v<MAJOR>.<MINOR>.<PATCH>`; lifecycle is kept outside the project ID; vendor and discovery activity is kept outside the canonical registry. Physical note and folder names are unchanged and resolve through the alias map.

## Delivery Pipeline

- INTERNAL / DEVELOPMENT: {group('DEVELOPMENT')}
- INTERNAL / UAT / PRE-GO-LIVE: {group('UAT / PRE-GO-LIVE')}
- INTERNAL / GO-LIVE / PRODUCTION / SUPPORT: {group('GO-LIVE / PRODUCTION / SUPPORT')}
- EXTERNAL DEVELOPMENT: {', '.join(x.code for x in PORTFOLIO if x.delivery_stream == 'EXTERNAL DEVELOPMENT')}

## Changes From The 2026-08-24 Snapshot

- Registered: WH_AWBExtraction_v1.1.0 (AWB OCR + DHL email extraction, one project).
- Domains added: Administration, Warehouse, Logistics / EXIM.
- Renamed: {sum(1 for x in PORTFOLIO if x.legacy and NEW_STYLE.fullmatch(x.code))} projects (see the Legacy To Canonical Name Map in the current snapshot).
- Stage moves: PUR_GDIAutomation_v1.0.0 to DEVELOPMENT; ADMIN_ExpenseManagement_v1.1.0 to UAT / PRE-GO-LIVE; PUR_HMLabelProcessing_v1.0.0 is On Hold (not Closed); PPJxStratova.AI is Closed (historical).
- Discovery register: {', '.join(d['label'] for d in DISCOVERY)}.

## Applied Updates

- Last apply invocation wrote {stats.get('written', 0)} changed files.
- Memory cards / root notes / workspace documents: {stats.get('memory', 0)} / {stats.get('root', 0)} / {stats.get('workspace', 0)}
- Tasks created / updated / closed: {stats.get('tasks_created', 0)} / {stats.get('tasks_updated', 0)} / {stats.get('tasks_closed', 0)}
- Local boards / global canvases / registry files: {stats.get('local_boards', 0)} / {stats.get('global_canvases', 0)} / {stats.get('registry', 0)}

## Open Items

See `Governance Exceptions` in [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT]].
"""


def audit_script_text() -> str:
    return r'''#!/usr/bin/env python3
import json, pathlib, re, sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
errors=[]; warnings=[]
snap=ROOT/'03_Projects/_Registry/Portfolio_Snapshots/PPJ_PORTFOLIO_SNAPSHOT_20260918.json'
try:
    data=json.loads(snap.read_text(encoding='utf-8-sig'))
except Exception as e:
    errors.append(f"snapshot JSON: {e}"); data={'projects':[]}
codes=[p['code'] for p in data.get('projects',[]) if not p.get('candidate')]
if len(codes)!=len(set(codes)): errors.append('duplicate canonical codes in snapshot')
standard=re.compile(r'^[A-Z]+_[A-Za-z0-9]+_v\d+\.\d+\.\d+$')
for c in codes:
    if '_' in c and not standard.match(c): errors.append(f'canonical code breaks naming standard: {c}')
seen={}
for p in data.get('projects',[]):
    for alias in p.get('legacy',[]):
        if alias in seen and seen[alias]!=p['code']: errors.append(f'alias {alias!r} maps to {seen[alias]} and {p["code"]}')
        seen[alias]=p['code']
for p in data.get('projects',[]):
    if p.get('root_file') and not (ROOT/'03_Projects'/p['root_file']).exists(): errors.append(f'missing root file: {p["code"]} -> {p["root_file"]}')
for path in ROOT.rglob('*'):
    if not path.is_file() or '99_Attachments' in path.parts or '.venv' in path.parts: continue
    if path.suffix.lower() not in ('.md','.canvas','.json','.py','.ps1','.txt'): continue
    try: raw=path.read_bytes(); text=raw.decode('utf-8-sig')
    except UnicodeDecodeError: errors.append(f'not UTF-8: {path.relative_to(ROOT)}'); continue
    placeholder_exempt=(path.name in ('README_PPJ_OBSIDIAN_SYSTEM.md.md','AGENTS.md','PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260918.md','PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260824.md','PLACEHOLDER_PROJECT_CLEANUP_REPORT_20260628.md')
                        or any(part in ('_Templates','_Archive','.github') for part in path.parts))
    if path.suffix in ('.md','.canvas') and not placeholder_exempt:
        for marker in ('PROJECT_NAME','PASTE UPDATE HERE','INTAKE_FILE.md'):
            if marker in text: warnings.append(f'legacy placeholder {marker}: {path.relative_to(ROOT)}')
    if path.suffix=='.canvas':
        try:
            doc=json.loads(text)
            ids=[n.get('id') for n in doc.get('nodes',[])]
            if len(ids)!=len(set(ids)): errors.append(f'duplicate canvas node ids: {path.relative_to(ROOT)}')
            files=[n.get('file') for n in doc.get('nodes',[]) if n.get('type')=='file']
            if len(files)!=len(set(files)): errors.append(f'duplicate canvas file cards: {path.relative_to(ROOT)}')
        except Exception as e: errors.append(f'invalid canvas JSON {path.relative_to(ROOT)}: {e}')
for path in ROOT.rglob('*.md'):
    if '99_Attachments' in path.parts: continue
    text=path.read_text(encoding='utf-8-sig')
    if text.count('<!-- PPJ_PROJECT_KNOWLEDGE_START -->')!=text.count('<!-- PPJ_PROJECT_KNOWLEDGE_END -->'):
        errors.append(f'unpaired project knowledge markers: {path.relative_to(ROOT)}')
fd=next((p for p in data.get('projects',[]) if p['code']=='FAB_FabricDatamart_v2.2.0'),{})
cpd=next((p for p in data.get('projects',[]) if p['code']=='CPD_VisualSampleDatamart_v1.1.0'),{})
if 'Hanger' not in fd.get('outcome','') or '3D' not in cpd.get('outcome',''): errors.append('FAB/CPD scope separation failed')
canvas=ROOT/'03_Projects/Canvas/PPJ_Executive_Board_v2.canvas'
if canvas.exists():
    text=canvas.read_text(encoding='utf-8-sig')
    marks=re.findall(r'PPJ_PROJECT_CARD:([^ >]+(?: [^ >]+)*?) -->',text)
    if sorted(marks)!=sorted(codes): errors.append('Executive Board cards do not match the registered codes in the snapshot')
report=ROOT/'10_Reports/PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260918.md'
report.write_text('# PPJ Portfolio Consistency Audit - 2026-09-18\n\n'
                  f'- Result: **{"PASS" if not errors else "FAIL"}**\n- Errors: {len(errors)}\n- Warnings: {len(warnings)}\n\n'
                  '## Errors\n\n'+('\n'.join(f'- {x}' for x in errors) or '- None')+'\n\n## Warnings\n\n'
                  +('\n'.join(f'- {x}' for x in warnings[:200]) or '- None')+'\n',encoding='utf-8')
print(f"Audit {'PASS' if not errors else 'FAIL'}: {len(errors)} errors, {len(warnings)} warnings")
print(report)
sys.exit(1 if errors else 0)
'''


def long(path: Path) -> Path:
    """Extended-length path so backups of deeply nested task files survive Windows MAX_PATH."""
    if sys.platform == "win32":
        return Path("\\\\?\\" + str(path.resolve()))
    return path


def parse_args():
    ap=argparse.ArgumentParser()
    mode=ap.add_mutually_exclusive_group(); mode.add_argument('--dry-run',action='store_true'); mode.add_argument('--apply',action='store_true')
    for flag in ('all','update-memory','update-root-notes','update-workspaces','update-tasks','update-registry','update-command-center','update-local-boards','update-global-canvases','update-executive-canvas'):
        ap.add_argument('--'+flag,action='store_true')
    ap.add_argument('--force',action='store_true')
    return ap.parse_args()


def main():
    args=parse_args(); apply=args.apply
    selected=any(getattr(args,n.replace('-','_')) for n in ('all','update-memory','update-root-notes','update-workspaces','update-tasks','update-registry','update-command-center','update-local-boards','update-global-canvases','update-executive-canvas'))
    if not selected: args.all=True
    changes: dict[Path,str]={}; categories: dict[Path,str]={}; warnings=[]; hard=[]
    def stage(path: Path, content: str, category: str):
        generated_json = None
        try:
            if path.suffix in ('.json','.canvas'): generated_json=json.loads(content)
        except Exception as e: hard.append(f"Invalid JSON for {path}: {e}"); return
        old=path.read_text(encoding='utf-8-sig') if path.exists() else None
        if old is not None and generated_json is not None:
            try:
                existing_json=json.loads(old)
                if path.suffix=='.canvas':
                    for doc in (existing_json,generated_json):
                        doc.pop('metadata',None)
                        doc['nodes']=sorted(doc.get('nodes',[]),key=lambda n:n.get('id',''))
                        doc['edges']=sorted(doc.get('edges',[]),key=lambda e:e.get('id',''))
                if existing_json==generated_json:
                    return
            except Exception:
                pass
        if old != content: changes[path]=content; categories[path]=category

    # Always stage the fast handoff, plan and reusable audit tooling.
    stage(REGISTRY/'PPJ_PORTFOLIO_CURRENT_SNAPSHOT.md',snapshot_markdown(),'snapshot')
    stage(REGISTRY/'Portfolio_Snapshots'/'PPJ_PORTFOLIO_SNAPSHOT_20260918.json',snapshot_json(),'snapshot')
    stage(REPORTS/'PPJ_PORTFOLIO_SNAPSHOT_UPDATE_PLAN_20260918.md',plan_report(),'report')
    stage(REGISTRY/'PPJ_DISCOVERY_REGISTER.md',discovery_register(),'registry')
    stage(REGISTRY/'PPJ_PORTFOLIO_DOMAIN_MODEL.md',domain_model_text(),'registry')
    stage(ROOT/'scripts'/'audit_ppj_portfolio_consistency.py',audit_script_text(),'script')

    canonical=[x for x in PORTFOLIO if not x.candidate]
    for x in canonical:
        if x.root_file and not (PROJECTS/x.root_file).exists(): hard.append(f"Missing mapped root file: {x.code} -> {x.root_file}")
        if x.workspace and not (PROJECTS/x.workspace).exists(): warnings.append(f"Mapped workspace missing: {x.code} -> {x.workspace}")
        if x.memory_file and not (MEMORY/x.memory_file).exists(): warnings.append(f"Mapped memory missing: {x.code} -> {x.memory_file}")

    if args.all or args.update_memory:
        for x in canonical:
            if not x.memory_file: continue
            path=MEMORY/x.memory_file
            old=path.read_text(encoding='utf-8-sig') if path.exists() else f"---\ntype: project_memory\n---\n\n# Project Memory: {x.code}\n"
            old=update_frontmatter(old,{"project_code":x.code,"canonical_code":x.code,"current_file":x.root_file or "Needs Confirmation","primary_domain":x.domain,"phase":x.delivery_stage,"delivery_stream":x.delivery_stream,"delivery_stage":x.delivery_stage,"status":x.status,"lifecycle":x.lifecycle,"progress":x.progress,"current_gate":x.gate,"priority":x.priority,"current_outcome":x.outcome,"latest_update_summary":x.latest,"known_risks":" | ".join(x.risks) or "None recorded","known_blockers":" | ".join(x.risks) or "None recorded","decisions_needed":" | ".join(x.decisions) or "None recorded","next_actions":" | ".join(x.next_actions) or "No active actions","dependencies":" | ".join(x.dependencies) or "None recorded","stage_entered_date":x.stage_entered_date,"last_verified":VERIFIED,"confidence":x.confidence,"source_event":EVENT,"recent_update_events":[EVENT]})
            stage(path,replace_managed(old,project_section(x),after_frontmatter=True),'memory')

    if args.all or args.update_root_notes:
        for x in canonical:
            if not x.root_file: continue
            path=PROJECTS/x.root_file; old=path.read_text(encoding='utf-8-sig')
            old=update_frontmatter(old,{"project_code":x.code,"canonical_code":x.code,"current_file":x.root_file,"primary_domain":x.domain,"phase":x.delivery_stage,"delivery_stream":x.delivery_stream,"delivery_stage":x.delivery_stage,"status":x.status,"lifecycle":x.lifecycle,"progress":x.progress,"current_gate":x.gate,"priority":x.priority,"stage_entered_date":x.stage_entered_date,"last_verified":VERIFIED,"source_event":EVENT})
            begin='<!-- PPJ_PROJECT_KNOWLEDGE_START -->'; end='<!-- PPJ_PROJECT_KNOWLEDGE_END -->'
            if begin in old and end in old:
                old=re.sub(re.escape(begin)+r'.*?'+re.escape(end),begin+'\n\n'+project_section(x)+'\n'+end,old,flags=re.S)
            else:
                old=old.rstrip()+f"\n\n{begin}\n\n{project_section(x)}\n{end}\n"
            while old.count(end) > old.count(begin):
                old=old.replace(end,'',1)
            stage(path,old.rstrip()+"\n",'root')

    # Candidate, registration and governance records.
    awb=next(x for x in PORTFOLIO if x.code=='WH_AWBExtraction_v1.1.0')
    cpdpat=next(x for x in PORTFOLIO if x.code=='CPD In-house Pattern Generation')
    stage(REGISTRY/'Project_Update_Proposals'/'WAREHOUSE_AWB_OCR_CURRENT_INITIATIVE.md',registered_initiative_doc(awb),'candidate')
    stage(REGISTRY/'Project_Update_Proposals'/'CPD_IN_HOUSE_PATTERN_GENERATION_CURRENT_INITIATIVE.md',candidate_doc(cpdpat),'candidate')
    stage(ROOT/'07_Decision_Log'/'DEC-20260824-ADMIN-EXPENSE-DOMAIN.md',decision_doc('DEC-20260824-ADMIN-EXPENSE-DOMAIN','Admin Expense Primary Domain Governance','Question (2026-08-24): the business owner group is Administration and the capability is Administration Expense & Business Travel Management; decide whether to add/assign an Administration domain and do not force Finance solely because expenses are involved.\n\nResolution (2026-09-18): ADMIN_ExpenseManagement_v1.1.0 is registered under the Primary Domain **Administration**, added to the domain model by the 18/09/2026 baseline.','Resolved'),'decision')
    stage(ROOT/'07_Decision_Log'/'DEC-20260824-WAREHOUSE-AWB-OCR-REGISTRATION.md',decision_doc('DEC-20260824-WAREHOUSE-AWB-OCR-REGISTRATION','Warehouse AWB OCR Registration and Domain','Question (2026-08-24): approve a canonical project code and official primary domain, or retain candidate status.\n\nResolution (2026-09-18): registered as WH_AWBExtraction_v1.1.0 (AWB OCR + DHL email extraction as one project) under the Primary Domain **Warehouse**, added to the domain model by the 18/09/2026 baseline. The root note, memory card and workspace were created through the registration pipeline.','Resolved'),'decision')

    planned_tasks: dict[str,list[Path]]={}
    if args.all or args.update_tasks:
        for x in canonical:
            if not x.workspace: continue
            folder=PROJECTS/x.workspace/'Tasks'; existing=sorted(folder.glob('*.md')) if folder.exists() else []
            planned_tasks[x.code]=list(existing)
            if x.lifecycle=='Closed':
                for path in existing:
                    old=path.read_text(encoding='utf-8-sig')
                    m=re.search(r'^status:\s*[\"\']?([^\n\"\']+)',old,re.M)
                    if m and m.group(1).strip().lower()!='done':
                        new=re.sub(r'^status:.*$', 'status: done', old, count=1, flags=re.M)
                        new=update_frontmatter(new,{"updated":VERIFIED,"source_event":EVENT,"closure_reason":"Project closed by approved portfolio snapshot"})
                        stage(path,new,'task_closed')
                continue
            limit=5 if x.lane in ('STRATEGIC ACTIVE','ACTIVE DELIVERY / UAT') else 3
            actions=x.next_actions[:limit]
            matched=set()
            def norm(value: str) -> str:
                return re.sub(r'[^a-z0-9]+','',value.lower())
            for i,action in enumerate(actions,1):
                action_norm=norm(action)
                match=None
                for old_path in existing:
                    old_text=old_path.read_text(encoding='utf-8-sig')
                    title_match=re.search(r'^title:\s*[\"\']?([^\n\"\']+)',old_text,re.M)
                    if not title_match: continue
                    title_norm=norm(title_match.group(1))
                    if title_norm and (action_norm.startswith(title_norm) or title_norm.startswith(action_norm)):
                        match=old_path
                        break
                status='blocked' if x.lifecycle=='On Hold' else ('this_week' if x.priority in ('P1','P2','P3') else 'backlog')
                if match:
                    matched.add(match)
                    old=match.read_text(encoding='utf-8-sig')
                    old=update_frontmatter(old,{"project":x.code,"title":action,"status":status,"priority":x.priority,"source_event":EVENT,"updated":VERIFIED})
                    stage(match,old,'task_updated')
                    continue
                slug=re.sub(r'[^A-Za-z0-9]+','-',action).strip('-')[:70]
                filename=f"{re.sub(r'[^A-Za-z0-9.-]+','-',x.code)}-20260918-TASK-{i:03d}_{slug}.md"
                path=folder/filename
                stage(path,task_text(x,i,action,status),'task_created' if not path.exists() else 'task_updated')
                if path not in planned_tasks[x.code]: planned_tasks[x.code].append(path)
                matched.add(path)
            for path in existing:
                if path in matched: continue
                old=path.read_text(encoding='utf-8-sig')
                m=re.search(r'^status:\s*[\"\']?([^\n\"\']+)',old,re.M)
                if m and m.group(1).strip().lower()!='done':
                    new=re.sub(r'^status:.*$', 'status: done', old, count=1, flags=re.M)
                    new=update_frontmatter(new,{"updated":VERIFIED,"source_event":EVENT,"closure_reason":"Superseded by current lifecycle and approved action set"})
                    stage(path,new,'task_closed')

    if args.all or args.update_workspaces:
        for x in canonical:
            if not x.workspace: continue
            base=PROJECTS/x.workspace
            if not base.exists(): continue
            home=base/'00_Project_Home.md'
            if home.exists():
                old=update_frontmatter(home.read_text(encoding='utf-8-sig'),{"project":x.code,"source_event":EVENT,"delivery_stream":x.delivery_stream,"delivery_stage":x.delivery_stage,"status":x.status,"stage_entered_date":x.stage_entered_date,"last_verified":VERIFIED,"lifecycle":x.lifecycle,"current_gate":x.gate,"priority":x.priority})
                stage(home,replace_managed(old,project_section(x,workspace=True),after_frontmatter=True),'workspace')
            rels=['01_Management/Project_Profile.md','01_Management/Weekly_Status.md','10_Governance/Change_Log.md']
            if x.lane in ('STRATEGIC ACTIVE','ACTIVE DELIVERY / UAT'):
                rels += ['01_Management/Project_Plan.md','01_Management/Milestones.md']
            if x.risks:
                rels.append('10_Governance/Risks_Issues.md')
            if x.decisions:
                rels.append('10_Governance/Decision_Log.md')
            if x.dependencies:
                rels.append('10_Governance/Dependencies.md')
            for rel in rels:
                path=base/rel
                if path.exists(): stage(path,replace_managed(path.read_text(encoding='utf-8-sig'),workspace_section(x),after_frontmatter=True),'workspace')

    if args.all or args.update_local_boards:
        for x in canonical:
            if not x.workspace: continue
            board=PROJECTS/x.workspace/'Project_Executive_Board.canvas'
            if board.parent.exists():
                files=planned_tasks.get(x.code,sorted((board.parent/'Tasks').glob('*.md')))
                stage(board,local_board(x,files,changes),'local_board')

    if args.all or args.update_registry:
        mapping={
            'PPJ_PROJECT_MEMORY_INDEX.md':'memory','PPJ_PROJECT_REGISTRY.md':'registry',
            'PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md':'domain','PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md':'aliases',
            'PPJ_PROJECT_ALIAS_MAP.md':'aliases','PPJ_PROJECT_RESOURCE_MATRIX.md':'resources'}
        for name,kind in mapping.items():
            path=REGISTRY/name; old=path.read_text(encoding='utf-8-sig') if path.exists() else f"# {name[:-3]}\n"
            stage(path,replace_managed(old,registry_table(kind),after_frontmatter=True),'registry')
        ledger=REGISTRY/'PPJ_PROJECT_UPDATE_LEDGER.md'; old=ledger.read_text(encoding='utf-8-sig')
        if EVENT not in old:
            row=f"| {VERIFIED} | Portfolio | portfolio_snapshot_sync | 18/09/2026 naming and portfolio baseline: canonical names, registrations, stages and discovery register | canonical_code / lifecycle / gate / domain / scope | 2026-08-24 snapshot | Approved 2026-09-18 baseline | {EVENT} | Strong | snapshot / memory / root / workspaces / tasks / boards / registry / canvases | Execute current priorities and pending governance decisions. |"
            renames=[f"| {VERIFIED} | {x.code} | canonical_rename | Canonical name updated to the DEPARTMENT_APPLICATION_vMAJOR.MINOR.PATCH standard; physical file retained | canonical_code | {x.legacy[0]} | {x.code} | {EVENT} | Strong | memory / root / registry / canvases | Resolve legacy name through the alias map. |" for x in PORTFOLIO if x.legacy and NEW_STYLE.fullmatch(x.code)]
            old=old.rstrip()+"\n"+row+"\n"+"\n".join(renames)+"\n"
        stage(ledger,old,'registry')
        module=REGISTRY/'PPJ_PROJECT_MODULE_INDEX.md'
        if module.exists(): stage(module,replace_managed(module.read_text(encoding='utf-8-sig'),registry_table('registry')),'registry')

    if args.all or args.update_command_center:
        stage(PROJECTS/'PROJECT_COMMAND_CENTER.md',command_center(),'command_center')

    if args.update_executive_canvas and not (args.all or args.update_global_canvases):
        stage(EXEC_BOARD,specialized_canvas('PPJ_Executive_Board_v2.canvas'),'global_canvas')
    elif args.all or args.update_global_canvases:
        for name in ('PPJ_Portfolio.canvas','PPJ_Executive_Board_v2.canvas','PPJ_Data_Flow.canvas','PPJ_Roadmap_2026.canvas','PPJ_Domain_Encapsulation.canvas'):
            stage(CANVAS/name,specialized_canvas(name),'global_canvas')

    agents=ROOT/'AGENTS.md'; agent_text=agents.read_text(encoding='utf-8-sig').replace('\x00','0')
    agent_overlay=f"""## Current Portfolio Snapshot Protocol

- Fast current state: `03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT.md`.
- Project read order: `AGENTS.md` -> Current Snapshot -> Memory Index -> Project Memory Card -> Root Project Note -> workspace documents as needed.
- New approved project information updates: memory -> root note -> relevant workspace docs -> tasks -> local board -> registry -> global Canvas when delivery-stage/lifecycle/domain/outcome changes.
- Do not embed full project descriptions in `AGENTS.md`; keep current detail in the snapshot and project layers.
- Canonical naming standard (2026-09-18 baseline): `<DEPARTMENT>_<APPLICATION>_v<MAJOR>.<MINOR>.<PATCH>`; lifecycle/status is never part of the name; vendor names are not used unless the vendor defines the business product; physical filenames are retained and resolved through `PPJ_PROJECT_ALIAS_MAP`.
- Vendor/technology discovery stays in `03_Projects/_Registry/PPJ_DISCOVERY_REGISTER.md` until PPJ approves a scope.
"""
    stage(agents,replace_managed(agent_text,agent_overlay),'agents')

    print(f"Source Event: {EVENT}")
    print(f"Mode: {'APPLY' if apply else 'DRY RUN'}")
    print(f"Canonical projects detected: {len(canonical)}")
    print(f"Root project files resolved: {sum(bool(x.root_file) for x in canonical)}")
    print(f"Candidates/unregistered initiatives: {sum(x.candidate for x in PORTFOLIO)}")
    print("Baseline: 18/09/2026 naming and portfolio baseline (DEPARTMENT_APPLICATION_vMAJOR.MINOR.PATCH)")
    print("Registered by this event: WH_AWBExtraction_v1.1.0; domains added: Administration, Warehouse, Logistics / EXIM")
    print(f"Discovery items outside the registry: {len(DISCOVERY)}")
    for cat in ('memory','root','workspace','task_created','task_updated','task_closed','local_board','global_canvas','registry','command_center','snapshot'):
        print(f"{cat.replace('_',' ').title()} files to update: {sum(v==cat for v in categories.values())}")
    print(f"Hard stops: {len(hard)}")
    for z in hard: print(f"  HARD: {z}")
    print(f"Non-blocking warnings: {len(warnings)}")
    for z in warnings: print(f"  WARN: {z}")
    safe=not hard
    print(f"Safe to Apply: {safe}")
    print(f"Changed files: {len(changes)}")
    if not apply:
        return 0 if safe else 2
    if not safe and not args.force:
        print("Apply blocked by hard stop."); return 2

    stamp=dt.datetime.now().strftime('%Y%m%d_%H%M%S')
    backup=ROOT/'99_Attachments'/'Audit'/'Portfolio_Snapshot_20260918_Backup'/stamp
    canvas_backup=ROOT/'99_Attachments'/'Canvas_Backup'/stamp
    try:
        for path in changes:
            if path.exists():
                dest=(canvas_backup if path.suffix=='.canvas' else backup)/path.relative_to(ROOT)
                long(dest).parent.mkdir(parents=True,exist_ok=True); shutil.copy2(long(path),long(dest))
    except Exception as e:
        print(f"Backup failure: {e}"); return 3
    for path,content in changes.items():
        long(path).parent.mkdir(parents=True,exist_ok=True)
        tmp=long(path.with_name(path.name+'.tmp-20260918'))
        tmp.write_text(content,encoding='utf-8'); tmp.replace(long(path))
    stats={"written":len(changes)}
    for cat,key in [('memory','memory'),('root','root'),('workspace','workspace'),('task_created','tasks_created'),('task_updated','tasks_updated'),('task_closed','tasks_closed'),('local_board','local_boards'),('global_canvas','global_canvases'),('registry','registry'),('command_center','command_center')]:
        stats[key]=sum(v==cat for v in categories.values())
    result=REPORTS/'PPJ_PORTFOLIO_SNAPSHOT_UPDATE_RESULT_20260918.md'
    result.write_text(result_report(stats),encoding='utf-8')
    print(f"Apply completed. Backup path: {backup}")
    print(f"Canvas backup path: {canvas_backup}")
    print(f"Result report: {result}")
    return 0


if __name__=='__main__':
    sys.exit(main())
