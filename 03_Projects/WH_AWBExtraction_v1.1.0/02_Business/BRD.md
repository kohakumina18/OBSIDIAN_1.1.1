---
type: "brd"
project: "WH_AWBExtraction_v1.1.0"
source_project: "WH_AWBExtraction_v1.1.0.md"
source_event: "PPJ-PROJECT-REGISTRATION-WH_AWBExtraction_v1.1.0-20260918"
last_verified: "2026-09-18"
confidence: "Needs Confirmation"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Business Requirements Document

## Executive Summary

Warehouse project for AWB: Extraction.

## Business Problem

Needs Confirmation from the current project evidence and responsible business users.

## Objectives

- Extract AWB image and DHL email data into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates) with confidence scoring and human review.

## Users / Stakeholders

- Primary users: Warehouse shipping-document users
- Business owner: Warehouse
- BA / Coordination: Khoa

## Current Process

Needs Confirmation. See [[../03_Process/AS_IS_Process]].

## Pain Points

- Scope, rules, data ownership and acceptance require confirmation.

## Target Process

See [[../03_Process/TO_BE_Process]]. Target flow remains subject to current-gate approval.

## Scope

- AWB
- Extraction

## Out of Scope

- Unapproved expansion or merger with another canonical project

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

- Scope, rules, data ownership and acceptance require confirmation.

## Assumptions

- Registry, memory and root project note remain the source of truth.
- Unverified details are not treated as approved requirements.

## Dependencies

- AWB images (OCR); DHL emails (email parsing)

## Decisions Required

- Confirm business rules, source of truth and delivery ownership.

## Acceptance Summary

See [[../05_Requirements/Acceptance_Criteria]]. Formal acceptance owner and evidence remain Needs Confirmation unless explicitly recorded.

## Evidence Basis

- Root project note: [[03_Projects/WH_AWBExtraction_v1.1.0]]
- Project memory: [[03_Projects/_Registry/Project_Memory/WH_AWBExtraction_v1.1.0.memory]]
- Source event: PPJ-PROJECT-REGISTRATION-WH_AWBExtraction_v1.1.0-20260918
- Last verified: 2026-09-18
- Confidence: Needs Confirmation
