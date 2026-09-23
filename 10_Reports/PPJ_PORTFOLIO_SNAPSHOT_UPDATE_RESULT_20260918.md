# PPJ Portfolio Snapshot Update Result - 2026-09-18

## Executive Summary

The 18/09/2026 naming and portfolio baseline (`PPJ-PORTFOLIO-SNAPSHOT-20260918`) is now the authoritative current-state overlay. Canonical codes follow `<DEPARTMENT>_<APPLICATION>_v<MAJOR>.<MINOR>.<PATCH>`; lifecycle is kept outside the project ID; vendor and discovery activity is kept outside the canonical registry. Physical note and folder names are unchanged and resolve through the alias map.

## Delivery Pipeline

- INTERNAL / DEVELOPMENT: MER_CostingAgenticPlatform_v1.1.0, PUR_GDIAutomation_v1.0.0, PROD_HangingLineIoT_v1.0.0, WH_AWBExtraction_v1.1.0
- INTERNAL / UAT / PRE-GO-LIVE: TD_TechnicalKnowledgePlatform_v2.1.0, ADMIN_ExpenseManagement_v1.1.0, LOG_ExpenseInvoiceProcessing_v1.2.0, PUR_MaterialAllocation_v1.1.0, MER_InvoiceDataRecheck_v1.1.0
- INTERNAL / GO-LIVE / PRODUCTION / SUPPORT: HR_EmployeeDataPlatform_v1.1.0, SCP_SourcingChatbot_v2.3.0, FIN_InvoiceDownloader_v1.2.0, PUR_InventoryReport_v2.1.0, AI_PERRIPlatform_v3.2.0, AI_ApplicationHub_v2.1.0, FAB_FabricDatamart_v2.2.0, CPD_VisualSampleDatamart_v1.1.0, ACC_GRNSupplierInvoiceBot_v2.3.0, PUR_AdhocIndentSouth_v1.0.0, PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0
- EXTERNAL DEVELOPMENT: QC_DefectDetection_v1.0.0, QC_ThreadTraceability_v1.0.0, PPJxStratova.AI, PPJxNUNOX.ScanTrial, EXT_AcademicCollaboration_v1.1.0, WASH_COWASH_v2.0.0

## Changes From The 2026-08-24 Snapshot

- Registered: WH_AWBExtraction_v1.1.0 (AWB OCR + DHL email extraction, one project).
- Domains added: Administration, Warehouse, Logistics / EXIM.
- Renamed: 29 projects (see the Legacy To Canonical Name Map in the current snapshot).
- Stage moves: PUR_GDIAutomation_v1.0.0 to DEVELOPMENT; ADMIN_ExpenseManagement_v1.1.0 to UAT / PRE-GO-LIVE; PUR_HMLabelProcessing_v1.0.0 is On Hold (not Closed); PPJxStratova.AI is Closed (historical).
- Discovery register: DISCOVERY_PatternGenerationPoC, Wizcore, Faceworks AI, Sortech, Quanskill.

## Applied Updates

- Last apply invocation wrote 43 changed files.
- Memory cards / root notes / workspace documents: 2 / 2 / 14
- Tasks created / updated / closed: 10 / 0 / 0
- Local boards / global canvases / registry files: 2 / 3 / 5

## Open Items

See `Governance Exceptions` in [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT]].
