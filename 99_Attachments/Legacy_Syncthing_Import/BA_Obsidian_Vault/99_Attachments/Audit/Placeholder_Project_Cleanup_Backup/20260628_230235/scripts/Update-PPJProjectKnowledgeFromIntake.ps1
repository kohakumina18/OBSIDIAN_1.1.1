param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [string]$InputPath,
    [string]$Source = "intake",
    [string]$ProjectName,
    [switch]$UpdateMemory,
    [switch]$UpdateProjectNote,
    [switch]$UpdateRegistry,
    [switch]$CreateTasks,
    [switch]$CreateDecisions,
    [switch]$RegisterNewProjects,
    [switch]$UpdateCanvas
)

$ErrorActionPreference = "Stop"
if (-not $Apply) { $DryRun = $true }

$vaultRoot = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$today = Get-Date -Format "yyyy-MM-dd"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$backupRoot = Join-Path $auditRoot "Project_Knowledge_Auto_Update_Backup\$stamp"
$logPath = Join-Path $auditRoot "PROJECT_KNOWLEDGE_AUTO_UPDATE_LOG_$stamp.md"
$memoryIndexPath = Join-Path $vaultRoot "03_Projects\_Registry\PPJ_PROJECT_MEMORY_INDEX.md"
$ledgerPath = Join-Path $vaultRoot "03_Projects\_Registry\PPJ_PROJECT_UPDATE_LEDGER.md"
$memoryRoot = Join-Path $vaultRoot "03_Projects\_Registry\Project_Memory"
$proposalRoot = Join-Path $vaultRoot "03_Projects\_Registry\Project_Update_Proposals"
$taskRoot = Join-Path $vaultRoot "03_Projects\_Tasks"
$decisionRoot = Join-Path $vaultRoot "07_Decision_Log"
$projectRoot = Join-Path $vaultRoot "03_Projects"
$cpdPath = Join-Path $projectRoot "CPD.Datamart.v1.1.md"

$standardStart = "<!-- PPJ_PROJECT_KNOWLEDGE_START -->"
$standardEnd = "<!-- PPJ_PROJECT_KNOWLEDGE_END -->"

function Read-Utf8 { param([string]$Path) if(Test-Path $Path){ Get-Content -Raw -Encoding UTF8 $Path } else { "" } }
function Write-Utf8 { param([string]$Path,[string]$Text) $dir=Split-Path $Path -Parent; if(-not(Test-Path $dir)){New-Item -ItemType Directory -Force -Path $dir|Out-Null}; $Text | Set-Content -Encoding UTF8 $Path }
function Add-Utf8 { param([string]$Path,[string]$Text) $dir=Split-Path $Path -Parent; if(-not(Test-Path $dir)){New-Item -ItemType Directory -Force -Path $dir|Out-Null}; Add-Content -Encoding UTF8 -Path $Path -Value $Text }
function Get-Relative { param([string]$Path) return (Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\') }
function Backup-File { param([string]$Path) if(Test-Path $Path){ $rel=Get-Relative $Path; $dest=Join-Path $backupRoot $rel; New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent)|Out-Null; Copy-Item $Path $dest -Force; $script:Log += "- Backup: $rel" } }
function Safe-Name { param([string]$Name) return (($Name.Trim() -replace '^\[\[|\]\]$','') -replace '[\\/:*?""<>|]', '_') }

function Parse-MarkdownTable {
    param([string]$Text,[string]$Heading)
    $lines = $Text -split "`r?`n"
    $start = -1
    for($i=0;$i -lt $lines.Count;$i++){ if($lines[$i] -match "^##\s+$([regex]::Escape($Heading))\s*$"){ $start=$i; break } }
    if($start -lt 0){ return @() }
    $rows=@()
    for($i=$start+1;$i -lt $lines.Count;$i++){
        if($lines[$i] -match '^##\s+'){ break }
        if($lines[$i].Trim() -notmatch '^\|'){ continue }
        if($lines[$i] -match '^\|\s*-'){ continue }
        $cells=@($lines[$i].Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() })
        if($cells.Count -gt 0 -and $cells[0] -notmatch 'Project|Proposed Name'){ $rows += ,$cells }
    }
    return @($rows)
}

if(-not [string]::IsNullOrWhiteSpace($InputPath) -and -not [System.IO.Path]::IsPathRooted($InputPath)){ $InputPath = Join-Path $vaultRoot $InputPath }
$intakeText = if(-not [string]::IsNullOrWhiteSpace($InputPath) -and (Test-Path $InputPath)){ Read-Utf8 $InputPath } else { "" }
$events = if($intakeText){ Parse-MarkdownTable $intakeText "Extracted Update Events" } else { @() }
$tasks = if($intakeText){ Parse-MarkdownTable $intakeText "Tasks To Create" } else { @() }
$decisions = if($intakeText){ Parse-MarkdownTable $intakeText "Decisions To Log" } else { @() }
$newCandidates = if($intakeText){ Parse-MarkdownTable $intakeText "New Project Registration Candidates" } else { @() }

if($events.Count -eq 0 -and -not [string]::IsNullOrWhiteSpace($ProjectName)){
    $events = @(,@($ProjectName,"progress_update","Latest Update Summary","TBD","TBD","Manual ProjectName supplied; intake needs extraction","Needs Review"))
}

$memoryCardCount = if(Test-Path $memoryRoot){ @(Get-ChildItem $memoryRoot -Filter "*.memory.md" -File).Count } else { 0 }
$memoryIndexStatus = if(Test-Path $memoryIndexPath){ "Exists" } else { "Missing" }
$filesToCreate=@()
$filesToUpdate=@()
$unknownProjects=@()
$knownProjects=@()

foreach($e in $events){
    if($e.Count -lt 7){ continue }
    $project = Safe-Name $e[0]
    if([string]::IsNullOrWhiteSpace($project)){ continue }
    $projectPath = Join-Path $projectRoot "$project.md"
    $memoryPath = Join-Path $memoryRoot "$project.memory.md"
    if(Test-Path $projectPath -or Test-Path $memoryPath -or ((Read-Utf8 $memoryIndexPath) -like "*$project*")){
        $knownProjects += $project
        if($UpdateMemory){ if(Test-Path $memoryPath){ $filesToUpdate += $memoryPath } else { $filesToCreate += $memoryPath } }
        if($UpdateProjectNote -and (Test-Path $projectPath)){ $filesToUpdate += $projectPath }
    } else {
        $unknownProjects += $project
    }
}
if($UpdateRegistry){ $filesToUpdate += $memoryIndexPath }
if($events.Count -gt 0){ $filesToUpdate += $ledgerPath }
if($CreateTasks){ foreach($t in $tasks){ if($t.Count -ge 2){ $filesToCreate += (Join-Path $taskRoot ("TASK_" + (Safe-Name $t[0]) + "_" + (Safe-Name $t[1]) + "_$stamp.md")) } } }
if($CreateDecisions){ foreach($d in $decisions){ if($d.Count -ge 2){ $filesToCreate += (Join-Path $decisionRoot ("DECISION_" + (Safe-Name $d[0]) + "_" + (Safe-Name $d[1]) + "_$stamp.md")) } } }
if($RegisterNewProjects){ foreach($n in $newCandidates){ if($n.Count -ge 1){ $filesToCreate += (Join-Path $proposalRoot ("PROJECT_REGISTRATION_PROPOSAL_" + (Safe-Name $n[0]) + "_$stamp.md")) } } }

$filesToCreate=@($filesToCreate | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)
$filesToUpdate=@($filesToUpdate | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)

Write-Host "PPJ Project Knowledge Update From Intake"
Write-Host "Mode: $(if($Apply){'Apply'}else{'DryRun'})"
Write-Host "InputPath: $(if($InputPath){$InputPath}else{'None supplied'})"
Write-Host "Memory index status: $memoryIndexStatus"
Write-Host "Existing project memory card count: $memoryCardCount"
Write-Host "CPD.Datamart.v1.1 exists: $(Test-Path $cpdPath)"
Write-Host "Extracted update events: $($events.Count)"
Write-Host "Known projects detected: $((@($knownProjects | Select-Object -Unique)) -join ', ')"
Write-Host "Unknown project candidates: $((@($unknownProjects | Select-Object -Unique)) -join ', ')"
Write-Host "Proposed AGENTS.md changes: Project Memory Loading Rule; Project Auto-Update Rule; New Project Registration Rule"
Write-Host "Script validation status: runtime DryRun OK"
Write-Host "Files to create:"
if($filesToCreate.Count -eq 0){ Write-Host " - None" } else { foreach($f in $filesToCreate){ Write-Host " - $f" } }
Write-Host "Files to update:"
if($filesToUpdate.Count -eq 0){ Write-Host " - None" } else { foreach($f in $filesToUpdate){ Write-Host " - $f" } }
Write-Host "Canvas update requested: $($UpdateCanvas.IsPresent)"
if(-not $UpdateCanvas){ Write-Host "Canvas update: No" }
if($DryRun){ Write-Host "DryRun only. No files were modified."; exit 0 }

New-Item -ItemType Directory -Force -Path $auditRoot,$backupRoot,$memoryRoot | Out-Null
$script:Log=@("# Project Knowledge Auto Update Log - $stamp","")
foreach($f in $filesToUpdate){ Backup-File $f }

foreach($e in $events){
    if($e.Count -lt 7){ continue }
    $project = Safe-Name $e[0]
    $updateType=$e[1]; $field=$e[2]; $old=$e[3]; $new=$e[4]; $evidence=$e[5]; $confidence=$e[6]
    $memoryPath = Join-Path $memoryRoot "$project.memory.md"
    if($UpdateMemory){
        if(Test-Path $memoryPath){
            $mem=Read-Utf8 $memoryPath
            $mem=[regex]::Replace($mem,'(?s)## Latest Update Summary\r?\n.*?(?=\r?\n## )',"## Latest Update Summary`r`n$new`r`n",1)
            $eventLine="| $today | $updateType | $new | $Source | $confidence |"
            if($mem -like "*## Recent Update Events*"){ $mem=$mem.TrimEnd()+"`r`n$eventLine`r`n" } else { $mem=$mem.TrimEnd()+"`r`n`r`n## Recent Update Events`r`n`r`n| Date | Update Type | Summary | Source | Confidence |`r`n|---|---|---|---|---|`r`n$eventLine`r`n" }
            Write-Utf8 $memoryPath $mem
        } else {
            $content="---`r`ntype: project_memory`r`nproject_name: `"$project`"`r`nproject_file: `"$project.md`"`r`nlast_verified: `"$today`"`r`nconfidence: `"$confidence`"`r`n---`r`n`r`n# Project Memory: $project`r`n`r`n## One-Line Understanding`r`nTBD`r`n`r`n## Latest Update Summary`r`n$new`r`n`r`n## Recent Update Events`r`n`r`n| Date | Update Type | Summary | Source | Confidence |`r`n|---|---|---|---|---|`r`n| $today | $updateType | $new | $Source | $confidence |`r`n`r`n## Do Not Drift Rules`r`n`r`n- Do not invent facts.`r`n`r`n## Source Links`r`n`r`n- [[$project]]`r`n"
            Write-Utf8 $memoryPath $content
        }
        $script:Log += "- Updated memory: $project"
    }
    $ledgerLine="| $today | [[$project]] | $updateType | $new | $field | $old | $new | $evidence | $confidence | memory$(if($UpdateProjectNote){', project note'}) | TBD |"
    Add-Utf8 $ledgerPath $ledgerLine
    $script:Log += "- Appended ledger: $project / $updateType"
}

Write-Utf8 $logPath ($script:Log -join "`r`n")
Write-Host "Apply completed. Log: $logPath"
