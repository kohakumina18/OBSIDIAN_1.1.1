---
type: project_memory
project_name: "WH_AWBExtraction_v1.1.0"
project_file: "WH_AWBExtraction_v1.1.0.md"
project_code: "WH_AWBExtraction_v1.1.0"
department: "Warehouse"
cluster: "Automation"
phase: "DEVELOPMENT"
status: "Active"
priority: "Medium"
business_owner: "Warehouse"
ba_coordination: ["Khoa"]
technical_members: []
stakeholders: []
systems: []
data_sources: ["AWB images (OCR); DHL emails (email parsing)"]
last_verified: "2026-09-18"
confidence: "Strong"
workspace_path: "03_Projects/WH_AWBExtraction_v1.1.0"
project_home: "03_Projects/WH_AWBExtraction_v1.1.0/00_Project_Home.md"
project_board: "03_Projects/WH_AWBExtraction_v1.1.0/Project_Executive_Board.canvas"
task_folder: "03_Projects/WH_AWBExtraction_v1.1.0/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
canonical_code: "WH_AWBExtraction_v1.1.0"
current_file: "WH_AWBExtraction_v1.1.0.md"
primary_domain: "Warehouse"
delivery_stream: "INTERNAL DEVELOPMENT"
delivery_stage: "DEVELOPMENT"
lifecycle: "Active Development"
progress: "TBD"
current_gate: "AWB image OCR and DHL email extraction; table/cell understanding and weight/unit reliability"
current_outcome: "Canonical umbrella for AWB OCR + DHL email extraction: both channels converge into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates)."
latest_update_summary: "Now one project, not two. Channel A: AWB Image -> Document Detection -> OCR -> Table/Structure Understanding -> Cell Boundary Detection -> Field Extraction -> Validation. Channel B: DHL Email -> Email Parsing -> Shipment Detection -> AWB Mapping -> Field Extraction -> Validation. Technical priorities: table structure, cell boundaries, weight/unit reliability, post-processing, validation rules, confidence, human review, logging."
known_risks: "Mixed-unit weight extraction | Table/cell-boundary errors"
known_blockers: "Mixed-unit weight extraction | Table/cell-boundary errors"
decisions_needed: "None recorded"
next_actions: "Improve table structure and cell-boundary understanding | Improve shipment weight and weight-unit reliability (kg/g/lb/lbs/oz, mixed units) | Add post-processing and validation rules | Add confidence scoring and human review | Add extraction logging and DHL email channel mapping to the Canonical AWB Record"
dependencies: "None recorded"
stage_entered_date: "Needs Confirmation"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260918"]
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

# Project Memory: WH_AWBExtraction_v1.1.0

## One-Line Understanding

Warehouse project for AWB: Extraction.

## Business Meaning

AWB documents and DHL emails are read and keyed manually; shipment weight and unit extraction is unreliable across mixed units (kg/g/lb/lbs/oz) and table layouts.

## Outcome

Extract AWB image and DHL email data into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates) with confidence scoring and human review.

## What This Project Is

Extraction

## What This Project Is Not

Not a replacement or merger of another canonical project unless separately approved.

## Key Users

Warehouse shipping-document users

## Systems / Data

AWB images (OCR); DHL emails (email parsing)

## Current Phase / Status

Development / Registered

## Known Risks

Needs Confirmation

## Decisions Needed

Confirm scope, ownership, source-of-truth and lifecycle gate.

## Next Actions

Improve table structure and cell-boundary understanding and weight/unit reliability

## Do Not Drift Rules

- Do not invent owners, systems, tables, dates, rules or implementation status.
- Do not merge or rename this project without approval.

## Source Links

- [[WH_AWBExtraction_v1.1.0]]
- [[03_Projects/WH_AWBExtraction_v1.1.0/00_Project_Home|Project Workspace]]
