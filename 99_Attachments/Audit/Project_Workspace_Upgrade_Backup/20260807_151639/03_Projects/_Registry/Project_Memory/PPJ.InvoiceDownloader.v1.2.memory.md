---
type: project_memory
project_name: "PPJ.InvoiceDownloader.v1.2"
project_file: "PPJ.Invoice Downloader.v1.2.md"
project_code: "PPJ.InvoiceDownloader.v1.2"
department: "Accounting / Purchasing"
cluster: "Invoice API / Download Automation"
phase: "Production / API Enhancement"
technical_members: ["Khoa", "Nam"]
last_verified: "2026-07-13"
confidence: "Strong"
canonical_code: "PPJ.InvoiceDownloader.v1.2"
current_file: "PPJ.Invoice Downloader.v1.2.md"
primary_domain: "Finance / Accounting"
primary_capability: "Financial analysis, reporting, invoices, GRN"
secondary_domains: "EXIM, Purchasing, API, E-invoice"
lifecycle: "Production / Support"
progress: "TBD"
current_gate: "Business Adoption"
---

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


