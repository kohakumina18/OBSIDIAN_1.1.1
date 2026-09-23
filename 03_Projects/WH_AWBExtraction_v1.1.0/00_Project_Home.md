---
type: "project_home"
project: "WH_AWBExtraction_v1.1.0"
source_project: "WH_AWBExtraction_v1.1.0.md"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
last_verified: "2026-09-18"
confidence: "Needs Confirmation"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
delivery_stream: "INTERNAL DEVELOPMENT"
delivery_stage: "DEVELOPMENT"
status: "Active"
stage_entered_date: "Needs Confirmation"
lifecycle: "Active Development"
current_gate: "AWB image OCR and DHL email extraction; table/cell understanding and weight/unit reliability"
priority: "Medium"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | WH_AWBExtraction_v1.1.0 |
| Legacy Code(s) | Warehouse AWB OCR; WH.AWB.EXTRACTION; AWB-OCR-EMAILS |
| Primary Domain | Warehouse |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DEVELOPMENT |
| Lifecycle | Active Development |
| Status | Active |
| Progress | TBD |
| Current Gate | AWB image OCR and DHL email extraction; table/cell understanding and weight/unit reliability |
| Priority | Medium |
| Business Owner | Warehouse |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

Canonical umbrella for AWB OCR + DHL email extraction: both channels converge into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates).

## Current Capability

AWB image + DHL email -> Canonical AWB Record with validation, confidence and human review.

## Latest Update

Now one project, not two. Channel A: AWB Image -> Document Detection -> OCR -> Table/Structure Understanding -> Cell Boundary Detection -> Field Extraction -> Validation. Channel B: DHL Email -> Email Parsing -> Shipment Detection -> AWB Mapping -> Field Extraction -> Validation. Technical priorities: table structure, cell boundaries, weight/unit reliability, post-processing, validation rules, confidence, human review, logging.

## Risks / Blockers

- Mixed-unit weight extraction
- Table/cell-boundary errors

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Improve table structure and cell-boundary understanding
- Improve shipment weight and weight-unit reliability (kg/g/lb/lbs/oz, mixed units)
- Add post-processing and validation rules
- Add confidence scoring and human review
- Add extraction logging and DHL email channel mapping to the Canonical AWB Record

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[WH_AWBExtraction_v1.1.0/00_Project_Home|Project Home]]
- [[WH_AWBExtraction_v1.1.0/Project_Executive_Board|Project Executive Board]]
- [[WH_AWBExtraction_v1.1.0/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# WH_AWBExtraction_v1.1.0

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | WH_AWBExtraction_v1.1.0 |
| Current File | WH_AWBExtraction_v1.1.0.md |
| Primary Domain | Warehouse |
| Secondary Domains | Automation |
| Lifecycle | Development |
| Progress | Not Started |
| Current Gate | Registration / Business Discovery |
| Priority | Medium |
| Business Owner | Warehouse |
| Primary Users | Warehouse shipping-document users |
| BA / Coordination | Khoa |
| Technical Members | Needs Confirmation |
| Last Verified | 2026-09-18 |
| Confidence | Needs Confirmation |

## One-Line Understanding

Warehouse project for AWB: Extraction.

## Business Goal

Extract AWB image and DHL email data into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates) with confidence scoring and human review.

## Current Outcome

Extract AWB image and DHL email data into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates) with confidence scoring and human review.

## Latest Update

Project registered; business discovery and source confirmation are pending.

## Current Scope

- AWB
- Extraction

## Current Risks / Blockers

- Needs Confirmation
- Scope, rules, data ownership and acceptance require confirmation.

## Decisions Needed

- Confirm business rules, source of truth and delivery ownership.

## Next Actions

- Improve table structure and cell-boundary understanding and weight/unit reliability

## Key Dependencies

- AWB images (OCR); DHL emails (email parsing)

## Current Deliverables

- Project profile and plan
- Business and requirements pack appropriate to lifecycle
- Data, process and solution documents where applicable
- Governance logs and operational task board

## Workspace Navigation

### Management

- [[01_Management/Project_Profile]]
- [[01_Management/Project_Plan]]
- [[01_Management/Milestones]]
- [[01_Management/Weekly_Status]]

### Business

- [[02_Business/Business_Context]]
- [[02_Business/BRD]]
- [[02_Business/Scope_and_Business_Rules]]

### Process

- [[03_Process/AS_IS_Process]]
- [[03_Process/TO_BE_Process]]
- [[03_Process/Process_Gaps]]

### Data

- [[04_Data/Data_Spec]]
- [[04_Data/Data_Source_Inventory]]
- [[04_Data/Data_Quality_and_Traceability]]

### Requirements

- [[05_Requirements/Functional_Requirements]]
- [[05_Requirements/Use_Cases]]
- [[05_Requirements/Acceptance_Criteria]]

### Solution

- [[06_Solution/Solution_Overview]]
- [[06_Solution/Integration_Spec]]

### Test / UAT

- [[07_Test_UAT/UAT_Plan]]
- [[07_Test_UAT/UAT_Cases]]
- [[07_Test_UAT/Defect_Log]]

### Implementation

- [[08_Implementation/Implementation_Plan]]
- [[08_Implementation/Deployment_Checklist]]

### Operations

- [[09_Operations/User_Manual]]
- [[09_Operations/Support_and_Maintenance]]

### Governance

- [[10_Governance/Risks_Issues]]
- [[10_Governance/Decision_Log]]
- [[10_Governance/Dependencies]]
- [[10_Governance/Change_Log]]

### Project Board

- [[Project_Executive_Board]]
- [[Tasks]]
- [[Meetings]]
- [[Evidence]]

## Source of Truth

Root Project Note:
[[../WH_AWBExtraction_v1.1.0]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/WH_AWBExtraction_v1.1.0.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
