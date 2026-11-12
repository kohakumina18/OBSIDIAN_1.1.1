---
type: project_memory
project_name: "PUR.Material.Allocation.v1.1"
project_file: "PUR.Material.Allocation.v1.1.md"
project_code: "PUR_MaterialAllocation_v1.1.0"
department: "Purchasing"
cluster: "Purchasing Workflow"
phase: "DEVELOPMENT"
technical_members: ["Uyen", "Khoa"]
progress: "TBD"
last_verified: "2026-11-06"
confidence: "Strong"
canonical_code: "PUR_MaterialAllocation_v1.1.0"
current_file: "PUR.Material.Allocation.v1.2.md"
primary_domain: "Sourcing / Purchasing"
primary_capability: "Purchasing transaction: allocation, validation, review"
secondary_domains: "WFX, Inventory, Production"
lifecycle: "Development"
current_gate: "Controlled WFX dry-run and Save testing"
status: "Active"
current_outcome: "Validate controlled reallocation of surplus material across eligible OCs: Material Requirement -> Availability -> Allocation -> Validation -> WFX Transaction."
latest_update_summary: "The controlled-flow build is documented with preview, dry run, fingerprints, audit history, emergency stop and rerun controls. This is documentation and build-control progress, not evidence of successful real WFX transactions. Business rules and controlled Save testing remain open."
known_risks: "Partial-allocation correctness | Rollback and duplicate safety | WFX transaction consistency"
decisions_needed: "None recorded"
next_actions: "Execute preview and dry-run tests against controlled WFX data. | Execute controlled Save tests covering duplicates, concurrency, cross-division cases, partial allocation and emergency stop. | Record fingerprints, audit history, rollback and rerun evidence."
priority: "P7"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260918"]
workspace_path: "03_Projects/PUR.Material.Allocation.v1.2"
project_home: "03_Projects/PUR.Material.Allocation.v1.2/00_Project_Home.md"
project_board: "03_Projects/PUR.Material.Allocation.v1.2/Project_Executive_Board.canvas"
task_folder: "03_Projects/PUR.Material.Allocation.v1.2/Tasks"
documentation_status: "Workspace Created"
dependencies: "None recorded"
source_event: "PPJ-WEEKLY-20261030-20261106"
known_blockers: "Partial-allocation correctness | Rollback and duplicate safety | WFX transaction consistency"
delivery_stage: "DEVELOPMENT"
stage_entered_date: "2026-09-28"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_START -->
## Executive Delivery State

| Field | Current |
|---|---|
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DEVELOPMENT |
| Detailed Lifecycle | Development |
| Status | Active |
| Current Gate | Transaction reliability and exception control |
| Stage Entered | 2026-09-28 |
| Last Verified | 2026-09-28 |
<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_END -->

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | PUR_MaterialAllocation_v1.1.0 |
| Legacy Code(s) | PUR.Material.Allocation.v1.1; PUR.Material.Allocation.v1.2; Material Allocation |
| Primary Domain | Sourcing / Purchasing |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Validation / Stabilization |
| Status | Active |
| Progress | TBD |
| Current Gate | Transaction reliability and exception control |
| Priority | P7 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

Validate controlled reallocation of surplus material across eligible OCs: Material Requirement -> Availability -> Allocation -> Validation -> WFX Transaction.

## Current Capability

Validated for Sewing and Embroidery; broader material scope remains unconfirmed.

## Latest Update

The controlled-flow build is documented with preview, dry run, fingerprints, audit history, emergency stop and rerun controls. This is documentation and build-control progress, not evidence of successful real WFX transactions. Business rules and controlled Save testing remain open.

## Risks / Blockers

- Real WFX transaction behaviour and Save safety are not confirmed.
- Duplicate, concurrency, cross-division, partial-allocation and rerun rules remain open.
- Emergency-stop, rollback, audit and recovery controls require controlled evidence.

## Decisions Needed

- Approve Material Allocation business rules and the transaction-control UAT gate.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Execute preview and dry-run tests against controlled WFX data.
- Execute controlled Save tests covering duplicates, concurrency, cross-division cases, partial allocation and emergency stop.
- Record fingerprints, audit history, rollback and rerun evidence.

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[PUR.Material.Allocation.v1.2/00_Project_Home|Project Home]]
- [[PUR.Material.Allocation.v1.2/Project_Executive_Board|Project Executive Board]]
- [[PUR.Material.Allocation.v1.2/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-11-06
- Source Event: PPJ-WEEKLY-20261030-20261106
- Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261106]]
- Confidence: Strong

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Memory: PUR.Material.Allocation.v1.1

## One-Line Understanding

Purchasing material allocation/transfer/borrow workflow with WFX dependency and validation before save/post.

## Current Outcome

Support allocation decisions and reduce manual WFX handling after real test data and rules are confirmed.

## Latest Update Summary

Team is requesting test data from Precision team and working with chi Tuyet; users are busy so data is incomplete.

## What This Project Is

Semi-automation/automation for material allocation, transfer, or borrow between OC/style/order.

## What This Project Is Not

Not production-ready until WFX logic, user review, and test data are confirmed.

## Key Users

Purchasing/business users and Precision-related stakeholders.

## Systems / Data

WFX, allocation data, transfer/borrow cases, validation rules.

## Known Risks / Blockers

Missing real test data, busy business users, WFX dependency, unclear business rules.

## Next Actions

Get real test data and define validation/user review flow.

## Do Not Drift Rules

- Keep WFX dependency visible.
- Do not mark production while test data and rules are incomplete.

## Source Links

-[[PUR.Material.Allocation.v1.2]]]
- [[PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY]]

<!-- PPJ_DOMAIN_GOVERNANCE_START -->
## Domain Governance

- Canonical Code: PUR.Material.Allocation.v1.1
- Current File:[[PUR.Material.Allocation.v1.2]]]
- Primary Domain: Sourcing / Purchasing
- Secondary Domains: WFX, Inventory, Production
- Lifecycle: Development
- Progress: 50%
- Current Gate: Blocked by WFX dependency

## Domain Do Not Drift Rules
- Keep WFX dependency visible.
<!-- PPJ_DOMAIN_GOVERNANCE_END -->

## Recent Update Events

| Date | Update Type | Summary | Source | Confidence |
| --- | --- | --- | --- | --- |
| 2026-07-18 | Weekly Portfolio Update | The first business flow was successfully tested: Source OC with Surplus -> Validate Surplus -> Unreserve -> Find Destination OC -> Validate Style and Buyer Reference -> Allocate -> Verify Result. Destination OCs are split OCs with the same Style and Buyer Reference. | PPJ-WEEKLY-20260713-20260718 | Strong |

<!-- PPJ_WEEKLY_20261023_20261030_START -->
## Weekly Synchronization Event: PPJ-WEEKLY-20261023-20261030

### Verified movement

WFX documented GET/POST behaviour and issued the Style/Article API enhancement specification dated 26-28 October, including partial Style/Article search. This is API-definition progress only; deployment and transaction-control testing are not confirmed.

### Current gate

Confirm API implementation and controlled GET/POST transaction UAT

### Risks / blockers

- Deployment status, performance, concurrency and audit behaviour are unconfirmed.
- Duplicate prevention, rollback, partial allocation and exception controls still require transaction UAT.

### Decisions required

- Confirm API deployment ownership and the transaction-control UAT gate.

### Next actions

- Confirm the specified API is implemented in the controlled environment.
- Execute controlled GET/POST tests for partial Style/Article search and allocation transactions.
- Validate duplicate prevention, rollback, concurrency, audit and user confirmation.

### Traceability

- Report: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261030-PORTFOLIO-GATES]]
- Last verified: 2026-10-30
- Confidence: Strong
<!-- PPJ_WEEKLY_20261023_20261030_END -->

<!-- PPJ_WEEKLY_20261030_20261106_START -->
## Weekly Synchronization Event: PPJ-WEEKLY-20261030-20261106

### Verified movement

The controlled-flow build is documented with preview, dry run, fingerprints, audit history, emergency stop and rerun controls. This is documentation and build-control progress, not evidence of successful real WFX transactions. Business rules and controlled Save testing remain open.

### Current gate

Controlled WFX dry-run and Save testing

### Risks / blockers

- Real WFX transaction behaviour and Save safety are not confirmed.
- Duplicate, concurrency, cross-division, partial-allocation and rerun rules remain open.
- Emergency-stop, rollback, audit and recovery controls require controlled evidence.

### Decisions required

- Approve Material Allocation business rules and the transaction-control UAT gate.

### Next actions

- Execute preview and dry-run tests against controlled WFX data.
- Execute controlled Save tests covering duplicates, concurrency, cross-division cases, partial allocation and emergency stop.
- Record fingerprints, audit history, rollback and rerun evidence.

### Traceability

- Report: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261106]]
- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261106-PORTFOLIO-GATES]]
- Last verified: 2026-11-06
- Confidence: Strong
<!-- PPJ_WEEKLY_20261030_20261106_END -->
