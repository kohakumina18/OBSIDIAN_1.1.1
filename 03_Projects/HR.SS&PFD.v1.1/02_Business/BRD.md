---
type: "brd"
project: "HR.SSPFD.Workflow.v1.1"
source_project: "HR.SS&PFD.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Business Requirements Document

## Executive Summary

HR/BHXH workflow requiring latest 3-month WISER data and field-level mapping.

## Business Problem

Needs Confirmation from the current project evidence and responsible business users.

## Objectives

- Group employee master-data standardization and applicant-data extraction/application-form prefill workflows.

## Users / Stakeholders

- Primary users: HR; production owner Needs Confirmation
- Business owner: Needs Confirmation
- BA / Coordination: Khoa

## Current Process

Needs Confirmation. See [[../03_Process/AS_IS_Process]].

## Pain Points

- Sensitive HR and applicant data require strict permissions.
- Incorrect matching may merge unrelated employee records.
- Applicant consent and privacy controls require confirmation.

## Target Process

See [[../03_Process/TO_BE_Process]]. Target flow remains subject to current-gate approval.

## Scope

- HR internal process/data project for SS&PFD/BHXH-related workflow.

## Out of Scope

- Not fully defined beyond WISER data need unless HR confirms scope.

## Business Requirements

- Deliver the verified project outcome without unapproved scope expansion.
- Preserve review, exception, evidence and traceability controls appropriate to the project type.
- Confirm any missing rule with the responsible business owner.

## Business Rules

See [[Scope_and_Business_Rules]]. Unconfirmed rules remain Needs Confirmation.

## Data Requirements Summary

See [[../04_Data/Data_Spec]] and [[../04_Data/Data_Source_Inventory]].

## Integration Summary

See [[../06_Solution/Integration_Spec]]. No direct transactional write is assumed.

## AI / Automation Scope

Applicable only where confirmed in the project memory, project note or approved update.

## Human Validation

Responsible users must validate outputs before business decisions or transactions when automation or AI is involved.

## Exception / Fallback

Unresolved exceptions must be logged, assigned and handled through an approved manual or system fallback.

## KPI / Measurable Outcome

Needs Confirmation.

## Risks

- Sensitive HR and applicant data require strict permissions.
- Incorrect matching may merge unrelated employee records.
- Applicant consent and privacy controls require confirmation.

## Assumptions

- Registry, memory and root project note remain the source of truth.
- Unverified details are not treated as approved requirements.

## Dependencies

- Employee source data -> Matching Rules -> Trusted Employee Master -> Group Rollout
- Applicant Input -> Extraction -> Mandatory-field Validation -> Prefill -> Review -> Structured Submission

## Decisions Required

- Assign production owner and correction authority.
- Approve applicant consent and privacy controls.
- Confirm post-rollout support boundary.

## Acceptance Summary

See [[../05_Requirements/Acceptance_Criteria]]. Formal acceptance owner and evidence remain Needs Confirmation unless explicitly recorded.

## Evidence Basis

- Root project note: [[../HR.SS&PFD.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/HR.SSPFD.Workflow.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
