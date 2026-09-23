---
type: project
project_name: "CPD Datamart"
cluster: "Data"
status: "Active"
priority: "P5"
project_code: "TD.TechnicalKnowledge.Platform.v2.1"
department: "Data / CPD / AI"
object: "Inferred from filename"
project_characteristic: "technical platform"
version: "v2.1"
phase: "UAT / PRE-GO-LIVE"
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
canonical_code: "TD.TechnicalKnowledge.Platform.v2.1"
current_file: "TD.TechnicalPlatform_v2.1.md"
primary_domain: "Fabric / Textiles Technique"
lifecycle: "Initial Sync Demo Completed / Sync Validation & Stabilization"
current_gate: "Incremental sync hardening and Technical UAT"
last_verified: "2026-08-24"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
dependencies: ["Technical Platform ETL -> Pattern / BOM / Consumption / Construction -> Sew and Consumption Costing -> Costing Package"]
delivery_stage: "UAT / PRE-GO-LIVE"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

# Technical Platform - v2.1

# Project Knowledge Detail

## Executive Summary

`TD.TechnicalKnowledge.Platform.v2.1` is a Technical Department knowledge/data platform request from anh Tứ. It aims to centralize and link technical data such as buyer reference, pattern, BOM, historical costing, sewing/measurement guidance, videos, training material, construction, fitting, and product-related technical documents.

This platform is directly related to `COSTING.AGENTIC.PLATFORM.v1.1` because the technical knowledge can become a data node for BOM, Sew, Cut, Technical Knowledge, and Historical Costing agents.

Next work is to survey the current technical platform, list data sources, define naming conventions and metadata, clarify search flow, decide what should sync to Directus if applicable, and define role/department permissions.

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

| Field   | Value                                                                                                                                                       | Evidence Source                                        | Confidence |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ | ---------- |
| Project | TD.TechnicalPlatform_v2.1                                                                                                                                   | Current filename                                       | Strong     |
| Scope   | Technical knowledge platform for buyer reference, pattern, BOM, costing history, sewing guidance, videos, training data, and costing-agent data foundation. | User-provided project detail / memory layer / registry | Strong     |

Evidence sources:
03_Projects_Registry\PPJ_PROJECT_REGISTRY.md: | Tech.Knowledge.Platform.v2.1 | TD.TechnicalPlatform_v2.1.md | [[PRODUCTION / SUPPORT]] | Agentic / Chatbot / Knowledge | Khoa | Linh, Nghĩa | Data, CPD | Production / P1 Next Week | TBD | TBD | TBD | Next Actions | TBD | TBD | TD.TechnicalPlatform_v2.1.md | 70 | Resource map name may not equal CPD Datamart |
03_Projects_Registry\PPJ_PROJECT_REGISTRY.md: - Tech.Knowledge.Platform.v2.1 may be related to TD.TechnicalPlatform_v2.1 but should not be assumed identical without confirmation.
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: | [[TD.TechnicalPlatform_v2.1]] | TD.TechnicalPlatform_v2.1; CPD Fabric Database | [[PRODUCTION / SUPPORT]] / TBD | Khoa | Linh, Nghĩa | Data, CPD | Agentic / Chatbot / Knowledge | Medium - source of truth and knowledge governance | P1 Next Week | TBD | TBD | Next Actions | TD.TechnicalPlatform_v2.1.md | 70 |
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: - [[TD.TechnicalPlatform_v2.1]] - Tech.Knowledge.Platform.v2.1
03_Projects_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: - [[TD.TechnicalPlatform_v2.1]]: confirm whether Tech.Knowledge.Platform.v2.1 is the same as TD.TechnicalPlatform_v2.1 or a new knowledge platform.
03_Projects_Registry\PPJ_PROJECT_ALIAS_MAP.md: | Tech.Knowledge.Platform.v2.1.md | TD.TechnicalPlatform_v2.1.md | Resource-map technical knowledge platform name overlaps technical platform note. | Medium | Resource-map alias only; update links only if found | Yes if links exist | Check Canvas after registry approval |
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: - [[TD.TechnicalPlatform_v2.1]] - Agentic / Chatbot / Knowledge - P1 Next Week
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: - [[TD.TechnicalPlatform_v2.1]] - P1 Next Week - Data, CPD
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: - Confirm if Tech.Knowledge.Platform.v2.1 is new or alias of TD.TechnicalPlatform_v2.1.
03_Projects\Canvas\PPJ_Data_Flow.canvas: Canvas reference

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

[[TD.TechnicalPlatform_v2.1]]

## Deliverables

[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[ERD_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]


## Weekly Synchronization Event: PPJ-WEEKLY-20260727-20260801

### Stable Project Understanding

Technical data and knowledge foundation for search, retrieval, Pattern, BOM, construction, consumption, historical cases, Costing and future domain AI.

### Current Weekly Delta

ETL completed for the Technical sources currently identified in v2.1 scope. Data was extracted, transformed, initially standardized, loaded into the Technical Platform data layer and organized for future search, retrieval and AI capability.

### Current State

- Canonical Code: TD.TechnicalKnowledge.Platform.v2.1
- Current Physical File: 03_Projects/TD.TechnicalPlatform_v2.1.md
- Primary Domain: Fabric / Textiles Technique
- Lifecycle: Development / Data Validation
- Progress: ETL completed for currently identified v2.1 sources
- Current Gate: ETL Completed / Data Foundation Available / Data Acceptance Pending
- Priority for 2026-08-03 to 2026-08-08: P6

### Current Outcome

Technical data and knowledge foundation for search, retrieval, Pattern, BOM, construction, consumption, historical cases, Costing and future domain AI.

Required output: ETL reconciliation and Technical data acceptance.

### Systems / Data and Dependencies

- Technical Platform ETL -> Pattern / BOM / Consumption / Construction -> Sew and Consumption Costing -> Costing Package

### Current Blockers

- Technical-user acceptance is pending.
- Completeness, freshness, approved-version logic, lineage and permissions are not fully confirmed.

### Current Risks

- ETL completion does not mean production-ready data.
- Duplicate records, missing keys or wrong versions could affect Costing outputs.

### Current Decisions

- Approve Technical data completeness, accuracy and version logic.
- Confirm data owner, lineage and permission model.

### Next Actions

- Measure ETL coverage and reconcile with source systems.
- Detect duplicates and missing keys.
- Confirm record version and approved/latest version logic.
- Build search/retrieval and permission layers.
- Connect consumption data to Costing and prepare Technical-user UAT.

### Evidence and Confidence

- Date: 2026-08-01
- Source Event: PPJ-WEEKLY-20260727-20260801
- Source: User-approved Weekly Portfolio Update
- Evidence: User-approved Weekly Portfolio Update for 2026-07-27 to 2026-08-01
- Confidence: Strong

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | TD.TechnicalKnowledge.Platform.v2.1 |
| Primary Domain | Fabric / Textiles Technique |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Initial Sync Demo Completed / Sync Validation & Stabilization |
| Status | Active |
| Progress | TBD |
| Current Gate | Incremental sync hardening and Technical UAT |
| Priority | P5 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Technical Data Backbone for Pattern, BOM, Consumption, Construction, documents and historical records.

## Current Capability

Source -> ETL -> Technical Data Layer -> Sync -> Technical Knowledge Platform.

## Latest Update

Source collection, ETL, Technical Data Layer and the initial syncing-flow demo are complete; the project is now validating and stabilizing synchronization.

## Risks / Blockers

- Sync reliability
- Version governance
- Missing keys and duplicate records
- Technical UAT acceptance

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- Technical sources -> ETL -> Technical Data Layer -> Sync -> Platform -> Costing / Pattern / Wash / Search

## Next Actions

- Implement incremental sync, error handling and retry
- Add duplicate, missing-key and reconciliation checks
- Govern versions and latest/approved-record logic
- Finalize permissions and prepare Technical UAT

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[TD.TechnicalPlatform_v2.1/00_Project_Home|Project Home]]
- [[TD.TechnicalPlatform_v2.1/Project_Executive_Board|Project Executive Board]]
- [[TD.TechnicalPlatform_v2.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong

<!-- PPJ_PROJECT_KNOWLEDGE_END -->
