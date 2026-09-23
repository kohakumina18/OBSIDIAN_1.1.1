---
type: "project"
project_name: "FD.Datamart.v2.2"
project_code: "FD.Datamart.v2.2"
department: "FD"
object: "Inferred from filename"
project_characteristic: "data platform"
version: "v2.2"
phase: "TBD"
cluster: "Sourcing / Material / Supplier Data"
owner: "TBD"
business_owner: "TBD"
technical_owner: "TBD"
members: []
stakeholders: []
systems: []
data_sources: []
status: "TBD"
progress: "TBD"
priority: "P2"
blocked: "TBD"
decision_needed: "TBD"
next_action: "TBD"
last_updated: "2026-06-28"
confidence: "Strong for corrected business concept; implementation details need confirmation"
source_files: []
---

---

## Project Resource Governance

BA / Coordination:
Khoa

Technical Members:
TBD

Business Stakeholder / Department:
FD

Portfolio Group:
Data / Dashboard / Portal

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

<!-- generated content start -->

# Project Knowledge Detail

## Executive Summary
This project represents the CPD Datamart / sample management portal initiative. The business goal is to port or modernize the existing CPD website/application that is currently used to manage sample information for Chi Trang in the 3D Design department.

The project should create a structured, searchable, governed sample data repository so CPD and 3D Design users can manage, search, review, and reuse sample information more effectively.

## Business Context
CPD and 3D Design need a reliable way to manage sample records, sample metadata, images or reference assets, and related tracking information. The current process appears to depend on an existing CPD website/application. The new project should port this workflow into a more maintainable data platform or internal portal.

This sits in the Data Repository / Dashboard / Portal portfolio group together with R&D Wash Sampling Portal, Sourcing repository, FD QR Hanger, Inventory Report, Market Intelligence, and production dashboards.

## Problem Statement
Sample information is valuable but can become hard to search, govern, and reuse if metadata, naming convention, ownership, and permission are not standardized. If the existing CPD website is not properly documented or ported, the team risks losing process knowledge and creating duplicate sample records.

## Objectives

- Document the current CPD sample management website/application.
- Identify the users, especially Chi Trang and the 3D Design department.
- Define the sample data model and metadata.
- Confirm the source of truth for sample records.
- Prepare a porting or migration plan into the target internal platform.
- Improve search, filtering, governance, and future AI-readiness of sample data.

## Scope

### In Scope

- Current CPD website/application process review
- Sample record structure
- Sample metadata definition
- User role and permission mapping
- Data migration / porting plan
- Sample search and filter requirements
- Data quality and duplicate checking
- Target portal/datamart concept
- UAT checklist with Chi Trang / 3D Design

### Out of Scope

- Replacing all FD / Sourcing / R&D Wash sample systems without approval
- Merging this project into Sourcing Chatbot
- Merging this project into R&D Wash Sampling Portal
- Renaming the file without approval
- Building AI recommendation before source data is stable

## Stakeholders

| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Business User | Chi Trang / 3D Design | Manage and validate sample workflow | Needs Confirmation |
| Department Owner | CPD / 3D Design | Confirm process, fields, and access | Needs Confirmation |
| BA / Coordination | Khoa | Process mapping, requirements, UAT coordination | Inferred from portfolio context |
| Technical / Data | Linh, Phat | Datamart/data pipeline/data analysis support | Inferred from resource mapping |
| Related Users | FD / CPD / Design | Search, manage, or reuse sample data | Needs Confirmation |

## Current Process
TBD after walkthrough.

Expected current process:

1. CPD or 3D Design user opens the existing CPD website/application.
2. User creates, updates, or searches sample records.
3. Sample information may include metadata, images, references, owner, status, and related design information.
4. Chi Trang or the 3D Design team uses this data to manage sample visibility and follow-up.
5. Data may need to be migrated or synchronized into a newer internal portal/datamart.

## Target Process
1. User accesses the new CPD Datamart / sample portal.
2. User searches or filters sample records by agreed metadata.
3. User opens sample detail with images/assets and business context.
4. Authorized users create or update sample records.
5. Data quality checks prevent duplicates and missing mandatory fields.
6. CPD / 3D Design validates the record.
7. The record becomes reusable for reporting, lookup, and future AI/search use cases.

## Data and Source of Truth
| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| Sample record | Existing CPD website/application | CPD / 3D Design | Missing metadata, duplicates | Needs Confirmation |
| Sample image / asset | Existing CPD website or file storage | CPD / 3D Design | Broken links, inconsistent naming | Needs Confirmation |
| Sample status | Existing workflow | CPD / 3D Design | Unclear status definition | Needs Confirmation |
| User / permission | Existing website or internal account model | IT / CPD | Access control mismatch | Needs Confirmation |
| Metadata dictionary | To be defined | BA / Data team | Inconsistent field names | Needs Confirmation |

## System / Automation Design
The system should behave as a structured datamart or portal layer for CPD sample management. It should support sample record CRUD, search, filtering, ownership, permission, data validation, and future integration with PPJ.AI.Hub or AI search if appropriate.

Potential target components:

- database / datamart
- internal portal UI
- Directus or similar data admin layer if applicable
- image/file storage
- search index
- reporting/dashboard layer
- permission model

## Business Rules

- Every sample should have a unique identifier.
- Mandatory metadata must be confirmed with CPD / 3D Design.
- Duplicate sample records should be flagged.
- Images/assets should be linked with stable paths or IDs.
- Only authorized users can edit records.
- Read access and edit access may be different.
- Migration should preserve original record identity where possible.
- UAT must include Chi Trang or assigned 3D Design representative.

## KPI / Success Metrics
| KPI | Target | Current | Notes |
|---|---|---|---|
| Sample search time | TBD | TBD | Measure before/after |
| Duplicate rate | TBD | TBD | Needs baseline |
| Mandatory field completion | TBD | TBD | Data quality KPI |
| User adoption | TBD | TBD | 3D Design / CPD users |
| Migration accuracy | TBD | TBD | Sample records migrated correctly |

## Risks and Blockers

- Current CPD website structure is not documented
- Data export may be difficult
- Sample metadata may be inconsistent
- Images/assets may not have stable links
- Permission model may be unclear
- Chi Trang / 3D Design availability for UAT may be limited
- Risk of confusing CPD Datamart with FD QR Hanger or Sourcing sample repository

## Decisions Needed

- Confirm whether current filename should remain FD.Datamart.v2.2.md or be renamed later to CPD.Datamart.v1.1.md.
- Confirm owner and key users.
- Confirm target platform.
- Confirm sample metadata fields.
- Confirm migration approach.
- Confirm access control model.

## Next Actions

- Schedule walkthrough with Chi Trang / 3D Design.
- Capture current CPD website screens and workflow.
- Export or sample current data structure.
- Draft sample metadata dictionary.
- Define UAT checklist.
- Decide rename separately after scope confirmation.

## Evidence and Confidence
| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Current Obsidian Filename | FD.Datamart.v2.2.md | Current project folder | Strong |
| Business Canonical Concept | CPD.Datamart.v1.1 | User correction | Strong |
| Rename Status | Needs Approval | Current instruction | Strong |
| Recommended Future Filename | CPD.Datamart.v1.1.md | User correction | Strong |
| Business concept | CPD sample management datamart / portal | User correction + portfolio context | Strong |
| Key user | Chi Trang / 3D Design | User correction | Strong |
| Technical members | Linh, Phat | Resource mapping | Medium |
| Phase | TBD / Needs Confirmation | Portfolio lifecycle + resource map | Medium |

Evidence sources:
03_Projects\_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: |[[FD.Datamart.v2.2]]] | FD QR Hanger | TBD / TBD | Khoa | TBD | FD | Data / Dashboard / Portal | High - zero-byte note | P2 | TBD | TBD | TBD | FD Hanger VER2.md | 40 |
03_Projects\_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: -[[FD.Datamart.v2.2]]] - Risk: High - zero-byte note; Blocker: TBD
03_Projects\_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: -[[FD.Datamart.v2.2]]] - Department: FD
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: -[[FD.Datamart.v2.2]]] - Data / Dashboard / Portal - P2
09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: -[[FD.Datamart.v2.2]]] - P2 - FD
User correction 2026-06-28: CPD sample management portal for chi Trang / 3D Design

## Related Concepts
[[Project Governance]]
[[Traceability]]
[[Data Repository]]
[[Sample Management]]
[[Data Quality]]
[[Permission Model]]

## Methods
[[Requirement Elicitation]]
[[Impact Analysis]]
[[Data Mapping]]
[[User Journey Mapping]]
[[Acceptance Criteria]]

## Projects
[[PPJ.AI.Hub.v2.1]]
[[SCP.SOURCING.CHATBOT.v2.3]]
[[WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1]]
[[TD.TechnicalPlatform_v2.1]]

## Deliverables
[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[ERD_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]

<!-- generated content end -->


