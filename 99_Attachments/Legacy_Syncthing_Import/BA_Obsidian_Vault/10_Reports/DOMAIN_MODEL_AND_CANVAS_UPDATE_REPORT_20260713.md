# Domain Model and Canvas Update Report

Date: 2026-07-13

## Executive Summary

Applied the official Primary Domain model for PPJ portfolio governance. Primary Domain is based on business owner, primary users, and primary capability. Lifecycle and progress remain separate.

## Domain Model Applied
- External Collaboration: Academic partnership, innovation, prototype, talent pipeline
- QC / TQM: Quality inspection, defect detection, traceability
- Sourcing / Purchasing: Supplier/material intelligence and purchasing transactions
- Merchandising: Costing, quotation, market intelligence, customer workflows
- Production + Wash: Factory execution, production data, wash operations
- Finance / Accounting: Financial analysis, reporting, invoices, GRN
- Internal Chatbot & AI Platforms: AI access, agent orchestration, helpdesk, shared platforms
- HR: Employee, payroll, BHXH and HR-sensitive workflows
- Fabric / Textiles Technique: Fabric, pattern, BOM, technical knowledge, 3D and scanning

## Canonical Code Corrections
- MER.MARKET.INTELLIGENCE.v5.5 -> MER.MARKET.INTELLIGENCE.v1.1: Official version reset to v1.1
- FD.HangerQR-Library.v2.2 -> FD.Datamart.v2.2: Official FD/fabric Directus QR hanger datamart name
- PPJ.GLPI.Helpdesk.v1.0 -> PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0: Official GLPI AI chatbot code
- CPD.3D&Pattern.MGMT.v1.1 -> CPD.Datamart.v1.1: Official CPD/3D visual datamart code
- WASH.SAMPLING.MGMT.PORTAL.v1.1 -> WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1: Official expanded Wash Sampling Management code

## Current File vs Canonical Code Mapping
- PPJ.UIT.ACADEMIC.COLLABORATION.v1.1.md -> PPJ.UIT.ACADEMIC.COLLABORATION.v1.1
- PPJxQSee.ai.md -> PPJxQSee.AI
- PPJ XPrimo1D RFID Thread.md -> QC.Primo1D.RFID.Thread.v1.0
- SCP.SOURCING.CHATBOT.v2.3.md -> SCP.SOURCING.CHATBOT.v2.3
- PUR.Adhoc Indent mien Nam.md -> PUR.Adhoc.Indent.South.v1.0
- PUR.Material.Allocation.v1.1.md -> PUR.Material.Allocation.v1.1
- PUR.Inventory Report.md -> PUR.Inventory.Report.v1.0
- PUR.GDI Automation.md -> PUR.GDI.Automation.v1.0
- PUR.H&M Label-O Processing.md -> PUR.HM.LabelO.Processing.Automation.v1.0
- PPJ.COSTING.AGENT.PLATFORM.v1.1.md -> COSTING.AGENTIC.PLATFORM.v1.1
- MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md -> MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1
- E-commerce Market Intelligence.md -> MER.MARKET.INTELLIGENCE.v1.1
- MER.PO-Commit.md -> MER.PO.Commit.v1.1
- PROD.IOT.CHuyenTreo_1.md -> PROD.IOT.CHuyenTreo.v1.0
- PROD.COWASH.md -> PROD.COWASH.v2.0
- WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md -> WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1
- FIN.AI.FINANCE.MANAGEMENT.v1.1.md -> FIN.AI.FINANCE.MANAGEMENT.v1.1
- PPJ. Expense-Invoices.v1.1.md -> PPJ.ExpenseInvoices.v1.1
- ACC.GRN-SupplierInvoiceBot.v2.3.md -> ACC.GRN-SupplierInvoiceBot.v2.3
- PPJ.Invoice Downloader.v1.2.md -> PPJ.InvoiceDownloader.v1.2
- PPJ.AI.Hub.v2.1.md -> PPJ.AI.Hub.v2.1
- PPJ.PERRI.Chatbot.md -> PPJ.PERRI.Chatbot.v3.2
- PPJ.GLPI-Helpdesk-AI Chatbot.md -> PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0
- HR.SS&PFD.v1.1.md -> HR.SSPFD.Workflow.v1.1
- FD.Datamart.v2.2.md -> FD.Datamart.v2.2
- TD.TechnicalPlatform_v2.1.md -> TD.TechnicalKnowledge.Platform.v2.1
- CPD.Datamart.v1.1.md -> CPD.Datamart.v1.1
- PPJxNUNOX.md -> PPJxNUNOX.ScanTrial
- PPJxStratova AI.md -> PPJxStratova.AI

## Projects by Domain
- External Collaboration: 1
- QC / TQM: 2
- Sourcing / Purchasing: 6
- Merchandising: 4
- Production + Wash: 3
- Finance / Accounting: 4
- Internal Chatbot & AI Platforms: 3
- HR: 1
- Fabric / Textiles Technique: 5

## Lifecycle and Progress Separation
Lifecycle values are stored separately from progress. Percentages are stored only as Progress.

## Cross-Functional Secondary Tags
Secondary domains are tags only and do not duplicate project cards across domains.

## Missing Official Project Notes
- None

## Alias Map Updates
Alias overlay updated when -UpdateAliasMap was provided.

## Memory Updates
Memory cards updated when -UpdateMemory was provided.

## Registry Updates
Registry, memory index, and naming dictionary overlays updated when -UpdateRegistry was provided.

## Project Note Updates
Skipped; -UpdateProjectNotes was not provided.

## Resource Matrix Updates
Resource matrix domain overlay updated when -UpdateResourceMatrix was provided.

## Canvas Created
- 03_Projects/Canvas/PPJ_Domain_Encapsulation.canvas

## Hard Stops
- None

## Validation Results
- Domain duplication check completed.
- Canvas JSON check completed if Canvas was created.
- Boundary checks completed.

## Remaining Warnings
- None

## Next Recommended Step
Review the new Domain Encapsulation Canvas and approve any later canonical file renames separately if desired.

