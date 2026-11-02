---
type: weekly_portfolio_report
as_of: 2026-10-30
comparison_baseline: 2026-10-23
source_event: PPJ-WEEKLY-20261023-20261030
evidence_status: mixed_confirmed_and_unconfirmed
confidence: Strong
---

# PPJ AI, Automation & Digital Portfolio - Weekly Status

**As of:** 30 October 2026  
**Comparison baseline:** 23 October 2026  
**Source event:** `PPJ-WEEKLY-20261023-20261030`

## Evidence boundary

New confirmed evidence covers:

- Fabric OC through 30 October 2026.
- COMIT Wash requirements v1.1 dated 30 October 2026.
- WFX Material Allocation specifications dated 26-28 October 2026.
- WS3 responses dated 24-26 October 2026.

Earlier confirmed evidence remains the baseline for every other workstream. A planned date is not treated as delivery evidence. No project or workstream is confirmed complete.

## Executive summary

- **FIN-AI WS4 showed the strongest movement.** One Knit golden case was traced, transaction-stage classification was completed, and a v0.2 rule-change proposal was prepared. The evidence confirms 1-to-many and line-level Det-Nhuom mapping requirements, but does not establish production accuracy.
- **Material Allocation progressed at API-definition level.** WFX documented GET/POST behaviour and specified partial Style/Article search. Deployment and transaction-control testing remain unconfirmed.
- **Wash Agent x COMIT entered structured POC definition.** Scope, responsibilities, data contract, expert review and proposed targets are documented. No trained model or POC result exists yet.
- **WS3 received two HR/Payroll responses.** Aggregate labour data appears feasible, but HR-WFX/GTAS mappings and month-finalization practices are inconsistent. The wider survey remains incomplete.
- **No new confirmed update** exists for WS1, WS2, WS5, Business Travel, GDI, invoice automations, AWB OCR, Market Intelligence, Stratova, BSC-KPI or shared AI/data platforms.

## Canonical project resolution

| Report workstream | Canonical project | Update treatment |
|---|---|---|
| FIN-AI WS1-WS5 | [[FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN_FinanceManagement_v1.2.0]] | Confirmed WS3/WS4 movement; other workstreams unchanged |
| Business Travel / eOffice / WFX | [[ADMIN_ExpenseManagement_v1.1.0]] | No new delivery evidence; release decision remains open |
| GDI Automation | [[PUR.GDI Automation|PUR_GDIAutomation_v1.0.0]] | No new delivery evidence; API/UAT ownership decision remains open |
| Material Allocation | [[PUR.Material.Allocation.v1.2|PUR_MaterialAllocation_v1.1.0]] | Confirmed API specification movement |
| Expense Invoice Automations | [[PPJ. Expense-Invoices.v1.1|LOG_ExpenseInvoiceProcessing_v1.2.2]] | No confirmed fix; defect exit gate remains open |
| GRN Bot / Invoice Downloader | [[ACC.GRN-SupplierInvoiceBot.v2.3]] / [[PPJ.Invoice Downloader.v1.2]] | No new confirmed update |
| AWB OCR + DHL Email | [[WH_AWBExtraction_v1.1.0]] | No new confirmed test result |
| Sew Agent / Wash Agent x COMIT | [[PPJ.COSTING.AGENT.PLATFORM.v1.1|MER_CostingAgenticPlatform_v1.1.0]] | Confirmed Wash/COMIT requirements movement; Sew unchanged |
| Market Intelligence | [[E-commerce Market Intelligence v.2.3|MER_MarketIntelligence_v1.1.0]] | No new confirmed update; 5 November Chino demo remains planned |
| MER Invoice Data Recheck | [[MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1|MER_InvoiceDataRecheck_v1.1.0]] | No new confirmed update |
| Production IoT / Hanger / Wash Sampling | [[PROD.IOT.CHuyenTreo_1|PROD_HangingLineIoT_v1.0.0]] / [[FD.Datamart.v2.2|FAB_FabricDatamart_v2.2.0]] / [[WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1|WASH_SamplingManagement_v1.1.0]] | No new confirmed update |
| GTAS / Stratova | GTAS dependency / Stratova discovery register item | No confirmed result; do not reactivate the closed historical project |
| BSC-KPI Platform | Discovery artifact, not a registered delivery project | No new confirmed update |

## Compact portfolio status

| Project / Workstream | Verified status and movement | Principal next action | Decision / blocker |
|---|---|---|---|
| FIN-AI WS1 - Finance Chatbot | Development/validation; no new confirmed update | Define supported questions and pilot gate | Finance UAT ownership and traceability |
| FIN-AI WS2 - Consolidated Reporting | BC04r3 Draft; 0 DEV_READY; no new confirmed update | Close four Finance policies and data-source gaps | Daily material and Cost Sheet sources unavailable |
| FIN-AI WS3 - Factory Performance | Two HR responses received; wider collection incomplete | Complete Accounting and Planning/Production inputs | Mapping, closing practices and accountable owner |
| FIN-AI WS4 - Fabric OC | One Knit golden case traced; transaction stages classified; v0.2 change proposal prepared | Review v0.2, provisional mappings and additional golden cases | Line-level lineage, metrics, history completeness and accounting meaning |
| FIN-AI WS5 - Factory Reporting | Programme scope gap; no new confirmed update | Define boundary with WS3 | Scope and owner unconfirmed |
| Business Travel / eOffice / WFX | Release preparation; no new confirmed update | Run formal release gate | Accounting mappings, authorization, migrations and release ownership |
| GDI Automation | API/requirements development; no new confirmed update | Freeze API and sandbox transaction scenarios | WFX delivery, duplicate prevention and rollback |
| Material Allocation | API extension / pre-UAT; Style/Article SRS issued | Confirm implementation and run controlled GET/POST tests | Deployment, performance, concurrency and audit unconfirmed |
| Expense Invoice Processing | Active use / defect remediation; no confirmed fix | Assign hotfix owner and run regression | VAT, attachments, regional rules and duplicate/error risk |
| GRN Bot / Invoice Downloader | Production support; no new confirmed update | Establish monitoring and exception SLA | External-session drift and support ownership |
| AWB OCR + DHL Email | Active development; no new confirmed test result | Freeze test pack and review thresholds | Address, glare, unit and duplicate-AWB issues |
| Sew Agent / Technical Knowledge | Sew V1 stabilized; V2 discovery; no new confirmed update | Complete expert evidence and golden cases | Dataset and acceptance owner |
| Wash Agent x COMIT | Requirement definition / proposed POC | Freeze taxonomy, metadata, annotations and dataset | Proposed targets and expert-review gate need approval |
| Market Intelligence | Active Chino MVP; no new confirmed update | Verify readiness for 5 November demo | Scope expansion and inconsistent SKU/pricing data |
| MER Invoice Data Recheck | Active / scope expanded; no new confirmed update | Prioritize customer rule packs | Rollout order and success criteria |
| Production IoT / Hanger / Wash Sampling | Development foundation / discovery; no new confirmed update | Select one measurable pilot | Data latency, facility readiness and ownership |
| Shared AI/Data Platforms | Production / maintenance; no new confirmed update | Establish adoption, DQ and support KPIs | Fragmented ownership and weak master data |
| GTAS / Stratova | PoC/commercial definition; no new confirmed update | Freeze test set and commercial terms | Acceptance criteria and cost exposure |
| BSC-KPI Platform | Discovery; no new confirmed update | Appoint sponsor and bound MVP | Subjective scoring and evidence ownership |
| UIT/AISC and vendor pilots | Research/coordination; no confirmed outcome | Close actions and select formal pilots | Portfolio dilution and shared expert capacity |

## Milestone movement

### Moved forward

- WS4 Fabric OC tracing, stage classification and rule-review proposal.
- Material Allocation API specification.
- Two WS3 HR responses.
- Wash Agent x COMIT requirement v1.1.

### Completed deliverables, not completed projects

- Fabric Rule Catalogue v0.2 change proposal.
- WFX Style/Article API enhancement specification.
- COMIT Wash Image Analysis Requirement v1.1.

### Delayed or at risk

- WS3 survey closure remains overdue.
- The 5 November Chino demo lacks fresh readiness evidence.
- Business Travel remains release-gated.
- GDI and Allocation lack confirmed transaction-control UAT.
- Expense Invoice defects remain unresolved.
- WS4 evidence remains limited to one golden-case package and a partial historical window.

## Cross-project dependencies

- WFX APIs and transaction governance affect GDI, Allocation, Travel, invoices and FIN-AI.
- Finance/Accounting must approve thresholds, mappings, period cutoffs and valuation meaning.
- Partial historical windows and mixed snapshots threaten Fabric OC and Finance accuracy.
- R&D, IED and technical experts are shared across Sew, Wash/COMIT, Stratova and Fabric OC.
- BA, QA and business-user capacity cannot sustainably support all UAT cycles in parallel.
- Travel, Finance and shared platforms need common authorization and audit standards.

## Next-week action plan

1. Review and approve the WS4 evidence model, provisional mappings, lineage method and priority accounting questions; close the overdue WS3 inputs.
2. Confirm Material Allocation API implementation and execute controlled GET/POST tests.
3. Freeze the Wash/COMIT taxonomy, data contract and expert-owned POC dataset.
4. Run a readiness gate for the planned 5 November Chino demonstration.
5. Assign release/UAT ownership for Business Travel, GDI and Expense Invoice remediation.

## Management decision gate

See [[DEC-WEEKLY-20261030-PORTFOLIO-GATES]].

## Traceability

- Current snapshot: [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT]]
- Memory index: [[03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX]]
- Update ledger: [[03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER]]
- Decision index: [[07_Decision_Log/Decision_Log]]

