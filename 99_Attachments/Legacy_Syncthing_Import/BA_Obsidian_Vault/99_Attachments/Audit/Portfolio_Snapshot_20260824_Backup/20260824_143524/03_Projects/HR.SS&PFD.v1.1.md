---
type: project
project_name: "HR Project"
cluster: "Governance"
status: "Active"
priority: "P8"
project_code: "HR.SSPFD.Workflow.v1.1"
department: "HR"
object: "Inferred from filename"
project_characteristic: "HR workflow"
version: "v1.1"
phase: "GO-LIVE / PRODUCTION / SUPPORT"
owner: "TBD"
business_owner: "TBD"
technical_owner: "TBD"
members: []
stakeholders: []
systems: []
data_sources: []
progress: "TBD"
blocked: "TBD"
decision_needed: "TBD"
next_action: "TBD"
last_updated: "2026-06-28"
confidence: "Strong"
source_files: []
canonical_code: "HR.SSPFD.Workflow.v1.1"
current_file: "HR.SS&PFD.v1.1.md"
primary_domain: "HR"
lifecycle: "Production"
current_gate: "Production rollout and data-quality monitoring"
last_verified: "2026-08-24"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
dependencies: ["Employee source data -> Matching Rules -> Trusted Employee Master -> Group Rollout", "Applicant Input -> Extraction -> Mandatory-field Validation -> Prefill -> Review -> Structured Submission"]
delivery_stage: "GO-LIVE / PRODUCTION / SUPPORT"
stage_entered_date: "Needs Confirmation"
---

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | HR.SSPFD.Workflow.v1.1 |
| Primary Domain | HR |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Production |
| Status | Active |
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

<!-- PPJ_PROJECT_KNOWLEDGE_END -->
