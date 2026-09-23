---
type: "integration_spec"
project: "EXIM.ExpenseInvoices.Automation.v1.1"
source_project: "EXIM.ExpenseInvoices.Automation.v1.1.md"
source_event: "Canonical naming populated"
last_verified: "2026-06-28"
confidence: "Strong for business concept; project note needs confirmation"
documentation_status: "Closed / Reference Only"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Integration Specification

## Integration Status

Closed / Reference Only

## Known Systems and Dependencies

- Systems: EXIM invoices, WFX, input/output mapping, exception cases.
- Dependencies: Needs Confirmation

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

- Root project note: [[../EXIM.ExpenseInvoices.Automation.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/EXIM.ExpenseInvoices.Automation.v1.1.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-06-28
- Confidence: Strong for business concept; project note needs confirmation
