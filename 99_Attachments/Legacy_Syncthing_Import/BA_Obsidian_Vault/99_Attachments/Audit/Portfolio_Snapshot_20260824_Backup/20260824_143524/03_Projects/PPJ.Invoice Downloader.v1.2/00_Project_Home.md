---
type: "project_home"
project: "PPJ.InvoiceDownloader.v1.2"
source_project: "PPJ.Invoice Downloader.v1.2.md"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
last_verified: "2026-08-24"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "Production"
current_gate: "Operational reliability"
priority: "Support"
delivery_stage: "GO-LIVE / PRODUCTION / SUPPORT"
status: "Active"
stage_entered_date: "Needs Confirmation"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | PPJ.InvoiceDownloader.v1.2 |
| Primary Domain | Finance / Accounting |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Production |
| Status | Active |
| Progress | TBD |
| Current Gate | Operational reliability |
| Priority | Support |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Operate e-invoice download for XML/PDF/metadata, merge, API and reporting-source use.

## Current Capability

Operate e-invoice download for XML/PDF/metadata, merge, API and reporting-source use.

## Latest Update

Production operations focus on portal changes, credentials, retry, missing/duplicate invoices, monitoring and audit.

## Risks / Blockers

- No current portfolio-level risk recorded.

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Monitor portal and credential changes
- Track retries, missing invoices and duplicates
- Maintain audit evidence

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[PPJ.Invoice Downloader.v1.2/00_Project_Home|Project Home]]
- [[PPJ.Invoice Downloader.v1.2/Project_Executive_Board|Project Executive Board]]
- [[PPJ.Invoice Downloader.v1.2/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# PPJ.InvoiceDownloader.v1.2

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | PPJ.InvoiceDownloader.v1.2 |
| Current File | PPJ.Invoice Downloader.v1.2.md |
| Primary Domain | Finance / Accounting |
| Secondary Domains | EXIM, Purchasing, API, E-invoice |
| Lifecycle | Production / Business Adoption |
| Progress | TBD |
| Current Gate | Business Adoption |
| Priority | P2 |
| Business Owner | Needs Confirmation |
| Primary Users | Accounting / EXIM / Uyen / Nam / Phat |
| BA / Coordination | Uyên |
| Technical Members | Khoa, Nam, Nam, Phát |
| Last Verified | 2026-07-13 |
| Confidence | Strong |

## One-Line Understanding

API/tool for downloading and merging e-invoices, now accessible through GPT/PERRI-enabled automation.

## Business Goal

Reduce manual invoice download/merge work while adding logging, permission, retry, and fallback controls.

## Current Outcome

Reduce manual invoice download/merge work while adding logging, permission, retry, and fallback controls.

## Latest Update

Canonical naming maps Invoice Downloader and SYS.INVOICES aliases here.

## Current Scope

- Production/API enhancement project for invoice download and output standardization.

## Current Risks / Blockers

- Credential/session, permission, portal UI/API changes, duplicate/missing invoice, metadata accuracy.

## Decisions Needed

- Confirm business owner.
- Confirm technical owner.
- Confirm source of truth.
- Confirm phase, scope, and next action.

## Next Actions

- Review repaired block with project owner.
- Confirm missing data fields and workflow.
- Update related BRD/SOP/user manual after confirmation.

## Key Dependencies

- Needs Confirmation

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
[[../PPJ.Invoice Downloader.v1.2]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/PPJ.InvoiceDownloader.v1.2.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
