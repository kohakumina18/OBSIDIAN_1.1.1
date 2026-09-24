param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [switch]$UpdateAgents,
    [switch]$CreateProjectMemory,
    [switch]$CreateRegistrationProtocol,
    [string]$ProjectName
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
if ($DryRun -and $Apply) { throw "Use either -DryRun or -Apply, not both." }
if (-not $Apply) { $DryRun = $true }
if (-not $UpdateAgents -and -not $CreateProjectMemory -and -not $CreateRegistrationProtocol) {
    $UpdateAgents = $true
    $CreateProjectMemory = $true
    $CreateRegistrationProtocol = $true
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$vaultRoot = Split-Path -Parent $scriptRoot
$agentsPath = Join-Path $vaultRoot "AGENTS.md"
$readmePath = Join-Path $vaultRoot "README_PPJ_OBSIDIAN_SYSTEM.md.md"
$projectRoot = Join-Path $vaultRoot "03_Projects"
$registryRoot = Join-Path $projectRoot "_Registry"
$memoryRoot = Join-Path $registryRoot "Project_Memory"
$memoryIndexPath = Join-Path $registryRoot "PPJ_PROJECT_MEMORY_INDEX.md"
$protocolPath = Join-Path $registryRoot "PPJ_PROJECT_REGISTRATION_PROTOCOL.md"
$templatePath = Join-Path $projectRoot "_Templates\PPJ_PROJECT_MEMORY_CARD_TEMPLATE.md"
$registerScriptPath = Join-Path $scriptRoot "Register-PPJProject.ps1"
$reportRoot = Join-Path $vaultRoot "10_Reports"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$today = Get-Date -Format "yyyy-MM-dd"
$backupRoot = Join-Path $vaultRoot "99_Attachments\Audit\Agent_Compaction_Backup\$stamp"
$reportPath = Join-Path $reportRoot "AGENT_COMPACTION_AND_PROJECT_MEMORY_PLAN_$stamp.md"

function Read-Utf8 {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) { return Get-Content -Raw -Encoding UTF8 -LiteralPath $Path }
    return ""
}

function Write-Utf8 {
    param([string]$Path, [string]$Text)
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    [System.IO.File]::WriteAllText($Path, $Text.TrimEnd() + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))
}

function Get-LineCount {
    param([string]$Text)
    if ([string]::IsNullOrEmpty($Text)) { return 0 }
    return ($Text -split "`r?`n").Count
}

function Get-VaultRelativePath {
    param([string]$Path)
    $rootFull = [System.IO.Path]::GetFullPath($vaultRoot).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
    $pathFull = [System.IO.Path]::GetFullPath($Path)
    if ($pathFull.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $pathFull.Substring($rootFull.Length).TrimStart([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
    }
    return $pathFull
}

function Backup-ExistingFile {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $relative = Get-VaultRelativePath $Path
    $destination = Join-Path $backupRoot $relative
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
    Copy-Item -LiteralPath $Path -Destination $destination -Force
}

$agentsProposal = @'
# PPJ Knowledge Base Agent

## Mission

Operate this vault as PPJ Group's Business Analysis, AI/Automation, data, and project-governance knowledge system.

Convert requests, meetings, issues, evidence, and decisions into traceable project knowledge while preserving canonical identity and source evidence.

Prefer verified facts over assumptions. Mark uncertainty as `Needs Confirmation`.

## Fast Read Order

Before answering about a project:

1. Read `AGENTS.md`.
2. Read `03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md`.
3. Read the relevant card under `03_Projects/_Registry/Project_Memory/`.
4. Read the relevant root project note only when more detail is needed.
5. Read the Registry, domain model, assignment matrix, naming governance, or local workspace document relevant to the claim.
6. If sources conflict, report the conflict and do not invent a resolution.

For portfolio or domain questions, also read:

- `03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md`
- `03_Projects/_Registry/PPJ_PORTFOLIO_DOMAIN_MODEL.md`
- `03_Projects/_Registry/PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md`
- `03_Projects/_Registry/PPJ_PROJECT_NAMING_GOVERNANCE.md`

For project updates, read the update protocol and update ledger before changing files.

Do not preload every root project note. Load only the relevant project memory card and evidence needed for the task.

## Source of Truth

Use this precedence model:

1. User-confirmed current instruction or approved source event.
2. Canonical root project note under `03_Projects/`.
3. Project Registry and governed assignment matrices.
4. Relevant project memory card.
5. Local project workspace documents and tasks.
6. Meeting notes, decision logs, reports, and evidence.
7. Canvas cards and generated summaries.
8. Historical aliases, legacy notes, and inferred context.

A lower source must not silently override a higher source.

The Registry identifies canonical projects. Memory cards provide fast context, not independent truth.

The local Project Executive Board is generated from local task files. Canvas is a view, not the primary record.

Primary Domain means Business Owner + Primary Users + Primary Business Capability. Domain is not technology, vendor, platform, or delivery team.

Each canonical project has exactly one Primary Domain. Secondary domains are tags and must not create duplicate project cards.

Lifecycle, progress, status, priority, and domain are separate fields.

## Safety Rules

- Default to DryRun.
- Require explicit approval before Apply.
- Never delete, rename, move, archive, merge, or overwrite project files without explicit approval.
- Preserve existing project notes and workspace files.
- Back up every existing file before an approved mutation.
- Prefer append or managed-block replacement over unrestricted overwrite.
- Validate generated Markdown, frontmatter, links, and Canvas JSON before commit.
- Use staged writes and rollback for multi-file operations.
- Stop on duplicate canonical identity, workspace collision, invalid Canvas JSON, unresolved source conflict, or missing required governance source.
- Do not invent owners, dates, phases, KPIs, business rules, systems, data sources, implementation status, acceptance evidence, or vendor commitments.
- Use `Needs Confirmation` when evidence is insufficient.
- Do not expose credentials or secrets in notes, logs, scripts, screenshots, or reports.
- Do not change portfolio Canvas unless the request explicitly requires it and approval covers it.

## Current Canonical Project Rule

A real project must resolve through the memory index, Registry, root project file, and alias map.

Use the canonical filename already established in the Registry. Do not normalize or upgrade a version by guessing.

Do not create a second note for an alias, old name, spelling variation, department nickname, module, or workstream unless registration governance confirms it is a separate canonical project.

`PROJECT_COMMAND_CENTER.md` is a portfolio control note, not an ordinary business project unless the Registry explicitly says otherwise.

Before making a canonical claim, verify the physical root note exists and matches the Registry or report the inconsistency.

## Project Memory Rule

Each canonical project should have one compact card:

`03_Projects/_Registry/Project_Memory/PROJECT_FILE_BASENAME.memory.md`

Memory cards should remain under 120 lines and contain:

- one-line understanding
- business meaning and outcome
- explicit scope boundaries
- users
- systems and data
- current phase/status
- risks, decisions, and next actions
- Do Not Drift rules
- source links, last verified date, and confidence

Do not paste a full root project note into a memory card.

When an approved project update changes project understanding, synchronize:

1. memory card
2. root project managed block
3. only the relevant workspace documents
4. justified tasks, risks, issues, decisions, and local board
5. Registry summary
6. update ledger
7. portfolio Canvas only when lifecycle, outcome, or domain changes and Canvas update is approved

A blocker update normally changes Memory, Project Home, Risks/Issues, relevant task, local board, Registry, and ledger. It does not rewrite BRD, Data Spec, or User Manual unless requirements changed.

## New Project Registration Rule

When the user says `new project`, `add project`, `register project`, `create project`, `track this project`, or mentions a project absent from memory/index/registry:

1. Check the project memory index.
2. Check the project Registry and alias map.
3. Check root project files.
4. If not found, start the New Project Registration Protocol.
5. Ask for or infer minimum metadata, marking inferred values `Needs Confirmation`.
6. Produce a DryRun registration proposal.
7. Do not create assets until Apply is approved.

Minimum metadata:

- project name
- department / owner group
- object / domain
- characteristic / purpose
- version
- business problem
- target users
- owner
- BA coordination
- technical members
- phase
- priority
- outcome
- source system/data
- next action

Approved registration is one atomic pipeline:

New Project Information -> Canonical Resolution -> Registration Proposal -> Approval -> Root Project Note -> Memory -> Registry -> Workspace -> Lifecycle Documentation -> Initial Tasks -> Local Project Board -> Optional Portfolio Canvas

Do not silently create random notes.

## Managed Block Marker Rule

The only valid managed project-knowledge markers are:

```html
<!-- PPJ_PROJECT_KNOWLEDGE_START -->
<!-- PPJ_PROJECT_KNOWLEDGE_END -->
```

Automation may update content inside this pair only when the operation explicitly covers root project knowledge.

Preserve all content outside the managed block.

Do not create alternate project-knowledge marker names.

Registry, Command Center, index, and governance overlays may use their own script-specific marker pairs, but they do not replace the project-knowledge markers.

## FD / CPD Datamart Separation

`FD.Datamart.v2.2` and `CPD.Datamart.v1.1` are separate canonical projects.

`FD.Datamart.v2.2`:

- FD / fabric datamart
- Directus backend/admin/data platform
- QR design or QR information module
- QR attached to hanger
- hanger, fabric, and sample data visibility

`CPD.Datamart.v1.1`:

- CPD / 3D Design datamart
- image search
- 3D sample library
- visual sample assets
- Chi Trang / 3D Design workflow only when confirmed

Never merge FD and CPD. Never say FD is CPD or CPD is FD. Never rename either without approval.

Do not assign image search or 3D sample library to FD unless separately confirmed.

Do not assign Directus hanger QR scope to CPD unless separately confirmed.

## Canvas Rule

Canvas is a visualization layer, not the source of truth.

Use horizontal lifecycle lanes:

`PENDING | ANALYSIS | DESIGN | DEVELOPMENT | STABILIZE / UAT | PRODUCTION / SUPPORT | EXTERNAL / THIRD PARTIES | BLOCKED / DEPENDENCY | TASKS / DOCS TO UPDATE | CLOSED / CANCELLED`

- Use large readable lanes and spacing.
- Use ASCII group labels; avoid emoji and smart punctuation.
- Preserve existing project nodes, task nodes, edges, and manually maintained summary nodes unless rebuilding is explicitly approved.
- Back up Canvas files before changes.
- Validate JSON before and after writing.
- Do not duplicate a project card for secondary domains.
- Local boards must derive task cards from `03_Projects/PROJECT/Tasks/*.md`.
- Portfolio Canvas changes require explicit scope and approval.

## PowerShell and Encoding Rule

- Resolve the vault from the script location, not current working directory.
- Scripts must work from any launch directory.
- Default to DryRun; use `-Apply` only after approval.
- Use UTF-8 for Markdown and JSON.
- Use safe Windows-compatible filenames.
- Avoid emoji, smart quotes, and special Unicode in PowerShell-generated Canvas labels.
- Use `Get-Content -Raw -Encoding UTF8`, `Set-Content -Encoding UTF8`, or .NET UTF-8 without BOM consistently.
- Keep scripts idempotent where practical.
- Display files to create, modify, back up, and skip.
- Use timestamped reports and backup folders.
- Never use force to bypass duplicate canonical identity or destructive safety checks.

## DryRun / Apply Rule

DryRun is the default and must not modify files.

A DryRun should show:

- resolved canonical project(s)
- source evidence and conflicts
- files to create
- files to modify
- files to preserve or skip
- backup target
- validation results
- hard stops and warnings
- whether Apply is safe

Apply requires explicit approval and must:

1. rediscover current state
2. refuse unresolved hard stops
3. create timestamped backups
4. stage all outputs
5. validate staged content
6. commit the complete set
7. roll back on failure
8. validate committed state
9. append an update-ledger event
10. write a timestamped report when the workflow defines one

Do not run Apply merely because a script was created or syntax-checked.

## Business Analysis Rule

For every project or update, distinguish:

- business problem
- root cause
- decision needed
- target users and business owner
- current and future process
- scope and out of scope
- source of truth and data ownership
- fields, rules, mappings, and exceptions
- system dependencies and permissions
- human review, fallback, and escalation
- KPI and acceptance evidence
- risks, issues, assumptions, and decisions
- next action and accountable owner

Generated documentation must be lifecycle-driven. Do not create a fixed 30-document pack for every project.

Always activate core governance documents. Activate discovery, solution, UAT, production, external-trial, or closure documents only when lifecycle and project type justify them.

Preserve previously created inactive documents. Do not delete them merely because they are not currently active.

A document template or file existing does not prove project maturity or completion.

## Textile Manufacturing Context

PPJ operates in textile and garment manufacturing. Typical domains include Merchandising, Accounting, Finance, Purchasing, Sourcing, EXIM, HR, Technical, R&D Wash, CPD/3D Design, Fabric Development, Production, Factory operations, Data, IT, and AI/Automation.

Common systems and evidence may include WFX/ERP, DWH, Directus, GLPI, supplier portals, invoices, GRN, PO, BOM, costing, material allocation, labels, samples, wash data, IoT, RFID, images, technical documents, and controlled knowledge sources.

Treat manufacturing terminology as domain-specific. Confirm acronyms, ownership, business rules, and source systems rather than expanding or interpreting them from memory.

Respect commercial, employee, supplier, costing, technical, and production data sensitivity.

External vendor exploration, workshops, sharing events, and internal product systems are different project types and must not be described as equivalent maturity.

## Response Pattern

Keep responses concise and operational.

For scripts or automation, provide:

1. what it does
2. DryRun command
3. Apply command marked approval-required
4. files affected
5. backup and rollback behavior
6. validation status
7. hard stops or unresolved evidence

For project questions, provide:

- canonical project name
- concise verified understanding
- phase/status with confidence
- source conflict if any
- next action

Use Obsidian wiki links inside vault content. Do not over-link generic words.
'@

$readmeProposal = @'
# PPJ Obsidian Business Knowledge Base

## Purpose

This vault is the PPJ AI/Automation Portfolio Command System for Business Analysis, project governance, data, automation, chatbot, dashboard, manufacturing workflow, and decision traceability.

```text
Request / meeting / issue
-> evidence and structured note
-> canonical project
-> memory and workspace
-> task / decision / risk
-> local board and Registry
-> portfolio reporting
```

## Operating Model

The vault separates fast-loading context from detailed evidence:

1. `AGENTS.md` - compact operating rules.
2. `03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md` - portfolio memory index.
3. `03_Projects/_Registry/Project_Memory/` - one compact card per canonical project.
4. Root project notes under `03_Projects/` - canonical project knowledge.
5. Local project workspaces - lifecycle-activated documentation, tasks, evidence, meetings, and board.
6. Registry, domain, naming, resource, and update-ledger files - governance.
7. Canvas and reports - derived views.

## Core Folders

```text
00_Inbox/                       incoming updates and requests
01_Daily_Notes/                 daily working notes
02_BA_Knowledge/                reusable BA, data, automation, and manufacturing knowledge
03_Projects/                    canonical notes and local project workspaces
03_Projects/_Registry/          Registry, memory index, governance, ledger
03_Projects/_Templates/         project and memory templates
04_Data_Dictionary/             entities, fields, mappings, definitions
05_Process_Library/             L1/L2/L3 process knowledge
06_AI_Automation/               reusable AI and automation designs
07_Decision_Log/                decision records
08_Meeting_Notes/               cross-project meeting records
09_Stakeholders/                stakeholder knowledge
10_Reports/                     portfolio and audit reports
11_PROJECT_MANAGEMENT/          management methods and templates
99_Attachments/                 evidence, backups, audit artifacts
scripts/                        DryRun-first automation
```

Scripts resolve the vault from their own location. They do not require the terminal working directory to be the vault root.

## Source-of-Truth Read Order

Before answering about a project:

1. `AGENTS.md`
2. project memory index
3. relevant project memory card
4. canonical root project note when detail is needed
5. Registry and relevant governance model
6. relevant local workspace document, task, meeting, decision, or evidence

If sources conflict, report the conflict. Do not invent.

## Canonical Project Architecture

Each approved canonical project should have:

```text
03_Projects/PROJECT.md
03_Projects/_Registry/Project_Memory/PROJECT.memory.md
03_Projects/PROJECT/00_Project_Home.md
03_Projects/PROJECT/Tasks/
03_Projects/PROJECT/Meetings/
03_Projects/PROJECT/Evidence/
03_Projects/PROJECT/Project_Executive_Board.canvas
```

Additional documents are activated by lifecycle and project type. Existing inactive documents are preserved.

The root note keeps canonical knowledge inside:

```html
<!-- PPJ_PROJECT_KNOWLEDGE_START -->
<!-- PPJ_PROJECT_KNOWLEDGE_END -->
```

Content outside this block is preserved by managed update workflows.

## Lifecycle-Driven Documentation

Core governance documents are active for every project. Other documents are activated only when justified:

- Discovery/Analysis: problem, scope, process, stakeholders, requirements, data discovery.
- Design/Development: solution, architecture, interfaces, data mapping, controls, testing approach.
- Stabilize/UAT: UAT, defects, training, readiness, acceptance evidence.
- Production/Support: runbook, monitoring, KPI, support, change and incident records.
- External/Trial: vendor evaluation, PoC criteria, commercial assumptions, trial evidence.
- Closed/Cancelled: closure decision, outcome, lessons learned, handover or cancellation evidence.

File count is not a maturity metric. Evidence, decisions, accepted outcomes, and actionable tasks are maturity signals.

## Project Memory

Memory cards are compact, evidence-aware session starters. Keep each card under 120 lines.

They record one-line understanding, outcome, scope boundaries, users, systems/data, status, risks, decisions, next actions, drift rules, confidence, and source links.

Memory does not override the root project note or Registry.

## Project Registration

A new project must follow:

```text
New Project Information
-> Canonical Resolution
-> Registration Proposal
-> Approval
-> Root Project Note
-> Memory Card
-> Registry and Index
-> Lifecycle Workspace
-> Optional Initial Task
-> Local Board
-> Optional Portfolio Canvas
```

Minimum metadata includes project name, department, object, purpose, version, business problem, users, owner, BA, technical members, phase, priority, outcome, source/data, and next action.

Use:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Register-PPJProject.ps1" `
  -DryRun `
  -ProjectName "PROJECT_NAME" `
  -Department "DEPARTMENT" `
  -Object "OBJECT" `
  -Characteristic "PURPOSE" `
  -Version "v1.1" `
  -Cluster "CLUSTER" `
  -Phase "ANALYSIS" `
  -Priority "P1" `
  -Outcome "EXPECTED OUTCOME" `
  -BusinessOwner "OWNER" `
  -BA "BA" `
  -TechnicalMembers "MEMBER 1","MEMBER 2" `
  -BusinessProblem "BUSINESS PROBLEM" `
  -TargetUsers "TARGET USERS" `
  -SourceData "SOURCE SYSTEM OR DATA" `
  -NextAction "NEXT ACTION"
```

Registration is DryRun by default. Apply is approval-required and atomic.

## Project Updates

For an approved update:

1. resolve canonical project identity
2. preserve source event and evidence
3. update memory and root managed knowledge
4. update only lifecycle-relevant workspace documents
5. create or update justified tasks, risks, issues, and decisions
6. synchronize local board
7. update Registry
8. append update ledger
9. update portfolio Canvas only when approved and lifecycle/outcome/domain changed

## Project Tasks

Tasks live under each project's `Tasks/` folder and are the source for the local Project Executive Board.

A valid task includes canonical project, unique task ID, actionable title, status, priority, owner, due date when known, source event, and acceptance condition.

Use `scripts/new_ppj_project_task.py` in DryRun first. Approved Apply stages the task, board, Registry, Command Center, and ledger together, with rollback on failure.

## Canvas

Canvas is a derived view. It is not the source of truth.

Preferred portfolio lanes:

```text
PENDING | ANALYSIS | DESIGN | DEVELOPMENT | STABILIZE / UAT |
PRODUCTION / SUPPORT | EXTERNAL / THIRD PARTIES |
BLOCKED / DEPENDENCY | TASKS / DOCS TO UPDATE | CLOSED / CANCELLED
```

Use readable horizontal spacing and ASCII labels. Back up before change, preserve nodes/edges unless rebuild is approved, and validate JSON.

## FD and CPD Datamarts

`FD.Datamart.v2.2` manages FD/fabric/hanger data with Directus and QR support for hanger usage.

`CPD.Datamart.v1.1` is a separate CPD/3D Design datamart for image search, 3D sample library, and visual sample assets.

Do not merge, rename, or exchange their scopes.

## DryRun and Apply

DryRun is the default and modifies nothing.

DryRun reports resolved projects, evidence/conflicts, proposed creates/updates, preserved files, backup target, validation, warnings, hard stops, and Apply safety.

Approved Apply must rediscover current state, back up existing files, stage all outputs, validate, commit atomically, roll back on error, append a ledger event, and write a timestamped report when required.

## Encoding and Safety

- UTF-8 Markdown and JSON.
- Safe Windows-compatible filenames.
- ASCII Canvas labels.
- Obsidian wiki links for vault content.
- No credentials or secrets in notes/logs.
- No silent project renames, moves, merges, deletions, or Canvas changes.
- No guessed owners, data, rules, status, or evidence.

## Key Governance Files

```text
03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md
03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md
03_Projects/_Registry/PPJ_PROJECT_REGISTRATION_PROTOCOL.md
03_Projects/_Registry/PPJ_PROJECT_ALIAS_MAP.md
03_Projects/_Registry/PPJ_PROJECT_NAMING_GOVERNANCE.md
03_Projects/_Registry/PPJ_PORTFOLIO_DOMAIN_MODEL.md
03_Projects/_Registry/PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md
03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md
03_Projects/_Registry/PPJ_PROJECT_MODULE_INDEX.md
```

## Reporting and Validation

Use timestamped reports under `10_Reports/` and timestamped backups under `99_Attachments/Audit/`.

After script changes, syntax-check the script and run DryRun. Do not run Apply unless separately approved.
'@

$memoryTemplate = @'
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
'@

$registrationProtocol = @'
# PPJ Project Registration Protocol

## Trigger

Start this protocol when the user says `new project`, `add project`, `register project`, `create project`, `track this project`, or mentions a project absent from memory/index/registry.

## Resolution Before Creation

1. Check `PPJ_PROJECT_MEMORY_INDEX.md`.
2. Check `PPJ_PROJECT_REGISTRY.md` and `PPJ_PROJECT_ALIAS_MAP.md`.
3. Check root project Markdown files.
4. Resolve aliases, spelling variants, modules, workstreams, and version references.
5. If an existing canonical project matches, update it instead of creating a duplicate.
6. If no project matches, prepare a registration proposal.
7. Do not create assets until Apply is approved.

## Minimum Metadata

- Project name
- Department / owner group
- Object / domain
- Characteristic / purpose
- Version
- Business problem
- Target users
- Business owner
- BA coordination
- Technical members
- Phase
- Priority
- Outcome
- Source system/data
- Next action

Inferred values must be marked `Needs Confirmation`.

## DryRun Proposal

The proposal must show canonical filename, duplicate and alias findings, lifecycle class, active document pack, root note, memory card, Registry/index/module updates, workspace folders, local board, optional task, optional Canvas card, backup target, warnings, and hard stops.

DryRun modifies nothing.

## Approved Atomic Registration

Create in one staged transaction:

1. root project note under `03_Projects/`
2. compact memory card under `_Registry/Project_Memory/`
3. memory index row
4. structured Registry entry
5. project module index entry
6. lifecycle-driven local workspace
7. `Tasks/`, `Meetings/`, and `Evidence/` folders
8. local Project Executive Board
9. Command Center workspace link
10. update-ledger event
11. optional initial task
12. optional portfolio Canvas card only when explicitly requested

Back up every existing governance or Canvas file before replacement. Validate staged Markdown/frontmatter and Canvas JSON. Roll back all committed files on failure.

## Naming and Drift Controls

- Do not invent or increment a version.
- Do not overwrite an existing canonical note.
- Do not use `-Force` to bypass exact canonical identity.
- Do not merge projects without approval.
- Keep FD.Datamart.v2.2 and CPD.Datamart.v1.1 separate.
- Keep Sourcing chatbot scope in SCP.SOURCING.CHATBOT.v2.3 unless separation is approved.
- Keep individual AI projects separate from PPJ.AI.Hub.v2.1.

## Registration Command

Use `scripts/Register-PPJProject.ps1` with full metadata and `-DryRun`. Replace `-DryRun` with `-Apply` only after approval.
'@

$projectSeeds = @(
    @{ File = "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1"; Understanding = "MER-led Chico's invoice/costing recheck and audit automation."; Outcome = "Standardize and speed up invoice/costing checking for Chico's workflow."; Drift = "Do not classify as purely Accounting unless evidence proves it." },
    @{ File = "AI Automation Workshop"; Understanding = "AI automation workshop/event note."; Outcome = "Capture workshop outputs and follow-up actions."; Drift = "Do not treat as a product system." },
    @{ File = "CPD.Datamart.v1.1"; Understanding = "Separate CPD/3D Design datamart for image search and 3D sample library management."; Outcome = "Build a searchable visual sample library and image search for 3D Design."; Drift = "Do not merge with FD.Datamart.v2.2 or assign Directus hanger QR scope without confirmation." },
    @{ File = "FD.Datamart.v2.2"; Understanding = "FD Datamart uses Directus to manage FD/fabric/hanger data and QR information for hanger usage."; Outcome = "Manage FD/fabric/hanger data in Directus with QR support for hanger operation."; Drift = "Do not describe as CPD Datamart or assign image search/3D library scope without confirmation." },
    @{ File = "HR.SS&PFD.v1.1"; Understanding = "HR-related data/process project requiring acronym and scope confirmation."; Outcome = "Prepare structured HR process or reporting support."; Drift = "Do not expand SS&PFD without evidence." },
    @{ File = "MER.PO-Commit"; Understanding = "MER PO commitment workflow support."; Outcome = "Support PO/customer commitment tracking and follow-up."; Drift = "Confirm closed or production-support status before claiming it." },
    @{ File = "PPJ XPrimo1D RFID Thread"; Understanding = "External RFID thread technology exploration."; Outcome = "Explore product identification and traceability feasibility."; Drift = "Keep as exploration unless a trial is confirmed." },
    @{ File = "PPJ. Expense-Invoices.v1.1"; Understanding = "EXIM-first expense invoice entry automation."; Outcome = "Automate EXIM expense invoice entry and prepare a reusable rollout foundation."; Drift = "Do not create v2 without approval." },
    @{ File = "PPJ.AI.Hub.v2.1"; Understanding = "Central AI tools, bots, chatbots, automation apps, and internal hub for PPJ."; Outcome = "Centralize access and governance for PPJ AI tools and automation modules."; Drift = "Do not absorb or merge individual project notes into AI Hub." },
    @{ File = "PPJ.COSTING.AGENT.PLATFORM.v1.1"; Understanding = "Agentic costing platform for MER quotation and technical costing decomposition."; Outcome = "Support faster quotation by routing requests into costing and technical agents."; Drift = "Keep as a strategic platform, not a simple calculator." },
    @{ File = "PPJ.GLPI-Helpdesk-AI Chatbot"; Understanding = "AI chatbot for GLPI/IT Helpdesk knowledge search, support Q&A, escalation, and possible ticket routing."; Outcome = "Resolve IT support questions and route requests faster."; Drift = "Do not claim ticket creation is implemented unless confirmed." },
    @{ File = "PPJ.Invoice Downloader.v1.2"; Understanding = "VNPT/supplier e-invoice downloader and merging tool."; Outcome = "Download and merge e-invoices for Accounting and EXIM workflows."; Drift = "Do not assume credential handling or auto-posting unless confirmed." },
    @{ File = "PPJ.PERRI.Chatbot"; Understanding = "Internal chatbot and orchestrator for document Q&A, data lookup, department agents, and future workflow triggers."; Outcome = "Provide controlled chatbot orchestration for PPJ knowledge and tool workflows."; Drift = "Do not treat as a simple FAQ bot; preserve permission, logging, fallback, and trigger controls." },
    @{ File = "PPJxNUNOX"; Understanding = "External NUNOX hardware/tool feasibility trial."; Outcome = "Evaluate hardware/tool feasibility for sample or sourcing workflow."; Drift = "Confirm exact hardware scope." },
    @{ File = "PPJxQSee.ai"; Understanding = "External AI QC/inspection collaboration exploration."; Outcome = "Explore AI QC use case and PoC requirements."; Drift = "Do not claim implementation unless PoC is confirmed." },
    @{ File = "PPJxStratova AI"; Understanding = "External AI vendor engagement history, likely closed or low confidence."; Outcome = "Preserve lessons learned and vendor screening history."; Drift = "Use Weak/Needs Confirmation if evidence is absent." },
    @{ File = "PROD.COWASH"; Understanding = "Production/wash-related project requiring scope confirmation."; Outcome = "Clarify production/wash tracking or dashboard support."; Drift = "Do not over-define until rescope is confirmed." },
    @{ File = "PROD.IOT.CHuyenTreo_1"; Understanding = "Production IoT Chuyen Treo monitoring/dashboard project."; Outcome = "Improve production-line visibility through IoT monitoring."; Drift = "Confirm metrics and device/data source." },
    @{ File = "PUR.Adhoc Indent mien Nam"; Understanding = "Adhoc indent automation/support for southern-region Purchasing workflow."; Outcome = "Support regional adhoc indent processing."; Drift = "Keep mien Nam scope unless expansion is confirmed." },
    @{ File = "PUR.GDI Automation"; Understanding = "Purchasing GDI automation dependent on input standardization and WFX feasibility."; Outcome = "Automate GDI after dependencies are resolved."; Drift = "Do not mark production while WFX dependency remains." },
    @{ File = "PUR.H&M Label-O Processing"; Understanding = "H&M Label-O processing automation pending blocker and priority confirmation."; Outcome = "Support label processing after requirements and blockers are confirmed."; Drift = "Do not mark active if still delayed." },
    @{ File = "PUR.Inventory Report"; Understanding = "Purchasing inventory report automation."; Outcome = "Improve inventory visibility and reduce repeated reporting work."; Drift = "Confirm users, data source, and refresh schedule." },
    @{ File = "PUR.Material.Allocation.v1.1"; Understanding = "Purchasing/material allocation workflow with validation, review, and WFX dependency tracking."; Outcome = "Support material-allocation decisions and reduce manual processing."; Drift = "Keep WFX dependency visible." },
    @{ File = "SCP.SOURCING.CHATBOT.v2.3"; Understanding = "Sourcing chatbot and data platform for supplier, material, fabric, trims, and sample lookup."; Outcome = "Enable sourcing lookup and data governance."; Drift = "Do not split sourcing into separate project notes without approval." },
    @{ File = "TD.TechnicalPlatform_v2.1"; Understanding = "Technical knowledge platform for BOM, pattern, sewing, measurement, videos, and historical costing data."; Outcome = "Create a technical knowledge foundation for AI search and costing agents."; Drift = "Respect technical data sensitivity." },
    @{ File = "VITAS Sharing"; Understanding = "External sharing or industry engagement activity."; Outcome = "Track preparation, follow-up, and reusable portfolio insight."; Drift = "Do not treat as an internal automation project." },
    @{ File = "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1"; Understanding = "R&D Wash sampling management portal."; Outcome = "Centralize wash sampling workflow into a searchable portal."; Drift = "Do not merge with CPD or FD Datamart." },
    @{ File = "Workshop Analysis"; Understanding = "Post-workshop analysis note."; Outcome = "Convert workshop insights into project opportunities and decisions."; Drift = "Do not treat as a product system." }
)

if (-not [string]::IsNullOrWhiteSpace($ProjectName)) {
    $projectSeeds = @($projectSeeds | Where-Object { $_.File -ieq $ProjectName })
    if ($projectSeeds.Count -eq 0) { throw "ProjectName is not present in the governed memory seed list: $ProjectName" }
}

function New-MemoryCard {
    param([hashtable]$Seed)
    return @"
---
type: project_memory
project_name: "$($Seed.File)"
project_file: "$($Seed.File).md"
project_code: "$($Seed.File)"
department: "Needs Confirmation"
cluster: "Needs Confirmation"
phase: "Needs Confirmation"
status: "Needs Confirmation"
priority: "Needs Confirmation"
business_owner: "Needs Confirmation"
ba_coordination: []
technical_members: []
stakeholders: []
systems: []
data_sources: []
last_verified: "$today"
confidence: "Needs Confirmation"
---

# Project Memory: $($Seed.File)

## One-Line Understanding

$($Seed.Understanding)

## Business Meaning

Needs Confirmation

## Outcome

$($Seed.Outcome)

## What This Project Is

$($Seed.Understanding)

## What This Project Is Not

Not a different canonical project, alias merge, or unapproved scope expansion.

## Key Users

Needs Confirmation

## Systems / Data

Needs Confirmation

## Current Phase / Status

Needs Confirmation

## Known Risks

Needs Confirmation

## Decisions Needed

Confirm current owner, lifecycle, evidence, source systems, and next gate.

## Next Actions

Read the canonical root project note and confirm current evidence.

## Do Not Drift Rules

- $($Seed.Drift)
- Do not invent implementation status, owners, dates, systems, or evidence.

## Source Links

- [[$($Seed.File)]]
"@
}

$currentAgents = Read-Utf8 $agentsPath
$currentReadme = Read-Utf8 $readmePath
$currentAgentsLines = Get-LineCount $currentAgents
$proposedAgentsLines = Get-LineCount $agentsProposal
$currentReadmeLines = Get-LineCount $currentReadme
$proposedReadmeLines = Get-LineCount $readmeProposal
$cardsToCreate = @()
$cardsPreserved = @()
$seedNotesAbsent = @()
$existingMemoryFiles = if (Test-Path -LiteralPath $memoryRoot) { @(Get-ChildItem -LiteralPath $memoryRoot -Filter "*.memory.md" -File) } else { @() }
foreach ($seed in $projectSeeds) {
    $projectNote = Join-Path $projectRoot "$($seed.File).md"
    $memoryPath = Join-Path $memoryRoot "$($seed.File).memory.md"
    if (-not (Test-Path -LiteralPath $projectNote)) { $seedNotesAbsent += $seed.File; continue }
    $existingCard = $existingMemoryFiles | Where-Object {
        (Read-Utf8 $_.FullName) -match ('(?m)^project_file:\s*["'']?' + [Regex]::Escape("$($seed.File).md") + '["'']?\s*$')
    } | Select-Object -First 1
    if ($existingCard) { $cardsPreserved += $existingCard.FullName }
    elseif (Test-Path -LiteralPath $memoryPath) { $cardsPreserved += $memoryPath }
    else { $cardsToCreate += @{ Path = $memoryPath; Seed = $seed } }
}

$previewRows = @($projectSeeds | Select-Object -First 8 | ForEach-Object {
    "| $($_.File) | $($_.Understanding) | $($_.Outcome) | Needs Confirmation |"
})
$filesToModify = @()
$filesToCreate = @()
if ($UpdateAgents) {
    if (Test-Path -LiteralPath $agentsPath) { $filesToModify += $agentsPath } else { $filesToCreate += $agentsPath }
    if (Test-Path -LiteralPath $readmePath) { $filesToModify += $readmePath } else { $filesToCreate += $readmePath }
}
if ($CreateProjectMemory) {
    $filesToCreate += @($cardsToCreate | ForEach-Object { $_.Path })
    if (-not (Test-Path -LiteralPath $memoryIndexPath)) { $filesToCreate += $memoryIndexPath }
    if (Test-Path -LiteralPath $templatePath) { $filesToModify += $templatePath } else { $filesToCreate += $templatePath }
}
if ($CreateRegistrationProtocol) {
    if (Test-Path -LiteralPath $protocolPath) { $filesToModify += $protocolPath } else { $filesToCreate += $protocolPath }
}
$filesToCreate += $reportPath

Write-Host "PPJ Agent Compaction and Project Memory Plan"
Write-Host "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Write-Host "Current AGENTS.md line count: $currentAgentsLines"
Write-Host "Proposed AGENTS.md line count: $proposedAgentsLines"
Write-Host "Current README line count: $currentReadmeLines"
Write-Host "Proposed README line count: $proposedReadmeLines"
Write-Host "Estimated AGENTS line reduction: $([Math]::Max(0, $currentAgentsLines - $proposedAgentsLines))"
Write-Host "Project memory cards to create: $($cardsToCreate.Count)"
Write-Host "Existing project memory cards preserved: $($existingMemoryFiles.Count)"
Write-Host "Governed seed cards resolved to existing memory: $($cardsPreserved.Count)"
Write-Host "Seed project notes absent and skipped: $(if ($seedNotesAbsent.Count -eq 0) { 'None' } else { $seedNotesAbsent -join '; ' })"
Write-Host "Project memory index preview:"
Write-Host "| Project | One-Line Understanding | Outcome | Confidence |"
Write-Host "| --- | --- | --- | --- |"
$previewRows | ForEach-Object { Write-Host $_ }
Write-Host "Registration protocol preview: resolve index -> Registry/aliases -> root notes -> DryRun proposal -> approval -> atomic registration"
Write-Host "Register script plan: preserve and use scripts/Register-PPJProject.ps1 with the atomic Python engine"
Write-Host "Files that would be modified:"
@($filesToModify | Sort-Object -Unique) | ForEach-Object { Write-Host " - $(Get-VaultRelativePath $_)" }
Write-Host "Files that would be created:"
@($filesToCreate | Sort-Object -Unique) | ForEach-Object { Write-Host " - $(Get-VaultRelativePath $_)" }
Write-Host "Backup target on Apply: $(Get-VaultRelativePath $backupRoot)"

if ($DryRun) {
    Write-Host "No files modified. DryRun completed."
    exit 0
}

$backupCandidates = @($filesToModify)
foreach ($path in ($backupCandidates | Sort-Object -Unique)) { Backup-ExistingFile $path }

if ($UpdateAgents) {
    Write-Utf8 $agentsPath $agentsProposal
    Write-Utf8 $readmePath $readmeProposal
}
if ($CreateProjectMemory) {
    Write-Utf8 $templatePath $memoryTemplate
    foreach ($card in $cardsToCreate) { Write-Utf8 $card.Path (New-MemoryCard $card.Seed) }
    if (-not (Test-Path -LiteralPath $memoryIndexPath)) {
        $rows = @()
        foreach ($seed in $projectSeeds) {
            $memoryPath = Join-Path $memoryRoot "$($seed.File).memory.md"
            $projectNote = Join-Path $projectRoot "$($seed.File).md"
            if ((Test-Path -LiteralPath $memoryPath) -and (Test-Path -LiteralPath $projectNote)) {
                $rows += "| [[$($seed.File)]] | [[$($seed.File).memory]] | [[$($seed.File)]] | Needs Confirmation | Needs Confirmation | Needs Confirmation | $($seed.Understanding) | $($seed.Outcome) | Needs Confirmation | $today |"
            }
        }
        $indexContent = "# PPJ Project Memory Index`n`n| Project | Memory Card | Project Note | Cluster | Phase | Priority | One-Line Understanding | Outcome | Confidence | Last Verified |`n| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |`n" + ($rows -join "`n")
        Write-Utf8 $memoryIndexPath $indexContent
    }
}
if ($CreateRegistrationProtocol) { Write-Utf8 $protocolPath $registrationProtocol }

$estimatedPercent = if ($currentAgentsLines -gt 0) { [Math]::Round((($currentAgentsLines - $proposedAgentsLines) / $currentAgentsLines) * 100, 1) } else { 0 }
$report = @"
# Agent Compaction and Project Memory Plan - $stamp

## Executive Summary

Compact always-loaded guidance and move project-specific understanding into governed memory cards.

## Why Compaction Is Needed

Current AGENTS.md: $currentAgentsLines lines. Proposed: $proposedAgentsLines lines.

## New Architecture

AGENTS -> Memory Index -> Relevant Memory Card -> Root Note -> Registry / Workspace Evidence.

## AGENTS.md Changes

Long project descriptions removed; core operating, safety, drift, registration, lifecycle, and Canvas rules retained.

## Project Memory Cards

Created: $($cardsToCreate.Count). Existing cards preserved: $($existingMemoryFiles.Count). Governed seed cards resolved: $($cardsPreserved.Count).

## Project Memory Index

Fast-loading governed project summary retained or rebuilt only when explicitly forced.

## Registration Protocol

Canonical resolution and approval precede an atomic multi-file registration transaction.

## Scripts Created

- scripts/Compact-PPJAgentAndProjectMemory.ps1
- scripts/Register-PPJProject.ps1
- scripts/register_ppj_project.py

## Token Usage Benefit

Estimated AGENTS line reduction: $estimatedPercent%.

## Drift Control Rules

Read index, memory, root note, and Registry; report conflicts; do not invent; keep FD and CPD separate.

## Apply Plan

Back up affected files, write compact guidance, create missing memory assets, preserve project notes, and do not update Canvas.

## Approval Checklist

- [x] Backup existing affected files
- [x] Preserve root project notes
- [x] Preserve existing project memory cards
- [x] Do not update Canvas
- [x] Use staged registration and task workflows
"@
Write-Utf8 $reportPath $report
Write-Host "Apply completed. Report: $(Get-VaultRelativePath $reportPath)"
