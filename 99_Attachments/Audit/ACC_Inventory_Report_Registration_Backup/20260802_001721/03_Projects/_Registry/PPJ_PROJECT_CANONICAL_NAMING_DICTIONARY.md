# PPJ Project Canonical Naming Dictionary

Purpose: source-of-truth mapping from spoken names, old filenames, aliases, and informal project names to canonical project codes.

## Naming Standard

```text
[DEPT/DOMAIN].[OBJECT].[CHARACTERISTIC].vX.Y
```

Rules:

- Discuss each project by canonical code when possible.
- Do not rename project files without approval.
- Do not split consolidated projects without approval.
- Do not merge separate projects because names sound similar.
- Explicit user correction is stronger than generated text.

## Scope Locks

- `FD.Datamart.v2.2` is separate from `CPD.Datamart.v1.1`.
- `SCP.SOURCING.CHATBOT.v2.3` is consolidated for Sourcing; do not split into repository/sample/chatbot notes without approval.
- `COSTING.AGENTIC.PLATFORM.v1.1` includes aliases such as Costing Intelligence, MER Costing, Merchandising Intelligence, and Costing Chatbot.
- `PPJ.AI.Hub.v2.1` is an app/tool hub, not a project documentation merge.
- `MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1` is MER-led unless evidence proves otherwise.

## Canonical Project Dictionary

| Canonical Code                             | Main Alias / Old Names                                                         | Cluster                                   | Phase                                  | Owner / Members                  | Current Note                              | Core Meaning                                                                                           |
| ------------------------------------------ | ------------------------------------------------------------------------------ | ----------------------------------------- | -------------------------------------- | -------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `PPJ.AI.Hub.v2.1`                          | AI Hub, PPJ AI Hub                                                             | AI Hub / Internal App Hub                 | Platform / Internal Hub                | AI / Automation Team             | [[PPJ.AI.Hub.v2.1]]                       | Internal app/tool center for AI tools, bots, automation apps, and utilities.                           |
| `PPJ.PERRI.Chatbot.v3.2`                   | PERRI Chatbot, PPJ PERRI, General Assistant                                    | AI Orchestrator / Internal Chatbot        | Production / Permission Enhancement    | Nam; multi-department            | [[PPJ.PERRI.Chatbot]]                     | Internal chatbot/orchestrator with department-level agents and permission control.                     |
| `PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0`        | GLPI Helpdesk, Helpdesk AI                                                     | IT / ERP Helpdesk AI                      | Maintenance and Support                | Huy                              | [[PPJ.GLPI-Helpdesk-AI Chatbot]]          | Helpdesk chatbot for IT/ERP/GLPI knowledge support and ticket guidance.                                |
| `SCP.SOURCING.CHATBOT.v2.3`                | Sourcing Chatbot, Sourcing Repository, External Sample Repository              | Sourcing AI / Data Platform               | Development / Data Strategy Discussion | Huy, Khoa, Linh, Nghia           | [[SCP.SOURCING.CHATBOT.v2.3]]             | Consolidated Sourcing data platform and chatbot for supplier/material/fabric/trims/sample lookup.      |
| `COSTING.AGENTIC.PLATFORM.v1.1`            | Costing Intelligence, MER Costing, Merchandising Intelligence, Costing Chatbot | Costing Agentic Platform                  | Analysis / Strategic Platform          | Lam, Khoa, Uyen; MER             | [[PPJ.COSTING.AGENT.PLATFORM.v1.1]]       | Strategic agentic platform for multi-step technical costing and quotation.                             |
| `TD.TechnicalKnowledge.Platform.v2.1`      | TD.TechnicalPlatform_v2.1, Anh Tu platform                                     | Technical Knowledge / Training            | New Request / Analysis                 | Huy, Khoa; Anh Tu                | [[TD.TechnicalPlatform_v2.1]]             | Technical knowledge platform for buyer reference, pattern, BOM, costing history, training, and videos. |
| `FD.Datamart.v2.2`                         | FD Hanger, QR Hanger, FD Fabric Datamart                                       | FD / Fabric Datamart / QR Hanger          | Stabilize / Onboarding                 | Nghia, Nam, Khoa                 | [[FD.Datamart.v2.2]]                      | FD Directus fabric/hanger datamart with QR information and QR Format Designer.                         |
| `CPD.Datamart.v1.1`                        | CPD DataMart, CPD / 3D Design Datamart                                         | CPD / 3D Sample Library                   | Development / Data Foundation          | Linh, Phat                       | [[CPD.Datamart.v1.1]]                     | CPD / 3D Design datamart for image search, 3D sample library, and visual assets.                       |
| `WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1`     | RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1                                       | Wash R&D Portal                           | New Booking / Analysis                 | R&D Wash; Nam                    | [[WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1]]  | Portal for R&D Wash sampling workflow, sample status, attachments, and permissions.                    |
| `MER.MARKET.INTELLIGENCE.v1.1`             | E-commerce Market Intelligence, Quince, Market Intelligence                    | Market / Product Intelligence             | Analysis                               | Phat, Nghia, Khoa                |[[E-commerce Market Intelligence v.2.3]]]        | Market/product intelligence using internal and external signals for MER decisions.                     |
| `PUR.Inventory.Report.v1.0`                | Purchasing Inventory Report, Inventory Report                                  | Purchasing Report                         | Maintenance and Support                | Nam                              | [[PUR.Inventory Report]]                  | Purchasing inventory reporting and lookup.                                                             |
| `PPJ.InvoiceDownloader.v1.2`               | Invoice Downloader, SYS.INVOICES.DOWNLOAD.v1.2                                 | Invoice API / Download Automation         | Production / API Enhancement           | Khoa, Nam                        | [[PPJ.Invoice Downloader.v1.2]]           | API/tool for e-invoice download, merge, and GPT/PERRI-enabled access.                                  |
| `PPJ.ExpenseInvoices.v1.1`                 | Accounting Expense Invoices, PPJ Expense-Invoices                              | Expense Invoice Platform                  | Analysis / Design                      | Accounting / related departments | [[PPJ. Expense-Invoices.v1.1]]            | Expense invoice mapping/workflow foundation with ledger and department mapping dependency.             |
| `MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1`    | Chico's Costing & Invoice Recheck Audit                                        | MER Invoice / Costing Audit               | Stabilize                              | Hien, Khoa; MER                  | [[MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1]] | MER-led Chico's invoice/costing recheck and audit automation pilot.                                    |
| `ACC.GRN-SupplierInvoiceBot.v2.3`          | GRN Supplier Invoice Bot, v1.1 alias                                           | Accounting ERP Bot                        | Maintenance and Support                | Hien, Khoa                       | [[ACC.GRN-SupplierInvoiceBot.v2.3]]       | Bot for Accounting GRN and supplier invoice automation.                                                |
| `EXIM.ExpenseInvoices.Automation.v1.1`     | EXIM Expense Invoice Bot                                                       | EXIM ERP Automation                       | Onboarding                             | Hien, Khoa                       | TBD                                       | EXIM expense invoice automation into WFX.                                                              |
| `PUR.Material.Allocation.v1.1`             | Material Allocation Automation                                                 | Purchasing Workflow                       | Analysis / Early Development           | Uyen, Khoa                       |[[PUR.Material.Allocation.v1.2]]]          | Material allocation/transfer/borrow workflow with WFX dependency and validation.                       |
| `PUR.GDI.Automation.v1.0`                  | GDI Automation                                                                 | Purchasing Workflow                       | On Hold                                | Hien, Khoa                       | [[PUR.GDI Automation]]                    | GDI creation automation blocked by WFX/system readiness.                                               |
| `PUR.Adhoc.Indent.South.v1.0`              | Adhoc Indent mien Nam                                                          | Purchasing Workflow                       | Maintenance and Support                | Hien                             | [[PUR.Adhoc Indent mien Nam]]             | Production/support automation for South-region adhoc indent workflow.                                  |
| `PUR.HM.LabelO.Processing.Automation.v1.0` | H&M Label-O Processing                                                         | Purchasing / Customer-specific Automation | On Hold / Delayed                      | Khoa, Nam                        | [[PUR.H&M Label-O Processing]]            | Customer-specific H&M Label-O processing automation.                                                   |
| `MER.PO.Commit.v1.1`                       | MER.PO Commit, PO Commit                                                       | MER Workflow                              | Closed / Production Support            | Lam, Uyen                        | [[MER.PO-Commit]]                         | PO processing support to create OC template, NPL file, and Packing List.                               |
| `PROD.IOT.CHuyenTreo.v1.0`                 | Chuyen treo ver1, PROD.IOT.CHuyenTreo_1                                        | Production IoT / Dashboard                | Development                            | Linh                             | [[PROD.IOT.CHuyenTreo_1]]                 | Realtime dashboard/report from production line hanger data.                                            |
| `PROD.COWASH.v2.0`                         | COWASH ver2, PROD.COWASH                                                       | Production / Wash Dashboard               | On Hold / Re-scope                     | Linh                             | [[PROD.COWASH]]                           | Cowash data dashboard/reporting initiative requiring source/API/KPI rescope.                           |
| `HR.SSPFD.Workflow.v1.1`                   | HR.SS&PFD.v1.1, BHXH WISER data                                                | HR / Internal Process                     | Analysis / Data Confirmation           | HR                               | [[HR.SS&PFD.v1.1]]                        | HR/BHXH workflow needing latest 3-month WISER data.                                                    |
| `PPJxQSee.AI`                              | QSee.ai, PPJ x QSee.ai                                                         | External Collaboration                    | NDA approved / Use case discussion     | QC, Khoa                         | [[PPJxQSee.ai]]                           | Vendor exploration for QC/production AI inspection use cases.                                          |
| `PPJxNUNOX.ScanTrial`                      | PPJ x NUNOX, NUNOX                                                             | Hardware Trial                            | Trials / Free of Charge                | Sourcing, Khoa                   | [[PPJxNUNOX]]                             | High-quality fabric sample scan trial for image/data foundation.                                       |
| `PPJxStratova.AI`                          | Stratova AI                                                                    | External Collaboration / Closed           | Canceled                               | Khoa                             | [[PPJxStratova AI]]                       | Canceled Pattern AI vendor exploration due unclear PoC/resource.                                       |
| `QC.Primo1D.RFID.Thread.v1.0`              | PPJ XPrimo1D RFID Thread                                                       | RFID / QC Exploration                     | Exploration                            | QC, Khoa                         | [[PPJ XPrimo1D RFID Thread]]              | RFID thread exploration for traceability/product identification.                                       |
| `VITAS.Sharing.202606`                     | VITAS Sharing                                                                  | External Sharing                          | Follow-up / External Sharing           | Management                       | [[VITAS Sharing]]                         | External sharing activity for PPJ AI/Automation story and case studies.                                |
| `AI.Automation.Workshop.202606`            | AI Automation Workshop                                                         | Workshop / Event                          | Closed                                 | AI Automation                    | [[AI Automation Workshop]]                | Completed internal AI/Automation workshop.                                                             |
| `AI.Automation.Workshop.Analysis.202606`   | Workshop Analysis                                                              | Feedback Intake / Analysis                | Analysis                               | AI Automation                    | [[Workshop Analysis]]                     | Post-workshop feedback analysis and use case backlog shaping.                                          |
| `PROJECT_COMMAND_CENTER`                   | PROJECT_COMMAND_CENTER.md                                                      | Command / Index                           | Internal Index                         | Portfolio governance             | [[PROJECT_COMMAND_CENTER]]                | Navigation/index note for project portfolio governance.                                                |
| `PPJ.GenAI.Cloud.Infrastructure.POC.v1.0`  | GenAI & Cloud Infrastructure, Gemini Enterprise, GCP Backup & GCE              | Cloud / GenAI Infrastructure              | Discovery / Proposal                   | PPJ, Google Cloud, Cloud Ace     | TBD                                       | Candidate initiative for GenAI/cloud infrastructure; needs portfolio confirmation.                     |

## Discussion Mapping Rules

| If user says                              | Interpret as                            |
| ----------------------------------------- | --------------------------------------- |
| costing platform                          | `COSTING.AGENTIC.PLATFORM.v1.1`         |
| sourcing chatbot                          | `SCP.SOURCING.CHATBOT.v2.3`             |
| FD hanger / QR hanger                     | `FD.Datamart.v2.2`                      |
| CPD datamart                              | `CPD.Datamart.v1.1`                     |
| technical platform của anh Tứ             | `TD.TechnicalKnowledge.Platform.v2.1`   |
| invoice downloader                        | `PPJ.InvoiceDownloader.v1.2`            |
| Chico's audit                             | `MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1` |
| expense invoice                           | `PPJ.ExpenseInvoices.v1.1`              |
| GRN supplier invoice bot                  | `ACC.GRN-SupplierInvoiceBot.v2.3`       |
| wash sampling portal                      | `WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1`  |
| market intelligence / e-commerce / Quince | `MER.MARKET.INTELLIGENCE.v1.1`          |
| HR BHXH WISER data                        | `HR.SSPFD.Workflow.v1.1`                |
| Primo1D / RFID thread                     | `QC.Primo1D.RFID.Thread.v1.0`           |

<!-- PPJ_DOMAIN_CANONICAL_OVERLAY_START -->
## Official Domain Model Canonical Corrections

Last updated: 2026-07-13

| Canonical Code | Current Storage Note | Primary Domain | Alias / Old Names | Rename Pending |
| --- | --- | --- | --- | --- |
| `PPJ.UIT.ACADEMIC.COLLABORATION.v1.1` | [[PPJ.UIT.ACADEMIC.COLLABORATION.v1.1]] | External Collaboration | PPJ x UIT Academic Collaboration; UIT partnership; AISC | No |
| `PPJxQSee.AI` | [[PPJxQSee.ai]] | QC / TQM | PPJxQSee.ai; QSee.ai; QSee | No |
| `QC.Primo1D.RFID.Thread.v1.0` | [[PPJ XPrimo1D RFID Thread]] | QC / TQM | PPJ XPrimo1D RFID Thread; Primo1D RFID Thread; RFID Thread | Yes - pending explicit rename approval |
| `SCP.SOURCING.CHATBOT.v2.3` | [[SCP.SOURCING.CHATBOT.v2.3]] | Sourcing / Purchasing | Sourcing Chatbot; SCP.Sourcing-Chatbot.ver2; Sourcing VER2 | No |
| `PUR.Adhoc.Indent.South.v1.0` | [[PUR.Adhoc Indent mien Nam]] | Sourcing / Purchasing | PUR.Adhoc Indent mien Nam; Adhoc Indent mien Nam; Adhoc Indent | Yes - pending explicit rename approval |
| `PUR.Material.Allocation.v1.1` |[[PUR.Material.Allocation.v1.2]]] | Sourcing / Purchasing | Material Allocation; Material Allocation Automation | No |
| `PUR.Inventory.Report.v1.0` | [[PUR.Inventory Report]] | Sourcing / Purchasing | PUR.Inventory Report; Purchasing Inventory Report; Inventory Report | Yes - pending explicit rename approval |
| `PUR.GDI.Automation.v1.0` | [[PUR.GDI Automation]] | Sourcing / Purchasing | PUR.GDI Automation; PUR.GDI.Automation; GDI Automation | Yes - pending explicit rename approval |
| `PUR.HM.LabelO.Processing.Automation.v1.0` | [[PUR.H&M Label-O Processing]] | Sourcing / Purchasing | PUR.H&M Label-O Processing; H&M Label-O Processing; H&M Label-O | Yes - pending explicit rename approval |
| `COSTING.AGENTIC.PLATFORM.v1.1` | [[PPJ.COSTING.AGENT.PLATFORM.v1.1]] | Merchandising | PPJ.COSTING.AGENT.PLATFORM.v1.1; MER Costing Intelligence; Costing Intelligence | Yes - pending explicit rename approval |
| `MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1` | [[MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1]] | Merchandising | MER.Chico's.Costing-Invoice.Recheck-Audit.v1.1; Chico's audit; Chico's recheck | No |
| `MER.MARKET.INTELLIGENCE.v1.1` |[[E-commerce Market Intelligence v.2.3]]] | Merchandising | MER.MARKET.INTELLIGENCE.v5.5; E-commerce Market Intelligence; Market Intelligence | Yes - pending explicit rename approval |
| `MER.PO.Commit.v1.1` | [[MER.PO-Commit]] | Merchandising | MER.PO-Commit; MER.PO Commit; PO Commit | Yes - pending explicit rename approval |
| `PROD.IOT.CHuyenTreo.v1.0` | [[PROD.IOT.CHuyenTreo_1]] | Production + Wash | PROD.IOT.CHuyenTreo_1; Chuyen Treo IoT Dashboard; Chuyen treo ver1 | Yes - pending explicit rename approval |
| `PROD.COWASH.v2.0` | [[PROD.COWASH]] | Production + Wash | PROD.COWASH; COWASH ver2; Cowash VER2 | Yes - pending explicit rename approval |
| `WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1` | [[WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1]] | Production + Wash | WASH.SAMPLING.MGMT.PORTAL.v1.1; RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1 | No |
| `FIN.AI.FINANCE.MANAGEMENT.v1.1` | [[FIN.AI.FINANCE.MANAGEMENT.v1.1]] | Finance / Accounting | AI-assisted Finance Management; Finance AI Analytics | No |
| `PPJ.ExpenseInvoices.v1.1` | [[PPJ. Expense-Invoices.v1.1]] | Finance / Accounting | PPJ. Expense-Invoices.v1.1; Accounting Expense Invoices | Yes - pending explicit rename approval |
| `ACC.GRN-SupplierInvoiceBot.v2.3` | [[ACC.GRN-SupplierInvoiceBot.v2.3]] | Finance / Accounting | ACC.GRN-SupplierInvoiceBot.v1.1; GRN Supplier Invoice Bot | No |
| `PPJ.InvoiceDownloader.v1.2` | [[PPJ.Invoice Downloader.v1.2]] | Finance / Accounting | PPJ.Invoice Downloader.v1.2; SYS.Invoices.Download & Merging; Invoice Downloader | Yes - pending explicit rename approval |
| `PPJ.AI.Hub.v2.1` | [[PPJ.AI.Hub.v2.1]] | Internal Chatbot & AI Platforms | AI Hub; Web Tong Hop Tool; Web Tá»•ng Há»£p Tool | No |
| `PPJ.PERRI.Chatbot.v3.2` | [[PPJ.PERRI.Chatbot]] | Internal Chatbot & AI Platforms | PPJ.PERRI.Chatbot; PERRI Chatbot; PPJ PERRI | Yes - pending explicit rename approval |
| `PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0` | [[PPJ.GLPI-Helpdesk-AI Chatbot]] | Internal Chatbot & AI Platforms | PPJ.GLPI.Helpdesk.v1.0; PPJ.GLPI-Helpdesk-AI Chatbot; GLPI Helpdesk AI | Yes - pending explicit rename approval |
| `HR.SSPFD.Workflow.v1.1` | [[HR.SS&PFD.v1.1]] | HR | HR.SS&PFD.v1.1; HR Project | Yes - pending explicit rename approval |
| `FD.Datamart.v2.2` | [[FD.Datamart.v2.2]] | Fabric / Textiles Technique | FD.HangerQR-Library.v2.2; FD Hanger; QR Hanger | No |
| `TD.TechnicalKnowledge.Platform.v2.1` | [[TD.TechnicalPlatform_v2.1]] | Fabric / Textiles Technique | TD.TechnicalPlatform_v2.1; Tech.Knowledge.Platform.v2.1; Anh Tu platform | Yes - pending explicit rename approval |
| `CPD.Datamart.v1.1` | [[CPD.Datamart.v1.1]] | Fabric / Textiles Technique | CPD.3D&Pattern.MGMT.v1.1; CPD DataMart; CPD / 3D Design Datamart | No |
| `PPJxNUNOX.ScanTrial` | [[PPJxNUNOX]] | Fabric / Textiles Technique | PPJxNUNOX; PPJ x NUNOX; PPJ x Nunox; NUNOX | Yes - pending explicit rename approval |
| `PPJxStratova.AI` | [[PPJxStratova AI]] | Fabric / Textiles Technique | PPJxStratova AI; PPJ x Stratova AI; Stratova AI | Yes - pending explicit rename approval |

### Board Code Corrections

| Old / Board Code | New Canonical Code | Reason |
| --- | --- | --- |
| `MER.MARKET.INTELLIGENCE.v5.5` | `MER.MARKET.INTELLIGENCE.v1.1` | Official version reset to v1.1 |
| `FD.HangerQR-Library.v2.2` | `FD.Datamart.v2.2` | Official FD/fabric Directus QR hanger datamart name |
| `PPJ.GLPI.Helpdesk.v1.0` | `PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0` | Official GLPI AI chatbot code |
| `CPD.3D&Pattern.MGMT.v1.1` | `CPD.Datamart.v1.1` | Official CPD/3D visual datamart code |
| `WASH.SAMPLING.MGMT.PORTAL.v1.1` | `WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1` | Official expanded Wash Sampling Management code |

<!-- PPJ_DOMAIN_CANONICAL_OVERLAY_END -->


