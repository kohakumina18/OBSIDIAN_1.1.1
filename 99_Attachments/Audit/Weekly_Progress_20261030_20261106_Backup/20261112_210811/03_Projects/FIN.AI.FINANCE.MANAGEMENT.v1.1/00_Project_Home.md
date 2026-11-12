---
type: "project_home"
project: "FIN_FinanceManagement_v1.2.0"
source_project: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
source_event: "PPJ-WEEKLY-20261030-20261106"
last_verified: "2026-11-06"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "Strategic Active"
current_gate: "Approve WS4 lineage and accounting semantics; scope-gate four FIN-AI enhancements"
priority: "P1"
delivery_stage: "DESIGN"
status: "Active"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
phase: "DESIGN"
---

<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_START -->
## Executive Delivery State

| Field | Current |
|---|---|
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DESIGN |
| Detailed Lifecycle | Design |
| Status | Active |
| Current Gate | Approve WS4 lineage and accounting semantics; scope-gate four FIN-AI enhancements |
| Stage Entered | 2026-08-24 |
| Last Verified | 2026-11-06 |
<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_END -->

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | FIN_FinanceManagement_v1.2.0 |
| Legacy Code(s) | FIN.AI.FINANCE.MANAGEMENT.v1.2; FIN.AI.FINANCE.MANAGEMENT.v1.1 |
| Primary Domain | Finance / Accounting |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DESIGN |
| Lifecycle | Strategic Active |
| Status | Active |
| Progress | TBD |
| Current Gate | Approve WS4 lineage and accounting semantics; scope-gate four FIN-AI enhancements |
| Priority | P1 |
| Business Owner | Accounting |
| Registration | Registered |
| Last Verified | 2026-11-06 |
| Confidence | Strong |

## Executive Summary

Centralized Finance Control Platform for completeness, correct OC/period, actual versus plan, missing cost, profitability, drill-down, factory performance and exception ownership.

## Current Capability

WS1 Finance Q&A (foundation); WS2 OC & Cost Control (main focus); WS3 Factory Performance (started).

## Latest Update

WS4 Golden Cases 02-03 confirm many-to-one Dệt-to-Nhuộm lineage, line-level Pick List evidence, cross-year source lots and voucher-level cost bridges. Daily NPL and Final Efficiency remain blocked. Four new FIN-AI enhancement requests are proposed only: internal-subcontracting OC analysis, expense allocation to net profit, receivables alerts and buyer credit limits. WS1, WS2 delivery, WS3 and WS5 have no new confirmed movement.

## Risks / Blockers

- Daily NPL and Final Efficiency evidence remains blocked.
- Lineage join keys, voucher-level accounting semantics, source extracts, historical cutoff and version control are not approved.
- The four FIN-AI enhancement requests have no approved scope, stage or accountable owner.
- WS3 closure and the WS3/WS5 boundary remain unresolved.

## Decisions Needed

- Approve WS4 lineage, accounting semantics, source extracts and acceptance method.
- Approve, stage or reject each new FIN-AI enhancement and assign accountable owners.
- Confirm WS3/WS5 boundaries and mandate overdue WS3 closure.

## Dependencies

- WFX / Databricks / DWH -> Finance source control -> Rule Engine -> OC control -> Factory performance -> Power BI / AI

## Next Actions

- Freeze WS4 lineage join keys and voucher-level accounting semantics using the two selected Golden Transactions.
- Scope-gate the four FIN-AI enhancements before estimation or development.
- Close the WS3 evidence gap and confirm the WS3/WS5 boundary.

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[FIN.AI.FINANCE.MANAGEMENT.v1.1/00_Project_Home|Project Home]]
- [[FIN.AI.FINANCE.MANAGEMENT.v1.1/Project_Executive_Board|Project Executive Board]]
- [[FIN.AI.FINANCE.MANAGEMENT.v1.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-11-06
- Source Event: PPJ-WEEKLY-20261030-20261106
- Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261106]]
- Confidence: Strong

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# FIN.AI.FINANCE.MANAGEMENT.v1.2

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | FIN.AI.FINANCE.MANAGEMENT.v1.2 |
| Current File | FIN.AI.FINANCE.MANAGEMENT.v1.1.md |
| Primary Domain | Finance / Accounting |
| Secondary Domains | Data, IT, Sales, Management |
| Lifecycle | Analysis / Design |
| Progress | TBD |
| Current Gate | Data Discovery / Databricks Access Blocked / Rule Engine Design |
| Priority | P1 |
| Business Owner | Finance / Management |
| Primary Users | Accounting; data-access governance owner Needs Confirmation |
| BA / Coordination | Khoa |
| Technical Members | IT / Data team, AI Automation team, IT / Data / AI |
| Last Verified | 2026-08-01 |
| Confidence | Strong |

## One-Line Understanding

Early-stage AI-assisted Finance Management initiative to explore cash-flow analysis, finance reporting assistant, forecasting, and management insight use cases.

## Business Goal

Centralized financial control and analysis platform for OC cost completeness, exception detection, order effectiveness, drill-down reporting, Power BI and AI-assisted analysis.

## Current Outcome

Centralized financial control and analysis platform for OC cost completeness, exception detection, order effectiveness, drill-down reporting, Power BI and AI-assisted analysis.

## Latest Update

Workstream 2 source inventory is nearly complete and Workstream 3 factory drill-down is partially covered. Most required sources appear to exist in Databricks rather than the governed DWH. Rule Engine groups now cover materials and trims, subcontracting, and order effectiveness.

## Current Scope

- Finance/Management discovery project.
- Kick-off preparation for AI/analytics use case shaping.
- Potential finance dashboard, reporting assistant, cash-flow analysis, AI finance agent, or forecasting platform.

## Current Risks / Blockers

- Approved Databricks account and read permission are not available.
- Source table, schema, grain, linking key and source owner are not fully confirmed.
- Required data is outside the currently governed DWH.
- OC linking keys may be incomplete.
- Accounting approval and warning thresholds are pending.
- Workstream 3 could expand before Workstream 2 stabilizes.

## Decisions Needed

- Define official Databricks access governance.
- Approve Accounting rules and thresholds.
- Confirm source owners and sources of truth.

## Next Actions

- Follow up Databricks account approval and confirm account, role, catalog, schema, table and read-only permission.
- Complete Workstream 2 Source Inventory and profile each source.
- Confirm OC linking keys and finalize the Rule Engine Catalogue.
- Select 20-30 sample OCs and compare Rule Engine results with manual Accounting controls.
- Do not expand Workstream 3 before Workstream 2 stabilizes.

## Key Dependencies

- Databricks Sources -> Finance Source Inventory -> Data Profiling -> Rule Engine -> OC Exception Detection -> Accounting Validation

## Current Deliverables

- Project profile and plan
- Business and requirements pack appropriate to lifecycle
- Data, process and solution documents where applicable
- Governance logs and operational task board

## Workspace Navigation

### Management

- [[01_Management/Project_Profile]]
- [[01_Management/Project_Plan]]
- [[01_Management/Milestones]]
- [[01_Management/Weekly_Status]]

### Business

- [[02_Business/Business_Context]]
- [[02_Business/BRD]]
- [[02_Business/Scope_and_Business_Rules]]

### Process

- [[03_Process/AS_IS_Process]]
- [[03_Process/TO_BE_Process]]
- [[03_Process/Process_Gaps]]

### Data

- [[04_Data/Data_Spec]]
- [[04_Data/Data_Source_Inventory]]
- [[04_Data/Data_Quality_and_Traceability]]

### Requirements

- [[05_Requirements/Functional_Requirements]]
- [[05_Requirements/Use_Cases]]
- [[05_Requirements/Acceptance_Criteria]]

### Solution

- [[06_Solution/Solution_Overview]]
- [[06_Solution/Integration_Spec]]

### Test / UAT

- [[07_Test_UAT/UAT_Plan]]
- [[07_Test_UAT/UAT_Cases]]
- [[07_Test_UAT/Defect_Log]]

### Implementation

- [[08_Implementation/Implementation_Plan]]
- [[08_Implementation/Deployment_Checklist]]

### Operations

- [[09_Operations/User_Manual]]
- [[09_Operations/Support_and_Maintenance]]

### Governance

- [[10_Governance/Risks_Issues]]
- [[10_Governance/Decision_Log]]
- [[10_Governance/Dependencies]]
- [[10_Governance/Change_Log]]

### Project Board

- [[Project_Executive_Board]]
- [[Tasks]]
- [[Meetings]]
- [[Evidence]]

## Source of Truth

Root Project Note:
[[../FIN.AI.FINANCE.MANAGEMENT.v1.1]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/FIN.AI.FINANCE.MANAGEMENT.v1.1.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]

<!-- PPJ_WEEKLY_20261023_20261030_START -->
## Weekly Synchronization Event: PPJ-WEEKLY-20261023-20261030

### Verified movement

WS4 traced one Knit golden case, completed transaction-stage classification and prepared a v0.2 rule-change proposal. The evidence confirms 1-to-many and line-level Det-Nhuom mapping requirements, but does not prove production accuracy. WS3 received two HR/Payroll responses; broader Accounting and Planning/Production inputs remain incomplete, and HR-WFX/GTAS mappings and month-finalization practices are inconsistent. WS1, WS2 and WS5 have no new confirmed movement.

### Current gate

WS4 v0.2 evidence review and WS3 input closure

### Risks / blockers

- WS4 evidence is limited to one golden-case package and a partial historical window.
- Line-level lineage, metric definitions, history completeness and accounting interpretation remain unresolved.
- WS3 survey closure is overdue; HR-WFX/GTAS mappings and month-finalization practices are inconsistent.
- WS1 UAT ownership, WS2 BC-04 policies/source gaps and the WS3/WS5 boundary remain open.

### Decisions required

- Approve WS4 line-level lineage, historical-window controls, provisional mapping review and golden-case method.
- Mandate WS3 closure and confirm the WS3/WS5 boundary.
- Approve the four open BC-04 policies and source-remediation plan.

### Next actions

- Review the WS4 v0.2 evidence model, provisional mappings, lineage method and priority accounting questions.
- Collect remaining Accounting and Planning/Production WS3 inputs and consolidate the data/rule/gap register.
- Define supported WS1 questions and pilot gate; preserve WS2 source-remediation and BC-04 policy actions.

### Traceability

- Report: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261030-PORTFOLIO-GATES]]
- Last verified: 2026-10-30
- Confidence: Strong
<!-- PPJ_WEEKLY_20261023_20261030_END -->

<!-- PPJ_WEEKLY_20261030_20261106_START -->
## Weekly Synchronization Event: PPJ-WEEKLY-20261030-20261106

### Verified movement

WS4 Golden Cases 02-03 confirm many-to-one Dệt-to-Nhuộm lineage, line-level Pick List evidence, cross-year source lots and voucher-level cost bridges. Daily NPL and Final Efficiency remain blocked. Four new FIN-AI enhancement requests are proposed only: internal-subcontracting OC analysis, expense allocation to net profit, receivables alerts and buyer credit limits. WS1, WS2 delivery, WS3 and WS5 have no new confirmed movement.

### Current gate

Approve WS4 lineage and accounting semantics; scope-gate four FIN-AI enhancements

### Risks / blockers

- Daily NPL and Final Efficiency evidence remains blocked.
- Lineage join keys, voucher-level accounting semantics, source extracts, historical cutoff and version control are not approved.
- The four FIN-AI enhancement requests have no approved scope, stage or accountable owner.
- WS3 closure and the WS3/WS5 boundary remain unresolved.

### Decisions required

- Approve WS4 lineage, accounting semantics, source extracts and acceptance method.
- Approve, stage or reject each new FIN-AI enhancement and assign accountable owners.
- Confirm WS3/WS5 boundaries and mandate overdue WS3 closure.

### Next actions

- Freeze WS4 lineage join keys and voucher-level accounting semantics using the two selected Golden Transactions.
- Scope-gate the four FIN-AI enhancements before estimation or development.
- Close the WS3 evidence gap and confirm the WS3/WS5 boundary.

### Traceability

- Report: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261106]]
- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261106-PORTFOLIO-GATES]]
- Last verified: 2026-11-06
- Confidence: Strong
<!-- PPJ_WEEKLY_20261030_20261106_END -->
