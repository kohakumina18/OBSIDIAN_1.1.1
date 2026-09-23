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

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

# Project Knowledge Detail

## Executive Summary
FD.Datamart.v2.2 is the FD / fabric datamart project using Directus as a backend/admin/data platform. The project supports FD sample or fabric data management and includes a module for QR design or QR information formatting so QR codes can be attached to hangers.

This project is separate from CPD.Datamart.v1.1.

## Business Context
FD needs a structured way to manage fabric/sample/hanger-related data and make it reusable for lookup, printing, QR formatting, and operational follow-up. Directus can provide the admin/data management layer, while the QR design module supports hanger usage by turning the data into a scannable or printable format.

## Problem Statement
Fabric and hanger-related data can become fragmented if the data model, QR format, and ownership are not standardized. Without a governed datamart, FD users may need to manage sample/fabric information manually or across scattered files, making lookup, update, and QR hanger preparation inefficient.

## Objectives

- Build or stabilize FD datamart using Directus.
- Define fabric/sample/hanger data fields.
- Support QR design or QR information format for hanger usage.
- Improve lookup and reuse of FD data.
- Clarify ownership, permission, and update process.
- Prepare data foundation for future search, reporting, or AI-assisted lookup if approved.

## Scope

### In Scope

- FD / fabric / hanger-related data model
- Directus data management
- QR design or QR information module
- Hanger QR usage flow
- Data ownership and permission
- UAT with FD users
- Data quality checks for required fields

### Out of Scope

- CPD image search library
- 3D Design sample library
- CPD.Datamart.v1.1
- Sourcing chatbot repository
- R&D Wash sampling portal
- Full AI recommendation before data is stable

## Stakeholders

| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Business Owner | FD | Confirm data fields, hanger workflow, and usage | Needs Confirmation |
| BA / Coordination | Khoa | Process mapping, requirements, UAT coordination | Inferred from portfolio context |
| Technical / Data | Nghia, Nam, Linh | Directus, data model, UI or QR support | Needs Confirmation |
| Users | FD / sample / hanger users | Search, manage, print, or scan hanger information | Needs Confirmation |

## Current Process
TBD after walkthrough.

Expected current process:

1. FD users manage fabric/sample/hanger-related data.
2. Data is prepared for hanger usage.
3. QR format or QR information needs to be designed or generated.
4. QR is attached to hanger.
5. Users scan or use the hanger QR to access relevant information.

## Target Process

1. FD user manages data in Directus or the target FD datamart interface.
2. Required fields are validated.
3. User generates or designs QR information format for hanger.
4. QR is attached to the hanger.
5. Scanning or using the QR leads to the correct sample/fabric/hanger information.
6. Updates are governed by permission and ownership rules.

## Data and Source of Truth

| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| Fabric/sample record | FD Datamart / Directus | FD | Missing or inconsistent metadata | Needs Confirmation |
| Hanger information | FD Datamart / QR module | FD | Wrong QR mapping or outdated data | Needs Confirmation |
| QR format/design | QR design module | FD / IT | Format mismatch or unreadable QR | Needs Confirmation |
| User permission | Directus / internal access model | IT / FD | Incorrect edit/read access | Needs Confirmation |

## System / Automation Design
The system should use Directus or a similar data platform to manage FD data. A QR design or QR information module should generate the structure needed for hanger usage. The system should support data CRUD, validation, permission, and stable links between hanger QR and underlying FD records.

## Business Rules

- Every hanger QR should map to the correct FD record.
- Required metadata must be confirmed with FD.
- QR format should be readable and stable.
- Only authorized users can update FD records.
- Data changes should not break existing hanger QR links.
- UAT must include actual hanger usage or QR scan validation.

## User Flow

1. User opens FD Datamart / Directus.
2. User creates or updates fabric/sample/hanger record.
3. System validates mandatory fields.
4. User generates or previews QR information format.
5. User attaches QR to hanger.
6. User scans or opens QR link.
7. System displays the correct FD information.

## KPI / Success Metrics

| KPI | Target | Current | Notes |
|---|---|---|---|
| Hanger QR preparation time | TBD | TBD | Measure before/after |
| QR mapping accuracy | TBD | TBD | Must be validated in UAT |
| Required field completion | TBD | TBD | Data quality KPI |
| FD user adoption | TBD | TBD | Needs baseline |
| Data lookup time | TBD | TBD | Measure before/after |

## Risks and Blockers

- Directus data model may be incomplete.
- QR format may not match hanger operation.
- Data ownership may be unclear.
- QR link stability must be guaranteed.
- FD and CPD scopes may be confused if not documented separately.

## Decisions Needed

- Confirm final FD data model.
- Confirm Directus role and target architecture.
- Confirm QR design/module requirement.
- Confirm QR output format and scan behavior.
- Confirm owner and UAT users.
- Confirm whether this project should stay as FD.Datamart.v2.2 or be renamed later.

## Next Actions

- Walk through current FD hanger workflow.
- Confirm Directus collections and fields.
- Define QR/hanger data mapping.
- Validate QR scan behavior.
- Prepare UAT checklist with FD users.
- Keep CPD.Datamart.v1.1 as separate project.

## Evidence and Confidence

| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Project identity | FD Datamart with Directus and QR hanger design module | User correction | Strong |
| CPD relationship | Separate from CPD.Datamart.v1.1 | User correction | Strong |
| Technical platform | Directus | User correction | Strong |
| Business use | QR design / QR attached to hanger | User correction | Strong |
| Phase | TBD | Needs registry confirmation | Needs Confirmation |

Related Concepts
[[Project Governance]]
[[Traceability]]
[[Data Repository]]
[[QR Workflow]]
[[Data Quality]]
[[Permission Model]]

Methods
[[Requirement Elicitation]]
[[Current State Analysis]]
[[Data Mapping]]
[[UAT Planning]]
[[Acceptance Criteria]]

Projects
[[CPD.Datamart.v1.1]]
[[SCP.SOURCING.CHATBOT.v2.3]]
[[TD.TechnicalPlatform_v2.1]]
[[PPJ.AI.Hub.v2.1]]

Deliverables
[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]

<!-- PPJ_PROJECT_KNOWLEDGE_END -->






