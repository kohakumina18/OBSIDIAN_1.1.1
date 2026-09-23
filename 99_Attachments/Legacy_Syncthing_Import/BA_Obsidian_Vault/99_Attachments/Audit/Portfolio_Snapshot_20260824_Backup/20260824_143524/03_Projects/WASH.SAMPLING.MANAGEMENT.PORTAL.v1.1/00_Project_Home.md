---
type: "project_home"
project: "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1"
source_project: "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
last_verified: "2026-08-24"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "Analysis / Product Design"
current_gate: "Sampling workflow and product design"
priority: "Medium"
delivery_stage: "DESIGN"
status: "Active"
stage_entered_date: "Needs Confirmation"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1 |
| Primary Domain | Production + Wash |
| Delivery Stage | DESIGN |
| Lifecycle | Analysis / Product Design |
| Status | Active |
| Progress | TBD |
| Current Gate | Sampling workflow and product design |
| Priority | Medium |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Create a PPJ Group Portal workflow for Wash sample requests, trials, results, approvals and history.

## Current Capability

Create a PPJ Group Portal workflow for Wash sample requests, trials, results, approvals and history.

## Latest Update

Target flow is Sample Request -> Assignment -> Trial -> Result -> Image/Comment -> Approval -> History; it remains separate from PROD.COWASH.

## Risks / Blockers

- Workflow ownership
- Do not merge with operational COWASH

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Confirm sampling workflow, data fields and roles
- Design approval/history and attachment handling

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1/00_Project_Home|Project Home]]
- [[WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1/Project_Executive_Board|Project Executive Board]]
- [[WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1 |
| Current File | WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md |
| Primary Domain | Production + Wash |
| Secondary Domains | R&D Wash, Portal, Sampling Workflow |
| Lifecycle | ANALYSIS |
| Progress | TBD |
| Current Gate | New Booking / Analysis |
| Priority | P1 |
| Business Owner | Needs Confirmation |
| Primary Users | R&D Wash / Khoa / Huy / Hien |
| BA / Coordination | Khoa |
| Technical Members | Nam, Huy, Hiền |
| Last Verified | 2026-07-13 |
| Confidence | Strong |

## One-Line Understanding

Portal for R&D Wash sampling management, status tracking, attachments, comments, and permissions.

## Business Goal

Port and standardize wash sampling workflow into PPJ Group Portal.

## Current Outcome

Port and standardize wash sampling workflow into PPJ Group Portal.

## Latest Update

Canonical naming populated from portfolio dictionary.

## Current Scope

- Workflow/data/portal project for wash sample requests, status, image/attachment, result/comment, and approval if needed.

## Current Risks / Blockers

- Need current app/process walkthrough, data owner, permission model, and data standardization before UI port.

## Decisions Needed

- Confirm business owner.
- Confirm technical owner.
- Confirm source of truth.
- Confirm phase, scope, and next action.

## Next Actions

- Review repaired block with project owner.
- Confirm missing data fields and workflow.
- Update related BRD/SOP/user manual after confirmation.

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
[[../WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
