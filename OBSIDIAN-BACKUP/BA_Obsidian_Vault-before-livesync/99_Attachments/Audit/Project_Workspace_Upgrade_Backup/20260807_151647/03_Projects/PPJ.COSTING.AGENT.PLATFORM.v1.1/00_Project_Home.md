---
type: "project_home"
project: "COSTING.AGENTIC.PLATFORM.v1.1"
source_project: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# COSTING.AGENTIC.PLATFORM.v1.1

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | COSTING.AGENTIC.PLATFORM.v1.1 |
| Current File | PPJ.COSTING.AGENT.PLATFORM.v1.1.md |
| Primary Domain | Merchandising |
| Secondary Domains | Technical, Sew, Wash, Fabric, Finance |
| Lifecycle | Development |
| Progress | TBD |
| Current Gate | Sew Costing v1.1 Demo Completed / v1.2 Development |
| Priority | P3 |
| Business Owner | Needs Confirmation |
| Primary Users | Merchandising and Sew experts |
| BA / Coordination | Khoa |
| Technical Members | Lam, Khoa, Uyen, Huy, Linh |
| Last Verified | 2026-08-01 |
| Confidence | Strong |

## One-Line Understanding

Strategic agentic platform for multi-department technical costing and quotation workflows.

## Business Goal

Costing and Quotation Package for Merchandising review and customer quotation proposals.

## Current Outcome

Costing and Quotation Package for Merchandising review and customer quotation proposals.

## Latest Update

Sew Costing v1.1 demo completed, demonstrating description intake, operation extraction, operation-list standardization and an initial SAM/Sew Cost data foundation. v1.2 focuses on SAM accuracy, machine/standard-time mapping, incomplete descriptions, historical similarity, confidence, expert review and GTAS/IED transfer.

## Current Scope

- Agentic platform with BOM, Sew, Wash, Cut, Technical Knowledge, Historical Costing, and Quotation Consolidation agents.

## Current Risks / Blockers

- GTAS/IED data contract and integration format are not confirmed.
- Technical data acceptance remains pending.
- SAM is not final without validated standards and expert review.
- AI suggestion and approved costing must remain separate.

## Decisions Needed

- Approve Sew v1.2 accuracy and acceptance plan.
- Confirm GTAS/IED data contract and expert-approval boundary.

## Next Actions

- Evaluate the v1.1 demo with Sew experts and establish an accuracy baseline.
- Analyze extraction errors and improve SAM calculation.
- Confirm GTAS/IED data contract and API/integration format.
- Connect Technical consumption data.
- Continue the Wash dataset workstream without creating a separate root project.

## Key Dependencies

- TD.TechnicalKnowledge.Platform.v2.1 -> Consumption / Pattern / BOM / Construction / History -> Costing Platform
- AI Suggestion -> Expert-approved Result -> Final GTAS/IED Transfer

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
[[../PPJ.COSTING.AGENT.PLATFORM.v1.1]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/COSTING.AGENTIC.PLATFORM.v1.1.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
