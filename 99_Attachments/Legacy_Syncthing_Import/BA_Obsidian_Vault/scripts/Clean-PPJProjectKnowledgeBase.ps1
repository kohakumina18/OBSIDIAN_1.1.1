param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Default behavior is DryRun.
if (-not $Apply) {
    $DryRun = $true
}

# -------------------------
# Paths
# -------------------------
$vaultRoot = (Get-Location).Path
$projectRoot = Join-Path $vaultRoot "03_Projects"
$canvasRoot = Join-Path $projectRoot "Canvas"
$registryRoot = Join-Path $projectRoot "_Registry"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$backupRoot = Join-Path $vaultRoot "99_Attachments\Project_Cleanup_Backup"
$archiveRoot = Join-Path $projectRoot "_Archive"

$stamp = Get-Date -Format "yyyyMMdd_HHmm"
$logPath = Join-Path $auditRoot "PROJECT_CLEANUP_LOG_$stamp.md"
$backupRunRoot = Join-Path $backupRoot $stamp

New-Item -ItemType Directory -Force -Path $registryRoot, $auditRoot, $backupRoot, $archiveRoot | Out-Null

# -------------------------
# Helpers
# -------------------------
function Read-Utf8 {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return ""
    }

    return Get-Content -Raw -Encoding UTF8 $Path
}

function Write-Utf8 {
    param(
        [string]$Path,
        [string]$Text
    )

    $Text | Set-Content -Encoding UTF8 $Path
}

function Add-Log {
    param([string]$Line)
    $script:LogLines += $Line
}

function Safe-FileName {
    param([string]$Name)

    $safe = $Name -replace '[<>:"/\\|?*]', '-'
    return $safe.Trim()
}

function Get-BaseName {
    param([string]$FileName)
    return [System.IO.Path]::GetFileNameWithoutExtension($FileName)
}

function Backup-File {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return
    }

    $relative = Resolve-Path -Path $Path | ForEach-Object {
        $_.Path.Substring($vaultRoot.Length).TrimStart('\')
    }

    $target = Join-Path $backupRunRoot $relative
    $targetDir = Split-Path $target -Parent
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item -Path $Path -Destination $target -Force
    Add-Log "- Backup: $relative"
}

function New-AliasNoteText {
    param(
        [string]$CanonicalName
    )

    return @"
---
type: alias
canonical: "$CanonicalName"
status: "alias"
created_by: "Clean-PPJProjectKnowledgeBase.ps1"
---

# Alias Note

Canonical Project:
[[$CanonicalName]]

Reason:
This note is retained to preserve backlinks and prevent broken links.
"@
}

function Update-WikiLinksInText {
    param(
        [string]$Text,
        [string]$AliasBase,
        [string]$CanonicalBase
    )

    $escaped = [regex]::Escape($AliasBase)
    $text1 = [regex]::Replace($Text, "\[\[$escaped\]\]", "[[$CanonicalBase]]")
    $text2 = [regex]::Replace($text1, "\[\[$escaped\|", "[[$CanonicalBase|")
    return $text2
}

function Test-AliasContentCanBeConverted {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return $true
    }

    if ($Text -match '(?im)^type\s*:\s*alias\s*$') {
        return $true
    }

    return $false
}

# -------------------------
# Alias rules
# -------------------------
$AliasRules = @(
    [pscustomobject]@{ Alias = "Adhoc Indent miền Nam.md"; Canonical = "Adhoc Indent mien Nam.md"; Confidence = "High"; Reason = "Vietnamese accent filename duplicate; prefer ASCII canonical for scripts." },
    [pscustomobject]@{ Alias = "Adhoc Indent.md"; Canonical = "Adhoc Indent mien Nam.md"; Confidence = "Medium"; Reason = "Short/old umbrella name for same Adhoc Indent scope." },
    [pscustomobject]@{ Alias = "Chuyền Treo IoT Dashboard.md"; Canonical = "IOT.CHuyenTreo_1.md"; Confidence = "Medium"; Reason = "Coded project filename available; likely same factory IoT dashboard." },
    [pscustomobject]@{ Alias = "Chuyền treo ver1.md"; Canonical = "IOT.CHuyenTreo_1.md"; Confidence = "Medium"; Reason = "Old Vietnamese/non-coded project name; coded IoT filename available." },
    [pscustomobject]@{ Alias = "Cowash VER2.md"; Canonical = "COWASH.md"; Confidence = "High"; Reason = "Version label duplicate for COWASH project." },
    [pscustomobject]@{ Alias = "E-commerce Exploration.md"; Canonical = "E-commerce Market Intelligence.md"; Confidence = "High"; Reason = "Exploration appears to be old/short name for Market Intelligence work." },
    [pscustomobject]@{ Alias = "Market Intelligence.md"; Canonical = "E-commerce Market Intelligence.md"; Confidence = "Medium"; Reason = "Generic market intelligence alias; canonical project is business-specific." },
    [pscustomobject]@{ Alias = "GDI Automation.md"; Canonical = "PUR.GDI Automation.md"; Confidence = "High"; Reason = "Coded Purchasing GDI project name preferred." },
    [pscustomobject]@{ Alias = "Import Export Automation.md"; Canonical = "PPJ. Expense-Invoices.v1.1.md"; Confidence = "Medium"; Reason = "Old umbrella name overlaps invoice automation foundation." },
    [pscustomobject]@{ Alias = "EX-IM Expense Invoice Bot.md"; Canonical = "PPJ. Expense-Invoices.v1.1.md"; Confidence = "Medium"; Reason = "Likely EXIM-specific alias under expense invoice automation foundation; review because EXIM may remain a separate bot." },
    [pscustomobject]@{ Alias = "PPJ x Nunox.md"; Canonical = "NUNOX.md"; Confidence = "High"; Reason = "Vendor partnership naming duplicate." },
    [pscustomobject]@{ Alias = "PPJ x Stratova AI.md"; Canonical = "Stratova AI.md"; Confidence = "High"; Reason = "Vendor partnership naming duplicate." },
    [pscustomobject]@{ Alias = "Sourcing Chatbot v2.3.md"; Canonical = "SCP.SOURCING.CHATBOT.v2.3.md"; Confidence = "High"; Reason = "Coded sourcing project name is canonical; sourcing must not be split." },
    [pscustomobject]@{ Alias = "Sourcing VER2.md"; Canonical = "SCP.SOURCING.CHATBOT.v2.3.md"; Confidence = "High"; Reason = "Old sourcing version alias; canonical project includes chatbot and external sample repository." },
    [pscustomobject]@{ Alias = "Web Tổng Hợp Tool.md"; Canonical = "Web Tong Hop Tool.md"; Confidence = "High"; Reason = "Vietnamese accent filename duplicate; prefer ASCII canonical for scripts." },
    [pscustomobject]@{ Alias = "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md"; Canonical = "RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md"; Confidence = "Medium"; Reason = "README names RND.WASH as canonical coded R&D Wash portal project; canonical file may need approval before creation." },
    [pscustomobject]@{ Alias = "CPD Fabric Database.md"; Canonical = "TD.TechnicalPlatform_v2.1.md"; Confidence = "Medium"; Reason = "CPD fabric database appears to be business name for technical CPD datamart platform." }
)

$script:LogLines = @()
Add-Log "# PPJ Project Knowledge Base Cleanup Log - $stamp"
Add-Log ""
Add-Log "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Add-Log "Force: $Force"
Add-Log ""
Add-Log "## Planned or Applied Operations"
Add-Log ""

Write-Host "PPJ Project Knowledge Base Cleanup"
Write-Host "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Write-Host "Vault: $vaultRoot"
Write-Host ""

$plannedAliasConversions = 0
$mergeRecommendations = 0
$linkUpdates = 0
$canvasUpdates = 0
$skippedMissingCanonical = 0

# -------------------------
# Alias conversion and merge recommendations
# -------------------------
foreach ($rule in $AliasRules) {
    $aliasPath = Join-Path $projectRoot $rule.Alias
    $canonicalPath = Join-Path $projectRoot $rule.Canonical
    $aliasBase = Get-BaseName $rule.Alias
    $canonicalBase = Get-BaseName $rule.Canonical

    if (-not (Test-Path $aliasPath)) {
        Add-Log "- Skip missing alias: $($rule.Alias)"
        continue
    }

    if (-not (Test-Path $canonicalPath)) {
        $skippedMissingCanonical++
        Add-Log "- Missing canonical target: $($rule.Canonical). Alias not changed: $($rule.Alias)"
        continue
    }

    $aliasText = Read-Utf8 $aliasPath
    $canConvert = Test-AliasContentCanBeConverted $aliasText

    if ($canConvert) {
        $plannedAliasConversions++
        Add-Log "- Convert alias note: $($rule.Alias) -> $($rule.Canonical). Reason: $($rule.Reason)"

        if ($Apply) {
            Backup-File $aliasPath
            $aliasNote = New-AliasNoteText $canonicalBase
            Write-Utf8 $aliasPath $aliasNote
            Write-Host "Alias converted: $($rule.Alias) -> $($rule.Canonical)"
        }
        else {
            Write-Host "DryRun: would convert alias note: $($rule.Alias) -> $($rule.Canonical)"
        }
    }
    else {
        $mergeRecommendations++
        Add-Log "- Merge review required: $($rule.Alias) -> $($rule.Canonical). Non-empty note was not overwritten."
        Write-Host "Merge review required: $($rule.Alias) -> $($rule.Canonical)"
    }
}

# -------------------------
# Update wiki links in Markdown files
# -------------------------
$markdownFiles = @(Get-ChildItem -Path $vaultRoot -Filter "*.md" -File -Recurse | Where-Object {
    $_.FullName -notmatch '\\.obsidian\\' -and
    $_.FullName -notmatch '\\.git\\' -and
    $_.FullName -notmatch '\\Project_SmartFlow\\'
})

foreach ($file in $markdownFiles) {
    $original = Read-Utf8 $file.FullName
    $updated = $original

    foreach ($rule in $AliasRules) {
        $canonicalPath = Join-Path $projectRoot $rule.Canonical
        if (-not (Test-Path $canonicalPath)) {
            continue
        }

        $aliasBase = Get-BaseName $rule.Alias
        $canonicalBase = Get-BaseName $rule.Canonical
        $updated = Update-WikiLinksInText $updated $aliasBase $canonicalBase
    }

    if ($updated -ne $original) {
        $relative = $file.FullName.Substring($vaultRoot.Length).TrimStart('\')
        $linkUpdates++
        Add-Log "- Wiki link update: $relative"

        if ($Apply) {
            Backup-File $file.FullName
            Write-Utf8 $file.FullName $updated
            Write-Host "Updated wiki links: $relative"
        }
        else {
            Write-Host "DryRun: would update wiki links: $relative"
        }
    }
}

# -------------------------
# Update Canvas file references
# -------------------------
if (Test-Path $canvasRoot) {
    $canvasFiles = @(Get-ChildItem -Path $canvasRoot -Filter "*.canvas" -File)

    foreach ($canvas in $canvasFiles) {
        $raw = Read-Utf8 $canvas.FullName
        $changed = $false

        try {
            $json = $raw | ConvertFrom-Json
        }
        catch {
            Add-Log "- Canvas skipped due to JSON parse error: $($canvas.Name)"
            continue
        }

        foreach ($node in @($json.nodes)) {
            if ($null -eq $node.file) {
                continue
            }

            foreach ($rule in $AliasRules) {
                $canonicalPath = Join-Path $projectRoot $rule.Canonical
                if (-not (Test-Path $canonicalPath)) {
                    continue
                }

                $aliasFile1 = "03_Projects/$($rule.Alias)"
                $aliasFile2 = "03_Projects\$($rule.Alias)"
                $canonicalFile = "03_Projects/$($rule.Canonical)"

                if ($node.file -eq $aliasFile1 -or $node.file -eq $aliasFile2 -or $node.file -eq $rule.Alias) {
                    $node.file = $canonicalFile
                    $changed = $true
                }
            }
        }

        if ($changed) {
            $canvasUpdates++
            Add-Log "- Canvas reference update: $($canvas.Name)"

            if ($Apply) {
                Backup-File $canvas.FullName
                $out = $json | ConvertTo-Json -Depth 100
                Write-Utf8 $canvas.FullName $out
                Write-Host "Updated Canvas references: $($canvas.Name)"
            }
            else {
                Write-Host "DryRun: would update Canvas references: $($canvas.Name)"
            }
        }
    }
}

# -------------------------
# Summary and log
# -------------------------
Add-Log ""
Add-Log "## Summary"
Add-Log ""
Add-Log "- Alias conversions planned/applied: $plannedAliasConversions"
Add-Log "- Merge recommendations: $mergeRecommendations"
Add-Log "- Markdown files with wiki link updates: $linkUpdates"
Add-Log "- Canvas files with reference updates: $canvasUpdates"
Add-Log "- Missing canonical targets skipped: $skippedMissingCanonical"
Add-Log ""
Add-Log "## Safety Notes"
Add-Log ""
Add-Log "- No files are deleted by this script."
Add-Log "- Non-empty duplicate notes are not overwritten."
Add-Log "- Apply mode creates backups before writing changes."
Add-Log "- Project_SmartFlow is excluded from Markdown link cleanup."

Write-Utf8 $logPath ($LogLines -join "`r`n")

Write-Host ""
Write-Host "Cleanup script summary:"
Write-Host " - Alias conversions planned/applied: $plannedAliasConversions"
Write-Host " - Merge recommendations: $mergeRecommendations"
Write-Host " - Markdown files with wiki link updates: $linkUpdates"
Write-Host " - Canvas files with reference updates: $canvasUpdates"
Write-Host " - Missing canonical targets skipped: $skippedMissingCanonical"
Write-Host " - Log: $logPath"

if ($DryRun) {
    Write-Host ""
    Write-Host "DryRun only. No project notes or Canvas files were modified."
}
