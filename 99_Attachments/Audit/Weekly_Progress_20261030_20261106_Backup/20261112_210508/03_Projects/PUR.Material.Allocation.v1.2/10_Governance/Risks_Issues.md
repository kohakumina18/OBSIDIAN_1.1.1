---
type: "risks_issues"
project: "PUR.Material.Allocation.v1.1"
source_project: "PUR.Material.Allocation.v1.2.md"
source_event: "PPJ-WEEKLY-20261030-20261106"
last_verified: "2026-11-06"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
current_gate: "Controlled WFX dry-run and Save testing"
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

# Risks and Issues

| ID | Risk / Issue | Impact | Owner | Status | Source |
| --- | --- | --- | --- | --- | --- |
| RISK-001 | Only Sewing and Embroidery scope is confirmed. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260713-20260718 |
| RISK-002 | Quantity may change during transaction execution. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260713-20260718 |
| RISK-003 | Rollback is undefined when unreserve succeeds but allocation fails. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260713-20260718 |

## Evidence Basis

- Root project note: [[../PUR.Material.Allocation.v1.2]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PUR.Material.Allocation.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260713-20260718
- Last verified: 2026-07-18
- Confidence: Strong

<!-- PPJ_WEEKLY_20261023_20261030_RISKS_START -->
## Weekly Risk Update - 2026-10-30

- Deployment status, performance, concurrency and audit behaviour are unconfirmed.
- Duplicate prevention, rollback, partial allocation and exception controls still require transaction UAT.

Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]] (PPJ-WEEKLY-20261023-20261030)
<!-- PPJ_WEEKLY_20261023_20261030_RISKS_END -->

<!-- PPJ_WEEKLY_20261030_20261106_RISKS_START -->
## Weekly Risk Update - 2026-11-06

- Real WFX transaction behaviour and Save safety are not confirmed.
- Duplicate, concurrency, cross-division, partial-allocation and rerun rules remain open.
- Emergency-stop, rollback, audit and recovery controls require controlled evidence.

Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261106]] (PPJ-WEEKLY-20261030-20261106)
<!-- PPJ_WEEKLY_20261030_20261106_RISKS_END -->
