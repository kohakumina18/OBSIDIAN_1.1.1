---
type: portfolio_project_process_map
source_event: PPJ-PORTFOLIO-SNAPSHOT-20260918
last_generated: 2026-09-19
status: governed_view
---

# PPJ Project Process Map

This note and its Canvas explain the end-to-end process of every registered PPJ portfolio project.

Canvas: [[03_Projects/Canvas/PPJ_Project_Process_Map]]

Reading model:

```text
Trigger / Input -> Data preparation -> Rule / AI / Automation processing -> Validation -> Human decision -> Transaction / Output -> Monitoring / Support
```

Candidate and discovery items are excluded until canonical registration is approved.

## Merchandising

### [[03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1|MER_CostingAgenticPlatform_v1.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `DEVELOPMENT`
- Status: `Active`
- Process: Garment requirement + technical history -> Sew/Wash/BOM/Consumption/Similar-Style agents -> Costing Orchestrator -> cost and quotation package -> expert review -> MER quotation decision
- Human control: IED, Wash, Technical and MER experts approve AI proposals before business use.
- Output: Reviewed costing / quotation package with confidence and traceability.
- Workspace: [[03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1/00_Project_Home|Home]] | [[03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1|MER_InvoiceDataRecheck_v1.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `UAT / PRE-GO-LIVE`
- Status: `Active`
- Process: Costing + commercial cost + invoice data + customer rules -> cross-check -> exception detection -> MER review -> correction / acceptance -> audit output
- Human control: MER validates customer-specific rules and approves every material exception.
- Output: Reusable invoice/cost recheck result beginning with Chico's rules.
- Workspace: [[03_Projects/MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1/00_Project_Home|Home]] | [[03_Projects/MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/E-commerce Market Intelligence v.2.3|MER_MarketIntelligence_v1.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `ANALYSIS`
- Status: `Active`
- Process: Market + customer + competitor + product signals -> collect/clean -> analyze trends and opportunities -> intelligence summary -> MER review -> commercial decision
- Human control: Merchandising validates signal quality and distinguishes evidence from assumptions.
- Output: Actionable market/customer intelligence for product and commercial decisions.
- Workspace: [[03_Projects/E-commerce Market Intelligence v.2.3/00_Project_Home|Home]] | [[03_Projects/E-commerce Market Intelligence v.2.3/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/MER.PO-Commit|MER_POCommit_v1.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `CLOSED`
- Status: `Closed`
- Process: Customer order -> scenario validation -> MER PO preparation -> manual exception handling -> WFX PO record -> completion/close
- Human control: MER reviewed scenarios not covered by automation.
- Output: Closed PO Commit history covering the validated customer scenarios.
- Workspace: [[03_Projects/MER.PO-Commit/00_Project_Home|Home]] | [[03_Projects/MER.PO-Commit/03_Process/TO_BE_Process|TO-BE]]

## Fabric / Textiles Technique

### [[03_Projects/CPD.Datamart.v1.1|CPD_VisualSampleDatamart_v1.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Support`
- Process: 3D samples + images + visual assets -> ingest -> tag/standardize metadata -> visual library -> image search -> user selection -> asset maintenance
- Human control: CPD/3D Design validates asset quality, metadata and search relevance.
- Output: Searchable 3D/visual sample library; separate from FD Fabric Datamart.
- Workspace: [[03_Projects/CPD.Datamart.v1.1/00_Project_Home|Home]] | [[03_Projects/CPD.Datamart.v1.1/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/FD.Datamart.v2.2|FAB_FabricDatamart_v2.2.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Support`
- Process: Fabric/hanger/material data -> Directus import/admin -> validation and correction -> fabric master + QR information/design -> attach/use on hanger -> search/support
- Human control: FD users approve data corrections, permissions and QR usage.
- Output: Governed Fabric + Hanger + QR reference datamart.
- Workspace: [[03_Projects/FD.Datamart.v2.2/00_Project_Home|Home]] | [[03_Projects/FD.Datamart.v2.2/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PPJxNUNOX|PPJxNUNOX.ScanTrial]]

- Delivery: `EXTERNAL DEVELOPMENT` / `ANALYSIS`
- Status: `External Collaboration`
- Process: Fabric/garment sample -> scan/capture -> image-quality and metadata check -> digital-library ingest -> user evaluation -> partnership/implementation decision
- Human control: Business and leadership confirm trial evidence before any commitment.
- Output: Evidence for fabric/garment digitization and digital-library feasibility.
- Workspace: [[03_Projects/PPJxNUNOX/00_Project_Home|Home]] | [[03_Projects/PPJxNUNOX/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/TD.TechnicalPlatform_v2.1|TD_TechnicalKnowledgePlatform_v2.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `UAT / PRE-GO-LIVE`
- Status: `Active`
- Process: Technical sources + documents -> ETL -> standardize keys/versions -> canonical technical model -> sync -> search, costing, pattern, wash and AI applications
- Human control: Technical users validate completeness, latest-approved version, permissions and reconciliation.
- Output: Governed technical knowledge backbone for downstream applications.
- Workspace: [[03_Projects/TD.TechnicalPlatform_v2.1/00_Project_Home|Home]] | [[03_Projects/TD.TechnicalPlatform_v2.1/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PPJxStratova AI|PPJxStratova.AI]]

- Delivery: `EXTERNAL DEVELOPMENT` / `CLOSED`
- Status: `Closed`
- Process: Historical vendor/use-case proposal -> technical and commercial evaluation -> PoC discussion -> management decision -> close -> retain lessons
- Human control: Leadership controlled the historical go/no-go decision; current PoC stays in Discovery Register.
- Output: Closed historical evaluation record without reusing it for the new discovery.
- Workspace: [[03_Projects/PPJxStratova AI/00_Project_Home|Home]] | [[03_Projects/PPJxStratova AI/03_Process/TO_BE_Process|TO-BE]]

## Sourcing / Purchasing

### [[03_Projects/PUR.Adhoc Indent mien Nam|PUR_AdhocIndentSouth_v1.0.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Support`
- Process: Indent input -> field and business validation -> prepare transaction -> submit to WFX -> confirmation/status -> exception handling -> operational support
- Human control: Purchasing reviews invalid or changed inputs and WFX compatibility exceptions.
- Output: Stable South-region indent automation.
- Workspace: [[03_Projects/PUR.Adhoc Indent mien Nam/00_Project_Home|Home]] | [[03_Projects/PUR.Adhoc Indent mien Nam/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PUR.GDI Automation|PUR_GDIAutomation_v1.0.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `DEVELOPMENT`
- Status: `Active`
- Process: Purchasing input + WFX master data -> business validation -> authenticated WFX API lookup -> create/update GDI -> WFX confirmation -> audit
- Human control: Purchasing confirms controlled submission; errors and duplicates are routed for review.
- Output: Auditable GDI transaction and dispatch status in WFX.
- Workspace: [[03_Projects/PUR.GDI Automation/00_Project_Home|Home]] | [[03_Projects/PUR.GDI Automation/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PUR.H&M Label-O Processing|PUR_HMLabelProcessing_v1.0.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `ANALYSIS`
- Status: `On Hold`
- Process: Customer/label input -> extract customer rules -> transform and validate -> Label-O processing -> exception handling -> business review
- Human control: Purchasing decides whether a scalable rules model justifies reactivation.
- Output: Controlled label-processing result; currently On Hold for scalability/value.
- Workspace: [[03_Projects/PUR.H&M Label-O Processing/00_Project_Home|Home]] | [[03_Projects/PUR.H&M Label-O Processing/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PUR.Inventory Report|PUR_InventoryReport_v2.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Active`
- Process: WFX inventory and purchasing data -> extract -> reconcile totals -> transform -> tables/filters/reports -> Purchasing review -> enhancement feedback
- Human control: Purchasing validates totals, refresh timing and operational interpretation.
- Output: Operational inventory visibility for purchasing decisions.
- Workspace: [[03_Projects/PUR.Inventory Report/00_Project_Home|Home]] | [[03_Projects/PUR.Inventory Report/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PUR.Material.Allocation.v1.2|PUR_MaterialAllocation_v1.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `UAT / PRE-GO-LIVE`
- Status: `Active`
- Process: OC material demand + available stock -> eligibility check -> allocation proposal -> quantity validation -> user confirmation -> WFX transaction -> rollback/audit if required
- Human control: Purchasing validates OC eligibility, partial allocation and exception handling before submit.
- Output: Controlled allocation of surplus material across eligible OCs.
- Workspace: [[03_Projects/PUR.Material.Allocation.v1.2/00_Project_Home|Home]] | [[03_Projects/PUR.Material.Allocation.v1.2/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/SCP.SOURCING.CHATBOT.v2.3|SCP_SourcingChatbot_v2.3.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Active`
- Process: Supplier/material/sample data -> ingest and normalize -> index/RAG -> search and comparison -> grounded answer -> user feedback and quality monitoring
- Human control: Sourcing validates source data, answer traceability and production quality.
- Output: One searchable sourcing intelligence and chatbot application.
- Workspace: [[03_Projects/SCP.SOURCING.CHATBOT.v2.3/00_Project_Home|Home]] | [[03_Projects/SCP.SOURCING.CHATBOT.v2.3/03_Process/TO_BE_Process|TO-BE]]

## Warehouse

### [[03_Projects/WH_AWBExtraction_v1.1.0|WH_AWBExtraction_v1.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `DEVELOPMENT`
- Status: `Active`
- Process: AWB image + DHL email -> OCR/email parsing -> canonical field mapping -> confidence and validation rules -> human review -> canonical AWB record
- Human control: Warehouse reviews low-confidence fields, tables, weight and units.
- Output: Validated structured AWB data across image and email channels.
- Workspace: [[03_Projects/WH_AWBExtraction_v1.1.0/00_Project_Home|Home]] | [[03_Projects/WH_AWBExtraction_v1.1.0/03_Process/TO_BE_Process|TO-BE]]

## Production + Wash

### [[03_Projects/PROD.IOT.CHuyenTreo_1|PROD_HangingLineIoT_v1.0.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `DEVELOPMENT`
- Status: `Active`
- Process: Hanging-line machines/sensors -> WISER / INA -> collect and normalize -> production KPI calculation -> dashboard -> line/factory review -> corrective action
- Human control: Production owners validate source reconciliation and KPI definitions.
- Output: Near-real-time line visibility for output, efficiency and exceptions.
- Workspace: [[03_Projects/PROD.IOT.CHuyenTreo_1/00_Project_Home|Home]] | [[03_Projects/PROD.IOT.CHuyenTreo_1/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PROD.COWASH|WASH_COWASH_v2.0.0]]

- Delivery: `EXTERNAL DEVELOPMENT` / `ANALYSIS`
- Status: `External Collaboration`
- Process: Wash operations + machine/output data -> capture -> standardize -> KPI/delay/rework calculation -> dashboard -> owner review -> operational action
- Human control: Wash/Production owners must confirm source, KPI, access and technical direction.
- Output: Operational Wash visibility if the paused scope is reactivated.
- Workspace: [[03_Projects/PROD.COWASH/00_Project_Home|Home]] | [[03_Projects/PROD.COWASH/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1|WASH_SamplingManagement_v1.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `DESIGN`
- Status: `Active`
- Process: Sample request -> planning -> recipe/process preparation -> sample execution -> result capture -> evaluation -> approval -> history and attachments
- Human control: R&D Wash users review results and approve the sampling outcome.
- Output: Group-wide controlled Wash sampling workflow and searchable history.
- Workspace: [[03_Projects/WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1/00_Project_Home|Home]] | [[03_Projects/WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1/03_Process/TO_BE_Process|TO-BE]]

## QC / TQM

### [[03_Projects/PPJxQSee.ai|QC_DefectDetection_v1.0.0]]

- Delivery: `EXTERNAL DEVELOPMENT` / `ANALYSIS`
- Status: `External Collaboration`
- Process: Inspection image + labeled dataset -> AI detection -> defect classification + confidence -> QC confirmation -> accept/rework decision -> quality metrics
- Human control: QC/TQM owns labels, confirms results and approves operational decisions.
- Output: Measured defect-detection capability when dataset/resources are ready.
- Workspace: [[03_Projects/PPJxQSee.ai/00_Project_Home|Home]] | [[03_Projects/PPJxQSee.ai/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PPJ XPrimo1D RFID Thread|QC_ThreadTraceability_v1.0.0]]

- Delivery: `EXTERNAL DEVELOPMENT` / `ANALYSIS`
- Status: `External Collaboration`
- Process: RFID/thread identity -> scan/read -> link to production event -> build traceability chain -> connect quality/product record -> QC/customer business decision
- Human control: QC, MER and factory users validate feasibility and customer value before PoC.
- Output: Thread-to-product traceability evidence if the business case is approved.
- Workspace: [[03_Projects/PPJ XPrimo1D RFID Thread/00_Project_Home|Home]] | [[03_Projects/PPJ XPrimo1D RFID Thread/03_Process/TO_BE_Process|TO-BE]]

## Logistics / EXIM

### [[03_Projects/PPJ. Expense-Invoices.v1.1|LOG_ExpenseInvoiceProcessing_v1.2.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `UAT / PRE-GO-LIVE`
- Status: `Active`
- Process: Expense invoice + supplier/region data -> intake/OCR -> mapping -> validation -> tax and regional rules -> exception review -> processing/posting -> audit
- Human control: Logistics/EXIM users resolve exceptions and approve region-specific treatment.
- Output: Validated expense-invoice transaction with regional compliance evidence.
- Workspace: [[03_Projects/PPJ. Expense-Invoices.v1.1/00_Project_Home|Home]] | [[03_Projects/PPJ. Expense-Invoices.v1.1/03_Process/TO_BE_Process|TO-BE]]

## Finance / Accounting

### [[03_Projects/ACC.GRN-SupplierInvoiceBot.v2.3|ACC_GRNSupplierInvoiceBot_v2.3.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Support`
- Process: Supplier invoice + GRN/system data -> validation -> matching and business rules -> transaction preparation -> automated data entry -> target system -> exception handling -> audit
- Human control: Accounting reviews exceptions and controls production support.
- Output: Auditable supplier-invoice/GRN processing and system entry.
- Workspace: [[03_Projects/ACC.GRN-SupplierInvoiceBot.v2.3/00_Project_Home|Home]] | [[03_Projects/ACC.GRN-SupplierInvoiceBot.v2.3/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN_FinanceManagement_v1.2.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `DESIGN`
- Status: `Active`
- Process: WFX / DWH / Databricks -> source validation -> finance rules and Q&A -> OC exceptions + factory performance -> Accounting review -> Power BI / management decision
- Human control: Accounting approves sources, thresholds, exception severity and reconciled results.
- Output: Trusted finance control, exception ownership and management insight.
- Workspace: [[03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1/00_Project_Home|Home]] | [[03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PPJ.Invoice Downloader.v1.2|FIN_InvoiceDownloader_v1.2.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Active`
- Process: Supplier/e-invoice portals -> authenticate -> download XML/PDF -> validate and merge -> save with structured metadata -> expose to Accounting/EXIM workflows
- Human control: Operations reviews missing, duplicate, failed and credential-related cases.
- Output: Reliable invoice document/data acquisition with audit evidence.
- Workspace: [[03_Projects/PPJ.Invoice Downloader.v1.2/00_Project_Home|Home]] | [[03_Projects/PPJ.Invoice Downloader.v1.2/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/ACC.Inventory.Report.v1.0|ACC_InventoryReport_v1.0.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `CLOSED`
- Status: `Closed`
- Process: Inventory transactions -> extract -> quantity/value/period reconciliation -> Accounting report -> Accounting review -> close
- Human control: Accounting validated the historical report and closure.
- Output: Closed Accounting inventory-control report history.
- Workspace: [[03_Projects/ACC.Inventory.Report.v1.0/00_Project_Home|Home]] | [[03_Projects/ACC.Inventory.Report.v1.0/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/EXIM.ExpenseInvoices.Automation.v1.1|EXIM.ExpenseInvoices.Automation.v1.1]]

- Delivery: `INTERNAL DEVELOPMENT` / `CLOSED`
- Status: `Closed`
- Process: Expense invoice -> extract/map -> validate -> automated system entry -> exception review -> audit -> historical close
- Human control: EXIM/Accounting reviewed exceptions; successor scope moved to LOG_ExpenseInvoiceProcessing_v1.2.0.
- Output: Closed predecessor history retained separately from the current project.
- Workspace: [[03_Projects/EXIM.ExpenseInvoices.Automation.v1.1/00_Project_Home|Home]] | [[03_Projects/EXIM.ExpenseInvoices.Automation.v1.1/03_Process/TO_BE_Process|TO-BE]]

## Administration

### [[03_Projects/ADMIN_ExpenseManagement_v1.1.0|ADMIN_ExpenseManagement_v1.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `UAT / PRE-GO-LIVE`
- Status: `Active`
- Process: Travel request + travelers/plans -> approval -> trip and booking -> advance -> expense submission -> settlement -> close
- Human control: Manager/Admin/Finance approvals control request, advance, expense and settlement stages.
- Output: Traceable end-to-end business-travel and expense record.
- Workspace: [[03_Projects/ADMIN_ExpenseManagement_v1.1.0/00_Project_Home|Home]] | [[03_Projects/ADMIN_ExpenseManagement_v1.1.0/03_Process/TO_BE_Process|TO-BE]]

## HR

### [[03_Projects/HR.SS&PFD.v1.1|HR_EmployeeDataPlatform_v1.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Active`
- Process: Employee/applicant data -> collect or extract -> required-field validation -> standardize/match/deduplicate -> HR review -> Employee Master or prefilled application -> downstream sync
- Human control: HR controls identity conflicts, corrections, consent, permissions and final confirmation.
- Output: Trusted Group Employee Master plus controlled applicant intake.
- Workspace: [[03_Projects/HR.SS&PFD.v1.1/00_Project_Home|Home]] | [[03_Projects/HR.SS&PFD.v1.1/03_Process/TO_BE_Process|TO-BE]]

## Internal Chatbot & AI Platforms

### [[03_Projects/PPJ.AI.Hub.v2.1|AI_ApplicationHub_v2.1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Active`
- Process: User access -> AI application catalogue -> discover/search -> permission check -> launch application -> usage and support feedback
- Human control: Application owners govern catalogue entries, access and support ownership.
- Output: Single internal access layer for approved AI applications.
- Workspace: [[03_Projects/PPJ.AI.Hub.v2.1/00_Project_Home|Home]] | [[03_Projects/PPJ.AI.Hub.v2.1/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PPJ.PERRI.Chatbot|AI_PERRIPlatform_v3.2.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Active`
- Process: User question/request -> intent and permission -> agent/tool selection -> governed data/API call -> controlled answer or action -> audit and feedback
- Human control: Human approval is mandatory for sensitive or write/action operations.
- Output: Permissioned conversational orchestration across PPJ tools and knowledge.
- Workspace: [[03_Projects/PPJ.PERRI.Chatbot/00_Project_Home|Home]] | [[03_Projects/PPJ.PERRI.Chatbot/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/PPJ.GLPI-Helpdesk-AI Chatbot|PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0]]

- Delivery: `INTERNAL DEVELOPMENT` / `GO-LIVE / PRODUCTION / SUPPORT`
- Status: `Support`
- Process: User IT/ERP issue -> intent -> GLPI/helpdesk knowledge retrieval -> troubleshooting answer -> ticket/escalation when unresolved -> knowledge feedback
- Human control: IT Helpdesk validates guidance and owns escalation and knowledge maintenance.
- Output: Faster IT support with controlled handoff to human service.
- Workspace: [[03_Projects/PPJ.GLPI-Helpdesk-AI Chatbot/00_Project_Home|Home]] | [[03_Projects/PPJ.GLPI-Helpdesk-AI Chatbot/03_Process/TO_BE_Process|TO-BE]]

## External Collaboration

### [[03_Projects/PPJ.UIT.ACADEMIC.COLLABORATION.v1.1|EXT_AcademicCollaboration_v1.1.0]]

- Delivery: `EXTERNAL DEVELOPMENT` / `DESIGN`
- Status: `External Collaboration`
- Process: PPJ business problem -> academic problem framing + dataset -> student/research prototype -> benchmark -> PPJ expert evaluation -> handoff or stop decision
- Human control: PPJ owners approve scope, data boundaries, benchmark and production boundary.
- Output: Evaluated academic prototype and talent/research collaboration outcome.
- Workspace: [[03_Projects/PPJ.UIT.ACADEMIC.COLLABORATION.v1.1/00_Project_Home|Home]] | [[03_Projects/PPJ.UIT.ACADEMIC.COLLABORATION.v1.1/03_Process/TO_BE_Process|TO-BE]]

### [[03_Projects/AI Automation Workshop|AI.Automation.Workshop.202606]]

- Delivery: `INTERNAL DEVELOPMENT` / `CLOSED`
- Status: `Closed`
- Process: Business needs + participants -> workshop planning -> demonstrations and working sessions -> feedback/ideas -> action capture -> close
- Human control: Facilitators and business participants validated takeaways.
- Output: Closed workshop event and captured improvement opportunities.
- Workspace: [[03_Projects/AI Automation Workshop|Project Note]]

### [[03_Projects/Workshop Analysis|AI.Automation.Workshop.Analysis.202606]]

- Delivery: `INTERNAL DEVELOPMENT` / `CLOSED`
- Status: `Closed`
- Process: Workshop notes + feedback -> consolidate -> classify themes/opportunities -> analyze value/feasibility -> recommendations -> close
- Human control: AI/Automation team reviewed and prioritized conclusions.
- Output: Closed workshop analysis and recommendation record.
- Workspace: [[03_Projects/Workshop Analysis|Project Note]]

### [[03_Projects/VITAS Sharing|VITAS.Sharing.202606]]

- Delivery: `INTERNAL DEVELOPMENT` / `CLOSED`
- Status: `Closed`
- Process: Industry updates/cases -> prepare sharing content -> presentation/discussion -> networking and feedback -> lessons captured -> close
- Human control: Participants validated relevance and follow-up items.
- Output: Closed VITAS sharing event with retained knowledge.
- Workspace: [[03_Projects/VITAS Sharing/00_Project_Home|Home]] | [[03_Projects/VITAS Sharing/03_Process/TO_BE_Process|TO-BE]]

Related Concepts
[[Business Process Design]]
[[System Thinking]]
[[Data Governance]]
[[Human in the Loop]]

Methods
[[Impact Analysis]]
[[Data Mapping]]
[[Requirement Elicitation]]

Deliverables
[[Process Documentation]]
[[Decision_Driven_BRD]]
[[Automation Flow]]
