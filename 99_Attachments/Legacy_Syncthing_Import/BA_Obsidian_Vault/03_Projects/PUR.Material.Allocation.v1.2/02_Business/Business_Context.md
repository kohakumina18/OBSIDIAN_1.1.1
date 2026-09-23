---
type: "business_context"
project: "PUR.Material.Allocation.v1.1"
source_project: "PUR.Material.Allocation.v1.2.md"
source_event: "PPJ-WEEKLY-20260713-20260718"
last_verified: "2026-07-18"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Business Context

## Business Meaning

Purchasing material allocation/transfer/borrow workflow with WFX dependency and validation before save/post.

## Business Goal

Validated unreserve, destination-OC matching and allocation flow with controlled UAT foundation

## Primary Domain and Users

- Primary domain: Sourcing / Purchasing
- Primary users: Purchasing / Khoa / Uyen / Nam / Phat
- Business owner: Needs Confirmation

## Current Context

The first business flow was successfully tested: Source OC with Surplus -> Validate Surplus -> Unreserve -> Find Destination OC -> Validate Style and Buyer Reference -> Allocate -> Verify Result. Destination OCs are split OCs with the same Style and Buyer Reference.

## Current Scope

- Semi-automation/automation for material allocation, transfer, or borrow between OC/style/order.

## Known Boundaries

- Not production-ready until WFX logic, user review, and test data are confirmed.

## Discovery Gaps

- Confirm unresolved ownership, current process, source of truth and measurable outcome.
- Retain TBD or Needs Confirmation where evidence is unavailable.

## Evidence Basis

- Root project note: [[../PUR.Material.Allocation.v1.2]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PUR.Material.Allocation.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260713-20260718
- Last verified: 2026-07-18
- Confidence: Strong
