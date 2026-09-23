---
type: "dependencies"
project: "PUR.GDI.Automation.v1.0"
source_project: "PUR.GDI Automation.md"
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
| Canonical Code | PUR_GDIAutomation_v1.0.0 |
| Domain | Sourcing / Purchasing |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DEVELOPMENT |
| Lifecycle | Active Development / WFX API Integration |
| Status | Active |
| Progress | TBD |
| Gate | WFX API integration and GDI data-entry workflow |
| Priority | P3 |
| Outcome | Give Purchasing end-to-end package-dispatch tracking through GDI and provide API capability for automated/assisted GDI data entry while preserving WFX transaction control, validation, confirmation and audit. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

Increasingly API-oriented rather than UI/RPA-oriented: Purchasing User -> GDI Application -> Validation -> WFX API -> GDI Transaction -> WFX. Two objectives stay separate: the business objective (GDI functionality to track package dispatch end-to-end) and the automation objective (WFX API capability for automated/assisted GDI entry). Critical path: WFX API specification -> Authentication -> GET/master-data APIs -> POST GDI -> Error handling -> UAT -> Production.

### Current Risks

- WFX API ownership and sandbox
- Authentication and rate limits
- Transaction integrity

### Dependencies

- WFX API -> Business validation -> Controlled GDI transaction -> Confirmation / Audit

### Next Actions

- Obtain WFX API authentication and operation documentation
- Confirm create/update/lookup/draft/submit/cancel/status schemas
- Define validation, idempotency, duplicate, retry and timeout controls
- Design audit logging and transaction confirmation
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Dependencies

| Dependency ID | Dependency | Owner | Status | Source |
| --- | --- | --- | --- | --- |
| DEP-001 | Confirmed Purchasing Workflow -> WFX API -> Controlled GDI Transaction -> Audit and Status | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |

## Evidence Basis

- Root project note: [[../PUR.GDI Automation]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PUR.GDI.Automation.v1.0.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
