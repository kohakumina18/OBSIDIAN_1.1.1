---
type: project_memory
project_name: "COSTING.AGENTIC.PLATFORM.v1.1"
project_file: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
project_code: "COSTING.AGENTIC.PLATFORM.v1.1"
department: "MER"
cluster: "Costing Agentic Platform"
phase: "Development"
technical_members: ["Lam", "Khoa", "Uyen"]
last_verified: "2026-08-01"
confidence: "Strong"
canonical_code: "COSTING.AGENTIC.PLATFORM.v1.1"
current_file: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
primary_domain: "Merchandising"
primary_capability: "Costing, quotation, market intelligence, customer workflows"
secondary_domains: "Technical, Sew, Wash, Fabric, Finance"
lifecycle: "Development"
progress: "TBD"
current_gate: "Sew Costing v1.1 Demo Completed / v1.2 Development"
status: "Development"
current_outcome: "Costing and Quotation Package for Merchandising review and customer quotation proposals."
latest_update_summary: "Sew Costing v1.1 demo completed, demonstrating description intake, operation extraction, operation-list standardization and an initial SAM/Sew Cost data foundation. v1.2 focuses on SAM accuracy, machine/standard-time mapping, incomplete descriptions, historical similarity, confidence, expert review and GTAS/IED transfer."
known_risks: "SAM is not final without validated standards and expert review. | AI suggestion and approved costing must remain separate."
decisions_needed: "Approve Sew v1.2 accuracy and acceptance plan. | Confirm GTAS/IED data contract and expert-approval boundary."
next_actions: "Evaluate the v1.1 demo with Sew experts and establish an accuracy baseline. | Analyze extraction errors and improve SAM calculation. | Confirm GTAS/IED data contract and API/integration format. | Connect Technical consumption data. | Continue the Wash dataset workstream without creating a separate root project."
priority: "P3"
recent_update_events: ["PPJ-WEEKLY-20260713-20260718", "PPJ-WEEKLY-20260727-20260801"]
secondary_workstream_gate: "Wash Discovery / Dataset Preparation"
known_blockers: "GTAS/IED data contract and integration format are not confirmed. | Technical data acceptance remains pending."
dependencies: ["TD.TechnicalKnowledge.Platform.v2.1 -> Consumption / Pattern / BOM / Construction / History -> Costing Platform", "AI Suggestion -> Expert-approved Result -> Final GTAS/IED Transfer"]
---

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



