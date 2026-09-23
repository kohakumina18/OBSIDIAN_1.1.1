---
type: "integration_spec"
project: "HR.SSPFD.Workflow.v1.1"
source_project: "HR.SS&PFD.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Integration Specification

## Integration Status

Current Working Document

## Known Systems and Dependencies

- Systems: WISER data, HR/BHXH fields, latest three months data.
- Dependencies: Employee source data -> Matching Rules -> Trusted Employee Master -> Group Rollout; Applicant Input -> Extraction -> Mandatory-field Validation -> Prefill -> Review -> Structured Submission

## Required Integration Contract

| Area | Requirement | Current Evidence |
| --- | --- | --- |
| Trigger | Define approved event, schedule or user action | Needs Confirmation |
| API / Service | Use approved API or service boundary | Needs Confirmation |
| Validation | Validate identity, input, state and business rules | Needs Confirmation |
| Idempotency | Prevent duplicate processing where transactions are involved | Required |
| Approval | Define human/system approval boundary | Needs Confirmation |
| Rollback | Define safe reversal or compensation | Required |
| Exception Handling | Log, route and retry only through approved behavior | Needs Confirmation |
| Audit Log | Retain request, result, actor, timestamp and status | Required |
| Fallback | Preserve approved manual or support path | Needs Confirmation |

## Transaction Safety Rule

A direct database write is not assumed to update a transactional system. WFX changes require an approved API or vendor-supported transactional service.

## Evidence Basis

- Root project note: [[../HR.SS&PFD.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/HR.SSPFD.Workflow.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
