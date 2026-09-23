---
type: project
project_name: "HR Project"
cluster: "Governance"
status: "Active"
priority: "P8"
project_code: "HR_EmployeeDataPlatform_v1.1.0"
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
canonical_code: "HR_EmployeeDataPlatform_v1.1.0"
current_file: "HR.SS&PFD.v1.1.md"
primary_domain: "HR"
lifecycle: "Production / Expansion"
current_gate: "Production rollout and data-quality monitoring"
last_verified: "2026-09-18"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
dependencies: ["Employee source data -> Matching Rules -> Trusted Employee Master -> Group Rollout", "Applicant Input -> Extraction -> Mandatory-field Validation -> Prefill -> Review -> Structured Submission"]
delivery_stage: "GO-LIVE / PRODUCTION / SUPPORT"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | HR_EmployeeDataPlatform_v1.1.0 |
| Legacy Code(s) | HR.SSPFD.Workflow.v1.1; HR.SS&PFD.v1.1 |
| Primary Domain | HR |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Production / Expansion |
| Status | Active |
| Progress | TBD |
| Current Gate | Production rollout and data-quality monitoring |
| Priority | P8 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

Standardize employee data into a trusted Employee Master and Group HR Data Foundation, and support applicant extraction/prefill.

## Current Capability

Employee Data Collection -> Validation -> Standardization -> Employee Master -> Group HR Data Foundation; plus applicant extraction/prefill.

## Latest Update

The old name no longer represents the current purpose: Employee Data Collection -> Validation -> Standardization -> Employee Master -> Group HR Data Foundation. Key controls: duplicate employees, missing fields, company mapping, organizational mapping, payroll-sensitive information, permissions, history and ownership.

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
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[HR.SS&PFD.v1.1/00_Project_Home|Project Home]]
- [[HR.SS&PFD.v1.1/Project_Executive_Board|Project Executive Board]]
- [[HR.SS&PFD.v1.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong

<!-- PPJ_PROJECT_KNOWLEDGE_END -->
