---
type: "project_home"
project: "PPJ.PERRI.Chatbot.v3.2"
source_project: "PPJ.PERRI.Chatbot.md"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260824"
last_verified: "2026-08-24"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
lifecycle: "Production"
current_gate: "Permissioned production orchestration"
priority: "Support"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | PPJ.PERRI.Chatbot.v3.2 |
| Primary Domain | Internal Chatbot & AI Platforms |
| Lifecycle | Production |
| Progress | TBD |
| Current Gate | Permissioned production orchestration |
| Priority | Support |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-08-24 |
| Confidence | Strong |

## Executive Summary

Operate PPJ's conversational orchestrator for department agents, knowledge retrieval and controlled tool/API execution.

## Current Capability

Operate PPJ's conversational orchestrator for department agents, knowledge retrieval and controlled tool/API execution.

## Latest Update

Read-only agents and action agents remain distinct; action agents require stronger permissions, approval and audit.

## Risks / Blockers

- Action-agent permissions and audit

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Maintain permission and approval controls
- Monitor tool execution and audit logs

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260824`.

## Workspace Links

- [[PPJ.PERRI.Chatbot/00_Project_Home|Project Home]]
- [[PPJ.PERRI.Chatbot/Project_Executive_Board|Project Executive Board]]
- [[PPJ.PERRI.Chatbot/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-08-24
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260824
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# PPJ.PERRI.Chatbot.v3.2

## Executive Snapshot

| Field | Value |
| --- | --- |
| Canonical Code | PPJ.PERRI.Chatbot.v3.2 |
| Current File | PPJ.PERRI.Chatbot.md |
| Primary Domain | Internal Chatbot & AI Platforms |
| Secondary Domains | Department Agents, Permission, Logs |
| Lifecycle | Production / Support |
| Progress | TBD |
| Current Gate | Permission Enhancement |
| Priority | TBD |
| Business Owner | Needs Confirmation |
| Primary Users | PPJ departments / Khoa / Nam |
| BA / Coordination | Needs Confirmation |
| Technical Members | Nam |
| Last Verified | 2026-07-13 |
| Confidence | Strong |

## One-Line Understanding

Internal chatbot/orchestrator connecting users to knowledge base, APIs, tools, agents, and workflows.

## Business Goal

Production chatbot with department-level agents, permissions, logging, and controlled tool/API calling.

## Current Outcome

Production chatbot with department-level agents, permissions, logging, and controlled tool/API calling.

## Latest Update

Agent access can now be granted by department; PERRI is moving toward AI Orchestrator, not simple FAQ.

## Current Scope

- AI Orchestrator layer for PERRI, department agents, knowledge lookup, and controlled automation triggers.

## Current Risks / Blockers

- Department permission leakage, API action audit, and difference between Q&A agents vs action agents.

## Decisions Needed

- Confirm access control model.
- Confirm tool trigger scope.
- Confirm audit log requirements.
- Confirm owner and support path.
- Confirm first departments and first release modules.

## Next Actions

- Map PERRI access roles by department.
- Define approved tool catalog with PPJ.AI.Hub.v2.1.
- Confirm Invoice Downloader integration scope.
- Draft fallback and escalation rules.
- Define audit log schema.

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
[[../PPJ.PERRI.Chatbot]]

Project Memory:
[[03_Projects/_Registry/Project_Memory/PPJ.PERRI.Chatbot.v3.2.memory]]

Registry:
[[../_Registry/PPJ_PROJECT_REGISTRY]]

Memory Index:
[[../_Registry/PPJ_PROJECT_MEMORY_INDEX]]

Command Center:
[[../PROJECT_COMMAND_CENTER]]
