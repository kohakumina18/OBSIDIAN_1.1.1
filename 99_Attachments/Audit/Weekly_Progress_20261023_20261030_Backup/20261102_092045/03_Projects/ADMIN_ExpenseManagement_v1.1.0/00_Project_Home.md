---
type: "project_home"
project: "ADMIN_ExpenseManagement_v1.1.0"
source_project: "ADMIN_ExpenseManagement_v1.1.0.md"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
last_verified: "2026-09-18"
confidence: "Needs Confirmation"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
delivery_stream: "INTERNAL DEVELOPMENT"
delivery_stage: "UAT / PRE-GO-LIVE"
status: "Active"
stage_entered_date: "Needs Confirmation"
lifecycle: "Active / Requirement Refinement / UAT Preparation"
current_gate: "Multi-traveler request model, end-to-end lifecycle and UAT preparation"
priority: "P6"
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

# ADMIN_ExpenseManagement_v1.1.0

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | ADMIN_ExpenseManagement_v1.1.0 |
| Current File | ADMIN_ExpenseManagement_v1.1.0.md |
| Primary Domain | Administration |
| Secondary Domains | Workflow |
| Lifecycle | UAT Preparation |
| Progress | Not Started |
| Current Gate | Registration / Business Discovery |
| Priority | P6 |
| Business Owner | Administration |
| Primary Users | Employees requesting travel; Admin staff by region (HO, Da Nang, Ha Noi, Nha Trang/Phu Yen); approvers; accounting |
| BA / Coordination | Khoa |
| Technical Members | Needs Confirmation |
| Last Verified | 2026-09-18 |
| Confidence | Needs Confirmation |

## One-Line Understanding

Administration project for ExpenseManagement: Business travel request, approval, advance, expense and settlement.

## Business Goal

Standardize Administration business-travel and expense workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement, with multi-traveler requests.

## Current Outcome

Standardize Administration business-travel and expense workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement, with multi-traveler requests.

## Latest Update

Project registered; business discovery and source confirmation are pending.

## Current Scope

- ExpenseManagement
- Business travel request, approval, advance, expense and settlement

## Current Risks / Blockers

- Needs Confirmation
- Scope, rules, data ownership and acceptance require confirmation.

## Decisions Needed

- Confirm business rules, source of truth and delivery ownership.

## Next Actions

- Validate booking workflow and status model, model multi-traveler requests, and prepare UAT

## Key Dependencies

- ADMIN_EXPENSE-RECAP-UAT-3 (15/09/2026 meeting recap); travel/expense regulations and per-diem rates

## Current Deliverables

- Project profile and plan
- Business and requirements pack appropriate to lifecycle
- Data, process and solution documents where applicable
- Governance logs and operational task board

## Workspace Navigation

### Management

- [[01_Management/Project_Profile]]
- [[01_Management/Project_Plan]]
- [[01_Management/Milestones]]
- [[01_Management/Weekly_Status]]

### Business

- [[02_Business/Business_Context]]
- [[02_Business/BRD]]
- [[02_Business/Scope_and_Business_Rules]]

### Process

- [[03_Process/AS_IS_Process]]
- [[03_Process/TO_BE_Process]]
- [[03_Process/Process_Gaps]]

### Data

- [[04_Data/Data_Spec]]
- [[04_Data/Data_Source_Inventory]]
- [[04_Data/Data_Quality_and_Traceability]]

### Requirements

- [[05_Requirements/Functional_Requirements]]
- [[05_Requirements/Use_Cases]]
- [[05_Requirements/Acceptance_Criteria]]

### Solution

- [[06_Solution/Solution_Overview]]
- [[06_Solution/Integration_Spec]]

### Test / UAT

- [[07_Test_UAT/UAT_Plan]]
- [[07_Test_UAT/UAT_Cases]]
- [[07_Test_UAT/Defect_Log]]

### Implementation

- [[08_Implementation/Implementation_Plan]]
- [[08_Implementation/Deployment_Checklist]]

### Operations

- [[09_Operations/User_Manual]]
- [[09_Operations/Support_and_Maintenance]]

### Governance

- [[10_Governance/Risks_Issues]]
- [[10_Governance/Decision_Log]]
- [[10_Governance/Dependencies]]
- [[10_Governance/Change_Log]]

### Project Board

- [[Project_Executive_Board]]
- [[Tasks]]
- [[Meetings]]
- [[Evidence]]

## Source of Truth

Root Project Note:
[[../ADMIN_ExpenseManagement_v1.1.0]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/ADMIN_ExpenseManagement_v1.1.0.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
