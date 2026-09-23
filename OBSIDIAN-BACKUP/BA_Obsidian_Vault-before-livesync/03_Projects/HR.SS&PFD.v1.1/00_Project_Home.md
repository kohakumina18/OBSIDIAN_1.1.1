---
type: "project_home"
project: "HR.SSPFD.Workflow.v1.1"
source_project: "HR.SS&PFD.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# HR.SSPFD.Workflow.v1.1

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | HR.SSPFD.Workflow.v1.1 |
| Current File | HR.SS&PFD.v1.1.md |
| Primary Domain | HR |
| Secondary Domains | WISER, BHXH, Sensitive HR Data |
| Lifecycle | Production Rollout / Stabilization |
| Progress | TBD |
| Current Gate | UAT Completed / Initial Deployment / Group Rollout |
| Priority | TBD |
| Business Owner | Needs Confirmation |
| Primary Users | HR; production owner Needs Confirmation |
| BA / Coordination | Khoa |
| Technical Members | Needs Confirmation |
| Last Verified | 2026-08-01 |
| Confidence | Strong |

## One-Line Understanding

HR/BHXH workflow requiring latest 3-month WISER data and field-level mapping.

## Business Goal

Group employee master-data standardization and applicant-data extraction/application-form prefill workflows.

## Current Outcome

Group employee master-data standardization and applicant-data extraction/application-form prefill workflows.

## Latest Update

Demo, UAT, initial testing and User Manual were completed. Deployment started, including group-wide employee-data standardization rollout. The project now contains employee master-data standardization and applicant data extraction/prefill workflows.

## Current Scope

- HR internal process/data project for SS&PFD/BHXH-related workflow.

## Current Risks / Blockers

- Production-support ownership across HR, Software Team, AI Team and HR IT is not confirmed.
- Conflicting-record correction authority is unclear.
- Sensitive HR and applicant data require strict permissions.
- Incorrect matching may merge unrelated employee records.
- Applicant consent and privacy controls require confirmation.

## Decisions Needed

- Assign production owner and correction authority.
- Approve applicant consent and privacy controls.
- Confirm post-rollout support boundary.

## Next Actions

- Monitor rollout by company and factory.
- Finalize employee matching and conflict-handling rules.
- Monitor rollout issues, fix and retest.
- Build rollout-status dashboard and complete Workflow 2 user guidance.
- Confirm production-support handover.

## Key Dependencies

- Employee source data -> Matching Rules -> Trusted Employee Master -> Group Rollout
- Applicant Input -> Extraction -> Mandatory-field Validation -> Prefill -> Review -> Structured Submission

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
[[../HR.SS&PFD.v1.1]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/HR.SSPFD.Workflow.v1.1.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
