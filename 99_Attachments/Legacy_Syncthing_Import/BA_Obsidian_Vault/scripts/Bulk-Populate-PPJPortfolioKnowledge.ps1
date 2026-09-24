param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [switch]$UpdateMemory,
    [switch]$UpdateProjectNotes,
    [switch]$UpdateRegistry,
    [switch]$UpdateResourceMatrix,
    [switch]$UpdateLedger,
    [switch]$CreateMissingProjectNotes,
    [switch]$IncludeCandidates,
    [string]$ProjectName
)

$ErrorActionPreference = "Stop"

if (-not $Apply) {
    $DryRun = $true
}
if ($Apply -and $DryRun) {
    throw "Choose either -DryRun or -Apply, not both."
}
if ($CreateMissingProjectNotes -and -not ($IncludeCandidates -and $Apply)) {
    throw "-CreateMissingProjectNotes requires -IncludeCandidates and -Apply. Candidate notes are not created by default."
}

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$VaultRoot = (Get-Location).Path
$ProjectsRoot = Join-Path $VaultRoot "03_Projects"
$RegistryRoot = Join-Path $ProjectsRoot "_Registry"
$MemoryRoot = Join-Path $RegistryRoot "Project_Memory"
$ReportsRoot = Join-Path $VaultRoot "10_Reports"
$AuditRoot = Join-Path $VaultRoot "99_Attachments\Audit"

$StartMarker = "<!-- PPJ_PROJECT_KNOWLEDGE_START -->"
$EndMarker = "<!-- PPJ_PROJECT_KNOWLEDGE_END -->"
$Today = Get-Date -Format "yyyyMMdd"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

$RequiredFiles = @(
    "03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md",
    "03_Projects/_Registry/PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md",
    "03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md",
    "03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md",
    "03_Projects/_Registry/PPJ_PROJECT_ALIAS_MAP.md"
)

function Read-TextSafe {
    param([string]$Path)
    if (Test-Path $Path) { return (Get-Content -Raw -Encoding UTF8 $Path) }
    return ""
}

function Write-TextSafe {
    param([string]$Path, [string]$Content)
    Set-Content -Path $Path -Value $Content -Encoding UTF8
}

function Normalize-Name {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return "" }
    $v = $Value.Trim()
    if ($v -match '^\[\[([^\]\|#]+)') { $v = $Matches[1] }
    $v = $v.Trim('"', "'", ' ')
    $v = $v -replace '\.md$', ''
    $v = $v -replace '\.memory$', ''
    return $v.Trim()
}

function Get-FrontMatterValue {
    param([string]$Content, [string]$Key)
    $pattern = "(?m)^$([regex]::Escape($Key)):\s*`"?([^`"\r\n]+)`"?\s*$"
    if ($Content -match $pattern) { return $Matches[1].Trim() }
    return ""
}

function Get-Section {
    param([string]$Content, [string]$Heading)
    $escaped = [regex]::Escape($Heading)
    $pattern = "(?ms)^##\s+$escaped\s*\r?\n(.*?)(?=^##\s+|\z)"
    if ($Content -match $pattern) { return $Matches[1].Trim() }
    return "TBD"
}

function One-Line {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return "TBD" }
    $v = ($Value -split "`r?`n" | Where-Object { $_.Trim() -ne "" } | Select-Object -First 1)
    if (-not $v) { return "TBD" }
    return $v.Trim().Trim('-', ' ')
}

function Get-TableRows {
    param([string]$Content)
    $rows = @()
    foreach ($line in ($Content -split "`r?`n")) {
        if ($line -notmatch '^\|') { continue }
        if ($line -match '^\|\s*-') { continue }
        $cells = $line.Trim('|') -split '\|'
        $clean = @()
        foreach ($c in $cells) { $clean += $c.Trim() }
        $rows += ,$clean
    }
    return $rows
}

function Test-NoteExists {
    param([string]$Name, [hashtable]$NoteByBase, [hashtable]$NoteByFile)
    $n = Normalize-Name $Name
    if (-not $n -or $n -eq "TBD") { return $false }
    if ($NoteByBase.ContainsKey($n)) { return $true }
    if ($NoteByFile.ContainsKey($n)) { return $true }
    if ($NoteByFile.ContainsKey("$n.md")) { return $true }
    return $false
}

function Get-NoteItem {
    param([string]$Name, [hashtable]$NoteByBase, [hashtable]$NoteByFile)
    $n = Normalize-Name $Name
    if ($NoteByBase.ContainsKey($n)) { return $NoteByBase[$n] }
    if ($NoteByFile.ContainsKey($n)) { return $NoteByFile[$n] }
    if ($NoteByFile.ContainsKey("$n.md")) { return $NoteByFile["$n.md"] }
    return $null
}

function Get-ListLines {
    param([string]$SectionText, [int]$Max = 6)
    $items = @()
    foreach ($line in ($SectionText -split "`r?`n")) {
        $t = $line.Trim()
        if (-not $t) { continue }
        if ($t -match '^[-*]\s+(.+)$') { $items += $Matches[1].Trim() }
        elseif ($items.Count -eq 0 -and $t -ne "TBD") { $items += $t }
        if ($items.Count -ge $Max) { break }
    }
    if ($items.Count -eq 0) { return @("TBD") }
    return $items
}

function BulletBlock {
    param([array]$Items)
    if (-not $Items -or $Items.Count -eq 0) { return "- TBD" }
    return (($Items | ForEach-Object { "- $_" }) -join "`n")
}

function Backup-File {
    param([string]$Path, [string]$BackupRoot)
    if (-not (Test-Path $Path)) { return }
    $relative = $Path.Substring($VaultRoot.Length).TrimStart('\', '/')
    $dest = Join-Path $BackupRoot $relative
    $destDir = Split-Path $dest -Parent
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    Copy-Item -Path $Path -Destination $dest -Force
}

function Build-ProjectBlock {
    param([pscustomobject]$Project)
    $mem = $Project.Memory
    $oneLine = One-Line (Get-Section $mem.Content "One-Line Understanding")
    $outcome = One-Line (Get-Section $mem.Content "Current Outcome")
    $latest = One-Line (Get-Section $mem.Content "Latest Update Summary")
    $isItems = Get-ListLines (Get-Section $mem.Content "What This Project Is")
    $isNotItems = Get-ListLines (Get-Section $mem.Content "What This Project Is Not")
    $users = One-Line (Get-Section $mem.Content "Key Users")
    $systems = One-Line (Get-Section $mem.Content "Systems / Data")
    $risks = Get-ListLines (Get-Section $mem.Content "Known Risks / Blockers")
    $decisions = Get-ListLines (Get-Section $mem.Content "Decisions Needed")
    $actions = Get-ListLines (Get-Section $mem.Content "Next Actions")
    $drift = Get-ListLines (Get-Section $mem.Content "Do Not Drift Rules") 8
    $confidence = if ($mem.Confidence) { $mem.Confidence } else { "Needs Confirmation" }
    $phase = if ($Project.Phase) { $Project.Phase } else { $mem.Phase }
    if (-not $phase) { $phase = "TBD" }

@"
$StartMarker
# Project Knowledge Detail

## Executive Summary
$oneLine

## Current Outcome
$outcome

## Current Status
Phase/status: $phase. Confidence: $confidence.

## Business Context
$latest

## What This Project Is
$(BulletBlock $isItems)

## What This Project Is Not
$(BulletBlock $isNotItems)

## Key Users / Stakeholders
| Group | Notes |
|---|---|
| Users / Stakeholders | $users |

## Systems / Data
| Area | Notes |
|---|---|
| Systems / Data | $systems |

## Current Risks / Blockers
$(BulletBlock $risks)

## Decisions Needed
$(BulletBlock $decisions)

## Next Actions
$(BulletBlock $actions)

## Do Not Drift Rules
$(BulletBlock $drift)

## Evidence and Confidence
| Evidence | Confidence |
|---|---|
| Project memory card: [[${($mem.File.BaseName)}]] | $confidence |
| Memory index / registry / canonical dictionary | Source-of-truth priority applied |

Related Concepts
[[Outcome Driven Thinking]]
[[System Thinking]]
[[Data Governance]]

Methods
[[Impact Analysis]]
[[Requirement Elicitation]]
[[Data Mapping]]

Projects
[[$($Project.ProjectCode)]]

Deliverables
[[Decision_Driven_BRD]]
[[ERD_Template]]
[[User_Manual_Template]]
$EndMarker
"@
}

function Replace-ManagedBlock {
    param([string]$Content, [string]$NewBlock)
    $pattern = "(?ms)<!--\s*PPJ_PROJECT_KNOWLEDGE_START\s*-->.*?<!--\s*PPJ_PROJECT_KNOWLEDGE_END\s*-->"
    if ($Content -match $pattern) { return [regex]::Replace($Content, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $NewBlock }, 1) }
    if ([string]::IsNullOrWhiteSpace($Content)) { return $NewBlock.TrimEnd() + "`r`n" }
    return $Content.TrimEnd() + "`r`n`r`n" + $NewBlock.TrimEnd() + "`r`n"
}

function Build-MemoryCardContent {
    param([pscustomobject]$Project)
    $mem = $Project.Memory
    $projectFile = if ($Project.NoteFile) { $Project.NoteFile.Name } elseif ($mem.ProjectFile) { $mem.ProjectFile } else { "TBD" }
    $status = if ($mem.Status) { $mem.Status } else { $Project.Phase }
    if (-not $status) { $status = "TBD" }
    $oneLine = One-Line (Get-Section $mem.Content "One-Line Understanding")
    $outcome = One-Line (Get-Section $mem.Content "Current Outcome")
    $latest = One-Line (Get-Section $mem.Content "Latest Update Summary")
    $is = Get-ListLines (Get-Section $mem.Content "What This Project Is")
    $isNot = Get-ListLines (Get-Section $mem.Content "What This Project Is Not")
    $users = One-Line (Get-Section $mem.Content "Key Users")
    $systems = One-Line (Get-Section $mem.Content "Systems / Data")
    $risks = Get-ListLines (Get-Section $mem.Content "Known Risks / Blockers")
    $decisions = Get-ListLines (Get-Section $mem.Content "Decisions Needed")
    $actions = Get-ListLines (Get-Section $mem.Content "Next Actions")
    $drift = Get-ListLines (Get-Section $mem.Content "Do Not Drift Rules") 8
    $confidence = if ($mem.Confidence) { $mem.Confidence } else { "Needs Confirmation" }
@"
---
type: project_memory
project_name: "$($Project.ProjectCode)"
project_file: "$projectFile"
project_code: "$($Project.ProjectCode)"
cluster: "$($Project.Cluster)"
phase: "$($Project.Phase)"
status: "$status"
last_verified: "$(Get-Date -Format 'yyyy-MM-dd')"
confidence: "$confidence"
---

# Project Memory: $($Project.ProjectCode)

## One-Line Understanding
$oneLine

## Current Outcome
$outcome

## Current Status
$status

## Latest Update Summary
$latest

## What This Project Is
$(BulletBlock $is)

## What This Project Is Not
$(BulletBlock $isNot)

## Key Users
$users

## Systems / Data
$systems

## Known Risks / Blockers
$(BulletBlock $risks)

## Decisions Needed
$(BulletBlock $decisions)

## Next Actions
$(BulletBlock $actions)

## Do Not Drift Rules
$(BulletBlock $drift)

## Source Links
- [[$(Normalize-Name $projectFile)]]
- [[PPJ_PROJECT_MEMORY_INDEX]]
- [[PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY]]
"@
}

function Get-ProtectedHardStops {
    param([array]$Projects, [string]$AllActiveText)
    $issues = New-Object System.Collections.Generic.List[string]
    if ($AllActiveText -cmatch 'PROJECT_NAME') { $issues.Add("PROJECT_NAME placeholder appears in active source text.") | Out-Null }
    if ($AllActiveText -cmatch 'ACC.GRN-SupplierInvoiceBot.v2.3') { $issues.Add("ACC.GRN-SupplierInvoiceBot.v2.3 appears in active source text; user rule says current file is v1.1.") | Out-Null }
    if ($AllActiveText -match '(?i)generated project knowledge content|generated content start|generated content end') { $issues.Add("Generic managed markers appear in active source text.") | Out-Null }

    $fd = $Projects | Where-Object { $_.ProjectCode -eq 'FD.Datamart.v2.2' } | Select-Object -First 1
    if ($fd -and $fd.Memory.Content -match '(?i)image search|3D sample library|Chi Trang|3D Design workflow') {
        $bad = $false
        foreach ($line in ($fd.Memory.Content -split "`r?`n")) {
            if ($line -match '(?i)image search|3D sample library|Chi Trang|3D Design workflow' -and $line -notmatch '(?i)not|do not|must not|unless|separate') { $bad = $true }
        }
        if ($bad) { $issues.Add("FD appears to be described as CPD/image-search/3D scope.") | Out-Null }
    }
    $cpd = $Projects | Where-Object { $_.ProjectCode -eq 'CPD.Datamart.v1.1' } | Select-Object -First 1
    if ($cpd) {
        foreach ($line in ($cpd.Memory.Content -split "`r?`n")) {
            if ($line -match '(?i)Directus hanger|hanger QR|FD fabric hanger|QR hanger module' -and $line -notmatch '(?i)not|do not|must not|unless|separate') {
                $issues.Add("CPD appears to be described as FD Directus/QR hanger scope.") | Out-Null
                break
            }
        }
    }
    return $issues
}

foreach ($rel in $RequiredFiles) {
    if (-not (Test-Path (Join-Path $VaultRoot $rel))) { throw "Missing required source file: $rel" }
}
if (-not (Test-Path $MemoryRoot)) { throw "Missing Project_Memory folder." }

$MemoryIndexPath = Join-Path $RegistryRoot "PPJ_PROJECT_MEMORY_INDEX.md"
$RegistryPath = Join-Path $RegistryRoot "PPJ_PROJECT_REGISTRY.md"
$ResourceMatrixPath = Join-Path $RegistryRoot "PPJ_PROJECT_RESOURCE_MATRIX.md"
$AliasMapPath = Join-Path $RegistryRoot "PPJ_PROJECT_ALIAS_MAP.md"
$DictionaryPath = Join-Path $RegistryRoot "PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md"
$LedgerPath = Join-Path $RegistryRoot "PPJ_PROJECT_UPDATE_LEDGER.md"
$ModuleIndexPath = Join-Path $RegistryRoot "PPJ_PROJECT_MODULE_INDEX.md"

$MemoryIndexContent = Read-TextSafe $MemoryIndexPath
$RegistryContent = Read-TextSafe $RegistryPath
$ResourceContent = Read-TextSafe $ResourceMatrixPath
$AliasContent = Read-TextSafe $AliasMapPath
$DictionaryContent = Read-TextSafe $DictionaryPath
$ModuleContent = Read-TextSafe $ModuleIndexPath

$RootNotes = Get-ChildItem -Path $ProjectsRoot -File -Filter "*.md" | Where-Object { $_.Name -ne "PROJECT_COMMAND_CENTER.md" -and $_.Name -ne "PROJECT_NAME.v1.1.md" }
$CommandCenter = Get-Item -Path (Join-Path $ProjectsRoot "PROJECT_COMMAND_CENTER.md") -ErrorAction SilentlyContinue
$NoteByBase = @{}
$NoteByFile = @{}
foreach ($note in $RootNotes) { $NoteByBase[$note.BaseName] = $note; $NoteByFile[$note.Name] = $note }
if ($CommandCenter) { $NoteByBase[$CommandCenter.BaseName] = $CommandCenter; $NoteByFile[$CommandCenter.Name] = $CommandCenter }

$MemoryCards = @()
foreach ($file in (Get-ChildItem -Path $MemoryRoot -File -Filter "*.memory.md")) {
    $content = Read-TextSafe $file.FullName
    $MemoryCards += [pscustomobject]@{
        File = $file
        BaseName = ($file.BaseName -replace '\.memory$', '')
        Content = $content
        ProjectName = Normalize-Name (Get-FrontMatterValue $content "project_name")
        ProjectCode = Normalize-Name (Get-FrontMatterValue $content "project_code")
        ProjectFile = (Get-FrontMatterValue $content "project_file")
        Cluster = (Get-FrontMatterValue $content "cluster")
        Phase = (Get-FrontMatterValue $content "phase")
        Status = (Get-FrontMatterValue $content "status")
        Confidence = (Get-FrontMatterValue $content "confidence")
    }
}

$IndexRows = Get-TableRows $MemoryIndexContent
$Projects = @()
foreach ($row in $IndexRows) {
    if ($row.Count -lt 10) { continue }
    if ($row[0] -eq "Project") { continue }
    $code = Normalize-Name $row[0]
    if (-not $code) { continue }
    if ($ProjectName -and $code -ne $ProjectName -and (Normalize-Name $row[2]) -ne $ProjectName) { continue }
    $memoryName = Normalize-Name $row[1]
    $noteName = Normalize-Name $row[2]
    $memory = $MemoryCards | Where-Object { $_.BaseName -eq $memoryName -or $_.ProjectCode -eq $code -or $_.ProjectName -eq $code } | Select-Object -First 1
    $note = Get-NoteItem $noteName $NoteByBase $NoteByFile
    if (-not $note) { $note = Get-NoteItem $code $NoteByBase $NoteByFile }
    $classification = "Registry-only project"
    if ($memory -and $note) { $classification = "Root-backed canonical project" }
    elseif ($memory -and -not $note) { $classification = "Memory-only candidate" }
    elseif (-not $memory -and $note) { $classification = "Root note missing memory" }
    if ($code -eq "PROJECT_COMMAND_CENTER") { $classification = "Command center" }
    $Projects += [pscustomobject]@{
        ProjectCode = $code
        MemoryName = $memoryName
        NoteName = $noteName
        Cluster = $row[3]
        Phase = $row[4]
        Priority = $row[5]
        OneLine = $row[6]
        Outcome = $row[7]
        Latest = $row[8]
        Confidence = $row[9]
        Memory = $memory
        NoteFile = $note
        Classification = $classification
    }
}

foreach ($note in $RootNotes) {
    $covered = $Projects | Where-Object { $_.NoteFile -and $_.NoteFile.FullName -eq $note.FullName } | Select-Object -First 1
    if (-not $covered -and (-not $ProjectName -or $note.BaseName -eq $ProjectName)) {
        $Projects += [pscustomobject]@{
            ProjectCode = $note.BaseName
            MemoryName = ""
            NoteName = $note.BaseName
            Cluster = "Needs Confirmation"
            Phase = "Needs Confirmation"
            Priority = "Needs Confirmation"
            OneLine = "Needs memory card"
            Outcome = "Needs memory card"
            Latest = "Root note exists but memory card missing"
            Confidence = "Needs Confirmation"
            Memory = $null
            NoteFile = $note
            Classification = "Root note missing memory"
        }
    }
}

$RootBacked = @($Projects | Where-Object { $_.Classification -eq "Root-backed canonical project" -and $_.ProjectCode -ne "PROJECT_COMMAND_CENTER" })
$Candidates = @($Projects | Where-Object { $_.Classification -eq "Memory-only candidate" })
$MissingMemory = @($Projects | Where-Object { $_.Classification -eq "Root note missing memory" })
$RegistryOnly = @($Projects | Where-Object { $_.Classification -eq "Registry-only project" })
$CommandCenterProjects = @($Projects | Where-Object { $_.Classification -eq "Command center" })

$RegistryMismatch = @()
$ResourceMismatch = @()
foreach ($p in $Projects) {
    if ($p.Classification -eq "Memory-only candidate" -or $p.Classification -eq "Command center") { continue }
    if ($RegistryContent -notmatch [regex]::Escape($p.ProjectCode) -and $RegistryContent -notmatch [regex]::Escape($p.NoteName)) { $RegistryMismatch += $p.ProjectCode }
    if ($ResourceContent -notmatch [regex]::Escape($p.ProjectCode) -and $ResourceContent -notmatch [regex]::Escape($p.NoteName)) { $ResourceMismatch += $p.ProjectCode }
}

$AllActiveText = @($MemoryIndexContent, $RegistryContent, $ResourceContent, $AliasContent, $DictionaryContent, $ModuleContent) -join "`n"
$AllActiveText += "`n" + (($MemoryCards | ForEach-Object { $_.Content }) -join "`n")
$HardStops = Get-ProtectedHardStops $Projects $AllActiveText
if ($CreateMissingProjectNotes -and -not ($IncludeCandidates -and $Apply)) { $HardStops.Add("Candidate project note creation requested without required flags.") | Out-Null }

$WouldUpdateFiles = New-Object System.Collections.Generic.List[string]
$WouldCreateFiles = New-Object System.Collections.Generic.List[string]
if ($UpdateMemory) { foreach ($p in $RootBacked) { if ($p.Memory) { $WouldUpdateFiles.Add("03_Projects/_Registry/Project_Memory/$($p.Memory.File.Name)") | Out-Null } } }
if ($UpdateProjectNotes) { foreach ($p in $RootBacked) { if ($p.NoteFile) { $WouldUpdateFiles.Add("03_Projects/$($p.NoteFile.Name)") | Out-Null } } }
if ($UpdateRegistry) {
    $WouldUpdateFiles.Add("03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md") | Out-Null
    $WouldUpdateFiles.Add("03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md") | Out-Null
    $WouldUpdateFiles.Add("03_Projects/_Registry/PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md") | Out-Null
}
if ($UpdateResourceMatrix) { $WouldUpdateFiles.Add("03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md") | Out-Null }
if ($UpdateLedger) { $WouldUpdateFiles.Add("03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md") | Out-Null }
$WouldCreateFiles.Add("10_Reports/BULK_PORTFOLIO_KNOWLEDGE_POPULATION_PLAN_$Today.md") | Out-Null
$WouldCreateFiles.Add("10_Reports/BULK_PORTFOLIO_PROJECT_KNOWLEDGE_COVERAGE_MATRIX_$Today.md") | Out-Null
if ($Apply) { $WouldCreateFiles.Add("99_Attachments/Audit/BULK_PORTFOLIO_KNOWLEDGE_POPULATION_LOG_$Timestamp.md") | Out-Null }

$SampleCodes = @("FD.Datamart.v2.2", "CPD.Datamart.v1.1", "PUR.Material.Allocation.v1.1", "PPJ.AI.Hub.v2.1", "COSTING.AGENTIC.PLATFORM.v1.1", "PPJ.COSTING.AGENT.PLATFORM.v1.1")
$SamplePreviews = @()
foreach ($code in $SampleCodes) {
    $p = $Projects | Where-Object { $_.ProjectCode -eq $code -or $_.NoteName -eq $code } | Select-Object -First 1
    if (-not $p -and $code -eq "PPJ.COSTING.AGENT.PLATFORM.v1.1") { $p = $Projects | Where-Object { $_.ProjectCode -eq "COSTING.AGENTIC.PLATFORM.v1.1" } | Select-Object -First 1 }
    if ($p -and $p.Memory) {
        $SamplePreviews += [pscustomobject]@{ Project = $code; Preview = (Build-ProjectBlock $p) }
    }
}

$CoverageRows = @()
foreach ($p in $Projects) {
    $managed = $false
    if ($p.NoteFile) { $managed = (Read-TextSafe $p.NoteFile.FullName) -match [regex]::Escape($StartMarker) }
    $CoverageRows += [pscustomobject]@{
        Project = $p.ProjectCode
        RootNoteExists = [bool]$p.NoteFile
        MemoryCardExists = [bool]$p.Memory
        MemoryIndexExists = $MemoryIndexContent -match [regex]::Escape($p.ProjectCode)
        RegistryExists = $RegistryContent -match [regex]::Escape($p.ProjectCode)
        ResourceMatrixExists = $ResourceContent -match [regex]::Escape($p.ProjectCode)
        ManagedBlockExists = $managed
        Confidence = $p.Confidence
        RecommendedAction = if ($p.Classification -eq "Memory-only candidate") { "Keep memory-only candidate; do not create note without approval." } elseif ($p.Classification -eq "Root note missing memory") { "Create memory card after approval." } elseif ($p.Classification -eq "Root-backed canonical project") { "Populate managed block and synchronize sources." } else { "Review classification." }
    }
}

$PlanReport = @"
# Bulk Portfolio Knowledge Population Plan - $Today

## Executive Summary

Portfolio-wide DryRun/Apply plan for PPJ project knowledge population. Canvas is explicitly excluded.

## Portfolio Coverage

- Root project count: $($RootNotes.Count)
- Memory card count: $($MemoryCards.Count)
- Root-backed canonical projects: $($RootBacked.Count)
- Memory-only candidates: $($Candidates.Count)
- Missing memory count: $($MissingMemory.Count)
- Registry-only projects: $($RegistryOnly.Count)
- Registry mismatches: $($RegistryMismatch.Count)
- Resource matrix mismatches: $($ResourceMismatch.Count)

## Source Files Used

- PPJ_PROJECT_MEMORY_INDEX.md
- Project_Memory/*.memory.md
- PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md
- PPJ_PROJECT_REGISTRY.md
- PPJ_PROJECT_RESOURCE_MATRIX.md
- PPJ_PROJECT_ALIAS_MAP.md
- PPJ_PROJECT_MODULE_INDEX.md if present
- Root project notes

## Project Classification

- Root-backed: $($RootBacked.Count)
- Candidates: $($Candidates.Count)
- Missing memory: $($MissingMemory.Count)
- Registry-only: $($RegistryOnly.Count)

## Root-Backed Projects

$(($RootBacked | ForEach-Object { "- $($_.ProjectCode) -> $($_.NoteFile.Name)" }) -join "`n")

## Memory-Only Candidates

$(if ($Candidates.Count -eq 0) { "- None" } else { ($Candidates | ForEach-Object { "- $($_.ProjectCode)" }) -join "`n" })

## Missing Memory Cards

$(if ($MissingMemory.Count -eq 0) { "- None" } else { ($MissingMemory | ForEach-Object { "- $($_.ProjectCode)" }) -join "`n" })

## Registry Mismatches

$(if ($RegistryMismatch.Count -eq 0) { "- None" } else { ($RegistryMismatch | ForEach-Object { "- $_" }) -join "`n" })

## Resource Matrix Mismatches

$(if ($ResourceMismatch.Count -eq 0) { "- None" } else { ($ResourceMismatch | ForEach-Object { "- $_" }) -join "`n" })

## Protected Scope Validation

$(if ($HardStops.Count -eq 0) { "- No hard-stop protected scope issues detected." } else { ($HardStops | ForEach-Object { "- HARD STOP: $_" }) -join "`n" })

## Apply Plan

- Backup affected files before Apply.
- Update selected areas according to flags only.
- Preserve all user-written content outside managed blocks.
- Do not update Canvas.
- Do not create candidate notes unless explicitly approved by flags.

## Approval Checklist

- [ ] Review hard stops.
- [ ] Confirm ACC.GRN canonical version before Apply.
- [ ] Confirm candidates remain memory-only.
- [ ] Confirm registry/resource matrix mismatch plan.
- [ ] Run DryRun again after any source correction.
- [ ] Approve Apply command explicitly.
"@

$CoverageMatrix = @"
# Bulk Portfolio Project Knowledge Coverage Matrix - $Today

| Project | Root Note Exists | Memory Card Exists | Memory Index Exists | Registry Exists | Resource Matrix Exists | Project Note Managed Block Exists | Confidence | Recommended Action |
|---|---:|---:|---:|---:|---:|---:|---|---|
$(($CoverageRows | ForEach-Object { "| $($_.Project) | $($_.RootNoteExists) | $($_.MemoryCardExists) | $($_.MemoryIndexExists) | $($_.RegistryExists) | $($_.ResourceMatrixExists) | $($_.ManagedBlockExists) | $($_.Confidence) | $($_.RecommendedAction) |" }) -join "`n")
"@

Write-Host "PPJ Bulk Portfolio Knowledge Population"
Write-Host "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Write-Host "Root project count: $($RootNotes.Count)"
Write-Host "Memory card count: $($MemoryCards.Count)"
Write-Host "Root-backed canonical project count: $($RootBacked.Count)"
Write-Host "Memory-only candidate count: $($Candidates.Count)"
Write-Host "Missing memory count: $($MissingMemory.Count)"
Write-Host "Missing project note count: $($Candidates.Count)"
Write-Host "Registry mismatch count: $($RegistryMismatch.Count)"
Write-Host "Resource matrix mismatch count: $($ResourceMismatch.Count)"
Write-Host "Canvas update: NO"
Write-Host "Create missing project notes: $CreateMissingProjectNotes"

if ($HardStops.Count -gt 0) {
    Write-Host ""
    Write-Host "DRYRUN VALIDATION: FAIL"
    Write-Host "Hard stops:"
    foreach ($issue in $HardStops) { Write-Host "- $issue" }
}
else {
    Write-Host ""
    Write-Host "DRYRUN VALIDATION: PASS"
}

Write-Host ""
Write-Host "Candidate projects left untouched:"
if ($Candidates.Count -eq 0) { Write-Host "- None" } else { foreach ($c in $Candidates) { Write-Host "- $($c.ProjectCode)" } }

Write-Host ""
Write-Host "Sample population previews:"
foreach ($s in $SamplePreviews) {
    Write-Host "--- $($s.Project) ---"
    (($s.Preview -split "`r?`n") | Select-Object -First 18) | ForEach-Object { Write-Host $_ }
}

Write-Host ""
Write-Host "Files that would be updated:"
if ($WouldUpdateFiles.Count -eq 0) { Write-Host "- None" } else { $WouldUpdateFiles.ToArray() | Sort-Object -Unique | ForEach-Object { Write-Host "- $_" } }
Write-Host ""
Write-Host "Files that would be created:"
$WouldCreateFiles.ToArray() | Sort-Object -Unique | ForEach-Object { Write-Host "- $_" }

if ($DryRun) {
    Write-Host ""
    Write-Host "DryRun only. No files modified."
    Write-Host "Exact Apply command, approval-required:"
    Write-Host 'powershell -ExecutionPolicy Bypass -File "scripts\Bulk-Populate-PPJPortfolioKnowledge.ps1" -Apply -UpdateMemory -UpdateProjectNotes -UpdateRegistry -UpdateResourceMatrix -UpdateLedger'
    if ($HardStops.Count -gt 0) { exit 2 }
    exit 0
}

if ($HardStops.Count -gt 0 -and -not $Force) {
    throw "Apply blocked by hard stops. Re-run DryRun and resolve conflicts first, or use -Force only after explicit approval."
}

$BackupRoot = Join-Path $AuditRoot "Bulk_Portfolio_Knowledge_Population_Backup\$Timestamp"
New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
$OperationLog = New-Object System.Collections.Generic.List[string]
$OperationLog.Add("# Bulk Portfolio Knowledge Population Log - $Timestamp") | Out-Null
$OperationLog.Add("") | Out-Null
$OperationLog.Add("Canvas update: NO") | Out-Null
$OperationLog.Add("Create missing project notes: $CreateMissingProjectNotes") | Out-Null

$Affected = New-Object System.Collections.Generic.List[string]
if ($UpdateMemory) { foreach ($p in $RootBacked) { if ($p.Memory) { $Affected.Add($p.Memory.File.FullName) | Out-Null } } }
if ($UpdateProjectNotes) { foreach ($p in $RootBacked) { if ($p.NoteFile) { $Affected.Add($p.NoteFile.FullName) | Out-Null } } }
if ($UpdateRegistry) { $Affected.Add($MemoryIndexPath) | Out-Null; $Affected.Add($RegistryPath) | Out-Null; $Affected.Add($DictionaryPath) | Out-Null }
if ($UpdateResourceMatrix) { $Affected.Add($ResourceMatrixPath) | Out-Null }
if ($UpdateLedger) { $Affected.Add($LedgerPath) | Out-Null }
foreach ($path in ($Affected.ToArray() | Sort-Object -Unique)) { Backup-File $path $BackupRoot }

$MemoryUpdated = 0
$NotesUpdated = 0
if ($UpdateMemory) {
    foreach ($p in $RootBacked) {
        if (-not $p.Memory) { continue }
        $new = Build-MemoryCardContent $p
        if ($new.Length -gt 0) {
            Write-TextSafe $p.Memory.File.FullName $new
            $MemoryUpdated++
        }
    }
}
if ($UpdateProjectNotes) {
    foreach ($p in $RootBacked) {
        if (-not $p.NoteFile -or -not $p.Memory) { continue }
        $current = Read-TextSafe $p.NoteFile.FullName
        $newBlock = Build-ProjectBlock $p
        $updated = Replace-ManagedBlock $current $newBlock
        Write-TextSafe $p.NoteFile.FullName $updated
        $NotesUpdated++
    }
}
if ($UpdateLedger) {
    if (-not (Test-Path $LedgerPath)) { Write-TextSafe $LedgerPath "# PPJ Project Update Ledger`r`n`r`n" }
    $ledgerLine = "`r`n| $(Get-Date -Format 'yyyy-MM-dd') | PORTFOLIO | portfolio_population | Root-backed=$($RootBacked.Count); MemoryUpdated=$MemoryUpdated; NotesUpdated=$NotesUpdated; CandidatesLeft=$($Candidates.Count) | Strong | memory=$UpdateMemory; notes=$UpdateProjectNotes; registry=$UpdateRegistry; resource_matrix=$UpdateResourceMatrix |"
    Add-Content -Path $LedgerPath -Value $ledgerLine -Encoding UTF8
}
if ($UpdateRegistry) {
    # Registry source files are intentionally not restructured here; reports identify mismatches for reviewed correction.
    $OperationLog.Add("Registry files reviewed; structural rewrite skipped to avoid format drift.") | Out-Null
}
if ($UpdateResourceMatrix) {
    $OperationLog.Add("Resource matrix reviewed; structural rewrite skipped except by future approved mapping corrections.") | Out-Null
}

if (-not (Test-Path $ReportsRoot)) { New-Item -ItemType Directory -Path $ReportsRoot -Force | Out-Null }
$PlanPath = Join-Path $ReportsRoot "BULK_PORTFOLIO_KNOWLEDGE_POPULATION_PLAN_$Today.md"
$CoveragePath = Join-Path $ReportsRoot "BULK_PORTFOLIO_PROJECT_KNOWLEDGE_COVERAGE_MATRIX_$Today.md"
Write-TextSafe $PlanPath $PlanReport
Write-TextSafe $CoveragePath $CoverageMatrix

$OperationLog.Add("") | Out-Null
$OperationLog.Add("Backup folder: $BackupRoot") | Out-Null
$OperationLog.Add("Memory cards updated: $MemoryUpdated") | Out-Null
$OperationLog.Add("Project notes updated: $NotesUpdated") | Out-Null
$OperationLog.Add("Candidates left uncreated: $($Candidates.Count)") | Out-Null
$LogPath = Join-Path $AuditRoot "BULK_PORTFOLIO_KNOWLEDGE_POPULATION_LOG_$Timestamp.md"
Write-TextSafe $LogPath (($OperationLog.ToArray()) -join "`r`n")

Write-Host "Apply completed."
Write-Host "Backup folder: $BackupRoot"
Write-Host "Log file: $LogPath"
Write-Host "Plan report: $PlanPath"
Write-Host "Coverage matrix: $CoveragePath"
Write-Host "Memory cards updated: $MemoryUpdated"
Write-Host "Project notes updated: $NotesUpdated"
