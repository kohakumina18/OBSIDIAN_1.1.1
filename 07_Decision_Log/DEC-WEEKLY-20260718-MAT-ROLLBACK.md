---
type: decision
id: "DEC-WEEKLY-20260718-MAT-ROLLBACK"
date: "2026-07-18"
project: "PUR.Material.Allocation.v1.1"
status: "Pending"
owner: "Purchasing / WFX Owner"
source_event: "PPJ-WEEKLY-20260713-20260718"
---

# Material Allocation rollback and audit model

## Decision Required

Confirm transaction rollback design.
- Confirm auditability and user confirmation before posting.
- Confirm whether additional material categories enter scope.

## Context

The first business flow was successfully tested: Source OC with Surplus -> Validate Surplus -> Unreserve -> Find Destination OC -> Validate Style and Buyer Reference -> Allocate -> Verify Result. Destination OCs are split OCs with the same Style and Buyer Reference.

## Evidence

User-approved weekly portfolio report 2026-07-13 to 2026-07-18

## Next Step

Test many-to-one, one-to-many, partial allocation, insufficient quantity, Buyer Reference mismatch and duplicate allocation.
