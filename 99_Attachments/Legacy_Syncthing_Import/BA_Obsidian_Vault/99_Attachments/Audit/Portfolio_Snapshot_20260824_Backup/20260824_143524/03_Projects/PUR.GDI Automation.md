---
type: "project"
project_name: "PUR.GDI Automation"
cluster: "Automation"
status: "Active"
priority: "P3"
project_code: "PUR.GDI.Automation.v1.0"
department: "Purchasing"
object: "Inferred from filename"
project_characteristic: "workflow automation"
version: "TBD"
phase: "DESIGN"
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
last_updated: "2026-07-06 08:53:49"
confidence: "Strong"
source_files: []
phase_canvas_group: "ANALYSIS"
last_weekly_update: "2026-06-29 to 2026-07-05"
weekly_rank: "6"
canonical_code: "PUR.GDI.Automation.v1.0"
current_file: "PUR.GDI Automation.md"
primary_domain: "Sourcing / Purchasing"
lifecycle: "Active / WFX API Integration"
current_gate: "WFX API contract discovery and controlled integration design"
last_verified: "2026-08-24"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
dependencies: ["Confirmed Purchasing Workflow -> WFX API -> Controlled GDI Transaction -> Audit and Status"]
delivery_stage: "DESIGN"
stage_entered_date: "Needs Confirmation"
---

# PUR.GDI Automation

# Project Knowledge Detail

## Executive Summary

`PUR.GDI.Automation.v1.0` is an automation project for Purchasing GDI creation, understood as Goods Delivery Instruction or related delivery/coordination instruction workflow. It aims to standardize input/output, reduce manual entry, reduce errors, and interact with WFX if applicable.

Current status is On Hold because the main blocker is WFX dependency / required WFX modification. Large effort should not continue until the WFX/system dependency is unblocked and business rules are clear.

Expected outputs after unblock include GDI automation flow, field mapping, validation rules, UAT with Purchasing, and WFX integration/modification if feasible.

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

| Field   | Value                                                                            | Evidence Source                                        | Confidence |
| ------- | -------------------------------------------------------------------------------- | ------------------------------------------------------ | ---------- |
| Project | PUR.GDI Automation                                                               | Current filename                                       | Strong     |
| Scope   | Purchasing GDI creation automation, currently on hold due WFX/system dependency. | User-provided project detail / memory layer / registry | Strong     |

Evidence sources:
03_Projects_Registry\PPJ_PROJECT_REGISTRY.md: | PUR.GDI Automation | PUR.GDI Automation.md | [[BLOCKED / DEPENDENCY]] | Purchasing / MER Workflow | Uyên | Nam, Phát | Purchasing | Blocked / P2 | TBD | Blocked" | TBD | Next Actions | TBD | TBD | PUR.GDI Automation.md | 80 | Blocked |
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: | [[PUR.GDI Automation]] | PUR.GDI.Automation; GDI Automation | [[BLOCKED / DEPENDENCY]] / TBD | Uyên | Nam, Phát | Purchasing | Purchasing / MER Workflow | High - WFX dependency | P2 | Blocked" | TBD | Next Actions | PUR.GDI Automation.md | 80 |
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: - [[PUR.GDI Automation]] - Risk: High - WFX dependency; Blocker: Blocked"
03_Projects_Registry\PPJ_PROJECT_ALIAS_MAP.md: | PUR.GDI.Automation.md | PUR.GDI Automation.md | Punctuation variant. | Medium | Resource-map alias only; update links only if found | Yes if links exist | Check Canvas after registry approval |
03_Projects_Registry\PPJ_PROJECT_ALIAS_MAP.md: | GDI Automation.md | PUR.GDI Automation.md | Non-coded Purchasing GDI name. | High | Candidate for alias conversion after approval | Yes if links exist | Check Canvas after registry approval |
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: - [[PUR.GDI Automation]] - Purchasing / MER Workflow - P2
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: - [[PUR.GDI Automation]] - P2 - Purchasing
03_Projects\Canvas\PPJ_Executive_Board.canvas: Canvas reference
03_Projects\Canvas\PPJ_Portfolio.canvas: Canvas reference

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

[[PUR.GDI Automation]]

## Deliverables

[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[ERD_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]


## Weekly Synchronization Event: PPJ-WEEKLY-20260727-20260801

### Stable Project Understanding

API-first GDI creation and update workflow that reduces manual Purchasing work while preserving review, transaction control and auditability in WFX.

### Current Weekly Delta

Purchasing and selected MER leaders/managers confirmed the business flow, required input, creation conditions, review responsibilities and target output. Architecture direction changed from Selenium screen simulation to approved API integration.

### Current State

- Canonical Code: PUR.GDI.Automation.v1.0
- Current Physical File: 03_Projects/PUR.GDI Automation.md
- Primary Domain: Sourcing / Purchasing
- Lifecycle: Analysis / Solution Redesign
- Progress: TBD
- Current Gate: Business Flow Confirmed / API Integration Discovery
- Priority for 2026-08-03 to 2026-08-08: P2

### Current Outcome

API-first GDI creation and update workflow that reduces manual Purchasing work while preserving review, transaction control and auditability in WFX.

Required output: WFX API request and target integration architecture.

### Systems / Data and Dependencies

- Confirmed Purchasing Workflow -> WFX API -> Controlled GDI Transaction -> Audit and Status

### Current Blockers

- Official WFX API documentation, authorization and non-production environment are not confirmed.
- Rollback, draft/review and idempotency behavior are not confirmed.

### Current Risks

- Direct unapproved Databricks writes would not constitute a governed WFX transaction.
- Duplicate transactions and incomplete rollback could damage operational data.

### Current Decisions

- Approve WFX API or vendor-approved transactional service.
- Confirm transaction, rollback, approval and audit architecture.

### Next Actions

- Request WFX API documentation and supported create/update/draft/submit/cancel/status operations.
- Confirm authentication, request/response schema, idempotency and duplicate rules.
- Confirm rollback, audit and approval-before-submit requirements.
- Build and test an API prototype in a non-production environment.
- Do not write production transactions without vendor approval.

### Evidence and Confidence

- Date: 2026-08-01
- Source Event: PPJ-WEEKLY-20260727-20260801
- Source: User-approved Weekly Portfolio Update
- Evidence: User-approved Weekly Portfolio Update for 2026-07-27 to 2026-08-01
- Confidence: Strong

<!-- PPJ_WEEKLY_UPDATE_20260629_20260705_START -->
## Weekly Update - 2026-06-29 to 2026-07-05

- Project code: $(@{Code=PUR.GDI.Automation.v1.0; Note=03_Projects/PUR.GDI Automation.md; Phase=Scope Reassessment; Lane=ANALYSIS; Priority=P2; Rank=6; CreateIfMissing=False; Summary=Technical feasibility improved significantly. Technical team identified a way to retrieve required data from multiple system screens. User confirmation may be bypassed. User may only need to provide style, item code and company branch. Project needs re-scope to confirm automation level, risk and final control points.}.Code)
- Phase: Scope Reassessment
- Executive Canvas lane: ANALYSIS
- Priority: P2
- Weekly priority rank: 6

Technical feasibility improved significantly. Technical team identified a way to retrieve required data from multiple system screens. User confirmation may be bypassed. User may only need to provide style, item code and company branch. Project needs re-scope to confirm automation level, risk and final control points.

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

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | PUR.GDI.Automation.v1.0 |
| Primary Domain | Sourcing / Purchasing |
| Delivery Stage | DESIGN |
| Lifecycle | Active / WFX API Integration |
| Status | Active |
| Progress | TBD |
| Current Gate | WFX API contract discovery and controlled integration design |
| Priority | P3 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Automate GDI creation/update while preserving WFX transaction control, validation, confirmation and audit.

## Current Capability

PPJ GDI application using supported WFX APIs; never direct-write Databricks as a substitute for WFX transactions.

## Latest Update

Purchasing teams and MER leaders/managers confirmed the business flow; WFX API support materially reduced technical uncertainty. Selenium is fallback only.

## Risks / Blockers

- WFX API ownership and sandbox
- Authentication and rate limits
- Transaction integrity

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- WFX API -> Business validation -> Controlled GDI transaction -> Confirmation / Audit

## Next Actions

- Obtain WFX API authentication and operation documentation
- Confirm create/update/lookup/draft/submit/cancel/status schemas
- Define validation, idempotency, duplicate, retry and timeout controls
- Design audit logging and transaction confirmation

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[PUR.GDI Automation/00_Project_Home|Project Home]]
- [[PUR.GDI Automation/Project_Executive_Board|Project Executive Board]]
- [[PUR.GDI Automation/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong

<!-- PPJ_PROJECT_KNOWLEDGE_END -->
