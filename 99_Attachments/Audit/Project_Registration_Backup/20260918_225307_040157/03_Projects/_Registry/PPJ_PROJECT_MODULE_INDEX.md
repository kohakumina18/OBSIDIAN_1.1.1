# PPJ Project Module Index

Generated: 2026-06-28

Purpose: group current canonical project notes by business cluster without renaming, moving, archiving, deleting, or merging project files.

## Accounting / Invoice Automation

- [[FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN.AI.FINANCE.MANAGEMENT.v1.2]]

- [[ACC.GRN-SupplierInvoiceBot.v2.3]]
- [[PPJ. Expense-Invoices.v1.1]]
- [[PPJ.Invoice Downloader.v1.2]]

- [[ACC.Inventory.Report.v1.0]]
## Sourcing / Material / Supplier Data

- [[SCP.SOURCING.CHATBOT.v2.3]]
- [[FD.Datamart.v2.2]]

## Purchasing Automation

- [[PUR.Adhoc Indent mien Nam]]
- [[PUR.GDI Automation|PUR.GDI.Automation.v1.0]]
- [[PUR.H&M Label-O Processing]]
- [[PUR.Inventory Report|PUR.Inventory.Report.v2.1]]
-[[PUR.Material.Allocation.v1.2]]]

## Merchandising / Costing

- [[MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1]]
- [[MER.PO-Commit]]
- [[PPJ.COSTING.AGENT.PLATFORM.v1.1|COSTING.AGENTIC.PLATFORM.v1.1]]
-[[E-commerce Market Intelligence v.2.3]]]

## Production / Factory / IoT / Wash

- [[PROD.COWASH]]
- [[PROD.IOT.CHuyenTreo_1]]
- [[WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1]]

## HR

- [[HR.SS&PFD.v1.1]]

## AI Platform / Chatbots / Hub

- [[PPJ.AI.Hub.v2.1]]
- [[PPJ.GLPI-Helpdesk-AI Chatbot]]
- [[PPJ.PERRI.Chatbot]]
- [[TD.TechnicalPlatform_v2.1|TD.TechnicalKnowledge.Platform.v2.1]]

## External Vendors / Partnerships

- [[PPJ XPrimo1D RFID Thread]]
- [[PPJxNUNOX|PPJxNUNOX.ScanTrial]]
- [[PPJxQSee.ai|PPJxQSee.AI]]
- [[PPJxStratova AI|PPJxStratova.AI]]

## Events / Workshops / Knowledge Sharing

- [[AI Automation Workshop]]
- [[VITAS Sharing]]
- [[Workshop Analysis]]

## Command / Index Notes

- [[PROJECT_COMMAND_CENTER]]

## Notes

- `PROJECT_COMMAND_CENTER.md` is an index / command center note, not a normal project note.
- `PPJ.AI.Hub.v2.1.md` is the central hub and should link to modules without absorbing individual project notes.
- External/vendor projects should remain separate engagement notes.
- Workshop notes should remain event/analysis notes, not product systems.

## FD / CPD Datamart Separation

- [[FD.Datamart.v2.2]]: FD / fabric datamart using Directus, including QR design or QR information formatting for hanger usage.
- [[CPD.Datamart.v1.1]]: CPD / 3D Design datamart for image search and 3D sample library.

These are separate projects and must not be merged.

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Authoritative Current-State Overlay - 2026-09-18

Source event: `PPJ-PORTFOLIO-SNAPSHOT-20260918`. This overlay supersedes older current-state rows below; older rows remain historical evidence.

| Canonical Code | Current File | Primary Domain | Delivery Stream | Delivery Stage | Lifecycle | Status | Current Gate | Priority | Current Outcome | Last Verified |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FIN_FinanceManagement_v1.2.0 | FIN.AI.FINANCE.MANAGEMENT.v1.1.md | Finance / Accounting | INTERNAL DEVELOPMENT | DESIGN | Strategic Active | Active | WS2 OC / Cost Control and WS3 Factory Performance | P1 | Centralized Finance Control Platform for completeness, correct OC/period, actual versus plan, missing cost, profitability, drill-down, factory performance and exception ownership. | 2026-09-18 |
| MER_CostingAgenticPlatform_v1.1.0 | PPJ.COSTING.AGENT.PLATFORM.v1.1.md | Merchandising | INTERNAL DEVELOPMENT | DEVELOPMENT | Active Development | Active | Sew Agent fixes and Wash Agent development | P2 | Generate a Costing / Quotation Package for Merchandising review and customer quotation through one platform. | 2026-09-18 |
| PUR_GDIAutomation_v1.0.0 | PUR.GDI Automation.md | Sourcing / Purchasing | INTERNAL DEVELOPMENT | DEVELOPMENT | Active Development / WFX API Integration | Active | WFX API integration and GDI data-entry workflow | P3 | Give Purchasing end-to-end package-dispatch tracking through GDI and provide API capability for automated/assisted GDI data entry while preserving WFX transaction control, validation, confirmation and audit. | 2026-09-18 |
| TD_TechnicalKnowledgePlatform_v2.1.0 | TD.TechnicalPlatform_v2.1.md | Fabric / Textiles Technique | INTERNAL DEVELOPMENT | UAT / PRE-GO-LIVE | Sync Validation & Stabilization | Active | Sync validation and canonical technical model | P5 | Technical Data Backbone for Pattern, BOM, Consumption, Construction, documents and historical records; upstream source for Costing, Sew Agent, BOM, Consumption, Pattern, Technical Search and Similar Style. | 2026-09-18 |
| ADMIN_ExpenseManagement_v1.1.0 | None - governance/candidate record only | Administration | INTERNAL DEVELOPMENT | UAT / PRE-GO-LIVE | Active / Requirement Refinement / UAT Preparation | Active | Multi-traveler request model, end-to-end lifecycle and UAT preparation | P6 | Standardize Administration business-travel and expense-management workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement. | 2026-09-18 |
| LOG_ExpenseInvoiceProcessing_v1.2.0 | PPJ. Expense-Invoices.v1.1.md | Logistics / EXIM | INTERNAL DEVELOPMENT | UAT / PRE-GO-LIVE | Regional Rollout / UAT | Active | Regional rollout, tax rules and invoice validation | P4 | Process Logistics / Import-Export expense invoices with regional and tax rules, invoice validation, user workflow and exception management. | 2026-09-18 |
| PUR_MaterialAllocation_v1.1.0 | PUR.Material.Allocation.v1.2.md | Sourcing / Purchasing | INTERNAL DEVELOPMENT | UAT / PRE-GO-LIVE | Validation / Stabilization | Active | Transaction reliability and exception control | P7 | Validate controlled reallocation of surplus material across eligible OCs: Material Requirement -> Availability -> Allocation -> Validation -> WFX Transaction. | 2026-09-18 |
| MER_MarketIntelligence_v1.1.0 | E-commerce Market Intelligence v.2.3.md | Merchandising | INTERNAL DEVELOPMENT | ANALYSIS | Active Intelligence | Active | Market and customer intelligence delivery | Medium | Turn market, customer, competitor, trend and demand signals into business intelligence for Merchandising. | 2026-09-18 |
| MER_InvoiceDataRecheck_v1.1.0 | MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md | Merchandising | INTERNAL DEVELOPMENT | UAT / PRE-GO-LIVE | Active | Active | Multi-customer invoice, cost and data checking | Medium | Cross-check costing data, commercial cost, invoice data and customer rules, route exceptions to user review. | 2026-09-18 |
| WASH_SamplingManagement_v1.1.0 | WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md | Production + Wash | INTERNAL DEVELOPMENT | DESIGN | Analysis / Product Design | Active | Sampling workflow and product design | Medium | Create a PPJ Group Portal workflow for Wash sample requests, planning, wash samples, results and approval. | 2026-09-18 |
| PROD_HangingLineIoT_v1.0.0 | PROD.IOT.CHuyenTreo_1.md | Production + Wash | INTERNAL DEVELOPMENT | DEVELOPMENT | Development | Active | Source and KPI reconciliation | Medium | Provide real-time production-line visibility: Production Line -> IoT / Machine Data -> WISER / INA -> Production Metrics -> Dashboard. | 2026-09-18 |
| WH_AWBExtraction_v1.1.0 | None - governance/candidate record only | Warehouse | INTERNAL DEVELOPMENT | DEVELOPMENT | Active Development | Active | AWB image OCR and DHL email extraction; table/cell understanding and weight/unit reliability | Medium | Canonical umbrella for AWB OCR + DHL email extraction: both channels converge into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates). | 2026-09-18 |
| HR_EmployeeDataPlatform_v1.1.0 | HR.SS&PFD.v1.1.md | HR | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Production / Expansion | Active | Production rollout and data-quality monitoring | P8 | Standardize employee data into a trusted Employee Master and Group HR Data Foundation, and support applicant extraction/prefill. | 2026-09-18 |
| SCP_SourcingChatbot_v2.3.0 | SCP.SOURCING.CHATBOT.v2.3.md | Sourcing / Purchasing | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Production | Active | Production monitoring, data quality and retrieval quality | P9 | One production application for supplier/material intelligence: Supplier Data + Material Data + Search + Comparison + RAG + Chatbot. | 2026-09-18 |
| FIN_InvoiceDownloader_v1.2.0 | PPJ.Invoice Downloader.v1.2.md | Finance / Accounting | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Production | Active | Operational reliability | Support | Acquire invoice documents/data: Invoice Source -> Download -> Store -> Structured Metadata (no accounting entry). | 2026-09-18 |
| PUR_InventoryReport_v2.1.0 | PUR.Inventory Report.md | Sourcing / Purchasing | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Production | Active | Post-enhancement support | Support | Purchasing operational inventory reporting: enhanced visibility, reports, tables, filters and material monitoring. | 2026-09-18 |
| AI_PERRIPlatform_v3.2.0 | PPJ.PERRI.Chatbot.md | Internal Chatbot & AI Platforms | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Production | Active | Permissioned production orchestration | Support | Operate PPJ's conversational orchestration platform: User -> PERRI -> Intent -> Agent / Tool -> Data / Knowledge / API -> Controlled Response / Action. | 2026-09-18 |
| AI_ApplicationHub_v2.1.0 | PPJ.AI.Hub.v2.1.md | Internal Chatbot & AI Platforms | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Internal Production Platform | Active | Platform operations | Support | AI application discovery, access and launch layer for the internal AI ecosystem. | 2026-09-18 |
| FAB_FabricDatamart_v2.2.0 | FD.Datamart.v2.2.md | Fabric / Textiles Technique | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Support | Support | Operational support | Support | Support the Fabric datamart: Fabric, Hanger, QR and material reference data with Directus, corrections, permissions and users. | 2026-09-18 |
| CPD_VisualSampleDatamart_v1.1.0 | CPD.Datamart.v1.1.md | Fabric / Textiles Technique | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Maintenance | Support | Operational maintenance | Support | Maintain the 3D / visual sample library: 3D, visual samples, images, design assets and image search. | 2026-09-18 |
| ACC_GRNSupplierInvoiceBot_v2.3.0 | ACC.GRN-SupplierInvoiceBot.v2.3.md | Finance / Accounting | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Production Support | Support | Operational stability and exceptions | Support | Operational automation bot for supplier invoice / GRN processing and system data entry: Validation -> Matching / Business Rules -> Data Preparation -> Automated Data Entry -> Target System -> Exception Handling. | 2026-09-18 |
| PUR_AdhocIndentSouth_v1.0.0 | PUR.Adhoc Indent mien Nam.md | Sourcing / Purchasing | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Maintenance | Support | Operational maintenance | Support | Maintain the existing stable indent automation (South region) and WFX compatibility. | 2026-09-18 |
| PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0 | PPJ.GLPI-Helpdesk-AI Chatbot.md | Internal Chatbot & AI Platforms | INTERNAL DEVELOPMENT | GO-LIVE / PRODUCTION / SUPPORT | Maintenance | Support | IT helpdesk maintenance | Support | Maintain the IT-specific Helpdesk AI for troubleshooting, FAQ, ERP support and knowledge retrieval. | 2026-09-18 |
| QC_DefectDetection_v1.0.0 | PPJxQSee.ai.md | QC / TQM | EXTERNAL DEVELOPMENT | ANALYSIS | On Hold | External Collaboration | Reactivation decision | Hold | Computer-vision inspection: Image -> Defect Detection -> Defect Classification -> QC Review. Named for the business capability, not the vendor. | 2026-09-18 |
| QC_ThreadTraceability_v1.0.0 | PPJ XPrimo1D RFID Thread.md | QC / TQM | EXTERNAL DEVELOPMENT | ANALYSIS | Pre-PoC / Business Case | External Collaboration | Business/customer case decision | Decision | Evaluate RFID / thread identification and traceability only when QC need, MER commercial case, customer willingness to pay and factory feasibility align. | 2026-09-18 |
| PPJxStratova.AI | PPJxStratova AI.md | Fabric / Textiles Technique | EXTERNAL DEVELOPMENT | CLOSED | Closed | Closed | Historical record; current Stratova PoC negotiation tracked as DISCOVERY_PatternGenerationPoC | Closed | Historical closed record of the earlier Stratova evaluation. Do not reuse this code for the current pattern-generation PoC. | 2026-09-18 |
| PPJxNUNOX.ScanTrial | PPJxNUNOX.md | Fabric / Textiles Technique | EXTERNAL DEVELOPMENT | ANALYSIS | Partnership / Digital Library Evaluation | External Collaboration | Working-session outcome unconfirmed | Decision | Evaluate fabric scanning and Fabric/Garment Digital Library potential. | 2026-09-18 |
| EXT_AcademicCollaboration_v1.1.0 | PPJ.UIT.ACADEMIC.COLLABORATION.v1.1.md | External Collaboration | EXTERNAL DEVELOPMENT | DESIGN | Active / Problem Framing | External Collaboration | Academic problem package | Medium | Academic collaboration: UIT, thesis and student projects, competitions, research, prototype development and talent pipeline. | 2026-09-18 |
| WASH_COWASH_v2.0.0 | PROD.COWASH.md | Production + Wash | EXTERNAL DEVELOPMENT | ANALYSIS | On Hold | External Collaboration | Delivery paused | Hold | Production wash operations platform (operational wash data, machine, output, delay, rework); distinct from WASH_SamplingManagement_v1.1.0. | 2026-09-18 |
| PUR_HMLabelProcessing_v1.0.0 | PUR.H&M Label-O Processing.md | Sourcing / Purchasing | INTERNAL DEVELOPMENT | ANALYSIS | On Hold | On Hold | Business priority paused | Hold | Hold H&M Label-O processing automation pending a scalable business case; name shortened to the actual process. | 2026-09-18 |
| ACC_InventoryReport_v1.0.0 | ACC.Inventory.Report.v1.0.md | Finance / Accounting | INTERNAL DEVELOPMENT | CLOSED | Closed | Closed | Closed / no active follow-up | Closed | Preserve the completed Accounting inventory-report history with no active delivery. | 2026-09-18 |
| MER_POCommit_v1.1.0 | MER.PO-Commit.md | Merchandising | INTERNAL DEVELOPMENT | CLOSED | Closed | Closed | Closed | Closed | Preserve the closed PO Commit project history (Customer Order -> MER PO Creation; ~70-80% of customer scenarios covered). | 2026-09-18 |
| EXIM.ExpenseInvoices.Automation.v1.1 | EXIM.ExpenseInvoices.Automation.v1.1.md | Finance / Accounting | INTERNAL DEVELOPMENT | CLOSED | Closed | Closed | Replaced / Closed; succeeded by LOG_ExpenseInvoiceProcessing_v1.2.0 | Closed | Preserve the closed legacy EXIM Expense Invoice Automation history separately from its successor. | 2026-09-18 |
| AI.Automation.Workshop.202606 | AI Automation Workshop.md | External Collaboration | INTERNAL DEVELOPMENT | CLOSED | Closed | Closed | Closed event | Closed | Preserve the June 2026 AI Automation Workshop record. | 2026-09-18 |
| AI.Automation.Workshop.Analysis.202606 | Workshop Analysis.md | External Collaboration | INTERNAL DEVELOPMENT | CLOSED | Closed | Closed | Closed analysis | Closed | Preserve the June 2026 workshop analysis record. | 2026-09-18 |
| VITAS.Sharing.202606 | VITAS Sharing.md | External Collaboration | INTERNAL DEVELOPMENT | CLOSED | Closed | Closed | Closed event | Closed | Preserve the June 2026 VITAS sharing record. | 2026-09-18 |
| CPD In-house Pattern Generation | None - governance/candidate record only | Fabric / Textiles Technique | Candidate / Not Registered | Candidate / Not Registered | Internal Prototype / Evaluation | Candidate | Build-vs-buy benchmark; canonical code pending | P10 | Build an internal pattern-generation benchmark from techpack/image/measurement inputs with Pattern Engineer and CAD validation. | 2026-09-18 |
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

<!-- PPJ_REGISTERED_PROJECT_MODULES_START -->
## Registered Projects

- [[WH_AWBExtraction_v1.1.0]]
<!-- PPJ_REGISTERED_PROJECT_MODULES_END -->
