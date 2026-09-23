---
type: project
project_name: "PPJ.AI.Hub"
phase: "DESIGN"
cluster: "AI / Automation Platform"
status: "Design"
priority: "P1"
project_code: "PPJ.AI.Hub.v2.1"
department: "AI Team / Management"
object: "Inferred from filename"
project_characteristic: "platform / hub"
version: "v2.1"
owner: "TBD"
business_owner: "TBD"
technical_owner: "TBD"
members: []
stakeholders: []
systems: []
data_sources: []
progress: "TBD"
blocked: "TBD"
decision_needed: "TBD"
next_action: "TBD"
last_updated: "2026-06-28"
confidence: "Supported by governance notes"
source_files: []
---

# PPJ.AI.Hub

## Executive Summary

PPJ.AI.Hub is the central internal hub for PPJ AI team tools, bots, chatbots, automation apps, and internal workflow utilities.

## Business Context

The AI team currently manages multiple automation tools, chatbots, and workflow applications across sourcing, accounting, purchasing, HR, helpdesk, production support, and management reporting. PPJ.AI.Hub provides a single controlled entry point to organize, access, and govern these tools.

## Problem Statement

Tools and bots are currently scattered across different notes, scripts, dashboards, and project pages. This makes it harder for users to find the right tool, understand ownership, track versioning, and request support.

## Objective

Create a central AI hub where approved tools, bots, chatbots, dashboards, and automation workflows can be listed, accessed, governed, and maintained.

## Scope

- Tool and bot catalog
- Chatbot catalog
- Automation app catalog
- User access and permission model
- Module onboarding workflow
- Support and escalation information
- Version and ownership tracking
- Usage visibility and feedback collection
- Future integration with internal portal or web app

## Out of Scope

- Replacing the individual project notes
- Merging all automation projects into one project
- Removing project-specific ownership
- Replacing ERP or WFX
- Replacing department-specific workflows

## Current Platform Concept

PPJ.AI.Hub acts as the front door for internal AI/automation tools. Each module links back to its canonical project note.

## Connected Modules

- [[SCP.SOURCING.CHATBOT.v2.3]]
- [[PPJ.PERRI.Chatbot]]
- [[PPJ.GLPI-Helpdesk-AI Chatbot]]
- [[PPJ.Invoice Downloader.v1.2]]
- [[PPJ. Expense-Invoices.v1.1]]
-[[ACC.GRN-SupplierInvoiceBot.v2.3]]]
- [[PUR.GDI Automation]]
-[[99_Attachments/Audit/Project_Knowledge_Repair_Backup/20260628_110353/03_Projects/PUR.Material.Allocation.v1.1]]]
- [[TD.TechnicalPlatform_v2.1]]

## Module Registry

| Module | Department | Owner | Phase | Access Point | Status |
|---|---|---|---|---|---|
| [[SCP.SOURCING.CHATBOT.v2.3]] | Sourcing | TBD | TBD | TBD | TBD |
| [[PPJ.PERRI.Chatbot]] | TBD | TBD | TBD | TBD | TBD |
| [[PPJ.GLPI-Helpdesk-AI Chatbot]] | IT / Helpdesk | TBD | TBD | TBD | TBD |
| [[PPJ.Invoice Downloader.v1.2]] | Accounting / EXIM | TBD | TBD | TBD | TBD |
| [[PPJ. Expense-Invoices.v1.1]] | EXIM / Accounting | TBD | TBD | TBD | TBD |
|[[ACC.GRN-SupplierInvoiceBot.v2.3]]] | Accounting | TBD | TBD | TBD | TBD |
| [[PUR.GDI Automation]] | Purchasing | TBD | TBD | TBD | TBD |
|[[99_Attachments/Audit/Project_Knowledge_Repair_Backup/20260628_110353/03_Projects/PUR.Material.Allocation.v1.1]]] | Purchasing / Sourcing | TBD | TBD | TBD | TBD |
| [[TD.TechnicalPlatform_v2.1]] | Technical Platform | TBD | TBD | TBD | TBD |

## Data and Source of Truth

TBD

## System / Automation Scope

TBD

## User Flow

1. User opens PPJ.AI.Hub.
2. User selects department or tool category.
3. User opens the relevant tool, bot, chatbot, dashboard, or workflow.
4. User submits request or uses the tool.
5. Usage, feedback, and support issues are tracked.
6. Module owner maintains the project note and roadmap.

## Governance Rules

- Every module must have a canonical project note.
- Every module must have an owner.
- Every module must have status, phase, access point, and support contact.
- PPJ.AI.Hub is the access and governance layer, not the only source of project details.
- Project-specific details remain in each canonical project note.

## Risks and Blockers

- Unclear ownership
- Fragmented access control
- Inconsistent module onboarding
- Missing usage data
- Lack of support workflow

## Decisions Needed

- Confirm hub owner
- Confirm module onboarding standard
- Confirm access control model
- Confirm first release modules
- Confirm whether the hub will be Obsidian-only, web portal, or integrated with another internal platform

## Next Actions

- Define module registry fields
- Confirm initial modules
- Confirm owner and support process
- Create AI Hub user journey
- Create first release roadmap

## Source Notes Preserved

TBD

## Related Concepts

[[Project Governance]]
[[Internal Tools Portal]]
[[AI Automation]]
[[Chatbot Governance]]
[[Traceability]]

## Methods

[[Impact Analysis]]
[[Requirement Elicitation]]
[[Data Mapping]]
[[User Journey Mapping]]

## Projects

[[SCP.SOURCING.CHATBOT.v2.3]]
[[PPJ.PERRI.Chatbot]]
[[PPJ.GLPI-Helpdesk-AI Chatbot]]
[[PPJ.Invoice Downloader.v1.2]]
[[PPJ. Expense-Invoices.v1.1]]
[[ACC.GRN-SupplierInvoiceBot.v2.3]]]
[[PUR.GDI Automation]][[99_Attachments/Audit/Project_Knowledge_Repair_Backup/20260628_110353/03_Projects/PUR.Material.Allocation.v1.1]]]
[[TD.TechnicalPlatform_v2.1]]

## Deliverables

[[Decision_Driven_BRD]]
[[User_Manual_Template]]
[[System_Design_Template]]
### Source: [[PPJ.AI.Hub.v2.1]]

Preserved On:
2026-06-27 23:39

```markdown
---
type: project
project_name: "Web Tong Hop Tool"
phase: "PRODUCTION / SUPPORT"
cluster: "Reporting"
---

# Web Tong Hop Tool

Phase:
[[PRODUCTION / SUPPORT]]

Cluster:
[[Reporting]]

Canvas:
- [[PPJ_Executive_Board]]
- [[PPJ_Portfolio]]
- [[PPJ_Data_Flow]]
- [[PPJ_Roadmap_2026]]

Current Summary:
- Consolidated web reporting/support tool.

Latest Update:
- Lifecycle Update 2026-W26

Risks / Blockers:
- TBD

Next Actions:
- TBD

Related Concepts
[[Outcome Driven Thinking]]
[[System Thinking]]
[[Decision Making]]
[[Stakeholder Management]]

Methods
[[Impact Analysis]]
[[Decision Matrix]]
[[Requirement Elicitation]]

Deliverables
[[Decision_Driven_BRD]]
[[ERD_Template]]
[[User_Manual_Template]]

---

## Project Resource Governance

BA / Coordination:
Khoa

Technical Members:
Huy

Business Stakeholder / Department:
Management, Reporting

Portfolio Group:
Data / Dashboard / Portal

Priority:
P1

Phase:
PRODUCTION

Progress:
SUPPORT / TBD

Blocker:
TBD

Decision Needed:
TBD

Next Action:
Next Actions:

Workload Risk:
Medium - production support

Source:
[[PPJ_PROJECT_RESOURCE_MATRIX]]
```

<!-- PPJ_PROJECT_DETAIL_MANAGED_START -->

# Project Detail

## Executive Summary
Central AI tools, bots, chatbots, automation apps, and internal hub. Links to modules but does not merge projects.

This note is populated as a canonical PPJ project record for PPJ.AI.Hub.v2.1. It serves AI Team / Management and should be maintained as the source of truth for this project, unless a linked module note is explicitly marked canonical.

## Business Context
Department / process area: AI Team / Management

Project category: AI / Automation Platform

Business impact: Central AI tools, bots, chatbots, automation apps, and internal hub. Links to modules but does not merge projects.

Canvas evidence: PPJ_Executive_Board.canvas

## Problem Statement
The current business or operational problem is partially documented. Known context: Central AI tools, bots, chatbots, automation apps, and internal hub. Links to modules but does not merge projects.

Where evidence is incomplete, details are marked as TBD or Needs Confirmation.

## Objectives

- Clarify scope, ownership, data, workflow, and support model.
- Confirm source of truth, users, and system dependencies.
- Define measurable outcome and next actions for execution tracking.

## Scope

### In Scope

- Project governance and scope clarification.
- Business workflow and data/source-of-truth documentation.
- Ownership, phase, risk, decision, and next-action tracking.

### Out of Scope

- Renaming project files.
- Merging this project into another project unless explicitly approved.
- Canvas layout changes.
- Replacing department-specific workflow ownership.

## Stakeholders

| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Business Owner | TBD | Own business process and acceptance | Needs Confirmation |
| Technical Owner | TBD | Own implementation, support, or integration | Needs Confirmation |
| Users | AI Team / Management | Use or validate the workflow/tool/output | Needs Confirmation |

## Current Process
TBD. Current process should be confirmed with the business owner and existing users.

## Target Process
Target process should support the project objective described above. The future state should clarify user trigger, system action, exception handling, ownership, monitoring, and support process.

## Data and Source of Truth

| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| TBD | TBD | TBD | TBD | Needs Confirmation |

## System / Automation Design
Project characteristic: platform / hub

Design concept: Central AI tools, bots, chatbots, automation apps, and internal hub. Links to modules but does not merge projects.

System dependencies and integration points remain TBD unless confirmed in registry or project notes.

## Business Rules

- TBD

## User Flow

1. User opens or triggers the tool/process.
2. User submits or searches information.
3. System processes request.
4. User receives output.
5. Exceptions are handled or escalated.

## KPI / Success Metrics

| KPI | Target | Current | Notes |
|---|---|---|---|
| Time saved | TBD | TBD | TBD |
| Error reduction | TBD | TBD | TBD |
| Adoption | TBD | TBD | TBD |

## Risks and Blockers

- Ownership and process details may be incomplete.
- Data source and source-of-truth confirmation may be required.
- System dependency and support ownership may need clarification.

## Decisions Needed

- Confirm business owner.
- Confirm technical owner.
- Confirm source of truth and data fields.
- Confirm next release scope and acceptance criteria.

## Next Actions

- Review this populated project detail block.
- Confirm missing owners, phase, data, and workflow details.
- Update deliverables and tasks after confirmation.

## Evidence and Confidence

| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Phase | DESIGN | Existing note / registry | Supported by governance notes |
| Owner | TBD | Registry/resource matrix if available | Needs Confirmation |
| Scope | Central AI tools, bots, chatbots, automation apps, and internal hub. Links to modules but does not merge projects. | Seed context and vault evidence | Supported by governance notes |
| Cluster | AI / Automation Platform | Existing note / registry / seed | Supported by governance notes |

Evidence sources found:

- 03_Projects\_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: |[[PPJ.AI.Hub.v2.1]]] | Web Tổng Hợp Tool | PRODUCTION / SUPPORT / TBD | Khoa | Huy | Management, Reporting | Data / Dashboard / Portal | Medium - production support | P1 | TBD | TBD | Next Actions: | Web Tong Hop Tool.md | 70 |
- 09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: -[[PPJ.AI.Hub.v2.1]]] - Data / Dashboard / Portal - P1
- 09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md: -[[PPJ.AI.Hub.v2.1]]] - P1 - Management, Reporting

## Related Concepts

[[Project Governance]]
[[Traceability]]
[[AI Automation]]
[[Business Process Design]]

## Methods

[[Requirement Elicitation]]
[[Impact Analysis]]
[[Data Mapping]]
[[User Journey Mapping]]
[[Acceptance Criteria]]

## Projects

[[SCP.SOURCING.CHATBOT.v2.3]]
[[PPJ.PERRI.Chatbot]]
[[PPJ.GLPI-Helpdesk-AI Chatbot]]
[[PPJ.Invoice Downloader.v1.2]]
[[PPJ. Expense-Invoices.v1.1]]
[[ACC.GRN-SupplierInvoiceBot.v1.1]]
[[PUR.GDI Automation]][[99_Attachments/Audit/Project_Knowledge_Repair_Backup/20260628_110353/03_Projects/PUR.Material.Allocation.v1.1]]]
[[TD.TechnicalPlatform_v2.1]]

## Deliverables

[[Decision_Driven_BRD]]
[[User_Manual_Template]]
[[System_Design_Template]]

<!-- PPJ_PROJECT_DETAIL_MANAGED_END -->

