---
type: project_memory
project_name: "COSTING.AGENTIC.PLATFORM.v1.1"
project_file: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
project_code: "MER_CostingAgenticPlatform_v1.1.0"
department: "MER"
cluster: "Costing Agentic Platform"
phase: "DEVELOPMENT"
technical_members: ["Lam", "Khoa", "Uyen"]
last_verified: "2026-10-30"
confidence: "Strong"
canonical_code: "MER_CostingAgenticPlatform_v1.1.0"
current_file: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
primary_domain: "Merchandising"
primary_capability: "Costing, quotation, market intelligence, customer workflows"
secondary_domains: "Technical, Sew, Wash, Fabric, Finance"
lifecycle: "Active Development"
progress: "TBD"
current_gate: "Wash/COMIT POC data-contract approval and expert-owned dataset"
status: "Active"
current_outcome: "Generate a Costing / Quotation Package for Merchandising review and customer quotation through one platform."
latest_update_summary: "COMIT Wash Image Analysis Requirement v1.1 entered structured POC definition. Scope, responsibilities, data contract, expert review and proposed targets are documented. No trained model or POC result exists yet. Sew Agent has no new confirmed movement."
known_risks: "SAM accuracy and expert acceptance | GTAS/IED integration contract | Technical Data dependency"
decisions_needed: "None recorded"
next_actions: "Freeze the Wash/COMIT taxonomy, metadata, annotation guide and data contract. | Assign the expert-owned POC dataset and acceptance review gate. | Keep all model targets labelled proposed until approved and tested."
priority: "P2"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260918"]
secondary_workstream_gate: "Wash Discovery / Dataset Preparation"
known_blockers: "SAM accuracy and expert acceptance | GTAS/IED integration contract | Technical Data dependency"
dependencies: "TD_TechnicalKnowledgePlatform_v2.1.0 -> Pattern/BOM/Consumption -> Sew/Wash/Costing AI"
workspace_path: "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1"
project_home: "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1/00_Project_Home.md"
project_board: "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1/Project_Executive_Board.canvas"
task_folder: "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-WEEKLY-20261023-20261030"
delivery_stage: "DEVELOPMENT"
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

# Project Memory: COSTING.AGENTIC.PLATFORM.v1.1

## One-Line Understanding

Strategic agentic platform for multi-department technical costing and quotation workflows.

## Current Outcome

Route customer requests through costing/technical agents and consolidate results for MER review.

## Latest Update Summary

Canonical project now absorbs Costing Intelligence, MER Costing, Merchandising Intelligence, Costing Chatbot aliases.

## What This Project Is

Agentic platform with BOM, Sew, Wash, Cut, Technical Knowledge, Historical Costing, and Quotation Consolidation agents.

## What This Project Is Not

Not a simple calculator or single chatbot.

## Key Users

MER, BOM, Sew, Wash, Cut, Costing, Technical Department, BDE.

## Systems / Data

Sketch, techpack, sample image, buyer reference, BOM, construction, wash, historical costing, quote history.

## Known Risks / Blockers

Distributed costing data, unstandardized technical experience, unclear source of truth, need human review.

## Next Actions

Collect real sample requests and define batch quotation workflow.

## Do Not Drift Rules

- Treat as strategic platform, not simple calculator.
- Keep human MER review before official quotation.

## Source Links

- [[PPJ.COSTING.AGENT.PLATFORM.v1.1]]
- [[PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY]]

<!-- PPJ_DOMAIN_GOVERNANCE_START -->
## Domain Governance

- Canonical Code: COSTING.AGENTIC.PLATFORM.v1.1
- Current File: [[PPJ.COSTING.AGENT.PLATFORM.v1.1]]
- Primary Domain: Merchandising
- Secondary Domains: Technical, Sew, Wash, Fabric, Finance
- Lifecycle: Development
- Progress: TBD
- Current Gate: Sew Costing v1.1 Demo Completed / v1.2 Development

## Domain Do Not Drift Rules
- Keep as strategic platform, not simple calculator.
<!-- PPJ_DOMAIN_GOVERNANCE_END -->

## Recent Update Events

| Date | Update Type | Summary | Source | Confidence |
| --- | --- | --- | --- | --- |
| 2026-08-01 | Weekly Portfolio Update | Sew Costing v1.1 demo completed, demonstrating description intake, operation extraction, operation-list standardization and an initial SAM/Sew Cost data foundation. v1.2 focuses on SAM accuracy, machine/standard-time mapping, incomplete descriptions, historical similarity, confidence, expert review and GTAS/IED transfer. | PPJ-WEEKLY-20260727-20260801 | Strong |
| 2026-07-18 | Weekly Portfolio Update | Sew prototype validated the flow Sewing Description -> Description Analysis -> Sewing Operation Extraction -> Standardized Operation List -> Expert Review. Extraction is not validated SMV, CM, final Sew Cost, or production-ready costing. Wash remains a workstream under this project: free-text input must be structured into attributes, missing-information checks, similar recipe retrieval, draft process recommendation, and mandatory Wash expert review. | PPJ-WEEKLY-20260713-20260718 | Strong |

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
