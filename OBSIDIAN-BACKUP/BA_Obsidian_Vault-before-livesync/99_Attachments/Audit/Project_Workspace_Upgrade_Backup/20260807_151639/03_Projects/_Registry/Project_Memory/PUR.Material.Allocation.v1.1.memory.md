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
last_verified: "2026-07-18"
confidence: "Strong"
canonical_code: "PUR.Material.Allocation.v1.1"
current_file: "PUR.Material.Allocation.v1.1.md"
primary_domain: "Sourcing / Purchasing"
primary_capability: "Purchasing transaction: allocation, validation, review"
secondary_domains: "WFX, Inventory, Production"
lifecycle: "UAT / Stabilization"
current_gate: "First Flow Validated / Extended Exception Testing"
status: "UAT / Stabilization"
current_outcome: "Validated unreserve, destination-OC matching and allocation flow with controlled UAT foundation"
latest_update_summary: "The first business flow was successfully tested: Source OC with Surplus -> Validate Surplus -> Unreserve -> Find Destination OC -> Validate Style and Buyer Reference -> Allocate -> Verify Result. Destination OCs are split OCs with the same Style and Buyer Reference."
known_risks: "Only Sewing and Embroidery scope is confirmed. | Quantity may change during transaction execution. | Rollback is undefined when unreserve succeeds but allocation fails."
decisions_needed: "Confirm transaction rollback design. | Confirm auditability and user confirmation before posting. | Confirm whether additional material categories enter scope."
next_actions: "Test many-to-one, one-to-many, partial allocation, insufficient quantity, Buyer Reference mismatch and duplicate allocation. | Test transaction failure/retry and define rollback. | Define audit log and user review before posting. | Prepare UAT with Ms. Tuyet and Precision users."
priority: "P5"
recent_update_events: ["PPJ-WEEKLY-20260713-20260718"]
---

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



