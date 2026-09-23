---
type: "brd"
project: "PUR.GDI.Automation.v1.0"
source_project: "PUR.GDI Automation.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Business Requirements Document

## Executive Summary

Purchasing GDI creation automation currently on hold due WFX/system dependency.

## Business Problem

Needs Confirmation from the current project evidence and responsible business users.

## Objectives

- API-first GDI creation and update workflow that reduces manual Purchasing work while preserving review, transaction control and auditability in WFX.

## Users / Stakeholders

- Primary users: Purchasing and participating MER leaders/managers
- Business owner: Needs Confirmation
- BA / Coordination: Uyên

## Current Process

Needs Confirmation. See [[../03_Process/AS_IS_Process]].

## Pain Points

- Direct unapproved Databricks writes would not constitute a governed WFX transaction.
- Duplicate transactions and incomplete rollback could damage operational data.

## Target Process

See [[../03_Process/TO_BE_Process]]. Target flow remains subject to current-gate approval.

## Scope

- Automation for Goods Delivery Instruction creation.

## Out of Scope

- Not active production if WFX modification/dependency remains blocked.

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

- Direct unapproved Databricks writes would not constitute a governed WFX transaction.
- Duplicate transactions and incomplete rollback could damage operational data.

## Assumptions

- Registry, memory and root project note remain the source of truth.
- Unverified details are not treated as approved requirements.

## Dependencies

- Confirmed Purchasing Workflow -> WFX API -> Controlled GDI Transaction -> Audit and Status

## Decisions Required

- Approve WFX API or vendor-approved transactional service.
- Confirm transaction, rollback, approval and audit architecture.

## Acceptance Summary

See [[../05_Requirements/Acceptance_Criteria]]. Formal acceptance owner and evidence remain Needs Confirmation unless explicitly recorded.

## Evidence Basis

- Root project note: [[../PUR.GDI Automation]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PUR.GDI.Automation.v1.0.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
