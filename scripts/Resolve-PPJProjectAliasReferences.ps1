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
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$backupStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRoot = Join-Path $auditRoot "Alias_Reference_Backup\$backupStamp"
$logPath = Join-Path $auditRoot "ALIAS_REFERENCE_RESOLUTION_LOG_$backupStamp.md"
$reportPath = Join-Path $vaultRoot ("10_Reports\ALIAS_REFERENCE_RESOLUTION_REPORT_" + (Get-Date -Format "yyyyMMdd") + ".md")

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

$canvasFiles = @(
    "03_Projects\Canvas\PPJ_Executive_Board.canvas",
    "03_Projects\Canvas\PPJ_Portfolio.canvas",
    "03_Projects\Canvas\PPJ_Data_Flow.canvas",
    "03_Projects\Canvas\PPJ_Roadmap_2026.canvas"
)

$aliasMappings = @(
    [pscustomobject]@{ AliasFile = "Adhoc Indent.md"; CanonicalFile = "Adhoc Indent mien Nam.md" },
    [pscustomobject]@{ AliasFile = "Cowash VER2.md"; CanonicalFile = "COWASH.md" },
    [pscustomobject]@{ AliasFile = "CPD Fabric Database.md"; CanonicalFile = "TD.TechnicalPlatform_v2.1.md" },
    [pscustomobject]@{ AliasFile = "E-commerce Exploration.md"; CanonicalFile = "E-commerce Market Intelligence.md" },
    [pscustomobject]@{ AliasFile = "EX-IM Expense Invoice Bot.md"; CanonicalFile = "PPJ. Expense-Invoices.v1.1.md" },
    [pscustomobject]@{ AliasFile = "GDI Automation.md"; CanonicalFile = "PUR.GDI Automation.md" },
    [pscustomobject]@{ AliasFile = "Import Export Automation.md"; CanonicalFile = "PPJ. Expense-Invoices.v1.1.md" },
    [pscustomobject]@{ AliasFile = "Market Intelligence.md"; CanonicalFile = "E-commerce Market Intelligence.md" },
    [pscustomobject]@{ AliasFile = "PPJ x Nunox.md"; CanonicalFile = "NUNOX.md" },
    [pscustomobject]@{ AliasFile = "PPJ x Stratova AI.md"; CanonicalFile = "Stratova AI.md" }
)

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

function Get-BaseName {
    param([string]$FileName)
    return [System.IO.Path]::GetFileNameWithoutExtension($FileName)
}

function Test-AliasFrontmatter {
    param([string]$Path)
    $text = Read-Utf8 $Path
    return ($text -match '(?im)^type\s*:\s*alias\s*$')
}

function Test-ExcludedPath {
    param([string]$Path)
    $relative = $Path.Substring($vaultRoot.Length).TrimStart('\')
    if ($relative -match '(^|\\)10_Reports(\\|$)') { return $true }
    if ($relative -match '(^|\\)99_Attachments(\\|$)') { return $true }
    if ($relative -match '(^|\\)\.obsidian(\\|$)') { return $true }
    if ($relative -match '(^|\\)\.git(\\|$)') { return $true }
    if ($relative -match '(?i)(^|\\)(backup|backups|Audit|Project_Cleanup_Backup|Alias_Reference_Backup)(\\|$)') { return $true }
    return $false
}

function Get-ActiveMarkdownFiles {
    $files = @()
    foreach ($root in $activeMarkdownRoots) {
        $fullRoot = Join-Path $vaultRoot $root
        if (-not (Test-Path $fullRoot)) { continue }
        $files += @(Get-ChildItem -Path $fullRoot -Filter "*.md" -File -Recurse | Where-Object { -not (Test-ExcludedPath $_.FullName) })
    }
    return @($files | Sort-Object FullName -Unique)
}

function Replace-WikiLinksOutsideCodeBlocks {
    param(
        [string]$Text,
        [object[]]$Mappings,
        [ref]$FoundRefs
    )

    $lines = $Text -split "`r?`n", -1
    $inFence = $false
    $changed = $false
    $out = New-Object System.Collections.Generic.List[string]

    foreach ($line in $lines) {
        if ($line -match '^\s*(```|~~~)') {
            $inFence = -not $inFence
            $out.Add($line)
            continue
        }

        $newLine = $line
        if (-not $inFence) {
            foreach ($m in $Mappings) {
                $aliasBase = [regex]::Escape((Get-BaseName $m.AliasFile))
                $canonicalBase = Get-BaseName $m.CanonicalFile
                $plainPattern = "\[\[$aliasBase\]\]"
                $displayPattern = "\[\[$aliasBase\|([^\]]+)\]\]"

                $plainMatches = [regex]::Matches($newLine, $plainPattern)
                foreach ($match in $plainMatches) {
                    $FoundRefs.Value += [pscustomobject]@{ Alias = (Get-BaseName $m.AliasFile); Canonical = $canonicalBase; Display = "" }
                }
                $newLine = [regex]::Replace($newLine, $plainPattern, "[[$canonicalBase]]")

                $displayMatches = [regex]::Matches($newLine, $displayPattern)
                foreach ($match in $displayMatches) {
                    $FoundRefs.Value += [pscustomobject]@{ Alias = (Get-BaseName $m.AliasFile); Canonical = $canonicalBase; Display = $match.Groups[1].Value }
                }
                $newLine = [regex]::Replace($newLine, $displayPattern, {
                    param($match)
                    return "[[$canonicalBase|$($match.Groups[1].Value)]]"
                })
            }
        }

        if ($newLine -ne $line) { $changed = $true }
        $out.Add($newLine)
    }

    return [pscustomobject]@{
        Text = ($out -join "`r`n")
        Changed = $changed
    }
}

function Get-CanvasChanges {
    param([string]$Path)
    $changes = @()
    if (-not (Test-Path $Path)) { return $changes }

    $raw = Read-Utf8 $Path
    $json = $raw | ConvertFrom-Json
    foreach ($node in @($json.nodes)) {
        if ($null -eq $node.file) { continue }
        foreach ($m in $aliasMappings) {
            $old1 = "03_Projects/$($m.AliasFile)"
            $old2 = "03_Projects\$($m.AliasFile)"
            $old3 = $m.AliasFile
            $new = "03_Projects/$($m.CanonicalFile)"
            if ($node.file -eq $old1 -or $node.file -eq $old2 -or $node.file -eq $old3) {
                $changes += [pscustomobject]@{ Old = $node.file; New = $new; NodeId = $node.id }
            }
        }
    }
    return $changes
}

function Apply-CanvasChanges {
    param([string]$Path)
    $raw = Read-Utf8 $Path
    $json = $raw | ConvertFrom-Json
    $changed = $false
    foreach ($node in @($json.nodes)) {
        if ($null -eq $node.file) { continue }
        foreach ($m in $aliasMappings) {
            $old1 = "03_Projects/$($m.AliasFile)"
            $old2 = "03_Projects\$($m.AliasFile)"
            $old3 = $m.AliasFile
            $new = "03_Projects/$($m.CanonicalFile)"
            if ($node.file -eq $old1 -or $node.file -eq $old2 -or $node.file -eq $old3) {
                $node.file = $new
                $changed = $true
            }
        }
    }
    if ($changed) {
        $out = $json | ConvertTo-Json -Depth 100
        Write-Utf8 $Path $out
    }
    return $changed
}

# Validate aliases and block unsafe mappings.
$blockedAliases = @()
$activeMappings = @()
foreach ($m in $aliasMappings) {
    $aliasPath = Join-Path $vaultRoot ("03_Projects\" + $m.AliasFile)
    $canonicalPath = Join-Path $vaultRoot ("03_Projects\" + $m.CanonicalFile)
    $reason = $null

    if (-not (Test-Path $aliasPath)) { $reason = "Alias file missing" }
    elseif (-not (Test-Path $canonicalPath)) { $reason = "Canonical file missing" }
    elseif ($m.AliasFile -eq "EX-IM Expense Invoice Bot.md" -and -not (Test-AliasFrontmatter $aliasPath)) { $reason = "EXIM replacement blocked because source note is not type: alias" }

    if ($reason) {
        $blockedAliases += [pscustomobject]@{ Alias = $m.AliasFile; Canonical = $m.CanonicalFile; Reason = $reason }
    }
    else {
        $activeMappings += $m
    }
}

$markdownPlans = @()
foreach ($file in (Get-ActiveMarkdownFiles)) {
    $raw = Read-Utf8 $file.FullName
    $refs = @()
    $result = Replace-WikiLinksOutsideCodeBlocks $raw $activeMappings ([ref]$refs)
    if ($result.Changed) {
        $markdownPlans += [pscustomobject]@{
            Path = $file.FullName
            Relative = $file.FullName.Substring($vaultRoot.Length).TrimStart('\')
            NewText = $result.Text
            Refs = $refs
        }
    }
}

$canvasPlans = @()
foreach ($relativeCanvas in $canvasFiles) {
    $full = Join-Path $vaultRoot $relativeCanvas
    $changes = @(Get-CanvasChanges $full)
    if ($changes.Count -gt 0) {
        $canvasPlans += [pscustomobject]@{ Path = $full; Relative = $relativeCanvas; Changes = $changes }
    }
}

Write-Host "PPJ Alias Reference Resolution"
Write-Host "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Write-Host ""
Write-Host "Markdown files planned: $($markdownPlans.Count)"
foreach ($plan in $markdownPlans) {
    $groups = $plan.Refs | Group-Object Alias | ForEach-Object { "$($_.Name): $($_.Count)" }
    Write-Host " - $($plan.Relative) [$($groups -join '; ')]"
}
Write-Host ""
Write-Host "Canvas files planned: $($canvasPlans.Count)"
foreach ($plan in $canvasPlans) {
    Write-Host " - $($plan.Relative)"
    foreach ($change in $plan.Changes) { Write-Host "   $($change.Old) -> $($change.New)" }
}
Write-Host ""
Write-Host "Blocked aliases: $($blockedAliases.Count)"
foreach ($b in $blockedAliases) { Write-Host " - $($b.Alias) -> $($b.Canonical): $($b.Reason)" }

$reportLines = New-Object System.Collections.Generic.List[string]
$reportLines.Add("# Alias Reference Resolution Report - $(Get-Date -Format 'yyyyMMdd')")
$reportLines.Add("")
$reportLines.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
$reportLines.Add("")
$reportLines.Add("## Executive Summary")
$reportLines.Add("")
$reportLines.Add("This report identifies active Markdown wiki links and Canvas file-node references that should point from alias notes to canonical project notes. No alias files are moved by this stage.")
$reportLines.Add("")
$reportLines.Add("- Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })")
$reportLines.Add("- Active alias mappings: $($activeMappings.Count)")
$reportLines.Add("- Blocked alias mappings: $($blockedAliases.Count)")
$reportLines.Add("- Markdown files planned/updated: $($markdownPlans.Count)")
$reportLines.Add("- Canvas files planned/updated: $($canvasPlans.Count)")
$reportLines.Add("")
$reportLines.Add("## Alias Mapping Used")
$reportLines.Add("")
$reportLines.Add("| Alias | Canonical | Status |")
$reportLines.Add("|---|---|---|")
foreach ($m in $aliasMappings) {
    $blocked = $blockedAliases | Where-Object { $_.Alias -eq $m.AliasFile }
    $status = if ($blocked) { "Blocked: $($blocked.Reason)" } else { "Active" }
    $reportLines.Add("| $($m.AliasFile) | $($m.CanonicalFile) | $status |")
}
$reportLines.Add("")
$reportLines.Add("## Markdown References Found")
$reportLines.Add("")
if ($markdownPlans.Count -eq 0) { $reportLines.Add("- None.") } else {
    $reportLines.Add("| File | Alias References |")
    $reportLines.Add("|---|---|")
    foreach ($plan in $markdownPlans) {
        $groups = $plan.Refs | Group-Object Alias | ForEach-Object { "$($_.Name): $($_.Count)" }
        $reportLines.Add("| $($plan.Relative) | $($groups -join '; ') |")
    }
}
$reportLines.Add("")
$reportLines.Add("## Canvas References Found")
$reportLines.Add("")
if ($canvasPlans.Count -eq 0) { $reportLines.Add("- None.") } else {
    $reportLines.Add("| Canvas | Old File Path | New File Path |")
    $reportLines.Add("|---|---|---|")
    foreach ($plan in $canvasPlans) {
        foreach ($change in $plan.Changes) { $reportLines.Add("| $($plan.Relative) | $($change.Old) | $($change.New) |") }
    }
}
$reportLines.Add("")
$reportLines.Add("## Blocked Aliases")
$reportLines.Add("")
if ($blockedAliases.Count -eq 0) { $reportLines.Add("- None.") } else { foreach ($b in $blockedAliases) { $reportLines.Add("- $($b.Alias) -> $($b.Canonical): $($b.Reason)") } }
$reportLines.Add("")
$reportLines.Add("## Files Updated or Planned")
$reportLines.Add("")
$reportLines.Add("### Markdown")
if ($markdownPlans.Count -eq 0) { $reportLines.Add("- None.") } else { foreach ($plan in $markdownPlans) { $reportLines.Add("- $($plan.Relative)") } }
$reportLines.Add("")
$reportLines.Add("### Canvas")
if ($canvasPlans.Count -eq 0) { $reportLines.Add("- None.") } else { foreach ($plan in $canvasPlans) { $reportLines.Add("- $($plan.Relative)") } }
$reportLines.Add("")
$reportLines.Add("## Remaining Risks")
$reportLines.Add("")
$reportLines.Add("- Alias notes should not be moved until this script is applied and folder hygiene DryRun confirms backlinks and Canvas references are clear.")
$reportLines.Add("- Historical reports and audit folders are intentionally excluded.")
$reportLines.Add("- Display text is preserved for wiki links with aliases.")
$reportLines.Add("")
$reportLines.Add("## Next Step")
$reportLines.Add("")
$reportLines.Add("1. Review this report.")
$reportLines.Add("2. Run Apply only after approval.")
$reportLines.Add("3. Re-run folder hygiene DryRun after Apply.")

if ($Apply) {
    New-Item -ItemType Directory -Force -Path $auditRoot, $backupRoot | Out-Null
    $script:LogLines = @()
    $script:LogLines += "# Alias Reference Resolution Log - $backupStamp"
    $script:LogLines += ""
    $script:LogLines += "Mode: Apply"
    $script:LogLines += ""

    foreach ($plan in $markdownPlans) {
        Backup-File $plan.Path
        Write-Utf8 $plan.Path $plan.NewText
        $script:LogLines += "- Updated Markdown: $($plan.Relative)"
    }

    foreach ($plan in $canvasPlans) {
        Backup-File $plan.Path
        $changed = Apply-CanvasChanges $plan.Path
        if ($changed) { $script:LogLines += "- Updated Canvas: $($plan.Relative)" }
    }

    $script:LogLines += ""
    $script:LogLines += "## Safety Confirmation"
    $script:LogLines += ""
    $script:LogLines += "- No alias files moved."
    $script:LogLines += "- No files deleted."
    $script:LogLines += "- Historical reports excluded."
    Write-Utf8 $logPath ($script:LogLines -join "`r`n")
}

Write-Utf8 $reportPath ($reportLines -join "`r`n")
Write-Host ""
Write-Host "Report: $reportPath"
if ($Apply) { Write-Host "Log: $logPath" }
if ($DryRun) { Write-Host "DryRun only. No files were modified." }
