---
type: project_memory
project_name: "HR.SSPFD.Workflow.v1.1"
project_file: "HR.SS&PFD.v1.1.md"
project_code: "HR.SSPFD.Workflow.v1.1"
department: "HR"
cluster: "HR / Internal Process"
phase: "Production Rollout / Stabilization"
last_verified: "2026-08-01"
confidence: "Strong"
canonical_code: "HR.SSPFD.Workflow.v1.1"
current_file: "HR.SS&PFD.v1.1.md"
primary_domain: "HR"
primary_capability: "Employee, payroll, BHXH and HR-sensitive workflows"
secondary_domains: "WISER, BHXH, Sensitive HR Data"
lifecycle: "Production Rollout / Stabilization"
progress: "TBD"
current_gate: "UAT Completed / Initial Deployment / Group Rollout"
status: "Production Rollout / Stabilization"
current_outcome: "Group employee master-data standardization and applicant-data extraction/application-form prefill workflows."
latest_update_summary: "Demo, UAT, initial testing and User Manual were completed. Deployment started, including group-wide employee-data standardization rollout. The project now contains employee master-data standardization and applicant data extraction/prefill workflows."
known_risks: "Sensitive HR and applicant data require strict permissions. | Incorrect matching may merge unrelated employee records. | Applicant consent and privacy controls require confirmation."
decisions_needed: "Assign production owner and correction authority. | Approve applicant consent and privacy controls. | Confirm post-rollout support boundary."
next_actions: "Monitor rollout by company and factory. | Finalize employee matching and conflict-handling rules. | Monitor rollout issues, fix and retest. | Build rollout-status dashboard and complete Workflow 2 user guidance. | Confirm production-support handover."
priority: "P5"
recent_update_events: ["PPJ-WEEKLY-20260713-20260718", "PPJ-WEEKLY-20260727-20260801"]
known_blockers: "Production-support ownership across HR, Software Team, AI Team and HR IT is not confirmed. | Conflicting-record correction authority is unclear."
dependencies: ["Employee source data -> Matching Rules -> Trusted Employee Master -> Group Rollout", "Applicant Input -> Extraction -> Mandatory-field Validation -> Prefill -> Review -> Structured Submission"]
---

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



