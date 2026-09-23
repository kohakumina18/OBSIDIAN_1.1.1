---
type: "project_profile"
project: "TD.TechnicalKnowledge.Platform.v2.1"
source_project: "TD.TechnicalPlatform_v2.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-08-24

| Field | Value |
| --- | --- |
| Canonical Code | TD.TechnicalKnowledge.Platform.v2.1 |
| Domain | Fabric / Textiles Technique |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Initial Sync Demo Completed / Sync Validation & Stabilization |
| Status | Active |
| Progress | TBD |
| Gate | Incremental sync hardening and Technical UAT |
| Priority | P5 |
| Outcome | Technical Data Backbone for Pattern, BOM, Consumption, Construction, documents and historical records. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260824 |

### Latest Update

Source collection, ETL, Technical Data Layer and the initial syncing-flow demo are complete; the project is now validating and stabilizing synchronization.

### Current Risks

- Sync reliability
- Version governance
- Missing keys and duplicate records
- Technical UAT acceptance

### Dependencies

- Technical sources -> ETL -> Technical Data Layer -> Sync -> Platform -> Costing / Pattern / Wash / Search

### Next Actions

- Implement incremental sync, error handling and retry
- Add duplicate, missing-key and reconciliation checks
- Govern versions and latest/approved-record logic
- Finalize permissions and prepare Technical UAT
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Profile

## Identity

| Field | Value |
| --- | --- |
| Canonical Code | TD.TechnicalKnowledge.Platform.v2.1 |
| Physical Project Note | TD.TechnicalPlatform_v2.1.md |
| Primary Domain | Fabric / Textiles Technique |
| Cluster | Technical Knowledge / Training |
| Lifecycle Class | A. Active / Delivery |
| Lifecycle | Development / Data Validation |
| Current Gate | ETL Completed / Data Foundation Available / Data Acceptance Pending |
| Priority | TBD |
| Business Owner | Needs Confirmation |

## One-Line Understanding

Technical knowledge platform for buyer reference, pattern, BOM, costing history, videos, and training material.

## Intended Outcome

Technical data and knowledge foundation for search, retrieval, Pattern, BOM, construction, consumption, historical cases, Costing and future domain AI.

## Users and Delivery Participants

- Primary users: Technical team
- BA / Coordination: Khoa
- Technical members: Huy, Khoa, Huy, Khoa

## Current Scope

- Knowledge/search/training platform for Technical Department data.

## Explicit Boundaries

- Not automatically identical to CPD Datamart or Costing Platform; it supports them as a data node.

## Current Gate and Next Move

- Gate: ETL Completed / Data Foundation Available / Data Acceptance Pending
- Next actions: Measure ETL coverage and reconcile with source systems.; Detect duplicates and missing keys.; Confirm record version and approved/latest version logic.; Build search/retrieval and permission layers.; Connect consumption data to Costing and prepare Technical-user UAT.

## Evidence Basis

- Root project note: [[../TD.TechnicalPlatform_v2.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/TD.TechnicalKnowledge.Platform.v2.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
