---
type: "brd"
project: "PPJ.ExpenseInvoices.v1.1"
source_project: "PPJ. Expense-Invoices.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Business Requirements Document

## Executive Summary

Expense invoice platform/workflow for mapping accounting fields, ledger, and department/factory rules before automation.

## Business Problem

Needs Confirmation from the current project evidence and responsible business users.

## Objectives

- Expense-invoice workflow for approved business scope, supplier mapping, department/factory mapping, ledger/account mapping, validation and controlled entry.

## Users / Stakeholders

- Primary users: Accounting
- Business owner: Needs Confirmation
- BA / Coordination: Uyên

## Current Process

Needs Confirmation. See [[../03_Process/AS_IS_Process]].

## Pain Points

- Duplicate invoices, invalid mappings and weak error handling could affect Accounting operations.
- Production monitoring and escalation ownership are pending.

## Target Process

See [[../03_Process/TO_BE_Process]]. Target flow remains subject to current-gate approval.

## Scope

- Expense invoice workflow/data mapping foundation.

## Out of Scope

- Not a v2 rollout to all departments unless formally approved.

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

- Duplicate invoices, invalid mappings and weak error handling could affect Accounting operations.
- Production monitoring and escalation ownership are pending.

## Assumptions

- Registry, memory and root project note remain the source of truth.
- Unverified details are not treated as approved requirements.

## Dependencies

- Supplier Master -> Supplier Mapping -> Department/Factory and Ledger Mapping -> Validation -> Expense Invoice Entry -> Monitoring

## Decisions Required

- Approve supplier and mapping ownership.
- Confirm go-live boundary and production-support escalation.

## Acceptance Summary

See [[../05_Requirements/Acceptance_Criteria]]. Formal acceptance owner and evidence remain Needs Confirmation unless explicitly recorded.

## Evidence Basis

- Root project note: [[../PPJ. Expense-Invoices.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PPJ.ExpenseInvoices.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
