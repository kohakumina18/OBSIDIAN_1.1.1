---
type: "risks_issues"
project: "PPJ.ExpenseInvoices.v1.1"
source_project: "PPJ. Expense-Invoices.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-09-18

| Field | Value |
| --- | --- |
| Canonical Code | LOG_ExpenseInvoiceProcessing_v1.2.2 |
| Domain | Logistics / EXIM |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Regional Rollout / UAT |
| Status | Active |
| Progress | TBD |
| Gate | Regional rollout, tax rules and invoice validation |
| Priority | P4 |
| Outcome | Process Logistics / Import-Export expense invoices with regional and tax rules, invoice validation, user workflow and exception management. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

Current Logistics / Import-Export expense-invoice project (Active Regional Rollout / UAT). Focus: regional rollout, tax rules, invoice validation, user workflow and exception management. Replaces the ambiguity created by older EXIM expense-invoice names. Prior guidance (departments/factories except Export; EXIM-first historical) is preserved in project history.

### Current Risks

- Mapping completeness
- Real-data defects
- Regional / tax-rule variation
- Go-live support readiness

### Dependencies

- None recorded in the current portfolio snapshot.

### Next Actions

- Close remaining defects and retest
- Confirm mapping and frequent-supplier readiness
- Complete production-readiness review and go-live decision
- Confirm regional and tax rules for each rollout region
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Risks and Issues

| ID | Risk / Issue | Impact | Owner | Status | Source |
| --- | --- | --- | --- | --- | --- |
| RISK-001 | Mapping ownership and go-live boundary are not confirmed. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |
| RISK-002 | Critical real-data defects and supplier-code inconsistencies remain open. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |
| RISK-003 | Duplicate invoices, invalid mappings and weak error handling could affect Accounting operations. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |
| RISK-004 | Production monitoring and escalation ownership are pending. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |

## Evidence Basis

- Root project note: [[../PPJ. Expense-Invoices.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PPJ.ExpenseInvoices.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
