---
type: "data_spec"
project: "COSTING.AGENTIC.PLATFORM.v1.1"
source_project: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Data Specification

## Architecture Separation

Business Source -> Data Warehouse / Data Platform -> Target Application

These layers must remain conceptually separate. WFX, Databricks and the governed Data Warehouse are not interchangeable.

## Known Systems

- Sketch, techpack, sample image, buyer reference, BOM, construction, wash, historical costing, quote history.

## Field-Level Specification

| Business Object | Field | Business Definition | Source System | Source Table / API if confirmed | Source Field | Grain | Transformation | Target Field | Owner | Data Quality Rule | Traceability | Confidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Link to source evidence | Needs Confirmation |

## Source Table Rule

No WFX table, Databricks schema, warehouse table or API is assumed. Unknown source tables remain Needs Confirmation.

## Evidence Basis

- Root project note: [[../PPJ.COSTING.AGENT.PLATFORM.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/COSTING.AGENTIC.PLATFORM.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
