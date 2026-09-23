---
type: "weekly_status"
project: "PUR.Material.Allocation.v1.1"
source_project: "PUR.Material.Allocation.v1.2.md"
source_event: "PPJ-WEEKLY-20260713-20260718"
last_verified: "2026-07-18"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-08-24

| Field | Value |
| --- | --- |
| Canonical Code | PUR.Material.Allocation.v1.1 |
| Domain | Sourcing / Purchasing |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | First Flow Validated |
| Status | Active |
| Progress | TBD |
| Gate | Exception, rollback and transaction-safety testing |
| Priority | P7 |
| Outcome | Validate controlled reallocation of surplus NPL across eligible OCs. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260824 |

### Latest Update

The first Sewing/Embroidery flow was validated: surplus OC -> unreserve -> find same Style/Buyer Reference OC -> allocate. General automation is not fully validated.

### Current Risks

- Partial-allocation correctness
- Rollback and duplicate safety
- WFX transaction consistency

### Dependencies

- None recorded in the current portfolio snapshot.

### Next Actions

- Test multiple OCs and partial allocation
- Test insufficient stock, duplicates and failure paths
- Validate rollback, audit and user confirmation
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Weekly Status

## Current Snapshot

- Lifecycle: UAT / Stabilization
- Progress: 50%
- Gate: First Flow Validated / Extended Exception Testing
- Priority: TBD

## Latest Verified Update

The first business flow was successfully tested: Source OC with Surplus -> Validate Surplus -> Unreserve -> Find Destination OC -> Validate Style and Buyer Reference -> Allocate -> Verify Result. Destination OCs are split OCs with the same Style and Buyer Reference.

## Current Blockers

- Needs Confirmation

## Decisions Needed

- Confirm transaction rollback design.
- Confirm auditability and user confirmation before posting.
- Confirm whether additional material categories enter scope.

## Next Actions

- Test many-to-one, one-to-many, partial allocation, insufficient quantity, Buyer Reference mismatch and duplicate allocation.
- Test transaction failure/retry and define rollback.
- Define audit log and user review before posting.
- Prepare UAT with Ms. Tuyet and Precision users.

## Update Protocol

Weekly updates should change only affected project memory, home, tasks, risks, decisions and relevant working documents.

## Evidence Basis

- Root project note: [[../PUR.Material.Allocation.v1.2]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PUR.Material.Allocation.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260713-20260718
- Last verified: 2026-07-18
- Confidence: Strong
