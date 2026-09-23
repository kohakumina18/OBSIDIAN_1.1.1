---
type: "project_home"
project: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
source_project: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
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
