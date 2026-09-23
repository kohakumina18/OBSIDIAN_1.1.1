---
type: "project"
project_name: "CPD.Datamart.v1.1"
project_code: "CPD.Datamart.v1.1"
department: "CPD / 3D Design"
object: "3D sample library / image search"
project_characteristic: "datamart"
version: "v1.1"
phase: "TBD"
cluster: "Data / Dashboard / Portal"
owner: "TBD"
business_owner: "3D Design / CPD"
technical_owner: "TBD"
status: "TBD"
progress: "TBD"
priority: "TBD"
blocked: "TBD"
decision_needed: "Confirm source of truth, owner, metadata, and search approach"
next_action: "Walk through Chi Trang / 3D Design sample search workflow"
last_updated: "2026-06-28"
confidence: "Strong for corrected business concept; implementation details need confirmation"
source_files: []
---

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

# Project Knowledge Detail

## Executive Summary
CPD.Datamart.v1.1 is a separate CPD / 3D Design datamart project. It focuses on image search and a 3D sample library for the 3D Design department.


## Business Context
The 3D Design department needs a searchable visual sample library where users can find sample images, references, and related 3D sample assets. The project should support image search, metadata governance, sample library structure, and reuse of visual sample knowledge.

## Problem Statement
Visual sample knowledge can become difficult to reuse if images and 3D sample references are stored across folders, unmanaged websites, or disconnected tools. Without a governed CPD datamart, users may struggle to find relevant sample images, compare designs, or reuse previous 3D sample assets.

## Objectives

- Build a CPD / 3D Design datamart for visual sample library.
- Support image search and sample lookup.
- Define sample image metadata.
- Organize 3D sample assets and references.
- Clarify permission and ownership.
- Prepare foundation for future AI visual search if approved.

## Scope

### In Scope

- CPD / 3D Design sample library
- Image search
- 3D sample asset metadata
- Visual sample lookup
- Permission and ownership
- Data quality and duplicate checking
- User validation with 3D Design users

### Out of Scope

- FD Directus hanger QR module
- FD.Datamart.v2.2
- R&D Wash sampling portal
- Sourcing chatbot repository
- AI visual recommendation before image data is stable

## Stakeholders

| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Business Owner | 3D Design / CPD | Confirm sample library workflow and metadata | Needs Confirmation |
| Key User | Chi Trang / 3D Design | Validate sample library and search workflow | Inferred from user correction |
| BA / Coordination | Khoa | Process mapping, requirements, UAT coordination | Inferred from portfolio context |
| Technical / Data | TBD | Datamart, image search, data model support | Needs Confirmation |
| Users | 3D Design / CPD users | Search and reuse sample images or 3D assets | Needs Confirmation |

## Current Process
TBD after walkthrough.

Expected current process:

1. 3D Design users manage or reference visual sample information.
2. Sample images and 3D sample assets are stored in the current library, website, folders, or application.
3. Users search manually or through existing limited search.
4. Reuse depends on naming, folder structure, and personal knowledge.

## Target Process

1. User opens CPD Datamart / 3D sample library.
2. User searches by keyword, metadata, image, category, buyer, style, fabric, or other agreed fields.
3. System returns relevant sample images and 3D sample references.
4. User opens sample detail.
5. Authorized users update metadata or upload new assets.
6. Data quality checks prevent duplicates and missing required fields.

## Data and Source of Truth

| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| Sample image | CPD / 3D Design library | 3D Design | Missing metadata or duplicate image | Needs Confirmation |
| 3D sample asset | CPD / 3D Design storage | 3D Design | Broken links or inconsistent naming | Needs Confirmation |
| Sample metadata | CPD Datamart | 3D Design / CPD | Inconsistent tags or categories | Needs Confirmation |
| User permission | Internal access model | IT / 3D Design | Wrong edit/read access | Needs Confirmation |

## System / Automation Design
The system should operate as a visual datamart and searchable library. It should support image storage or image references, metadata tagging, search/filter, duplicate detection, permission, and future AI-powered visual search if approved.

## Business Rules

- Every sample image should have stable metadata.
- 3D sample assets should be linked to the correct sample record.
- Duplicate or near-duplicate images should be flagged where possible.
- Editing rights should be limited to authorized users.
- Search fields must be confirmed with 3D Design users.
- UAT must include real search scenarios from 3D Design.

## User Flow

1. User opens CPD Datamart.
2. User searches by text, metadata, or image if available.
3. System returns matching sample images and 3D assets.
4. User opens sample detail.
5. User downloads, references, or reuses the sample.
6. Authorized user updates metadata or adds new samples.
7. Changes are logged or traceable.

## KPI / Success Metrics

| KPI | Target | Current | Notes |
|---|---|---|---|
| Sample search time | TBD | TBD | Measure before/after |
| Search relevance | TBD | TBD | Needs user validation |
| Metadata completeness | TBD | TBD | Data quality KPI |
| Duplicate reduction | TBD | TBD | Needs baseline |
| 3D Design adoption | TBD | TBD | Needs baseline |

## Risks and Blockers

- Image metadata may be incomplete.
- Existing image folders or library may not be standardized.
- Image search quality depends on tagging or visual embedding quality.
- 3D sample asset links may be unstable.
- Permission model may be unclear.
- FD and CPD scopes may be confused if not documented separately.

## Decisions Needed

- Confirm current CPD / 3D Design sample library source.
- Confirm whether image search is metadata-based, visual similarity-based, or both.
- Confirm required metadata fields.
- Confirm technical approach for image storage and search.
- Confirm owner and UAT users.
- Confirm whether to create or promote CPD.Datamart.v1.1 as canonical root project note.

## Next Actions

- Confirm current CPD / 3D Design library location.
- Walk through Chi Trang / 3D Design sample search workflow.
- Collect sample image and 3D asset examples.
- Define metadata dictionary.
- Define search scenarios.
- Prepare UAT checklist.
- Keep FD.Datamart.v2.2 separate.

## Evidence and Confidence

| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Project identity | CPD Datamart with image search and 3D sample library | User correction | Strong |
| Department | 3D Design / CPD | User correction | Strong |
| Key capability | Image search | User correction | Strong |
| Relationship to FD | Separate from FD.Datamart.v2.2 | User correction | Strong |
| Phase | TBD | Needs registry confirmation | Needs Confirmation |

Related Concepts
[[Project Governance]]
[[Traceability]]
[[Image Search]]
[[Sample Library]]
[[Data Repository]]
[[Data Quality]]
[[Permission Model]]

Methods
[[Requirement Elicitation]]
[[Current State Analysis]]
[[Data Mapping]]
[[Search Requirement Design]]
[[UAT Planning]]

Projects
[[FD.Datamart.v2.2]]
[[TD.TechnicalPlatform_v2.1]]
[[PPJ.AI.Hub.v2.1]]
[[SCP.SOURCING.CHATBOT.v2.3]]

Deliverables
[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]

<!-- PPJ_PROJECT_KNOWLEDGE_END -->
