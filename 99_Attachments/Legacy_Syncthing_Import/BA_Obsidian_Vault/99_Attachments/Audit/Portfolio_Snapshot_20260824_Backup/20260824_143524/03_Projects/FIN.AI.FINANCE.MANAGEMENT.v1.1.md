---
type: "project"
project_name: "FIN.AI.FINANCE.MANAGEMENT.v1.1"
phase: "ANALYSIS"
cluster: "Finance / Management Insight / AI Analytics"
owner: "Finance / Management"
project_code: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
status: "Active"
priority: "P1"
phase_canvas_group: "ANALYSIS"
last_updated: "2026-07-06 08:53:49"
last_weekly_update: "2026-06-29 to 2026-07-05"
weekly_rank: "1"
canonical_code: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
current_file: "FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
primary_domain: "Finance / Accounting"
lifecycle: "Strategic Active"
progress: "TBD"
current_gate: "WS2 Rule Catalogue and Databricks access; then WS3 source discovery"
last_verified: "2026-08-24"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
proposed_canonical_code: "FIN.AI.FINANCE.MANAGEMENT.v1.2"
version_migration_status: "Pending Confirmation"
dependencies: ["Databricks Sources -> Finance Source Inventory -> Data Profiling -> Rule Engine -> OC Exception Detection -> Accounting Validation"]
delivery_stage: "ANALYSIS"
stage_entered_date: "Needs Confirmation"
---

# AI-assisted Finance Management

Tên tiếng Việt: Dự án AI hỗ trợ quản trị tài chính

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | FIN.AI.FINANCE.MANAGEMENT.v1.2 |
| Primary Domain | Finance / Accounting |
| Delivery Stage | ANALYSIS |
| Lifecycle | Strategic Active |
| Status | Active |
| Progress | TBD |
| Current Gate | WS2 Rule Catalogue and Databricks access; then WS3 source discovery |
| Priority | P1 |
| Business Owner | Accounting |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Centralized Finance Control Platform for completeness, correct OC/period, actual versus plan, missing cost, profitability, drill-down and exception ownership.

## Current Capability

WS1 Financial Reporting/Closing Foundation (completed); WS2 OC Cost Control and Order Performance (advanced); WS3 Factory Performance Analysis (remaining).

## Latest Update

WS1 is complete and in operational support; WS2 rules are mostly consolidated and remain the main active focus; WS3 is the remaining major program scope.

## Risks / Blockers

- Databricks access
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
- Begin WS3 factory-performance source discovery

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[FIN.AI.FINANCE.MANAGEMENT.v1.1/00_Project_Home|Project Home]]
- [[FIN.AI.FINANCE.MANAGEMENT.v1.1/Project_Executive_Board|Project Executive Board]]
- [[FIN.AI.FINANCE.MANAGEMENT.v1.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong

<!-- PPJ_PROJECT_KNOWLEDGE_END -->

<!-- PPJ_WEEKLY_UPDATE_20260629_20260705_START -->
## Weekly Update - 2026-06-29 to 2026-07-05

- Project code: $(@{Code=FIN.AI.FINANCE.MANAGEMENT.v1.1; Note=03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1.md; Phase=Discovery / BRD / Strategic Program; Lane=ANALYSIS; Priority=P1 / Top Focus; Rank=1; CreateIfMissing=False; Summary=Official kick-off completed on 2026-07-04. Scope corrected: this is not a generic AI Finance or Cash Flow Analytics MVP. Current program has three workstreams: Financial Reporting Automation as MVP P1, Costing Analysis, and Order / Sales Efficiency Analysis. MVP principle is One Company + One Period + One Approved Financial Report. Automated output must reconcile with the manual approved Finance report, or differences must be explainable. Data first, AI second. Finance owns finance logic.}.Code)
- Phase: Discovery / BRD / Strategic Program
- Executive Canvas lane: ANALYSIS
- Priority: P1 / Top Focus
- Weekly priority rank: 1

Official kick-off completed on 2026-07-04. Scope corrected: this is not a generic AI Finance or Cash Flow Analytics MVP. Current program has three workstreams: Financial Reporting Automation as MVP P1, Costing Analysis, and Order / Sales Efficiency Analysis. MVP principle is One Company + One Period + One Approved Financial Report. Automated output must reconcile with the manual approved Finance report, or differences must be explainable. Data first, AI second. Finance owns finance logic.

Related Concepts
[[Outcome Driven Thinking]]
[[System Thinking]]
[[Data Governance]]
[[Traceability]]

Methods
[[Impact Analysis]]
[[Requirement Elicitation]]
[[Data Mapping]]

Deliverables
[[Decision_Driven_BRD]]
[[ERD_Template]]
[[User_Manual_Template]]

<!-- PPJ_WEEKLY_UPDATE_20260629_20260705_END -->
