---
type: "integration_spec"
project: "PPJxDệt_Phú_Thọ"
source_project: "PPJxDệt_Phú_Thọ.md"
source_event: "PPJ-PROJECT-REGISTRATION-PPJxDệt_Phú_Thọ-20261112"
last_verified: "2026-11-12"
confidence: "Needs Confirmation"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Integration Specification

## Integration Status

Current Working Document

## Known Systems and Dependencies

- Systems: Needs Confirmation
- Dependencies: 100-question ERP discovery questionnaire and current-process/source-system evidence; responses pending

## Required Integration Contract

| Area | Requirement | Current Evidence |
| --- | --- | --- |
| Trigger | Define approved event, schedule or user action | Needs Confirmation |
| API / Service | Use approved API or service boundary | Needs Confirmation |
| Validation | Validate identity, input, state and business rules | Needs Confirmation |
| Idempotency | Prevent duplicate processing where transactions are involved | Assess Applicability |
| Approval | Define human/system approval boundary | Needs Confirmation |
| Rollback | Define safe reversal or compensation | Assess Applicability |
| Exception Handling | Log, route and retry only through approved behavior | Needs Confirmation |
| Audit Log | Retain request, result, actor, timestamp and status | Required |
| Fallback | Preserve approved manual or support path | Needs Confirmation |

## Transaction Safety Rule

A direct database write is not assumed to update a transactional system. WFX changes require an approved API or vendor-supported transactional service.

## Evidence Basis

- Root project note: [[03_Projects/PPJxDệt_Phú_Thọ]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PPJxDệt_Phú_Thọ.memory]]
- Source event: PPJ-PROJECT-REGISTRATION-PPJxDệt_Phú_Thọ-20261112
- Last verified: 2026-11-12
- Confidence: Needs Confirmation
