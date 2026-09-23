$ErrorActionPreference = "Stop"

$vaultRoot = (Get-Location).Path
$reportPath = Join-Path $vaultRoot ("10_Reports\ALIAS_BLOCKER_DIAGNOSIS_" + (Get-Date -Format "yyyyMMdd") + ".md")

$aliasFiles = @(
    "Adhoc Indent.md",
    "Cowash VER2.md",
    "CPD Fabric Database.md",
    "E-commerce Exploration.md",
    "EX-IM Expense Invoice Bot.md",
    "GDI Automation.md",
    "Import Export Automation.md",
    "Market Intelligence.md",
    "PPJ x Nunox.md",
    "PPJ x Stratova AI.md"
)

$activeRoots = @(
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

function Test-InActiveRoot {
    param([string]$RelativePath)
    foreach ($root in $activeRoots) {
        if ($RelativePath -eq $root -or $RelativePath.StartsWith($root + "\")) { return $true }
    }
    return $false
}

function Test-NonBlockingMarkdownPath {
    param(
        [string]$RelativePath,
        [string]$AliasRelativePath
    )

    if ($RelativePath -eq $AliasRelativePath) { return "Non-blocking: alias note self-content" }
    if ($RelativePath -match '(?i)(^|\\)03_Projects\\_Registry(\\|$)') { return "Non-blocking: project registry or alias map metadata" }
    if ($RelativePath -match '(?i)(^|\\)03_Projects\\_Aliases(\\|$)') { return "Non-blocking: alias storage folder" }
    if ($RelativePath -match '(?i)(^|\\)10_Reports(\\|$)') { return "Non-blocking: report or historical report" }
    if ($RelativePath -match '(?i)(^|\\)99_Attachments(\\|$)') { return "Non-blocking: attachment, audit, backup, or log" }
    if ($RelativePath -match '(?i)(^|\\)(backup|backups|audit|logs?|Project_Cleanup_Backup|Project_Folder_Hygiene_Backup|Alias_Reference_Backup)(\\|$)') { return "Non-blocking: backup, audit, or log folder" }
    if ($RelativePath -match '(?i)(log|audit|backup|report).*\.md$') { return "Non-blocking: log, audit, backup, or report file" }
    if (-not (Test-InActiveRoot $RelativePath)) { return "Non-blocking: outside active Markdown roots" }
    return $null
}

function Find-MarkdownReferences {
    param([string]$AliasFile)

    $aliasBase = Get-BaseName $AliasFile
    $aliasRelativePath = "03_Projects\$AliasFile"
    $escaped = [regex]::Escape($aliasBase)
    $pattern = "\[\[$escaped(\||\]\])"
    $results = @()

    $mdFiles = @(Get-ChildItem -Path $vaultRoot -Filter "*.md" -File -Recurse | Where-Object {
        $_.FullName -notmatch '\\.obsidian\\' -and $_.FullName -notmatch '\\.git\\'
    })

    foreach ($file in $mdFiles) {
        $relative = Get-RelativePath $file.FullName
        $lines = Get-Content -Encoding UTF8 $file.FullName
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match $pattern) {
                $nonBlockingReason = Test-NonBlockingMarkdownPath $relative $aliasRelativePath
                $classification = if ($nonBlockingReason) { $nonBlockingReason } else { "Blocking: active Markdown note reference" }
                $results += [pscustomobject]@{
                    Alias = $AliasFile
                    File = $relative
                    LineNumber = $i + 1
                    Line = $lines[$i].Trim()
                    Classification = $classification
                    IsBlocking = -not [bool]$nonBlockingReason
                }
            }
        }
    }

    return $results
}

function Find-CanvasReferences {
    param([string]$AliasFile)

    $aliasBase = Get-BaseName $AliasFile
    $expectedPath = "03_Projects/$AliasFile"
    $expectedPathBackslash = "03_Projects\$AliasFile"
    $results = @()

    $allCanvas = @(Get-ChildItem -Path $vaultRoot -Filter "*.canvas" -File -Recurse | Where-Object {
        $_.FullName -notmatch '\\.git\\' -and $_.FullName -notmatch '\\.obsidian\\'
    })

    foreach ($canvas in $allCanvas) {
        $relative = Get-RelativePath $canvas.FullName
        $raw = Read-Utf8 $canvas.FullName
        $isActiveCanvas = $activeCanvasFiles -contains $relative
        $parsed = $null
        try { $parsed = $raw | ConvertFrom-Json } catch { $parsed = $null }

        if ($null -ne $parsed) {
            foreach ($node in @($parsed.nodes)) {
                if ($null -ne $node.file) {
                    $isAliasFileNode = ($node.file -eq $expectedPath -or $node.file -eq $expectedPathBackslash -or $node.file -eq $AliasFile)
                    if ($isAliasFileNode) {
                        $classification = if ($isActiveCanvas) { "Blocking: active Canvas file node points to alias file" } else { "Non-blocking: backup or non-active Canvas file node" }
                        $results += [pscustomobject]@{
                            Alias = $AliasFile
                            Canvas = $relative
                            NodeId = $node.id
                            NodeType = $node.type
                            Field = "file"
                            Value = $node.file
                            Classification = $classification
                            IsBlocking = $isActiveCanvas
                        }
                    }
                }
            }
        }

        if ($raw -like "*$AliasFile*" -or $raw -like "*$aliasBase*") {
            $alreadyBlockingFileNode = @($results | Where-Object { $_.Alias -eq $AliasFile -and $_.Canvas -eq $relative -and $_.IsBlocking }).Count -gt 0
            if (-not $alreadyBlockingFileNode) {
                $classification = if ($isActiveCanvas) { "Non-blocking: alias appears only in Canvas text, label, group, or metadata" } else { "Non-blocking: alias appears only in backup or non-active Canvas text" }
                $results += [pscustomobject]@{
                    Alias = $AliasFile
                    Canvas = $relative
                    NodeId = ""
                    NodeType = "raw-text"
                    Field = "raw"
                    Value = $aliasBase
                    Classification = $classification
                    IsBlocking = $false
                }
            }
        }
    }

    return $results
}

$markdownRefs = @()
$canvasRefs = @()
foreach ($alias in $aliasFiles) {
    $markdownRefs += @(Find-MarkdownReferences $alias)
    $canvasRefs += @(Find-CanvasReferences $alias)
}

$blockingMarkdown = @($markdownRefs | Where-Object { $_.IsBlocking })
$nonBlockingMarkdown = @($markdownRefs | Where-Object { -not $_.IsBlocking })
$blockingCanvas = @($canvasRefs | Where-Object { $_.IsBlocking })
$nonBlockingCanvas = @($canvasRefs | Where-Object { -not $_.IsBlocking })

$safeAliases = @()
foreach ($alias in $aliasFiles) {
    $bm = @($blockingMarkdown | Where-Object { $_.Alias -eq $alias }).Count
    $bc = @($blockingCanvas | Where-Object { $_.Alias -eq $alias }).Count
    if ($bm -eq 0 -and $bc -eq 0) { $safeAliases += $alias }
}

$report = New-Object System.Collections.Generic.List[string]
$report.Add("# Alias Blocker Diagnosis - $(Get-Date -Format 'yyyyMMdd')")
$report.Add("")
$report.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
$report.Add("")
$report.Add("## Executive Summary")
$report.Add("")
$report.Add("This diagnosis separates real movement blockers from non-blocking metadata, audit, report, backup, alias self-content, and Canvas text mentions.")
$report.Add("")
$report.Add("- Alias notes scanned: $($aliasFiles.Count)")
$report.Add("- Blocking Markdown references: $($blockingMarkdown.Count)")
$report.Add("- Non-blocking Markdown references: $($nonBlockingMarkdown.Count)")
$report.Add("- Blocking Canvas file-node references: $($blockingCanvas.Count)")
$report.Add("- Non-blocking Canvas mentions: $($nonBlockingCanvas.Count)")
$report.Add("- Aliases safe by precise blocker logic: $($safeAliases.Count)")
$report.Add("")
$report.Add("## Alias Blocker Summary")
$report.Add("")
$report.Add("| Alias | Blocking Markdown | Blocking Canvas File Nodes | Safe By Diagnosis |")
$report.Add("|---|---:|---:|---|")
foreach ($alias in $aliasFiles) {
    $bm = @($blockingMarkdown | Where-Object { $_.Alias -eq $alias }).Count
    $bc = @($blockingCanvas | Where-Object { $_.Alias -eq $alias }).Count
    $safe = if ($bm -eq 0 -and $bc -eq 0) { "Yes" } else { "No" }
    $report.Add("| $alias | $bm | $bc | $safe |")
}
$report.Add("")
$report.Add("## Exact Blocking Markdown References")
$report.Add("")
if ($blockingMarkdown.Count -eq 0) { $report.Add("- None.") } else {
    $report.Add("| Alias | File | Line | Matched Line | Classification |")
    $report.Add("|---|---|---:|---|---|")
    foreach ($r in $blockingMarkdown) { $report.Add("| $($r.Alias) | $($r.File) | $($r.LineNumber) | $($r.Line.Replace('|','/')) | $($r.Classification) |") }
}
$report.Add("")
$report.Add("## Exact Non-Blocking Markdown References")
$report.Add("")
if ($nonBlockingMarkdown.Count -eq 0) { $report.Add("- None.") } else {
    $report.Add("| Alias | File | Line | Matched Line | Classification |")
    $report.Add("|---|---|---:|---|---|")
    foreach ($r in $nonBlockingMarkdown) { $report.Add("| $($r.Alias) | $($r.File) | $($r.LineNumber) | $($r.Line.Replace('|','/')) | $($r.Classification) |") }
}
$report.Add("")
$report.Add("## Exact Blocking Canvas File Nodes")
$report.Add("")
if ($blockingCanvas.Count -eq 0) { $report.Add("- None.") } else {
    $report.Add("| Alias | Canvas | Node Id | Field | Value | Classification |")
    $report.Add("|---|---|---|---|---|---|")
    foreach ($r in $blockingCanvas) { $report.Add("| $($r.Alias) | $($r.Canvas) | $($r.NodeId) | $($r.Field) | $($r.Value) | $($r.Classification) |") }
}
$report.Add("")
$report.Add("## Exact Non-Blocking Canvas Mentions")
$report.Add("")
if ($nonBlockingCanvas.Count -eq 0) { $report.Add("- None.") } else {
    $report.Add("| Alias | Canvas | Node Id | Field | Value | Classification |")
    $report.Add("|---|---|---|---|---|---|")
    foreach ($r in $nonBlockingCanvas) { $report.Add("| $($r.Alias) | $($r.Canvas) | $($r.NodeId) | $($r.Field) | $($r.Value) | $($r.Classification) |") }
}
$report.Add("")
$report.Add("## Why Folder Hygiene Still Shows Blocked")
$report.Add("")
$report.Add("The previous folder hygiene logic scanned the whole vault for Markdown backlinks and searched raw Canvas text. That made non-blocking references look like movement blockers, including alias note self-content, registry metadata, reports, audit logs, backups, and Canvas text labels.")
$report.Add("")
$report.Add("## Recommended Script Patch")
$report.Add("")
$report.Add("Patch folder hygiene logic so aliases are blocked only by active Markdown references outside excluded folders and by active Canvas JSON file nodes whose file property exactly points to 03_Projects/Alias Filename.md.")
$report.Add("")
$report.Add("## Next Action")
$report.Add("")
$report.Add("1. Patch Clean-PPJProjectFolderVisuals.ps1 blocker logic.")
$report.Add("2. Syntax-check the patched script.")
$report.Add("3. Run DryRun only.")
$report.Add("4. Run Apply only after approval.")

Write-Utf8 $reportPath ($report -join "`r`n")

Write-Host "PPJ Alias Blocker Diagnosis"
Write-Host "Report: $reportPath"
Write-Host "Blocking Markdown references: $($blockingMarkdown.Count)"
Write-Host "Blocking Canvas file-node references: $($blockingCanvas.Count)"
Write-Host "Safe aliases by diagnosis: $($safeAliases.Count)"
foreach ($alias in $safeAliases) { Write-Host " - $alias" }
