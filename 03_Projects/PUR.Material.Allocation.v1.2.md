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
phase: "DEVELOPMENT"
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
last_updated: "2026-10-30"
confidence: "Strong"
source_files: []
canonical_code: "PUR_MaterialAllocation_v1.1.0"
current_file: "PUR.Material.Allocation.v1.2.md"
primary_domain: "Sourcing / Purchasing"
lifecycle: "Development"
current_gate: "Confirm API implementation and controlled GET/POST transaction UAT"
last_verified: "2026-10-30"
source_event: "PPJ-WEEKLY-20261023-20261030"
delivery_stage: "DEVELOPMENT"
stage_entered_date: "2026-09-28"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_START -->
## Executive Delivery State

| Field | Current |
|---|---|
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DEVELOPMENT |
| Detailed Lifecycle | Development |
| Status | Active |
| Current Gate | Transaction reliability and exception control |
| Stage Entered | 2026-09-28 |
| Last Verified | 2026-09-28 |
<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_END -->

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

WFX documented GET/POST behaviour and issued the Style/Article API enhancement specification dated 26-28 October, including partial Style/Article search. This is API-definition progress only; deployment and transaction-control testing are not confirmed.

## Risks / Blockers

- Deployment status, performance, concurrency and audit behaviour are unconfirmed.
- Duplicate prevention, rollback, partial allocation and exception controls still require transaction UAT.

## Decisions Needed

- Confirm API deployment ownership and the transaction-control UAT gate.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Confirm the specified API is implemented in the controlled environment.
- Execute controlled GET/POST tests for partial Style/Article search and allocation transactions.
- Validate duplicate prevention, rollback, concurrency, audit and user confirmation.

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

- Date: 2026-10-30
- Source Event: PPJ-WEEKLY-20261023-20261030
- Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Confidence: Strong

<!-- PPJ_PROJECT_KNOWLEDGE_END -->

<!-- PPJ_WEEKLY_20261023_20261030_START -->
## Weekly Synchronization Event: PPJ-WEEKLY-20261023-20261030

### Verified movement

WFX documented GET/POST behaviour and issued the Style/Article API enhancement specification dated 26-28 October, including partial Style/Article search. This is API-definition progress only; deployment and transaction-control testing are not confirmed.

### Current gate

Confirm API implementation and controlled GET/POST transaction UAT

### Risks / blockers

- Deployment status, performance, concurrency and audit behaviour are unconfirmed.
- Duplicate prevention, rollback, partial allocation and exception controls still require transaction UAT.

### Decisions required

- Confirm API deployment ownership and the transaction-control UAT gate.

### Next actions

- Confirm the specified API is implemented in the controlled environment.
- Execute controlled GET/POST tests for partial Style/Article search and allocation transactions.
- Validate duplicate prevention, rollback, concurrency, audit and user confirmation.

### Traceability

- Report: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261030-PORTFOLIO-GATES]]
- Last verified: 2026-10-30
- Confidence: Strong
<!-- PPJ_WEEKLY_20261023_20261030_END -->
