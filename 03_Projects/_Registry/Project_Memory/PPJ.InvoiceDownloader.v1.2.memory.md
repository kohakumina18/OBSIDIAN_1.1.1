---
type: project_memory
project_name: "PPJ.InvoiceDownloader.v1.2"
project_file: "PPJ.Invoice Downloader.v1.2.md"
project_code: "FIN_InvoiceDownloader_v1.2.0"
department: "Accounting / Purchasing"
cluster: "Invoice API / Download Automation"
phase: "GO-LIVE / PRODUCTION / SUPPORT"
technical_members: ["Khoa", "Nam"]
last_verified: "2026-09-18"
confidence: "Strong"
canonical_code: "FIN_InvoiceDownloader_v1.2.0"
current_file: "PPJ.Invoice Downloader.v1.2.md"
primary_domain: "Finance / Accounting"
primary_capability: "Financial analysis, reporting, invoices, GRN"
secondary_domains: "EXIM, Purchasing, API, E-invoice"
lifecycle: "Production"
progress: "TBD"
current_gate: "Operational reliability"
workspace_path: "03_Projects/PPJ.Invoice Downloader.v1.2"
project_home: "03_Projects/PPJ.Invoice Downloader.v1.2/00_Project_Home.md"
project_board: "03_Projects/PPJ.Invoice Downloader.v1.2/Project_Executive_Board.canvas"
task_folder: "03_Projects/PPJ.Invoice Downloader.v1.2/Tasks"
documentation_status: "Workspace Created"
priority: "Support"
current_outcome: "Acquire invoice documents/data: Invoice Source -> Download -> Store -> Structured Metadata (no accounting entry)."
latest_update_summary: "Production. Acquires invoice documents/data for XML/PDF/metadata, merge, API and reporting-source use; does not perform accounting entry. Operations focus on portal changes, credentials, retry, missing/duplicate invoices, monitoring and audit."
known_risks: "None recorded"
decisions_needed: "None recorded"
next_actions: "Monitor portal and credential changes | Track retries, missing invoices and duplicates | Maintain audit evidence"
dependencies: "None recorded"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
status: "Active"
known_blockers: "None recorded"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260918"]
delivery_stage: "GO-LIVE / PRODUCTION / SUPPORT"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | FIN_InvoiceDownloader_v1.2.0 |
| Legacy Code(s) | PPJ.InvoiceDownloader.v1.2; PPJ.Invoice Downloader.v1.2; Invoice Downloader |
| Primary Domain | Finance / Accounting |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Production |
| Status | Active |
| Progress | TBD |
| Current Gate | Operational reliability |
| Priority | Support |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

Acquire invoice documents/data: Invoice Source -> Download -> Store -> Structured Metadata (no accounting entry).

## Current Capability

Acquire invoice documents/data: Invoice Source -> Download -> Store -> Structured Metadata (no accounting entry).

## Latest Update

Production. Acquires invoice documents/data for XML/PDF/metadata, merge, API and reporting-source use; does not perform accounting entry. Operations focus on portal changes, credentials, retry, missing/duplicate invoices, monitoring and audit.

## Risks / Blockers

- No current portfolio-level risk recorded.

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Monitor portal and credential changes
- Track retries, missing invoices and duplicates
- Maintain audit evidence

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[PPJ.Invoice Downloader.v1.2/00_Project_Home|Project Home]]
- [[PPJ.Invoice Downloader.v1.2/Project_Executive_Board|Project Executive Board]]
- [[PPJ.Invoice Downloader.v1.2/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Memory: PPJ.InvoiceDownloader.v1.2

## One-Line Understanding

API/tool for downloading and merging e-invoices, now accessible through GPT/PERRI-enabled automation.

## Current Outcome

Reduce manual invoice download/merge work while adding logging, permission, retry, and fallback controls.

## Latest Update Summary

Canonical naming maps Invoice Downloader and SYS.INVOICES aliases here.

## What This Project Is

Production/API enhancement project for invoice download and output standardization.

## What This Project Is Not

Not automatic accounting posting unless separately confirmed.

## Key Users

Accounting, Purchasing, EXIM users who need invoice retrieval.

## Systems / Data

E-invoice portals, API, GPT/PERRI call path, output files, invoice metadata, logs.

## Known Risks / Blockers

Credential/session, permission, portal UI/API changes, duplicate/missing invoice, metadata accuracy.

## Next Actions

Keep API logging and permission model clear before expanding agent access.

## Do Not Drift Rules

- Do not assume credential handling or auto-posting unless confirmed.
- Keep audit/logging for GPT/PERRI access.

## Source Links

- [[PPJ.Invoice Downloader.v1.2]]
- [[PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY]]

<!-- PPJ_DOMAIN_GOVERNANCE_START -->
## Domain Governance

- Canonical Code: PPJ.InvoiceDownloader.v1.2
- Current File: [[PPJ.Invoice Downloader.v1.2]]
- Primary Domain: Finance / Accounting
- Secondary Domains: EXIM, Purchasing, API, E-invoice
- Lifecycle: Production / Support
- Progress: TBD
- Current Gate: Business Adoption

## Domain Do Not Drift Rules
- Shared technical utility but Finance / Accounting primary domain.
<!-- PPJ_DOMAIN_GOVERNANCE_END -->
