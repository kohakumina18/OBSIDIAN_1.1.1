---
type: "weekly_status"
project: "ADMIN_ExpenseManagement_v1.1.0"
source_project: "ADMIN_ExpenseManagement_v1.1.0.md"
source_event: "PPJ-PROJECT-REGISTRATION-ADMIN_ExpenseManagement_v1.1.0-20260918"
last_verified: "2026-09-18"
confidence: "Needs Confirmation"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-09-18

| Field | Value |
| --- | --- |
| Canonical Code | ADMIN_ExpenseManagement_v1.1.0 |
| Domain | Administration |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | Active / Requirement Refinement / UAT Preparation |
| Status | Active |
| Progress | ~90% (2026-09-15 meeting recap) |
| Gate | Multi-traveler request model, end-to-end lifecycle and UAT preparation |
| Priority | P6 |
| Outcome | Standardize Administration business-travel and expense-management workflows: Request -> Approval -> Business Trip -> Advance -> Expense -> Settlement. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

Evolved well beyond the initial Travel Request application. Modules: TravelRequest, TravelApproval, TripManagement, Advance, Expense, Settlement. Latest major change: one request can contain multiple travelers, each with a traveler-specific travel plan (origin, destination, stops, dates, flight, hotel/shared room, per diem, customer visit). Management concern: prevent scope creep; the core stays Request -> Approval -> Trip -> Expense -> Settlement.

### Current Risks

- Scope creep beyond Request -> Approval -> Trip -> Expense -> Settlement
- Approval/status rules need confirmation
- Multi-traveler data model complexity

### Dependencies

- None recorded in the current portfolio snapshot.

### Next Actions

- Validate the booking workflow and status model
- Model multi-traveler requests with per-traveler travel plans
- Finalize approval matrix, advance, expense submission and settlement
- Define vendor catalogue and expense categories
- Prepare UAT
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Weekly Status

## Current Snapshot — 2026-10-16

- Lifecycle: Mapping Validation — 642x/627x confirmed; 641x open
- Progress: Material progress on GL mapping; WFX Analysis Code and 641x gaps remain
- Gate: Close 641x, Name3, organizational, VAT and posting rules; run golden cases
- Priority: P6
- Source Event: PPJ-WEEKLY-20261010-20261016

## Latest Verified Update

All 22 expense types now have confirmed **642x / 627x** GL mapping detail (Mrs. Violet — HCQT_WFX_AccountingMapping_v2.1.1_MrsViolet_641Update.xlsx). Four Name3 examples confirmed.

**Open gaps:**
- 641x details: none confirmed for any of the 22 expense types.
- 18 of 22 WFX Analysis Code mappings remain open.
- Conflicting evidence: 6421 vs 6427/6428 needs resolution.
- Production import: not ready.

## Current Blockers

- 641x mapping authority not confirmed (who approves?).
- WFX Analysis Code — 18/22 gaps block UAT posting golden cases.
- Organizational mapping and VAT rules not confirmed.
- No approved effective date for new rules.

## Decisions Needed

- **P0:** Approve mapping authority, exceptions, effective date and UAT gate (Accounting + HCQT + IT/WFX).
- Resolve 6421 vs 6427/6428 conflict.
- Confirm posting golden cases scope before production import.

## Next Actions

- Close 641x, Name3, organizational, VAT and posting rules.
- Run 641/642/627 golden cases with Mrs. Violet confirmation.
- Confirm WFX production import readiness gate.

## Update Protocol

Weekly updates should change only affected project memory, home, tasks, risks, decisions and relevant working documents.

## Evidence Basis

- Root project note: [[00_Project_Home]]
- Project memory: [[03_Projects/_Registry/Project_Memory/ADMIN_ExpenseManagement_v1.1.0.memory]]
- Weekly report: [[08_Meeting_Notes/WEEKLY_REPORTS/WEEKLY-REPORT-10-16.10.2026]]
- Source: HCQT_WFX_AccountingMapping_v2.1.1_MrsViolet_641Update.xlsx; PPJ_GL_COA_TT99_2026_Master_Research.xlsx
- Source event: PPJ-WEEKLY-20261010-20261016
- Last verified: 2026-10-16
- Confidence: Strong
