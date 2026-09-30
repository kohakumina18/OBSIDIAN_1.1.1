---
type: "milestones"
project: "PUR.Material.Allocation.v1.1"
source_project: "PUR.Material.Allocation.v1.2.md"
source_event: "PPJ-WEEKLY-20260713-20260718"
last_verified: "2026-07-18"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-09-18

| Field | Value |
| --- | --- |
| Canonical Code | PUR_MaterialAllocation_v1.1.0 |
| Domain | Sourcing / Purchasing |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Validation / Stabilization |
| Status | Active |
| Progress | TBD |
| Gate | Transaction reliability and exception control |
| Priority | P7 |
| Outcome | Validate controlled reallocation of surplus material across eligible OCs: Material Requirement -> Availability -> Allocation -> Validation -> WFX Transaction. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

Validation / stabilization. The first Sewing/Embroidery flow was validated (surplus OC -> unreserve -> find same Style/Buyer Reference OC -> allocate); general automation is not fully validated. Current work focuses on duplicate prevention, allocation conflict, exception paths, rollback, transaction confirmation and audit trail.

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

# Milestones

| Milestone | State | Evidence / Exit Condition | Owner | Target |
| --- | --- | --- | --- | --- |
| Current Gate: First Flow Validated / Extended Exception Testing | Current | Gate evidence reviewed | Needs Confirmation | TBD |
| Next Approved Outcome | Planned | Validated unreserve, destination-OC matching and allocation flow with controlled UAT foundation | Needs Confirmation | TBD |
| Operational Handover or Closeout | Not Started | Acceptance, ownership and support confirmed | Needs Confirmation | TBD |

## Notes

Milestone dates remain TBD until confirmed by the responsible owner.

## Evidence Basis

- Root project note: [[../PUR.Material.Allocation.v1.2]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PUR.Material.Allocation.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260713-20260718
- Last verified: 2026-07-18
- Confidence: Strong
