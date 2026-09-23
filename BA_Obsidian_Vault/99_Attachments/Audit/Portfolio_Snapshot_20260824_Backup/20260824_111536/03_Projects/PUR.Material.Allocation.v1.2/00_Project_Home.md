---
type: "project_home"
project: "PUR.Material.Allocation.v1.1"
source_project: "PUR.Material.Allocation.v1.2.md"
source_event: "PPJ-WEEKLY-20260713-20260718"
last_verified: "2026-07-18"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# PUR.Material.Allocation.v1.1

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | PUR.Material.Allocation.v1.1 |
| Current File | PUR.Material.Allocation.v1.2.md |
| Primary Domain | Sourcing / Purchasing |
| Secondary Domains | WFX, Inventory, Production |
| Lifecycle | UAT / Stabilization |
| Progress | 50% |
| Current Gate | First Flow Validated / Extended Exception Testing |
| Priority | TBD |
| Business Owner | Needs Confirmation |
| Primary Users | Purchasing / Khoa / Uyen / Nam / Phat |
| BA / Coordination | Khoa, Uyên |
| Technical Members | Uyen, Khoa, Nam, Phát |
| Last Verified | 2026-07-18 |
| Confidence | Strong |

## One-Line Understanding

Purchasing material allocation/transfer/borrow workflow with WFX dependency and validation before save/post.

## Business Goal

Validated unreserve, destination-OC matching and allocation flow with controlled UAT foundation

## Current Outcome

Validated unreserve, destination-OC matching and allocation flow with controlled UAT foundation

## Latest Update

The first business flow was successfully tested: Source OC with Surplus -> Validate Surplus -> Unreserve -> Find Destination OC -> Validate Style and Buyer Reference -> Allocate -> Verify Result. Destination OCs are split OCs with the same Style and Buyer Reference.

## Current Scope

- Semi-automation/automation for material allocation, transfer, or borrow between OC/style/order.

## Current Risks / Blockers

- Only Sewing and Embroidery scope is confirmed.
- Quantity may change during transaction execution.
- Rollback is undefined when unreserve succeeds but allocation fails.

## Decisions Needed

- Confirm transaction rollback design.
- Confirm auditability and user confirmation before posting.
- Confirm whether additional material categories enter scope.

## Next Actions

- Test many-to-one, one-to-many, partial allocation, insufficient quantity, Buyer Reference mismatch and duplicate allocation.
- Test transaction failure/retry and define rollback.
- Define audit log and user review before posting.
- Prepare UAT with Ms. Tuyet and Precision users.

## Key Dependencies

- Needs Confirmation

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
[[../PUR.Material.Allocation.v1.2]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/PUR.Material.Allocation.v1.1.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
