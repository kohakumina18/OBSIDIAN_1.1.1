---
type: "data_spec"
project: "MER.PO.Commit.v1.1"
source_project: "MER.PO-Commit.md"
source_event: "Canonical naming populated"
last_verified: "2026-07-13"
confidence: "Strong"
documentation_status: "Closed / Reference Only"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Data Specification

## Architecture Separation

Business Source -> Data Warehouse / Data Platform -> Target Application

These layers must remain conceptually separate. WFX, Databricks and the governed Data Warehouse are not interchangeable.

## Known Systems

- Customer PO, OC template, NPL file, Packing List, customer-specific formats.

## Field-Level Specification

| Business Object | Field | Business Definition | Source System | Source Table / API if confirmed | Source Field | Grain | Transformation | Target Field | Owner | Data Quality Rule | Traceability | Confidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Link to source evidence | Needs Confirmation |

## Source Table Rule

No WFX table, Databricks schema, warehouse table or API is assumed. Unknown source tables remain Needs Confirmation.

## Evidence Basis

- Root project note: [[../MER.PO-Commit]]
- Project memory: [[03_Projects/_Registry/Project_Memory/MER.PO.Commit.v1.1.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-07-13
- Confidence: Strong
