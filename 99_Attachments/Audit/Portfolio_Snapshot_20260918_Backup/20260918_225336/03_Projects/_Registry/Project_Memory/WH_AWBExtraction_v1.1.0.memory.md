---
type: project_memory
project_name: "WH_AWBExtraction_v1.1.0"
project_file: "WH_AWBExtraction_v1.1.0.md"
project_code: "WH_AWBExtraction_v1.1.0"
department: "Warehouse"
cluster: "Automation"
phase: "Development"
status: "Registered"
priority: "Medium"
business_owner: "Warehouse"
ba_coordination: ["Khoa"]
technical_members: []
stakeholders: []
systems: []
data_sources: ["AWB images (OCR); DHL emails (email parsing)"]
last_verified: "2026-09-18"
confidence: "Needs Confirmation"
workspace_path: "03_Projects/WH_AWBExtraction_v1.1.0"
project_home: "03_Projects/WH_AWBExtraction_v1.1.0/00_Project_Home.md"
project_board: "03_Projects/WH_AWBExtraction_v1.1.0/Project_Executive_Board.canvas"
task_folder: "03_Projects/WH_AWBExtraction_v1.1.0/Tasks"
documentation_status: "Workspace Created"
source_event: "PPJ-PROJECT-REGISTRATION-WH_AWBExtraction_v1.1.0-20260918"
---

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
