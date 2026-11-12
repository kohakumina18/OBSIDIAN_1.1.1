---
type: weekly_portfolio_report
as_of: 2026-11-06
comparison_baseline: 2026-10-30
source_event: PPJ-WEEKLY-20261030-20261106
evidence_status: mixed_confirmed_and_unconfirmed
confidence: Strong
---

# PPJ AI, Automation & Digital Portfolio - Weekly Status

**As of:** 6 November 2026

**Baseline:** 30 October 2026

**Source freshness:** Evidence updated through 6 November, covering WS4 Fabric OC, Business Travel, Finance enhancements, Material Allocation and Dệt Phú Thọ ERP discovery. The 30 October baseline remains authoritative elsewhere.

[Management report source](https://chatgpt.com/library?file_id=libfile_b5fcb69a2b108191966ad873e0fc9303&account_id=personal)

> [!note] Post-report governance update - 12 November 2026
> Executive authorization registered the former `DISCOVERY_DetPhuThoERP` item as [[PPJxDệt_Phú_Thọ]]. This does not rewrite the 6 November evidence baseline: questionnaire answers, requirements, owner, ERP vendor/solution, implementation scope and BRD / ERP fit-gap authorization remain unconfirmed. See [[07_Decision_Log/DEC-20261112-REGISTER-PPJxDetPhuTho]].

## Evidence boundary

Only the five reported areas above receive new evidence treatment. Guides, knowledge packs, re-analysis and questionnaires are deliverables, not proof of project completion, release or production readiness. Proposed FIN-AI enhancements are not approved scope. Dệt Phú Thọ remains a discovery item, not a registered project. No delivery-stage change is confirmed.

## Executive summary

- **WS4 Fabric OC made the strongest analytical progress.** Golden Cases 02-03 confirm many-to-one Dệt-to-Nhuộm lineage, line-level Pick List evidence, cross-year source lots and voucher-level cost bridges. Daily NPL and Final Efficiency remain blocked.
- **Material Allocation advanced to a documented controlled-flow build.** Preview, dry run, fingerprints, audit history, emergency stop and rerun controls are documented. Real WFX transaction testing and several business rules remain open.
- **Business Travel progressed in release enablement.** Employee and Admin guides are complete, but this does not confirm go-live. Access, accounting mappings, migrations, irreversible actions and release authority remain unresolved.
- **Four new FIN-AI enhancement requests require scope approval:** internal-subcontracting OC analysis, expense allocation to net profit, receivables alerts and buyer credit limits.
- **Dệt Phú Thọ entered structured ERP discovery.** A 100-question questionnaire now covers Sales, Production, Labor and Cotton Blending. No answers or requirements are confirmed yet.
- The **Market Intelligence Chino demo target of 5 November passed without confirmed outcome evidence**.
- No project or workstream was confirmed complete.

## Canonical resolution

| Report workstream | Canonical project / record | Treatment |
|---|---|---|
| WS4 Fabric OC and FIN-AI enhancements | [[FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN_FinanceManagement_v1.2.0]] | Confirmed WS4 evidence movement; enhancement requests remain proposed |
| Material Allocation | [[PUR.Material.Allocation.v1.2|PUR_MaterialAllocation_v1.1.0]] | Controlled-flow documentation movement; real WFX transaction evidence pending |
| Business Travel | [[ADMIN_ExpenseManagement_v1.1.0]] | Guides complete; formal UAT and release decision pending |
| Market Intelligence | [[E-commerce Market Intelligence v.2.3|MER_MarketIntelligence_v1.1.0]] | Planned target passed without confirmed outcome evidence |
| Dệt Phú Thọ ERP | [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER|DISCOVERY_DetPhuThoERP]] | Structured discovery only; no registration, stage or Canvas card |

## Weekly movement

| Workstream | Movement versus 30 October | Current gate |
|---|---|---|
| WS4 Fabric OC | Major analytical progress from two additional Golden Cases | Approve lineage, accounting semantics and source extracts |
| Material Allocation | Business and technical control model documented | Controlled WFX dry-run and Save testing |
| Business Travel | User/Admin operating guides completed | Formal UAT and release decision |
| FIN-AI enhancements | New proposed scope | Approve, stage or reject each request |
| Dệt Phú Thọ ERP | New structured discovery | Assign owners and collect evidence |
| Market Intelligence | No delivery evidence after planned demo date | Record outcome and rebaseline |
| WS1, WS2 delivery, WS3, WS5, GDI, invoices, AWB, Sew, Wash/COMIT, Stratova, BSC-KPI, shared platforms | No new confirmed update | Previous blockers and decisions remain open |

## Main portfolio constraints

- Finance and Accounting policy ownership across WS2-WS5, Travel, invoices and the new enhancements.
- WFX transaction safety across Allocation, GDI, Travel and invoice automation.
- Incomplete lineage, historical cutoff and version control across Fabric OC, DWH and Market Intelligence.
- Competing BA, QA, Finance, WFX and factory-expert capacity.
- Missing common authorization, audit and recovery standards for irreversible system actions.

## Milestone assessment

**Moved forward:** WS4 Golden Cases, Material Allocation documentation, Business Travel guidance, FIN-AI scope review and Dệt Phú Thọ discovery.

**Completed deliverables:** WS4 re-analysis, Business Travel guides, Material Allocation knowledge packs and the Dệt Phú Thọ questionnaire. These are deliverables, not completed projects.

**Delayed or at risk:** Market Intelligence demo evidence, WS3 survey closure, Business Travel release, Allocation/GDI transaction UAT, Expense Invoice defects, WS2 readiness and WS4 production-rule readiness.

## Top five actions for next week

1. Freeze WS4 lineage join keys and voucher-level accounting semantics using the two selected Golden Transactions.
2. Scope-gate the four new FIN-AI enhancements before estimation or development.
3. Execute Material Allocation dry-run and controlled Save tests, including duplicate, concurrency, cross-division and emergency-stop cases.
4. Run the Business Travel release gate covering access, accounting, migrations, irreversible actions, training and support.
5. Close the Market Intelligence and WS3 evidence gaps; appoint Dệt Phú Thọ process owners without displacing P0 UAT work.

## Management decisions required

| Priority | Decision |
|---|---|
| P0 | Approve WS4 lineage, accounting semantics, source extracts and acceptance method |
| P0 | Approve, stage or reject each new FIN-AI enhancement and assign accountable owners |
| P0 | Approve Business Travel release authority, UAT ownership and support model |
| P0 | Approve Material Allocation business rules and transaction-control UAT gate |
| P1 | Accept, rework or rebaseline the Market Intelligence Chino MVP |
| P1 | Confirm WS3/WS5 boundaries and mandate overdue WS3 closure |
| P1 | Authorize Dệt Phú Thọ discovery ownership and BRD/ERP-gap gate |
| P1 | Escalate GDI and assign Expense Invoice defect ownership |
| P1 | Approve the Wash/COMIT POC dataset and expert-review model |
| P2 | Pause vendor or research initiatives without an owner, KPI, dataset and production path |

## Traceability

- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261106-PORTFOLIO-GATES]]
- Current snapshot: [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT]]
- Memory index: [[03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX]]
- Update ledger: [[03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER]]
- Discovery register: [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER]]
- Registered Dệt Phú Thọ project: [[PPJxDệt_Phú_Thọ]]
