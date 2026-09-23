---
type: "project_profile"
project: "HR.SSPFD.Workflow.v1.1"
source_project: "HR.SS&PFD.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-09-18

| Field | Value |
| --- | --- |
| Canonical Code | HR_EmployeeDataPlatform_v1.1.0 |
| Domain | HR |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Production / Expansion |
| Status | Active |
| Progress | TBD |
| Gate | Production rollout and data-quality monitoring |
| Priority | P8 |
| Outcome | Standardize employee data into a trusted Employee Master and Group HR Data Foundation, and support applicant extraction/prefill. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

The old name no longer represents the current purpose: Employee Data Collection -> Validation -> Standardization -> Employee Master -> Group HR Data Foundation. Key controls: duplicate employees, missing fields, company mapping, organizational mapping, payroll-sensitive information, permissions, history and ownership.

### Current Risks

- Sensitive HR data
- Data-quality consistency across companies/factories

### Dependencies

- None recorded in the current portfolio snapshot.

### Next Actions

- Monitor rollout by company/factory
- Track standardization, missing-field, duplicate and matching-success KPIs
- Stabilize applicant extraction and prefill workflow
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Profile

## Identity

| Field | Value |
| --- | --- |
| Canonical Code | HR.SSPFD.Workflow.v1.1 |
| Physical Project Note | HR.SS&PFD.v1.1.md |
| Primary Domain | HR |
| Cluster | HR / Internal Process |
| Lifecycle Class | C. Production / Maintenance |
| Lifecycle | Production Rollout / Stabilization |
| Current Gate | UAT Completed / Initial Deployment / Group Rollout |
| Priority | TBD |
| Business Owner | Needs Confirmation |

## One-Line Understanding

HR/BHXH workflow requiring latest 3-month WISER data and field-level mapping.

## Intended Outcome

Group employee master-data standardization and applicant-data extraction/application-form prefill workflows.

## Users and Delivery Participants

- Primary users: HR; production owner Needs Confirmation
- BA / Coordination: Khoa
- Technical members: Needs Confirmation

## Current Scope

- HR internal process/data project for SS&PFD/BHXH-related workflow.

## Explicit Boundaries

- Not fully defined beyond WISER data need unless HR confirms scope.

## Current Gate and Next Move

- Gate: UAT Completed / Initial Deployment / Group Rollout
- Next actions: Monitor rollout by company and factory.; Finalize employee matching and conflict-handling rules.; Monitor rollout issues, fix and retest.; Build rollout-status dashboard and complete Workflow 2 user guidance.; Confirm production-support handover.

## Evidence Basis

- Root project note: [[../HR.SS&PFD.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/HR.SSPFD.Workflow.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
