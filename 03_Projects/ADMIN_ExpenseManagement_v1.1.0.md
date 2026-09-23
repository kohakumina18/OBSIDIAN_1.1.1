---
type: project
project_name: "ADMIN_ExpenseManagement_v1.1.0"
project_code: "ADMIN_ExpenseManagement_v1.1.0"
canonical_code: "ADMIN_ExpenseManagement_v1.1.0"
current_file: "ADMIN_ExpenseManagement_v1.1.0.md"
department: "Administration"
object: "ExpenseManagement"
project_characteristic: "Business travel request, approval, advance, expense and settlement"
version: "v1.1.0"
phase: "UAT / PRE-GO-LIVE"
lifecycle: "Active / Requirement Refinement / UAT Preparation"
cluster: "Workflow"
priority: "P6"
business_owner: "Administration"
ba_coordination: "Khoa"
technical_members: []
status: "Active"
last_updated: "2026-09-18"
last_verified: "2026-09-18"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
confidence: "Needs Confirmation"
primary_domain: "Administration"
delivery_stream: "INTERNAL DEVELOPMENT"
delivery_stage: "UAT / PRE-GO-LIVE"
progress: "~90% (2026-09-15 meeting recap)"
current_gate: "Multi-traveler request model, end-to-end lifecycle and UAT preparation"
stage_entered_date: "Needs Confirmation"
---

# ADMIN_ExpenseManagement_v1.1.0

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

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

<!-- PPJ_PROJECT_KNOWLEDGE_END -->
