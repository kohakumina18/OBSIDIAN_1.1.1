---
type: "project"
project_name: "PPJ.GLPI-Helpdesk-AI Chatbot"
project_code: "PPJ.GLPI-Helpdesk-AI Chatbot"
department: "IT / Helpdesk"
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
This project is an AI chatbot for GLPI / IT Helpdesk support. It helps users search IT/helpdesk knowledge, answer common questions, route support requests, and potentially create or classify tickets if that capability is confirmed and approved.

## Business Context
IT Helpdesk support often receives repeated questions, unclear ticket categories, and requests that need routing. A GLPI AI chatbot can improve self-service and triage while keeping escalation to IT for unresolved or sensitive issues.

## Problem Statement
Users may not know where to find IT support answers or how to classify requests. Helpdesk teams may spend time on repeated questions. If the chatbot uses stale knowledge or wrong permissions, it may give incorrect answers or route tickets incorrectly.

## Objectives

- Define GLPI chatbot support scope.
- Map FAQ and ticket categories.
- Confirm GLPI knowledge source and update process.
- Define escalation and ticket routing rules.
- Confirm permission and support owner.

## Scope

### In Scope

- GLPI knowledge search
- Helpdesk FAQ answers
- Ticket category suggestion
- Escalation to IT
- Possible ticket routing or creation if confirmed
- Permission and support ownership
- Conversation and handoff logging

### Out of Scope

- Replacing IT Helpdesk human support
- Changing GLPI workflow without approval
- Creating tickets without confirmed permission rules
- Answering outside approved knowledge scope

## Stakeholders

| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Business Owner | IT / Helpdesk | Own GLPI support process and knowledge quality | Needs Confirmation |
| Technical Owner | TBD | Own chatbot integration, knowledge sync, and support workflow | Needs Confirmation |
| Users | PPJ employees / requesters | Ask IT/helpdesk questions or request support | Needs Confirmation |
| Escalation Team | IT Helpdesk | Resolve tickets and maintain FAQ categories | Needs Confirmation |

## Current Process
Current GLPI chatbot implementation details need confirmation. The known business intent is IT/helpdesk support through AI-assisted search, FAQ, ticket routing, and escalation.

## Target Process
1. User asks an IT/helpdesk question.
2. Chatbot searches approved GLPI/helpdesk knowledge.
3. Chatbot returns an answer or asks clarifying questions.
4. If unresolved, chatbot recommends a ticket category or escalates to IT.
5. IT receives sufficient context to resolve or route the issue.

## Data and Source of Truth
| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| Helpdesk knowledge | GLPI / IT knowledge base | IT Helpdesk | Stale answers | Needs Confirmation |
| FAQ categories | GLPI categories / IT taxonomy | IT Helpdesk | Inconsistent categories | Needs Confirmation |
| User question | Chatbot UI | User / IT | Ambiguous request | Needs Confirmation |
| Ticket metadata | GLPI ticket system | IT Helpdesk | Wrong routing | Needs Confirmation |
| Escalation log | GLPI / chatbot log | IT Helpdesk | Missing traceability | Needs Confirmation |

## System / Automation Design
The system should connect a chatbot interface to approved GLPI/helpdesk knowledge sources, FAQ/ticket categories, escalation rules, and optional ticket routing or creation. Permission and support ownership must be confirmed before enabling write actions.

## Business Rules

- Chatbot answers must cite or rely on approved helpdesk knowledge.
- Uncertain answers must escalate to IT.
- Ticket creation or routing requires confirmed permission and owner approval.
- Knowledge must have an update owner.
- Logs should support troubleshooting and improvement.

## KPI / Success Metrics
| KPI | Target | Current | Notes |
|---|---|---|---|
| Self-service answer rate | TBD | TBD | Reduce repeated IT questions |
| Ticket routing accuracy | TBD | TBD | Needs GLPI category mapping |
| Escalation quality | TBD | TBD | Human handoff KPI |
| Stale answer rate | TBD | TBD | Knowledge governance KPI |

## Risks and Blockers

- Wrong answer to IT support question
- Stale GLPI knowledge
- Incorrect ticket category
- Permission issue if ticket actions are enabled
- Unclear support owner
- Users treating chatbot as final authority

## Decisions Needed

- Confirm GLPI knowledge source.
- Confirm FAQ and ticket categories.
- Confirm whether chatbot can create or classify tickets.
- Confirm IT owner and escalation SLA.
- Confirm permission and audit log requirements.

## Next Actions

- Inventory current GLPI FAQ/ticket categories.
- Confirm top repeated IT questions.
- Define escalation and fallback rules.
- Confirm ticket creation scope.
- Prepare UAT with IT/helpdesk users.

## Evidence and Confidence
| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Phase | Production / Supporting | User correction | Strong for phase label; details need confirmation |
| Business meaning | AI chatbot for GLPI / IT Helpdesk support | User correction | Strong |
| Knowledge source | GLPI / IT Helpdesk knowledge | User correction | Strong for concept; source details need confirmation |

Evidence sources:
03_Projects\Canvas\PPJ_Executive_Board.canvas: Canvas reference
03_Projects\Canvas\PPJ_Portfolio.canvas: Canvas reference
User correction 2026-06-28: GLPI / IT Helpdesk AI chatbot

## Related Concepts
[[Project Governance]]
[[AI Automation]]
[[Chatbot Governance]]
[[Knowledge Management]]
[[Traceability]]

## Methods
[[Requirement Elicitation]]
[[Impact Analysis]]
[[Data Mapping]]
[[User Journey Mapping]]
[[Acceptance Criteria]]

## Projects
[[PPJ.AI.Hub.v2.1]]
[[TD.TechnicalPlatform_v2.1]]

## Deliverables
[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[ERD_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]

<!-- generated content end -->


