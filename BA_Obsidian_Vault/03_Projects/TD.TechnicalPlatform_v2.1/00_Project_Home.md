---
type: "project_home"
project: "TD.TechnicalKnowledge.Platform.v2.1"
source_project: "TD.TechnicalPlatform_v2.1.md"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
last_verified: "2026-08-24"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "Initial Sync Demo Completed / Sync Validation & Stabilization"
current_gate: "Incremental sync hardening and Technical UAT"
priority: "P5"
delivery_stage: "UAT / PRE-GO-LIVE"
status: "Active"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | TD.TechnicalKnowledge.Platform.v2.1 |
| Primary Domain | Fabric / Textiles Technique |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Initial Sync Demo Completed / Sync Validation & Stabilization |
| Status | Active |
| Progress | TBD |
| Current Gate | Incremental sync hardening and Technical UAT |
| Priority | P5 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Technical Data Backbone for Pattern, BOM, Consumption, Construction, documents and historical records.

## Current Capability

Source -> ETL -> Technical Data Layer -> Sync -> Technical Knowledge Platform.

## Latest Update

Source collection, ETL, Technical Data Layer and the initial syncing-flow demo are complete; the project is now validating and stabilizing synchronization.

## Risks / Blockers

- Sync reliability
- Version governance
- Missing keys and duplicate records
- Technical UAT acceptance

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- Technical sources -> ETL -> Technical Data Layer -> Sync -> Platform -> Costing / Pattern / Wash / Search

## Next Actions

- Implement incremental sync, error handling and retry
- Add duplicate, missing-key and reconciliation checks
- Govern versions and latest/approved-record logic
- Finalize permissions and prepare Technical UAT

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[TD.TechnicalPlatform_v2.1/00_Project_Home|Project Home]]
- [[TD.TechnicalPlatform_v2.1/Project_Executive_Board|Project Executive Board]]
- [[TD.TechnicalPlatform_v2.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# TD.TechnicalKnowledge.Platform.v2.1

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | TD.TechnicalKnowledge.Platform.v2.1 |
| Current File | TD.TechnicalPlatform_v2.1.md |
| Primary Domain | Fabric / Textiles Technique |
| Secondary Domains | Merchandising, Costing, Training |
| Lifecycle | Development / Data Validation |
| Progress | ETL completed for currently identified v2.1 sources |
| Current Gate | ETL Completed / Data Foundation Available / Data Acceptance Pending |
| Priority | TBD |
| Business Owner | Needs Confirmation |
| Primary Users | Technical team |
| BA / Coordination | Khoa |
| Technical Members | Huy, Khoa, Huy, Khoa |
| Last Verified | 2026-08-01 |
| Confidence | Strong |

## One-Line Understanding

Technical knowledge platform for buyer reference, pattern, BOM, costing history, videos, and training material.

## Business Goal

Technical data and knowledge foundation for search, retrieval, Pattern, BOM, construction, consumption, historical cases, Costing and future domain AI.

## Current Outcome

Technical data and knowledge foundation for search, retrieval, Pattern, BOM, construction, consumption, historical cases, Costing and future domain AI.

## Latest Update

ETL completed for the Technical sources currently identified in v2.1 scope. Data was extracted, transformed, initially standardized, loaded into the Technical Platform data layer and organized for future search, retrieval and AI capability.

## Current Scope

- Knowledge/search/training platform for Technical Department data.

## Current Risks / Blockers

- Technical-user acceptance is pending.
- Completeness, freshness, approved-version logic, lineage and permissions are not fully confirmed.
- ETL completion does not mean production-ready data.
- Duplicate records, missing keys or wrong versions could affect Costing outputs.

## Decisions Needed

- Approve Technical data completeness, accuracy and version logic.
- Confirm data owner, lineage and permission model.

## Next Actions

- Measure ETL coverage and reconcile with source systems.
- Detect duplicates and missing keys.
- Confirm record version and approved/latest version logic.
- Build search/retrieval and permission layers.
- Connect consumption data to Costing and prepare Technical-user UAT.

## Key Dependencies

- Technical Platform ETL -> Pattern / BOM / Consumption / Construction -> Sew and Consumption Costing -> Costing Package

## Current Deliverables

- Project profile and plan
- Business and requirements pack appropriate to lifecycle
- Data, process and solution documents where applicable
- Governance logs and operational task board

## Workspace Navigation

### Management

- [[01_Management/Project_Profile]]
- [[01_Management/Project_Plan]]
- [[01_Management/Milestones]]
- [[01_Management/Weekly_Status]]

### Business

- [[02_Business/Business_Context]]
- [[02_Business/BRD]]
- [[02_Business/Scope_and_Business_Rules]]

### Process

- [[03_Process/AS_IS_Process]]
- [[03_Process/TO_BE_Process]]
- [[03_Process/Process_Gaps]]

### Data

- [[04_Data/Data_Spec]]
- [[04_Data/Data_Source_Inventory]]
- [[04_Data/Data_Quality_and_Traceability]]

### Requirements

- [[05_Requirements/Functional_Requirements]]
- [[05_Requirements/Use_Cases]]
- [[05_Requirements/Acceptance_Criteria]]

### Solution

- [[06_Solution/Solution_Overview]]
- [[06_Solution/Integration_Spec]]

### Test / UAT

- [[07_Test_UAT/UAT_Plan]]
- [[07_Test_UAT/UAT_Cases]]
- [[07_Test_UAT/Defect_Log]]

### Implementation

- [[08_Implementation/Implementation_Plan]]
- [[08_Implementation/Deployment_Checklist]]

### Operations

- [[09_Operations/User_Manual]]
- [[09_Operations/Support_and_Maintenance]]

### Governance

- [[10_Governance/Risks_Issues]]
- [[10_Governance/Decision_Log]]
- [[10_Governance/Dependencies]]
- [[10_Governance/Change_Log]]

### Project Board

- [[Project_Executive_Board]]
- [[Tasks]]
- [[Meetings]]
- [[Evidence]]

## Source of Truth

Root Project Note:
[[../TD.TechnicalPlatform_v2.1]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/TD.TechnicalKnowledge.Platform.v2.1.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
