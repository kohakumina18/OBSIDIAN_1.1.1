---
type: "project_home"
project: "SCP_SourcingChatbot_v2.3.0"
source_project: "SCP.SOURCING.CHATBOT.v2.3.md"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
last_verified: "2026-09-18"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "Production"
current_gate: "Production monitoring, data quality and retrieval quality"
priority: "P9"
delivery_stage: "GO-LIVE / PRODUCTION / SUPPORT"
status: "Active"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | SCP_SourcingChatbot_v2.3.0 |
| Legacy Code(s) | SCP.SOURCING.CHATBOT.v2.3 |
| Primary Domain | Sourcing / Purchasing |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Production |
| Status | Active |
| Progress | TBD |
| Current Gate | Production monitoring, data quality and retrieval quality |
| Priority | P9 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

One production application for supplier/material intelligence: Supplier Data + Material Data + Search + Comparison + RAG + Chatbot.

## Current Capability

Supplier / Material / Sample Intelligence; consolidated search platform and chatbot.

## Latest Update

Stays one application; do not split into sourcing database / search / RAG / chatbot unless business lifecycles genuinely diverge. Focus: production monitoring, data quality, retrieval quality, supplier/material coverage and answer traceability.

## Risks / Blockers

- Manual external-data input
- Non-standard naming and metadata
- Data-quality drift

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Clean missing fields, mixed types, duplicates and naming
- Stress-test retrieval with real Sourcing questions
- Monitor adoption and production quality

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[SCP.SOURCING.CHATBOT.v2.3/00_Project_Home|Project Home]]
- [[SCP.SOURCING.CHATBOT.v2.3/Project_Executive_Board|Project Executive Board]]
- [[SCP.SOURCING.CHATBOT.v2.3/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# SCP.SOURCING.CHATBOT.v2.3

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | SCP.SOURCING.CHATBOT.v2.3 |
| Current File | SCP.SOURCING.CHATBOT.v2.3.md |
| Primary Domain | Sourcing / Purchasing |
| Secondary Domains | Data Governance, AI Chatbot, Supplier Data |
| Lifecycle | Closeout Preparation |
| Progress | TBD |
| Current Gate | Output Finalization / UAT Acceptance / Handover Preparation |
| Priority | TBD |
| Business Owner | Needs Confirmation |
| Primary Users | Sourcing; data/permission/support owners Need Confirmation |
| BA / Coordination | Khoa |
| Technical Members | Huy, Khoa, Linh, Nghia, Huy, Linh, Nghĩa |
| Last Verified | 2026-08-01 |
| Confidence | Strong |

## One-Line Understanding

Consolidated Sourcing data platform and chatbot for supplier, material, fabric, trims, and sample lookup.

## Business Goal

Consolidated Sourcing data platform and chatbot for supplier, material, fabric, trims and sample lookup.

## Current Outcome

Consolidated Sourcing data platform and chatbot for supplier, material, fabric, trims and sample lookup.

## Latest Update

The team is finalizing the official output format for the current release. Expected next movement is UAT acceptance, handover and closure of active-development scope. External Sourcing data standardization remains a backlog workstream under the same consolidated project.

## Current Scope

- One consolidated project covering sourcing data repository, external samples, and chatbot lookup.

## Current Risks / Blockers

- UAT acceptance, data owner, permission owner and support owner are not confirmed.
- External data remains manually entered and inconsistent.
- Closing chatbot development could be confused with completing the data foundation.
- Future MER usage requires stress, permission, search-quality and data-normalization tests.

## Decisions Needed

- Approve active-development closeout separately from external-data backlog.
- Confirm data, permission and support ownership.

## Next Actions

- Finalize output format and confirm UAT acceptance.
- Complete User Manual and support handover.
- Separate defects from enhancements and transfer remaining issues to maintenance backlog.
- Create/update the Sourcing External Data Standardization Backlog section within this project.

## Key Dependencies

- External Manual Input -> Validation -> Standardization -> Sourcing Data Platform -> Chatbot Search Quality

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
[[../SCP.SOURCING.CHATBOT.v2.3]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/SCP.SOURCING.CHATBOT.v2.3.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
