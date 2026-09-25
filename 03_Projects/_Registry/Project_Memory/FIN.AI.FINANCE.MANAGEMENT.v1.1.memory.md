---
type: project_memory
project_name: "FIN.AI.FINANCE.MANAGEMENT.v1.1"
project_file: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
project_code: "FIN_FinanceManagement_v1.2.0"
department: "Finance / Management"
cluster: "Finance / Management Insight / AI Analytics"
phase: "DESIGN"
status: "Active"
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
last_verified: "2026-09-18"
confidence: "Strong"
canonical_code: "FIN_FinanceManagement_v1.2.0"
current_file: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
primary_domain: "Finance / Accounting"
primary_capability: "Financial analysis, reporting, invoices, GRN"
secondary_domains: "Data, IT, Sales, Management"
lifecycle: "Strategic Active"
progress: "TBD"
current_gate: "WS2 OC / Cost Control and WS3 Factory Performance"
current_outcome: "Centralized Finance Control Platform for completeness, correct OC/period, actual versus plan, missing cost, profitability, drill-down, factory performance and exception ownership."
latest_update_summary: "No longer merely an AI chatbot. WS1 Finance Q&A (Balance Sheet, P&L, management Q&A) is the foundation; WS2 OC / Cost Control remains the main focus (missing cost, incorrect period, BOM/material, overhead, subcontracting, abnormal margin, duplicate/missing transactions, actual vs plan, invoice/posting completeness); WS3 Factory Performance has now started (Group -> Company -> Region -> Factory -> Production -> Labor -> Cost -> Efficiency). Databricks / DWH access and validated sources remain the key dependency."
known_risks: "Databricks / DWH access | Source ownership and lineage | Rule and threshold approval | Incorrect OC linkage"
decisions_needed: "Approve WS2 thresholds and exception severity | Confirm governed sources of truth | Choose the variance threshold that replaces 5% (Finance / Control)"
next_actions: "Finalize the WS2 Rule Catalogue and thresholds | Obtain read-only Databricks access and confirm catalog/schema/table lineage | Select a Golden OC and run the rules | Reconcile results with Accounting and finalize exception severity | Advance WS3 factory-performance source discovery and dimensions (headcount, labor cost, overtime, output, capacity, budget vs actual)"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260918"]
proposed_canonical_code: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
version_migration_status: "Pending Confirmation"
known_blockers: "Databricks / DWH access | Source ownership and lineage | Rule and threshold approval | Incorrect OC linkage"
dependencies: "WFX / Databricks / DWH -> Finance source control -> Rule Engine -> OC control -> Factory performance -> Power BI / AI"
workspace_path: "03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1"
project_home: "03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1/00_Project_Home.md"
project_board: "03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1/Project_Executive_Board.canvas"
task_folder: "03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
delivery_stage: "DESIGN"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_START -->
## Executive Delivery State

| Field | Current |
|---|---|
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DESIGN |
| Detailed Lifecycle | Design |
| Status | Active |
| Current Gate | WS2 Rule Catalogue and Databricks access; then WS3 source discovery |
| Stage Entered | 2026-08-24 |
| Last Verified | 2026-08-24 |
<!-- PPJ_EXECUTIVE_DELIVERY_STAGE_END -->

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | FIN_FinanceManagement_v1.2.0 |
| Legacy Code(s) | FIN.AI.FINANCE.MANAGEMENT.v1.2; FIN.AI.FINANCE.MANAGEMENT.v1.1 |
| Primary Domain | Finance / Accounting |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DESIGN |
| Lifecycle | Strategic Active |
| Status | Active |
| Progress | TBD |
| Current Gate | WS2 OC / Cost Control and WS3 Factory Performance |
| Priority | P1 |
| Business Owner | Accounting |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

Centralized Finance Control Platform for completeness, correct OC/period, actual versus plan, missing cost, profitability, drill-down, factory performance and exception ownership.

## Current Capability

WS1 Finance Q&A (foundation); WS2 OC & Cost Control (main focus); WS3 Factory Performance (started).

## Latest Update

No longer merely an AI chatbot. WS1 Finance Q&A (Balance Sheet, P&L, management Q&A) is the foundation; WS2 OC / Cost Control remains the main focus (missing cost, incorrect period, BOM/material, overhead, subcontracting, abnormal margin, duplicate/missing transactions, actual vs plan, invoice/posting completeness); WS3 Factory Performance has now started (Group -> Company -> Region -> Factory -> Production -> Labor -> Cost -> Efficiency). Databricks / DWH access and validated sources remain the key dependency.

## Risks / Blockers

- Databricks / DWH access
- Source ownership and lineage
- Rule and threshold approval
- Incorrect OC linkage

## Decisions Needed

- Approve WS2 thresholds and exception severity
- Confirm governed sources of truth

## Dependencies

- WFX / Databricks / DWH -> Finance source control -> Rule Engine -> OC control -> Factory performance -> Power BI / AI

## Next Actions

- Finalize the WS2 Rule Catalogue and thresholds
- Obtain read-only Databricks access and confirm catalog/schema/table lineage
- Select a Golden OC and run the rules
- Reconcile results with Accounting and finalize exception severity
- Advance WS3 factory-performance source discovery and dimensions (headcount, labor cost, overtime, output, capacity, budget vs actual)

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[FIN.AI.FINANCE.MANAGEMENT.v1.1/00_Project_Home|Project Home]]
- [[FIN.AI.FINANCE.MANAGEMENT.v1.1/Project_Executive_Board|Project Executive Board]]
- [[FIN.AI.FINANCE.MANAGEMENT.v1.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

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
| 2026-09-24 | BOD Review | OC profitability is compared only for OCs shipped in the period. 177 OCs show cost and revenue in different periods. The 5% variance threshold is too tight (5.01-5.3% flagged, dashboard almost all red); no replacement value chosen. Variance is to be split into material, processing and overhead; overhead exists only per month. Company filter exists; Division and Sales Group filters requested. | 08_Meeting_Notes/PPJ-PROJECTS-REPORT/BOD_REVIEW_20260924_Madame_Phuong | Strong |
| 2026-08-01 | Weekly Portfolio Update | Workstream 2 source inventory is nearly complete and Workstream 3 factory drill-down is partially covered. Most required sources appear to exist in Databricks rather than the governed DWH. Rule Engine groups now cover materials and trims, subcontracting, and order effectiveness. | PPJ-WEEKLY-20260727-20260801 | Strong |
| 2026-07-18 | Weekly Portfolio Update | After the 2026-07-17 discussion, the project was repositioned from a standalone chatbot/reporting initiative into a centralized financial-control platform. The operating sequence is Data Control -> Exception Handling -> Trusted Data Confirmation -> Reporting -> Analysis -> AI-assisted Q&A. MVP covers materials and trims, subcontracting, basic overhead, correct OC/period posting, missing cost detection, exception assignment, automatic recheck, and evidence traceability. | PPJ-WEEKLY-20260713-20260718 | Strong |
