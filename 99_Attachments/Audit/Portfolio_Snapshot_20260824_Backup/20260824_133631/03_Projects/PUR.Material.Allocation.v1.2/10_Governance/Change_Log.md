---
type: "change_log"
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
| Lifecycle | First Flow Validated |
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

# Change Log

| Date | Change | Source Event | Confidence | Author / Owner |
| --- | --- | --- | --- | --- |
| 2026-08-07 | Project workspace baseline planned/created | PPJ-WEEKLY-20260713-20260718 | Strong | PPJ workspace automation |

## Evidence Basis

- Root project note: [[../PUR.Material.Allocation.v1.2]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PUR.Material.Allocation.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260713-20260718
- Last verified: 2026-07-18
- Confidence: Strong
