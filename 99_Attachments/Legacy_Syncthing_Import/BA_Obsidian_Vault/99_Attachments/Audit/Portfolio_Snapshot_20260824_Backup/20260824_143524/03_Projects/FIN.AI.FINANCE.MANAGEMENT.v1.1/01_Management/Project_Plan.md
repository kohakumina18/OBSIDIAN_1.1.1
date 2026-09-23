---
type: "project_plan"
project: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
source_project: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-08-24

| Field | Value |
| --- | --- |
| Canonical Code | FIN.AI.FINANCE.MANAGEMENT.v1.2 |
| Domain | Finance / Accounting |
| Delivery Stage | ANALYSIS |
| Lifecycle | Strategic Active |
| Status | Active |
| Progress | TBD |
| Gate | WS2 Rule Catalogue and Databricks access; then WS3 source discovery |
| Priority | P1 |
| Outcome | Centralized Finance Control Platform for completeness, correct OC/period, actual versus plan, missing cost, profitability, drill-down and exception ownership. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260824 |

### Latest Update

WS1 is complete and in operational support; WS2 rules are mostly consolidated and remain the main active focus; WS3 is the remaining major program scope.

### Current Risks

- Databricks access
- Source ownership and lineage
- Rule and threshold approval
- Incorrect OC linkage

### Dependencies

- WFX / Databricks / DWH -> Finance source control -> Rule Engine -> OC control -> Factory performance -> Power BI / AI

### Next Actions

- Finalize the WS2 Rule Catalogue and thresholds
- Obtain read-only Databricks access and confirm catalog/schema/table lineage
- Select a Golden OC and run the rules
- Reconcile results with Accounting and finalize exception severity
- Begin WS3 factory-performance source discovery
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Plan

## Planning Basis

- Lifecycle: Analysis / Design
- Current gate: Data Discovery / Databricks Access Blocked / Rule Engine Design
- Priority: P1
- Plan status: Current Working Document

## Current Work Packages

1. Confirm scope, ownership and evidence.
2. Complete the current lifecycle gate.
3. Maintain task, risk, decision and dependency traceability.
4. Prepare only the next approved delivery or closeout step.

## Evidence-Based Next Actions

- Follow up Databricks account approval and confirm account, role, catalog, schema, table and read-only permission.
- Complete Workstream 2 Source Inventory and profile each source.
- Confirm OC linking keys and finalize the Rule Engine Catalogue.
- Select 20-30 sample OCs and compare Rule Engine results with manual Accounting controls.
- Do not expand Workstream 3 before Workstream 2 stabilizes.

## Dependencies

- Databricks Sources -> Finance Source Inventory -> Data Profiling -> Rule Engine -> OC Exception Detection -> Accounting Validation

## Planning Controls

- No unapproved scope expansion.
- No invented owner, date, source table or business rule.
- Each milestone requires evidence and responsible-owner confirmation.

## Evidence Basis

- Root project note: [[../FIN.AI.FINANCE.MANAGEMENT.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/FIN.AI.FINANCE.MANAGEMENT.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
