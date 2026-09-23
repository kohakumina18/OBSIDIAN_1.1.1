param(
    [Parameter(Mandatory=$true)]
    [string]$Project,

    [Parameter(Mandatory=$true)]
    [string]$Title,

    [ValidateSet("Task","Decision","Blocked","Analysis","Development","Production","External","Closed")]
    [string]$Lane = "Task",

    [string[]]$Related = @(),

    [string]$Outcome = "TBD",

    [string]$NextAction = "TBD",

    [string]$Update = "",

    [switch]$NoEdge
)

$ErrorActionPreference = "Stop"

# -------------------------
# Paths
# -------------------------
$vaultRoot  = (Get-Location).Path
$canvasPath = Join-Path $vaultRoot "03_Projects\Canvas\PPJ_Executive_Board.canvas"
$taskRoot   = Join-Path $vaultRoot "03_Projects\_Tasks"
$projectRoot = Join-Path $vaultRoot "03_Projects"
$backupRoot = Join-Path $vaultRoot "99_Attachments\Canvas_Backup"

New-Item -ItemType Directory -Force -Path $taskRoot | Out-Null
New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null

if (-not (Test-Path $canvasPath)) {
    throw "Canvas not found: $canvasPath"
}

# -------------------------
# Helper functions
# -------------------------
function New-CanvasId {
    return ([guid]::NewGuid().ToString("N").Substring(0,12))
}

function Safe-FileName {
    param([string]$Name)

    $safe = $Name -replace '[<>:"/\\|?*]', '-'
    $safe = $safe.Trim()

    if ($safe.Length -gt 80) {
        $safe = $safe.Substring(0,80).Trim()
    }

    return $safe
}

function Get-LaneKeyword {
    param([string]$Lane)

    switch ($Lane) {
        "Task"        { return "TASKS / DOCS TO UPDATE" }
        "Decision"    { return "TASKS / DOCS TO UPDATE" }
        "Blocked"     { return "BLOCKED" }
        "Analysis"    { return "ANALYSIS" }
        "Development" { return "DEVELOPMENT" }
        "Production"  { return "PRODUCTION" }
        "External"    { return "EXTERNAL" }
        "Closed"      { return "CLOSED" }
        default       { return "TASKS / DOCS TO UPDATE" }
    }
}

function New-GroupNode {
    param(
        [string]$Label,
        [double]$X,
        [double]$Y,
        [double]$W,
        [double]$H,
        [string]$Color = "6"
    )

    return [pscustomobject][ordered]@{
        id     = New-CanvasId
        type   = "group"
        label  = $Label
        x      = $X
        y      = $Y
        width  = $W
        height = $H
        color  = $Color
    }
}

function New-FileNode {
    param(
        [string]$File,
        [double]$X,
        [double]$Y,
        [double]$W = 300,
        [double]$H = 90,
        [string]$Color = "6"
    )

    return [pscustomobject][ordered]@{
        id     = New-CanvasId
        type   = "file"
        file   = $File
        x      = $X
        y      = $Y
        width  = $W
        height = $H
        color  = $Color
    }
}

function New-Edge {
    param(
        [string]$From,
        [string]$To,
        [string]$Label = "task"
    )

    return [pscustomobject][ordered]@{
        id       = New-CanvasId
        fromNode = $From
        fromSide = "right"
        toNode   = $To
        toSide   = "left"
        label    = $Label
    }
}

# -------------------------
# Create task note
# -------------------------
$timestamp = Get-Date -Format "yyyyMMdd_HHmm"
$dateHuman = Get-Date -Format "yyyy-MM-dd HH:mm"

$safeProject = Safe-FileName $Project
$safeTitle   = Safe-FileName $Title

$taskFileName = "${timestamp}_TASK_${safeProject}_${safeTitle}.md"
$taskPath = Join-Path $taskRoot $taskFileName
$obsidianTaskFile = "03_Projects/_Tasks/$taskFileName"

$relatedLinks = "- TBD"
if ($Related.Count -gt 0) {
    $relatedLinks = ($Related | ForEach-Object { "- [[${_}]]" }) -join "`r`n"
}

@"
---
type: task
created: "$dateHuman"
project: "$Project"
lane: "$Lane"
status: "Open"
---

# TASK - $Title

Project:
[[$Project]]

Lane:
$Lane

Outcome:
$Outcome

Next Action:
$NextAction

Related Documents:
$relatedLinks

Source / Context:
- Added from PowerShell into [[PPJ_Executive_Board]]

Validation:
- Done when the related document is updated, linked, and the next decision/action is clear.

🔗 Related Concepts  
[[Decision Making]]  
[[Outcome Driven Thinking]]  
[[System Thinking]]  
[[Stakeholder Management]]

🔧 Methods  
[[Impact Analysis]]  
[[Decision Matrix]]  
[[Requirement Elicitation]]

📂 Projects  
[[$Project]]

📎 Deliverables  
[[Decision_Driven_BRD]]  
[[ERD_Template]]  
[[User_Manual_Template]]
"@ | Set-Content -Encoding UTF8 $taskPath

# -------------------------
# Ensure project note exists
# -------------------------
$projectFileName = Safe-FileName $Project
$projectPath = Join-Path $projectRoot "$projectFileName.md"

if (-not (Test-Path $projectPath)) {
@"
---
type: project
project_name: "$Project"
status: "TBD"
---

# $Project

Status:
TBD

Canvas:
- [[PPJ_Executive_Board]]
- [[PPJ_Portfolio]]
- [[PPJ_Data_Flow]]
- [[PPJ_Roadmap_2026]]

Current Context:
- TBD

Tasks:
- [[$($taskFileName -replace '\.md$','')]]

🔗 Related Concepts  
[[System Thinking]]  
[[Outcome Driven Thinking]]

🔧 Methods  
[[Impact Analysis]]

📎 Deliverables  
[[Decision_Driven_BRD]]
"@ | Set-Content -Encoding UTF8 $projectPath
}
else {
    $taskLinkName = $taskFileName -replace '\.md$',''

    $append = @"

---

Update - $dateHuman

Related Task:
[[$taskLinkName]]

Task:
- $Title

Outcome:
- $Outcome

Next Action:
- $NextAction
"@

    if ($Update.Trim().Length -gt 0) {
        $append += @"

Update Detail:
- $Update
"@
    }

    Add-Content -Encoding UTF8 -Path $projectPath -Value $append
}

# -------------------------
# Load canvas
# -------------------------
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
Copy-Item $canvasPath "$backupRoot\PPJ_Executive_Board.canvas.$stamp.bak"

$canvas = Get-Content -Raw $canvasPath | ConvertFrom-Json

$nodes = @()
if ($canvas.nodes) {
    $nodes = @($canvas.nodes)
}

$edges = @()
if ($canvas.edges) {
    $edges = @($canvas.edges)
}

# -------------------------
# Find or create target group
# -------------------------
$keyword = Get-LaneKeyword $Lane

$group = $nodes |
    Where-Object {
        $_.type -eq "group" -and
        $_.label -like "*$keyword*"
    } |
    Select-Object -First 1

if (-not $group) {
    $rightMost = 0

    if ($nodes.Count -gt 0) {
        $rightMost = ($nodes | ForEach-Object {
            [double]$_.x + [double]$_.width
        } | Measure-Object -Maximum).Maximum
    }

    if (-not $rightMost) {
        $rightMost = 0
    }

    $groupLabel = "TASKS / DOCS TO UPDATE"

    $group = New-GroupNode `
        -Label $groupLabel `
        -X ([math]::Ceiling($rightMost + 120)) `
        -Y 0 `
        -W 720 `
        -H 720 `
        -Color "6"

    $nodes += $group
}

# -------------------------
# Calculate card position
# -------------------------
$groupX = [double]$group.x
$groupY = [double]$group.y
$groupW = [double]$group.width
$groupH = [double]$group.height

$cardsInGroup = $nodes | Where-Object {
    $_.type -ne "group" -and
    [double]$_.x -ge $groupX -and
    [double]$_.x -lt ($groupX + $groupW) -and
    [double]$_.y -ge ($groupY + 60) -and
    [double]$_.y -lt ($groupY + $groupH)
}

$index = @($cardsInGroup).Count

$cardX = $groupX + 30 + (($index % 2) * 330)
$cardY = $groupY + 70 + ([math]::Floor($index / 2) * 115)

if (($cardY + 130) -gt ($groupY + $groupH)) {
    $group.height = ($cardY - $groupY + 160)
}

# -------------------------
# Add task node
# -------------------------
$newTaskNode = New-FileNode `
    -File ($obsidianTaskFile -replace "\\","/") `
    -X $cardX `
    -Y $cardY `
    -W 300 `
    -H 90 `
    -Color "6"

$nodes += $newTaskNode

# -------------------------
# Link project node to task node if project exists on canvas
# -------------------------
$projectCanvasFile = "03_Projects/$projectFileName.md"

$projectNode = $nodes |
    Where-Object {
        $_.type -eq "file" -and
        (
            $_.file -eq $projectCanvasFile -or
            $_.file -like "*$projectFileName.md"
        )
    } |
    Select-Object -First 1

if ($projectNode -and -not $NoEdge) {
    $edges += New-Edge -From $projectNode.id -To $newTaskNode.id -Label "task"
}

# -------------------------
# Save canvas
# -------------------------
$out = [ordered]@{
    nodes = @($nodes)
    edges = @($edges)
}

$out | ConvertTo-Json -Depth 50 | Set-Content -Encoding UTF8 $canvasPath

Write-Host ""
Write-Host "✅ Task created:"
Write-Host " - $taskPath"
Write-Host ""
Write-Host "✅ Added to canvas:"
Write-Host " - 03_Projects/Canvas/PPJ_Executive_Board.canvas"
Write-Host ""
Write-Host "✅ Linked with project:"
Write-Host " - $Project"
Write-Host ""
Write-Host "✅ Backup created:"
Write-Host " - $backupRoot"

