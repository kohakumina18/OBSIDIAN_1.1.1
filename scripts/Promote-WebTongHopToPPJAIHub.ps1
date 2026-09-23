param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

if (-not $Apply) {
    $DryRun = $true
}

$vaultRoot = (Get-Location).Path
$projectRoot = Join-Path $vaultRoot "03_Projects"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$dateStamp = Get-Date -Format "yyyyMMdd"
$backupRoot = Join-Path $auditRoot "PPJ_AI_Hub_Promotion_Backup\$stamp"
$logPath = Join-Path $auditRoot "PPJ_AI_HUB_PROMOTION_LOG_$stamp.md"
$reportPath = Join-Path $vaultRoot "10_Reports\PPJ_AI_HUB_PROMOTION_REPORT_$dateStamp.md"

$canonicalFile = "PPJ.AI.Hub.md"
$webTongAsciiFile = "Web Tong Hop Tool.md"
$webTongVnName = ("Web T{0}ng H{1}p Tool" -f [char]0x1ED5, [char]0x1EE3)
$webTongVnFile = "$webTongVnName.md"
$oldFiles = @($webTongAsciiFile, $webTongVnFile)
$oldNames = @("Web Tong Hop Tool", $webTongVnName)
$registryPath = Join-Path $projectRoot "_Registry\PPJ_PROJECT_REGISTRY.md"
$aliasMapPath = Join-Path $projectRoot "_Registry\PPJ_PROJECT_ALIAS_MAP.md"

$activeMarkdownRoots = @(
    "01_Daily_Notes",
    "02_BA_Knowledge",
    "03_Projects",
    "04_Data_Dictionary",
    "05_Process_Library",
    "06_AI_Automation",
    "07_Decision_Log",
    "08_Meeting_Notes",
    "09_Stakeholders",
    "10_Deliverables",
    "11_Templates"
)

$activeCanvasFiles = @(
    "03_Projects\Canvas\PPJ_Executive_Board.canvas",
    "03_Projects\Canvas\PPJ_Portfolio.canvas",
    "03_Projects\Canvas\PPJ_Data_Flow.canvas",
    "03_Projects\Canvas\PPJ_Roadmap_2026.canvas"
)

function Read-Utf8 {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return "" }
    return Get-Content -Raw -Encoding UTF8 $Path
}

function Write-Utf8 {
    param([string]$Path, [string]$Text)
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $Text | Set-Content -Encoding UTF8 $Path
}

function Get-RelativePath {
    param([string]$Path)
    return (Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\')
}

function Get-BaseName {
    param([string]$FileName)
    return [System.IO.Path]::GetFileNameWithoutExtension($FileName)
}

function Test-InActiveMarkdownRoot {
    param([string]$RelativePath)
    foreach ($root in $activeMarkdownRoots) {
        if ($RelativePath -eq $root -or $RelativePath.StartsWith($root + "\")) { return $true }
    }
    return $false
}

function Test-ExcludedMarkdownPath {
    param([string]$RelativePath)
    if ($RelativePath -match '(?i)(^|\\)10_Reports(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)99_Attachments(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)\.obsidian(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)\.git(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)(backup|backups|audit|logs?|PPJ_AI_Hub_Promotion_Backup|Project_Cleanup_Backup|Project_Folder_Hygiene_Backup|Alias_Reference_Backup|Approved_Duplicate_Backup)(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(log|audit|backup|report).*\.md$') { return $true }
    if (-not (Test-InActiveMarkdownRoot $RelativePath)) { return $true }
    return $false
}

function Get-FileClassification {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return "Missing" }
    $file = Get-Item $Path
    $text = Read-Utf8 $Path
    if ($text -match '(?im)^type\s*:\s*alias\s*$' -or $text -match '(?im)^status\s*:\s*"?alias"?\s*$') { return "Alias" }
    if ($file.Length -le 20 -or [string]::IsNullOrWhiteSpace($text)) { return "Tiny Placeholder" }
    return "Non-empty"
}

function Get-Preview {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return "Missing" }
    $text = Read-Utf8 $Path
    if ([string]::IsNullOrWhiteSpace($text)) { return "Whitespace only" }
    $lines = $text -split "`r?`n"
    return (($lines | Select-Object -First 24) -join "`n")
}

function Get-ActiveMarkdownFiles {
    $files = @()
    foreach ($root in $activeMarkdownRoots) {
        $fullRoot = Join-Path $vaultRoot $root
        if (-not (Test-Path $fullRoot)) { continue }
        $files += @(Get-ChildItem -Path $fullRoot -Filter "*.md" -File -Recurse | Where-Object {
            $relative = $_.FullName.Substring($vaultRoot.Length).TrimStart('\')
            -not (Test-ExcludedMarkdownPath $relative)
        })
    }
    return @($files | Sort-Object FullName -Unique)
}

function Find-MarkdownLinkReferences {
    $refs = @()
    foreach ($file in (Get-ActiveMarkdownFiles)) {
        $relative = Get-RelativePath $file.FullName
        $lines = Get-Content -Encoding UTF8 $file.FullName
        for ($i = 0; $i -lt $lines.Count; $i++) {
            foreach ($oldName in $oldNames) {
                $escaped = [regex]::Escape($oldName)
                if ($lines[$i] -match "\[\[$escaped(\||\]\])") {
                    $refs += [pscustomobject]@{ File = $relative; Line = $i + 1; OldName = $oldName; Text = $lines[$i].Trim() }
                }
            }
        }
    }
    return $refs
}

function Find-CanvasFileNodeReferences {
    $refs = @()
    foreach ($relativeCanvas in $activeCanvasFiles) {
        $canvasPath = Join-Path $vaultRoot $relativeCanvas
        if (-not (Test-Path $canvasPath)) { continue }
        $raw = Read-Utf8 $canvasPath
        $json = $null
        try { $json = $raw | ConvertFrom-Json } catch { $json = $null }
        if ($null -eq $json) { continue }
        foreach ($node in @($json.nodes)) {
            if ($null -eq $node.file) { continue }
            foreach ($oldFile in $oldFiles) {
                $oldPath1 = "03_Projects/$oldFile"
                $oldPath2 = "03_Projects\$oldFile"
                if ($node.file -eq $oldPath1 -or $node.file -eq $oldPath2 -or $node.file -eq $oldFile) {
                    $refs += [pscustomobject]@{ Canvas = $relativeCanvas; NodeId = $node.id; OldFile = $node.file; NewFile = "03_Projects/$canonicalFile" }
                }
            }
        }
    }
    return $refs
}

function Replace-WikiLinksPreserveDisplay {
    param([string]$Text)
    $result = $Text
    foreach ($oldName in $oldNames) {
        $escaped = [regex]::Escape($oldName)
        $result = [regex]::Replace($result, "\[\[$escaped\]\]", "[[PPJ.AI.Hub]]")
        $result = [regex]::Replace($result, "\[\[$escaped\|([^\]]+)\]\]", {
            param($match)
            return "[[PPJ.AI.Hub|$($match.Groups[1].Value)]]"
        })
    }
    return $result
}

function Backup-File {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return }
    $relative = Get-RelativePath $Path
    $target = Join-Path $backupRoot $relative
    $targetDir = Split-Path $target -Parent
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item -Path $Path -Destination $target -Force
    $script:LogLines += "- Backup: $relative"
}

function Get-AIHubTemplate {
    return @'
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
- [[Accounting GRN Supplier Invoice Bot]]
- [[PUR.GDI Automation]]
- [[PUR.Material.Allocation.v1.1]]
- [[TD.TechnicalPlatform_v2.1]]

## Module Registry

| Module | Department | Owner | Phase | Access Point | Status |
|---|---|---|---|---|---|
| [[SCP.SOURCING.CHATBOT.v2.3]] | Sourcing | TBD | TBD | TBD | TBD |
| [[PPJ.PERRI.Chatbot]] | TBD | TBD | TBD | TBD | TBD |
| [[PPJ.GLPI-Helpdesk-AI Chatbot]] | IT / Helpdesk | TBD | TBD | TBD | TBD |
| [[PPJ.Invoice Downloader.v1.2]] | Accounting / EXIM | TBD | TBD | TBD | TBD |
| [[PPJ. Expense-Invoices.v1.1]] | EXIM / Accounting | TBD | TBD | TBD | TBD |
| [[Accounting GRN Supplier Invoice Bot]] | Accounting | TBD | TBD | TBD | TBD |
| [[PUR.GDI Automation]] | Purchasing | TBD | TBD | TBD | TBD |
| [[PUR.Material.Allocation.v1.1]] | Purchasing / Sourcing | TBD | TBD | TBD | TBD |
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
[[Accounting GRN Supplier Invoice Bot]]
[[PUR.GDI Automation]]
[[PUR.Material.Allocation.v1.1]]
[[TD.TechnicalPlatform_v2.1]]

## Deliverables

[[Decision_Driven_BRD]]
[[User_Manual_Template]]
[[System_Design_Template]]
'@
}

function Get-AliasNoteText {
    param([string]$PreviousScope)
    return @"
---
type: alias
canonical: "PPJ.AI.Hub"
canonical_file: "PPJ.AI.Hub.md"
status: "alias"
---

# Alias Note

Canonical Project:
[[PPJ.AI.Hub]]

Reason:
This old note is retained to preserve backlinks and historical context. The former Web Tong Hop Tool concept has been promoted into PPJ.AI.Hub, the central AI tools, bots, chatbot, and automation hub for the PPJ AI team.

Previous Scope:
$PreviousScope

Current Canonical Scope:
PPJ.AI.Hub

Related Concepts
[[Project Governance]]
[[Internal Tools Portal]]
[[AI Automation]]
[[Traceability]]

Methods
[[Impact Analysis]]
[[Requirement Validation]]
[[Platform Design]]
"@
}

function Merge-AIHubContent {
    param([string]$ExistingText, [object[]]$SourcePlans)
    $template = Get-AIHubTemplate
    $content = if ([string]::IsNullOrWhiteSpace($ExistingText)) { $template.TrimEnd() } else { $ExistingText.TrimEnd() }

    if ($content -notmatch '(?im)^## Source Notes Preserved\s*$') {
        $content += "`r`n`r`n## Source Notes Preserved`r`n`r`nTBD"
    }

    foreach ($source in $SourcePlans) {
        if (-not $source.Exists -or [string]::IsNullOrWhiteSpace($source.Text)) { continue }
        $base = Get-BaseName $source.FileName
        if ($content -like "*Source: [[$base]]*") { continue }
        $preservedBlock = @"

### Source: [[$base]]

Preserved On:
$(Get-Date -Format 'yyyy-MM-dd HH:mm')

```markdown
$($source.Text.Trim())
```
"@
        $content += $preservedBlock
    }

    return $content.TrimEnd() + "`r`n"
}

function Update-CanvasFileNodes {
    param([string]$CanvasPath)
    $raw = Read-Utf8 $CanvasPath
    $json = $raw | ConvertFrom-Json
    $changed = $false
    foreach ($node in @($json.nodes)) {
        if ($null -eq $node.file) { continue }
        foreach ($oldFile in $oldFiles) {
            $oldPath1 = "03_Projects/$oldFile"
            $oldPath2 = "03_Projects\$oldFile"
            if ($node.file -eq $oldPath1 -or $node.file -eq $oldPath2 -or $node.file -eq $oldFile) {
                $node.file = "03_Projects/$canonicalFile"
                $changed = $true
            }
        }
    }
    if ($changed) { Write-Utf8 $CanvasPath ($json | ConvertTo-Json -Depth 100) }
    return $changed
}

function Update-RegistryText {
    param([string]$Text)
    $line = "| PPJ.AI.Hub | PPJ.AI.Hub.md | DESIGN | AI / Automation Platform | Khoa | Huy | AI Team, Management, Reporting | Design / P1 | TBD | TBD | Confirm platform owner and module onboarding standard | Define module registry fields | Decision_Driven_BRD; User_Manual_Template; System_Design_Template | Obsidian / Portal / Internal Tools | PPJ.AI.Hub.md | 70 | Promoted from Web Tong Hop Tool; platform hub, not replacement for individual bot notes |"
    $updated = $Text
    $updated = $updated -replace '(?m)^\| Web Tong Hop Tool \|.*\r?\n?', ''
    if ($updated -notmatch '(?m)^\| PPJ\.AI\.Hub \|') {
        $updated = [regex]::Replace($updated, '(?m)(^\|---.*\|\r?\n)', "`$1$line`r`n", 1)
    }
    return $updated
}

function Update-AliasMapText {
    param([string]$Text)
    $rows = @(
        "| Web Tong Hop Tool.md | PPJ.AI.Hub.md | Old web tool name promoted into central AI tools, bots, chatbot, and automation hub. | High | Convert to alias/history after content preservation | Yes | Yes if Canvas file-node refs exist |",
        "| $webTongVnFile | PPJ.AI.Hub.md | Vietnamese duplicate/placeholder promoted into PPJ.AI.Hub alias history. | High | Convert to alias/history after content preservation | Yes | Yes if Canvas file-node refs exist |"
    )
    $updated = $Text
    $updated = $updated -replace '(?m)^\| Web Tong Hop Tool\.md \|.*\r?\n?', ''
    $updated = [regex]::Replace($updated, ('(?m)^\| ' + [regex]::Escape($webTongVnFile) + ' \|.*\r?\n?'), '')
    foreach ($row in $rows) {
        if ($updated -notmatch [regex]::Escape($row)) {
            $updated = [regex]::Replace($updated, '(?m)(^\|---.*\|\r?\n)', "`$1$row`r`n", 1)
        }
    }
    return $updated
}

$sourcePlans = @()
foreach ($oldFile in $oldFiles) {
    $path = Join-Path $projectRoot $oldFile
    $exists = Test-Path $path
    $text = Read-Utf8 $path
    $sourcePlans += [pscustomobject]@{
        FileName = $oldFile
        Path = $path
        Relative = if ($exists) { Get-RelativePath $path } else { "03_Projects\$oldFile" }
        Exists = $exists
        Length = if ($exists) { (Get-Item $path).Length } else { 0 }
        Classification = Get-FileClassification $path
        Text = $text
        Preview = Get-Preview $path
    }
}

$canonicalPath = Join-Path $projectRoot $canonicalFile
$canonicalExists = Test-Path $canonicalPath
$canonicalLength = if ($canonicalExists) { (Get-Item $canonicalPath).Length } else { 0 }
$canonicalClassification = Get-FileClassification $canonicalPath
$markdownRefs = @(Find-MarkdownLinkReferences)
$canvasRefs = @(Find-CanvasFileNodeReferences)
$registryUpdateNeeded = (Test-Path $registryPath)
$aliasMapUpdateNeeded = (Test-Path $aliasMapPath)

Write-Host "PPJ AI Hub Promotion"
Write-Host "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Write-Host ""
Write-Host "File check:"
foreach ($source in $sourcePlans) {
    Write-Host " - $($source.Relative): exists=$($source.Exists), size=$($source.Length), classification=$($source.Classification)"
}
Write-Host " - 03_Projects\${canonicalFile}: exists=$canonicalExists, size=$canonicalLength, classification=$canonicalClassification"
Write-Host ""
Write-Host "Preview: Web Tong Hop Tool.md"
Write-Host (($sourcePlans | Where-Object { $_.FileName -eq "Web Tong Hop Tool.md" }).Preview)
Write-Host ""
Write-Host "Preview: $webTongVnFile"
Write-Host (($sourcePlans | Where-Object { $_.FileName -eq $webTongVnFile }).Preview)
Write-Host ""
Write-Host "Markdown links planned: $($markdownRefs.Count)"
foreach ($ref in $markdownRefs) { Write-Host " - $($ref.File):$($ref.Line) $($ref.OldName)" }
Write-Host ""
Write-Host "Canvas file-node refs planned: $($canvasRefs.Count)"
foreach ($ref in $canvasRefs) { Write-Host " - $($ref.Canvas) node=$($ref.NodeId): $($ref.OldFile) -> $($ref.NewFile)" }
Write-Host ""
Write-Host "Registry updates planned: $registryUpdateNeeded"
Write-Host "Alias map updates planned: $aliasMapUpdateNeeded"
Write-Host ""
Write-Host "Promotion plan:"
Write-Host " - Create or update 03_Projects\$canonicalFile"
Write-Host " - Preserve useful content from Web Tong Hop Tool.md"
Write-Host " - Preserve content from $webTongVnFile if useful content exists"
Write-Host " - Convert old notes to alias/history after preservation"
Write-Host " - Update active Markdown links to [[PPJ.AI.Hub]]"
Write-Host " - Update active Canvas file-node paths only"
Write-Host " - Update project registry and alias map"

if ($DryRun) {
    Write-Host ""
    Write-Host "DryRun only. No files were modified."
    exit 0
}

New-Item -ItemType Directory -Force -Path $auditRoot, $backupRoot | Out-Null
$script:LogLines = @()
$script:LogLines += "# PPJ AI Hub Promotion Log - $stamp"
$script:LogLines += ""
$script:LogLines += "Mode: Apply"
$script:LogLines += ""

$affected = @($canonicalPath, $registryPath, $aliasMapPath)
foreach ($source in $sourcePlans) { if ($source.Exists) { $affected += $source.Path } }
foreach ($ref in $markdownRefs) { $affected += (Join-Path $vaultRoot $ref.File) }
foreach ($ref in $canvasRefs) { $affected += (Join-Path $vaultRoot $ref.Canvas) }
foreach ($path in @($affected | Sort-Object -Unique)) { Backup-File $path }

$existingCanonical = Read-Utf8 $canonicalPath
$newCanonical = Merge-AIHubContent $existingCanonical $sourcePlans
Write-Utf8 $canonicalPath $newCanonical
$script:LogLines += "- Created/updated canonical project: 03_Projects\$canonicalFile"

foreach ($source in $sourcePlans) {
    if (-not $source.Exists) { continue }
    $previousScope = Get-BaseName $source.FileName
    Write-Utf8 $source.Path (Get-AliasNoteText $previousScope)
    $script:LogLines += "- Converted old note to alias/history: $($source.Relative)"
}

foreach ($file in (Get-ActiveMarkdownFiles)) {
    $raw = Read-Utf8 $file.FullName
    $new = Replace-WikiLinksPreserveDisplay $raw
    if ($new -ne $raw) {
        Write-Utf8 $file.FullName $new
        $script:LogLines += "- Updated Markdown links: $(Get-RelativePath $file.FullName)"
    }
}

foreach ($relativeCanvas in $activeCanvasFiles) {
    $canvasPath = Join-Path $vaultRoot $relativeCanvas
    if ((Test-Path $canvasPath) -and (Update-CanvasFileNodes $canvasPath)) {
        $script:LogLines += "- Updated Canvas file-node paths: $relativeCanvas"
    }
}

if (Test-Path $registryPath) {
    Write-Utf8 $registryPath (Update-RegistryText (Read-Utf8 $registryPath))
    $script:LogLines += "- Updated registry: 03_Projects\_Registry\PPJ_PROJECT_REGISTRY.md"
}

if (Test-Path $aliasMapPath) {
    Write-Utf8 $aliasMapPath (Update-AliasMapText (Read-Utf8 $aliasMapPath))
    $script:LogLines += "- Updated alias map: 03_Projects\_Registry\PPJ_PROJECT_ALIAS_MAP.md"
}

$report = New-Object System.Collections.Generic.List[string]
$report.Add("# PPJ AI Hub Promotion Report - $dateStamp")
$report.Add("")
$report.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
$report.Add("")
$report.Add("## Executive Summary")
$report.Add("")
$report.Add("Web Tong Hop Tool and $webTongVnName were promoted into PPJ.AI.Hub as the central AI tools, bots, chatbot, automation, and internal application hub for the PPJ AI team.")
$report.Add("")
$report.Add("## Business Decision")
$report.Add("")
$report.Add("PPJ.AI.Hub is a platform / portal / hub project. It does not merge all bot projects into one note. Individual bot and automation project notes remain source of truth and are linked as connected modules.")
$report.Add("")
$report.Add("## Old Notes")
$report.Add("")
foreach ($source in $sourcePlans) { $report.Add("- $($source.Relative): $($source.Classification), size $($source.Length)") }
$report.Add("")
$report.Add("## New Canonical Project")
$report.Add("")
$report.Add("- 03_Projects\PPJ.AI.Hub.md")
$report.Add("")
$report.Add("## Preserved Content")
$report.Add("")
foreach ($source in $sourcePlans) { if ($source.Exists -and -not [string]::IsNullOrWhiteSpace($source.Text)) { $report.Add("- Preserved: $($source.Relative)") } }
$report.Add("")
$report.Add("## Registry Update")
$report.Add("")
$report.Add("- Updated PPJ_PROJECT_REGISTRY.md to use PPJ.AI.Hub.md as canonical.")
$report.Add("")
$report.Add("## Alias Map Update")
$report.Add("")
$report.Add("- Added/updated Web Tong Hop Tool aliases to point to PPJ.AI.Hub.md.")
$report.Add("")
$report.Add("## Markdown Reference Update")
$report.Add("")
foreach ($ref in $markdownRefs) { $report.Add("- $($ref.File):$($ref.Line) $($ref.OldName) -> PPJ.AI.Hub") }
if ($markdownRefs.Count -eq 0) { $report.Add("- None.") }
$report.Add("")
$report.Add("## Canvas Reference Update")
$report.Add("")
foreach ($ref in $canvasRefs) { $report.Add("- $($ref.Canvas) node $($ref.NodeId): $($ref.OldFile) -> $($ref.NewFile)") }
if ($canvasRefs.Count -eq 0) { $report.Add("- None.") }
$report.Add("")
$report.Add("## Connected Modules")
$report.Add("")
$report.Add("- [[SCP.SOURCING.CHATBOT.v2.3]]")
$report.Add("- [[PPJ.PERRI.Chatbot]]")
$report.Add("- [[PPJ.GLPI-Helpdesk-AI Chatbot]]")
$report.Add("- [[PPJ.Invoice Downloader.v1.2]]")
$report.Add("- [[PPJ. Expense-Invoices.v1.1]]")
$report.Add("- [[Accounting GRN Supplier Invoice Bot]]")
$report.Add("- [[PUR.GDI Automation]]")
$report.Add("- [[PUR.Material.Allocation.v1.1]]")
$report.Add("- [[TD.TechnicalPlatform_v2.1]]")
$report.Add("")
$report.Add("## Risks and Decisions Needed")
$report.Add("")
$report.Add("- Confirm hub owner.")
$report.Add("- Confirm module onboarding standard.")
$report.Add("- Confirm access control model.")
$report.Add("- Confirm first release modules.")
$report.Add("")
$report.Add("## Next Action")
$report.Add("")
$report.Add("Review PPJ.AI.Hub.md and confirm owner, access model, and module registry fields.")
Write-Utf8 $reportPath ($report -join "`r`n")

$script:LogLines += ""
$script:LogLines += "## Safety Confirmation"
$script:LogLines += ""
$script:LogLines += "- No files deleted."
$script:LogLines += "- Old files retained as alias/history notes."
$script:LogLines += "- Canvas file-node paths only were updated."
$script:LogLines += "- Individual bot and automation project notes remain separate."
Write-Utf8 $logPath ($script:LogLines -join "`r`n")

Write-Host ""
Write-Host "Apply completed."
Write-Host " - Canonical project: 03_Projects\$canonicalFile"
Write-Host " - Report: $reportPath"
Write-Host " - Log: $logPath"
Write-Host " - Backup folder: $backupRoot"
