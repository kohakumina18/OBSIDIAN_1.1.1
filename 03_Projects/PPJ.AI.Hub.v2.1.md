---
type: project
project_name: "PPJ.AI.Hub"
phase: "GO-LIVE / PRODUCTION / SUPPORT"
cluster: "AI / Automation Platform"
status: "Active"
priority: "Support"
project_code: "AI_ApplicationHub_v2.1.0"
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
confidence: "Strong"
source_files: []
canonical_code: "AI_ApplicationHub_v2.1.0"
current_file: "PPJ.AI.Hub.v2.1.md"
primary_domain: "Internal Chatbot & AI Platforms"
lifecycle: "Internal Production Platform"
current_gate: "Platform operations"
last_verified: "2026-09-18"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
delivery_stage: "GO-LIVE / PRODUCTION / SUPPORT"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
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
- [[PUR.Material.Allocation.v1.2]]
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
| [[PUR.Material.Allocation.v1.2]] | Purchasing / Sourcing | TBD | TBD | TBD | TBD |
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
[[PUR.GDI Automation]]
[[PUR.Material.Allocation.v1.2]]
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

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | AI_ApplicationHub_v2.1.0 |
| Legacy Code(s) | PPJ.AI.Hub.v2.1; PPJ.AI.Hub; Web Tong Hop Tool |
| Primary Domain | Internal Chatbot & AI Platforms |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Internal Production Platform |
| Status | Active |
| Progress | TBD |
| Current Gate | Platform operations |
| Priority | Support |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

AI application discovery, access and launch layer for the internal AI ecosystem.

## Current Capability

AI application discovery, access and launch layer for the internal AI ecosystem.

## Latest Update

Platform. PERRI = conversational orchestration; AI Hub = application access layer. AI Hub is not the master project registry and not a container for merged project notes.

## Risks / Blockers

- No current portfolio-level risk recorded.

## Decisions Needed

- No current portfolio decision recorded.

## Dependencies

- No current cross-project dependency recorded.

## Next Actions

- Maintain application catalogue and access
- Keep project registry ownership outside AI Hub

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[PPJ.AI.Hub.v2.1/00_Project_Home|Project Home]]
- [[PPJ.AI.Hub.v2.1/Project_Executive_Board|Project Executive Board]]
- [[PPJ.AI.Hub.v2.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong

<!-- PPJ_PROJECT_KNOWLEDGE_END -->
