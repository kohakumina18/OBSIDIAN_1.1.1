---
type: "brd"
project: "PPJ.InvoiceDownloader.v1.2"
source_project: "PPJ.Invoice Downloader.v1.2.md"
source_event: "Canonical naming populated"
last_verified: "2026-07-13"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Business Requirements Document

## Executive Summary

API/tool for downloading and merging e-invoices, now accessible through GPT/PERRI-enabled automation.

## Business Problem

Needs Confirmation from the current project evidence and responsible business users.

## Objectives

- Reduce manual invoice download/merge work while adding logging, permission, retry, and fallback controls.

## Users / Stakeholders

- Primary users: Accounting / EXIM / Uyen / Nam / Phat
- Business owner: Needs Confirmation
- BA / Coordination: Uyên

## Current Process

Needs Confirmation. See [[../03_Process/AS_IS_Process]].

## Pain Points

- Credential/session, permission, portal UI/API changes, duplicate/missing invoice, metadata accuracy.

## Target Process

See [[../03_Process/TO_BE_Process]]. Target flow remains subject to current-gate approval.

## Scope

- Production/API enhancement project for invoice download and output standardization.

## Out of Scope

- Not automatic accounting posting unless separately confirmed.

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

- Credential/session, permission, portal UI/API changes, duplicate/missing invoice, metadata accuracy.

## Assumptions

- Registry, memory and root project note remain the source of truth.
- Unverified details are not treated as approved requirements.

## Dependencies

- Needs Confirmation

## Decisions Required

- Confirm business owner.
- Confirm technical owner.
- Confirm source of truth.
- Confirm phase, scope, and next action.

## Acceptance Summary

See [[../05_Requirements/Acceptance_Criteria]]. Formal acceptance owner and evidence remain Needs Confirmation unless explicitly recorded.

## Evidence Basis

- Root project note: [[../PPJ.Invoice Downloader.v1.2]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PPJ.InvoiceDownloader.v1.2.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-07-13
- Confidence: Strong
