---
type: "project_home"
project: "FIN_FinanceManagement_v1.2.0"
source_project: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
last_verified: "2026-09-18"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "Strategic Active"
current_gate: "WS2 OC / Cost Control and WS3 Factory Performance"
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
| Current Gate | WS2 Rule Catalogue and Databricks access; then WS3 source discovery |
| Stage Entered | 2026-08-24 |
| Last Verified | 2026-08-24 |
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
| Current Gate | WS2 OC / Cost Control and WS3 Factory Performance |
| Priority | P1 |
| Business Owner | Accounting |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

Centralized Finance Control Platform for completeness, correct OC/period, actual versus plan, missing cost, profitability, drill-down, factory performance and exception ownership.

## Current Capability

WS1 Finance Q&A (foundation); WS2 OC & Cost Control (main focus); WS3 Factory Performance (started).

## Latest Update

No longer merely an AI chatbot. WS1 Finance Q&A (Balance Sheet, P&L, management Q&A) is the foundation; WS2 OC / Cost Control remains the main focus (missing cost, incorrect period, BOM/material, overhead, subcontracting, abnormal margin, duplicate/missing transactions, actual vs plan, invoice/posting completeness); WS3 Factory Performance has now started (Group -> Company -> Region -> Factory -> Production -> Labor -> Cost -> Efficiency). Databricks / DWH access and validated sources remain the key dependency.

## Risks / Blockers

- Databricks / DWH access
- Source ownership and lineage
- Rule and threshold approval
- Incorrect OC linkage

## Decisions Needed

- Approve WS2 thresholds and exception severity
- Confirm governed sources of truth

## Dependencies

- WFX / Databricks / DWH -> Finance source control -> Rule Engine -> OC control -> Factory performance -> Power BI / AI

## Next Actions

- Finalize the WS2 Rule Catalogue and thresholds
- Obtain read-only Databricks access and confirm catalog/schema/table lineage
- Select a Golden OC and run the rules
- Reconcile results with Accounting and finalize exception severity
- Advance WS3 factory-performance source discovery and dimensions (headcount, labor cost, overtime, output, capacity, budget vs actual)

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

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
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
