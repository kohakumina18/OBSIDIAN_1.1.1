---
type: "decision_log"
project: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
source_project: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
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
| Canonical Code | FIN_FinanceManagement_v1.2.0 |
| Domain | Finance / Accounting |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DESIGN |
| Lifecycle | Strategic Active |
| Status | Active |
| Progress | TBD |
| Gate | WS2 OC / Cost Control and WS3 Factory Performance |
| Priority | P1 |
| Outcome | Centralized Finance Control Platform for completeness, correct OC/period, actual versus plan, missing cost, profitability, drill-down, factory performance and exception ownership. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

No longer merely an AI chatbot. WS1 Finance Q&A (Balance Sheet, P&L, management Q&A) is the foundation; WS2 OC / Cost Control remains the main focus (missing cost, incorrect period, BOM/material, overhead, subcontracting, abnormal margin, duplicate/missing transactions, actual vs plan, invoice/posting completeness); WS3 Factory Performance has now started (Group -> Company -> Region -> Factory -> Production -> Labor -> Cost -> Efficiency). Databricks / DWH access and validated sources remain the key dependency.

### Current Risks

- Databricks / DWH access
- Source ownership and lineage
- Rule and threshold approval
- Incorrect OC linkage

### Dependencies

- WFX / Databricks / DWH -> Finance source control -> Rule Engine -> OC control -> Factory performance -> Power BI / AI

### Next Actions

- Finalize the WS2 Rule Catalogue and thresholds
- Obtain read-only Databricks access and confirm catalog/schema/table lineage
- Select a Golden OC and run the rules
- Reconcile results with Accounting and finalize exception severity
- Advance WS3 factory-performance source discovery and dimensions (headcount, labor cost, overtime, output, capacity, budget vs actual)
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Decision Log

| Decision ID | Decision Needed | Status | Decision Owner | Decision / Date | Source |
| --- | --- | --- | --- | --- | --- |
| DEC-001 | Define official Databricks access governance. | Open | Needs Confirmation | TBD | PPJ-WEEKLY-20260727-20260801 |
| DEC-002 | Approve Accounting rules and thresholds. | Open | Needs Confirmation | TBD | PPJ-WEEKLY-20260727-20260801 |
| DEC-003 | Confirm source owners and sources of truth. | Open | Needs Confirmation | TBD | PPJ-WEEKLY-20260727-20260801 |

## Evidence Basis

- Root project note: [[../FIN.AI.FINANCE.MANAGEMENT.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/FIN.AI.FINANCE.MANAGEMENT.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
