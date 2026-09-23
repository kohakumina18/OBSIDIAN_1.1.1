---
type: project_memory
project_name: "TD.TechnicalKnowledge.Platform.v2.1"
project_file: "TD.TechnicalPlatform_v2.1.md"
project_code: "TD.TechnicalKnowledge.Platform.v2.1"
department: "Technical Department"
cluster: "Technical Knowledge / Training"
phase: "UAT / PRE-GO-LIVE"
technical_members: ["Huy", "Khoa"]
stakeholders: ["Anh Tu", "Technical Department"]
last_verified: "2026-08-24"
confidence: "Strong"
canonical_code: "TD.TechnicalKnowledge.Platform.v2.1"
current_file: "TD.TechnicalPlatform_v2.1.md"
primary_domain: "Fabric / Textiles Technique"
primary_capability: "Fabric, pattern, BOM, technical knowledge, 3D and scanning"
secondary_domains: "Merchandising, Costing, Training"
lifecycle: "Initial Sync Demo Completed / Sync Validation & Stabilization"
progress: "TBD"
current_gate: "Incremental sync hardening and Technical UAT"
status: "Active"
current_outcome: "Technical Data Backbone for Pattern, BOM, Consumption, Construction, documents and historical records."
latest_update_summary: "Source collection, ETL, Technical Data Layer and the initial syncing-flow demo are complete; the project is now validating and stabilizing synchronization."
known_blockers: "Sync reliability | Version governance | Missing keys and duplicate records | Technical UAT acceptance"
known_risks: "Sync reliability | Version governance | Missing keys and duplicate records | Technical UAT acceptance"
decisions_needed: "None recorded"
next_actions: "Implement incremental sync, error handling and retry | Add duplicate, missing-key and reconciliation checks | Govern versions and latest/approved-record logic | Finalize permissions and prepare Technical UAT"
priority: "P5"
dependencies: "Technical sources -> ETL -> Technical Data Layer -> Sync -> Platform -> Costing / Pattern / Wash / Search"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260824"]
workspace_path: "03_Projects/TD.TechnicalPlatform_v2.1"
project_home: "03_Projects/TD.TechnicalPlatform_v2.1/00_Project_Home.md"
project_board: "03_Projects/TD.TechnicalPlatform_v2.1/Project_Executive_Board.canvas"
task_folder: "03_Projects/TD.TechnicalPlatform_v2.1/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
delivery_stage: "UAT / PRE-GO-LIVE"
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

# Project Memory: TD.TechnicalKnowledge.Platform.v2.1

## One-Line Understanding

Technical knowledge platform for buyer reference, pattern, BOM, costing history, videos, and training material.

## Current Outcome

Create a technical data node for search, training, and future costing agents.

## Latest Update Summary

Canonical naming populated; linked strongly to Costing Agentic Platform as technical data source.

## What This Project Is

Knowledge/search/training platform for Technical Department data.

## What This Project Is Not

Not automatically identical to CPD Datamart or Costing Platform; it supports them as a data node.

## Key Users

Technical Department, Anh Tu, AI/Automation, costing-related users.

## Systems / Data

Buyer reference, pattern, BOM, costing old, technical docs, sewing videos, training materials, possible Directus sync.

## Known Risks / Blockers

Distributed technical data, unclear naming convention, training vs operating data separation, sensitive technical permission.

## Next Actions

Define data structure, access model, and relation to costing agents.

## Do Not Drift Rules

- Respect technical data sensitivity.
- Do not merge with CPD Datamart unless explicitly approved.

## Source Links

- [[TD.TechnicalPlatform_v2.1]]
- [[COSTING.AGENTIC.PLATFORM.v1.1]]
- [[PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY]]

<!-- PPJ_DOMAIN_GOVERNANCE_START -->
## Domain Governance

- Canonical Code: TD.TechnicalKnowledge.Platform.v2.1
- Current File: [[TD.TechnicalPlatform_v2.1]]
- Primary Domain: Fabric / Textiles Technique
- Secondary Domains: Merchandising, Costing, Training
- Lifecycle: Development / Data Validation
- Progress: ETL completed for currently identified v2.1 sources
- Current Gate: ETL Completed / Data Foundation Available / Data Acceptance Pending

## Domain Do Not Drift Rules
- Respect technical data sensitivity.
<!-- PPJ_DOMAIN_GOVERNANCE_END -->

## Recent Update Events

| Date | Update Type | Summary | Source | Confidence |
| --- | --- | --- | --- | --- |
| 2026-08-01 | Weekly Portfolio Update | ETL completed for the Technical sources currently identified in v2.1 scope. Data was extracted, transformed, initially standardized, loaded into the Technical Platform data layer and organized for future search, retrieval and AI capability. | PPJ-WEEKLY-20260727-20260801 | Strong |
