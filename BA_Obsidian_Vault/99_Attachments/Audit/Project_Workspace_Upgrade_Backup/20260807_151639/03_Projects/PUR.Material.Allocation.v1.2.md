---
type: project
project_name: "Material Allocation"
cluster: "Automation"
status: "UAT / Stabilization"
priority: "P5"
project_code: "PUR.Material.Allocation.v1.1"
department: "Purchasing / Sourcing"
object: "Inferred from filename"
project_characteristic: "workflow automation"
version: "v1.1"
phase: "UAT / Stabilization"
owner: "TBD"
business_owner: "TBD"
technical_owner: "TBD"
members: []
stakeholders: []
systems: []
data_sources: []
progress: "TBD"
blocked: "TBD"
decision_needed: "TBD"
next_action: "TBD"
last_updated: "2026-06-28"
confidence: "Strong"
source_files: []
canonical_code: "PUR.Material.Allocation.v1.1"
current_file: "PUR.Material.Allocation.v1.1.md"
primary_domain: "Sourcing / Purchasing"
lifecycle: "UAT / Stabilization"
current_gate: "First Flow Validated / Extended Exception Testing"
last_verified: "2026-07-18"
source_event: "PPJ-WEEKLY-20260713-20260718"
---

# Material Allocation


---

## Project Resource Governance

BA / Coordination:
Khoa, Uyên

Technical Members:
Nam, Phát

Business Stakeholder / Department:
Purchasing

Portfolio Group:
Purchasing / MER Workflow

Priority:
P1 Next Week

Phase:
BLOCKED

Progress:
DEPENDENCY]] / TBD

Blocker:
Blocked"

Decision Needed:
TBD

Next Action:

- Confirm timeline with WFX owner

Workload Risk:
High - WFX dependency

Source:
[[PPJ_PROJECT_RESOURCE_MATRIX]]

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

# Project Knowledge Detail

## Executive Summary

`PUR.Material.Allocation.v1.1` is an automation / semi-automation project for material allocation, transfer, borrow, indent, and allocation adjustment between OC/style/order on WFX. Because this affects sensitive material transactions, the workflow must include validation, user review, draft/save logic where WFX supports it, and human confirmation before final posting.

Current status is Analysis / Early Development, around 10%. The team is requesting real test data from Precision and working with chị Tuyết, Precision Manager in Vietnam. Business users are busy, so test data and feedback are still incomplete.

Required data includes test OC/order, material code, available quantity, required quantity, allocation status, transfer/borrow cases, WFX screens/fields, and approval/user rules. The main blockers are real test data, business user availability, WFX save/edit draft capability, and WFX rule behavior.

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

| Field   | Value                                                                                                                     | Evidence Source                                        | Confidence |
| ------- | ------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ | ---------- |
| Project | PUR.Material.Allocation.v1.1                                                                                              | Current filename                                       | Strong     |
| Scope   | Purchasing material allocation/transfer/borrow automation with WFX validation, real test data, and mandatory user review. | User-provided project detail / memory layer / registry | Strong     |

Evidence sources:
03_Projects_Registry\PPJ_PROJECT_REGISTRY.md: | PUR.Material.Allocation.v1.1 | PUR.Material.Allocation.v1.1.md | [[BLOCKED / DEPENDENCY]] | Purchasing / MER Workflow | Khoa, Uyên | Nam, Phát | Purchasing | Blocked / P1 Next Week | TBD | Blocked" | TBD | - Confirm timeline with WFX owner | TBD | TBD | PUR.Material.Allocation.v1.1.md | 80 | Blocked by WFX |
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: | [[PU[[PUR.Material.Allocation.v1.2]]aterial Allocation | [[BLOCKED / DEPENDENCY]] / TBD | Khoa, Uyên | Nam, Phát | Purchasing | Purchasing / MER Workflow | High - WFX dependency | P1 Next Week | Blocked" | TBD | - Confirm timeline with WFX owner | PUR.Material.Allocation.v1.1.md | 80 |
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: - [[PU[[PUR.Material.Allocation.v1.2]]UR.Material.Allocation.v1.1
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: - [[PU[[PUR.Material.Allocation.v1.2]]isk: High - WFX dependency; Blocker: Blocked"
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: - [[PU[[PUR.Material.Allocation.v1.2]]urchasing / MER Workflow - P1 Next Week
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: - [[PU[[PUR.Material.Allocation.v1.2]]1 Next Week - Purchasing
03_Projects\Canvas\PPJ_Executive_Board.canvas: Canvas reference
03_Projects\Canvas\PPJ_Portfolio.canvas: Canvas reference
03_Projects\Canvas\PPJ_Roadmap_2026.canvas: Canvas reference

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

[[PU[[PUR.Material.Allocation.v1.2]] Deliverables

[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[ERD_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]


## Weekly Synchronization Event: PPJ-WEEKLY-20260713-20260718

### Executive Summary

The first business flow was successfully tested: Source OC with Surplus -> Validate Surplus -> Unreserve -> Find Destination OC -> Validate Style and Buyer Reference -> Allocate -> Verify Result. Destination OCs are split OCs with the same Style and Buyer Reference.

### Current Outcome

Automate reallocation of surplus Sewing and Embroidery materials/trims between split OCs while reducing manual WFX operations and allocation errors.

Primary output: Validated unreserve, destination-OC matching and allocation flow with controlled UAT foundation

### Current Status

- Canonical Code: PUR.Material.Allocation.v1.1
- Current File: 03_Projects/PUR.Material.Allocation.v1.1.md
- Primary Domain: Sourcing / Purchasing
- Lifecycle: UAT / Stabilization
- Progress: TBD
- Current Gate: First Flow Validated / Extended Exception Testing
- Priority for 2026-07-20 to 2026-07-25: P5

### Latest Update

The first business flow was successfully tested: Source OC with Surplus -> Validate Surplus -> Unreserve -> Find Destination OC -> Validate Style and Buyer Reference -> Allocate -> Verify Result. Destination OCs are split OCs with the same Style and Buyer Reference.

### Current Risks / Blockers

- Only Sewing and Embroidery scope is confirmed.
- Quantity may change during transaction execution.
- Rollback is undefined when unreserve succeeds but allocation fails.

### Decisions Needed

- Confirm transaction rollback design.
- Confirm auditability and user confirmation before posting.
- Confirm whether additional material categories enter scope.

### Next Actions

- Test many-to-one, one-to-many, partial allocation, insufficient quantity, Buyer Reference mismatch and duplicate allocation.
- Test transaction failure/retry and define rollback.
- Define audit log and user review before posting.
- Prepare UAT with Ms. Tuyet and Precision users.

Required next-period output: Exception-case testing and UAT plan.

### Evidence and Confidence

- Date: 2026-07-18
- Source Event: PPJ-WEEKLY-20260713-20260718
- Source: User-approved Weekly Portfolio Report
- Evidence: User-approved weekly portfolio report 2026-07-13 to 2026-07-18
- Confidence: Strong

<!-- PPJ_PROJECT_KNOWLEDGE_END -->


