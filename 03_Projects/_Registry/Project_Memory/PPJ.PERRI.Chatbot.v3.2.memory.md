---
type: project_memory
project_name: "PPJ.PERRI.Chatbot.v3.2"
project_file: "PPJ.PERRI.Chatbot.md"
project_code: "AI_PERRIPlatform_v3.2.0"
department: "Multi-department"
cluster: "AI Orchestrator / Internal Chatbot"
phase: "GO-LIVE / PRODUCTION / SUPPORT"
technical_members: ["Nam"]
last_verified: "2026-09-18"
confidence: "Strong"
canonical_code: "AI_PERRIPlatform_v3.2.0"
current_file: "PPJ.PERRI.Chatbot.md"
primary_domain: "Internal Chatbot & AI Platforms"
primary_capability: "AI access, agent orchestration, helpdesk, shared platforms"
secondary_domains: "Department Agents, Permission, Logs"
lifecycle: "Production"
progress: "TBD"
current_gate: "Permissioned production orchestration"
workspace_path: "03_Projects/PPJ.PERRI.Chatbot"
project_home: "03_Projects/PPJ.PERRI.Chatbot/00_Project_Home.md"
project_board: "03_Projects/PPJ.PERRI.Chatbot/Project_Executive_Board.canvas"
task_folder: "03_Projects/PPJ.PERRI.Chatbot/Tasks"
documentation_status: "Workspace Created"
priority: "Support"
current_outcome: "Operate PPJ's conversational orchestration platform: User -> PERRI -> Intent -> Agent / Tool -> Data / Knowledge / API -> Controlled Response / Action."
latest_update_summary: "Production. PERRI is an orchestration platform and should not absorb every business-domain project. Read-only agents and action agents remain distinct; action agents require stronger permissions, approval and audit."
known_risks: "Action-agent permissions and audit"
decisions_needed: "None recorded"
next_actions: "Maintain permission and approval controls | Monitor tool execution and audit logs"
dependencies: "None recorded"
source_event: "PPJ-PORTFOLIO-SNAPSHOT-20260918"
status: "Active"
known_blockers: "Action-agent permissions and audit"
recent_update_events: ["PPJ-PORTFOLIO-SNAPSHOT-20260918"]
delivery_stage: "GO-LIVE / PRODUCTION / SUPPORT"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | AI_PERRIPlatform_v3.2.0 |
| Legacy Code(s) | PPJ.PERRI.Chatbot.v3.2; PPJ.PERRI.Chatbot; PERRI Chatbot |
| Primary Domain | Internal Chatbot & AI Platforms |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Production |
| Status | Active |
| Progress | TBD |
| Current Gate | Permissioned production orchestration |
| Priority | Support |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-09-18 |
| Confidence | Strong |

## Executive Summary

Operate PPJ's conversational orchestration platform: User -> PERRI -> Intent -> Agent / Tool -> Data / Knowledge / API -> Controlled Response / Action.

## Current Capability

Operate PPJ's conversational orchestration platform: User -> PERRI -> Intent -> Agent / Tool -> Data / Knowledge / API -> Controlled Response / Action.

## Latest Update

Production. PERRI is an orchestration platform and should not absorb every business-domain project. Read-only agents and action agents remain distinct; action agents require stronger permissions, approval and audit.

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
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[PPJ.PERRI.Chatbot/00_Project_Home|Project Home]]
- [[PPJ.PERRI.Chatbot/Project_Executive_Board|Project Executive Board]]
- [[PPJ.PERRI.Chatbot/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-09-18
- Source Event: PPJ-PORTFOLIO-SNAPSHOT-20260918
- Source: User-approved portfolio current-state snapshot
- Confidence: Strong
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Project Memory: PPJ.PERRI.Chatbot.v3.2

## One-Line Understanding

Internal chatbot/orchestrator connecting users to knowledge base, APIs, tools, agents, and workflows.

## Current Outcome

Production chatbot with department-level agents, permissions, logging, and controlled tool/API calling.

## Latest Update Summary

Agent access can now be granted by department; PERRI is moving toward AI Orchestrator, not simple FAQ.

## What This Project Is

AI Orchestrator layer for PERRI, department agents, knowledge lookup, and controlled automation triggers.

## What This Project Is Not

Not a simple FAQ bot and not unrestricted access to all departments/tools.

## Key Users

Multi-department PPJ users; agent access depends on department permission.

## Systems / Data

Knowledge base, APIs, automation tools, Invoice Downloader, Sourcing Chatbot, Costing Platform, department agents.

## Known Risks / Blockers

Department permission leakage, API action audit, and difference between Q&A agents vs action agents.

## Next Actions

Audit department permissions and logging for API/tool-calling agents.

## Do Not Drift Rules

- Always include permission, logging, fallback, and tool trigger controls.
- Do not describe PERRI as only a general chatbot.

## Source Links

- [[PPJ.PERRI.Chatbot]]
- [[PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY]]

<!-- PPJ_DOMAIN_GOVERNANCE_START -->
## Domain Governance

- Canonical Code: PPJ.PERRI.Chatbot.v3.2
- Current File: [[PPJ.PERRI.Chatbot]]
- Primary Domain: Internal Chatbot & AI Platforms
- Secondary Domains: Department Agents, Permission, Logs
- Lifecycle: Production / Support
- Progress: TBD
- Current Gate: Permission Enhancement

## Domain Do Not Drift Rules
- Do not treat as simple FAQ bot only.
<!-- PPJ_DOMAIN_GOVERNANCE_END -->
