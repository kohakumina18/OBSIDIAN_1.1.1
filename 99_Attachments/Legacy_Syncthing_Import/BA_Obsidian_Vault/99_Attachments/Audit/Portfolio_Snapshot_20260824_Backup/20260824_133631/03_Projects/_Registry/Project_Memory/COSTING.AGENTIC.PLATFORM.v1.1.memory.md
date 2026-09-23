---
type: project_memory
project_name: "COSTING.AGENTIC.PLATFORM.v1.1"
project_file: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
project_code: "COSTING.AGENTIC.PLATFORM.v1.1"
department: "MER"
cluster: "Costing Agentic Platform"
phase: "Active Development"
technical_members: ["Lam", "Khoa", "Uyen"]
last_verified: "2026-08-24"
confidence: "Strong"
canonical_code: "COSTING.AGENTIC.PLATFORM.v1.1"
current_file: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
primary_domain: "Merchandising"
primary_capability: "Costing, quotation, market intelligence, customer workflows"
secondary_domains: "Technical, Sew, Wash, Fabric, Finance"
lifecycle: "Active Development"
progress: "TBD"
current_gate: "Sew v1.2 and Wash Agent development"
status: "Active Development"
current_outcome: "Generate a Costing / Quotation Package for Merchandising review and customer quotation."
latest_update_summary: "Sew v1.1 demonstrated description-to-standardized-operation extraction; v1.2 focuses on SAM accuracy, normalization, machine/time mapping, confidence and GTAS/IED integration. Wash remains a human-reviewed workstream inside this platform."
known_risks: "SAM accuracy and expert acceptance | GTAS/IED integration contract | Technical Data dependency"
decisions_needed: "None recorded"
next_actions: "Improve SAM validation and benchmark with a Sew expert | Confirm the GTAS/IED integration contract | Connect Technical Data | Collect Wash cases | Build the Wash similarity engine with mandatory expert review"
priority: "P2"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260824"]
secondary_workstream_gate: "Wash Discovery / Dataset Preparation"
known_blockers: "SAM accuracy and expert acceptance | GTAS/IED integration contract | Technical Data dependency"
dependencies: "TD.TechnicalKnowledge.Platform.v2.1 -> Pattern/BOM/Consumption -> Sew/Wash/Costing AI"
workspace_path: "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1"
project_home: "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1/00_Project_Home.md"
project_board: "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1/Project_Executive_Board.canvas"
task_folder: "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | COSTING.AGENTIC.PLATFORM.v1.1 |
| Primary Domain | Merchandising |
| Lifecycle | Active Development |
| Progress | TBD |
| Current Gate | Sew v1.2 and Wash Agent development |
| Priority | P2 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Generate a Costing / Quotation Package for Merchandising review and customer quotation.

## Current Capability

Description -> Operation -> Machine -> Standard Time -> SAM -> Cost -> Expert Review -> GTAS/IED; Wash creates draft recommendations only.

## Latest Update

Sew v1.1 demonstrated description-to-standardized-operation extraction; v1.2 focuses on SAM accuracy, normalization, machine/time mapping, confidence and GTAS/IED integration. Wash remains a human-reviewed workstream inside this platform.

## Risks / Blockers

- SAM accuracy and expert acceptance
- GTAS/IED integration contract
- Technical Data dependency

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- TD.TechnicalKnowledge.Platform.v2.1 -> Pattern/BOM/Consumption -> Sew/Wash/Costing AI

## Next Actions

- Improve SAM validation and benchmark with a Sew expert
- Confirm the GTAS/IED integration contract
- Connect Technical Data
- Collect Wash cases
- Build the Wash similarity engine with mandatory expert review

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[PPJ.COSTING.AGENT.PLATFORM.v1.1/00_Project_Home|Project Home]]
- [[PPJ.COSTING.AGENT.PLATFORM.v1.1/Project_Executive_Board|Project Executive Board]]
- [[PPJ.COSTING.AGENT.PLATFORM.v1.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
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
