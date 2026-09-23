---
type: project_memory
project_name: "TD.TechnicalKnowledge.Platform.v2.1"
project_file: "TD.TechnicalPlatform_v2.1.md"
project_code: "TD.TechnicalKnowledge.Platform.v2.1"
department: "Technical Department"
cluster: "Technical Knowledge / Training"
phase: "Development / Data Validation"
technical_members: ["Huy", "Khoa"]
stakeholders: ["Anh Tu", "Technical Department"]
last_verified: "2026-08-01"
confidence: "Strong"
canonical_code: "TD.TechnicalKnowledge.Platform.v2.1"
current_file: "TD.TechnicalPlatform_v2.1.md"
primary_domain: "Fabric / Textiles Technique"
primary_capability: "Fabric, pattern, BOM, technical knowledge, 3D and scanning"
secondary_domains: "Merchandising, Costing, Training"
lifecycle: "Development / Data Validation"
progress: "ETL completed for currently identified v2.1 sources"
current_gate: "ETL Completed / Data Foundation Available / Data Acceptance Pending"
status: "Development / Data Validation"
current_outcome: "Technical data and knowledge foundation for search, retrieval, Pattern, BOM, construction, consumption, historical cases, Costing and future domain AI."
latest_update_summary: "ETL completed for the Technical sources currently identified in v2.1 scope. Data was extracted, transformed, initially standardized, loaded into the Technical Platform data layer and organized for future search, retrieval and AI capability."
known_blockers: "Technical-user acceptance is pending. | Completeness, freshness, approved-version logic, lineage and permissions are not fully confirmed."
known_risks: "ETL completion does not mean production-ready data. | Duplicate records, missing keys or wrong versions could affect Costing outputs."
decisions_needed: "Approve Technical data completeness, accuracy and version logic. | Confirm data owner, lineage and permission model."
next_actions: "Measure ETL coverage and reconcile with source systems. | Detect duplicates and missing keys. | Confirm record version and approved/latest version logic. | Build search/retrieval and permission layers. | Connect consumption data to Costing and prepare Technical-user UAT."
priority: "P6"
dependencies: ["Technical Platform ETL -> Pattern / BOM / Consumption / Construction -> Sew and Consumption Costing -> Costing Package"]
recent_update_events: ["PPJ-WEEKLY-20260727-20260801"]
workspace_path: "03_Projects/TD.TechnicalPlatform_v2.1"
project_home: "03_Projects/TD.TechnicalPlatform_v2.1/00_Project_Home.md"
project_board: "03_Projects/TD.TechnicalPlatform_v2.1/Project_Executive_Board.canvas"
task_folder: "03_Projects/TD.TechnicalPlatform_v2.1/Tasks"
documentation_status: "Workspace Created"
---

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
