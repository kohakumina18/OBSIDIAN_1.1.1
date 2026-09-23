---
type: "project_profile"
project: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
source_project: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
source_event: "PPJ-EXECUTIVE-CANVAS-SYNC-20260824_144054"
last_verified: "2026-08-24"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
phase: "DESIGN"
delivery_stream: "INTERNAL DEVELOPMENT"
delivery_stage: "DESIGN"
lifecycle: "Design"
status: "Active"
current_gate: "WS2 Rule Catalogue and Databricks access; then WS3 source discovery"
stage_entered_date: "2026-08-24"
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

# Project Profile

## Identity

| Field | Value |
| --- | --- |
| Canonical Code | FIN.AI.FINANCE.MANAGEMENT.v1.2 |
| Physical Project Note | FIN.AI.FINANCE.MANAGEMENT.v1.1.md |
| Primary Domain | Finance / Accounting |
| Cluster | Finance / Management Insight / AI Analytics |
| Lifecycle Class | A. Active / Delivery |
| Lifecycle | Analysis / Design |
| Current Gate | Data Discovery / Databricks Access Blocked / Rule Engine Design |
| Priority | P1 |
| Business Owner | Finance / Management |

## One-Line Understanding

Early-stage AI-assisted Finance Management initiative to explore cash-flow analysis, finance reporting assistant, forecasting, and management insight use cases.

## Intended Outcome

Centralized financial control and analysis platform for OC cost completeness, exception detection, order effectiveness, drill-down reporting, Power BI and AI-assisted analysis.

## Users and Delivery Participants

- Primary users: Accounting; data-access governance owner Needs Confirmation
- BA / Coordination: Khoa
- Technical members: IT / Data team, AI Automation team, IT / Data / AI

## Current Scope

- Finance/Management discovery project.
- Kick-off preparation for AI/analytics use case shaping.
- Potential finance dashboard, reporting assistant, cash-flow analysis, AI finance agent, or forecasting platform.

## Explicit Boundaries

- Not ready for development before discovery.
- Not a promise of forecasting accuracy.
- Not a finance-data chatbot until permissions and data model are clear.

## Current Gate and Next Move

- Gate: Data Discovery / Databricks Access Blocked / Rule Engine Design
- Next actions: Follow up Databricks account approval and confirm account, role, catalog, schema, table and read-only permission.; Complete Workstream 2 Source Inventory and profile each source.; Confirm OC linking keys and finalize the Rule Engine Catalogue.; Select 20-30 sample OCs and compare Rule Engine results with manual Accounting controls.; Do not expand Workstream 3 before Workstream 2 stabilizes.

## Evidence Basis

- Root project note: [[../FIN.AI.FINANCE.MANAGEMENT.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/FIN.AI.FINANCE.MANAGEMENT.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
