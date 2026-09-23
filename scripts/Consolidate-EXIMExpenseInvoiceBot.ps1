param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

if (-not $Apply) {
    $DryRun = $true
}

# -------------------------
# Paths
# -------------------------
$vaultRoot = (Get-Location).Path
$projectRoot = Join-Path $vaultRoot "03_Projects"
$registryRoot = Join-Path $projectRoot "_Registry"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"

$sourcePath = Join-Path $projectRoot "EX-IM Expense Invoice Bot.md"
$canonicalPath = Join-Path $projectRoot "PPJ. Expense-Invoices.v1.1.md"
$importExportPath = Join-Path $projectRoot "Import Export Automation.md"
$aliasMapPath = Join-Path $registryRoot "PPJ_PROJECT_ALIAS_MAP.md"
$registryPath = Join-Path $registryRoot "PPJ_PROJECT_REGISTRY.md"

$canonicalName = "PPJ. Expense-Invoices.v1.1"
$sourceName = "EX-IM Expense Invoice Bot"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRoot = Join-Path $auditRoot "Project_Cleanup_Backup\$stamp"
$logPath = Join-Path $auditRoot "CONSOLIDATE_EXIM_EXPENSE_INVOICE_BOT_LOG_$stamp.md"

# -------------------------
# Helpers
# -------------------------
function Read-Utf8 {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return "" }
    return Get-Content -Raw -Encoding UTF8 $Path
}

function Write-Utf8 {
    param(
        [string]$Path,
        [string]$Text
    )
    $Text | Set-Content -Encoding UTF8 $Path
}

function Add-Utf8 {
    param(
        [string]$Path,
        [string]$Text
    )
    Add-Content -Encoding UTF8 -Path $Path -Value $Text
}

function Get-NoteState {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return "Missing"
    }

    $item = Get-Item $Path
    if ($item.Length -eq 0) {
        return "Zero-byte"
    }

    $raw = Read-Utf8 $Path
    if ($raw -match '(?im)^type\s*:\s*alias\s*$' -or $raw -match '(?im)^status\s*:\s*"?alias"?\s*$') {
        return "Alias"
    }

    return "Non-empty"
}

function Backup-File {
    param([string]$Path)

    if (-not (Test-Path $Path)) { return }

    $relative = (Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\')
    $target = Join-Path $backupRoot $relative
    $targetDir = Split-Path $target -Parent
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item -Path $Path -Destination $target -Force
    $script:LogLines += "- Backup: $relative"
}

function Get-PreservedSourceContent {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return "TBD"
    }

    $clean = $Text.Trim()
    $clean = $clean -replace '🎯\s*', ''
    $clean = $clean -replace '📌\s*', ''
    $clean = $clean -replace '⚠️\s*', ''
    $clean = $clean -replace '✅\s*', ''
    $clean = $clean -replace '🔗\s*', ''
    $clean = $clean -replace '🔧\s*', ''
    $clean = $clean -replace '📎\s*', ''
    $clean = [regex]::Replace($clean, '[\uD800-\uDFFF]', '')
    $clean = [regex]::Replace($clean, '[\uFE0E\uFE0F]', '')
    $clean = [regex]::Replace($clean, '[\u2600-\u27BF]', '')
    return $clean
}

function New-PreservedSection {
    param([string]$PreservedContent)

    return @"

---

## Source Notes Preserved

Source:
[[$sourceName]]

Preserved On:
$(Get-Date -Format "yyyy-MM-dd HH:mm")

Preserved Content:

~~~markdown
$PreservedContent
~~~
"@
}

function New-GovernanceUpdateSection {
    return @"

---

## Project Governance Update

Canonical Project:
[[$canonicalName]]

Consolidated Alias:
[[$sourceName]]

Business Meaning:
EX-IM Expense Invoice Bot is treated as part of the current PPJ expense invoice automation v1.1 scope.

Future Roadmap:
PPJ.Expense-Invoices.v1.2 may be considered later if the scope is formally expanded into a PPJ-wide multi-department invoice automation foundation.
"@
}

function New-AliasNote {
    return @"
---
type: alias
canonical: "$canonicalName"
canonical_file: "PPJ. Expense-Invoices.v1.1.md"
status: "alias"
created_by: "Consolidate-EXIMExpenseInvoiceBot.ps1"
---

# Alias Note

Canonical Project:
[[$canonicalName]]

Reason:
This old EXIM-specific note is retained to preserve backlinks and historical context. The scope is now managed under the canonical PPJ expense invoice automation v1.1 project.

Previous Scope:
EXIM Expense Invoice Bot

Current Canonical Scope:
PPJ Expense Invoice Automation v1.1

Future Roadmap:
[[PPJ.Expense-Invoices.v1.2]] may be created later only if the project is officially expanded into a PPJ-wide multi-department invoice automation foundation.

Related Concepts
[[Project Governance]]
[[Traceability]]
[[Process Automation]]
[[Invoice Automation]]

Methods
[[Data Mapping]]
[[Impact Analysis]]
[[Requirement Validation]]
"@
}

function Update-AliasMapText {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $Text }

    $updated = $Text

    $updated = $updated -replace '\| EXIM\.Expense-Invoices Automation\.md \| EX-IM Expense Invoice Bot\.md \| Resource-map EXIM automation name\. \| Medium \| Resource-map alias only; update links only if found \| Yes if links exist \| Check Canvas after registry approval \|', '| EXIM.Expense-Invoices Automation.md | PPJ. Expense-Invoices.v1.1.md | EXIM automation name is consolidated under current PPJ expense invoice automation v1.1 scope. | High | Keep as alias/history; no Canvas update in this script | No global replacement in this script | No |'
    $updated = $updated -replace '\| Import Export Automation\.md \| EX-IM Expense Invoice Bot\.md \| Old EXIM/import-export automation alias\. \| Medium \| Candidate for alias conversion after approval \| Yes if links exist \| Check Canvas after registry approval \|', '| Import Export Automation.md | PPJ. Expense-Invoices.v1.1.md | Old import/export automation alias is consolidated under PPJ expense invoice automation v1.1. | High | Leave existing alias if already correct; no Canvas update in this script | No global replacement in this script | No |'

    if ($updated -notmatch [regex]::Escape('| EX-IM Expense Invoice Bot.md | PPJ. Expense-Invoices.v1.1.md |')) {
        $row = '| EX-IM Expense Invoice Bot.md | PPJ. Expense-Invoices.v1.1.md | EXIM-specific production bot consolidated into the current PPJ expense invoice automation v1.1 scope. | High | Converted to alias/history after content preservation | No global replacement in this script | No |'
        $updated = $updated -replace '(?m)(\|---\|---\|---\|---\|---\|---\|---\|\r?\n)', "`$1$row`r`n"
    }

    return $updated
}

function Update-RegistryText {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $Text }
    if ($Text -match 'EXIM Expense Invoice Bot Consolidation Update') { return $Text }

    return $Text + @"

---

## EXIM Expense Invoice Bot Consolidation Update

Canonical Project:
[[$canonicalName]]

Alias / History Notes:
- [[$sourceName]]
- [[Import Export Automation]]

Status:
Consolidated scope

Decision Needed:
Confirm future v1.2 multi-department expansion only if PPJ formally expands the project beyond the current v1.1 scope.

Business Meaning:
EX-IM Expense Invoice Bot is treated as part of the current PPJ expense invoice automation v1.1 scope.
"@
}

function Show-Preview {
    param(
        [string]$Title,
        [string]$Text,
        [int]$MaxChars = 2500
    )

    Write-Host ""
    Write-Host $Title
    Write-Host ("-" * $Title.Length)
    if ([string]::IsNullOrWhiteSpace($Text)) {
        Write-Host "TBD"
        return
    }

    if ($Text.Length -gt $MaxChars) {
        Write-Host $Text.Substring(0, $MaxChars)
        Write-Host "... [truncated preview]"
    }
    else {
        Write-Host $Text
    }
}

# -------------------------
# Scan
# -------------------------
$sourceState = Get-NoteState $sourcePath
$canonicalState = Get-NoteState $canonicalPath
$importExportState = Get-NoteState $importExportPath

$sourceText = Read-Utf8 $sourcePath
$canonicalText = Read-Utf8 $canonicalPath
$importExportText = Read-Utf8 $importExportPath
$preservedContent = Get-PreservedSourceContent $sourceText
$preservedSection = New-PreservedSection $preservedContent
$governanceSection = New-GovernanceUpdateSection
$aliasNote = New-AliasNote

Write-Host "EXIM Expense Invoice Bot Consolidation"
Write-Host "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Write-Host ""
Write-Host "File checks:"
Write-Host " - 03_Projects/EX-IM Expense Invoice Bot.md: $sourceState"
Write-Host " - 03_Projects/PPJ. Expense-Invoices.v1.1.md: $canonicalState"
Write-Host " - 03_Projects/Import Export Automation.md: $importExportState"

if ($canonicalState -eq "Missing") {
    throw "Canonical project note is missing: $canonicalPath"
}

if ($sourceState -eq "Missing") {
    throw "Source EXIM note is missing: $sourcePath"
}

Show-Preview "Content that would be preserved from EX-IM Expense Invoice Bot.md" $preservedContent
Show-Preview "Section that would be appended to PPJ. Expense-Invoices.v1.1.md" ($preservedSection + $governanceSection)
Show-Preview "Alias conversion that would be written to EX-IM Expense Invoice Bot.md" $aliasNote

Write-Host ""
Write-Host "Registry update plan:"
Write-Host " - Update PPJ_PROJECT_ALIAS_MAP.md so EX-IM Expense Invoice Bot.md maps to PPJ. Expense-Invoices.v1.1.md."
Write-Host " - Update Import Export Automation.md alias-map target to PPJ. Expense-Invoices.v1.1.md."
Write-Host " - Append registry consolidation note for PPJ. Expense-Invoices.v1.1 if not already present."
Write-Host " - No Canvas update."
Write-Host " - No global Markdown link replacement."

if ($DryRun) {
    Write-Host ""
    Write-Host "DryRun only. No files were modified."
    exit 0
}

# -------------------------
# Apply
# -------------------------
New-Item -ItemType Directory -Force -Path $auditRoot, $backupRoot | Out-Null
$script:LogLines = @()
$script:LogLines += "# Consolidate EXIM Expense Invoice Bot Log - $stamp"
$script:LogLines += ""
$script:LogLines += "Mode: Apply"
$script:LogLines += ""

$affected = @($sourcePath, $canonicalPath, $importExportPath, $aliasMapPath, $registryPath)
foreach ($path in $affected) {
    Backup-File $path
}

$canonicalUpdated = $canonicalText
if ($canonicalUpdated -notmatch '## Source Notes Preserved\s+\r?\n\s+Source:\s+\r?\n\[\[EX-IM Expense Invoice Bot\]\]') {
    $canonicalUpdated += $preservedSection
    $script:LogLines += "- Appended preserved EXIM source notes to canonical project."
}
else {
    $script:LogLines += "- Preserved EXIM source notes already present; skipped append."
}

if ($canonicalUpdated -notmatch '## Project Governance Update') {
    $canonicalUpdated += $governanceSection
    $script:LogLines += "- Appended project governance update to canonical project."
}
else {
    $script:LogLines += "- Project governance update already present; skipped append."
}
Write-Utf8 $canonicalPath $canonicalUpdated

Write-Utf8 $sourcePath $aliasNote
$script:LogLines += "- Converted EX-IM Expense Invoice Bot.md to alias/history note."

if (Test-Path $aliasMapPath) {
    $aliasText = Read-Utf8 $aliasMapPath
    $aliasUpdated = Update-AliasMapText $aliasText
    if ($aliasUpdated -ne $aliasText) {
        Write-Utf8 $aliasMapPath $aliasUpdated
        $script:LogLines += "- Updated PPJ_PROJECT_ALIAS_MAP.md consolidation mappings."
    }
    else {
        $script:LogLines += "- Alias map already reflected consolidation or no matching row found."
    }
}

if (Test-Path $registryPath) {
    $registryText = Read-Utf8 $registryPath
    $registryUpdated = Update-RegistryText $registryText
    if ($registryUpdated -ne $registryText) {
        Write-Utf8 $registryPath $registryUpdated
        $script:LogLines += "- Updated PPJ_PROJECT_REGISTRY.md with consolidation note."
    }
    else {
        $script:LogLines += "- Registry consolidation note already present."
    }
}

$script:LogLines += ""
$script:LogLines += "## Safety Confirmation"
$script:LogLines += ""
$script:LogLines += "- No files deleted."
$script:LogLines += "- No Canvas files updated."
$script:LogLines += "- No global Markdown link replacement performed."
$script:LogLines += "- PPJ.Expense-Invoices.v1.2 was not created."
$script:LogLines += "- PPJ. Expense-Invoices.v1.1.md was not renamed."

Write-Utf8 $logPath ($script:LogLines -join "`r`n")

Write-Host ""
Write-Host "Apply completed."
Write-Host " - Backup folder: $backupRoot"
Write-Host " - Log: $logPath"
