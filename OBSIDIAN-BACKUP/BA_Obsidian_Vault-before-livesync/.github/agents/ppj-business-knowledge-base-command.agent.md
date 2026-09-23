Read AGENTS.md and README_PPJ_OBSIDIAN_SYSTEM.md first.

Current issue:
AGENTS.md is becoming too large. Every new Codex session reads too much context, causing high token usage. We need to compact the agent instructions while preserving project understanding and preventing future drift.

Goal:
Refactor the vault agent system into a compact, token-efficient, source-of-truth architecture.

Do not delete any information.
Do not lose project understanding.
Do not rename project files.
Do not move project files.
Do not archive project files.
Do not update Canvas yet.
Do not modify project notes unless explicitly requested.
Default mode must be DryRun.

Target architecture:

1. AGENTS.md
   Compact core operating rules only.
   It should tell the agent how to work, what to read, what not to do, and how to stay grounded.
   It should NOT contain long project-specific descriptions for every project.

2. Project Memory Cards
   One compact memory file per canonical project.
   These files preserve the project understanding for new chat/session usage.

3. Project Memory Index
   A fast-loading index that summarizes all project memories in a compact table.

4. Project Registration Protocol
   A protocol and script so new projects can be registered consistently when the agent is called.

5. Drift Control
   The agent must always read the memory/index/registry before making claims about a project.

Create folders if missing:

03_Projects/\_Registry/Project_Memory/
03_Projects/\_Templates/
10_Reports/
scripts/

Create script:

scripts\Compact-PPJAgentAndProjectMemory.ps1

Parameters:

-DryRun
-Apply
-Force
-UpdateAgents
-CreateProjectMemory
-CreateRegistrationProtocol
-ProjectName

Default:
-DryRun only.

Backup behavior on Apply:

Backup affected files to:

99_Attachments/Audit/Agent_Compaction_Backup/YYYYMMDD_HHMMSS/

Files to backup if modified:

- AGENTS.md
- 03_Projects/\_Registry/PPJ_PROJECT_MEMORY_INDEX.md
- 03_Projects/\_Registry/PPJ_PROJECT_REGISTRATION_PROTOCOL.md
- 03_Projects/\_Templates/PPJ_PROJECT_MEMORY_CARD_TEMPLATE.md
- any created or updated project memory cards

Important current canonical project files:

- MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md
- ACC.GRN-SupplierInvoiceBot.v1.1.md
- AI Automation Workshop.md
- E-commerce Market Intelligence.md
- FD.Datamart.v2.2.md
- CPD.Datamart.v1.1.md if it exists or is approved to create
- HR.SS&PFD.v1.1.md
- MER.PO-Commit.md
- PPJ XPrimo1D RFID Thread.md
- PPJ. Expense-Invoices.v1.1.md
- PPJ.AI.Hub.v2.1.md
- PPJ.COSTING.AGENT.PLATFORM.v1.1.md
- PPJ.GLPI-Helpdesk-AI Chatbot.md
- PPJ.Invoice Downloader.v1.2.md
- PPJ.PERRI.Chatbot.md
- PPJxNUNOX.md
- PPJxQSee.ai.md
- PPJxStratova AI.md
- PROD.COWASH.md
- PROD.IOT.CHuyenTreo_1.md
- PROJECT_COMMAND_CENTER.md
- PUR.Adhoc Indent mien Nam.md
- PUR.GDI Automation.md
- PUR.H&M Label-O Processing.md
- PUR.Inventory Report.md
- PUR.Material.Allocation.v1.1.md
- SCP.SOURCING.CHATBOT.v2.3.md
- TD.TechnicalPlatform_v2.1.md
- VITAS Sharing.md
- WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md
- Workshop Analysis.md

Important correction:
FD.Datamart.v2.2 and CPD.Datamart.v1.1 are separate projects.

FD.Datamart.v2.2:

- FD / fabric datamart
- Directus backend/admin/data platform
- QR design or QR information module
- QR attached to hanger
- hanger/fabric/sample data visibility

CPD.Datamart.v1.1:

- CPD / 3D Design datamart
- image search
- 3D sample library
- visual sample assets
- Chi Trang / 3D Design workflow if confirmed

Do not merge FD and CPD.
Do not say FD is CPD.
Do not say CPD is FD.

Managed block marker standard:
The only valid managed project knowledge markers are:

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

<!-- PPJ_PROJECT_KNOWLEDGE_END -->

AGENTS.md compacting rules:

1. Create a compact AGENTS.md of around 250 to 450 lines maximum.
2. Keep only:
   - vault role
   - source-of-truth model
   - safety rules
   - read order
   - project registration rules
   - marker rules
   - naming rules
   - FD/CPD separation rule
   - workflow protocols
   - dryrun/apply rules
   - Obsidian/PowerShell rules
   - Canvas rule
   - project memory loading rule

3. Remove long project descriptions from AGENTS.md.
4. Move project-specific understanding into Project Memory Cards.
5. Add this rule to AGENTS.md:

Before answering about a project:

- Read AGENTS.md
- Read 03_Projects/\_Registry/PPJ_PROJECT_MEMORY_INDEX.md
- Read the relevant project memory card
- Read the relevant project note only if more detail is needed
- Use registry and project note as source of truth
- If conflict exists, report conflict and do not invent

6. Add this rule to AGENTS.md:

When the user mentions a new project not found in memory/index/registry:

- Do not silently create random notes.
- Start New Project Registration Protocol.
- Ask for or infer minimum metadata.
- Create project note, memory card, registry entry, and optional Canvas card only after DryRun/approval.

Create compact AGENTS.md content with these sections:

# PPJ Knowledge Base Agent

## Mission

## Fast Read Order

## Source of Truth

## Safety Rules

## Current Canonical Project Rule

## Project Memory Rule

## New Project Registration Rule

## Managed Block Marker Rule

## FD / CPD Datamart Separation

## Canvas Rule

## PowerShell and Encoding Rule

## DryRun / Apply Rule

## Business Analysis Rule

## Textile Manufacturing Context

## Response Pattern

Project Memory Card template:

Create:

03_Projects/\_Templates/PPJ_PROJECT_MEMORY_CARD_TEMPLATE.md

Template content:

---

type: project_memory
project_name: ""
project_file: ""
project_code: ""
department: ""
cluster: ""
phase: ""
status: ""
priority: ""
business_owner: ""
ba_coordination: []
technical_members: []
stakeholders: []
systems: []
data_sources: []
last_verified: "YYYY-MM-DD"
confidence: "Needs Confirmation"

---

# Project Memory: PROJECT_NAME

## One-Line Understanding

TBD

## Business Meaning

TBD

## Outcome

TBD

## What This Project Is

TBD

## What This Project Is Not

TBD

## Key Users

TBD

## Systems / Data

TBD

## Current Phase / Status

TBD

## Known Risks

TBD

## Decisions Needed

TBD

## Next Actions

TBD

## Do Not Drift Rules

- TBD

## Source Links

- [[PROJECT_FILE_BASENAME]]

Project Memory Card creation:

For every canonical project, create:

03_Projects/\_Registry/Project_Memory/PROJECT_FILE_BASENAME.memory.md

Use filename-safe basename.
Example:

- 03_Projects/\_Registry/Project_Memory/PPJ.AI.Hub.v2.1.memory.md
- 03_Projects/\_Registry/Project_Memory/SCP.SOURCING.CHATBOT.v2.3.memory.md
- 03_Projects/\_Registry/Project_Memory/FD.Datamart.v2.2.memory.md
- 03_Projects/\_Registry/Project_Memory/CPD.Datamart.v1.1.memory.md if project exists or creation approved

Each memory card must be compact. Maximum 120 lines per project memory card.

Memory card content rules:

- Use concise project understanding.
- Do not paste full project note.
- Do not include long tables unless needed.
- Use evidence confidence.
- Include "Do Not Drift Rules" for protected concepts.
- Use Obsidian links.

Memory seeds:

FD.Datamart.v2.2:
One-Line Understanding:
FD Datamart uses Directus to manage FD/fabric/hanger data and supports QR design or QR information for hanger usage.
Outcome:
Manage FD/fabric/hanger data in Directus with QR support for hanger operation.
Do Not Drift:
Do not describe FD Datamart as CPD Datamart.
Do not mention image search or 3D sample library as FD scope unless separately confirmed.
Do not rename FD.Datamart.v2.2 without approval.

CPD.Datamart.v1.1:
One-Line Understanding:
CPD Datamart is a separate 3D Design datamart for image search and 3D sample library management.
Outcome:
Build searchable visual sample library and image search for 3D Design.
Do Not Drift:
Do not merge with FD.Datamart.v2.2.
Do not describe it as Directus hanger QR module unless later confirmed.
Keep image search and 3D sample library as core scope.

SCP.SOURCING.CHATBOT.v2.3:
One-Line Understanding:
Sourcing chatbot and sourcing data management platform for supplier, material, fabric, trims, and sample lookup.
Outcome:
Enable sourcing lookup and data governance for suppliers, materials, fabrics, trims, and samples.
Do Not Drift:
Do not split sourcing into separate project notes without approval.

PPJ.AI.Hub.v2.1:
One-Line Understanding:
Central AI tools, bots, chatbots, automation apps, and internal hub for PPJ.
Outcome:
Centralize access and governance for PPJ AI tools and automation modules.
Do Not Drift:
Do not absorb or merge individual project notes into AI Hub.

PPJ.PERRI.Chatbot:
One-Line Understanding:
Internal chatbot and orchestrator layer for document Q&A, data lookup, department agents, and future workflow triggers.
Outcome:
Provide controlled chatbot orchestration for PPJ knowledge and tool workflows.
Do Not Drift:
Do not treat as simple FAQ bot only.
Include permission, logging, fallback, and tool trigger controls.

PPJ.GLPI-Helpdesk-AI Chatbot:
One-Line Understanding:
AI chatbot for GLPI / IT Helpdesk knowledge search, support Q&A, escalation, and possible ticket routing.
Outcome:
Help users resolve IT support questions and route GLPI requests faster.
Do Not Drift:
Do not claim ticket creation is implemented unless confirmed.

PPJ.COSTING.AGENT.PLATFORM.v1.1:
One-Line Understanding:
Agentic costing platform for MER quotation and technical costing decomposition.
Outcome:
Support faster quotation by routing customer requests into costing/technical agents.
Do Not Drift:
Keep it as strategic platform, not a simple calculator.

MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1:
One-Line Understanding:
MER-led Chico's invoice/costing recheck and audit automation.
Outcome:
Standardize and speed up invoice/costing checking for Chico's workflow.
Do Not Drift:
Do not classify as purely Accounting unless evidence proves it.

ACC.GRN-SupplierInvoiceBot.v1.1:
One-Line Understanding:
Accounting bot for GRN and supplier invoice processing.
Outcome:
Reduce manual GRN and supplier invoice workload for Accounting.
Do Not Drift:
Do not invent v2.3 filename.

PPJ.Invoice Downloader.v1.2:
One-Line Understanding:
VNPT/supplier e-invoice downloader and merging tool.
Outcome:
Download and merge e-invoices for Accounting and EXIM workflows.
Do Not Drift:
Do not assume credential handling or auto-posting unless confirmed.

PPJ. Expense-Invoices.v1.1:
One-Line Understanding:
EXIM-first expense invoice entry automation.
Outcome:
Automate EXIM expense invoice entry and prepare reusable foundation for future rollout.
Do Not Drift:
Do not create v2 without approval.

PUR.Material.Allocation.v1.1:
One-Line Understanding:
Purchasing/material allocation workflow with validation, review, and WFX dependency tracking.
Outcome:
Support material allocation decisions and reduce manual processing.
Do Not Drift:
Keep WFX dependency visible.

PUR.GDI Automation:
One-Line Understanding:
Purchasing GDI automation dependent on input standardization and WFX feasibility.
Outcome:
Automate GDI workflow after dependencies are resolved.
Do Not Drift:
Do not mark production if WFX dependency remains.

PUR.Adhoc Indent mien Nam:
One-Line Understanding:
Adhoc indent automation/support for miền Nam purchasing workflow.
Outcome:
Support regional adhoc indent processing.
Do Not Drift:
Keep miền Nam scope unless expansion is confirmed.

PUR.H&M Label-O Processing:
One-Line Understanding:
H&M Label-O processing automation pending blocker and priority confirmation.
Outcome:
Support label processing once requirements and blockers are confirmed.
Do Not Drift:
Do not mark active if still delayed.

PUR.Inventory Report:
One-Line Understanding:
Purchasing inventory report automation.
Outcome:
Improve inventory visibility and reduce repeated reporting work.
Do Not Drift:
Confirm users, data source, and refresh schedule.

MER.PO-Commit:
One-Line Understanding:
MER PO commitment workflow support.
Outcome:
Support PO/customer commitment tracking and follow-up.
Do Not Drift:
Confirm whether closed or production support before claiming.

TD.TechnicalPlatform_v2.1:
One-Line Understanding:
Technical knowledge platform for BOM, pattern, sewing, measurement, videos, and historical costing data.
Outcome:
Create technical knowledge foundation for AI search and costing agents.
Do Not Drift:
Respect technical data sensitivity.

WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1:
One-Line Understanding:
R&D Wash sampling management portal.
Outcome:
Centralize wash sampling workflow into searchable portal.
Do Not Drift:
Do not merge with CPD or FD datamart.

PROD.IOT.CHuyenTreo_1:
One-Line Understanding:
Production IoT Chuyen Treo monitoring/dashboard project.
Outcome:
Improve production line visibility through IoT monitoring.
Do Not Drift:
Confirm metrics and device/data source.

PROD.COWASH:
One-Line Understanding:
Production/wash-related project requiring scope confirmation.
Outcome:
Clarify production/wash tracking or dashboard support.
Do Not Drift:
Do not over-define until rescope is confirmed.

HR.SS&PFD.v1.1:
One-Line Understanding:
HR-related data/process project requiring acronym and scope confirmation.
Outcome:
Prepare structured HR process or reporting support.
Do Not Drift:
Do not expand SS&PFD without evidence.

E-commerce Market Intelligence:
One-Line Understanding:
Market intelligence / e-commerce opportunity exploration.
Outcome:
Provide external product or market insight for decision-making.
Do Not Drift:
Confirm active scope and data source.

PPJxQSee.ai:
One-Line Understanding:
External AI QC/inspection collaboration exploration.
Outcome:
Explore AI QC use case and PoC requirements.
Do Not Drift:
Do not claim implementation unless PoC is confirmed.

PPJxNUNOX:
One-Line Understanding:
External NUNOX hardware/tool feasibility trial.
Outcome:
Evaluate hardware/tool feasibility for sample or sourcing workflow.
Do Not Drift:
Confirm exact hardware scope.

PPJ XPrimo1D RFID Thread:
One-Line Understanding:
External RFID thread technology exploration.
Outcome:
Explore product identification and traceability feasibility.
Do Not Drift:
Keep as exploration unless trial is confirmed.

PPJxStratova AI:
One-Line Understanding:
External AI vendor engagement history, likely closed or low confidence.
Outcome:
Preserve lessons learned and vendor screening history.
Do Not Drift:
Use Weak/Needs Confirmation if no evidence.

VITAS Sharing:
One-Line Understanding:
External sharing or industry engagement activity.
Outcome:
Track preparation, follow-up, and reusable portfolio insight.
Do Not Drift:
Do not treat as internal automation project.

AI Automation Workshop:
One-Line Understanding:
AI automation workshop/event note.
Outcome:
Capture workshop outputs and follow-up actions.
Do Not Drift:
Do not treat as product system.

Workshop Analysis:
One-Line Understanding:
Post-workshop analysis note.
Outcome:
Convert workshop insights into project opportunities and decisions.
Do Not Drift:
Do not treat as product system.

Create project memory index:

03_Projects/\_Registry/PPJ_PROJECT_MEMORY_INDEX.md

Columns:

- Project
- Memory Card
- Project Note
- Cluster
- Phase
- Priority
- One-Line Understanding
- Outcome
- Confidence
- Last Verified

Create project registration protocol:

03_Projects/\_Registry/PPJ_PROJECT_REGISTRATION_PROTOCOL.md

It must define:

When user says:

- "new project"
- "add project"
- "register project"
- "create project"
- "track this project"
- or mentions a project not found in memory/index/registry

Agent must:

1. Check project memory index.
2. Check project registry.
3. Check root project files.
4. If project does not exist, create a registration proposal.
5. Do not create immediately unless Apply approved.

Minimum metadata:

- Project name
- Department / owner group
- Object / domain
- Characteristic / purpose
- Version
- Business problem
- Target users
- Owner
- Technical member
- Phase
- Priority
- Outcome
- Source system/data
- Next action

Generated assets for new project:

- project note under 03_Projects/
- project memory card under 03_Projects/\_Registry/Project_Memory/
- registry entry
- module index entry
- optional task note
- optional Canvas card after approval

Create or update script:

scripts\Register-PPJProject.ps1

Parameters:
-DryRun
-Apply
-ProjectName
-Department
-Object
-Characteristic
-Version
-Cluster
-Phase
-Priority
-Outcome
-BusinessOwner
-BA
-TechnicalMembers
-CreateCanvasCard

Default DryRun.

It should:

- validate name is not duplicate
- generate safe filename
- create project note from template
- create memory card
- update memory index
- update project registry if possible
- do not update Canvas unless -CreateCanvasCard and Apply
- backup before modifying registry/index

Create report:

10_Reports/AGENT_COMPACTION_AND_PROJECT_MEMORY_PLAN_YYYYMMDD.md

Sections:

- Executive Summary
- Why Compaction Is Needed
- New Architecture
- AGENTS.md Changes
- Project Memory Cards
- Project Memory Index
- Registration Protocol
- Scripts Created
- Token Usage Benefit
- Drift Control Rules
- Apply Plan
- Approval Checklist

DryRun output must include:

- Current AGENTS.md line count
- Proposed AGENTS.md line count
- Project memory cards to create
- Project memory index preview
- Registration protocol preview
- Register script plan
- Files that would be modified
- Files that would be created
- No files modified

Apply behavior:
Only after approval:

- backup affected files
- update AGENTS.md
- create memory cards
- create memory index
- create registration protocol
- create/register script
- create report
- do not update Canvas
- do not modify project notes

After creating script:

1. Syntax-check it.
2. Run DryRun only:

powershell -ExecutionPolicy Bypass -File "scripts\Compact-PPJAgentAndProjectMemory.ps1" -DryRun

Do not run Apply.

Final response must include:

- Script created
- Current AGENTS line count
- Proposed AGENTS line count
- Estimated token reduction
- Project memory cards planned
- Project memory index preview
- New project registration workflow
- Files that would be modified
- Files that would be created
- Exact Apply command, approval-required

Do not run Apply.
