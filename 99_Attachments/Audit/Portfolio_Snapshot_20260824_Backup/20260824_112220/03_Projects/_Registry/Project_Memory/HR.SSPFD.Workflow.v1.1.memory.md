---
type: project_memory
project_name: "HR.SSPFD.Workflow.v1.1"
project_file: "HR.SS&PFD.v1.1.md"
project_code: "HR.SSPFD.Workflow.v1.1"
department: "HR"
cluster: "HR / Internal Process"
phase: "Production Rollout / Stabilization"
last_verified: "2026-08-24"
confidence: "Strong"
canonical_code: "HR.SSPFD.Workflow.v1.1"
current_file: "HR.SS&PFD.v1.1.md"
primary_domain: "HR"
primary_capability: "Employee, payroll, BHXH and HR-sensitive workflows"
secondary_domains: "WISER, BHXH, Sensitive HR Data"
lifecycle: "Production"
progress: "TBD"
current_gate: "Production rollout and data-quality monitoring"
status: "Production Rollout / Stabilization"
current_outcome: "Standardize employee data into a trusted Employee Master and support applicant extraction/prefill."
latest_update_summary: "Demo, UAT, User Manual, production deployment and group rollout were achieved. BHXH audit is historical context, not the primary current capability."
known_risks: "Sensitive HR data | Data-quality consistency across companies/factories"
decisions_needed: "None recorded"
next_actions: "Monitor rollout by company/factory | Track standardization, missing-field, duplicate and matching-success KPIs | Stabilize applicant extraction and prefill workflow"
priority: "P8"
recent_update_events: ["PPJ-WEEKLY-20260713-20260718", "PPJ-WEEKLY-20260727-20260801"]
known_blockers: "Production-support ownership across HR, Software Team, AI Team and HR IT is not confirmed. | Conflicting-record correction authority is unclear."
dependencies: "None recorded"
workspace_path: "03_Projects/HR.SS&PFD.v1.1"
project_home: "03_Projects/HR.SS&PFD.v1.1/00_Project_Home.md"
project_board: "03_Projects/HR.SS&PFD.v1.1/Project_Executive_Board.canvas"
task_folder: "03_Projects/HR.SS&PFD.v1.1/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | HR.SSPFD.Workflow.v1.1 |
| Primary Domain | HR |
| Lifecycle | Production |
| Progress | TBD |
| Current Gate | Production rollout and data-quality monitoring |
| Priority | P8 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Standardize employee data into a trusted Employee Master and support applicant extraction/prefill.

## Current Capability

Employee Data Collection -> Validation -> CCCD/Employee ID Matching -> Deduplication -> Standardization -> Employee Master; plus applicant extraction/prefill.

## Latest Update

Demo, UAT, User Manual, production deployment and group rollout were achieved. BHXH audit is historical context, not the primary current capability.

## Risks / Blockers

- Sensitive HR data
- Data-quality consistency across companies/factories

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Monitor rollout by company/factory
- Track standardization, missing-field, duplicate and matching-success KPIs
- Stabilize applicant extraction and prefill workflow

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[HR.SS&PFD.v1.1/00_Project_Home|Project Home]]
- [[HR.SS&PFD.v1.1/Project_Executive_Board|Project Executive Board]]
- [[HR.SS&PFD.v1.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Memory: HR.SSPFD.Workflow.v1.1

## One-Line Understanding

HR/BHXH workflow requiring latest 3-month WISER data and field-level mapping.

## Current Outcome

Prepare structured HR process/reporting support after data and meaning are confirmed.

## Latest Update Summary

Canonical naming populated and tied to HR/BHXH WISER data context.

## What This Project Is

HR internal process/data project for SS&PFD/BHXH-related workflow.

## What This Project Is Not

Not fully defined beyond WISER data need unless HR confirms scope.

## Key Users

HR users.

## Systems / Data

WISER data, HR/BHXH fields, latest three months data.

## Known Risks / Blockers

Acronym meaning and exact process scope need confirmation.

## Next Actions

Collect latest 3-month WISER dataset and confirm field meaning.

## Do Not Drift Rules

- Do not expand SS&PFD meaning beyond evidence.
- Keep HR/BHXH data confirmation as blocker.

## Source Links

- [[HR.SS&PFD.v1.1]]
- [[PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY]]

<!-- PPJ_DOMAIN_GOVERNANCE_START -->
## Domain Governance

- Canonical Code: HR.SSPFD.Workflow.v1.1
- Current File: [[HR.SS&PFD.v1.1]]
- Primary Domain: HR
- Secondary Domains: WISER, BHXH, Sensitive HR Data
- Lifecycle: Production Rollout / Stabilization
- Progress: TBD
- Current Gate: UAT Completed / Initial Deployment / Group Rollout

## Domain Do Not Drift Rules
- Do not expand SS&PFD without evidence; HR data is sensitive.
<!-- PPJ_DOMAIN_GOVERNANCE_END -->

## Recent Update Events

| Date | Update Type | Summary | Source | Confidence |
| --- | --- | --- | --- | --- |
| 2026-08-01 | Weekly Portfolio Update | Demo, UAT, initial testing and User Manual were completed. Deployment started, including group-wide employee-data standardization rollout. The project now contains employee master-data standardization and applicant data extraction/prefill workflows. | PPJ-WEEKLY-20260727-20260801 | Strong |
| 2026-07-18 | Weekly Portfolio Update | Stakeholders agreed the solution is more appropriate for transfer to the Software Team because it behaves as a business application, workflow management, data-processing software, rule-based validation and user-facing system rather than an AI-led initiative. The project is pending handover and is not completed or closed. | PPJ-WEEKLY-20260713-20260718 | Strong |
