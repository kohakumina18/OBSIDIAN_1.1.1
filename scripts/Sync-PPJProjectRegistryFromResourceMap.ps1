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
$registryRoot = Join-Path $projectRoot "_Registry"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$backupRoot = Join-Path $vaultRoot "99_Attachments\Project_Registry_Sync_Backup"

$resourceMatrixPath = Join-Path $registryRoot "PPJ_PROJECT_RESOURCE_MATRIX.md"
$aliasMapPath = Join-Path $registryRoot "PPJ_PROJECT_ALIAS_MAP.md"
$stamp = Get-Date -Format "yyyyMMdd_HHmm"
$logPath = Join-Path $auditRoot "PROJECT_RESOURCE_SYNC_LOG_$stamp.md"
$backupRunRoot = Join-Path $backupRoot $stamp

New-Item -ItemType Directory -Force -Path $registryRoot, $auditRoot, $backupRoot | Out-Null

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
    $target = Join-Path $backupRunRoot $relative
    $targetDir = Split-Path $target -Parent
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item $Path $target -Force
    $script:Log += "- Backup: $relative"
}

function ConvertTo-SafeValue {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return "TBD" }
    return ($Value.Trim() -replace '[\r\n]+', ' ')
}

function Get-ProjectBaseName {
    param([string]$FileName)
    return [System.IO.Path]::GetFileNameWithoutExtension($FileName)
}

function Parse-ResourceMatrix {
    param([string]$Path)

    $items = @()
    $raw = Read-Utf8 $Path
    if ([string]::IsNullOrWhiteSpace($raw)) {
        throw "Resource matrix not found or empty: $Path"
    }

    $lines = $raw -split "`r?`n"
    foreach ($line in $lines) {
        if ($line -notmatch '^\| \[\[') { continue }
        $cells = $line.Trim('|') -split '\|'
        if ($cells.Count -lt 14) { continue }

        $projectCell = $cells[0].Trim()
        $projectName = $projectCell -replace '^\[\[', '' -replace '\]\]$', ''

        $phaseProgress = $cells[2].Trim()
        $phase = "TBD"
        $progress = "TBD"
        if ($phaseProgress -match '(.+?)\s*/\s*(.+)') {
            $phase = ConvertTo-SafeValue ($matches[1] -replace '\[\[|\]\]', '')
            $progress = ConvertTo-SafeValue $matches[2]
        }

        $items += [pscustomobject]@{
            ProjectName = ConvertTo-SafeValue $projectName
            AliasNames = ConvertTo-SafeValue $cells[1]
            Phase = $phase
            Progress = $progress
            BA = ConvertTo-SafeValue $cells[3]
            Technical = ConvertTo-SafeValue $cells[4]
            Department = ConvertTo-SafeValue $cells[5]
            PortfolioGroup = ConvertTo-SafeValue $cells[6]
            WorkloadRisk = ConvertTo-SafeValue $cells[7]
            Priority = ConvertTo-SafeValue $cells[8]
            Blocker = ConvertTo-SafeValue $cells[9]
            DecisionNeeded = ConvertTo-SafeValue $cells[10]
            NextAction = ConvertTo-SafeValue $cells[11]
            SourceFile = ConvertTo-SafeValue $cells[12]
        }
    }

    return $items
}

function Test-SectionExists {
    param(
        [string]$Text,
        [string]$Heading
    )
    return ($Text -match "(?im)^##\s+$([regex]::Escape($Heading))\s*$")
}

function New-GovernanceAppendix {
    param([pscustomobject]$Item)

    return @"

---

## Project Resource Governance

BA / Coordination:
$($Item.BA)

Technical Members:
$($Item.Technical)

Business Stakeholder / Department:
$($Item.Department)

Portfolio Group:
$($Item.PortfolioGroup)

Priority:
$($Item.Priority)

Phase:
$($Item.Phase)

Progress:
$($Item.Progress)

Blocker:
$($Item.Blocker)

Decision Needed:
$($Item.DecisionNeeded)

Next Action:
$($Item.NextAction)

Workload Risk:
$($Item.WorkloadRisk)

Source:
[[PPJ_PROJECT_RESOURCE_MATRIX]]
"@
}

$script:Log = @()
$script:Log += "# PPJ Project Resource Sync Log - $stamp"
$script:Log += ""
$script:Log += "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
$script:Log += "Force: $Force"
$script:Log += ""

if (-not (Test-Path $resourceMatrixPath)) {
    throw "Missing resource matrix: $resourceMatrixPath"
}

if (-not (Test-Path $aliasMapPath)) {
    throw "Missing alias map: $aliasMapPath"
}

$resourceItems = @(Parse-ResourceMatrix $resourceMatrixPath)
$updated = 0
$skippedMissing = 0
$skippedExisting = 0

Write-Host "PPJ Resource Matrix Sync"
Write-Host "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Write-Host "Resource items: $($resourceItems.Count)"
Write-Host ""

foreach ($item in $resourceItems) {
    if ($item.SourceFile -eq "TBD") {
        $skippedMissing++
        $script:Log += "- Missing source file for project: $($item.ProjectName)"
        continue
    }

    $projectPath = Join-Path $projectRoot $item.SourceFile
    if (-not (Test-Path $projectPath)) {
        $skippedMissing++
        $script:Log += "- Project note not found: $($item.SourceFile)"
        Write-Host "Missing project note: $($item.SourceFile)"
        continue
    }

    $raw = Read-Utf8 $projectPath
    if (Test-SectionExists $raw "Project Resource Governance") {
        $skippedExisting++
        $script:Log += "- Governance section already exists: $($item.SourceFile)"
        Write-Host "Skip existing governance section: $($item.SourceFile)"
        continue
    }

    $appendix = New-GovernanceAppendix $item
    $updated++
    $script:Log += "- Append resource governance: $($item.SourceFile)"

    if ($Apply) {
        Backup-File $projectPath
        Add-Content -Encoding UTF8 -Path $projectPath -Value $appendix
        Write-Host "Updated: $($item.SourceFile)"
    }
    else {
        Write-Host "DryRun: would append resource governance to $($item.SourceFile)"
    }
}

$script:Log += ""
$script:Log += "## Summary"
$script:Log += ""
$script:Log += "- Resource items read: $($resourceItems.Count)"
$script:Log += "- Project notes planned/applied: $updated"
$script:Log += "- Missing project notes skipped: $skippedMissing"
$script:Log += "- Existing governance sections skipped: $skippedExisting"
$script:Log += ""
$script:Log += "## Safety Rules"
$script:Log += ""
$script:Log += "- No files are deleted."
$script:Log += "- Existing project content is not overwritten."
$script:Log += "- Apply mode backs up affected files before appending."
$script:Log += "- DryRun is the default behavior."

Write-Utf8 $logPath ($script:Log -join "`r`n")

Write-Host ""
Write-Host "Summary:"
Write-Host " - Resource items read: $($resourceItems.Count)"
Write-Host " - Project notes planned/applied: $updated"
Write-Host " - Missing project notes skipped: $skippedMissing"
Write-Host " - Existing governance sections skipped: $skippedExisting"
Write-Host " - Log: $logPath"

if ($DryRun) {
    Write-Host ""
    Write-Host "DryRun only. No project notes were modified."
}
