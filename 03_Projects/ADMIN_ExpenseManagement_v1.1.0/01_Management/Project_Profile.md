---
type: "project_profile"
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

# Project Profile

## Identity

| Field | Value |
| --- | --- |
| Canonical Code | ADMIN_ExpenseManagement_v1.1.0 |
| Physical Project Note | ADMIN_ExpenseManagement_v1.1.0.md |
| Primary Domain | Administration |
| Cluster | Workflow |
| Lifecycle Class | B. UAT / Stabilization |
| Lifecycle | UAT Preparation |
| Current Gate | Registration / Business Discovery |
| Priority | P6 |
| Business Owner | Administration |

## One-Line Understanding

Administration project for ExpenseManagement: Business travel request, approval, advance, expense and settlement.

## Intended Outcome

Standardize Administration business-travel and expense workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement, with multi-traveler requests.

## Users and Delivery Participants

- Primary users: Employees requesting travel; Admin staff by region (HO, Da Nang, Ha Noi, Nha Trang/Phu Yen); approvers; accounting
- BA / Coordination: Khoa
- Technical members: Needs Confirmation

## Current Scope

- ExpenseManagement
- Business travel request, approval, advance, expense and settlement

## Explicit Boundaries

- Unapproved expansion or merger with another canonical project

## Current Gate and Next Move

- Gate: Registration / Business Discovery
- Next actions: Validate booking workflow and status model, model multi-traveler requests, and prepare UAT

## Evidence Basis

- Root project note: [[03_Projects/ADMIN_ExpenseManagement_v1.1.0]]
- Project memory: [[03_Projects/_Registry/Project_Memory/ADMIN_ExpenseManagement_v1.1.0.memory]]
- Source event: PPJ-PROJECT-REGISTRATION-ADMIN_ExpenseManagement_v1.1.0-20260918
- Last verified: 2026-09-18
- Confidence: Needs Confirmation
