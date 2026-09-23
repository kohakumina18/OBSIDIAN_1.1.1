---
type: "project_plan"
project: "ADMIN_ExpenseManagement_v1.1.0"
source_project: "ADMIN_ExpenseManagement_v1.1.0.md"
source_event: "PPJ-PROJECT-REGISTRATION-ADMIN_ExpenseManagement_v1.1.0-20260918"
last_verified: "2026-09-18"
confidence: "Needs Confirmation"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-09-18

| Field | Value |
| --- | --- |
| Canonical Code | ADMIN_ExpenseManagement_v1.1.0 |
| Domain | Administration |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Active / Requirement Refinement / UAT Preparation |
| Status | Active |
| Progress | ~90% (2026-09-15 meeting recap) |
| Gate | Multi-traveler request model, end-to-end lifecycle and UAT preparation |
| Priority | P6 |
| Outcome | Standardize Administration business-travel and expense-management workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

Evolved well beyond the initial Travel Request application. Modules: TravelRequest, TravelApproval, TripManagement, Advance, Expense, Settlement. Latest major change: one request can contain multiple travelers, each with a traveler-specific travel plan (origin, destination, stops, dates, flight, hotel/shared room, per diem, customer visit). Management concern: prevent scope creep; the core stays Request -> Approval -> Trip -> Expense -> Settlement.

### Current Risks

- Scope creep beyond Request -> Approval -> Trip -> Expense -> Settlement
- Approval/status rules need confirmation
- Multi-traveler data model complexity

### Dependencies

- None recorded in the current portfolio snapshot.

### Next Actions

- Validate the booking workflow and status model
- Model multi-traveler requests with per-traveler travel plans
- Finalize approval matrix, advance, expense submission and settlement
- Define vendor catalogue and expense categories
- Prepare UAT
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Plan

## Planning Basis

- Lifecycle: UAT Preparation
- Current gate: Registration / Business Discovery
- Priority: P6
- Plan status: Current Working Document

## Current Work Packages

1. Confirm scope, ownership and evidence.
2. Complete the current lifecycle gate.
3. Maintain task, risk, decision and dependency traceability.
4. Prepare only the next approved delivery or closeout step.

## Evidence-Based Next Actions

- Validate booking workflow and status model, model multi-traveler requests, and prepare UAT

## Dependencies

- ADMIN_EXPENSE-RECAP-UAT-3 (15/09/2026 meeting recap); travel/expense regulations and per-diem rates

## Planning Controls

- No unapproved scope expansion.
- No invented owner, date, source table or business rule.
- Each milestone requires evidence and responsible-owner confirmation.

## Evidence Basis

- Root project note: [[03_Projects/ADMIN_ExpenseManagement_v1.1.0]]
- Project memory: [[03_Projects/_Registry/Project_Memory/ADMIN_ExpenseManagement_v1.1.0.memory]]
- Source event: PPJ-PROJECT-REGISTRATION-ADMIN_ExpenseManagement_v1.1.0-20260918
- Last verified: 2026-09-18
- Confidence: Needs Confirmation
