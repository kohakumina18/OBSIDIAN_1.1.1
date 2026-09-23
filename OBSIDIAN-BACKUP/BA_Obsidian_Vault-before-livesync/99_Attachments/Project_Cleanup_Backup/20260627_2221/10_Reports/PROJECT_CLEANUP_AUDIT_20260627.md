# PPJ Project Cleanup Audit - 20260627  Generated: 2026-06-27 21:51  ## Executive Summary  The audit found duplicate, alias, naming, and governance consistency issues in the PPJ project knowledge base. No project notes or Canvas files were modified during this audit.  ## File Count  - Top-level project Markdown files scanned: 45 - Project_SmartFlow excluded from portfolio count: Yes - Canvas files scanned for alias reference risk: 4  ## Project Count  - Canonical project candidates: 28 - Alias or duplicate candidates: 17 - Project count mismatch risk: High, because old names and aliases inflate portfolio count.  ## Zero-byte Notes 
- [[Adhoc Indent]] - Adhoc Indent.md
- [[Chuyền Treo IoT Dashboard]] - Chuyền Treo IoT Dashboard.md
- [[Cowash VER2]] - Cowash VER2.md
- [[CPD Fabric Database]] - CPD Fabric Database.md
- [[E-commerce Exploration]] - E-commerce Exploration.md
-[[FD.Datamart.v2.2]]] - FD Hanger VER2.md
- [[GDI Automation]] - GDI Automation.md
- [[Import Export Automation]] - Import Export Automation.md
- [[Market Intelligence]] - Market Intelligence.md
-[[MER.PO-Commit]]] - PO Commit.md
- [[PPJ x Nunox]] - PPJ x Nunox.md
- [[PPJ x Stratova AI]] - PPJ x Stratova AI.md
- [[PPJ.GLPI-Helpdesk-AI Chatbot]] - PPJ.GLPI-Helpdesk-AI Chatbot.md
- [[PPJ.PERRI.Chatbot]] - PPJ.PERRI.Chatbot.md
-[[PUR.Inventory Report]]] - Purchasing Inventory Report.md
- [[Web Tổng Hợp Tool]] - Web Tổng Hợp Tool.md

## Duplicate Candidates

| Alias | Canonical | Confidence | Reason |
|---|---|---|---|
| Adhoc Indent miền Nam.md | Adhoc Indent mien Nam.md | High | Vietnamese accent filename duplicate; prefer ASCII canonical for scripts. |
| Adhoc Indent.md | Adhoc Indent mien Nam.md | Medium | Short/old umbrella name for same Adhoc Indent scope. |
| Chuyền Treo IoT Dashboard.md | IOT.CHuyenTreo_1.md | Medium | Coded project filename available; likely same factory IoT dashboard. |
| Chuyền treo ver1.md | IOT.CHuyenTreo_1.md | Medium | Old Vietnamese/non-coded project name; coded IoT filename available. |
| Cowash VER2.md | COWASH.md | High | Version label duplicate for COWASH project. |
| E-commerce Exploration.md | E-commerce Market Intelligence.md | High | Exploration appears to be old/short name for Market Intelligence work. |
| Market Intelligence.md | E-commerce Market Intelligence.md | Medium | Generic market intelligence alias; canonical project is business-specific. |
| GDI Automation.md | PUR.GDI Automation.md | High | Coded Purchasing GDI project name preferred. |
| Import Export Automation.md | PPJ. Expense-Invoices.v1.1.md | Medium | Old umbrella name overlaps invoice automation foundation. |
| EX-IM Expense Invoice Bot.md | PPJ. Expense-Invoices.v1.1.md | Medium | Likely EXIM-specific alias under expense invoice automation foundation. |
| PPJ x Nunox.md | NUNOX.md | High | Vendor partnership naming duplicate. |
| PPJ x Stratova AI.md | Stratova AI.md | High | Vendor partnership naming duplicate. |
| Sourcing Chatbot v2.3.md | SCP.SOURCING.CHATBOT.v2.3.md | High | Coded sourcing project name is canonical; sourcing must not be split. |
| Sourcing VER2.md | SCP.SOURCING.CHATBOT.v2.3.md | High | Old sourcing version alias; canonical project includes chatbot and external sample repository. |
| Web Tổng Hợp Tool.md | Web Tong Hop Tool.md | High | Vietnamese accent filename duplicate; prefer ASCII canonical for scripts. |
| WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md | RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md | Medium | README names RND.WASH as canonical coded R&D Wash portal project. |
| CPD Fabric Database.md | TD.TechnicalPlatform_v2.1.md | Medium | CPD fabric database appears to be business name for technical CPD datamart platform. |

## Alias Candidates

Alias candidates are listed in [[PPJ_PROJECT_ALIAS_MAP]]. Zero-byte aliases can be converted safely after approval. Non-empty duplicates need merge review before alias conversion.

## Naming Standardization Issues

- Vietnamese accent and ASCII mismatch: Adhoc Indent mien Nam/miền Nam, Web Tong Hop/Tổng Hợp, Chuyền Treo variants.
- Coded and non-coded mismatch: SCP.SOURCING.CHATBOT.v2.3 versus Sourcing Chatbot v2.3/Sourcing VER2; PUR.GDI Automation versus GDI Automation.
- Vendor partnership aliases: PPJ x Nunox/NUNOX and PPJ x Stratova AI/Stratova AI.

## Phase Mismatch

[[ACC.GRN-SupplierInvoiceBot.v2.3]]]] - phase: [[PRODUCTION / SUPPORT]]
- [[Adhoc Indent miền Nam]] - phase: TBD
- [[Adhoc Indent]] - phase: TBD
- [[AI Automation Workshop]] - phase: [[CLOSED / CANCELLED]]
- [[Chuyền Treo IoT Dashboard]] - phase: TBD
-[[PROD.Chuyền treo ver1]]] - phase: TBD
- [[Cowash VER2]] - phase: TBD
-[[PROD.COWASH]]] - phase: [[PENDING]]
- [[CPD Fabric Database]] - phase: TBD
- [[E-commerce Exploration]] - phase: TBD
-[[E-commerce Market Intelligence v.2.3]]] - phase: [[ANALYSIS]]
- [[EX-IM Expense Invoice Bot]] - phase: [[PRODUCTION / SUPPORT]]
-[[FD.Datamart.v2.2]]] - phase: TBD
- [[GDI Automation]] - phase: TBD
-[[PUR.H&M Label-O Processing]]] - phase: [[PENDING]]
- [[HR.SS&PFD.v1.1]] - phase: [[DESIGN]]
- [[Import Export Automation]] - phase: TBD
- [[Market Intelligence]] - phase: TBD
-[[PPJ.COSTING.AGENT.PLATFORM.v1.1]]] - phase: [[ANALYSIS]]
-[[PPJxNUNOX]]] - phase: [[EXTERNAL]]
-[[MER.PO-Commit]]] - phase: TBD
- [[PPJ x Nunox]] - phase: TBD
- [[PPJ x Stratova AI]] - phase: TBD
- [[PPJ. Expense-Invoices.v1.1]] - phase: [[ANALYSIS]]
- [[PPJ.GLPI-Helpdesk-AI Chatbot]] - phase: TBD
- [[PPJ.Invoice Downloader.v1.2]] - phase: [[PRODUCTION / SUPPORT]]
- [[PPJ.PERRI.Chatbot]] - phase: TBD
-[[PPJ XPrimo1D RFID Thread]]] - phase: [[EXTERNAL]]
- [[PUR.GDI Automation]] - phase: [[BLOCKED / DEPENDENCY]]
-[[PUR.Material.Allocation.v1.2]]] - phase: [[BLOCKED / DEPENDENCY]]
-[[PUR.Inventory Report]]] - phase: TBD
-[[PPJxQSee.ai]]] - phase: [[EXTERNAL]]
- [[Sourcing Chatbot v2.3]] - phase: TBD
- [[Sourcing VER2]] - phase: TBD
-[[PPJxStratova AI]]] - phase: [[CLOSED / CANCELLED]]
- [[TD.TechnicalPlatform_v2.1]] - phase: [[PRODUCTION / SUPPORT]]
- [[VITAS Sharing]] - phase: [[EXTERNAL]]
- [[Web Tổng Hợp Tool]] - phase: TBD
- [[Workshop Analysis]] - phase: [[ANALYSIS]]

## Broken Link Risk

- Link update needed for all alias candidates before any archive or rename workflow.
- Highest risk aliases: Sourcing Chatbot v2.3, Sourcing VER2, Web Tổng Hợp Tool, GDI Automation, Chuyền Treo variants.

## Canvas Reference Risk

- PPJ_Data_Flow.canvas: Chuyền treo ver1.md should point to IOT.CHuyenTreo_1.md.
- PPJ_Data_Flow.canvas: Market Intelligence.md should point to E-commerce Market Intelligence.md.
- PPJ_Data_Flow.canvas: Sourcing Chatbot v2.3.md should point to SCP.SOURCING.CHATBOT.v2.3.md.
- PPJ_Data_Flow.canvas: Sourcing VER2.md should point to SCP.SOURCING.CHATBOT.v2.3.md.
- PPJ_Executive_Board.canvas: Market Intelligence.md should point to E-commerce Market Intelligence.md.
- PPJ_Executive_Board.canvas: GDI Automation.md should point to PUR.GDI Automation.md.
- PPJ_Executive_Board.canvas: EX-IM Expense Invoice Bot.md should point to PPJ. Expense-Invoices.v1.1.md.
- PPJ_Executive_Board.canvas: WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md should point to RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md.
- PPJ_Executive_Board.canvas: CPD Fabric Database.md should point to TD.TechnicalPlatform_v2.1.md.
- PPJ_Portfolio.canvas: Adhoc Indent miền Nam.md should point to Adhoc Indent mien Nam.md.
- PPJ_Portfolio.canvas: Chuyền treo ver1.md should point to IOT.CHuyenTreo_1.md.
- PPJ_Portfolio.canvas: Market Intelligence.md should point to E-commerce Market Intelligence.md.
- PPJ_Portfolio.canvas: GDI Automation.md should point to PUR.GDI Automation.md.
- PPJ_Portfolio.canvas: EX-IM Expense Invoice Bot.md should point to PPJ. Expense-Invoices.v1.1.md.
- PPJ_Portfolio.canvas: Sourcing Chatbot v2.3.md should point to SCP.SOURCING.CHATBOT.v2.3.md.
- PPJ_Portfolio.canvas: Sourcing VER2.md should point to SCP.SOURCING.CHATBOT.v2.3.md.
- PPJ_Portfolio.canvas: CPD Fabric Database.md should point to TD.TechnicalPlatform_v2.1.md.
- PPJ_Roadmap_2026.canvas: Chuyền treo ver1.md should point to IOT.CHuyenTreo_1.md.
- PPJ_Roadmap_2026.canvas: Market Intelligence.md should point to E-commerce Market Intelligence.md.
- PPJ_Roadmap_2026.canvas: Sourcing Chatbot v2.3.md should point to SCP.SOURCING.CHATBOT.v2.3.md.
- PPJ_Roadmap_2026.canvas: Sourcing VER2.md should point to SCP.SOURCING.CHATBOT.v2.3.md.
- PPJ_Roadmap_2026.canvas: CPD Fabric Database.md should point to TD.TechnicalPlatform_v2.1.md.

## Recommended Cleanup Plan

1. Approve canonical project names in [[PPJ_PROJECT_REGISTRY]].
2. Review [[PPJ_PROJECT_ALIAS_MAP]] for high-confidence aliases.
3. Run cleanup script in DryRun mode and review the operation log.
4. Apply only zero-byte alias conversion and safe link updates first.
5. Review non-empty duplicate notes manually before merge or archive.
6. Update Canvas references only after Markdown links are stable.
7. Re-run project inventory and daily command center after cleanup.
