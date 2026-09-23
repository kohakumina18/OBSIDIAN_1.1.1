---
type: project
project_name: "WH_AWBExtraction_v1.1.0"
project_code: "WH_AWBExtraction_v1.1.0"
canonical_code: "WH_AWBExtraction_v1.1.0"
current_file: "WH_AWBExtraction_v1.1.0.md"
department: "Warehouse"
object: "AWB"
project_characteristic: "Extraction"
version: "v1.1.0"
phase: "Development"
lifecycle: "Development"
cluster: "Automation"
priority: "Medium"
business_owner: "Warehouse"
ba_coordination: "Khoa"
technical_members: []
status: "Registered"
last_updated: "2026-09-18"
last_verified: "2026-09-18"
source_event: "PPJ-PROJECT-REGISTRATION-WH_AWBExtraction_v1.1.0-20260918"
confidence: "Needs Confirmation"
---

# WH_AWBExtraction_v1.1.0

<!-- PPJ_PROJECT_KNOWLEDGE_START -->
## Business Problem

AWB documents and DHL emails are read and keyed manually; shipment weight and unit extraction is unreliable across mixed units (kg/g/lb/lbs/oz) and table layouts.

## Business Outcome

Extract AWB image and DHL email data into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates) with confidence scoring and human review.

## Target Users

Warehouse shipping-document users

## Systems / Data

AWB images (OCR); DHL emails (email parsing)

## Next Action

Improve table structure and cell-boundary understanding and weight/unit reliability

## Workspace

- [[WH_AWBExtraction_v1.1.0/00_Project_Home|Project Workspace]]
- [[WH_AWBExtraction_v1.1.0/Project_Executive_Board|Project Executive Board]]
<!-- PPJ_PROJECT_KNOWLEDGE_END -->
