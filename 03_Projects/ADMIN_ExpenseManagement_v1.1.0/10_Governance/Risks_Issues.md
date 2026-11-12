---
type: "risks_issues"
project: "ADMIN_ExpenseManagement_v1.1.0"
source_project: "ADMIN_ExpenseManagement_v1.1.0.md"
source_event: "PPJ-WEEKLY-20261030-20261106"
last_verified: "2026-11-06"
confidence: "Needs Confirmation"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
current_gate: "Formal UAT and release decision"
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

# Risks and Issues

| ID | Risk / Issue | Impact | Owner | Status | Source |
| --- | --- | --- | --- | --- | --- |
| RISK-001 | Needs Confirmation | Needs Confirmation | Needs Confirmation | Open | PPJ-PROJECT-REGISTRATION-ADMIN_ExpenseManagement_v1.1.0-20260918 |
| RISK-002 | Scope, rules, data ownership and acceptance require confirmation. | Needs Confirmation | Needs Confirmation | Open | PPJ-PROJECT-REGISTRATION-ADMIN_ExpenseManagement_v1.1.0-20260918 |

## Evidence Basis

- Root project note: [[03_Projects/ADMIN_ExpenseManagement_v1.1.0]]
- Project memory: [[03_Projects/_Registry/Project_Memory/ADMIN_ExpenseManagement_v1.1.0.memory]]
- Source event: PPJ-PROJECT-REGISTRATION-ADMIN_ExpenseManagement_v1.1.0-20260918
- Last verified: 2026-09-18
- Confidence: Needs Confirmation

<!-- PPJ_WEEKLY_20261023_20261030_RISKS_START -->
## Weekly Risk Update - 2026-10-30

- Accounting mappings and authorization/access testing are not confirmed.
- Migration, training, eOffice budget and release ownership remain unresolved.

Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]] (PPJ-WEEKLY-20261023-20261030)
<!-- PPJ_WEEKLY_20261023_20261030_RISKS_END -->

<!-- PPJ_WEEKLY_20261030_20261106_RISKS_START -->
## Weekly Risk Update - 2026-11-06

- Guide completion may be mistaken for release approval or production readiness.
- Access, accounting mappings and migrations are not confirmed.
- Irreversible actions, release authority, UAT ownership, training and support remain unresolved.

Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261106]] (PPJ-WEEKLY-20261030-20261106)
<!-- PPJ_WEEKLY_20261030_20261106_RISKS_END -->
