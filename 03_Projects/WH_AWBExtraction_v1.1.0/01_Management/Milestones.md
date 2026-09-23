---
type: "milestones"
project: "WH_AWBExtraction_v1.1.0"
source_project: "WH_AWBExtraction_v1.1.0.md"
source_event: "PPJ-PROJECT-REGISTRATION-WH_AWBExtraction_v1.1.0-20260918"
last_verified: "2026-09-18"
confidence: "Needs Confirmation"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-09-18

| Field | Value |
| --- | --- |
| Canonical Code | WH_AWBExtraction_v1.1.0 |
| Domain | Warehouse |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DEVELOPMENT |
| Lifecycle | Active Development |
| Status | Active |
| Progress | TBD |
| Gate | AWB image OCR and DHL email extraction; table/cell understanding and weight/unit reliability |
| Priority | Medium |
| Outcome | Canonical umbrella for AWB OCR + DHL email extraction: both channels converge into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates). |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

Now one project, not two. Channel A: AWB Image -> Document Detection -> OCR -> Table/Structure Understanding -> Cell Boundary Detection -> Field Extraction -> Validation. Channel B: DHL Email -> Email Parsing -> Shipment Detection -> AWB Mapping -> Field Extraction -> Validation. Technical priorities: table structure, cell boundaries, weight/unit reliability, post-processing, validation rules, confidence, human review, logging.

### Current Risks

- Mixed-unit weight extraction
- Table/cell-boundary errors

### Dependencies

- None recorded in the current portfolio snapshot.

### Next Actions

- Improve table structure and cell-boundary understanding
- Improve shipment weight and weight-unit reliability (kg/g/lb/lbs/oz, mixed units)
- Add post-processing and validation rules
- Add confidence scoring and human review
- Add extraction logging and DHL email channel mapping to the Canonical AWB Record
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Milestones

| Milestone | State | Evidence / Exit Condition | Owner | Target |
| --- | --- | --- | --- | --- |
| Current Gate: Registration / Business Discovery | Current | Gate evidence reviewed | Needs Confirmation | TBD |
| Next Approved Outcome | Planned | Extract AWB image and DHL email data into one validated Canonical AWB Record (AWB number, sender, recipient, pieces, weight, unit, reference, origin, carrier, destination, dates) with confidence scoring and human review. | Needs Confirmation | TBD |
| Operational Handover or Closeout | Not Started | Acceptance, ownership and support confirmed | Needs Confirmation | TBD |

## Notes

Milestone dates remain TBD until confirmed by the responsible owner.

## Evidence Basis

- Root project note: [[03_Projects/WH_AWBExtraction_v1.1.0]]
- Project memory: [[03_Projects/_Registry/Project_Memory/WH_AWBExtraction_v1.1.0.memory]]
- Source event: PPJ-PROJECT-REGISTRATION-WH_AWBExtraction_v1.1.0-20260918
- Last verified: 2026-09-18
- Confidence: Needs Confirmation
