---
type: "project_home"
project: "MER_CostingAgenticPlatform_v1.1.0"
source_project: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
source_event: "PPJ-WEEKLY-20261023-20261030"
last_verified: "2026-10-30"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "Active Development"
current_gate: "Wash/COMIT POC data-contract approval and expert-owned dataset"
priority: "P2"
delivery_stage: "DEVELOPMENT"
status: "Active"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | MER_CostingAgenticPlatform_v1.1.0 |
| Legacy Code(s) | COSTING.AGENTIC.PLATFORM.v1.1; PPJ.COSTING.AGENT.PLATFORM.v1.1 |
| Primary Domain | Merchandising |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DEVELOPMENT |
| Lifecycle | Active Development |
| Status | Active |
| Progress | TBD |
| Current Gate | Wash/COMIT POC data-contract approval and expert-owned dataset |
| Priority | P2 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-10-30 |
| Confidence | Strong |

## Executive Summary

Generate a Costing / Quotation Package for Merchandising review and customer quotation through one platform.

## Current Capability

Garment Requirement -> Operation Breakdown -> Operation Normalization -> Machine Mapping -> SAM -> Cost -> Confidence -> IED / Expert Review; Wash: Requirement -> Attribute Extraction -> Recipe Search -> Process Recommendation -> Cost/Risk -> Wash Expert Review.

## Latest Update

COMIT Wash Image Analysis Requirement v1.1 entered structured POC definition. Scope, responsibilities, data contract, expert review and proposed targets are documented. No trained model or POC result exists yet. Sew Agent has no new confirmed movement.

## Risks / Blockers

- Taxonomy, metadata, annotation rules and expert-owned dataset are not frozen.
- Proposed targets and the expert-review fallback are not approved.
- A requirement document is not evidence of model training, accuracy or a successful POC.

## Decisions Needed

- Approve Wash/COMIT POC scope, dataset ownership, proposed targets and mandatory expert-review fallback.

## Dependencies

- TD_TechnicalKnowledgePlatform_v2.1.0 -> Pattern/BOM/Consumption -> Sew/Wash/Costing AI

## Next Actions

- Freeze the Wash/COMIT taxonomy, metadata, annotation guide and data contract.
- Assign the expert-owned POC dataset and acceptance review gate.
- Keep all model targets labelled proposed until approved and tested.

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[PPJ.COSTING.AGENT.PLATFORM.v1.1/00_Project_Home|Project Home]]
- [[PPJ.COSTING.AGENT.PLATFORM.v1.1/Project_Executive_Board|Project Executive Board]]
- [[PPJ.COSTING.AGENT.PLATFORM.v1.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-10-30
- Source Event: PPJ-WEEKLY-20261023-20261030
- Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Confidence: Strong

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# COSTING.AGENTIC.PLATFORM.v1.1

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | COSTING.AGENTIC.PLATFORM.v1.1 |
| Current File | PPJ.COSTING.AGENT.PLATFORM.v1.1.md |
| Primary Domain | Merchandising |
| Secondary Domains | Technical, Sew, Wash, Fabric, Finance |
| Lifecycle | Development |
| Progress | TBD |
| Current Gate | Sew Costing v1.1 Demo Completed / v1.2 Development |
| Priority | P3 |
| Business Owner | Needs Confirmation |
| Primary Users | Merchandising and Sew experts |
| BA / Coordination | Khoa |
| Technical Members | Lam, Khoa, Uyen, Huy, Linh |
| Last Verified | 2026-08-01 |
| Confidence | Strong |

## One-Line Understanding

Strategic agentic platform for multi-department technical costing and quotation workflows.

## Business Goal

Costing and Quotation Package for Merchandising review and customer quotation proposals.

## Current Outcome

Costing and Quotation Package for Merchandising review and customer quotation proposals.

## Latest Update

Sew Costing v1.1 demo completed, demonstrating description intake, operation extraction, operation-list standardization and an initial SAM/Sew Cost data foundation. v1.2 focuses on SAM accuracy, machine/standard-time mapping, incomplete descriptions, historical similarity, confidence, expert review and GTAS/IED transfer.

## Current Scope

- Agentic platform with BOM, Sew, Wash, Cut, Technical Knowledge, Historical Costing, and Quotation Consolidation agents.

## Current Risks / Blockers

- GTAS/IED data contract and integration format are not confirmed.
- Technical data acceptance remains pending.
- SAM is not final without validated standards and expert review.
- AI suggestion and approved costing must remain separate.

## Decisions Needed

- Approve Sew v1.2 accuracy and acceptance plan.
- Confirm GTAS/IED data contract and expert-approval boundary.

## Next Actions

- Evaluate the v1.1 demo with Sew experts and establish an accuracy baseline.
- Analyze extraction errors and improve SAM calculation.
- Confirm GTAS/IED data contract and API/integration format.
- Connect Technical consumption data.
- Continue the Wash dataset workstream without creating a separate root project.

## Key Dependencies

- TD.TechnicalKnowledge.Platform.v2.1 -> Consumption / Pattern / BOM / Construction / History -> Costing Platform
- AI Suggestion -> Expert-approved Result -> Final GTAS/IED Transfer

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
[[../PPJ.COSTING.AGENT.PLATFORM.v1.1]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/COSTING.AGENTIC.PLATFORM.v1.1.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]

<!-- PPJ_WEEKLY_20261023_20261030_START -->
## Weekly Synchronization Event: PPJ-WEEKLY-20261023-20261030

### Verified movement

COMIT Wash Image Analysis Requirement v1.1 entered structured POC definition. Scope, responsibilities, data contract, expert review and proposed targets are documented. No trained model or POC result exists yet. Sew Agent has no new confirmed movement.

### Current gate

Wash/COMIT POC data-contract approval and expert-owned dataset

### Risks / blockers

- Taxonomy, metadata, annotation rules and expert-owned dataset are not frozen.
- Proposed targets and the expert-review fallback are not approved.
- A requirement document is not evidence of model training, accuracy or a successful POC.

### Decisions required

- Approve Wash/COMIT POC scope, dataset ownership, proposed targets and mandatory expert-review fallback.

### Next actions

- Freeze the Wash/COMIT taxonomy, metadata, annotation guide and data contract.
- Assign the expert-owned POC dataset and acceptance review gate.
- Keep all model targets labelled proposed until approved and tested.

### Traceability

- Report: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261030-PORTFOLIO-GATES]]
- Last verified: 2026-10-30
- Confidence: Strong
<!-- PPJ_WEEKLY_20261023_20261030_END -->
