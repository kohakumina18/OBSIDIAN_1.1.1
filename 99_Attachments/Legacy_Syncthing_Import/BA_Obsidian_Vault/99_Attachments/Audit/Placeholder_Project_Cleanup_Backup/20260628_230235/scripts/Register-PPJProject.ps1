param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [string]$ProjectName,
    [string]$Department,
    [string]$Object,
    [string]$Characteristic,
    [string]$Version,
    [string]$Cluster,
    [string]$Phase,
    [string]$Priority,
    [string]$Outcome,
    [string]$BusinessOwner,
    [string]$BA,
    [string[]]$TechnicalMembers,
    [switch]$CreateCanvasCard
)

$ErrorActionPreference = "Stop"
if (-not $Apply) { $DryRun = $true }

$vaultRoot = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$today = Get-Date -Format "yyyy-MM-dd"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$backupRoot = Join-Path $auditRoot "Project_Knowledge_Auto_Update_Backup\$stamp"
$logPath = Join-Path $auditRoot "PROJECT_REGISTRATION_LOG_$stamp.md"
$projectRoot = Join-Path $vaultRoot "03_Projects"
$registryPath = Join-Path $vaultRoot "03_Projects\_Registry\PPJ_PROJECT_REGISTRY.md"
$aliasPath = Join-Path $vaultRoot "03_Projects\_Registry\PPJ_PROJECT_ALIAS_MAP.md"
$memoryIndexPath = Join-Path $vaultRoot "03_Projects\_Registry\PPJ_PROJECT_MEMORY_INDEX.md"
$memoryRoot = Join-Path $vaultRoot "03_Projects\_Registry\Project_Memory"
$cpdPath = Join-Path $projectRoot "CPD.Datamart.v1.1.md"

function Read-Utf8 { param([string]$Path) if(Test-Path $Path){ Get-Content -Raw -Encoding UTF8 $Path } else { "" } }
function Write-Utf8 { param([string]$Path,[string]$Text) $dir=Split-Path $Path -Parent; if(-not(Test-Path $dir)){New-Item -ItemType Directory -Force -Path $dir|Out-Null}; $Text | Set-Content -Encoding UTF8 $Path }
function Add-Utf8 { param([string]$Path,[string]$Text) $dir=Split-Path $Path -Parent; if(-not(Test-Path $dir)){New-Item -ItemType Directory -Force -Path $dir|Out-Null}; Add-Content -Encoding UTF8 -Path $Path -Value $Text }
function Get-Relative { param([string]$Path) return (Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\') }
function Backup-File { param([string]$Path) if(Test-Path $Path){ $rel=Get-Relative $Path; $dest=Join-Path $backupRoot $rel; New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent)|Out-Null; Copy-Item $Path $dest -Force; $script:Log += "- Backup: $rel" } }
function Safe-Part { param([string]$Value) if([string]::IsNullOrWhiteSpace($Value)){ return "TBD" }; return (($Value.Trim() -replace '[\\/:*?""<>|]', '-') -replace '\s+', '.') }
function Safe-FileBase { param([string]$Value) return (($Value.Trim() -replace '[\\/:*?""<>|]', '-') -replace '\s+', '.') }

if([string]::IsNullOrWhiteSpace($ProjectName)){
    $parts=@((Safe-Part $Department),(Safe-Part $Object),(Safe-Part $Characteristic),(Safe-Part $Version)) | Where-Object { $_ -ne "TBD" }
    $ProjectName = if($parts.Count -gt 0){ $parts -join "." } else { "NEW.PROJECT.$stamp" }
}
$baseName = Safe-FileBase $ProjectName
if(-not [string]::IsNullOrWhiteSpace($Version) -and $baseName -notlike "*$Version*"){ $baseName = "$baseName.$Version" }
$projectPath = Join-Path $projectRoot "$baseName.md"
$memoryPath = Join-Path $memoryRoot "$baseName.memory.md"

$allProjectFiles = if(Test-Path $projectRoot){ @(Get-ChildItem $projectRoot -Filter "*.md" -File) } else { @() }
$memoryIndex = Read-Utf8 $memoryIndexPath
$registry = Read-Utf8 $registryPath
$aliases = Read-Utf8 $aliasPath
$duplicateReasons=@()
if(Test-Path $projectPath){ $duplicateReasons += "Exact project file exists: $projectPath" }
if(@($allProjectFiles | Where-Object { $_.BaseName -eq $baseName -or $_.BaseName -eq $ProjectName }).Count -gt 0){ $duplicateReasons += "Basename match exists" }
if($memoryIndex -like "*$ProjectName*" -or $memoryIndex -like "*$baseName*"){ $duplicateReasons += "Memory index match exists" }
if($registry -like "*$ProjectName*" -or $registry -like "*$baseName*"){ $duplicateReasons += "Registry match exists" }
if($aliases -like "*$ProjectName*" -or $aliases -like "*$baseName*"){ $duplicateReasons += "Alias match exists" }

$memoryCardCount = if(Test-Path $memoryRoot){ @(Get-ChildItem $memoryRoot -Filter "*.memory.md" -File).Count } else { 0 }
$filesToCreate=@($projectPath,$memoryPath)
$filesToUpdate=@($memoryIndexPath,$registryPath)
if($CreateCanvasCard){ $filesToUpdate += (Join-Path $projectRoot "Canvas\PPJ_Executive_Board.canvas") }

Write-Host "PPJ Project Registration"
Write-Host "Mode: $(if($Apply){'Apply'}else{'DryRun'})"
Write-Host "ProjectName: $ProjectName"
Write-Host "Canonical filename: $baseName.md"
Write-Host "Memory index status: $(if(Test-Path $memoryIndexPath){'Exists'}else{'Missing'})"
Write-Host "Existing project memory card count: $memoryCardCount"
Write-Host "CPD.Datamart.v1.1 exists: $(Test-Path $cpdPath)"
Write-Host "Duplicate findings: $(if($duplicateReasons.Count -eq 0){'None'}else{($duplicateReasons -join '; ')})"
Write-Host "Proposed AGENTS.md changes: Project Memory Loading Rule; Project Auto-Update Rule; New Project Registration Rule"
Write-Host "Script validation status: runtime DryRun OK"
Write-Host "Files to create:"
foreach($f in $filesToCreate){ Write-Host " - $f" }
Write-Host "Files to update:"
foreach($f in $filesToUpdate){ Write-Host " - $f" }
if(-not $CreateCanvasCard){ Write-Host "Canvas update: No" } else { Write-Host "Canvas update requested: Yes" }
if($duplicateReasons.Count -gt 0 -and -not $Force){ Write-Host "Duplicate detected. Apply would stop unless -Force is provided." }
if($DryRun){ Write-Host "DryRun only. No files were modified."; exit 0 }
if($duplicateReasons.Count -gt 0 -and -not $Force){ throw "Duplicate detected. Re-run with -Force only if this is intentional." }

New-Item -ItemType Directory -Force -Path $auditRoot,$backupRoot,$memoryRoot | Out-Null
$script:Log=@("# PPJ Project Registration Log - $stamp","")
foreach($f in $filesToUpdate){ Backup-File $f }

$projectContent=@"
---
type: project
project_name: "$ProjectName"
project_code: "$baseName"
department: "$Department"
object: "$Object"
project_characteristic: "$Characteristic"
version: "$Version"
phase: "$Phase"
cluster: "$Cluster"
priority: "$Priority"
business_owner: "$BusinessOwner"
ba_coordination: "$BA"
technical_members: "$($TechnicalMembers -join ', ')"
status: "Draft"
last_updated: "$today"
confidence: "Needs Confirmation"
---

# $ProjectName

## Business Outcome
$Outcome

## Current Context
TBD

## Next Actions
TBD

## Related Concepts
[[Project Governance]]
[[Traceability]]

## Deliverables
[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[UAT_Checklist_Template]]
"@

$memoryContent=@"
---
type: project_memory
project_name: "$ProjectName"
project_file: "$baseName.md"
project_code: "$baseName"
department: "$Department"
cluster: "$Cluster"
phase: "$Phase"
status: "Draft"
priority: "$Priority"
business_owner: "$BusinessOwner"
ba_coordination: ["$BA"]
technical_members: ["$($TechnicalMembers -join '", "')"]
last_verified: "$today"
confidence: "Needs Confirmation"
---

# Project Memory: $ProjectName

## One-Line Understanding
TBD

## Current Outcome
$Outcome

## Latest Update Summary
Registered as new project.

## Do Not Drift Rules

- Do not invent facts.
- Do not merge this project into another note without approval.

## Source Links

- [[$baseName]]
"@

Write-Utf8 $projectPath $projectContent
Write-Utf8 $memoryPath $memoryContent
if(-not(Test-Path $memoryIndexPath)){ Write-Utf8 $memoryIndexPath "# PPJ Project Memory Index`r`n`r`n| Project | Memory Card | Project Note | Cluster | Phase | Priority | One-Line Understanding | Current Outcome | Latest Update | Confidence | Last Verified |`r`n|---|---|---|---|---|---|---|---|---|---|---|`r`n" }
Add-Utf8 $memoryIndexPath "| [[$baseName]] | [[$baseName.memory]] | [[$baseName]] | $Cluster | $Phase | $Priority | TBD | $Outcome | Registered as new project | Needs Confirmation | $today |"
if(Test-Path $registryPath){ Add-Utf8 $registryPath "`r`n- [[$baseName]]: $Outcome" }
$script:Log += "- Created project note: $baseName.md"
$script:Log += "- Created memory card: $baseName.memory.md"
$script:Log += "- Updated memory index"
Write-Utf8 $logPath ($script:Log -join "`r`n")
Write-Host "Apply completed. Log: $logPath"
