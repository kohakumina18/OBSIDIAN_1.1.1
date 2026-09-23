---
type: project_memory
project_name: "FIN.AI.FINANCE.MANAGEMENT.v1.1"
project_file: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
project_code: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
department: "Finance / Management"
cluster: "Finance / Management Insight / AI Analytics"
phase: "Analysis / Design"
status: "Analysis / Design"
priority: "P1"
business_owner: "Finance / Management"
ba_coordination: ["Khoa"]
technical_members: ["IT / Data team", "AI Automation team"]
stakeholders:
  [
    "Madame Hồng Phương",
    "Finance team",
    "Accounting team",
    "Management team",
    "IT / Data team",
    "Khoa",
  ]
systems: ["ERP", "Excel", "Accounting system", "Bank statement", "DWH"]
data_sources:
  ["Finance reports", "Cash flow data", "Accounting files", "Bank statements"]
last_verified: "2026-08-01"
confidence: "Strong"
canonical_code: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
current_file: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
primary_domain: "Finance / Accounting"
primary_capability: "Financial analysis, reporting, invoices, GRN"
secondary_domains: "Data, IT, Sales, Management"
lifecycle: "Analysis / Design"
progress: "TBD"
current_gate: "Data Discovery / Databricks Access Blocked / Rule Engine Design"
current_outcome: "Centralized financial control and analysis platform for OC cost completeness, exception detection, order effectiveness, drill-down reporting, Power BI and AI-assisted analysis."
latest_update_summary: "Workstream 2 source inventory is nearly complete and Workstream 3 factory drill-down is partially covered. Most required sources appear to exist in Databricks rather than the governed DWH. Rule Engine groups now cover materials and trims, subcontracting, and order effectiveness."
known_risks: "Required data is outside the currently governed DWH. | OC linking keys may be incomplete. | Accounting approval and warning thresholds are pending. | Workstream 3 could expand before Workstream 2 stabilizes."
decisions_needed: "Define official Databricks access governance. | Approve Accounting rules and thresholds. | Confirm source owners and sources of truth."
next_actions: "Follow up Databricks account approval and confirm account, role, catalog, schema, table and read-only permission. | Complete Workstream 2 Source Inventory and profile each source. | Confirm OC linking keys and finalize the Rule Engine Catalogue. | Select 20-30 sample OCs and compare Rule Engine results with manual Accounting controls. | Do not expand Workstream 3 before Workstream 2 stabilizes."
recent_update_events: ["PPJ-WEEKLY-20260713-20260718", "PPJ-WEEKLY-20260727-20260801"]
proposed_canonical_code: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
version_migration_status: "Pending Confirmation"
known_blockers: "Approved Databricks account and read permission are not available. | Source table, schema, grain, linking key and source owner are not fully confirmed."
dependencies: ["Databricks Sources -> Finance Source Inventory -> Data Profiling -> Rule Engine -> OC Exception Detection -> Accounting Validation"]
---

# Project Memory: FIN.AI.FINANCE.MANAGEMENT.v1.1

## One-Line Understanding

Early-stage AI-assisted Finance Management initiative to explore cash-flow analysis, finance reporting assistant, forecasting, and management insight use cases.

## Business Meaning

Helps Finance / Management clarify whether AI can support reporting, analysis, executive summary, cash-flow risk visibility, and decision insight.

## Outcome

After kick-off, define problem statement, process map, data sources, stakeholders, expected output, risks, and whether to pursue dashboard, report automation, AI assistant, or forecasting.

## What This Project Is

- Finance/Management discovery project.
- Kick-off preparation for AI/analytics use case shaping.
- Potential finance dashboard, reporting assistant, cash-flow analysis, AI finance agent, or forecasting platform.

## What This Project Is Not

- Not ready for development before discovery.
- Not a promise of forecasting accuracy.
- Not a finance-data chatbot until permissions and data model are clear.

## Key Users

Madame Hồng Phương, Finance team, Accounting team if data-related, Management team, IT/Data team, Khoa / AI Automation team.

## Systems / Data

ERP, Excel, accounting system, bank statement, DWH, internal finance files, chart of accounts, cost center, department mapping.

## Current Phase / Status

Idea / Kick-off Preparation. Proposed kick-off: 04/07/2026, 09:00-11:00.

## Known Risks

- Sensitive finance data.
- Fragmented source data.
- Mapping needed before AI.
- Forecasting requires clean historical data.
- Finance owner must confirm business rules and output.

## Decisions Needed

- Desired output: dashboard, report automation, chatbot, forecast, or insight memo.
- Data allowed for AI.
- Security and permission model.
- Review/decision owner.

## Next Actions

- Send meeting invitation.
- Confirm participants.
- Prepare agenda and discovery checklist.
- Write meeting minutes and propose v1.1 scope after kick-off.

## Do Not Drift Rules

- Do not go directly to development.
- Do not promise AI forecast accuracy before data assessment.
- Do not expose finance data without permission controls.

## Source Links

- [[FIN.AI.FINANCE.MANAGEMENT.v1.1]]

<!-- PPJ_DOMAIN_GOVERNANCE_START -->
## Domain Governance

- Canonical Code: FIN.AI.FINANCE.MANAGEMENT.v1.2
- Current File: [[FIN.AI.FINANCE.MANAGEMENT.v1.1]]
- Primary Domain: Finance / Accounting
- Secondary Domains: Data, IT, Sales, Management
- Lifecycle: Analysis / Design
- Progress: TBD
- Current Gate: Data Discovery / Databricks Access Blocked / Rule Engine Design

## Domain Do Not Drift Rules
- Do not move to development before discovery and permission confirmation.
<!-- PPJ_DOMAIN_GOVERNANCE_END -->

## Recent Update Events

| Date | Update Type | Summary | Source | Confidence |
| --- | --- | --- | --- | --- |
| 2026-08-01 | Weekly Portfolio Update | Workstream 2 source inventory is nearly complete and Workstream 3 factory drill-down is partially covered. Most required sources appear to exist in Databricks rather than the governed DWH. Rule Engine groups now cover materials and trims, subcontracting, and order effectiveness. | PPJ-WEEKLY-20260727-20260801 | Strong |
| 2026-07-18 | Weekly Portfolio Update | After the 2026-07-17 discussion, the project was repositioned from a standalone chatbot/reporting initiative into a centralized financial-control platform. The operating sequence is Data Control -> Exception Handling -> Trusted Data Confirmation -> Reporting -> Analysis -> AI-assisted Q&A. MVP covers materials and trims, subcontracting, basic overhead, correct OC/period posting, missing cost detection, exception assignment, automatic recheck, and evidence traceability. | PPJ-WEEKLY-20260713-20260718 | Strong |



