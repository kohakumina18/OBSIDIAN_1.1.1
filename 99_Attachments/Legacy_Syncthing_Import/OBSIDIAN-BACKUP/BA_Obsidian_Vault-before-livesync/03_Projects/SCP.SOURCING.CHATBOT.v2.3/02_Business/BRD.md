---
type: "brd"
project: "SCP.SOURCING.CHATBOT.v2.3"
source_project: "SCP.SOURCING.CHATBOT.v2.3.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Business Requirements Document

## Executive Summary

Consolidated Sourcing data platform and chatbot for supplier, material, fabric, trims, and sample lookup.

## Business Problem

Needs Confirmation from the current project evidence and responsible business users.

## Objectives

- Consolidated Sourcing data platform and chatbot for supplier, material, fabric, trims and sample lookup.

## Users / Stakeholders

- Primary users: Sourcing; data/permission/support owners Need Confirmation
- Business owner: Needs Confirmation
- BA / Coordination: Khoa

## Current Process

Needs Confirmation. See [[../03_Process/AS_IS_Process]].

## Pain Points

- Closing chatbot development could be confused with completing the data foundation.
- Future MER usage requires stress, permission, search-quality and data-normalization tests.

## Target Process

See [[../03_Process/TO_BE_Process]]. Target flow remains subject to current-gate approval.

## Scope

- One consolidated project covering sourcing data repository, external samples, and chatbot lookup.

## Out of Scope

- Do not split into separate Sourcing Repository, External Sample Management, and Sourcing Chatbot projects without approval.

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

- Closing chatbot development could be confused with completing the data foundation.
- Future MER usage requires stress, permission, search-quality and data-normalization tests.

## Assumptions

- Registry, memory and root project note remain the source of truth.
- Unverified details are not treated as approved requirements.

## Dependencies

- External Manual Input -> Validation -> Standardization -> Sourcing Data Platform -> Chatbot Search Quality

## Decisions Required

- Approve active-development closeout separately from external-data backlog.
- Confirm data, permission and support ownership.

## Acceptance Summary

See [[../05_Requirements/Acceptance_Criteria]]. Formal acceptance owner and evidence remain Needs Confirmation unless explicitly recorded.

## Evidence Basis

- Root project note: [[../SCP.SOURCING.CHATBOT.v2.3]]
- Project memory: [[03_Projects/_Registry/Project_Memory/SCP.SOURCING.CHATBOT.v2.3.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
