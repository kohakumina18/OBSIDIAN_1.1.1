---
type: project
project_name: "Material Allocation"
cluster: "Automation"
status: "Active"
priority: "P7"
project_code: "PUR_MaterialAllocation_v1.1.0"
department: "Purchasing / Sourcing"
object: "Inferred from filename"
project_characteristic: "workflow automation"
version: "v1.1"
phase: "UAT / PRE-GO-LIVE"
owner: "TBD"
business_owner: "TBD"
technical_owner: "TBD"
members: []
stakeholders: []
systems: []
data_sources: []
progress: "TBD"
blocked: "TBD"
decision_needed: "TBD"
next_action: "TBD"
last_updated: "2026-06-28"
confidence: "Strong"
source_files: []
canonical_code: "PUR_MaterialAllocation_v1.1.0"
current_file: "PUR.Material.Allocation.v1.2.md"
primary_domain: "Sourcing / Purchasing"
lifecycle: "Validation / Stabilization"
current_gate: "Transaction reliability and exception control"
last_verified: "2026-09-18"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
delivery_stage: "UAT / PRE-GO-LIVE"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

# Material Allocation


---

## Project Resource Governance

BA / Coordination:
Khoa, Uyên

Technical Members:
Nam, Phát

Business Stakeholder / Department:
Purchasing

Portfolio Group:
Purchasing / MER Workflow

Priority:
P1 Next Week

Phase:
BLOCKED

Progress:
DEPENDENCY]] / TBD

Blocker:
Blocked"

Decision Needed:
TBD

Next Action:

- Confirm timeline with WFX owner

Workload Risk:
High - WFX dependency

Source:
[[PPJ_PROJECT_RESOURCE_MATRIX]]

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

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

Validation / stabilization. The first Sewing/Embroidery flow was validated (surplus OC -> unreserve -> find same Style/Buyer Reference OC -> allocate); general automation is not fully validated. Current work focuses on duplicate prevention, allocation conflict, exception paths, rollback, transaction confirmation and audit trail.

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
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[PUR.Material.Allocation.v1.2/00_Project_Home|Project Home]]
- [[PUR.Material.Allocation.v1.2/Project_Executive_Board|Project Executive Board]]
- [[PUR.Material.Allocation.v1.2/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong

<!-- PPJ_PROJECT_KNOWLEDGE_END -->
