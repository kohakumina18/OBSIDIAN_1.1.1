---
type: "risks_issues"
project: "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1"
source_project: "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md"
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
| Canonical Code | MER_InvoiceDataRecheck_v1.1.0 |
| Domain | Merchandising |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Active |
| Status | Active |
| Progress | TBD |
| Gate | Multi-customer invoice, cost and data checking |
| Priority | Medium |
| Outcome | Cross-check costing data, commercial cost, invoice data and customer rules, route exceptions to user review. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

No longer conceptually limited to Chico's: multi-customer invoice/cost/data checking (Costing Data + Commercial Cost + Invoice Data + Customer Rules -> Cross-check -> Exception -> User Review). Belongs to Merchandising, not Finance, because its business owner and core process are commercial/order-data validation.

### Current Risks

- Customer-rule coverage across customers

### Dependencies

- None recorded in the current portfolio snapshot.

### Next Actions

- Validate customer-specific recheck rules, starting from the Chico's baseline
- Confirm audit output with Merchandising
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Risks and Issues

| ID | Risk / Issue | Impact | Owner | Status | Source |
| --- | --- | --- | --- | --- | --- |
| RISK-001 | Need real sample invoice/costing, MER checklist, source of truth, and human review. | Needs Confirmation | Needs Confirmation | Open | Canonical naming populated |

## Evidence Basis

- Root project note: [[../MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-07-13
- Confidence: Strong
