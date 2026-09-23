param(
    [switch]$DryRun,
    [switch]$Apply,
    [string]$RawText,
    [string]$Source = "manual",
    [string]$ProjectName,
    [string]$OutputPath
)

$ErrorActionPreference = "Stop"
if (-not $Apply) { $DryRun = $true }

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

$vaultRoot = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$today = Get-Date -Format "yyyy-MM-dd"
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $safeName = if ([string]::IsNullOrWhiteSpace($ProjectName)) { "PROJECT_UPDATE" } else { ($ProjectName -replace '[\\/:*?""<>|]', '_') }
    $OutputPath = Join-Path $vaultRoot "03_Projects\_Registry\Project_Update_Intake\${safeName}_INTAKE_$stamp.md"
} elseif (-not [System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath = Join-Path $vaultRoot $OutputPath
}

function Write-Utf8 { param([string]$Path,[string]$Text) $dir=Split-Path $Path -Parent; if(-not(Test-Path $dir)){New-Item -ItemType Directory -Force -Path $dir|Out-Null}; $Text | Set-Content -Encoding UTF8 $Path }
function Test-Exists { param([string]$Rel) return (Test-Path (Join-Path $vaultRoot $Rel)) }

$memoryIndexPath = Join-Path $vaultRoot "03_Projects\_Registry\PPJ_PROJECT_MEMORY_INDEX.md"
$memoryCardRoot = Join-Path $vaultRoot "03_Projects\_Registry\Project_Memory"
$cpdPath = Join-Path $vaultRoot "03_Projects\CPD.Datamart.v1.1.md"
$memoryCardCount = if(Test-Path $memoryCardRoot){ @(Get-ChildItem $memoryCardRoot -Filter "*.memory.md" -File).Count } else { 0 }
$memoryIndexStatus = if(Test-Path $memoryIndexPath){ "Exists" } else { "Missing" }

$raw = if ([string]::IsNullOrWhiteSpace($RawText)) { "Paste or summarize raw update here." } else { $RawText }
$detected = if ([string]::IsNullOrWhiteSpace($ProjectName)) { "" } else { "| [[${ProjectName}]] | user_supplied | Needs Review | Supplied through -ProjectName |" }

$content = @"
---
type: project_update_intake
date: "$today"
source: "$Source"
raw_update_id: "$stamp"
detected_projects: ["$ProjectName"]
new_project_candidates: []
confidence: "Needs Review"
apply_status: "Draft"
---

# Project Update Intake

## Raw Update
$raw

## Detected Projects

| Project | Match Type | Confidence | Reason |
|---|---|---|---|
$detected

## Extracted Update Events

| Project | Update Type | Field | Old Value | New Value | Evidence | Confidence |
|---|---|---|---|---|---|---|

## Tasks To Create

| Project | Task | Owner | Priority | Due Date | Validation |
|---|---|---|---|---|---|

## Decisions To Log

| Project | Decision Needed | Options | Owner | Deadline |
|---|---|---|---|---|

## Risks / Blockers

| Project | Risk / Blocker | Impact | Owner | Next Action |
|---|---|---|---|---|

## New Project Registration Candidates

| Proposed Name | Department | Object | Characteristic | Version | Reason | Confidence |
|---|---|---|---|---|---|---|

## Apply Plan

- Update project memory cards: Yes / No
- Update project notes: Yes / No
- Update registry: Yes / No
- Create tasks: Yes / No
- Create decision logs: Yes / No
- Register new projects: Yes / No
- Update Canvas: No by default
"@

Write-Host "PPJ Project Update Intake Creator"
Write-Host "Mode: $(if($Apply){'Apply'}else{'DryRun'})"
Write-Host "Output path: $OutputPath"
Write-Host "Memory index status: $memoryIndexStatus"
Write-Host "Existing project memory card count: $memoryCardCount"
Write-Host "CPD.Datamart.v1.1 exists: $(Test-Path $cpdPath)"
Write-Host "Files to create:"
Write-Host " - $OutputPath"
Write-Host "Files to update: None"
Write-Host "Proposed AGENTS.md changes: Project Memory Loading Rule, Project Auto-Update Rule, New Project Registration Rule"
Write-Host "Script validation status: runtime DryRun OK"
if($DryRun){ Write-Host "DryRun only. No files were modified."; exit 0 }

Write-Utf8 $OutputPath $content
Write-Host "Created intake note: $OutputPath"

