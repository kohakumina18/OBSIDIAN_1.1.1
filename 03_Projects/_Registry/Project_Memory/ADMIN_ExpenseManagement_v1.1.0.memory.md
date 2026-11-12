---
type: project_memory
project_name: "ADMIN_ExpenseManagement_v1.1.0"
project_file: "ADMIN_ExpenseManagement_v1.1.0.md"
project_code: "ADMIN_ExpenseManagement_v1.1.0"
department: "Administration"
cluster: "Workflow"
phase: "UAT / PRE-GO-LIVE"
status: "Active"
priority: "P6"
business_owner: "Administration"
ba_coordination: ["Khoa"]
technical_members: []
stakeholders: []
systems: []
data_sources: ["ADMIN_EXPENSE-RECAP-UAT-3 (15/09/2026 meeting recap); travel/expense regulations and per-diem rates"]
last_verified: "2026-11-06"
confidence: "Strong"
workspace_path: "03_Projects/ADMIN_ExpenseManagement_v1.1.0"
project_home: "03_Projects/ADMIN_ExpenseManagement_v1.1.0/00_Project_Home.md"
project_board: "03_Projects/ADMIN_ExpenseManagement_v1.1.0/Project_Executive_Board.canvas"
task_folder: "03_Projects/ADMIN_ExpenseManagement_v1.1.0/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-WEEKLY-20261030-20261106"
canonical_code: "ADMIN_ExpenseManagement_v1.1.0"
current_file: "ADMIN_ExpenseManagement_v1.1.0.md"
primary_domain: "Administration"
delivery_stream: "INTERNAL DEVELOPMENT"
delivery_stage: "UAT / PRE-GO-LIVE"
lifecycle: "Active / Requirement Refinement / UAT Preparation"
progress: "~90% (2026-09-15 meeting recap)"
current_gate: "Formal UAT and release decision"
current_outcome: "Standardize Administration business-travel and expense-management workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement."
latest_update_summary: "Employee and Admin operating guides are complete. This is release-enablement progress and does not confirm go-live. Access, accounting mappings, migrations, irreversible actions, release authority, UAT ownership and support remain unresolved."
known_risks: "Scope creep beyond Request -> Approval -> Trip -> Expense -> Settlement | Approval/status rules need confirmation | Multi-traveler data model complexity"
known_blockers: "Scope creep beyond Request -> Approval -> Trip -> Expense -> Settlement | Approval/status rules need confirmation | Multi-traveler data model complexity"
decisions_needed: "None recorded"
next_actions: "Run the release gate covering access, accounting, migrations, irreversible actions, training and support. | Record formal UAT outcomes and release authority before any go-live claim."
dependencies: "None recorded"
stage_entered_date: "Needs Confirmation"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260918"]
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | ADMIN_ExpenseManagement_v1.1.0 |
| Legacy Code(s) | Admin Expense Management.v1.1; Business Travel / Admin Expense Management |
| Primary Domain | Administration |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Active / Requirement Refinement / UAT Preparation |
| Status | Active |
| Progress | ~90% (2026-09-15 meeting recap) |
| Current Gate | Formal UAT and release decision |
| Priority | P6 |
| Business Owner | Administration |
| Registration | Registered |
| Last Verified | 2026-11-06 |
| Confidence | Strong |

## Executive Summary

Standardize Administration business-travel and expense-management workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement.

## Current Capability

TravelRequest / TravelApproval / TripManagement / Advance / Expense / Settlement with multi-traveler requests.

## Latest Update

Employee and Admin operating guides are complete. This is release-enablement progress and does not confirm go-live. Access, accounting mappings, migrations, irreversible actions, release authority, UAT ownership and support remain unresolved.

## Risks / Blockers

- Guide completion may be mistaken for release approval or production readiness.
- Access, accounting mappings and migrations are not confirmed.
- Irreversible actions, release authority, UAT ownership, training and support remain unresolved.

## Decisions Needed

- Approve Business Travel release authority, UAT ownership and support model.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Run the release gate covering access, accounting, migrations, irreversible actions, training and support.
- Record formal UAT outcomes and release authority before any go-live claim.

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[ADMIN_ExpenseManagement_v1.1.0/00_Project_Home|Project Home]]
- [[ADMIN_ExpenseManagement_v1.1.0/Project_Executive_Board|Project Executive Board]]
- [[ADMIN_ExpenseManagement_v1.1.0/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-11-06
- Source Event: PPJ-WEEKLY-20261030-20261106
- Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261106]]
- Confidence: Strong

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Memory: ADMIN_ExpenseManagement_v1.1.0

## One-Line Understanding

Administration project for ExpenseManagement: Business travel request, approval, advance, expense and settlement.

## Business Meaning

Business-travel requests, approvals, advances, expenses and settlements are handled inconsistently; one request may cover several travelers with different travel plans.

## Outcome

Standardize Administration business-travel and expense workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement, with multi-traveler requests.

## What This Project Is

Business travel request, approval, advance, expense and settlement

## What This Project Is Not

Not a replacement or merger of another canonical project unless separately approved.

## Key Users

Employees requesting travel; Admin staff by region (HO, Da Nang, Ha Noi, Nha Trang/Phu Yen); approvers; accounting

## Systems / Data

ADMIN_EXPENSE-RECAP-UAT-3 (15/09/2026 meeting recap); travel/expense regulations and per-diem rates

## Current Phase / Status

UAT Preparation / Registered

## Known Risks

Needs Confirmation

## Decisions Needed

Confirm scope, ownership, source-of-truth and lifecycle gate.

## Next Actions

Validate booking workflow and status model, model multi-traveler requests, and prepare UAT

## Do Not Drift Rules

- Do not invent owners, systems, tables, dates, rules or implementation status.
- Do not merge or rename this project without approval.

## Source Links

- [[ADMIN_ExpenseManagement_v1.1.0]]
- [[03_Projects/ADMIN_ExpenseManagement_v1.1.0/00_Project_Home|Project Workspace]]

<!-- PPJ_WEEKLY_20261023_20261030_START -->
## Weekly Synchronization Event: PPJ-WEEKLY-20261023-20261030

### Verified movement

No new confirmed release result exists as of 30 October. The project remains in release preparation; Accounting mappings, authorization, migrations, training, eOffice budget and release ownership remain open.

### Current gate

Formal Business Travel release decision

### Risks / blockers

- Accounting mappings and authorization/access testing are not confirmed.
- Migration, training, eOffice budget and release ownership remain unresolved.

### Decisions required

- Approve release authority, accounting exceptions, access testing, training and eOffice budget.

### Next actions

- Run the formal release gate and record owners for every unresolved control.

### Traceability

- Report: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261030-PORTFOLIO-GATES]]
- Last verified: 2026-10-30
- Confidence: Strong
<!-- PPJ_WEEKLY_20261023_20261030_END -->

<!-- PPJ_WEEKLY_20261030_20261106_START -->
## Weekly Synchronization Event: PPJ-WEEKLY-20261030-20261106

### Verified movement

Employee and Admin operating guides are complete. This is release-enablement progress and does not confirm go-live. Access, accounting mappings, migrations, irreversible actions, release authority, UAT ownership and support remain unresolved.

### Current gate

Formal UAT and release decision

### Risks / blockers

- Guide completion may be mistaken for release approval or production readiness.
- Access, accounting mappings and migrations are not confirmed.
- Irreversible actions, release authority, UAT ownership, training and support remain unresolved.

### Decisions required

- Approve Business Travel release authority, UAT ownership and support model.

### Next actions

- Run the release gate covering access, accounting, migrations, irreversible actions, training and support.
- Record formal UAT outcomes and release authority before any go-live claim.

### Traceability

- Report: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261106]]
- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261106-PORTFOLIO-GATES]]
- Last verified: 2026-11-06
- Confidence: Strong
<!-- PPJ_WEEKLY_20261030_20261106_END -->
