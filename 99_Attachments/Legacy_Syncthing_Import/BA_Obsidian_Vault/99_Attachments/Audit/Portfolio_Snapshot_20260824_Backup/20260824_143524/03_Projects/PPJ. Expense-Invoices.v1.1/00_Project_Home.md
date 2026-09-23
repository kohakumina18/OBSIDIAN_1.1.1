---
type: "project_home"
project: "PPJ.ExpenseInvoices.v1.1"
source_project: "PPJ. Expense-Invoices.v1.1.md"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
last_verified: "2026-08-24"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "UAT / Pre-Go-Live"
current_gate: "Production Readiness / Go-Live"
priority: "P4"
delivery_stage: "UAT / PRE-GO-LIVE"
status: "Active"
stage_entered_date: "Needs Confirmation"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | PPJ.ExpenseInvoices.v1.1 |
| Primary Domain | Finance / Accounting |
| Delivery Stage | UAT / PRE-GO-LIVE |
| Lifecycle | UAT / Pre-Go-Live |
| Status | Active |
| Progress | TBD |
| Current Gate | Production Readiness / Go-Live |
| Priority | P4 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Complete controlled expense-invoice rollout for all departments and factories except Export.

## Current Capability

Expense-invoice intake, mapping, validation and controlled processing for all departments/factories except Export.

## Latest Update

Expense period and mappings were confirmed, suppliers expanded, testing and user support continued, and defects were fixed. EXIM-first is historical only.

## Risks / Blockers

- Mapping completeness
- Real-data defects
- Go-live support readiness

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Close remaining defects and retest
- Confirm mapping and frequent-supplier readiness
- Complete production-readiness review and go-live decision

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[PPJ. Expense-Invoices.v1.1/00_Project_Home|Project Home]]
- [[PPJ. Expense-Invoices.v1.1/Project_Executive_Board|Project Executive Board]]
- [[PPJ. Expense-Invoices.v1.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# PPJ.ExpenseInvoices.v1.1

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | PPJ.ExpenseInvoices.v1.1 |
| Current File | PPJ. Expense-Invoices.v1.1.md |
| Primary Domain | Finance / Accounting |
| Secondary Domains | EXIM, ERP, Department Mapping |
| Lifecycle | UAT / Stabilization |
| Progress | TBD |
| Current Gate | Supplier and Mapping Expansion / Defect Closure |
| Priority | TBD |
| Business Owner | Needs Confirmation |
| Primary Users | Accounting |
| BA / Coordination | Uyên |
| Technical Members | Nam, Phát |
| Last Verified | 2026-08-01 |
| Confidence | Strong |

## One-Line Understanding

Expense invoice platform/workflow for mapping accounting fields, ledger, and department/factory rules before automation.

## Business Goal

Expense-invoice workflow for approved business scope, supplier mapping, department/factory mapping, ledger/account mapping, validation and controlled entry.

## Current Outcome

Expense-invoice workflow for approved business scope, supplier mapping, department/factory mapping, ledger/account mapping, validation and controlled entry.

## Latest Update

UAT continued with mapping expansion, frequent-supplier additions, bot adjustments, real-data defect capture, fixes and retesting. The current approved scope remains protected; EXIM-first wording is historical only, not current scope.

## Current Scope

- Expense invoice workflow/data mapping foundation.

## Current Risks / Blockers

- Mapping ownership and go-live boundary are not confirmed.
- Critical real-data defects and supplier-code inconsistencies remain open.
- Duplicate invoices, invalid mappings and weak error handling could affect Accounting operations.
- Production monitoring and escalation ownership are pending.

## Decisions Needed

- Approve supplier and mapping ownership.
- Confirm go-live boundary and production-support escalation.

## Next Actions

- Finalize frequent-supplier list and standardize supplier codes.
- Confirm mapping ownership and close critical defects.
- Run regression testing.
- Confirm go-live boundary, production monitoring and support escalation.

## Key Dependencies

- Supplier Master -> Supplier Mapping -> Department/Factory and Ledger Mapping -> Validation -> Expense Invoice Entry -> Monitoring

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
[[../PPJ. Expense-Invoices.v1.1]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/PPJ.ExpenseInvoices.v1.1.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
