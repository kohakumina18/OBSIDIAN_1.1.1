
# ==PPJ Obsidian BA / AI Automation Command System README==

This README explains my current Obsidian system, project portfolio structure, Canvas management logic, PowerShell automation scripts, and how ChatGPT should help me generate future PowerShell commands safely.

This system is used by me as an AI Business Analyst / AI Automation Lead at PPJ Group to manage AI, automation, data, chatbot, dashboard, and workflow improvement initiatives.

---

# 1. My Working Context

I work at PPJ Group in textile / garment manufacturing.

My work sits between:

- Business users
    
- Management
    
- IT / Dev team
    
- Data team
    
- AI / Automation team
    
- ERP / WFX process owners
    
- Accounting, Purchasing, Sourcing, EXIM, R&D Wash, CPD, Factory teams
    

My main deliverables are:

- BRD
    
- Decision-driven BRD
    
- ERD / Data Spec
    
- User Manual / SOP
    
- Meeting notes
    
- Process documentation
    
- Automation flow
    
- Canvas portfolio views
    
- Weekly project report
    
- Project tasks and decision logs
    

The main goal of this Obsidian system is:

```text
Meeting / request / issue
→ structured note
→ linked project
→ canvas task
→ phase tracking
→ weekly report
→ traceability
```

---

# 2. Obsidian Vault Path

The canonical vault is the portable USB vault. On the current Windows host its root is:

```powershell
E:\DATA\USB-VAULT\BA_Obsidian_Vault_FULL_LINUX_20260918\USB_BA_Obsidian_Vault
```

The USB drive letter may change on another Windows computer. Resolve the mounted USB path first, then run all PowerShell scripts from that vault root. Do not hard-code `E:` inside reusable scripts.

When the USB vault is mounted on Ubuntu, the operational vault root is:

```bash
/home/nvakhoa/Documents/BA_Obsidian_Vault
```

The backslashes sometimes shown before underscores are Markdown escaping and are not part of the filesystem path.

The previous local Windows vault is a legacy/reference source only:

```powershell
C:\Users\nvakt\Documents\obsidian\BA_Obsidian_Vault

and another on yoga thinkpad laptop:
D:\PPJ\syncing
```

Do not write project updates, registry changes, tasks, reports, or Canvas state to the legacy local vault unless the user explicitly requests it.

All PowerShell scripts should be run from the vault root unless stated otherwise.

All Ubuntu/Python commands should use `/home/nvakhoa/Documents/BA_Obsidian_Vault` as the vault root.

---

# 3. Core Folder Structure

Current important folders:

```text
00_Inbox/
01_Daily_Notes/
02_BA_Knowledge/
03_Projects/
04_Data_Dictionary/
05_Process_Library/
06_AI_Automation/
07_Decision_Log/
08_Meeting_Notes/
09_Stakeholders/
10_Deliverables/
11_Templates/
99_Attachments/
scripts/
```

Recommended usage:

```text
02_BA_Knowledge
→ reusable concepts and methods

03_Projects
→ project notes, canvas, tasks, kanban

04_Data_Dictionary
→ entities, fields, relationships, mappings

05_Process_Library
→ L1 / L2 / L3 process documentation

06_AI_Automation
→ n8n flows, OCR, chatbot, AI design

07_Decision_Log
→ decisions, rationale, alternatives

08_Meeting_Notes
→ meeting transcript summaries and action items

10_Deliverables
→ BRD, ERD, user manuals, reports

11_Templates
→ reusable templates

99_Attachments
→ backups, audits, raw files, attachments

scripts
→ PowerShell automation scripts
```

---

# 4. Key Obsidian Canvas Files

Canvas files are stored here:

```text
03_Projects/Canvas/
```

Important Canvas files:

```text
PPJ_Portfolio.canvas
PPJ_Executive_Board_v2.canvas
PPJ_Data_Flow.canvas
PPJ_Roadmap_2026.canvas
PPJ_Domain_Encapsulation.canvas
PPJ_EndToEnd_Process_Automation_Coverage.canvas
PPJ_Enterprise_Application_AI_Automation_Ecosystem.canvas
PPJ_Project_Process_Map.canvas
```

Purpose:

```text
PPJ_Portfolio.canvas
→ system-level portfolio overview by cluster

PPJ_Executive_Board_v2.canvas
→ weekly execution board / phase tracking / task command board

PPJ_Data_Flow.canvas
→ WFX / DWH / Data / AI / decision dependency map

PPJ_Roadmap_2026.canvas
→ quarterly roadmap view

PPJ_Domain_Encapsulation.canvas
→ one-card-per-project Primary Domain view

PPJ_EndToEnd_Process_Automation_Coverage.canvas
→ customer-to-finance business flow with application and AI coverage

PPJ_Enterprise_Application_AI_Automation_Ecosystem.canvas
→ five-layer enterprise architecture: business, WFX, third-party, PPJ apps, Data/AI/Automation

PPJ_Project_Process_Map.canvas
→ one process card per registered project: input/trigger, processing steps, human control and final output
```

The most important daily board is:

```text
03_Projects/Canvas/PPJ_Executive_Board_v2.canvas
```

---

# 5. Executive Canvas Delivery-Stage Model

The Executive Canvas is an operational control surface with two persistent delivery streams:

```text
INTERNAL DEVELOPMENT
EXTERNAL DEVELOPMENT
```

Each stream uses the same eight delivery-stage lanes:

Correct phase lanes:

```text
BACKLOG
KICK-OFF
ANALYSIS
DESIGN
DEVELOPMENT
UAT / PRE-GO-LIVE
GO-LIVE / PRODUCTION / SUPPORT
CLOSED
```

Meaning:

```text
BACKLOG
→ approved idea or request, not yet scheduled for kick-off

KICK-OFF
→ owner, users, problem, scope, outcome and working model are being aligned

ANALYSIS
→ business problem, scope, process, data, stakeholders still being clarified

DESIGN
→ solution flow, data fields, UI, permission, logic, and integration are being designed

DEVELOPMENT
→ app, automation, chatbot, dashboard, or workflow logic is being built

UAT / PRE-GO-LIVE
→ business validation, defect closure, training and readiness review are ongoing

GO-LIVE / PRODUCTION / SUPPORT
→ system is live or rolling out and needs monitoring, support and controlled enhancement

CLOSED
→ completed or stopped; history is retained and there are no active delivery tasks
```

`delivery_stream` and `delivery_stage` are separate from detailed `lifecycle`, `status`, `progress`, `current_gate`, `priority`, and Primary Domain. `On Hold`, `Blocked`, `Waiting`, and `Pending Decision` are statuses/overlays, not stages or streams. Production, rollout, maintenance, enhancement, and support all use `GO-LIVE / PRODUCTION / SUPPORT`. Only confirmed closure uses `CLOSED`.

Current preferred Canvas layout:

```text
INTERNAL DEVELOPMENT: BACKLOG | KICK-OFF | ANALYSIS | DESIGN | DEVELOPMENT | UAT/PRE-GO-LIVE | GO-LIVE/PRODUCTION/SUPPORT | CLOSED
EXTERNAL DEVELOPMENT: BACKLOG | KICK-OFF | ANALYSIS | DESIGN | DEVELOPMENT | UAT/PRE-GO-LIVE | GO-LIVE/PRODUCTION/SUPPORT | CLOSED
```

All sixteen stream-stage groups must remain visible. Each registered project appears exactly once, identified by `<!-- PPJ_PROJECT_CARD:CANONICAL_CODE -->`. Moving horizontally changes stage; moving vertically between the two streams changes `delivery_stream`. Side groups are management overlays, not duplicate cards. Candidate initiatives enter neither stream until registration is approved.

After a card is dragged and Canvas is saved, geometry is authoritative only when the card center is inside exactly one configured stream-stage group. The watcher persists both stream and stage automatically. Reopening `CLOSED` requires manual `--approve-reopen` or `--force`.

On the Ubuntu vault, `ppj-executive-canvas-watcher.service` normally performs this guarded synchronization automatically within about 1-2 seconds after Obsidian saves the Canvas. Manual commands remain available for audit/recovery. Do not run a second watcher process while the service is active.

---

# 6. Important Encoding Rule

Do NOT use emoji in PowerShell-generated Canvas group labels.

Reason:

```text
Windows PowerShell 5.1 can create mojibake / corrupted Unicode labels in .canvas files.
```

Good Canvas labels:

```text
BACKLOG
KICK-OFF
ANALYSIS
DESIGN
DEVELOPMENT
UAT / PRE-GO-LIVE
GO-LIVE / PRODUCTION / SUPPORT
CLOSED
```

Avoid in Canvas labels generated by PowerShell:

```text
emoji
smart quotes
special unicode arrows
fancy symbols
```

Before running scripts, use:

```powershell
chcp 65001
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
```

Still, safest rule: use ASCII labels for Canvas.

---

# 7. Current Project Portfolio

Known active / tracked projects include:

```text
ACC.CHICOS.INVOICE.RECHECK-AUDIT.v1.1
RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1
Accounting Expense Invoices
MER Costing Intelligence
E-commerce Market Intelligence
Workshop Analysis
CPD Fabric Database
HR Project
SCP.SOURCING.CHATBOT.v2.3
Chuyen treo ver1
FD QR Hanger
PERRI Chatbot
GLPI Helpdesk AI Chatbot
Invoice Downloader
PO Commit
Accounting Automation
Accounting GRN Supplier Invoice Bot
EXIM Expense Invoice Bot
Adhoc Indent mien Nam
CPD Datamart
Purchasing Inventory Report
Web Tong Hop Tool
Material Allocation
PUR.GDI Automation
QSee.ai
Primo1D RFID Thread
NUNOX
VITAS Sharing
COWASH
H&M Label-O Processing
Stratova AI
AI Automation Workshop
```

Important naming update:

```text
SCP.SOURCING.CHATBOT.v2.3
```

This project includes:

```text
Sourcing chatbot
External sample data repository
Search / lookup over sourcing-related data
Supplier / material / sample data management
```

Important new projects:

```text
ACC.CHICOS.INVOICE.RECHECK-AUDIT.v1.1
→ invoice recheck / audit pilot for CHICO'S
→ foundation for reusable invoice checking across Accounting, Import, Export

RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1
→ port R&D Wash sampling management into PPJ Group Portal
→ make sampling workflow usable by wider PPJ group
```

---

# 8. Current Scripts

Scripts are stored here:

```text
scripts/
```

Existing / recommended scripts:

```text
Add-PPJCanvasTask.ps1
Rebuild-PPJExecutiveBoard-SplitPhases.ps1
Expand-PPJExecutiveBoard-Horizontal.ps1
New-PPJProject.ps1
Move-PPJProjectPhase.ps1
Add-PPJMeetingNote.ps1
Build-PPJWeeklyReport.ps1
Audit-ObsidianLinks.ps1
Backup-ObsidianVault.ps1
```

Purpose:

```text
Add-PPJCanvasTask.ps1
→ create task note, link to project, add task node to Executive Canvas

Rebuild-PPJExecutiveBoard-SplitPhases.ps1
→ rebuild Executive Canvas using separated lifecycle phases

Expand-PPJExecutiveBoard-Horizontal.ps1
→ expand Executive Canvas into horizontal end-to-end lifecycle view

New-PPJProject.ps1
→ create a new project note with frontmatter and standard BA sections

Move-PPJProjectPhase.ps1
→ move project note to new phase and reposition it on Executive Canvas

Add-PPJMeetingNote.ps1
→ create linked meeting note and append update to project note

Build-PPJWeeklyReport.ps1
→ generate weekly project report from project notes

Audit-ObsidianLinks.ps1
→ scan broken Obsidian wiki links

Backup-ObsidianVault.ps1
→ zip backup of vault excluding .obsidian and .git
```

---

# 9. Safe Script Rules for ChatGPT

When generating PowerShell for this system, always follow these rules:

```text
1. Assume the script is run from vault root.
2. Backup .canvas files before modifying them.
3. Use UTF-8 for reading and writing files.
4. Avoid emoji in Canvas labels.
5. Keep scripts idempotent where possible.
6. Do not delete existing notes unless explicitly asked.
7. Do not overwrite project notes without backup or append-only logic.
8. For Canvas edits, preserve existing nodes unless rebuilding is explicitly requested.
9. Use safe filenames by replacing invalid Windows characters.
10. Use Obsidian wiki links [[...]] in generated markdown.
```

Recommended PowerShell read/write style:

```powershell
Get-Content -Raw -Encoding UTF8 $path
Set-Content -Encoding UTF8 $path
Add-Content -Encoding UTF8 $path
```

Canvas backup pattern:

```powershell
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
Copy-Item $canvasPath "$backupRoot\PPJ_Executive_Board.canvas.$stamp.bak"
```

---

# 10. Common Commands

Create new project:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\New-PPJProject.ps1" `
-Project "PROJECT_NAME" `
-Phase "ANALYSIS" `
-Cluster "Automation" `
-Outcome "Business outcome here" `
-Owner "Khoa" `
-Related "Decision_Driven_BRD","Impact Analysis","Data Mapping"
```

Move project phase:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Move-PPJProjectPhase.ps1" `
-Project "PROJECT_NAME" `
-Phase "DESIGN" `
-Reason "Business flow confirmed" `
-NextAction "Design data fields, screen flow, and permission model"
```

Add canvas task:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Add-PPJCanvasTask.ps1" `
-Project "PROJECT_NAME" `
-Title "Task title here" `
-Lane Task `
-Related "Decision_Driven_BRD","Data Mapping","Impact Analysis" `
-Outcome "Expected outcome here" `
-NextAction "Next action here"
```

Add meeting note:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Add-PPJMeetingNote.ps1" `
-Project "PROJECT_NAME" `
-Title "Meeting title here" `
-Stakeholders "Stakeholder names / teams" `
-Decision "Decision made or TBD" `
-NextAction "Next action here"
```

Generate weekly report:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Build-PPJWeeklyReport.ps1"
```

Audit broken links:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Audit-ObsidianLinks.ps1"
```

Backup vault:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Backup-ObsidianVault.ps1"
```

Rebuild Executive Canvas with separated phases:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Rebuild-PPJExecutiveBoard-SplitPhases.ps1"
```

Expand Executive Canvas horizontally:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Expand-PPJExecutiveBoard-Horizontal.ps1"
```

---

# 11. Standard Project Note Structure

Every project note should ideally contain:

```text
YAML frontmatter
Project title
Phase
Cluster
Owner
Canvas links
Business outcome
Current context
Problem / pain point
Scope
Process
Data
AI / Automation scope
Human check
Fallback
KPI
Risks
Next actions
Related concepts
Methods
Deliverables
```

Example frontmatter:

```yaml
---
type: project
project_name: "SCP.SOURCING.CHATBOT.v2.3"
phase: "DEVELOPMENT"
cluster: "AI / Data"
owner: "Khoa"
---
```

---

# 12. Standard Task Note Structure

Tasks are stored in:

```text
03_Projects/_Tasks/
```

Each task note should include:

```text
type: task
created date
project
lane
status
title
project link
outcome
next action
related documents
source/context
validation condition
related concepts
methods
projects
deliverables
```

Task notes should be linked into:

```text
PPJ_Executive_Board.canvas
Project note
Related deliverables
Related methods
```

---

# 13. Standard Meeting Note Structure

Meeting notes are stored in:

```text
08_Meeting_Notes/
```

Each meeting note should include:

```text
type: meeting
date
time
project
meeting title
project link
stakeholders
context
current process
pain points
requirements
data / source of truth
systems
decisions
risks / gaps
action items
open questions
next steps
related concepts
methods
projects
deliverables
```

Meeting notes should append a short update into the related project note.

---

# 14. Standard Deliverables

Deliverables are stored in:

```text
10_Deliverables/
```

Important deliverable templates:

```text
Decision_Driven_BRD
ERD_Template
User_Manual_Template
Automation Flow
Dashboard Design
Process Documentation
Data_Dictionary
```

Decision-driven BRD should focus on:

```text
Problem
Root cause
Decision needed
Options
Recommended option
Expected outcome
Process impact
User behavior impact
Data requirement
AI / automation design
Validation criteria
Fallback
KPI
Risk
Next action
```

---

# 15. Linking Philosophy

Every generated note should include Obsidian links.

Use clean linking sections without markdown H2 headings if the note is meant to paste directly:

```text
Related Concepts
[[Outcome Driven Thinking]]
[[System Thinking]]
[[Decision Making]]
[[Stakeholder Management]]
[[Data Governance]]

Methods
[[Impact Analysis]]
[[Decision Matrix]]
[[Requirement Elicitation]]
[[Data Mapping]]

Projects
[[PROJECT_NAME]]

Deliverables
[[Decision_Driven_BRD]]
[[ERD_Template]]
[[User_Manual_Template]]
```

Do not over-link generic words. Link only reusable concepts, methods, projects, and deliverables.

---

# 16. PowerShell Request Pattern I Use

When I ask ChatGPT for a PowerShell script, generate:

```text
1. What the script does
2. Copy-run PowerShell code
3. How to run it
4. What files it modifies
5. Safety notes
```

Script should be practical and immediately usable.

Preferred style:

```text
- Give full script
- Avoid pseudo-code
- Avoid vague explanation
- Use copy-paste commands
- Use comments inside script
- Preserve my existing vault structure
```

---

# 17. Common Tasks I Need ChatGPT to Generate Scripts For

Generate PowerShell scripts for tasks like:

```text
Create new project note
Move project to another phase
Add task to Executive Canvas
Add decision to Decision Log
Create meeting note
Append meeting update to project
Generate weekly portfolio report
Audit broken links
Backup vault
Normalize Canvas labels
Re-layout Canvas
Extract all project phases from frontmatter
Create missing notes from broken links
Generate project index
Generate dashboard note
Generate BRD from project note
Generate ERD skeleton from data section
Generate user manual skeleton from project note
Archive closed projects
Create monthly report
Create phase summary
Create owner workload summary
Create blocked dependency report
```

---

# 18. Important Current Needs

The Executive Canvas must stay readable.

Avoid compact layout.

Preferred Canvas layout:

```text
End-to-end horizontal lifecycle
Large lanes
Expanded spacing
Cards arranged with enough gap
Readable labels
ASCII group titles
```

Whenever updating Canvas layout, preserve:

```text
existing project nodes
existing task nodes
existing edges if possible
existing notes
existing backups
```

---

# 19. Recommended ChatGPT Behavior

When helping me, ChatGPT should think like:

```text
AI BA + Obsidian system architect + PowerShell automation helper
```

Always consider:

```text
Business problem
Project phase
Data source
System dependency
User impact
Decision needed
Deliverable affected
Canvas placement
Traceability link
Backup safety
```

When uncertain, choose the safer script:

```text
append instead of overwrite
backup before modify
create missing folder automatically
avoid deleting
avoid emoji in Canvas
```

---

# 20. One-Line System Summary

```text
This Obsidian vault is a PPJ AI/Automation Portfolio Command System that connects projects, phases, tasks, meetings, decisions, BRD/ERD/manual deliverables, and Canvas visualization through PowerShell automation.
```

## FD / CPD Datamart Separation Rule

- FD.Datamart.v2.2: FD / fabric datamart using Directus as backend/admin/data platform, with QR design or QR information module and QR attached to hanger usage.
- CPD.Datamart.v1.1: CPD / 3D Design datamart for image search, 3D sample library, and visual sample assets.
- Do not merge FD and CPD.
- Do not say FD business canonical concept is CPD.
- Do not say FD should be renamed to CPD.

<!-- PPJ_DOMAIN_RULE_START -->
## Portfolio Domain Governance Rule

- Primary Domain = Business Owner + Primary Users + Primary Business Capability.
- Domain is not technology, system, vendor, or technical team.
- Lifecycle and progress are separate from domain.
- Each project has exactly one Primary Domain.
- Secondary domains are tags only and must not duplicate Canvas cards.
- Domain model source file: 03_Projects/_Registry/PPJ_PORTFOLIO_DOMAIN_MODEL.md.
- Before answering domain questions, read the domain model and assignment matrix.
<!-- PPJ_DOMAIN_RULE_END -->

<!-- PPJ_EXTERNAL_COLLABORATION_RULE_START -->
## Third-Party / External Collaboration Rule

- `QC_DefectDetection_v1.0.0` (was `PPJxQSee.AI`), `PPJxNUNOX.ScanTrial`, `EXT_AcademicCollaboration_v1.1.0` (was `PPJ.UIT.ACADEMIC.COLLABORATION.v1.1`), `WASH_COWASH_v2.0.0` (was `PROD.COWASH.v2.0`), and `QC_ThreadTraceability_v1.0.0` (was `QC.Primo1D.RFID.Thread.v1.0`) are third-party projects in `EXTERNAL DEVELOPMENT`, not internal PPJ development. `PPJxStratova.AI` is closed (historical); the current Stratova pattern-generation PoC is a discovery item in `PPJ_DISCOVERY_REGISTER`, not a project.
- `PUR_HMLabelProcessing_v1.0.0` (was `PUR.HM.LabelO.Processing.Automation.v1.0`) remains in `INTERNAL DEVELOPMENT` with `status: On Hold`.
- External projects retain the furthest evidenced delivery stage inside the external stream; stream classification must never force them into the internal ANALYSIS lane.
<!-- PPJ_EXTERNAL_COLLABORATION_RULE_END -->

<!-- PPJ_PROJECT_WORKSPACE_PROTOCOL_START -->
## Project Workspace Registration and Update Protocol

When a newly approved canonical project is registered, create the root project note, project memory card, registry/index entry, right-sized project workspace, Tasks folder, local Executive Project Board, workspace links, and optional portfolio Canvas card in one approved Apply pipeline.

Registration pipeline:

New Project Information -> Canonical Resolution -> Registration Proposal -> Approval -> Root Project Note -> Memory -> Registry -> Workspace -> Documentation Pack -> Initial Tasks -> Project Executive Board -> Portfolio Canvas

When the user provides a project update or weekly report:

1. Identify affected canonical projects.
2. Update project memory and the root project note.
3. Update only relevant workspace documents.
4. Create, move, close or block tasks only when justified.
5. Update Risks / Issues and Decision Log where relevant.
6. Synchronize the local Project Executive Board.
7. Update the Registry.
8. Update portfolio Canvas when delivery stage, lifecycle, outcome or domain changes.

A blocker update normally changes Memory, Project Home, Risks / Issues, the relevant task and the local Project Board. It does not rewrite the BRD, Data Spec or User Manual unless requirements changed.
<!-- PPJ_PROJECT_WORKSPACE_PROTOCOL_END -->

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current Portfolio Snapshot Protocol

- Fast current state: `03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT.md`.
- Project read order: `AGENTS.md` -> Current Snapshot -> Memory Index -> Project Memory Card -> Root Project Note -> workspace documents as needed.
- New approved project information updates: memory -> root note -> relevant workspace docs -> tasks -> local board -> registry -> global Canvas when delivery-stage/lifecycle/domain/outcome changes.
- Do not embed full project descriptions in `AGENTS.md`; keep current detail in the snapshot and project layers.
- Canonical naming standard (2026-09-18 baseline): `<DEPARTMENT>_<APPLICATION>_v<MAJOR>.<MINOR>.<PATCH>`; lifecycle/status is never part of the name; vendor names are not used unless the vendor defines the business product; physical filenames are retained and resolved through `PPJ_PROJECT_ALIAS_MAP`.
- Vendor/technology discovery stays in `03_Projects/_Registry/PPJ_DISCOVERY_REGISTER.md` until PPJ approves a scope.
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->
