---
type: registered_initiative
initiative: "WH_AWBExtraction_v1.1.0"
registration_status: "Registered"
primary_domain: "Warehouse"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
last_verified: 2026-09-18
---

# WH_AWBExtraction_v1.1.0

Registered as a canonical project by `PPJ-PORTFOLIO-SNAPSHOT-20260918` (previously the candidate `Warehouse AWB OCR`). Its root project note, memory card and workspace are `WH_AWBExtraction_v1.1.0` (created with `scripts/register_ppj_project.py`).

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

