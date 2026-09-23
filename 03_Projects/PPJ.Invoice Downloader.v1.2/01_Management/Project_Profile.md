---
type: "project_profile"
project: "PPJ.InvoiceDownloader.v1.2"
source_project: "PPJ.Invoice Downloader.v1.2.md"
source_event: "Canonical naming populated"
last_verified: "2026-07-13"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-09-18

| Field | Value |
| --- | --- |
| Canonical Code | FIN_InvoiceDownloader_v1.2.0 |
| Domain | Finance / Accounting |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Production |
| Status | Active |
| Progress | TBD |
| Gate | Operational reliability |
| Priority | Support |
| Outcome | Acquire invoice documents/data: Invoice Source -> Download -> Store -> Structured Metadata (no accounting entry). |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

Production. Acquires invoice documents/data for XML/PDF/metadata, merge, API and reporting-source use; does not perform accounting entry. Operations focus on portal changes, credentials, retry, missing/duplicate invoices, monitoring and audit.

### Current Risks

- None recorded in the current portfolio snapshot.

### Dependencies

- None recorded in the current portfolio snapshot.

### Next Actions

- Monitor portal and credential changes
- Track retries, missing invoices and duplicates
- Maintain audit evidence
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Profile

## Identity

| Field | Value |
| --- | --- |
| Canonical Code | PPJ.InvoiceDownloader.v1.2 |
| Physical Project Note | PPJ.Invoice Downloader.v1.2.md |
| Primary Domain | Finance / Accounting |
| Cluster | Invoice API / Download Automation |
| Lifecycle Class | C. Production / Maintenance |
| Lifecycle | Production / Business Adoption |
| Current Gate | Business Adoption |
| Priority | P2 |
| Business Owner | Needs Confirmation |

## One-Line Understanding

API/tool for downloading and merging e-invoices, now accessible through GPT/PERRI-enabled automation.

## Intended Outcome

Reduce manual invoice download/merge work while adding logging, permission, retry, and fallback controls.

## Users and Delivery Participants

- Primary users: Accounting / EXIM / Uyen / Nam / Phat
- BA / Coordination: Uyên
- Technical members: Khoa, Nam, Nam, Phát

## Current Scope

- Production/API enhancement project for invoice download and output standardization.

## Explicit Boundaries

- Not automatic accounting posting unless separately confirmed.

## Current Gate and Next Move

- Gate: Business Adoption
- Next actions: Review repaired block with project owner.; Confirm missing data fields and workflow.; Update related BRD/SOP/user manual after confirmation.

## Evidence Basis

- Root project note: [[../PPJ.Invoice Downloader.v1.2]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PPJ.InvoiceDownloader.v1.2.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-07-13
- Confidence: Strong
