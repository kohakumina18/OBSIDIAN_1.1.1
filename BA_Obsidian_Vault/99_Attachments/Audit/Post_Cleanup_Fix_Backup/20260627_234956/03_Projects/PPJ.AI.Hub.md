---
type: project
project_name: "PPJ.AI.Hub"
phase: "DESIGN"
cluster: "AI / Automation Platform"
status: "Design"
priority: "P1"
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
[[ACC.GRN-SupplierInvoiceBot.v2.3]]]]
- [[PUR.GDI Automation]]
-[[PUR.Material.Allocation.v1.2]]]
- [[TD.TechnicalPlatform_v2.1]]

## Module Registry

| Module | Department | Owner | Phase | Access Point | Status |
|---|---|---|---|---|---|
| [[SCP.SOURCING.CHATBOT.v2.3]] | Sourcing | TBD | TBD | TBD | TBD |
| [[PPJ.PERRI.Chatbot]] | TBD | TBD | TBD | TBD | TBD |
| [[PPJ.GLPI-Helpdesk-AI Chatbot]] | IT / Helpdesk | TBD | TBD | TBD | TBD |
| [[PPJ.Invoice Downloader.v1.2]] | Accounting / EXIM | TBD | TBD | TBD | TBD |
| [[PPJ. Expense-Invoices.v1.1]] | EXIM / Accounting | TBD | TBD | TBD | TBD |
[[ACC.GRN-SupplierInvoiceBot.v2.3]]]] | Accounting | TBD | TBD | TBD | TBD |
| [[PUR.GDI Automation]] | Purchasing | TBD | TBD | TBD | TBD |
|[[PUR.Material.Allocation.v1.2]]] | Purchasing / Sourcing | TBD | TBD | TBD | TBD |
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
[[PPJ. Expense-Invoices.v1.1]][[ACC.GRN-SupplierInvoiceBot.v2.3]]]]
[[PUR.GDI Automation]][[PUR.Material.Allocation.v1.2]]]
[[TD.TechnicalPlatform_v2.1]]

## Deliverables

[[Decision_Driven_BRD]]
[[User_Manual_Template]]
[[System_Design_Template]]
### Source: [[PPJ.AI.Hub]]

Preserved On:
2026-06-27 23:39

`markdown
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
`


