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
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRoot = Join-Path $auditRoot "Post_Cleanup_Fix_Backup\$stamp"
$logPath = Join-Path $auditRoot "POST_CLEANUP_FIX_LOG_$stamp.md"

$webTongVnName = ("Web T{0}ng H{1}p Tool" -f [char]0x1ED5, [char]0x1EE3)
$webAliasFiles = @("Web Tong Hop Tool.md", "$webTongVnName.md")
$canvasFiles = @(
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

function Test-AliasNote {
    param([string]$Text)
    return ($Text -match '(?im)^type\s*:\s*alias\s*$' -or $Text -match '(?im)^status\s*:\s*"?alias"?\s*$')
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

function Get-CanvasOldPathRefs {
    $refs = @()
    foreach ($relativeCanvas in $canvasFiles) {
        $canvasPath = Join-Path $vaultRoot $relativeCanvas
        if (-not (Test-Path $canvasPath)) { continue }
        $raw = Read-Utf8 $canvasPath
        $json = $null
        try { $json = $raw | ConvertFrom-Json } catch { $json = $null }
        if ($null -eq $json) { continue }
        foreach ($node in @($json.nodes)) {
            if ($null -eq $node.file) { continue }
            if ($node.file -match 'Web Tong Hop|Web Tong HopTool|Web Tổng Hợp') {
                $refs += [pscustomobject]@{ Canvas = $relativeCanvas; NodeId = $node.id; OldFile = $node.file; NewFile = "03_Projects/PPJ.AI.Hub.md" }
            }
        }
    }
    return $refs
}

function Update-CanvasOldPathRefs {
    param([string]$Path)
    $raw = Read-Utf8 $Path
    $json = $raw | ConvertFrom-Json
    $changed = $false
    foreach ($node in @($json.nodes)) {
        if ($null -eq $node.file) { continue }
        if ($node.file -match 'Web Tong Hop|Web Tong HopTool|Web Tổng Hợp') {
            $node.file = "03_Projects/PPJ.AI.Hub.md"
            $changed = $true
        }
    }
    if ($changed) { Write-Utf8 $Path ($json | ConvertTo-Json -Depth 100) }
    return $changed
}

$rootAliasPlans = @()
foreach ($fileName in $webAliasFiles) {
    $path = Join-Path $projectRoot $fileName
    $destination = Join-Path $aliasRoot $fileName
    $exists = Test-Path $path
    $text = Read-Utf8 $path
    $isAlias = Test-AliasNote $text
    $destinationExists = Test-Path $destination
    $safe = ($exists -and $isAlias -and (-not $destinationExists -or $Force))
    $reason = if (-not $exists) { "Source missing" } elseif (-not $isAlias) { "Source is not alias note" } elseif ($destinationExists -and -not $Force) { "Destination exists; use -Force after review" } else { "Safe to move to _Aliases" }
    $rootAliasPlans += [pscustomobject]@{ FileName = $fileName; Source = $path; Destination = $destination; Exists = $exists; IsAlias = $isAlias; Safe = $safe; Reason = $reason }
}

$canvasPlans = @(Get-CanvasOldPathRefs)
$hubPath = Join-Path $projectRoot "PPJ.AI.Hub.md"
$hubText = Read-Utf8 $hubPath
$hubFenceIssue = ($hubText -match '(?m)^`markdown\s*$' -or $hubText -match '(?m)^`\s*$')

Write-Host "Post-Cleanup Integrity Fix Plan"
Write-Host "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Write-Host ""
Write-Host "Root alias move plans:"
foreach ($plan in $rootAliasPlans) {
    Write-Host " - $($plan.FileName): safe=$($plan.Safe); $($plan.Reason)"
}
Write-Host ""
Write-Host "Canvas old Web path refs: $($canvasPlans.Count)"
foreach ($plan in $canvasPlans) {
    Write-Host " - $($plan.Canvas) node=$($plan.NodeId): $($plan.OldFile) -> $($plan.NewFile)"
}
Write-Host ""
Write-Host "PPJ.AI.Hub preserved-content code fence issue: $hubFenceIssue"
Write-Host ""

if ($DryRun) {
    Write-Host "DryRun only. No files were moved or modified."
    exit 0
}

New-Item -ItemType Directory -Force -Path $auditRoot, $backupRoot, $aliasRoot | Out-Null
$script:LogLines = @()
$script:LogLines += "# Post-Cleanup Integrity Fix Log - $stamp"
$script:LogLines += ""
$script:LogLines += "Mode: Apply"
$script:LogLines += ""

foreach ($plan in $rootAliasPlans) {
    if (-not $plan.Safe) {
        $script:LogLines += "- Skipped alias move: $($plan.FileName) - $($plan.Reason)"
        continue
    }
    Backup-File $plan.Source
    if (Test-Path $plan.Destination) { Backup-File $plan.Destination }
    Move-Item -Path $plan.Source -Destination $plan.Destination -Force:$Force
    $script:LogLines += "- Moved alias to _Aliases: $($plan.FileName)"
}

foreach ($relativeCanvas in ($canvasPlans | Select-Object -ExpandProperty Canvas -Unique)) {
    $canvasPath = Join-Path $vaultRoot $relativeCanvas
    Backup-File $canvasPath
    if (Update-CanvasOldPathRefs $canvasPath) {
        $script:LogLines += "- Fixed Canvas Web path refs: $relativeCanvas"
    }
}

if ($hubFenceIssue -and (Test-Path $hubPath)) {
    Backup-File $hubPath
    $fixed = $hubText -replace '(?m)^`markdown\s*$', '```markdown'
    $fixed = $fixed -replace '(?m)^`\s*$', '```'
    Write-Utf8 $hubPath $fixed
    $script:LogLines += "- Fixed PPJ.AI.Hub preserved-content code fence formatting"
}

$script:LogLines += ""
$script:LogLines += "## Safety Confirmation"
$script:LogLines += ""
$script:LogLines += "- No files deleted."
$script:LogLines += "- GLPI and PERRI placeholder notes were not touched."
$script:LogLines += "- Only Web alias movement, old Web Canvas paths, and PPJ.AI.Hub code-fence formatting are in scope."
Write-Utf8 $logPath ($script:LogLines -join "`r`n")

Write-Host "Apply completed."
Write-Host " - Log: $logPath"
Write-Host " - Backup folder: $backupRoot"
