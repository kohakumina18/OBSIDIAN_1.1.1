param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [switch]$ArchiveOnly,
    [switch]$PatchGuards
)

$ErrorActionPreference = "Stop"
if (-not $Apply) { $DryRun = $true }

$vaultRoot = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$dateStamp = Get-Date -Format "yyyyMMdd"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$backupRoot = Join-Path $auditRoot "Placeholder_Project_Cleanup_Backup\$stamp"
$archiveRoot = Join-Path $vaultRoot "03_Projects\_Archive\Placeholder_Test_Artifacts\$stamp"
$reportPath = Join-Path $vaultRoot "10_Reports\PLACEHOLDER_PROJECT_CLEANUP_REPORT_$dateStamp.md"
$logPath = Join-Path $auditRoot "PLACEHOLDER_PROJECT_CLEANUP_LOG_$stamp.md"

$memoryIndexPath = Join-Path $vaultRoot "03_Projects\_Registry\PPJ_PROJECT_MEMORY_INDEX.md"
$registryPath = Join-Path $vaultRoot "03_Projects\_Registry\PPJ_PROJECT_REGISTRY.md"
$ledgerPath = Join-Path $vaultRoot "03_Projects\_Registry\PPJ_PROJECT_UPDATE_LEDGER.md"
$reportsRoot = Join-Path $vaultRoot "10_Reports"
$auditScanRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$memoryRoot = Join-Path $vaultRoot "03_Projects\_Registry\Project_Memory"
$cpdPath = Join-Path $vaultRoot "03_Projects\CPD.Datamart.v1.1.md"

$scriptTargets = @(
    "scripts\Create-PPJProjectUpdateIntake.ps1",
    "scripts\Update-PPJProjectKnowledgeFromIntake.ps1",
    "scripts\Register-PPJProject.ps1"
)

$placeholderValues = @(
    "PROJECT_NAME",
    "DEPARTMENT",
    "OBJECT",
    "PURPOSE",
    "OUTCOME",
    "PASTE UPDATE HERE",
    "INTAKE_FILE.md",
    "CLUSTER",
    "manual placeholder"
)

$rowPlaceholderValues = @(
    "PROJECT_NAME",
    "DEPARTMENT",
    "OBJECT",
    "PURPOSE",
    "OUTCOME",
    "PASTE UPDATE HERE",
    "INTAKE_FILE.md",
    "CLUSTER"
)

function Read-Utf8 { param([string]$Path) if(Test-Path $Path){ Get-Content -Raw -Encoding UTF8 $Path } else { "" } }
function Write-Utf8 { param([string]$Path,[string]$Text) $dir=Split-Path $Path -Parent; if(-not(Test-Path $dir)){ New-Item -ItemType Directory -Force -Path $dir | Out-Null }; $Text | Set-Content -Encoding UTF8 $Path }
function Get-Relative { param([string]$Path) if(Test-Path $Path){ return (Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\') } return $Path }
function Backup-File { param([string]$Path) if(Test-Path $Path){ $rel=Get-Relative $Path; $target=Join-Path $backupRoot $rel; New-Item -ItemType Directory -Force -Path (Split-Path $target -Parent) | Out-Null; Copy-Item $Path $target -Force; $script:Log += "- Backup: $rel" } }
function Count-Text { param([string]$Text,[string]$Needle) return ([regex]::Matches($Text,[regex]::Escape($Needle))).Count }

function Find-DummyFiles {
    $found = @()
    $paths = @(
        "03_Projects\PROJECT_NAME.v1.1.md",
        "03_Projects\_Registry\Project_Memory\PROJECT_NAME.v1.1.memory.md"
    )
    foreach($rel in $paths){
        $p = Join-Path $vaultRoot $rel
        if(Test-Path $p){ $found += Get-Item $p }
    }
    $intakeRoot = Join-Path $vaultRoot "03_Projects\_Registry\Project_Update_Intake"
    if(Test-Path $intakeRoot){
        $found += Get-ChildItem $intakeRoot -Filter "PROJECT_NAME_INTAKE*.md" -File
    }
    $legacyPatternRoots = @(Join-Path $vaultRoot "03_Projects")
    foreach($root in $legacyPatternRoots){
        if(Test-Path $root){
            $found += Get-ChildItem $root -Recurse -File -Filter "PROJECT_NAME_INTAKE*.md" | Where-Object { $_.FullName -like "*Registry*Project_Update_Intake*" }
        }
    }
    return @($found | Sort-Object FullName -Unique)
}

function Get-MatchingLines {
    param([string]$Path,[string[]]$Needles)
    $rows = @()
    if(-not(Test-Path $Path)){ return @() }
    $lines = Get-Content -Encoding UTF8 $Path
    for($i=0;$i -lt $lines.Count;$i++){
        foreach($needle in $Needles){
            if($lines[$i] -clike "*$needle*"){
                $rows += [pscustomobject]@{ File=(Get-Relative $Path); LineNumber=($i+1); Text=$lines[$i]; Match=$needle }
                break
            }
        }
    }
    return @($rows)
}

function Remove-PlaceholderRows {
    param([string]$Path)
    if(-not(Test-Path $Path)){ return }
    $lines = Get-Content -Encoding UTF8 $Path
    $kept = @()
    foreach($line in $lines){
        if($line -like "*PROJECT_NAME*") { continue }
        $kept += $line
    }
    Write-Utf8 $Path ($kept -join "`r`n")
}

function Test-GuardPresent {
    param([string]$Text)
    return ($Text -like "*PLACEHOLDER_GUARD_START*")
}

function Get-CreateIntakeGuard {
@'
# PLACEHOLDER_GUARD_START
function Test-PPJPlaceholderValue {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
    $forbidden = @("PROJECT_NAME","DEPARTMENT","OBJECT","PURPOSE","OUTCOME","PASTE UPDATE HERE","INTAKE_FILE.md","CLUSTER","manual placeholder")
    foreach ($item in $forbidden) { if ($Value.Trim() -ieq $item -or $Value -like "*$item*") { return $true } }
    return $false
}
if ($Apply) {
    if ([string]::IsNullOrWhiteSpace($RawText) -or $RawText.Trim() -ieq "PASTE UPDATE HERE" -or (Test-PPJPlaceholderValue $RawText)) {
        Write-Host "HARD FAIL: RawText is placeholder or empty"
        exit 1
    }
    if (Test-PPJPlaceholderValue $ProjectName -or Test-PPJPlaceholderValue $OutputPath -or Test-PPJPlaceholderValue $Source) {
        Write-Host "HARD FAIL: Placeholder value detected"
        exit 1
    }
}
# PLACEHOLDER_GUARD_END
'@
}

function Get-RegisterGuard {
@'
# PLACEHOLDER_GUARD_START
function Test-PPJPlaceholderValue {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $true }
    $forbidden = @("PROJECT_NAME","DEPARTMENT","OBJECT","PURPOSE","OUTCOME","PASTE UPDATE HERE","INTAKE_FILE.md","CLUSTER","manual placeholder","TBD")
    foreach ($item in $forbidden) { if ($Value.Trim() -ieq $item -or $Value -like "*$item*") { return $true } }
    return $false
}
if ($Apply) {
    $requiredValues = @($ProjectName,$Department,$Object,$Characteristic,$Cluster,$Outcome)
    foreach ($value in $requiredValues) {
        if (Test-PPJPlaceholderValue $value) {
            Write-Host "HARD FAIL: Placeholder value detected"
            exit 1
        }
    }
}
# PLACEHOLDER_GUARD_END
'@
}

function Get-UpdateGuardTop {
@'
# PLACEHOLDER_GUARD_START
function Test-PPJPlaceholderValue {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
    $forbidden = @("PROJECT_NAME","DEPARTMENT","OBJECT","PURPOSE","OUTCOME","PASTE UPDATE HERE","INTAKE_FILE.md","CLUSTER","manual placeholder")
    foreach ($item in $forbidden) { if ($Value.Trim() -ieq $item -or $Value -like "*$item*") { return $true } }
    return $false
}
if ($Apply) {
    if ([string]::IsNullOrWhiteSpace($InputPath) -or $InputPath -like "*INTAKE_FILE.md*" -or -not (Test-Path $InputPath)) {
        Write-Host "HARD FAIL: InputPath is placeholder or missing"
        exit 1
    }
    if (Test-PPJPlaceholderValue $InputPath -or Test-PPJPlaceholderValue $ProjectName -or Test-PPJPlaceholderValue $Source) {
        Write-Host "HARD FAIL: Placeholder value detected"
        exit 1
    }
}
# PLACEHOLDER_GUARD_END
'@
}

function Get-UpdateNoEventsGuard {
@'
# PLACEHOLDER_NO_EVENTS_GUARD_START
if ($Apply -and $events.Count -eq 0 -and ($UpdateMemory -or $UpdateProjectNote -or $UpdateRegistry) -and -not $Force) {
    Write-Host "HARD FAIL: Extracted update events = 0. Refusing to update memory/index/registry without -Force."
    exit 1
}
# PLACEHOLDER_NO_EVENTS_GUARD_END
'@
}

function Patch-ScriptGuards {
    param([string]$Path)
    $text = Read-Utf8 $Path
    $name = Split-Path $Path -Leaf
    $changes = @()
    if(-not(Test-GuardPresent $text)){
        $guard = if($name -eq "Create-PPJProjectUpdateIntake.ps1"){ Get-CreateIntakeGuard } elseif($name -eq "Register-PPJProject.ps1"){ Get-RegisterGuard } else { Get-UpdateGuardTop }
        $anchor = 'if (-not $Apply) { $DryRun = $true }'
        if($text -like "*$anchor*"){
            $text = $text.Replace($anchor, $anchor + "`r`n`r`n" + $guard.TrimEnd())
            $changes += "Inserted placeholder hard-fail guard"
        }
    }
    if($name -eq "Update-PPJProjectKnowledgeFromIntake.ps1" -and $text -notlike "*PLACEHOLDER_NO_EVENTS_GUARD_START*"){
        $anchor2 = 'if($events.Count -eq 0 -and -not [string]::IsNullOrWhiteSpace($ProjectName)){'
        $insertAfterPattern = '(?s)if\(\$events\.Count -eq 0 -and -not \[string\]::IsNullOrWhiteSpace\(\$ProjectName\)\)\{.*?\r?\n\}'
        $m = [regex]::Match($text,$insertAfterPattern)
        if($m.Success){
            $guard2 = Get-UpdateNoEventsGuard
            $text = $text.Insert($m.Index + $m.Length, "`r`n`r`n" + $guard2.TrimEnd())
            $changes += "Inserted zero-events Apply guard"
        } elseif($text -like "*$anchor2*") {
            $guard2 = Get-UpdateNoEventsGuard
            $text = $text.Replace($anchor2, $guard2.TrimEnd() + "`r`n`r`n" + $anchor2)
            $changes += "Inserted zero-events Apply guard"
        }
    }
    return [pscustomobject]@{ Text=$text; Changes=$changes }
}

function Test-ScriptNeedsGuard {
    param([string]$Path)
    if(-not(Test-Path $Path)){ return $false }
    $text = Read-Utf8 $Path
    $name = Split-Path $Path -Leaf
    if(-not(Test-GuardPresent $text)){ return $true }
    if($name -eq "Update-PPJProjectKnowledgeFromIntake.ps1" -and $text -notlike "*PLACEHOLDER_NO_EVENTS_GUARD_START*"){ return $true }
    return $false
}

$dummyFiles = @(Find-DummyFiles)
$memoryRows = @(Get-MatchingLines $memoryIndexPath $rowPlaceholderValues | Where-Object { $_.Text -like "*PROJECT_NAME*" })
$registryRows = @(Get-MatchingLines $registryPath $rowPlaceholderValues | Where-Object { $_.Text -like "*PROJECT_NAME*" })
$ledgerRows = @(Get-MatchingLines $ledgerPath $rowPlaceholderValues)
$reportRows = @()
if(Test-Path $reportsRoot){
    foreach($r in Get-ChildItem $reportsRoot -Filter "*.md" -File){ $reportRows += Get-MatchingLines $r.FullName $rowPlaceholderValues }
}
$auditRows = @()
if(Test-Path $auditScanRoot){
    foreach($r in Get-ChildItem $auditScanRoot -Filter "*.md" -Recurse -File){ $auditRows += Get-MatchingLines $r.FullName $rowPlaceholderValues }
}
$scriptGuardPlan = @()
foreach($rel in $scriptTargets){
    $path = Join-Path $vaultRoot $rel
    $scriptGuardPlan += [pscustomobject]@{ File=$rel; Exists=(Test-Path $path); NeedsGuard=(Test-ScriptNeedsGuard $path) }
}
$memoryCardCount = if(Test-Path $memoryRoot){ @(Get-ChildItem $memoryRoot -Filter "*.memory.md" -File).Count } else { 0 }
$rootProjectCount = if(Test-Path (Join-Path $vaultRoot "03_Projects")){ @(Get-ChildItem (Join-Path $vaultRoot "03_Projects") -Filter "*.md" -File | Where-Object { $_.Name -ne "PROJECT_NAME.v1.1.md" }).Count } else { 0 }

Write-Host "PPJ Placeholder Project Cleanup"
Write-Host "Mode: $(if($Apply){'Apply'}else{'DryRun'})"
Write-Host "Dummy files found: $($dummyFiles.Count)"
Write-Host "Memory index rows found: $($memoryRows.Count)"
Write-Host "Registry rows found: $($registryRows.Count)"
Write-Host "Ledger rows to mark/report as dummy/test: $($ledgerRows.Count)"
Write-Host "Report references found: $($reportRows.Count)"
Write-Host "Audit references found: $($auditRows.Count)"
Write-Host "Existing project memory card count: $memoryCardCount"
Write-Host "Root real project note count estimate: $rootProjectCount"
Write-Host "CPD.Datamart.v1.1 exists: $(Test-Path $cpdPath)"
Write-Host "Canvas update: No"
Write-Host ""
Write-Host "Dummy files found:"
if($dummyFiles.Count -eq 0){ Write-Host " - None" } else { foreach($f in $dummyFiles){ Write-Host " - $(Get-Relative $f.FullName)" } }
Write-Host ""
Write-Host "Registry rows that would be removed:"
if($registryRows.Count -eq 0){ Write-Host " - None" } else { foreach($r in $registryRows){ Write-Host " - $($r.File):$($r.LineNumber): $($r.Text)" } }
Write-Host ""
Write-Host "Memory index rows that would be removed:"
if($memoryRows.Count -eq 0){ Write-Host " - None" } else { foreach($r in $memoryRows){ Write-Host " - $($r.File):$($r.LineNumber): $($r.Text)" } }
Write-Host ""
Write-Host "Ledger rows that would be marked/reported as dummy/test:"
if($ledgerRows.Count -eq 0){ Write-Host " - None" } else { foreach($r in $ledgerRows){ Write-Host " - $($r.File):$($r.LineNumber): $($r.Text)" } }
Write-Host ""
Write-Host "Scripts requiring guard patch:"
foreach($s in $scriptGuardPlan){ Write-Host " - $($s.File): exists=$($s.Exists); needs_guard=$($s.NeedsGuard)" }
Write-Host ""
Write-Host "DryRun cleanup plan:"
Write-Host " - Backup affected files to $backupRoot"
Write-Host " - Move dummy artifacts to $archiveRoot"
Write-Host " - Remove only PROJECT_NAME placeholder rows from memory index and registry"
Write-Host " - Do not delete historical reports or audit logs"
Write-Host " - Create cleanup report at $reportPath on Apply"
Write-Host " - Patch placeholder hard-fail guards only if -PatchGuards is provided"
Write-Host " - Do not update Canvas, real projects, or real project notes"
Write-Host ""
Write-Host "Next step after cleanup: generate memory cards for all real projects. Coverage estimate: $memoryCardCount memory cards / $rootProjectCount real root project notes."
if($DryRun){ Write-Host "DryRun only. No files were modified."; exit 0 }

New-Item -ItemType Directory -Force -Path $backupRoot,$archiveRoot,$reportsRoot | Out-Null
$script:Log = @("# Placeholder Project Cleanup Log - $stamp", "")

$affectedFiles = @($memoryIndexPath,$registryPath,$ledgerPath) | Where-Object { Test-Path $_ }
if($PatchGuards){ foreach($s in $scriptTargets){ $p=Join-Path $vaultRoot $s; if(Test-Path $p){ $affectedFiles += $p } } }
foreach($f in ($affectedFiles | Select-Object -Unique)){ Backup-File $f }
foreach($f in $dummyFiles){ Backup-File $f.FullName }

foreach($f in $dummyFiles){
    $rel = Get-Relative $f.FullName
    $dest = Join-Path $archiveRoot $rel
    New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent) | Out-Null
    Move-Item -Path $f.FullName -Destination $dest -Force
    $script:Log += "- Archived dummy file: $rel"
}

if($memoryRows.Count -gt 0){ Remove-PlaceholderRows $memoryIndexPath; $script:Log += "- Removed PROJECT_NAME rows from PPJ_PROJECT_MEMORY_INDEX.md" }
if($registryRows.Count -gt 0){ Remove-PlaceholderRows $registryPath; $script:Log += "- Removed PROJECT_NAME rows from PPJ_PROJECT_REGISTRY.md" }

$patchedScripts = @()
if($PatchGuards){
    foreach($rel in $scriptTargets){
        $path = Join-Path $vaultRoot $rel
        if(-not(Test-Path $path)){ continue }
        $patch = Patch-ScriptGuards $path
        if($patch.Changes.Count -gt 0 -or $Force){
            Write-Utf8 $path $patch.Text
            $patchedScripts += $rel
            foreach($c in $patch.Changes){ $script:Log += "- Patched ${rel}: $c" }
        }
    }
}

$report = @()
$report += "# Placeholder Project Cleanup Report - $dateStamp"
$report += ""
$report += "## Executive Summary"
$report += ""
$report += "Placeholder PROJECT_NAME artifacts were detected and cleanup was executed without deleting files permanently. Dummy artifacts were archived. Real project notes and Canvas were not modified."
$report += ""
$report += "## Placeholder Artifacts Found"
if($dummyFiles.Count -eq 0){ $report += "- None" } else { foreach($f in $dummyFiles){ $report += "- $(Get-Relative $f.FullName)" } }
$report += ""
$report += "## Registry / Index Cleanup"
$report += ""
$report += "- Memory index rows removed: $($memoryRows.Count)"
$report += "- Registry rows removed: $($registryRows.Count)"
$report += "- Ledger rows reported as dummy/test: $($ledgerRows.Count)"
$report += ""
$report += "## Files Archived"
if($dummyFiles.Count -eq 0){ $report += "- None" } else { foreach($f in $dummyFiles){ $report += "- $(Get-Relative $f.FullName)" } }
$report += ""
$report += "## Script Guard Patches"
if($patchedScripts.Count -eq 0){ $report += "- None" } else { foreach($p in $patchedScripts){ $report += "- $p" } }
$report += ""
$report += "## Remaining Manual Review"
$report += ""
$report += "- Review ledger/report/audit references for placeholder entries if needed. Historical audit logs were not deleted."
$report += ""
$report += "## Next Step"
$report += ""
$report += "Generate memory cards for all real projects. Current estimate: $memoryCardCount memory cards / $rootProjectCount real root project notes."
Write-Utf8 $reportPath ($report -join "`r`n")
$script:Log += "- Wrote report: $(Get-Relative $reportPath)"
Write-Utf8 $logPath ($script:Log -join "`r`n")
Write-Host "Apply completed. Log: $logPath"
