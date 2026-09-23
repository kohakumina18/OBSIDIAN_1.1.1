---
type: project_memory
project_name: "PUR.GDI.Automation.v1.0"
project_file: "PUR.GDI Automation.md"
project_code: "PUR.GDI.Automation.v1.0"
department: "Purchasing"
cluster: "Purchasing Workflow"
phase: "DESIGN"
technical_members: ["Hien", "Khoa"]
last_verified: "2026-08-24"
confidence: "Strong"
canonical_code: "PUR.GDI.Automation.v1.0"
current_file: "PUR.GDI Automation.md"
primary_domain: "Sourcing / Purchasing"
primary_capability: "Purchasing transaction: GDI creation automation"
secondary_domains: "WFX, Purchasing Operations"
lifecycle: "Active / WFX API Integration"
progress: "TBD"
current_gate: "WFX API contract discovery and controlled integration design"
status: "Active"
current_outcome: "Automate GDI creation/update while preserving WFX transaction control, validation, confirmation and audit."
latest_update_summary: "Purchasing teams and MER leaders/managers confirmed the business flow; WFX API support materially reduced technical uncertainty. Selenium is fallback only."
known_blockers: "WFX API ownership and sandbox | Authentication and rate limits | Transaction integrity"
known_risks: "WFX API ownership and sandbox | Authentication and rate limits | Transaction integrity"
decisions_needed: "None recorded"
next_actions: "Obtain WFX API authentication and operation documentation | Confirm create/update/lookup/draft/submit/cancel/status schemas | Define validation, idempotency, duplicate, retry and timeout controls | Design audit logging and transaction confirmation"
priority: "P3"
dependencies: "WFX API -> Business validation -> Controlled GDI transaction -> Confirmation / Audit"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260824"]
workspace_path: "03_Projects/PUR.GDI Automation"
project_home: "03_Projects/PUR.GDI Automation/00_Project_Home.md"
project_board: "03_Projects/PUR.GDI Automation/Project_Executive_Board.canvas"
task_folder: "03_Projects/PUR.GDI Automation/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
delivery_stage: "DESIGN"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | PUR.GDI.Automation.v1.0 |
| Primary Domain | Sourcing / Purchasing |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DESIGN |
| Lifecycle | Active / WFX API Integration |
| Status | Active |
| Progress | TBD |
| Current Gate | WFX API contract discovery and controlled integration design |
| Priority | P3 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Automate GDI creation/update while preserving WFX transaction control, validation, confirmation and audit.

## Current Capability

PPJ GDI application using supported WFX APIs; never direct-write Databricks as a substitute for WFX transactions.

## Latest Update

Purchasing teams and MER leaders/managers confirmed the business flow; WFX API support materially reduced technical uncertainty. Selenium is fallback only.

## Risks / Blockers

- WFX API ownership and sandbox
- Authentication and rate limits
- Transaction integrity

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- WFX API -> Business validation -> Controlled GDI transaction -> Confirmation / Audit

## Next Actions

- Obtain WFX API authentication and operation documentation
- Confirm create/update/lookup/draft/submit/cancel/status schemas
- Define validation, idempotency, duplicate, retry and timeout controls
- Design audit logging and transaction confirmation

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[PUR.GDI Automation/00_Project_Home|Project Home]]
- [[PUR.GDI Automation/Project_Executive_Board|Project Executive Board]]
- [[PUR.GDI Automation/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

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
