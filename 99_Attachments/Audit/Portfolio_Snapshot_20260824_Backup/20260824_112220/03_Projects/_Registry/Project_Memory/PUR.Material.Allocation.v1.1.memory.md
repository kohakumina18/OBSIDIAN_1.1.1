---
type: project_memory
project_name: "PUR.Material.Allocation.v1.1"
project_file: "PUR.Material.Allocation.v1.1.md"
project_code: "PUR.Material.Allocation.v1.1"
department: "Purchasing"
cluster: "Purchasing Workflow"
phase: "UAT / Stabilization"
technical_members: ["Uyen", "Khoa"]
progress: "TBD"
last_verified: "2026-08-24"
confidence: "Strong"
canonical_code: "PUR.Material.Allocation.v1.1"
current_file: "PUR.Material.Allocation.v1.2.md"
primary_domain: "Sourcing / Purchasing"
primary_capability: "Purchasing transaction: allocation, validation, review"
secondary_domains: "WFX, Inventory, Production"
lifecycle: "First Flow Validated"
current_gate: "Exception, rollback and transaction-safety testing"
status: "UAT / Stabilization"
current_outcome: "Validate controlled reallocation of surplus NPL across eligible OCs."
latest_update_summary: "The first Sewing/Embroidery flow was validated: surplus OC -> unreserve -> find same Style/Buyer Reference OC -> allocate. General automation is not fully validated."
known_risks: "Partial-allocation correctness | Rollback and duplicate safety | WFX transaction consistency"
decisions_needed: "None recorded"
next_actions: "Test multiple OCs and partial allocation | Test insufficient stock, duplicates and failure paths | Validate rollback, audit and user confirmation"
priority: "P7"
recent_update_events: ["PPJ-WEEKLY-20260713-20260718"]
workspace_path: "03_Projects/PUR.Material.Allocation.v1.2"
project_home: "03_Projects/PUR.Material.Allocation.v1.2/00_Project_Home.md"
project_board: "03_Projects/PUR.Material.Allocation.v1.2/Project_Executive_Board.canvas"
task_folder: "03_Projects/PUR.Material.Allocation.v1.2/Tasks"
documentation_status: "Workspace Created"
dependencies: "None recorded"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | PUR.Material.Allocation.v1.1 |
| Primary Domain | Sourcing / Purchasing |
| Lifecycle | First Flow Validated |
| Progress | TBD |
| Current Gate | Exception, rollback and transaction-safety testing |
| Priority | P7 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Validate controlled reallocation of surplus NPL across eligible OCs.

## Current Capability

Validated for Sewing and Embroidery; broader material scope remains unconfirmed.

## Latest Update

The first Sewing/Embroidery flow was validated: surplus OC -> unreserve -> find same Style/Buyer Reference OC -> allocate. General automation is not fully validated.

## Risks / Blockers

- Partial-allocation correctness
- Rollback and duplicate safety
- WFX transaction consistency

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Test multiple OCs and partial allocation
- Test insufficient stock, duplicates and failure paths
- Validate rollback, audit and user confirmation

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[PUR.Material.Allocation.v1.2/00_Project_Home|Project Home]]
- [[PUR.Material.Allocation.v1.2/Project_Executive_Board|Project Executive Board]]
- [[PUR.Material.Allocation.v1.2/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
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
