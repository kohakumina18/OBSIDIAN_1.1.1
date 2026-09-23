---
type: "project_home"
project: "PUR.GDI.Automation.v1.0"
source_project: "PUR.GDI Automation.md"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
last_verified: "2026-08-24"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "Active / WFX API Integration"
current_gate: "WFX API contract discovery and controlled integration design"
priority: "P3"
delivery_stage: "DESIGN"
status: "Active"
stage_entered_date: "Needs Confirmation"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | PUR.GDI.Automation.v1.0 |
| Primary Domain | Sourcing / Purchasing |
| Delivery Stage | DESIGN |
| Lifecycle | Active / WFX API Integration |
| Status | Active |
| Progress | TBD |
| Current Gate | WFX API contract discovery and controlled integration design |
| Priority | P3 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Automate GDI creation/update while preserving WFX transaction control, validation, confirmation and audit.

## Current Capability

PPJ GDI application using supported WFX APIs; never direct-write Databricks as a substitute for WFX transactions.

## Latest Update

Purchasing teams and MER leaders/managers confirmed the business flow; WFX API support materially reduced technical uncertainty. Selenium is fallback only.

## Risks / Blockers

- WFX API ownership and sandbox
- Authentication and rate limits
- Transaction integrity

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- WFX API -> Business validation -> Controlled GDI transaction -> Confirmation / Audit

## Next Actions

- Obtain WFX API authentication and operation documentation
- Confirm create/update/lookup/draft/submit/cancel/status schemas
- Define validation, idempotency, duplicate, retry and timeout controls
- Design audit logging and transaction confirmation

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[PUR.GDI Automation/00_Project_Home|Project Home]]
- [[PUR.GDI Automation/Project_Executive_Board|Project Executive Board]]
- [[PUR.GDI Automation/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# PUR.GDI.Automation.v1.0

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | PUR.GDI.Automation.v1.0 |
| Current File | PUR.GDI Automation.md |
| Primary Domain | Sourcing / Purchasing |
| Secondary Domains | WFX, Purchasing Operations |
| Lifecycle | Analysis / Solution Redesign |
| Progress | TBD |
| Current Gate | Business Flow Confirmed / API Integration Discovery |
| Priority | P2 |
| Business Owner | Needs Confirmation |
| Primary Users | Purchasing and participating MER leaders/managers |
| BA / Coordination | Uyên |
| Technical Members | Hien, Khoa, Nam, Phát |
| Last Verified | 2026-08-01 |
| Confidence | Strong |

## One-Line Understanding

Purchasing GDI creation automation currently on hold due WFX/system dependency.

## Business Goal

API-first GDI creation and update workflow that reduces manual Purchasing work while preserving review, transaction control and auditability in WFX.

## Current Outcome

API-first GDI creation and update workflow that reduces manual Purchasing work while preserving review, transaction control and auditability in WFX.

## Latest Update

Purchasing and selected MER leaders/managers confirmed the business flow, required input, creation conditions, review responsibilities and target output. Architecture direction changed from Selenium screen simulation to approved API integration.

## Current Scope

- Automation for Goods Delivery Instruction creation.

## Current Risks / Blockers

- Official WFX API documentation, authorization and non-production environment are not confirmed.
- Rollback, draft/review and idempotency behavior are not confirmed.
- Direct unapproved Databricks writes would not constitute a governed WFX transaction.
- Duplicate transactions and incomplete rollback could damage operational data.

## Decisions Needed

- Approve WFX API or vendor-approved transactional service.
- Confirm transaction, rollback, approval and audit architecture.

## Next Actions

- Request WFX API documentation and supported create/update/draft/submit/cancel/status operations.
- Confirm authentication, request/response schema, idempotency and duplicate rules.
- Confirm rollback, audit and approval-before-submit requirements.
- Build and test an API prototype in a non-production environment.
- Do not write production transactions without vendor approval.

## Key Dependencies

- Confirmed Purchasing Workflow -> WFX API -> Controlled GDI Transaction -> Audit and Status

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
[[../PUR.GDI Automation]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/PUR.GDI.Automation.v1.0.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
