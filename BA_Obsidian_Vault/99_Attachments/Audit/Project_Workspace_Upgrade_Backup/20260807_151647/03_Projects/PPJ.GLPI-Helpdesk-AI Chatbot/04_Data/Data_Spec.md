---
type: "data_spec"
project: "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"
source_project: "PPJ.GLPI-Helpdesk-AI Chatbot.md"
source_event: "Canonical naming populated"
last_verified: "2026-07-13"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Data Specification

## Architecture Separation

Business Source -> Data Warehouse / Data Platform -> Target Application

These layers must remain conceptually separate. WFX, Databricks and the governed Data Warehouse are not interchangeable.

## Known Systems

- GLPI ticket/knowledge base, IT/ERP FAQ, troubleshooting guides.

## Field-Level Specification

| Business Object | Field | Business Definition | Source System | Source Table / API if confirmed | Source Field | Grain | Transformation | Target Field | Owner | Data Quality Rule | Traceability | Confidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Needs Confirmation | Link to source evidence | Needs Confirmation |

## Source Table Rule

No WFX table, Databricks schema, warehouse table or API is assumed. Unknown source tables remain Needs Confirmation.

## Evidence Basis

- Root project note: [[../PPJ.GLPI-Helpdesk-AI Chatbot]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-07-13
- Confidence: Strong
