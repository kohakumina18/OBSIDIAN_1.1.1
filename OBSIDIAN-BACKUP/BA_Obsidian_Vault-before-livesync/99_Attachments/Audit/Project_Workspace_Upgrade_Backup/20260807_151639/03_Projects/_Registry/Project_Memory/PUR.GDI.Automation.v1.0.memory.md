---
type: project_memory
project_name: "PUR.GDI.Automation.v1.0"
project_file: "PUR.GDI Automation.md"
project_code: "PUR.GDI.Automation.v1.0"
department: "Purchasing"
cluster: "Purchasing Workflow"
phase: "Analysis / Solution Redesign"
technical_members: ["Hien", "Khoa"]
last_verified: "2026-08-01"
confidence: "Strong"
canonical_code: "PUR.GDI.Automation.v1.0"
current_file: "PUR.GDI Automation.md"
primary_domain: "Sourcing / Purchasing"
primary_capability: "Purchasing transaction: GDI creation automation"
secondary_domains: "WFX, Purchasing Operations"
lifecycle: "Analysis / Solution Redesign"
progress: "TBD"
current_gate: "Business Flow Confirmed / API Integration Discovery"
status: "Analysis / Solution Redesign"
current_outcome: "API-first GDI creation and update workflow that reduces manual Purchasing work while preserving review, transaction control and auditability in WFX."
latest_update_summary: "Purchasing and selected MER leaders/managers confirmed the business flow, required input, creation conditions, review responsibilities and target output. Architecture direction changed from Selenium screen simulation to approved API integration."
known_blockers: "Official WFX API documentation, authorization and non-production environment are not confirmed. | Rollback, draft/review and idempotency behavior are not confirmed."
known_risks: "Direct unapproved Databricks writes would not constitute a governed WFX transaction. | Duplicate transactions and incomplete rollback could damage operational data."
decisions_needed: "Approve WFX API or vendor-approved transactional service. | Confirm transaction, rollback, approval and audit architecture."
next_actions: "Request WFX API documentation and supported create/update/draft/submit/cancel/status operations. | Confirm authentication, request/response schema, idempotency and duplicate rules. | Confirm rollback, audit and approval-before-submit requirements. | Build and test an API prototype in a non-production environment. | Do not write production transactions without vendor approval."
priority: "P2"
dependencies: ["Confirmed Purchasing Workflow -> WFX API -> Controlled GDI Transaction -> Audit and Status"]
recent_update_events: ["PPJ-WEEKLY-20260727-20260801"]
---

# Project Memory: PUR.GDI.Automation.v1.0

## One-Line Understanding

Purchasing GDI creation automation currently on hold due WFX/system dependency.

## Current Outcome

Automate GDI only after input standardization and WFX readiness are resolved.

## Latest Update Summary

Canonical naming populated from portfolio dictionary.

## What This Project Is

Automation for Goods Delivery Instruction creation.

## What This Project Is Not

Not active production if WFX modification/dependency remains blocked.

## Key Users

Purchasing users.

## Systems / Data

WFX, GDI input, delivery instruction data.

## Known Risks / Blockers

WFX dependency and source-system readiness.

## Next Actions

Keep on hold until WFX blocker is unblocked.

## Do Not Drift Rules

- Do not spend large effort while WFX blocker remains.
- Do not mark production until dependency is resolved.

## Source Links

- [[PUR.GDI Automation]]
- [[PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY]]

<!-- PPJ_DOMAIN_GOVERNANCE_START -->
## Domain Governance

- Canonical Code: PUR.GDI.Automation.v1.0
- Current File: [[PUR.GDI Automation]]
- Primary Domain: Sourcing / Purchasing
- Secondary Domains: WFX, Purchasing Operations
- Lifecycle: Analysis / Solution Redesign
- Progress: TBD
- Current Gate: Business Flow Confirmed / API Integration Discovery

## Domain Do Not Drift Rules
- Do not mark production while WFX dependency remains.
<!-- PPJ_DOMAIN_GOVERNANCE_END -->

## Recent Update Events

| Date | Update Type | Summary | Source | Confidence |
| --- | --- | --- | --- | --- |
| 2026-08-01 | Weekly Portfolio Update | Purchasing and selected MER leaders/managers confirmed the business flow, required input, creation conditions, review responsibilities and target output. Architecture direction changed from Selenium screen simulation to approved API integration. | PPJ-WEEKLY-20260727-20260801 | Strong |

