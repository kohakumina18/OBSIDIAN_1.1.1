---
type: "brd"
project: "PPJ.PERRI.Chatbot.v3.2"
source_project: "PPJ.PERRI.Chatbot.md"
source_event: "Canonical naming populated"
last_verified: "2026-07-13"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Business Requirements Document

## Executive Summary

Internal chatbot/orchestrator connecting users to knowledge base, APIs, tools, agents, and workflows.

## Business Problem

Needs Confirmation from the current project evidence and responsible business users.

## Objectives

- Production chatbot with department-level agents, permissions, logging, and controlled tool/API calling.

## Users / Stakeholders

- Primary users: PPJ departments / Khoa / Nam
- Business owner: Needs Confirmation
- BA / Coordination: Needs Confirmation

## Current Process

Needs Confirmation. See [[../03_Process/AS_IS_Process]].

## Pain Points

- Department permission leakage, API action audit, and difference between Q&A agents vs action agents.

## Target Process

See [[../03_Process/TO_BE_Process]]. Target flow remains subject to current-gate approval.

## Scope

- AI Orchestrator layer for PERRI, department agents, knowledge lookup, and controlled automation triggers.

## Out of Scope

- Not a simple FAQ bot and not unrestricted access to all departments/tools.

## Business Requirements

- Deliver the verified project outcome without unapproved scope expansion.
- Preserve review, exception, evidence and traceability controls appropriate to the project type.
- Confirm any missing rule with the responsible business owner.

## Business Rules

See [[Scope_and_Business_Rules]]. Unconfirmed rules remain Needs Confirmation.

## Data Requirements Summary

See [[../04_Data/Data_Spec]] and [[../04_Data/Data_Source_Inventory]].

## Integration Summary

See [[../06_Solution/Integration_Spec]]. No direct transactional write is assumed.

## AI / Automation Scope

Applicable only where confirmed in the project memory, project note or approved update.

## Human Validation

Responsible users must validate outputs before business decisions or transactions when automation or AI is involved.

## Exception / Fallback

Unresolved exceptions must be logged, assigned and handled through an approved manual or system fallback.

## KPI / Measurable Outcome

Needs Confirmation.

## Risks

- Department permission leakage, API action audit, and difference between Q&A agents vs action agents.

## Assumptions

- Registry, memory and root project note remain the source of truth.
- Unverified details are not treated as approved requirements.

## Dependencies

- Needs Confirmation

## Decisions Required

- Confirm access control model.
- Confirm tool trigger scope.
- Confirm audit log requirements.
- Confirm owner and support path.
- Confirm first departments and first release modules.

## Acceptance Summary

See [[../05_Requirements/Acceptance_Criteria]]. Formal acceptance owner and evidence remain Needs Confirmation unless explicitly recorded.

## Evidence Basis

- Root project note: [[../PPJ.PERRI.Chatbot]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PPJ.PERRI.Chatbot.v3.2.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-07-13
- Confidence: Strong
