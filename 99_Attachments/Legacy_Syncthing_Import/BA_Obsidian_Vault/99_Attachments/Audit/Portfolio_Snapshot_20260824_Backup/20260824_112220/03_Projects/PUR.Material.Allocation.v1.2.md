---
type: project
project_name: "Material Allocation"
cluster: "Automation"
status: "UAT / Stabilization"
priority: "P7"
project_code: "PUR.Material.Allocation.v1.1"
department: "Purchasing / Sourcing"
object: "Inferred from filename"
project_characteristic: "workflow automation"
version: "v1.1"
phase: "UAT / Stabilization"
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
canonical_code: "PUR.Material.Allocation.v1.1"
current_file: "PUR.Material.Allocation.v1.2.md"
primary_domain: "Sourcing / Purchasing"
lifecycle: "First Flow Validated"
current_gate: "Exception, rollback and transaction-safety testing"
last_verified: "2026-08-24"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
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

<!-- PPJ_PROJECT_KNOWLEDGE_END -->
