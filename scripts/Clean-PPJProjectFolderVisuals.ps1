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
$aliasRoot = Join-Path $projectRoot "_Aliases"
$canvasRoot = Join-Path $projectRoot "Canvas"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRoot = Join-Path $auditRoot "Project_Folder_Hygiene_Backup\$stamp"
$logPath = Join-Path $auditRoot "PROJECT_FOLDER_HYGIENE_LOG_$stamp.md"

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

function Get-WikiBaseName {
    param([string]$Path)
    return [System.IO.Path]::GetFileNameWithoutExtension($Path)
}

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

function Test-InActiveMarkdownRoot {
    param([string]$RelativePath)

    foreach ($root in $activeMarkdownRoots) {
        if ($RelativePath -eq $root -or $RelativePath.StartsWith($root + "\")) {
            return $true
        }
    }

    return $false
}

function Test-NonBlockingMarkdownPath {
    param(
        [string]$RelativePath,
        [string]$OwnRelativePath
    )

    if ($RelativePath -eq $OwnRelativePath) { return $true }
    if ($RelativePath -match '(?i)(^|\\)03_Projects\\_Registry(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)03_Projects\\_Aliases(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)10_Reports(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)99_Attachments(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)(backup|backups|audit|logs?|Project_Cleanup_Backup|Project_Folder_Hygiene_Backup|Alias_Reference_Backup)(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(log|audit|backup|report).*\.md$') { return $true }
    if (-not (Test-InActiveMarkdownRoot $RelativePath)) { return $true }

    return $false
}

function Test-AliasNote {
    param([string]$Text)
    return ($Text -match '(?im)^type\s*:\s*alias\s*$' -or $Text -match '(?im)^status\s*:\s*"?alias"?\s*$')
}

function Test-ProjectNote {
    param([string]$Text)
    return ($Text -match '(?im)^type\s*:\s*project\s*$')
}

function Test-CanonicalProject {
    param([string]$Text)
    return ((Test-ProjectNote $Text) -and -not (Test-AliasNote $Text))
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

function Find-MarkdownBacklinks {
    param(
        [string]$BaseName,
        [string]$OwnPath
    )

    $results = @()
    $escaped = [regex]::Escape($BaseName)
    $pattern = "\[\[$escaped(\||\]\])"
    $ownRelativePath = (Resolve-Path $OwnPath).Path.Substring($vaultRoot.Length).TrimStart('\')

    $mdFiles = @()
    foreach ($root in $activeMarkdownRoots) {
        $fullRoot = Join-Path $vaultRoot $root
        if (Test-Path $fullRoot) {
            $mdFiles += @(Get-ChildItem -Path $fullRoot -Filter "*.md" -File -Recurse)
        }
    }

    foreach ($file in $mdFiles) {
        $relative = $file.FullName.Substring($vaultRoot.Length).TrimStart('\')
        if (Test-NonBlockingMarkdownPath $relative $ownRelativePath) { continue }

        $text = Read-Utf8 $file.FullName
        if ($text -match $pattern) {
            $results += $relative
        }
    }

    return $results
}

function Find-CanvasReferences {
    param(
        [string]$FileName,
        [string]$BaseName
    )

    $results = @()
    $expectedFilePath = "03_Projects/$FileName"

    foreach ($relativeCanvas in $activeCanvasFiles) {
        $canvasPath = Join-Path $vaultRoot $relativeCanvas
        if (-not (Test-Path $canvasPath)) { continue }

        $raw = Read-Utf8 $canvasPath
        $json = $null
        try { $json = $raw | ConvertFrom-Json } catch { $json = $null }
        if ($null -eq $json) { continue }

        foreach ($node in @($json.nodes)) {
            if ($null -ne $node.file -and $node.file -eq $expectedFilePath) {
                $results += $relativeCanvas
                break
            }
        }
    }

    return $results
}

function Get-Classification {
    param([System.IO.FileInfo]$File)

    $text = Read-Utf8 $File.FullName
    $base = Get-WikiBaseName $File.FullName
    $isAlias = Test-AliasNote $text
    $isProject = Test-ProjectNote $text
    $isTiny = $File.Length -le 20
    $isCommand = $File.Name -match '^(PROJECT_COMMAND_CENTER|README|INDEX)' -or $base -match '(?i)(command|index)'
    $isKnownDuplicate = $File.Name -in @(
        "Adhoc Indent miền Nam.md",
        "Adhoc Indent.md",
        "Chuyền Treo IoT Dashboard.md",
        "Chuyền treo ver1.md",
        "Cowash VER2.md",
        "CPD Fabric Database.md",
        "E-commerce Exploration.md",
        "GDI Automation.md",
        "Import Export Automation.md",
        "Market Intelligence.md",
        "PPJ x Nunox.md",
        "PPJ x Stratova AI.md",
        "Sourcing Chatbot v2.3.md",
        "Sourcing VER2.md",
        "Web Tổng Hợp Tool.md"
    )

    $classification = "Non-empty Duplicate Review"
    if ($isCommand) {
        $classification = "Command / Index File"
    }
    elseif ($isAlias) {
        $classification = "Alias Note"
    }
    elseif ($isTiny -and -not $isProject) {
        $classification = "Placeholder / Suspicious"
    }
    elseif (Test-CanonicalProject $text) {
        if ($isKnownDuplicate) {
            $classification = "Non-empty Duplicate Review"
        }
        else {
            $classification = "Canonical Project"
        }
    }
    elseif ($File.Length -gt 20 -and $isKnownDuplicate) {
        $classification = "Non-empty Duplicate Review"
    }
    elseif ($File.Length -gt 20) {
        $classification = "Non-empty Duplicate Review"
    }

    $backlinks = @()
    $canvasRefs = @()
    if ($classification -eq "Alias Note") {
        $backlinks = @(Find-MarkdownBacklinks $base $File.FullName)
        $canvasRefs = @(Find-CanvasReferences $File.Name $base)
    }

    $safeToMove = $false
    $blockedReason = "TBD"
    if ($classification -eq "Alias Note") {
        if ($backlinks.Count -eq 0 -and $canvasRefs.Count -eq 0) {
            $safeToMove = $true
            $blockedReason = "Safe: no Markdown backlinks or Canvas references detected"
        }
        else {
            $reasons = @()
            if ($backlinks.Count -gt 0) { $reasons += "Markdown backlinks: $($backlinks.Count)" }
            if ($canvasRefs.Count -gt 0) { $reasons += "Canvas references: $($canvasRefs.Count)" }
            $blockedReason = ($reasons -join "; ")
        }
    }

    return [pscustomobject]@{
        FileName = $File.Name
        BaseName = $base
        FullName = $File.FullName
        Size = $File.Length
        Classification = $classification
        IsAlias = $isAlias
        SafeToMove = $safeToMove
        BlockedReason = $blockedReason
        BacklinkCount = $backlinks.Count
        CanvasRefCount = $canvasRefs.Count
        Backlinks = $backlinks
        CanvasRefs = $canvasRefs
    }
}

if (-not (Test-Path $projectRoot)) {
    throw "Project root not found: $projectRoot"
}

$topFiles = @(Get-ChildItem -Path $projectRoot -Filter "*.md" -File | Sort-Object Name)
$items = @($topFiles | ForEach-Object { Get-Classification $_ })

$canonical = @($items | Where-Object { $_.Classification -eq "Canonical Project" })
$aliases = @($items | Where-Object { $_.Classification -eq "Alias Note" })
$safeAliases = @($aliases | Where-Object { $_.SafeToMove })
$blockedAliases = @($aliases | Where-Object { -not $_.SafeToMove })
$suspicious = @($items | Where-Object { $_.Classification -eq "Placeholder / Suspicious" })
$duplicates = @($items | Where-Object { $_.Classification -eq "Non-empty Duplicate Review" })
$commands = @($items | Where-Object { $_.Classification -eq "Command / Index File" })

Write-Host "PPJ Project Folder Visual Hygiene"
Write-Host "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Write-Host ""
Write-Host "Summary:"
Write-Host " - Canonical project count: $($canonical.Count)"
Write-Host " - Alias note count: $($aliases.Count)"
Write-Host " - Safe-to-move alias count: $($safeAliases.Count)"
Write-Host " - Blocked alias count: $($blockedAliases.Count)"
Write-Host " - Suspicious tiny file count: $($suspicious.Count)"
Write-Host " - Non-empty duplicate review count: $($duplicates.Count)"
Write-Host " - Command / index file count: $($commands.Count)"
Write-Host ""

Write-Host "Safe-to-move aliases:"
if ($safeAliases.Count -eq 0) { Write-Host " - None" }
foreach ($item in $safeAliases) { Write-Host " - $($item.FileName)" }

Write-Host ""
Write-Host "Blocked aliases:"
if ($blockedAliases.Count -eq 0) { Write-Host " - None" }
foreach ($item in $blockedAliases) { Write-Host " - $($item.FileName): $($item.BlockedReason)" }

Write-Host ""
Write-Host "Suspicious tiny files:"
if ($suspicious.Count -eq 0) { Write-Host " - None" }
foreach ($item in $suspicious) { Write-Host " - $($item.FileName) ($($item.Size) bytes)" }

Write-Host ""
Write-Host "Non-empty duplicates requiring manual review:"
if ($duplicates.Count -eq 0) { Write-Host " - None" }
foreach ($item in $duplicates) { Write-Host " - $($item.FileName) ($($item.Size) bytes)" }

if ($DryRun) {
    Write-Host ""
    Write-Host "DryRun only. No files were moved or modified."
    exit 0
}

New-Item -ItemType Directory -Force -Path $aliasRoot, $auditRoot, $backupRoot | Out-Null
$script:LogLines = @()
$script:LogLines += "# PPJ Project Folder Hygiene Log - $stamp"
$script:LogLines += ""
$script:LogLines += "Mode: Apply"
$script:LogLines += ""
$script:LogLines += "## Summary"
$script:LogLines += ""
$script:LogLines += "- Canonical project count: $($canonical.Count)"
$script:LogLines += "- Alias note count: $($aliases.Count)"
$script:LogLines += "- Safe-to-move alias count: $($safeAliases.Count)"
$script:LogLines += "- Blocked alias count: $($blockedAliases.Count)"
$script:LogLines += "- Suspicious tiny file count: $($suspicious.Count)"
$script:LogLines += "- Non-empty duplicate review count: $($duplicates.Count)"
$script:LogLines += ""
$script:LogLines += "## Operations"
$script:LogLines += ""

foreach ($item in $safeAliases) {
    $destination = Join-Path $aliasRoot $item.FileName
    if ((Test-Path $destination) -and -not $Force) {
        $script:LogLines += "- Skipped because destination exists: $($item.FileName)"
        Write-Host "Skipped, destination exists: $($item.FileName)"
        continue
    }

    Backup-File $item.FullName
    if (Test-Path $destination) {
        Backup-File $destination
    }

    Move-Item -Path $item.FullName -Destination $destination -Force:$Force
    $script:LogLines += "- Moved alias to _Aliases: $($item.FileName)"
    Write-Host "Moved alias to _Aliases: $($item.FileName)"
}

$script:LogLines += ""
$script:LogLines += "## Safety Confirmation"
$script:LogLines += ""
$script:LogLines += "- No files deleted."
$script:LogLines += "- Canonical project files were not moved."
$script:LogLines += "- Suspicious tiny files were not moved."
$script:LogLines += "- Non-empty duplicate review files were not moved."
$script:LogLines += "- Canvas files were not updated."
$script:LogLines += "- Alias notes with backlinks or Canvas references were not moved."

Write-Utf8 $logPath ($script:LogLines -join "`r`n")
Write-Host ""
Write-Host "Apply completed."
Write-Host " - Log: $logPath"
Write-Host " - Backup folder: $backupRoot"
