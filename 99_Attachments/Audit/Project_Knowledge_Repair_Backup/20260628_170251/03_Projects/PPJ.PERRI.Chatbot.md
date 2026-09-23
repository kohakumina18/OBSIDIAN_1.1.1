---
type: "project"
project_name: "PPJ.PERRI.Chatbot"
project_code: "PPJ.PERRI.Chatbot"
department: "TBD"
object: "Inferred from filename"
project_characteristic: "chatbot"
version: "TBD"
phase: "TBD"
cluster: "AI Platform / Chatbots / Hub"
owner: "TBD"
business_owner: "TBD"
technical_owner: "TBD"
members: []
stakeholders: []
systems: []
data_sources: []
status: "TBD"
progress: "TBD"
priority: "TBD"
blocked: "TBD"
decision_needed: "TBD"
next_action: "TBD"
last_updated: "2026-06-28"
confidence: "Strong for corrected business concept; implementation details need confirmation"
source_files: []
---

<!-- generated content start -->

# Project Knowledge Detail

## Executive Summary
PERRI is the internal chatbot and orchestrator layer for PPJ. It supports document Q&A, data lookup, department-specific agents, and future workflow triggers. It can become the execution layer where user requests are routed to approved tools such as invoice downloader, document lookup, project knowledge lookup, or other automation modules.

## Business Context
PERRI sits between users, PPJ.AI.Hub.v2.1, document knowledge sources, and approved automation tools. The project should define chatbot access, department-level agent permissions, tool trigger boundaries, fallback behavior, and audit logging before expanding automation actions.

## Problem Statement
Without a clear permission and orchestration model, a chatbot can answer from stale sources, trigger the wrong tool, expose restricted information, or create support issues. PERRI needs governance as an orchestrator, not only a chat interface.

## Objectives

- Define PERRI chatbot/orchestrator scope.
- Design department-level access and permission model.
- Define approved tool trigger scope and fallback behavior.
- Connect PERRI governance to PPJ.AI.Hub.v2.1 module catalog.
- Define audit logging and support process.

## Scope

### In Scope

- Document Q&A
- Data lookup
- Department-specific agent access
- Approved tool routing and orchestration
- Permission model
- Logging and fallback
- Connection to PPJ.AI.Hub.v2.1
- Connection to PPJ.Invoice Downloader.v1.2 if approved

### Out of Scope

- Unapproved autonomous actions
- Bypassing owner approval for sensitive workflows
- Replacing individual project notes
- Creating unrestricted access to all data
- Broker/trading or unrelated automation

## Stakeholders

| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Platform Owner | TBD | Own chatbot/orchestrator roadmap | Needs Confirmation |
| AI / Automation Team | Khoa / PPJ AI team | Requirements, governance, and support coordination | Inferred from portfolio context |
| Technical Owner | TBD | Own orchestration, tool integration, logging, and permission model | Needs Confirmation |
| Department Users | PPJ departments | Ask questions, request lookup, or trigger approved tools | Needs Confirmation |
| Connected Tool Owners | Invoice Downloader / PPJ.AI.Hub modules | Maintain downstream tool behavior | Needs Confirmation |

## Current Process
PERRI is treated as a chatbot/orchestrator concept. Current implementation details, deployment status, permission setup, and connected tools need confirmation.

## Target Process
1. User opens PERRI from an approved access point.
2. User intent is classified by department, permission, and request type.
3. PERRI answers from approved knowledge or routes to an approved tool.
4. Sensitive or unsupported requests are refused or escalated.
5. Every interaction and tool trigger is logged for audit and improvement.

## Data and Source of Truth
| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| User question/request | PERRI chatbot UI | AI Team | Ambiguous intent | Needs Confirmation |
| Document knowledge | Approved document repositories | Document owners | Stale content | Needs Confirmation |
| Tool/action catalog | PPJ.AI.Hub.v2.1 | AI Team | Unapproved trigger scope | Needs Confirmation |
| Permission profile | User/department access model | IT / AI Team | Over-permission risk | Needs Confirmation |
| Audit log | Chatbot/orchestrator log | Technical owner | Missing traceability | Needs Confirmation |

## System / Automation Design
PERRI should be designed as an orchestrator layer with a controlled tool catalog, permission checks, department-specific agents, logging, fallback, and escalation. It should link to PPJ.AI.Hub.v2.1 as the module catalog and governance layer, while individual tools remain separate canonical project notes.

## Business Rules

- Every tool trigger must be permission-checked.
- Department-specific agents must only access approved sources.
- Unsupported requests must fall back to human support or a safe response.
- Audit logs must capture user, intent, source, action, and outcome where allowed.
- PERRI must not absorb project-specific source-of-truth notes.

## KPI / Success Metrics
| KPI | Target | Current | Notes |
|---|---|---|---|
| Answer success rate | TBD | TBD | Needs baseline |
| Escalation accuracy | TBD | TBD | Department routing |
| Tool trigger accuracy | TBD | TBD | Only approved workflows |
| Audit log completeness | TBD | TBD | Governance KPI |

## Risks and Blockers

- Incorrect or stale answer
- Over-permissioned access
- Unapproved workflow trigger
- Missing audit trail
- Unclear technical owner
- User confusion between chatbot answer and official process

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

## Evidence and Confidence
| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Phase | Production / Permission Enhancement | User correction | Strong for phase label; details need confirmation |
| Business meaning | Internal chatbot and orchestrator layer | User correction | Strong |
| Connected hub | PPJ.AI.Hub.v2.1 | User correction | Strong |
| Evidence count rule | Confidence is not Medium when evidence is zero | Repair rule | Strong |

Evidence sources:
03_Projects\Canvas\PPJ_Data_Flow.canvas: Canvas reference
03_Projects\Canvas\PPJ_Executive_Board.canvas: Canvas reference
03_Projects\Canvas\PPJ_Portfolio.canvas: Canvas reference
03_Projects\Canvas\PPJ_Roadmap_2026.canvas: Canvas reference
User correction 2026-06-28: PERRI internal chatbot/orchestrator layer

## Related Concepts
[[Project Governance]]
[[AI Automation]]
[[Chatbot Governance]]
[[Permission Model]]
[[Traceability]]

## Methods
[[Requirement Elicitation]]
[[Impact Analysis]]
[[Data Mapping]]
[[User Journey Mapping]]
[[Acceptance Criteria]]

## Projects
[[PPJ.AI.Hub.v2.1]]
[[PPJ.Invoice Downloader.v1.2]]
[[TD.TechnicalPlatform_v2.1]]

## Deliverables
[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[ERD_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]

<!-- generated content end -->


