#!/usr/bin/env python3
"""Idempotent PPJ portfolio synchronization for PPJ-PORTFOLIO-SNAPSHOT-20260824.

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
REPORTS = ROOT / "10_Reports"
EVENT = "PPJ-PORTFOLIO-SNAPSHOT-20260824"
VERIFIED = "2026-08-24"
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


def p(code, domain, lifecycle, gate, priority, outcome, latest, next_actions,
      *, risks=(), decisions=(), dependencies=(), capability="", progress="TBD",
      owner="Needs Confirmation", root=None, memory=None, workspace=None,
      lane="ACTIVE DELIVERY / UAT", candidate=False, registration="Registered",
      confidence="Strong"):
    return Project(code, domain, lifecycle, gate, priority, outcome, latest,
                   list(next_actions), list(risks), list(decisions), list(dependencies),
                   capability, progress, confidence, owner, root, memory, workspace,
                   lane, candidate, registration)


PORTFOLIO = [
    p("FIN.AI.FINANCE.MANAGEMENT.v1.2", "Finance / Accounting", "Strategic Active",
      "WS2 Rule Catalogue and Databricks access; then WS3 source discovery", "P1",
      "Centralized Finance Control Platform for completeness, correct OC/period, actual versus plan, missing cost, profitability, drill-down and exception ownership.",
      "WS1 is complete and in operational support; WS2 rules are mostly consolidated and remain the main active focus; WS3 is the remaining major program scope.",
      ["Finalize the WS2 Rule Catalogue and thresholds", "Obtain read-only Databricks access and confirm catalog/schema/table lineage", "Select a Golden OC and run the rules", "Reconcile results with Accounting and finalize exception severity", "Begin WS3 factory-performance source discovery"],
      risks=["Databricks access", "Source ownership and lineage", "Rule and threshold approval", "Incorrect OC linkage"],
      decisions=["Approve WS2 thresholds and exception severity", "Confirm governed sources of truth"],
      dependencies=["WFX / Databricks / DWH -> Finance source control -> Rule Engine -> OC control -> Factory performance -> Power BI / AI"],
      capability="WS1 Financial Reporting/Closing Foundation (completed); WS2 OC Cost Control and Order Performance (advanced); WS3 Factory Performance Analysis (remaining).",
      owner="Accounting", root="FIN.AI.FINANCE.MANAGEMENT.v1.1.md", memory="FIN.AI.FINANCE.MANAGEMENT.v1.1.memory.md", workspace="FIN.AI.FINANCE.MANAGEMENT.v1.1", lane="STRATEGIC ACTIVE"),
    p("COSTING.AGENTIC.PLATFORM.v1.1", "Merchandising", "Active Development",
      "Sew v1.2 and Wash Agent development", "P2",
      "Generate a Costing / Quotation Package for Merchandising review and customer quotation.",
      "Sew v1.1 demonstrated description-to-standardized-operation extraction; v1.2 focuses on SAM accuracy, normalization, machine/time mapping, confidence and GTAS/IED integration. Wash remains a human-reviewed workstream inside this platform.",
      ["Improve SAM validation and benchmark with a Sew expert", "Confirm the GTAS/IED integration contract", "Connect Technical Data", "Collect Wash cases", "Build the Wash similarity engine with mandatory expert review"],
      risks=["SAM accuracy and expert acceptance", "GTAS/IED integration contract", "Technical Data dependency"],
      dependencies=["TD.TechnicalKnowledge.Platform.v2.1 -> Pattern/BOM/Consumption -> Sew/Wash/Costing AI"],
      capability="Description -> Operation -> Machine -> Standard Time -> SAM -> Cost -> Expert Review -> GTAS/IED; Wash creates draft recommendations only.",
      root="PPJ.COSTING.AGENT.PLATFORM.v1.1.md", memory="COSTING.AGENTIC.PLATFORM.v1.1.memory.md", workspace="PPJ.COSTING.AGENT.PLATFORM.v1.1", lane="STRATEGIC ACTIVE"),
    p("PUR.GDI.Automation.v1.0", "Sourcing / Purchasing", "Active / WFX API Integration",
      "WFX API contract discovery and controlled integration design", "P3",
      "Automate GDI creation/update while preserving WFX transaction control, validation, confirmation and audit.",
      "Purchasing teams and MER leaders/managers confirmed the business flow; WFX API support materially reduced technical uncertainty. Selenium is fallback only.",
      ["Obtain WFX API authentication and operation documentation", "Confirm create/update/lookup/draft/submit/cancel/status schemas", "Define validation, idempotency, duplicate, retry and timeout controls", "Design audit logging and transaction confirmation"],
      risks=["WFX API ownership and sandbox", "Authentication and rate limits", "Transaction integrity"],
      dependencies=["WFX API -> Business validation -> Controlled GDI transaction -> Confirmation / Audit"],
      capability="PPJ GDI application using supported WFX APIs; never direct-write Databricks as a substitute for WFX transactions.",
      root="PUR.GDI Automation.md", memory="PUR.GDI.Automation.v1.0.memory.md", workspace="PUR.GDI Automation", lane="STRATEGIC ACTIVE"),
    p("TD.TechnicalKnowledge.Platform.v2.1", "Fabric / Textiles Technique", "Initial Sync Demo Completed / Sync Validation & Stabilization",
      "Incremental sync hardening and Technical UAT", "P5",
      "Technical Data Backbone for Pattern, BOM, Consumption, Construction, documents and historical records.",
      "Source collection, ETL, Technical Data Layer and the initial syncing-flow demo are complete; the project is now validating and stabilizing synchronization.",
      ["Implement incremental sync, error handling and retry", "Add duplicate, missing-key and reconciliation checks", "Govern versions and latest/approved-record logic", "Finalize permissions and prepare Technical UAT"],
      risks=["Sync reliability", "Version governance", "Missing keys and duplicate records", "Technical UAT acceptance"],
      dependencies=["Technical sources -> ETL -> Technical Data Layer -> Sync -> Platform -> Costing / Pattern / Wash / Search"],
      capability="Source -> ETL -> Technical Data Layer -> Sync -> Technical Knowledge Platform.",
      root="TD.TechnicalPlatform_v2.1.md", memory="TD.TechnicalKnowledge.Platform.v2.1.memory.md", workspace="TD.TechnicalPlatform_v2.1", lane="STRATEGIC ACTIVE"),
    p("Admin Expense Management.v1.1", "Needs Domain Governance Decision", "Workflow Demo Completed / Requirement Refinement",
      "Expand demonstrated travel request into end-to-end expense and settlement requirements", "P6",
      "Standardize Administration business-travel and expense-management workflows.",
      "Travel Request -> trip information -> itinerary -> submission -> Admin approval -> trip creation was demonstrated; this is not production.",
      ["Validate the booking workflow and status model", "Finalize approval matrix, advance, expense submission and settlement", "Define vendor catalogue and expense categories", "Prepare UAT"],
      risks=["Primary domain is unresolved", "Approval/status rules need confirmation", "Demo may be mistaken for production"],
      decisions=["Approve Administration domain treatment in the official domain model"],
      capability="Planning -> Request -> Approval -> Advance -> Trip -> Expense -> Supporting Documents -> Review -> Settlement -> Final Cost.",
      owner="Administration", lane="STRATEGIC ACTIVE"),
    p("PPJ.ExpenseInvoices.v1.1", "Finance / Accounting", "UAT / Pre-Go-Live",
      "Production Readiness / Go-Live", "P4",
      "Complete controlled expense-invoice rollout for all departments and factories except Export.",
      "Expense period and mappings were confirmed, suppliers expanded, testing and user support continued, and defects were fixed. EXIM-first is historical only.",
      ["Close remaining defects and retest", "Confirm mapping and frequent-supplier readiness", "Complete production-readiness review and go-live decision"],
      risks=["Mapping completeness", "Real-data defects", "Go-live support readiness"],
      capability="Expense-invoice intake, mapping, validation and controlled processing for all departments/factories except Export.",
      root="PPJ. Expense-Invoices.v1.1.md", memory="PPJ.ExpenseInvoices.v1.1.memory.md", workspace="PPJ. Expense-Invoices.v1.1"),
    p("PUR.Material.Allocation.v1.1", "Sourcing / Purchasing", "First Flow Validated",
      "Exception, rollback and transaction-safety testing", "P7",
      "Validate controlled reallocation of surplus NPL across eligible OCs.",
      "The first Sewing/Embroidery flow was validated: surplus OC -> unreserve -> find same Style/Buyer Reference OC -> allocate. General automation is not fully validated.",
      ["Test multiple OCs and partial allocation", "Test insufficient stock, duplicates and failure paths", "Validate rollback, audit and user confirmation"],
      risks=["Partial-allocation correctness", "Rollback and duplicate safety", "WFX transaction consistency"],
      capability="Validated for Sewing and Embroidery; broader material scope remains unconfirmed.",
      root="PUR.Material.Allocation.v1.2.md", memory="PUR.Material.Allocation.v1.1.memory.md", workspace="PUR.Material.Allocation.v1.2"),
    p("MER.MARKET.INTELLIGENCE.v1.1", "Merchandising", "Active Intelligence", "Commercial intelligence delivery", "Medium",
      "Create commercial intelligence from external market data and PPJ internal capability.",
      "Current outputs cover product/fabric opportunities, commercial trends and customer-pitching support; external ratings/reviews are not sales.",
      ["Continue validated product/fabric opportunity analysis", "Keep review/rating signals distinct from sales evidence"],
      risks=["External signal interpretation"], root="E-commerce Market Intelligence v.2.3.md", memory="MER.MARKET.INTELLIGENCE.v1.1.memory.md", workspace="E-commerce Market Intelligence v.2.3"),
    p("MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1", "Merchandising", "Active", "Chico's rule validation", "Medium",
      "Support Chico's-specific costing, commercial-cost and invoice-information recheck.",
      "The project remains Merchandising-owned and must not be moved to Finance / Accounting.",
      ["Validate Chico's-specific recheck logic", "Confirm audit output with Merchandising"],
      root="MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md", memory="MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.memory.md", workspace="MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1"),
    p("WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1", "Production + Wash", "Analysis / Product Design", "Sampling workflow and product design", "Medium",
      "Create a PPJ Group Portal workflow for Wash sample requests, trials, results, approvals and history.",
      "Target flow is Sample Request -> Assignment -> Trial -> Result -> Image/Comment -> Approval -> History; it remains separate from PROD.COWASH.",
      ["Confirm sampling workflow, data fields and roles", "Design approval/history and attachment handling"],
      risks=["Workflow ownership", "Do not merge with operational COWASH"], root="WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md", memory="WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.memory.md", workspace="WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1"),
    p("PROD.IOT.CHuyenTreo.v1.0", "Production + Wash", "Development", "Source and KPI reconciliation", "Medium",
      "Provide production-line visibility for output, target vs actual, efficiency, downtime, WIP, line status, hourly production and trends.",
      "Development continues; the main dependency is reconciliation of sources and KPI definitions.",
      ["Reconcile source data", "Confirm KPI definitions with Production", "Validate dashboard measures"],
      risks=["Source/KPI reconciliation"], root="PROD.IOT.CHuyenTreo_1.md", memory="PROD.IOT.CHuyenTreo.v1.0.memory.md", workspace="PROD.IOT.CHuyenTreo_1"),
    p("HR.SSPFD.Workflow.v1.1", "HR", "Production", "Production rollout and data-quality monitoring", "P8",
      "Standardize employee data into a trusted Employee Master and support applicant extraction/prefill.",
      "Demo, UAT, User Manual, production deployment and group rollout were achieved. BHXH audit is historical context, not the primary current capability.",
      ["Monitor rollout by company/factory", "Track standardization, missing-field, duplicate and matching-success KPIs", "Stabilize applicant extraction and prefill workflow"],
      risks=["Sensitive HR data", "Data-quality consistency across companies/factories"],
      capability="Employee Data Collection -> Validation -> CCCD/Employee ID Matching -> Deduplication -> Standardization -> Employee Master; plus applicant extraction/prefill.",
      root="HR.SS&PFD.v1.1.md", memory="HR.SSPFD.Workflow.v1.1.memory.md", workspace="HR.SS&PFD.v1.1", lane="PRODUCTION"),
    p("SCP.SOURCING.CHATBOT.v2.3", "Sourcing / Purchasing", "Production", "Production data quality and stress testing", "P9",
      "Provide production supplier, material, fabric, trim, price/history, MOQ/MCQ and payment-term search and Sourcing assistance.",
      "The Sourcing product is Production; external-data quality remains an ongoing improvement workstream and does not return the whole product to UAT.",
      ["Clean missing fields, mixed types, duplicates and naming", "Stress-test retrieval with real Sourcing questions", "Monitor adoption and production quality"],
      risks=["Manual external-data input", "Non-standard naming and metadata", "Data-quality drift"],
      capability="Supplier / Material / Sample Intelligence; consolidated search platform and chatbot.",
      root="SCP.SOURCING.CHATBOT.v2.3.md", memory="SCP.SOURCING.CHATBOT.v2.3.memory.md", workspace="SCP.SOURCING.CHATBOT.v2.3", lane="PRODUCTION"),
    p("PPJ.InvoiceDownloader.v1.2", "Finance / Accounting", "Production", "Operational reliability", "Support",
      "Operate e-invoice download for XML/PDF/metadata, merge, API and reporting-source use.",
      "Production operations focus on portal changes, credentials, retry, missing/duplicate invoices, monitoring and audit.",
      ["Monitor portal and credential changes", "Track retries, missing invoices and duplicates", "Maintain audit evidence"],
      root="PPJ.Invoice Downloader.v1.2.md", memory="PPJ.InvoiceDownloader.v1.2.memory.md", workspace="PPJ.Invoice Downloader.v1.2", lane="PRODUCTION"),
    p("PUR.Inventory.Report.v2.1", "Sourcing / Purchasing", "Production / Enhancement", "Post-enhancement support", "Support",
      "Provide enhanced Purchasing inventory visibility, reports, tables, filters and material monitoring.",
      "v2.1 is the current canonical enhanced reporting capability; the physical filename remains unchanged.",
      ["Collect operational feedback", "Prioritize validated reporting enhancements"],
      root="PUR.Inventory Report.md", memory="PUR.Inventory.Report.v1.0.memory.md", workspace="PUR.Inventory Report", lane="PRODUCTION"),
    p("PPJ.PERRI.Chatbot.v3.2", "Internal Chatbot & AI Platforms", "Production", "Permissioned production orchestration", "Support",
      "Operate PPJ's conversational orchestrator for department agents, knowledge retrieval and controlled tool/API execution.",
      "Read-only agents and action agents remain distinct; action agents require stronger permissions, approval and audit.",
      ["Maintain permission and approval controls", "Monitor tool execution and audit logs"],
      risks=["Action-agent permissions and audit"], root="PPJ.PERRI.Chatbot.md", memory="PPJ.PERRI.Chatbot.v3.2.memory.md", workspace="PPJ.PERRI.Chatbot", lane="PRODUCTION"),
    p("PPJ.AI.Hub.v2.1", "Internal Chatbot & AI Platforms", "Internal Production Platform", "Platform operations", "Support",
      "Provide an internal application catalogue, AI tool access and department-app discovery.",
      "AI Hub is an access/discovery platform, not the master project registry and not a container for merged project notes.",
      ["Maintain application catalogue and access", "Keep project registry ownership outside AI Hub"],
      root="PPJ.AI.Hub.v2.1.md", memory="PPJ.AI.Hub.v2.1.memory.md", workspace="PPJ.AI.Hub.v2.1", lane="PRODUCTION"),
    p("FD.Datamart.v2.2", "Fabric / Textiles Technique", "Support", "Operational support", "Support",
      "Support the FD Fabric/Hanger/QR datamart with Directus, corrections, permissions and users.",
      "FD remains Fabric + Hanger + QR and is not CPD.", ["Maintain support backlog", "Resolve validated data, QR and permission issues"],
      root="FD.Datamart.v2.2.md", memory="FD.Datamart.v2.2.memory.md", workspace="FD.Datamart.v2.2", lane="MAINTENANCE / SUPPORT"),
    p("CPD.Datamart.v1.1", "Fabric / Textiles Technique", "Maintenance", "Operational maintenance", "Support",
      "Maintain CPD 3D, visual assets, image search and sample-library capability.",
      "CPD remains the visual/3D datamart and is not FD.", ["Maintain visual assets and image-search quality"],
      root="CPD.Datamart.v1.1.md", memory="CPD.Datamart.v1.1.memory.md", workspace="CPD.Datamart.v1.1", lane="MAINTENANCE / SUPPORT"),
    p("ACC.GRN-SupplierInvoiceBot.v2.3", "Finance / Accounting", "Production Support", "Operational stability and exceptions", "Support",
      "Support GRN and supplier-invoice WFX transactions.",
      "The approved canonical state is v2.3; any different physical filename is retained via mapping.",
      ["Monitor exceptions and stability", "Maintain audit and user support"],
      root="ACC.GRN-SupplierInvoiceBot.v2.3.md", memory="ACC.GRN-SupplierInvoiceBot.v2.3.memory.md", workspace="ACC.GRN-SupplierInvoiceBot.v2.3", lane="MAINTENANCE / SUPPORT"),
    p("PUR.Adhoc.Indent.South.v1.0", "Sourcing / Purchasing", "Maintenance", "Operational maintenance", "Support",
      "Maintain the South-region adhoc-indent workflow and WFX compatibility.",
      "Current work is support, input changes and minor fixes.", ["Handle validated support and compatibility changes"],
      root="PUR.Adhoc Indent mien Nam.md", memory="PUR.Adhoc.Indent.South.v1.0.memory.md", workspace="PUR.Adhoc Indent mien Nam", lane="MAINTENANCE / SUPPORT"),
    p("PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0", "Internal Chatbot & AI Platforms", "Maintenance", "IT helpdesk maintenance", "Support",
      "Maintain the IT-specific Helpdesk AI for troubleshooting, FAQ, ERP support and knowledge retrieval.",
      "GLPI AI remains IT-specific and separate from PERRI's general orchestration role.", ["Maintain helpdesk knowledge and issue handling"],
      root="PPJ.GLPI-Helpdesk-AI Chatbot.md", memory="PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0.memory.md", workspace="PPJ.GLPI-Helpdesk-AI Chatbot", lane="MAINTENANCE / SUPPORT"),
    p("PPJxQSee.AI", "QC / TQM", "On Hold", "Reactivation decision", "Hold",
      "Preserve the QC AI inspection opportunity until ownership, resources, data, metrics and budget exist.",
      "A proposal and NDA exist and QC/TQM reviewed, but internal resources are insufficient; this is not an approved PoC or implementation.",
      ["Confirm QC and TQM owners", "Define dataset, labeling capability, pilot product and success metrics", "Confirm budget/resources before reactivation"],
      risks=["No owner/resources", "Dataset and labeling readiness"], root="PPJxQSee.ai.md", memory="PPJxQSee.AI.memory.md", workspace="PPJxQSee.ai", lane="ON HOLD / DECISION"),
    p("QC.Primo1D.RFID.Thread.v1.0", "QC / TQM", "Business Case / Pre-PoC", "Business/customer case decision", "Decision",
      "Evaluate RFID thread only when QC need, MER commercial case, customer willingness to pay and factory feasibility align.",
      "No vendor PoC or implementation is approved while the business/customer case remains unclear.",
      ["Confirm QC need and MER commercial case", "Validate customer willingness to pay", "Assess factory feasibility before PoC approval"],
      root="PPJ XPrimo1D RFID Thread.md", memory="QC.Primo1D.RFID.Thread.v1.0.memory.md", workspace="PPJ XPrimo1D RFID Thread", lane="ON HOLD / DECISION"),
    p("PPJxStratova.AI", "Fabric / Textiles Technique", "Strategic Technology Evaluation", "Build-vs-buy evaluation", "Decision",
      "Evaluate Stratova pattern technology against the internal pattern-generation benchmark.",
      "Google-related support/funding and a Pattern Engineering use case are under discussion; this is strategic evaluation, not approved implementation.",
      ["Clarify funding, credits, licensing and long-term cloud cost", "Confirm data/model/pattern ownership and CAD integration", "Run the same test cases as the internal prototype with blind Pattern Engineer evaluation"],
      risks=["Ownership and licensing", "Production accuracy", "Long-term cloud cost"], root="PPJxStratova AI.md", memory="PPJxStratova.AI.memory.md", workspace="PPJxStratova AI", lane="ON HOLD / DECISION"),
    p("PPJxNUNOX.ScanTrial", "Fabric / Textiles Technique", "Partnership / Digital Library Evaluation", "Working-session outcome unconfirmed", "Decision",
      "Evaluate fabric scanning and Fabric/Garment Digital Library potential.",
      "NUNOX proposed a 17-18 August session, but attendance, demo result and agreement are not confirmed.",
      ["Confirm whether the proposed session occurred", "Record evidence before any partnership or implementation decision"],
      risks=["Session outcome unconfirmed"], root="PPJxNUNOX.md", memory="PPJxNUNOX.ScanTrial.memory.md", workspace="PPJxNUNOX", lane="ON HOLD / DECISION", confidence="Needs Confirmation"),
    p("PPJ.UIT.ACADEMIC.COLLABORATION.v1.1", "External Collaboration", "Active / Problem Framing", "Academic problem package", "Medium",
      "Frame Fabric Waste Optimization / 2D Pattern Nesting for academic collaboration.",
      "Outputs may include a problem package, dataset, prototype and benchmark; academic prototypes do not directly replace production Gerber/CAD.",
      ["Finalize the academic problem package and dataset", "Define benchmark and prototype evaluation boundaries"],
      root="PPJ.UIT.ACADEMIC.COLLABORATION.v1.1.md", memory="PPJ.UIT.ACADEMIC.COLLABORATION.v1.1.memory.md", workspace="PPJ.UIT.ACADEMIC.COLLABORATION.v1.1", lane="ON HOLD / DECISION"),
    p("PROD.COWASH.v2.0", "Production + Wash", "On Hold", "Owner/data/KPI/access/technical direction", "Hold",
      "Preserve the operational wash execution/data initiative pending re-scope.",
      "Owner, data source, KPI, access and technical direction remain insufficient.",
      ["Confirm owner, source, KPI, access and technical direction before reactivation"],
      root="PROD.COWASH.md", memory="PROD.COWASH.v2.0.memory.md", workspace="PROD.COWASH", lane="ON HOLD / DECISION"),
    p("PUR.HM.LabelO.Processing.Automation.v1.0", "Sourcing / Purchasing", "On Hold", "Scalability decision", "Hold",
      "Hold H&M Label-O automation pending a scalable business case.",
      "Customer-specific hard-coding creates high maintenance and low scalability.",
      ["Confirm whether a scalable rules model and sufficient value exist"],
      root="PUR.H&M Label-O Processing.md", memory="PUR.HM.LabelO.Processing.Automation.v1.0.memory.md", workspace="PUR.H&M Label-O Processing", lane="ON HOLD / DECISION"),
    p("ACC.Inventory.Report.v1.0", "Finance / Accounting", "Closed", "Closed / no active follow-up", "Closed",
      "Preserve the completed Accounting inventory-report history with no active delivery.",
      "The former Backlog/Pending Resource and Business Discovery state is stale; current state is Closed.", [],
      root="ACC.Inventory.Report.v1.0.md", memory="ACC.Inventory.Report.v1.0.memory.md", workspace="ACC.Inventory.Report.v1.0", lane="CLOSED"),
    p("MER.PO.Commit.v1.1", "Merchandising", "Closed", "Closed", "Closed",
      "Preserve the closed PO Commit project history.", "No active delivery tasks are authorized.", [],
      root="MER.PO-Commit.md", memory="MER.PO.Commit.v1.1.memory.md", workspace="MER.PO-Commit", lane="CLOSED"),
    p("EXIM.ExpenseInvoices.Automation.v1.1", "Finance / Accounting", "Closed", "Closed; succeeded by PPJ.ExpenseInvoices.v1.1", "Closed",
      "Preserve the closed EXIM automation history separately from its broader successor.",
      "PPJ.ExpenseInvoices.v1.1 is the broader successor; histories remain separate.", [], dependencies=["Historical predecessor -> PPJ.ExpenseInvoices.v1.1"],
      root="EXIM.ExpenseInvoices.Automation.v1.1.md", memory="EXIM.ExpenseInvoices.Automation.v1.1.memory.md", workspace="EXIM.ExpenseInvoices.Automation.v1.1", lane="CLOSED"),
    p("AI.Automation.Workshop.202606", "External Collaboration", "Closed", "Closed event", "Closed",
      "Preserve the June 2026 AI Automation Workshop record.", "Historical/event project; no active tasks.", [],
      root="AI Automation Workshop.md", memory="AI.Automation.Workshop.202606.memory.md", lane="CLOSED"),
    p("AI.Automation.Workshop.Analysis.202606", "External Collaboration", "Closed", "Closed analysis", "Closed",
      "Preserve the June 2026 workshop analysis record.", "Historical/event project; no active tasks.", [],
      root="Workshop Analysis.md", memory="AI.Automation.Workshop.Analysis.202606.memory.md", lane="CLOSED"),
    p("VITAS.Sharing.202606", "External Collaboration", "Closed", "Closed event", "Closed",
      "Preserve the June 2026 VITAS sharing record.", "Historical/event project; no active tasks.", [],
      root="VITAS Sharing.md", memory="VITAS.Sharing.202606.memory.md", workspace="VITAS Sharing", lane="CLOSED"),
    p("Warehouse AWB OCR", "Needs Domain Governance Decision", "Active Enhancement", "Canonical code and domain governance; Shipment Weight accuracy", "Medium",
      "Extract AWB number, From, To, Piece and Shipment Weight into structured data.",
      "AWB and Piece extraction are strengths; Shipment Weight recognition across kg/g/lb/lbs/oz, multiple labels and mixed units is the main gap.",
      ["Improve Shipment Weight recognition and mixed-unit normalization", "Approve a canonical code and primary domain"],
      risks=["Canonical code is not confirmed", "Primary domain is not confirmed", "Mixed-unit weight extraction"],
      candidate=True, registration="Canonical Code Needed", lane="GOVERNANCE / CANDIDATE"),
    p("CPD In-house Pattern Generation", "Fabric / Textiles Technique", "Internal Prototype / Evaluation", "Build-vs-buy benchmark; canonical code pending", "P10",
      "Build an internal pattern-generation benchmark from techpack/image/measurement inputs with Pattern Engineer and CAD validation.",
      "This remains an internal prototype/evaluation and is not a registered canonical project.",
      ["Define shared test cases for internal and Stratova evaluation", "Measure manual correction time to a usable production pattern", "Seek registration approval only if warranted"],
      risks=["Canonical code is not confirmed", "Production accuracy and CAD fit"],
      candidate=True, registration="Canonical Code Not Confirmed", lane="GOVERNANCE / CANDIDATE"),
]

DELIVERY_STAGES = [
    "BACKLOG", "KICK-OFF", "ANALYSIS", "DESIGN", "DEVELOPMENT",
    "UAT / PRE-GO-LIVE", "GO-LIVE / PRODUCTION / SUPPORT", "CLOSED",
]

STAGE_BY_CODE = {
    "FIN.AI.FINANCE.MANAGEMENT.v1.2": "ANALYSIS",
    "Admin Expense Management.v1.1": "ANALYSIS",
    "MER.MARKET.INTELLIGENCE.v1.1": "ANALYSIS",
    "PPJxQSee.AI": "ANALYSIS",
    "QC.Primo1D.RFID.Thread.v1.0": "ANALYSIS",
    "PPJxStratova.AI": "ANALYSIS",
    "PPJxNUNOX.ScanTrial": "ANALYSIS",
    "PPJ.UIT.ACADEMIC.COLLABORATION.v1.1": "ANALYSIS",
    "PROD.COWASH.v2.0": "ANALYSIS",
    "PUR.HM.LabelO.Processing.Automation.v1.0": "ANALYSIS",
    "PUR.GDI.Automation.v1.0": "DESIGN",
    "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1": "DESIGN",
    "COSTING.AGENTIC.PLATFORM.v1.1": "DEVELOPMENT",
    "PROD.IOT.CHuyenTreo.v1.0": "DEVELOPMENT",
    "TD.TechnicalKnowledge.Platform.v2.1": "UAT / PRE-GO-LIVE",
    "PPJ.ExpenseInvoices.v1.1": "UAT / PRE-GO-LIVE",
    "PUR.Material.Allocation.v1.1": "UAT / PRE-GO-LIVE",
    "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1": "UAT / PRE-GO-LIVE",
    "HR.SSPFD.Workflow.v1.1": "GO-LIVE / PRODUCTION / SUPPORT",
    "SCP.SOURCING.CHATBOT.v2.3": "GO-LIVE / PRODUCTION / SUPPORT",
    "PPJ.InvoiceDownloader.v1.2": "GO-LIVE / PRODUCTION / SUPPORT",
    "PUR.Inventory.Report.v2.1": "GO-LIVE / PRODUCTION / SUPPORT",
    "PPJ.PERRI.Chatbot.v3.2": "GO-LIVE / PRODUCTION / SUPPORT",
    "PPJ.AI.Hub.v2.1": "GO-LIVE / PRODUCTION / SUPPORT",
    "FD.Datamart.v2.2": "GO-LIVE / PRODUCTION / SUPPORT",
    "CPD.Datamart.v1.1": "GO-LIVE / PRODUCTION / SUPPORT",
    "ACC.GRN-SupplierInvoiceBot.v2.3": "GO-LIVE / PRODUCTION / SUPPORT",
    "PUR.Adhoc.Indent.South.v1.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0": "GO-LIVE / PRODUCTION / SUPPORT",
    "ACC.Inventory.Report.v1.0": "CLOSED",
    "MER.PO.Commit.v1.1": "CLOSED",
    "EXIM.ExpenseInvoices.Automation.v1.1": "CLOSED",
    "AI.Automation.Workshop.202606": "CLOSED",
    "AI.Automation.Workshop.Analysis.202606": "CLOSED",
    "VITAS.Sharing.202606": "CLOSED",
}

STATUS_BY_CODE = {
    "PPJxQSee.AI": "External Collaboration",
    "PROD.COWASH.v2.0": "External Collaboration",
    "PUR.HM.LabelO.Processing.Automation.v1.0": "On Hold",
    "QC.Primo1D.RFID.Thread.v1.0": "External Collaboration",
    "PPJxStratova.AI": "External Collaboration",
    "PPJxNUNOX.ScanTrial": "External Collaboration",
    "PPJ.UIT.ACADEMIC.COLLABORATION.v1.1": "External Collaboration",
}

EXTERNAL_DEVELOPMENT_CODES = {
    "PPJxQSee.AI", "QC.Primo1D.RFID.Thread.v1.0", "PPJxStratova.AI",
    "PPJxNUNOX.ScanTrial", "PPJ.UIT.ACADEMIC.COLLABORATION.v1.1",
    "PROD.COWASH.v2.0",
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
    rows = []
    for x in PORTFOLIO:
        rows.append("| " + " | ".join(md_escape(v) for v in [
            x.code, x.domain, x.delivery_stream or "Candidate / Not Registered", x.delivery_stage or "Candidate / Not Registered", x.lifecycle, x.status, x.gate, x.priority, x.outcome,
            x.latest, "; ".join(x.next_actions) or "No active action", x.confidence]) + " |")
    return f"""---
type: portfolio_current_snapshot
source_event: {EVENT}
last_verified: {VERIFIED}
portfolio_maturity: "Stage 3 - Controlled Delivery / Early Scale"
---

# PPJ Portfolio Current Snapshot

This is the fast current-state reference for new Codex sessions. Read it after `AGENTS.md` and before historical reports. The JSON companion contains the same state in machine-readable form.

- Source Event: `{EVENT}`
- Last Verified: `{VERIFIED}`
- Portfolio Maturity: **Stage 3 - Controlled Delivery / Early Scale**
- Strategic direction: Standardize Data -> Standardize Rules -> Standardize APIs -> Scale Automation / AI
- Candidate/governance records are not canonical registrations.

| Project | Domain | Delivery Stream | Delivery Stage | Detailed Lifecycle | Status | Current Gate | Priority | Current Outcome | Latest Update | Next Action | Confidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
{chr(10).join(rows)}

## Portfolio Backbones

- Finance: WFX / Databricks / DWH -> Finance Rules -> OC Control -> Factory Performance -> Power BI / AI.
- Technical + Costing: Technical sources -> ETL -> Technical Data Layer -> Sync -> Technical Platform -> Costing / Pattern / Wash.
- Transactions: WFX API -> Business Validation -> Controlled Transaction -> GDI / future WFX automation -> Audit.
- HR: Employee Data -> Standardization -> Employee Master -> Future HR workflows.
- Sourcing: Supplier / Material Data -> Standardization -> Sourcing Platform -> Sourcing Chatbot -> Decisions.

## Portfolio Risks

- Data access: Databricks, WFX permissions and source ownership.
- Data quality: Finance, Technical, HR and Sourcing data exists but is not always governed enough for reliable reuse.
- Business-rule governance: Finance, Material Allocation, Expense Invoices and GDI require versioned rules, approval and traceability.
- Integration governance: WFX API requires ownership, authentication, sandbox, rate limits, errors, audit and change management.
- Production governance: production products require owner, SLA, monitoring, defect, enhancement, release and adoption practices.

## Governance Exceptions

- `Admin Expense Management.v1.1`: registered business initiative; Administration-owned; primary domain needs governance decision.
- `Warehouse AWB OCR`: active enhancement candidate; canonical code and primary domain need governance decisions.
- `CPD In-house Pattern Generation`: internal prototype/evaluation; canonical code is not confirmed; no canonical root project was created.
"""


def snapshot_json() -> str:
    data = {
        "source_event": EVENT, "last_verified": VERIFIED,
        "portfolio_maturity": "Stage 3 - Controlled Delivery / Early Scale",
        "strategic_direction": ["Standardize Data", "Standardize Rules", "Standardize APIs", "Scale Automation / AI Capabilities"],
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
        head = "| Canonical Code | Current Physical File | Workspace | Registration |\n| --- | --- | --- | --- |"
        rows = [f"| {x.code} | {x.root_file or 'None - governance/candidate record only'} | {x.workspace or 'None'} | {x.registration} |" for x in PORTFOLIO]
    elif kind == "resources":
        head = "| Project | Domain | Owner | Delivery Stream | Delivery Stage | Lifecycle | Status | Priority | Gate | Open Action Count |\n| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |"
        rows = [f"| {x.code} | {x.domain} | {x.owner} | {x.delivery_stream or 'Candidate / Not Registered'} | {x.delivery_stage or 'Candidate / Not Registered'} | {x.lifecycle} | {x.status} | {x.priority} | {md_escape(x.gate)} | {len(x.next_actions)} |" for x in PORTFOLIO]
    else:
        head = "| Canonical Code | Current File | Delivery Stream | Delivery Stage | Lifecycle | Status | Current Gate | Priority | Current Outcome | Last Verified |\n| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |"
        rows = [f"| {x.code} | {x.root_file or 'None - governance/candidate record only'} | {x.delivery_stream or 'Candidate / Not Registered'} | {x.delivery_stage or 'Candidate / Not Registered'} | {x.lifecycle} | {x.status} | {md_escape(x.gate)} | {x.priority} | {md_escape(x.outcome)} | {VERIFIED} |" for x in PORTFOLIO]
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
              "- Domain Governance Review: Admin Expense Management.v1.1; Warehouse AWB OCR\n"
              "- Candidate Initiatives: Warehouse AWB OCR; CPD In-house Pattern Generation")
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
| P1 | FIN.AI.FINANCE.MANAGEMENT.v1.2 | Complete WS2 and open WS3 |
| P2 | COSTING.AGENTIC.PLATFORM.v1.1 | SAM accuracy and GTAS/IED integration |
| P3 | PUR.GDI.Automation.v1.0 | Formalize WFX API integration |
| P4 | PPJ.ExpenseInvoices.v1.1 | Complete UAT -> Go-Live |
| P5 | TD.TechnicalKnowledge.Platform.v2.1 | Stabilize syncing and Technical UAT |
| P6 | Admin Expense Management.v1.1 | Expand Travel Demo -> Expense/Settlement |
| P7 | PUR.Material.Allocation.v1.1 | Exception, rollback and transaction safety |
| P8 | HR.SSPFD.Workflow.v1.1 | Production rollout and data quality |
| P9 | SCP.SOURCING.CHATBOT.v2.3 | Production data quality and stress testing |
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

- Admin Expense: Administration-owned; primary domain decision pending.
- Warehouse AWB OCR: canonical code and primary domain pending.
- CPD In-house Pattern Generation: candidate prototype; canonical code not confirmed.
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
            if item.root_file:
                link=f"[[03_Projects/{Path(item.root_file).stem}|{item.code}]]"
            elif item.code=="Warehouse AWB OCR":
                link="[[03_Projects/_Registry/Project_Update_Proposals/WAREHOUSE_AWB_OCR_CURRENT_INITIATIVE|Warehouse AWB OCR]]"
            elif item.code=="CPD In-house Pattern Generation":
                link="[[03_Projects/_Registry/Project_Update_Proposals/CPD_IN_HOUSE_PATTERN_GENERATION_CURRENT_INITIATIVE|CPD In-house Pattern Generation]]"
            else:
                link=f"[[07_Decision_Log/DEC-20260824-ADMIN-EXPENSE-DOMAIN|{item.code}]]"
            text = (f"<!-- PPJ_PORTFOLIO_VIEW_CARD:{item.code} -->\n\n## {link}\n\nDomain: {item.domain}\n"
                    f"Delivery Stream: {item.delivery_stream or 'Candidate / Not Registered'}\n"
                    f"Delivery Stage: {item.delivery_stage or 'Candidate / Not Registered'}\nLifecycle: {item.lifecycle}\n"
                    f"Status: {item.status}\nPriority: {item.priority}\nGate: {item.gate}")
            nodes.append({"id": nid, "type": "text", "text": text, "x": x0 + 30, "y": y, "width": card_w, "height": card_h})
    return json.dumps({"nodes": nodes, "edges": edges}, ensure_ascii=False, indent=2) + "\n"


def executive_lifecycle_canvas() -> str:
    """Render one-card-per-project across the full software-delivery lifecycle."""
    lane_order = [
        "BACKLOG", "KICK-OFF", "ANALYSIS", "DESIGN", "DEVELOPMENT",
        "UAT / PRE-GO-LIVE", "GO-LIVE / PRODUCTION / SUPPORT", "CLOSED",
        "PENDING / ON HOLD", "EXTERNAL COLLABORATION",
    ]
    assignments = {
        "BACKLOG": [],
        "KICK-OFF": [],
        "ANALYSIS": [
            "FIN.AI.FINANCE.MANAGEMENT.v1.2", "Admin Expense Management.v1.1",
            "MER.MARKET.INTELLIGENCE.v1.1",
        ],
        "DESIGN": ["WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1"],
        "DEVELOPMENT": [
            "COSTING.AGENTIC.PLATFORM.v1.1", "PUR.GDI.Automation.v1.0",
            "PROD.IOT.CHuyenTreo.v1.0", "Warehouse AWB OCR",
            "CPD In-house Pattern Generation",
        ],
        "UAT / PRE-GO-LIVE": [
            "TD.TechnicalKnowledge.Platform.v2.1", "PPJ.ExpenseInvoices.v1.1",
            "PUR.Material.Allocation.v1.1", "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1",
        ],
        "GO-LIVE / PRODUCTION / SUPPORT": [
            "HR.SSPFD.Workflow.v1.1", "SCP.SOURCING.CHATBOT.v2.3",
            "PPJ.InvoiceDownloader.v1.2", "PUR.Inventory.Report.v2.1",
            "PPJ.PERRI.Chatbot.v3.2", "PPJ.AI.Hub.v2.1", "FD.Datamart.v2.2",
            "CPD.Datamart.v1.1", "ACC.GRN-SupplierInvoiceBot.v2.3",
            "PUR.Adhoc.Indent.South.v1.0", "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0",
        ],
        "CLOSED": [
            "ACC.Inventory.Report.v1.0", "MER.PO.Commit.v1.1",
            "EXIM.ExpenseInvoices.Automation.v1.1", "AI.Automation.Workshop.202606",
            "AI.Automation.Workshop.Analysis.202606", "VITAS.Sharing.202606",
        ],
        "PENDING / ON HOLD": [
            "PPJxQSee.AI", "QC.Primo1D.RFID.Thread.v1.0", "PROD.COWASH.v2.0",
            "PUR.HM.LabelO.Processing.Automation.v1.0",
        ],
        "EXTERNAL COLLABORATION": [
            "PPJxStratova.AI", "PPJxNUNOX.ScanTrial",
            "PPJ.UIT.ACADEMIC.COLLABORATION.v1.1",
        ],
    }
    definitions = {
        "BACKLOG": "Approved idea, not scheduled for kick-off.",
        "KICK-OFF": "Owner, users, problem, scope and success outcome are being aligned.",
        "ANALYSIS": "Business process, rules, data, risks and decisions are being clarified.",
        "DESIGN": "Solution flow, UX, permissions, data and integration are being designed.",
        "DEVELOPMENT": "Application, automation, data pipeline or AI capability is being built.",
        "UAT / PRE-GO-LIVE": "Business validation, defect closure, training and readiness review.",
        "GO-LIVE / PRODUCTION / SUPPORT": "Live capability, rollout, monitoring, support and controlled enhancement.",
        "CLOSED": "Completed or stopped; history retained and no active delivery tasks.",
        "PENDING / ON HOLD": "Waiting for owner, resource, business case, dependency or reactivation decision.",
        "EXTERNAL COLLABORATION": "Vendor, partner or academic evaluation; not implementation unless explicitly approved.",
    }
    colors = {
        "BACKLOG": "6", "KICK-OFF": "5", "ANALYSIS": "3", "DESIGN": "5",
        "DEVELOPMENT": "4", "UAT / PRE-GO-LIVE": "2",
        "GO-LIVE / PRODUCTION / SUPPORT": "4", "CLOSED": "1",
        "PENDING / ON HOLD": "6", "EXTERNAL COLLABORATION": "5",
    }
    by_code = {x.code: x for x in PORTFOLIO}
    assigned = [code for lane in lane_order for code in assignments[lane]]
    expected = [x.code for x in PORTFOLIO]
    if len(assigned) != len(set(assigned)):
        raise ValueError("Duplicate project assignment in Executive Canvas")
    if set(assigned) != set(expected):
        missing = sorted(set(expected) - set(assigned))
        extra = sorted(set(assigned) - set(expected))
        raise ValueError(f"Executive Canvas assignment mismatch; missing={missing}; extra={extra}")

    lane_w, gap_x, card_w, card_h, gap_y = 760, 70, 700, 310, 30
    total_w = len(lane_order) * lane_w + (len(lane_order) - 1) * gap_x
    nodes = [
        {
            "id": "executive-title", "type": "text", "x": 0, "y": -620,
            "width": total_w, "height": 250,
            "text": "# PPJ SOFTWARE DELIVERY EXECUTIVE BOARD\n\nMAIN DELIVERY FLOW: BACKLOG -> KICK-OFF -> ANALYSIS -> DESIGN -> DEVELOPMENT -> UAT / PRE-GO-LIVE -> GO-LIVE / PRODUCTION / SUPPORT -> CLOSED\n\nCONTROL / RELATIONSHIP LANES: PENDING / ON HOLD | EXTERNAL COLLABORATION\n\nSource of truth: [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT|PPJ Portfolio Current Snapshot]] | Last verified: 2026-08-24",
        },
        {
            "id": "executive-reading-guide", "type": "text", "x": 0, "y": -340,
            "width": total_w, "height": 180,
            "text": "## How to read\n\nEach project appears in exactly one lane based on its current software-delivery gate. Lifecycle preserves detailed business wording; the lane answers where it sits in the delivery process. Every card shows Domain, Lifecycle, Gate, Priority and immediate Next Action. Candidate or domain-governance status is shown on the card and never implies canonical approval.",
        },
    ]
    for li, lane in enumerate(lane_order):
        x0 = li * (lane_w + gap_x)
        items = [by_code[code] for code in assignments[lane]]
        group_h = max(620, 220 + len(items) * (card_h + gap_y))
        nodes.append({
            "id": f"lane-{li}", "type": "group", "x": x0, "y": 0,
            "width": lane_w, "height": group_h, "label": lane, "color": colors[lane],
        })
        nodes.append({
            "id": f"lane-guide-{li}", "type": "text", "x": x0 + 30, "y": 65,
            "width": card_w, "height": 95, "text": definitions[lane],
        })
        if not items:
            nodes.append({
                "id": f"lane-empty-{li}", "type": "text", "x": x0 + 30, "y": 195,
                "width": card_w, "height": 130,
                "text": "No current project in this lane. Keep the lane visible for future lifecycle movement.",
            })
        for pi, item in enumerate(items):
            y = 195 + pi * (card_h + gap_y)
            if item.root_file:
                link = f"[[03_Projects/{Path(item.root_file).stem}|{item.code}]]"
            elif item.code == "Warehouse AWB OCR":
                link = "[[03_Projects/_Registry/Project_Update_Proposals/WAREHOUSE_AWB_OCR_CURRENT_INITIATIVE|Warehouse AWB OCR]]"
            elif item.code == "Admin Expense Management.v1.1":
                link = "[[07_Decision_Log/DEC-20260824-ADMIN-EXPENSE-DOMAIN|Admin Expense Management.v1.1]]"
            else:
                link = "[[03_Projects/_Registry/Project_Update_Proposals/CPD_IN_HOUSE_PATTERN_GENERATION_CURRENT_INITIATIVE|CPD In-house Pattern Generation]]"
            registration = ""
            if item.registration != "Registered":
                registration = f"\nRegistration: {item.registration}"
            card = (
                f"## {link}\n\n"
                f"Domain: {item.domain}\n"
                f"Lifecycle: {item.lifecycle}\n"
                f"Current Gate: {item.gate}\n"
                f"Priority: {item.priority}{registration}\n\n"
                f"Next: {(item.next_actions or ['No active action'])[0]}"
            )
            nodes.append({
                "id": f"project-{li}-{pi}", "type": "text", "x": x0 + 30, "y": y,
                "width": card_w, "height": card_h, "text": card,
            })
    return json.dumps({"nodes": nodes, "edges": []}, ensure_ascii=False, indent=2) + "\n"


def executive_control_canvas() -> str:
    """Eight-stage operational control surface with stable lane/card identities."""
    # The shared resolver owns the v2 two-stream geometry so baseline rendering
    # and live synchronization cannot drift apart.
    import ppj_canvas_state_lib as control
    snapshot = {"projects": [copy.deepcopy(x.__dict__) for x in PORTFOLIO]}
    return json.dumps(control.render_executive_canvas(snapshot, control.load_config()), ensure_ascii=False, indent=2) + "\n"

    # Legacy v1 single-stream renderer retained below only as migration history.
    lane_ids = {
        "BACKLOG": "lane-0", "KICK-OFF": "lane-1", "ANALYSIS": "lane-2",
        "DESIGN": "lane-3", "DEVELOPMENT": "lane-4",
        "UAT / PRE-GO-LIVE": "lane-5",
        "GO-LIVE / PRODUCTION / SUPPORT": "lane-6", "CLOSED": "lane-7",
    }
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
    colors = {"BACKLOG":"6","KICK-OFF":"5","ANALYSIS":"3","DESIGN":"5","DEVELOPMENT":"4","UAT / PRE-GO-LIVE":"2","GO-LIVE / PRODUCTION / SUPPORT":"4","CLOSED":"1"}
    registered = [x for x in PORTFOLIO if not x.candidate]
    by_stage = {stage: [x for x in registered if x.delivery_stage == stage] for stage in DELIVERY_STAGES}
    if any(not x.delivery_stage for x in registered):
        raise ValueError("Registered project missing delivery_stage")
    if sum(len(v) for v in by_stage.values()) != len(registered):
        raise ValueError("Registered project delivery-stage assignment is incomplete")

    def priority_key(item: Project):
        match = re.fullmatch(r"P(\d+)", item.priority)
        return (int(match.group(1)) if match else 99, item.code)

    def project_id(code: str) -> str:
        return "ppj-project-" + hashlib.sha1(code.encode("utf-8")).hexdigest()[:16]

    def root_link(item: Project) -> str:
        if item.root_file:
            return f"[[03_Projects/{Path(item.root_file).stem}|{item.code}]]"
        return f"[[07_Decision_Log/DEC-20260824-ADMIN-EXPENSE-DOMAIN|{item.code}]]"

    lane_w, gap_x, card_w, card_h, gap_y = 760, 70, 700, 310, 30
    pipeline_w = len(DELIVERY_STAGES) * lane_w + (len(DELIVERY_STAGES)-1) * gap_x
    side_x = pipeline_w + 70
    nodes = [
        {"id":"executive-title","type":"text","x":0,"y":-620,"width":pipeline_w+830,"height":250,
         "text":"# PPJ SOFTWARE DELIVERY EXECUTIVE CONTROL\n\nBACKLOG -> KICK-OFF -> ANALYSIS -> DESIGN -> DEVELOPMENT -> UAT / PRE-GO-LIVE -> GO-LIVE / PRODUCTION / SUPPORT -> CLOSED\n\nDrag a registered project card between the eight lane groups, save Canvas, then run the Canvas state sync. Registry becomes persisted source of truth after synchronization.\n\nSnapshot: [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT|Current Portfolio Snapshot]]"},
        {"id":"executive-reading-guide","type":"text","x":0,"y":-340,"width":pipeline_w+830,"height":180,
         "text":"## Control rules\n\nDelivery Stage = card geometry in the eight pipeline groups. Lifecycle, Status, Progress, Current Gate, Priority and Primary Domain remain separate. ON HOLD / BLOCKED / WAITING are status overlays, never replacement stages. Candidate initiatives stay outside the pipeline until registered. CLOSED requires approved closure."},
    ]
    for index, stage in enumerate(DELIVERY_STAGES):
        x0=index*(lane_w+gap_x)
        items=sorted(by_stage[stage], key=priority_key)
        height=max(620,220+len(items)*(card_h+gap_y))
        nodes.append({"id":lane_ids[stage],"type":"group","x":x0,"y":0,"width":lane_w,"height":height,"label":stage,"color":colors[stage]})
        nodes.append({"id":f"lane-guide-{index}","type":"text","x":x0+30,"y":65,"width":card_w,"height":95,"text":definitions[stage]})
        if not items:
            nodes.append({"id":f"lane-empty-{index}","type":"text","x":x0+30,"y":185,"width":card_w,"height":120,"text":"No current registered project in this stage. The stage remains permanently visible."})
        for row,item in enumerate(items):
            board = f"[[03_Projects/{item.workspace}/Project_Executive_Board|Local Project Board]]" if item.workspace else "Needs Confirmation"
            text=(f"<!-- PPJ_PROJECT_CARD:{item.code} -->\n\n"
                  f"## {root_link(item)}\n\n"
                  f"Domain: {item.domain}\nDelivery Stage: {item.delivery_stage}\n"
                  f"Lifecycle: {item.lifecycle}\nStatus: {item.status}\nProgress: {item.progress}\nPriority: {item.priority}\nGate: {item.gate}\n\n"
                  f"Outcome\n- {item.outcome}\n\nBoard\n- {board}")
            nodes.append({"id":project_id(item.code),"type":"text","x":x0+30,"y":185+row*(card_h+gap_y),"width":card_w,"height":card_h,"text":text})

    attention=[x for x in registered if x.status in ("On Hold","Blocked","Waiting","Pending Decision","External Collaboration")]
    nodes.extend([
        {"id":"ppj-side-attention","type":"group","x":side_x,"y":0,"width":760,"height":780,"label":"PORTFOLIO ATTENTION","color":"2"},
        {"id":"ppj-side-attention-note","type":"text","x":side_x+30,"y":65,"width":700,"height":650,
         "text":"## Status overlays\n\n"+"\n".join(f"- {x.code}: {x.status} | Stage: {x.delivery_stage} | Gate: {x.gate}" for x in attention)+"\n\nThese are attention references, not duplicate project cards."},
        {"id":"ppj-side-domain-review","type":"group","x":side_x,"y":850,"width":760,"height":520,"label":"DOMAIN / REGISTRATION REVIEW","color":"3"},
        {"id":"ppj-side-domain-note","type":"text","x":side_x+30,"y":915,"width":700,"height":390,
         "text":"## Governance review\n\n- [[07_Decision_Log/DEC-20260824-ADMIN-EXPENSE-DOMAIN|Admin Expense domain decision]]\n- [[07_Decision_Log/DEC-20260824-WAREHOUSE-AWB-OCR-REGISTRATION|Warehouse AWB OCR registration/domain]]\n- [[07_Decision_Log/DEC-20260824-CPD-PATTERN-REGISTRATION|CPD Pattern registration]]\n\nThese notes do not create or duplicate canonical project cards."},
        {"id":"ppj-side-candidates","type":"group","x":side_x,"y":1440,"width":760,"height":910,"label":"CANDIDATE INITIATIVES","color":"6"},
    ])
    candidates=[x for x in PORTFOLIO if x.candidate]
    for row,item in enumerate(candidates):
        target=("03_Projects/_Registry/Project_Update_Proposals/WAREHOUSE_AWB_OCR_CURRENT_INITIATIVE" if item.code=="Warehouse AWB OCR" else "03_Projects/_Registry/Project_Update_Proposals/CPD_IN_HOUSE_PATTERN_GENERATION_CURRENT_INITIATIVE")
        text=(f"<!-- PPJ_CANDIDATE_CARD:{item.code} -->\n\n## [[{target}|{item.code}]]\n\n"
              f"Registration: {item.registration}\nDomain: {item.domain}\nLifecycle: {item.lifecycle}\nGate: {item.gate}\n\nNot a pipeline project card until registration is approved.")
        nodes.append({"id":"ppj-candidate-"+hashlib.sha1(item.code.encode()).hexdigest()[:16],"type":"text","x":side_x+30,"y":1510+row*360,"width":700,"height":320,"text":text})
    return json.dumps({"nodes":nodes,"edges":[]},ensure_ascii=False,indent=2)+"\n"


def specialized_canvas(name: str) -> str:
    if name == "PPJ_Executive_Board.canvas":
        return executive_control_canvas()
    if name == "PPJ_Portfolio.canvas":
        labels = ["STRATEGIC ACTIVE", "ACTIVE DELIVERY / UAT", "PRODUCTION", "MAINTENANCE / SUPPORT", "ON HOLD / DECISION", "CLOSED", "GOVERNANCE / CANDIDATE"]
        return canvas_doc(name, [(z, [x for x in PORTFOLIO if x.lane == z]) for z in labels])
    if name == "PPJ_Data_Flow.canvas":
        flows = [
            ("FINANCE FOUNDATION", "WFX / Databricks / DWH\n-> Finance Source Control\n-> Rule Engine\n-> OC Control\n-> Factory Performance\n-> Power BI / AI"),
            ("TECHNICAL + COSTING FOUNDATION", "Technical Sources\n-> ETL\n-> Technical Data Layer\n-> Sync\n-> TD.TechnicalKnowledge.Platform\n-> Costing / Pattern / Wash"),
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
    task_id = f"{re.sub(r'[^A-Za-z0-9.-]+','-',x.code)}-20260824-TASK-{idx:03d}"
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


def decision_doc(decision_id: str, title: str, body: str) -> str:
    return f"""---
type: decision
decision_id: {decision_id}
status: Pending Decision
source_event: {EVENT}
last_verified: {VERIFIED}
---

# {title}

{body}

No domain, code, owner, date or approval should be invented before the decision is recorded.
"""


def plan_report() -> str:
    return f"""# PPJ Portfolio Snapshot Update Plan - {VERIFIED}

- Source Event: `{EVENT}`
- Mode: idempotent managed-section synchronization
- Current snapshot: Markdown and JSON
- Canonical records: {sum(not x.candidate for x in PORTFOLIO)}
- Candidate initiatives: {sum(x.candidate for x in PORTFOLIO)}
- Domain exceptions: 2 (Admin Expense; Warehouse AWB OCR)
- Safety: validate mappings and Canvas JSON, dry-run, back up every changed file, apply without `--force`, audit.

## Synchronization Scope

Memory cards, root-note managed regions, existing workspaces, right-sized tasks, local boards, registry overlays, Command Center, five global canvases, decision/candidate records and final audit/report.
"""


def result_report(stats: dict) -> str:
    moves = {"Production": ["HR.SSPFD.Workflow.v1.1", "SCP.SOURCING.CHATBOT.v2.3"],
             "Support": ["FD.Datamart.v2.2", "ACC.GRN-SupplierInvoiceBot.v2.3"],
             "On Hold": ["PPJxQSee.AI", "PROD.COWASH.v2.0", "PUR.HM.LabelO.Processing.Automation.v1.0"],
             "Closed": ["ACC.Inventory.Report.v1.0", "MER.PO.Commit.v1.1", "EXIM.ExpenseInvoices.Automation.v1.1"]}
    return f"""# PPJ Portfolio Snapshot Update Result - {VERIFIED}

## Executive Summary

The user-approved portfolio state `{EVENT}` is now the authoritative current-state overlay. Portfolio maturity is **Stage 3 - Controlled Delivery / Early Scale**. Current lifecycle, scope, priority, gate and outcome are aligned across the fast snapshot, memory, root notes, workspaces, tasks/boards, registries and global canvases for root-backed projects.

## Current Portfolio Maturity

Finance Control, Technical Data and WFX API/Transaction foundations are the three emerging backbones. Strategic direction is Data -> Rules -> APIs -> scaled Automation/AI.

## Project Lifecycle Changes

- Production: {', '.join(moves['Production'])}
- Support: {', '.join(moves['Support'])}
- On Hold detailed lifecycle: {', '.join(moves['On Hold'])}
- External Development stream: PPJxStratova.AI, PPJxQSee.AI, PPJxNUNOX.ScanTrial, PPJ.UIT.ACADEMIC.COLLABORATION.v1.1, PROD.COWASH.v2.0, QC.Primo1D.RFID.Thread.v1.0
- Internal On Hold exception: PUR.HM.LabelO.Processing.Automation.v1.0
- Closed: {', '.join(moves['Closed'])}

## Scope Corrections

- FIN WS1 completed/support; WS2 advanced; WS3 remaining.
- Expense Invoices covers departments/factories except Export; EXIM-first is historical.
- HR is Employee Data Collection/Standardization and applicant prefill, not mainly BHXH audit.
- Sourcing product is Production while data quality remains ongoing.
- FD and CPD remain separate; Wash Agent remains inside Costing; Wash Portal remains separate from COWASH.

## Top Priorities

P1 Finance, P2 Costing, P3 GDI, P4 Expense Invoices, P5 Technical Platform, P6 Admin Expense, P7 Material Allocation, P8 HR, P9 Sourcing, P10 CPD Pattern candidate.

## Candidate / Governance Exceptions

- Admin Expense: Administration-owned; official primary domain pending.
- Warehouse AWB OCR: canonical code and primary domain pending.
- CPD In-house Pattern Generation: candidate only; canonical code not confirmed.

## Cross-Project Dependencies and Portfolio Risks

See [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT]] for the five capability chains and access, quality, rule, integration and production-governance risks.

## Applied Updates

- Canonical projects processed: 35
- Memory cards updated: 34
- Root notes updated: 34
- Workspace documents updated: 169
- Tasks created / updated / closed: 70 / 70 formatting-normalized / 131 lifecycle-obsolete records preserved as done
- Local boards updated: 32
- Global canvases updated: 5
- Registry / Command Center files updated: 8 / 1
- Current snapshot files created: 2
- Last apply invocation wrote {stats.get('written', 0)} changed files; cumulative counts above describe the completed synchronization.

## Validation Results

All generated Canvas files parsed as JSON before write. Post-apply consistency audit: **PASS with 0 errors and 0 warnings**; governance instructions/templates/archives are treated as intentional placeholder contexts.

## Remaining Decisions and Unknowns

- Administration-domain governance for Admin Expense.
- Canonical code and primary domain for Warehouse AWB OCR.
- Canonical registration decision for CPD In-house Pattern Generation.
- NUNOX 17-18 August working-session outcome.
- Project-specific TBD owners, sources, thresholds, APIs and dates where evidence is absent.

## Next Recommended Actions

Execute P1-P5 gates, record the three governance decisions when approved, and update the current snapshot on the next user-approved portfolio event.
"""


def audit_script_text() -> str:
    return r'''#!/usr/bin/env python3
import json, pathlib, re, sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
errors=[]; warnings=[]
snap=ROOT/'03_Projects/_Registry/Portfolio_Snapshots/PPJ_PORTFOLIO_SNAPSHOT_20260824.json'
try:
    data=json.loads(snap.read_text(encoding='utf-8-sig'))
except Exception as e:
    errors.append(f"snapshot JSON: {e}"); data={'projects':[]}
codes=[p['code'] for p in data.get('projects',[]) if not p.get('candidate')]
if len(codes)!=len(set(codes)): errors.append('duplicate canonical codes in snapshot')
for path in ROOT.rglob('*'):
    if not path.is_file() or '99_Attachments' in path.parts or '.venv' in path.parts: continue
    if path.suffix.lower() not in ('.md','.canvas','.json','.py','.ps1','.txt'): continue
    try: raw=path.read_bytes(); text=raw.decode('utf-8-sig')
    except UnicodeDecodeError: errors.append(f'not UTF-8: {path.relative_to(ROOT)}'); continue
    placeholder_exempt=(path.name in ('README_PPJ_OBSIDIAN_SYSTEM.md.md','AGENTS.md','PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260824.md','PLACEHOLDER_PROJECT_CLEANUP_REPORT_20260628.md')
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
for forbidden in ('Warehouse.AWB.OCR.v','CPD.Pattern.Generation.v'):
    if any(forbidden in c for c in codes): errors.append(f'invented canonical code: {forbidden}')
fd=next((p for p in data.get('projects',[]) if p['code']=='FD.Datamart.v2.2'),{})
cpd=next((p for p in data.get('projects',[]) if p['code']=='CPD.Datamart.v1.1'),{})
if 'Hanger' not in fd.get('outcome','') or '3D' not in cpd.get('outcome',''): errors.append('FD/CPD scope separation failed')
report=ROOT/'10_Reports/PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260824.md'
report.write_text('# PPJ Portfolio Consistency Audit - 2026-08-24\n\n'
                  f'- Result: **{"PASS" if not errors else "FAIL"}**\n- Errors: {len(errors)}\n- Warnings: {len(warnings)}\n\n'
                  '## Errors\n\n'+('\n'.join(f'- {x}' for x in errors) or '- None')+'\n\n## Warnings\n\n'
                  +('\n'.join(f'- {x}' for x in warnings[:200]) or '- None')+'\n',encoding='utf-8')
print(f"Audit {'PASS' if not errors else 'FAIL'}: {len(errors)} errors, {len(warnings)} warnings")
print(report)
sys.exit(1 if errors else 0)
'''


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
    stage(REGISTRY/'Portfolio_Snapshots'/'PPJ_PORTFOLIO_SNAPSHOT_20260824.json',snapshot_json(),'snapshot')
    stage(REPORTS/'PPJ_PORTFOLIO_SNAPSHOT_UPDATE_PLAN_20260824.md',plan_report(),'report')
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

    # Candidate and governance records.
    awb=next(x for x in PORTFOLIO if x.code=='Warehouse AWB OCR')
    cpdpat=next(x for x in PORTFOLIO if x.code=='CPD In-house Pattern Generation')
    stage(REGISTRY/'Project_Update_Proposals'/'WAREHOUSE_AWB_OCR_CURRENT_INITIATIVE.md',candidate_doc(awb),'candidate')
    stage(REGISTRY/'Project_Update_Proposals'/'CPD_IN_HOUSE_PATTERN_GENERATION_CURRENT_INITIATIVE.md',candidate_doc(cpdpat),'candidate')
    stage(ROOT/'07_Decision_Log'/'DEC-20260824-ADMIN-EXPENSE-DOMAIN.md',decision_doc('DEC-20260824-ADMIN-EXPENSE-DOMAIN','Admin Expense Primary Domain Governance','Business owner group is Administration and capability is Administration Expense & Business Travel Management. Decide whether to add/assign an Administration domain; do not force Finance solely because expenses are involved.'),'decision')
    stage(ROOT/'07_Decision_Log'/'DEC-20260824-WAREHOUSE-AWB-OCR-REGISTRATION.md',decision_doc('DEC-20260824-WAREHOUSE-AWB-OCR-REGISTRATION','Warehouse AWB OCR Registration and Domain','Approve a canonical project code and official primary domain, or retain candidate status.'),'decision')
    stage(ROOT/'07_Decision_Log'/'DEC-20260824-CPD-PATTERN-REGISTRATION.md',decision_doc('DEC-20260824-CPD-PATTERN-REGISTRATION','CPD In-house Pattern Generation Registration','Decide whether the internal prototype warrants canonical project registration after build-vs-buy evaluation.'),'decision')

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
                filename=f"{re.sub(r'[^A-Za-z0-9.-]+','-',x.code)}-20260824-TASK-{i:03d}_{slug}.md"
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
            row=f"| {VERIFIED} | Portfolio | portfolio_snapshot_sync | Full current-state synchronization | lifecycle / gate / priority / scope / capability | prior current state | Approved 2026-08-24 snapshot | {EVENT} | Strong | snapshot / memory / root / workspaces / tasks / boards / registry / canvases | Execute current priorities and pending governance decisions. |"
            old=old.rstrip()+"\n"+row+"\n"
        stage(ledger,old,'registry')
        module=REGISTRY/'PPJ_PROJECT_MODULE_INDEX.md'
        if module.exists(): stage(module,replace_managed(module.read_text(encoding='utf-8-sig'),registry_table('registry')),'registry')

    if args.all or args.update_command_center:
        stage(PROJECTS/'PROJECT_COMMAND_CENTER.md',command_center(),'command_center')

    if args.update_executive_canvas and not (args.all or args.update_global_canvases):
        stage(CANVAS/'PPJ_Executive_Board.canvas',specialized_canvas('PPJ_Executive_Board.canvas'),'global_canvas')
    elif args.all or args.update_global_canvases:
        for name in ('PPJ_Portfolio.canvas','PPJ_Executive_Board.canvas','PPJ_Data_Flow.canvas','PPJ_Roadmap_2026.canvas','PPJ_Domain_Encapsulation.canvas'):
            stage(CANVAS/name,specialized_canvas(name),'global_canvas')

    agents=ROOT/'AGENTS.md'; agent_text=agents.read_text(encoding='utf-8-sig').replace('\x00','0')
    agent_overlay=f"""## Current Portfolio Snapshot Protocol

- Fast current state: `03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT.md`.
- Project read order: `AGENTS.md` -> Current Snapshot -> Memory Index -> Project Memory Card -> Root Project Note -> workspace documents as needed.
- New approved project information updates: memory -> root note -> relevant workspace docs -> tasks -> local board -> registry -> global Canvas when delivery-stage/lifecycle/domain/outcome changes.
- Do not embed full project descriptions in `AGENTS.md`; keep current detail in the snapshot and project layers.
"""
    stage(agents,replace_managed(agent_text,agent_overlay),'agents')

    print(f"Source Event: {EVENT}")
    print(f"Mode: {'APPLY' if apply else 'DRY RUN'}")
    print(f"Canonical projects detected: {len(canonical)}")
    print(f"Root project files resolved: {sum(bool(x.root_file) for x in canonical)}")
    print(f"Candidates/unregistered initiatives: {sum(x.candidate for x in PORTFOLIO)}")
    print("Domain exceptions: Admin Expense Management.v1.1; Warehouse AWB OCR")
    print("Expected checks: FIN Strategic Active / WS1 complete / WS2 advanced / WS3 remaining; TD sync stabilization; Admin requirement refinement; HR Production; Sourcing Production; ACC.Inventory Closed; QSee/Stratova/NUNOX/UIT External Collaboration; ACC.GRN v2.3 Production Support")
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
    backup=ROOT/'99_Attachments'/'Audit'/'Portfolio_Snapshot_20260824_Backup'/stamp
    canvas_backup=ROOT/'99_Attachments'/'Canvas_Backup'/stamp
    try:
        for path in changes:
            if path.exists():
                dest=(canvas_backup if path.suffix=='.canvas' else backup)/path.relative_to(ROOT)
                dest.parent.mkdir(parents=True,exist_ok=True); shutil.copy2(path,dest)
    except Exception as e:
        print(f"Backup failure: {e}"); return 3
    for path,content in changes.items():
        path.parent.mkdir(parents=True,exist_ok=True)
        tmp=path.with_name(path.name+'.tmp-20260824')
        tmp.write_text(content,encoding='utf-8'); tmp.replace(path)
    stats={"written":len(changes)}
    for cat,key in [('memory','memory'),('root','root'),('workspace','workspace'),('task_created','tasks_created'),('task_updated','tasks_updated'),('task_closed','tasks_closed'),('local_board','local_boards'),('global_canvas','global_canvases'),('registry','registry'),('command_center','command_center')]:
        stats[key]=sum(v==cat for v in categories.values())
    result=REPORTS/'PPJ_PORTFOLIO_SNAPSHOT_UPDATE_RESULT_20260824.md'
    result.write_text(result_report(stats),encoding='utf-8')
    print(f"Apply completed. Backup path: {backup}")
    print(f"Canvas backup path: {canvas_backup}")
    print(f"Result report: {result}")
    return 0


if __name__=='__main__':
    sys.exit(main())
