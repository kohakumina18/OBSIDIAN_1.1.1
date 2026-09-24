---
type: "brd"
project: "TD.TechnicalKnowledge.Platform.v2.1"
source_project: "TD.TechnicalPlatform_v2.1.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Business Requirements Document

## Executive Summary

Technical knowledge platform for buyer reference, pattern, BOM, costing history, videos, and training material.

## Business Problem

Needs Confirmation from the current project evidence and responsible business users.

## Objectives

- Technical data and knowledge foundation for search, retrieval, Pattern, BOM, construction, consumption, historical cases, Costing and future domain AI.

## Users / Stakeholders

- Primary users: Technical team
- Business owner: Needs Confirmation
- BA / Coordination: Khoa

## Current Process

Needs Confirmation. See [[../03_Process/AS_IS_Process]].

## Pain Points

- ETL completion does not mean production-ready data.
- Duplicate records, missing keys or wrong versions could affect Costing outputs.

## Target Process

See [[../03_Process/TO_BE_Process]]. Target flow remains subject to current-gate approval.

## Scope

- Knowledge/search/training platform for Technical Department data.

## Out of Scope

- Not automatically identical to CPD Datamart or Costing Platform; it supports them as a data node.

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

- ETL completion does not mean production-ready data.
- Duplicate records, missing keys or wrong versions could affect Costing outputs.

## Assumptions

- Registry, memory and root project note remain the source of truth.
- Unverified details are not treated as approved requirements.

## Dependencies

- Technical Platform ETL -> Pattern / BOM / Consumption / Construction -> Sew and Consumption Costing -> Costing Package

## Decisions Required

- Approve Technical data completeness, accuracy and version logic.
- Confirm data owner, lineage and permission model.

## Acceptance Summary

See [[../05_Requirements/Acceptance_Criteria]]. Formal acceptance owner and evidence remain Needs Confirmation unless explicitly recorded.

## Evidence Basis

- Root project note: [[../TD.TechnicalPlatform_v2.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/TD.TechnicalKnowledge.Platform.v2.1.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
