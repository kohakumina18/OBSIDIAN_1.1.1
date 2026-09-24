---
type: "integration_spec"
project: "FD.Datamart.v2.2"
source_project: "FD.Datamart.v2.2.md"
source_event: "PPJ-WEEKLY-20260713-20260718"
last_verified: "2026-07-18"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Integration Specification

## Integration Status

Current Working Document

## Known Systems and Dependencies

- Systems: Directus, QR module, QR Format Designer, Directus, QR Format Designer, QR design or QR information module, fabric/sample/hanger data.
- Dependencies: Needs Confirmation

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

- Root project note: [[../FD.Datamart.v2.2]]
- Project memory: [[03_Projects/_Registry/Project_Memory/FD.Datamart.v2.2.memory]]
- Source event: PPJ-WEEKLY-20260713-20260718
- Last verified: 2026-07-18
- Confidence: Strong
