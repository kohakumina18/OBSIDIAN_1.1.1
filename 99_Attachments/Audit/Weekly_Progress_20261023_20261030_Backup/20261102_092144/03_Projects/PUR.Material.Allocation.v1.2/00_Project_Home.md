---
type: "project_home"
project: "PUR_MaterialAllocation_v1.1.0"
source_project: "PUR.Material.Allocation.v1.2.md"
source_event: "PPJ-WEEKLY-20261023-20261030"
last_verified: "2026-10-30"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "Development"
current_gate: "Confirm API implementation and controlled GET/POST transaction UAT"
priority: "P7"
delivery_stage: "DEVELOPMENT"
status: "Active"
stage_entered_date: "2026-09-28"
delivery_stream: "INTERNAL DEVELOPMENT"
phase: "DEVELOPMENT"
---

<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_START -->
## Executive Delivery State

| Field | Current |
|---|---|
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DEVELOPMENT |
| Detailed Lifecycle | Development |
| Status | Active |
| Current Gate | Transaction reliability and exception control |
| Stage Entered | 2026-09-28 |
| Last Verified | 2026-09-28 |
<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_END -->

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | PUR_MaterialAllocation_v1.1.0 |
| Legacy Code(s) | PUR.Material.Allocation.v1.1; PUR.Material.Allocation.v1.2; Material Allocation |
| Primary Domain | Sourcing / Purchasing |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Validation / Stabilization |
| Status | Active |
| Progress | TBD |
| Current Gate | Transaction reliability and exception control |
| Priority | P7 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

Validate controlled reallocation of surplus material across eligible OCs: Material Requirement -> Availability -> Allocation -> Validation -> WFX Transaction.

## Current Capability

Validated for Sewing and Embroidery; broader material scope remains unconfirmed.

## Latest Update

WFX documented GET/POST behaviour and issued the Style/Article API enhancement specification dated 26-28 October, including partial Style/Article search. This is API-definition progress only; deployment and transaction-control testing are not confirmed.

## Risks / Blockers

- Deployment status, performance, concurrency and audit behaviour are unconfirmed.
- Duplicate prevention, rollback, partial allocation and exception controls still require transaction UAT.

## Decisions Needed

- Confirm API deployment ownership and the transaction-control UAT gate.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Confirm the specified API is implemented in the controlled environment.
- Execute controlled GET/POST tests for partial Style/Article search and allocation transactions.
- Validate duplicate prevention, rollback, concurrency, audit and user confirmation.

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[PUR.Material.Allocation.v1.2/00_Project_Home|Project Home]]
- [[PUR.Material.Allocation.v1.2/Project_Executive_Board|Project Executive Board]]
- [[PUR.Material.Allocation.v1.2/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-10-30
- Source Event: PPJ-WEEKLY-20261023-20261030
- Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Confidence: Strong

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

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

<!-- PPJ_WEEKLY_20261023_20261030_START -->
## Weekly Synchronization Event: PPJ-WEEKLY-20261023-20261030

### Verified movement

WFX documented GET/POST behaviour and issued the Style/Article API enhancement specification dated 26-28 October, including partial Style/Article search. This is API-definition progress only; deployment and transaction-control testing are not confirmed.

### Current gate

Confirm API implementation and controlled GET/POST transaction UAT

### Risks / blockers

- Deployment status, performance, concurrency and audit behaviour are unconfirmed.
- Duplicate prevention, rollback, partial allocation and exception controls still require transaction UAT.

### Decisions required

- Confirm API deployment ownership and the transaction-control UAT gate.

### Next actions

- Confirm the specified API is implemented in the controlled environment.
- Execute controlled GET/POST tests for partial Style/Article search and allocation transactions.
- Validate duplicate prevention, rollback, concurrency, audit and user confirmation.

### Traceability

- Report: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261030-PORTFOLIO-GATES]]
- Last verified: 2026-10-30
- Confidence: Strong
<!-- PPJ_WEEKLY_20261023_20261030_END -->
