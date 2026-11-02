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
last_verified: "2026-09-18"
confidence: "Strong"
workspace_path: "03_Projects/ADMIN_ExpenseManagement_v1.1.0"
project_home: "03_Projects/ADMIN_ExpenseManagement_v1.1.0/00_Project_Home.md"
project_board: "03_Projects/ADMIN_ExpenseManagement_v1.1.0/Project_Executive_Board.canvas"
task_folder: "03_Projects/ADMIN_ExpenseManagement_v1.1.0/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
canonical_code: "ADMIN_ExpenseManagement_v1.1.0"
current_file: "ADMIN_ExpenseManagement_v1.1.0.md"
primary_domain: "Administration"
delivery_stream: "INTERNAL DEVELOPMENT"
delivery_stage: "UAT / PRE-GO-LIVE"
lifecycle: "Active / Requirement Refinement / UAT Preparation"
progress: "~90% (2026-09-15 meeting recap)"
current_gate: "Multi-traveler request model, end-to-end lifecycle and UAT preparation"
current_outcome: "Standardize Administration business-travel and expense-management workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement."
latest_update_summary: "Evolved well beyond the initial Travel Request application. Modules: TravelRequest, TravelApproval, TripManagement, Advance, Expense, Settlement. Latest major change: one request can contain multiple travelers, each with a traveler-specific travel plan (origin, destination, stops, dates, flight, hotel/shared room, per diem, customer visit). Management concern: prevent scope creep; the core stays Request -> Approval -> Trip -> Expense -> Settlement."
known_risks: "Scope creep beyond Request -> Approval -> Trip -> Expense -> Settlement | Approval/status rules need confirmation | Multi-traveler data model complexity"
known_blockers: "Scope creep beyond Request -> Approval -> Trip -> Expense -> Settlement | Approval/status rules need confirmation | Multi-traveler data model complexity"
decisions_needed: "None recorded"
next_actions: "Validate the booking workflow and status model | Model multi-traveler requests with per-traveler travel plans | Finalize approval matrix, advance, expense submission and settlement | Define vendor catalogue and expense categories | Prepare UAT"
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
| Current Gate | Multi-traveler request model, end-to-end lifecycle and UAT preparation |
| Priority | P6 |
| Business Owner | Administration |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

Standardize Administration business-travel and expense-management workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement.

## Current Capability

TravelRequest / TravelApproval / TripManagement / Advance / Expense / Settlement with multi-traveler requests.

## Latest Update

Evolved well beyond the initial Travel Request application. Modules: TravelRequest, TravelApproval, TripManagement, Advance, Expense, Settlement. Latest major change: one request can contain multiple travelers, each with a traveler-specific travel plan (origin, destination, stops, dates, flight, hotel/shared room, per diem, customer visit). Management concern: prevent scope creep; the core stays Request -> Approval -> Trip -> Expense -> Settlement.

## Risks / Blockers

- Scope creep beyond Request -> Approval -> Trip -> Expense -> Settlement
- Approval/status rules need confirmation
- Multi-traveler data model complexity

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Validate the booking workflow and status model
- Model multi-traveler requests with per-traveler travel plans
- Finalize approval matrix, advance, expense submission and settlement
- Define vendor catalogue and expense categories
- Prepare UAT

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

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
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
