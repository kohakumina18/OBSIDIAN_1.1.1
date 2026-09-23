---
type: "project_plan"
project: "COSTING.AGENTIC.PLATFORM.v1.1"
source_project: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
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
| Canonical Code | MER_CostingAgenticPlatform_v1.1.0 |
| Domain | Merchandising |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DEVELOPMENT |
| Lifecycle | Active Development |
| Status | Active |
| Progress | TBD |
| Gate | Sew Agent fixes and Wash Agent development |
| Priority | P2 |
| Outcome | Generate a Costing / Quotation Package for Merchandising review and customer quotation through one platform. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

One platform, not dozens of projects: SewAgent, WashAgent, BOMAgent, ConsumptionAgent, SimilarStyleAgent and CostingOrchestrator. Current focus: fixing Sew Agent issues, SAM accuracy, machine mapping, operation normalization, historical similar-style retrieval and GTAS/IED integration. Wash (especially Denim): the AI proposes, the Wash expert approves.

### Current Risks

- SAM accuracy and expert acceptance
- GTAS/IED integration contract
- Technical Data dependency

### Dependencies

- TD_TechnicalKnowledgePlatform_v2.1.0 -> Pattern/BOM/Consumption -> Sew/Wash/Costing AI

### Next Actions

- Improve SAM validation and benchmark with a Sew expert
- Confirm the GTAS/IED integration contract
- Connect Technical Data
- Collect Wash cases
- Build the Wash similarity engine with mandatory expert review
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Plan

## Planning Basis

- Lifecycle: Development
- Current gate: Sew Costing v1.1 Demo Completed / v1.2 Development
- Priority: P3
- Plan status: Current Working Document

## Current Work Packages

1. Confirm scope, ownership and evidence.
2. Complete the current lifecycle gate.
3. Maintain task, risk, decision and dependency traceability.
4. Prepare only the next approved delivery or closeout step.

## Evidence-Based Next Actions

- Evaluate the v1.1 demo with Sew experts and establish an accuracy baseline.
- Analyze extraction errors and improve SAM calculation.
- Confirm GTAS/IED data contract and API/integration format.
- Connect Technical consumption data.
- Continue the Wash dataset workstream without creating a separate root project.

## Dependencies

- TD.TechnicalKnowledge.Platform.v2.1 -> Consumption / Pattern / BOM / Construction / History -> Costing Platform
- AI Suggestion -> Expert-approved Result -> Final GTAS/IED Transfer

## Planning Controls

- No unapproved scope expansion.
- No invented owner, date, source table or business rule.
- Each milestone requires evidence and responsible-owner confirmation.

## Evidence Basis

- Root project note: [[../PPJ.COSTING.AGENT.PLATFORM.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/COSTING.AGENTIC.PLATFORM.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
