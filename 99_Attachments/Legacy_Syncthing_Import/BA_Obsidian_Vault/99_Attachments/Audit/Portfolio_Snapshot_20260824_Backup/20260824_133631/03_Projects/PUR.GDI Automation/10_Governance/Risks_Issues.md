---
type: "risks_issues"
project: "PUR.GDI.Automation.v1.0"
source_project: "PUR.GDI Automation.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-08-24

| Field | Value |
| --- | --- |
| Canonical Code | PUR.GDI.Automation.v1.0 |
| Domain | Sourcing / Purchasing |
| Lifecycle | Active / WFX API Integration |
| Progress | TBD |
| Gate | WFX API contract discovery and controlled integration design |
| Priority | P3 |
| Outcome | Automate GDI creation/update while preserving WFX transaction control, validation, confirmation and audit. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260824 |

### Latest Update

Purchasing teams and MER leaders/managers confirmed the business flow; WFX API support materially reduced technical uncertainty. Selenium is fallback only.

### Current Risks

- WFX API ownership and sandbox
- Authentication and rate limits
- Transaction integrity

### Dependencies

- WFX API -> Business validation -> Controlled GDI transaction -> Confirmation / Audit

### Next Actions

- Obtain WFX API authentication and operation documentation
- Confirm create/update/lookup/draft/submit/cancel/status schemas
- Define validation, idempotency, duplicate, retry and timeout controls
- Design audit logging and transaction confirmation
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Risks and Issues

| ID | Risk / Issue | Impact | Owner | Status | Source |
| --- | --- | --- | --- | --- | --- |
| RISK-001 | Official WFX API documentation, authorization and non-production environment are not confirmed. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |
| RISK-002 | Rollback, draft/review and idempotency behavior are not confirmed. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |
| RISK-003 | Direct unapproved Databricks writes would not constitute a governed WFX transaction. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |
| RISK-004 | Duplicate transactions and incomplete rollback could damage operational data. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |

## Evidence Basis

- Root project note: [[../PUR.GDI Automation]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PUR.GDI.Automation.v1.0.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
