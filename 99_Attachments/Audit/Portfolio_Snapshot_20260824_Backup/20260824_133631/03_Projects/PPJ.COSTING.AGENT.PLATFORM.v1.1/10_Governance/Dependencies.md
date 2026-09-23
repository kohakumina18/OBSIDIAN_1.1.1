---
type: "dependencies"
project: "COSTING.AGENTIC.PLATFORM.v1.1"
source_project: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-08-24

| Field | Value |
| --- | --- |
| Canonical Code | COSTING.AGENTIC.PLATFORM.v1.1 |
| Domain | Merchandising |
| Lifecycle | Active Development |
| Progress | TBD |
| Gate | Sew v1.2 and Wash Agent development |
| Priority | P2 |
| Outcome | Generate a Costing / Quotation Package for Merchandising review and customer quotation. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260824 |

### Latest Update

Sew v1.1 demonstrated description-to-standardized-operation extraction; v1.2 focuses on SAM accuracy, normalization, machine/time mapping, confidence and GTAS/IED integration. Wash remains a human-reviewed workstream inside this platform.

### Current Risks

- SAM accuracy and expert acceptance
- GTAS/IED integration contract
- Technical Data dependency

### Dependencies

- TD.TechnicalKnowledge.Platform.v2.1 -> Pattern/BOM/Consumption -> Sew/Wash/Costing AI

### Next Actions

- Improve SAM validation and benchmark with a Sew expert
- Confirm the GTAS/IED integration contract
- Connect Technical Data
- Collect Wash cases
- Build the Wash similarity engine with mandatory expert review
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Dependencies

| Dependency ID | Dependency | Owner | Status | Source |
| --- | --- | --- | --- | --- |
| DEP-001 | TD.TechnicalKnowledge.Platform.v2.1 -> Consumption / Pattern / BOM / Construction / History -> Costing Platform | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |
| DEP-002 | AI Suggestion -> Expert-approved Result -> Final GTAS/IED Transfer | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |

## Evidence Basis

- Root project note: [[../PPJ.COSTING.AGENT.PLATFORM.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/COSTING.AGENTIC.PLATFORM.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
