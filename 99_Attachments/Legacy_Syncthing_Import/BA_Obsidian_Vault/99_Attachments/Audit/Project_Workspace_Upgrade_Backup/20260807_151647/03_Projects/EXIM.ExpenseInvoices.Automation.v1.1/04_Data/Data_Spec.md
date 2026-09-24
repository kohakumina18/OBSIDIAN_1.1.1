---
type: "data_spec"
project: "EXIM.ExpenseInvoices.Automation.v1.1"
source_project: "EXIM.ExpenseInvoices.Automation.v1.1.md"
source_event: "Canonical naming populated"
last_verified: "2026-06-28"
confidence: "Strong for business concept; project note needs confirmation"
documentation_status: "Closed / Reference Only"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Data Specification

## Architecture Separation

Business Source -> Data Warehouse / Data Platform -> Target Application

These layers must remain conceptually separate. WFX, Databricks and the governed Data Warehouse are not interchangeable.

## Known Systems

- EXIM invoices, WFX, input/output mapping, exception cases.

## Field-Level Specification

| Business Object | Field | Business Definition | Source System | Source Table / API if confirmed | Source Field | Grain | Transformation | Target Field | Owner | Data Quality Rule | Traceability | Confidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Link to source evidence | Needs Confirmation |

## Source Table Rule

No WFX table, Databricks schema, warehouse table or API is assumed. Unknown source tables remain Needs Confirmation.

## Evidence Basis

- Root project note: [[../EXIM.ExpenseInvoices.Automation.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/EXIM.ExpenseInvoices.Automation.v1.1.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-06-28
- Confidence: Strong for business concept; project note needs confirmation
