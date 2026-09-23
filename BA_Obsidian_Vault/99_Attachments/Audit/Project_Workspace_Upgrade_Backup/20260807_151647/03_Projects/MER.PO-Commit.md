---
type: "project"
project_name: "MER.PO-Commit"
project_code: "MER.PO.Commit.v1.1"
department: "MER / Purchasing"
object: "Inferred from filename"
project_characteristic: "workflow governance"
version: "TBD"
phase: "DONE / CLOSED"
cluster: "Merchandising / Costing"
owner: "TBD"
business_owner: "TBD"
technical_owner: "TBD"
members: []
stakeholders: []
systems: []
data_sources: []
status: "DONE / CLOSED"
progress: "TBD"
priority: "Closed"
blocked: "TBD"
decision_needed: "TBD"
next_action: "TBD"
last_updated: "2026-07-06 08:53:49"
confidence: "Strong"
source_files: []
phase_canvas_group: "CLOSED / CANCELLED"
last_weekly_update: "2026-06-29 to 2026-07-05"
---

---

## Project Resource Governance

BA / Coordination:
Uyên

Technical Members:
TBD

Business Stakeholder / Department:
MER, Purchasing

Portfolio Group:
Purchasing / MER Workflow

Priority:
P2

Phase:
TBD

Progress:
TBD

Blocker:
TBD

Decision Needed:
TBD

Next Action:
TBD

Workload Risk:
High - zero-byte note

Source:
[[PPJ_PROJECT_RESOURCE_MATRIX]]

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

# Project Knowledge Detail

## Executive Summary

`MER.PO.Commit.v1.1` is an automation that supports MER in processing customer PO input and generating required templates such as OC-related files, NPL files, and Packing Lists. It reduces manual copying, formatting errors, and repeated template preparation work.

The current status is Closed / Production Support. Enhancement work may still happen for customer-specific logic, but the project should avoid excessive hard-coding and should version templates if customer formats vary.

Expected outputs include OC template, NPL file, Packing List, output checks/logs, and user support when customer PO formats change.

## Business Context

This project belongs to the PPJ AI/Automation portfolio. The repaired managed block records business meaning, ownership gaps, data/source-of-truth needs, risks, decisions, and next actions without changing the filename or user-written content outside the managed block.

## Problem Statement

The existing generated block used generic wording and may not contain enough project-specific business detail. This repair makes the block more conservative, clearer, and easier to validate.

## Objectives

- Clarify project-specific business meaning.
- Identify missing owner, data, and workflow details.
- Prepare the note for business confirmation and deliverable creation.

## Scope

### In Scope

- Business context and scope clarification
- Stakeholder and source-of-truth confirmation
- Risk, decision, and next-action tracking

### Out of Scope

- Renaming files
- Moving or archiving files
- Canvas layout changes
- Merging this project into another note

## Stakeholders

| Role            | Name / Team | Responsibility                             | Confirmation       |
| --------------- | ----------- | ------------------------------------------ | ------------------ |
| Business Owner  | TBD         | Confirm process, scope, and acceptance     | Needs Confirmation |
| Technical Owner | TBD         | Confirm system, data, and support approach | Needs Confirmation |
| Users           | TBD         | Validate workflow and outputs              | Needs Confirmation |

## Current Process

Current process is partially documented and needs confirmation from the business owner and users.

## Target Process

Target process should be confirmed through requirements walkthrough, source-of-truth review, and UAT planning.

## Data and Source of Truth

| Data Object          | Source System | Owner | Quality Risk                       | Confirmation       |
| -------------------- | ------------- | ----- | ---------------------------------- | ------------------ |
| Primary project data | TBD           | TBD   | Missing source-of-truth definition | Needs Confirmation |

## System / Automation Design

System / automation design is TBD unless already confirmed in the source project note, registry, or resource matrix. The project should define input, output, user flow, exceptions, support owner, and monitoring before implementation or rollout decisions.

## Business Rules

- Do not rename or merge this project without approval.
- Source of truth must be confirmed before automation expansion.
- Owner and support path must be confirmed before production use.

## KPI / Success Metrics

| KPI             | Target | Current | Notes                            |
| --------------- | ------ | ------- | -------------------------------- |
| Time saved      | TBD    | TBD     | Define after process baseline    |
| Error reduction | TBD    | TBD     | Define after data/process review |
| Adoption        | TBD    | TBD     | Confirm user group               |

## Risks and Blockers

- Unclear ownership
- Missing source-of-truth definition
- Incomplete data fields or process rules
- Support and escalation path not confirmed

## Decisions Needed

- Confirm business owner.
- Confirm technical owner.
- Confirm source of truth.
- Confirm phase, scope, and next action.

## Next Actions

- Review repaired block with project owner.
- Confirm missing data fields and workflow.
- Update related BRD/SOP/user manual after confirmation.

## Evidence and Confidence

| Field   | Value                                                                                         | Evidence Source                                        | Confidence |
| ------- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------ | ---------- |
| Project | MER.PO-Commit                                                                                 | Current filename                                       | Strong     |
| Scope   | MER PO automation for OC template, NPL file, Packing List generation, and production support. | User-provided project detail / memory layer / registry | Strong     |

Evidence sources:
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: |[[MER.PO-Commit]]] | MER.PO Commit | TBD / TBD | Uyên | TBD | MER, Purchasing | Purchasing / MER Workflow | High - zero-byte note | P2 | TBD | TBD | TBD | PO Commit.md | 40 |
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: -[[MER.PO-Commit]]] - Risk: High - zero-byte note; Blocker: TBD
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: -[[MER.PO-Commit]]] - Department: MER, Purchasing
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: -[[MER.PO-Commit]]] - Purchasing / MER Workflow - P2
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: -[[MER.PO-Commit]]] - P2 - MER, Purchasing

## Related Concepts

[[Project Governance]]
[[Traceability]]
[[Business Process Design]]
[[Data Governance]]

## Methods

[[Requirement Elicitation]]
[[Impact Analysis]]
[[Data Mapping]]
[[User Journey Mapping]]
[[Acceptance Criteria]]

## Projects

[[MER.PO-Commit]]

## Deliverables

[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[ERD_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]

## Project Workspace

Workspace:
[[MER.PO-Commit/00_Project_Home]]

Executive Board:
[[MER.PO-Commit/Project_Executive_Board]]

Tasks:
[[MER.PO-Commit/Tasks]]

Governance:
[[MER.PO-Commit/10_Governance/Decision_Log]]
<!-- PPJ_PROJECT_KNOWLEDGE_END -->

<!-- PPJ_WEEKLY_UPDATE_20260629_20260705_START -->
## Weekly Update - 2026-06-29 to 2026-07-05

- Project code: $(@{Code=MER.PO.Commit.v1.1; Note=03_Projects/MER.PO-Commit.md; Phase=DONE / CLOSED; Lane=CLOSED / CANCELLED; Priority=Closed; Rank=; CreateIfMissing=False; Summary=Full scope completed and officially closed.}.Code)
- Phase: DONE / CLOSED
- Executive Canvas lane: CLOSED / CANCELLED
- Priority: Closed

Full scope completed and officially closed.

Related Concepts
[[Outcome Driven Thinking]]
[[System Thinking]]
[[Data Governance]]
[[Traceability]]

Methods
[[Impact Analysis]]
[[Requirement Elicitation]]
[[Data Mapping]]

Deliverables
[[Decision_Driven_BRD]]
[[ERD_Template]]
[[User_Manual_Template]]

<!-- PPJ_WEEKLY_UPDATE_20260629_20260705_END -->
