---
type: "brd"
project: "COSTING.AGENTIC.PLATFORM.v1.1"
source_project: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Business Requirements Document

## Executive Summary

Strategic agentic platform for multi-department technical costing and quotation workflows.

## Business Problem

Needs Confirmation from the current project evidence and responsible business users.

## Objectives

- Costing and Quotation Package for Merchandising review and customer quotation proposals.

## Users / Stakeholders

- Primary users: Merchandising and Sew experts
- Business owner: Needs Confirmation
- BA / Coordination: Khoa

## Current Process

Needs Confirmation. See [[../03_Process/AS_IS_Process]].

## Pain Points

- SAM is not final without validated standards and expert review.
- AI suggestion and approved costing must remain separate.

## Target Process

See [[../03_Process/TO_BE_Process]]. Target flow remains subject to current-gate approval.

## Scope

- Agentic platform with BOM, Sew, Wash, Cut, Technical Knowledge, Historical Costing, and Quotation Consolidation agents.

## Out of Scope

- Not a simple calculator or single chatbot.

## Business Requirements

- Deliver the verified project outcome without unapproved scope expansion.
- Preserve review, exception, evidence and traceability controls appropriate to the project type.
- Confirm any missing rule with the responsible business owner.

## Business Rules

See [[Scope_and_Business_Rules]]. Unconfirmed rules remain Needs Confirmation.

## Data Requirements Summary

See [[../04_Data/Data_Spec]] and [[../04_Data/Data_Source_Inventory]].

## Integration Summary

See [[../06_Solution/Integration_Spec]]. No direct transactional write is assumed.

## AI / Automation Scope

Applicable only where confirmed in the project memory, project note or approved update.

## Human Validation

Responsible users must validate outputs before business decisions or transactions when automation or AI is involved.

## Exception / Fallback

Unresolved exceptions must be logged, assigned and handled through an approved manual or system fallback.

## KPI / Measurable Outcome

Needs Confirmation.

## Risks

- SAM is not final without validated standards and expert review.
- AI suggestion and approved costing must remain separate.

## Assumptions

- Registry, memory and root project note remain the source of truth.
- Unverified details are not treated as approved requirements.

## Dependencies

- TD.TechnicalKnowledge.Platform.v2.1 -> Consumption / Pattern / BOM / Construction / History -> Costing Platform
- AI Suggestion -> Expert-approved Result -> Final GTAS/IED Transfer

## Decisions Required

- Approve Sew v1.2 accuracy and acceptance plan.
- Confirm GTAS/IED data contract and expert-approval boundary.

## Acceptance Summary

See [[../05_Requirements/Acceptance_Criteria]]. Formal acceptance owner and evidence remain Needs Confirmation unless explicitly recorded.

## Evidence Basis

- Root project note: [[../PPJ.COSTING.AGENT.PLATFORM.v1.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/COSTING.AGENTIC.PLATFORM.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
