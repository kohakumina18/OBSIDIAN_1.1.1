---
type: "integration_spec"
project: "CPD.Datamart.v1.1"
source_project: "CPD.Datamart.v1.1.md"
source_event: "Canonical naming populated"
last_verified: "2026-07-13"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Integration Specification

## Integration Status

Current Working Document

## Known Systems and Dependencies

- Systems: Image search, 3D sample library, Image search, visual sample assets, 3D sample library metadata, sample categories, image/3D references.
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

- Root project note: [[../CPD.Datamart.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/CPD.Datamart.v1.1.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-07-13
- Confidence: Strong
