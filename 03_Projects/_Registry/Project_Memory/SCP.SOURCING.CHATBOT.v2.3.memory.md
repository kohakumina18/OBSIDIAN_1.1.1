---
type: project_memory
project_name: "SCP.SOURCING.CHATBOT.v2.3"
project_file: "SCP.SOURCING.CHATBOT.v2.3.md"
project_code: "SCP_SourcingChatbot_v2.3.0"
department: "Sourcing"
cluster: "Sourcing AI / Data Platform"
phase: "GO-LIVE / PRODUCTION / SUPPORT"
technical_members: ["Huy", "Khoa", "Linh", "Nghia"]
progress: "TBD"
last_verified: "2026-09-18"
confidence: "Strong"
canonical_code: "SCP_SourcingChatbot_v2.3.0"
current_file: "SCP.SOURCING.CHATBOT.v2.3.md"
primary_domain: "Sourcing / Purchasing"
primary_capability: "Sourcing intelligence: supplier, material, sample, search, intelligence"
secondary_domains: "Data Governance, AI Chatbot, Supplier Data"
lifecycle: "Production"
current_gate: "Production monitoring, data quality and retrieval quality"
status: "Active"
current_outcome: "One production application for supplier/material intelligence: Supplier Data + Material Data + Search + Comparison + RAG + Chatbot."
latest_update_summary: "Stays one application; do not split into sourcing database / search / RAG / chatbot unless business lifecycles genuinely diverge. Focus: production monitoring, data quality, retrieval quality, supplier/material coverage and answer traceability."
known_risks: "Manual external-data input | Non-standard naming and metadata | Data-quality drift"
decisions_needed: "None recorded"
next_actions: "Clean missing fields, mixed types, duplicates and naming | Stress-test retrieval with real Sourcing questions | Monitor adoption and production quality"
priority: "P9"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260918"]
known_blockers: "Manual external-data input | Non-standard naming and metadata | Data-quality drift"
dependencies: "None recorded"
workspace_path: "03_Projects/SCP.SOURCING.CHATBOT.v2.3"
project_home: "03_Projects/SCP.SOURCING.CHATBOT.v2.3/00_Project_Home.md"
project_board: "03_Projects/SCP.SOURCING.CHATBOT.v2.3/Project_Executive_Board.canvas"
task_folder: "03_Projects/SCP.SOURCING.CHATBOT.v2.3/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
delivery_stage: "GO-LIVE / PRODUCTION / SUPPORT"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | SCP_SourcingChatbot_v2.3.0 |
| Legacy Code(s) | SCP.SOURCING.CHATBOT.v2.3 |
| Primary Domain | Sourcing / Purchasing |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Production |
| Status | Active |
| Progress | TBD |
| Current Gate | Production monitoring, data quality and retrieval quality |
| Priority | P9 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

One production application for supplier/material intelligence: Supplier Data + Material Data + Search + Comparison + RAG + Chatbot.

## Current Capability

Supplier / Material / Sample Intelligence; consolidated search platform and chatbot.

## Latest Update

Stays one application; do not split into sourcing database / search / RAG / chatbot unless business lifecycles genuinely diverge. Focus: production monitoring, data quality, retrieval quality, supplier/material coverage and answer traceability.

## Risks / Blockers

- Manual external-data input
- Non-standard naming and metadata
- Data-quality drift

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Clean missing fields, mixed types, duplicates and naming
- Stress-test retrieval with real Sourcing questions
- Monitor adoption and production quality

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[SCP.SOURCING.CHATBOT.v2.3/00_Project_Home|Project Home]]
- [[SCP.SOURCING.CHATBOT.v2.3/Project_Executive_Board|Project Executive Board]]
- [[SCP.SOURCING.CHATBOT.v2.3/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Memory: SCP.SOURCING.CHATBOT.v2.3

## One-Line Understanding

Consolidated Sourcing data platform and chatbot for supplier, material, fabric, trims, and sample lookup.

## Current Outcome

Build governed sourcing repository and chatbot search with clear metadata and data owner.

## Latest Update Summary

Team continues POC/data strategy discussion with Linh and Roberto, especially external sample volume before large import.

## What This Project Is

One consolidated project covering sourcing data repository, external samples, and chatbot lookup.

## What This Project Is Not

Do not split into separate Sourcing Repository, External Sample Management, and Sourcing Chatbot projects without approval.

## Key Users

Sourcing users and stakeholders managing supplier/material/sample data.

## Systems / Data

Supplier data, fabric, trims, external sample data, metadata, file/document storage, chatbot search.

## Known Risks / Blockers

Large external data volume, missing metadata minimum, missing data owner, naming convention risk.

## Next Actions

Finalize data strategy and minimum metadata before large import.

## Do Not Drift Rules

- Keep sourcing consolidated under `SCP.SOURCING.CHATBOT.v2.3`.
- Do not create separate project notes for external samples without approval.

## Source Links

- [[SCP.SOURCING.CHATBOT.v2.3]]
- [[PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY]]

<!-- PPJ_DOMAIN_GOVERNANCE_START -->
## Domain Governance

- Canonical Code: SCP.SOURCING.CHATBOT.v2.3
- Current File: [[SCP.SOURCING.CHATBOT.v2.3]]
- Primary Domain: Sourcing / Purchasing
- Secondary Domains: Data Governance, AI Chatbot, Supplier Data
- Lifecycle: Closeout Preparation
- Progress: TBD
- Current Gate: Output Finalization / UAT Acceptance / Handover Preparation

## Domain Do Not Drift Rules
- Do not split sourcing into separate project notes without approval.
- Do not mix sourcing intelligence with purchasing transaction automation.
<!-- PPJ_DOMAIN_GOVERNANCE_END -->

## Recent Update Events

| Date | Update Type | Summary | Source | Confidence |
| --- | --- | --- | --- | --- |
| 2026-08-01 | Weekly Portfolio Update | The team is finalizing the official output format for the current release. Expected next movement is UAT acceptance, handover and closure of active-development scope. External Sourcing data standardization remains a backlog workstream under the same consolidated project. | PPJ-WEEKLY-20260727-20260801 | Strong |
| 2026-07-18 | Weekly Portfolio Update | The third user-training session was completed for chá»‹ LÃ¢m and chá»‹ Minh Anh, covering login, permissions, question formulation, data search, result validation, and feedback/defect reporting. Real use cases and adoption support continue. | PPJ-WEEKLY-20260713-20260718 | Strong |
