param(
    [switch]$DryRun,
    [switch]$Apply,
    [string]$CanvasPath = "03_Projects/Canvas/PPJ_Executive_Board.canvas"
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if ($DryRun -and $Apply) { throw "Use only one mode: -DryRun or -Apply." }
if (-not $Apply) { $DryRun = $true }

$VaultRoot = (Get-Location).ProviderPath
$CanvasFullPath = Join-Path $VaultRoot ($CanvasPath -replace "/", "\")
$SourceEventId = "PPJ-WEEKLY-20260727-20260801"
$ReportingPeriod = "2026-07-27 to 2026-08-01"
$PlanningPeriod = "2026-08-03 to 2026-08-08"
$UpdateDate = "2026-08-02"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupRoot = Join-Path $VaultRoot "99_Attachments/Audit/Weekly_Canvas_Update_Backup/20260727_20260801/$Stamp"

$AllowedLanes = @(
    "PENDING",
    "ANALYSIS",
    "DESIGN",
    "DEVELOPMENT",
    "STABILIZE / UAT",
    "PRODUCTION / SUPPORT",
    "EXTERNAL / THIRD PARTIES",
    "BLOCKED / DEPENDENCY",
    "TASKS / DOCS TO UPDATE",
    "CLOSED / CANCELLED"
)

function New-ProjectPlan {
    param(
        [string]$Priority,
        [string]$CanonicalCode,
        [string]$File,
        [string]$Lane,
        [double]$X,
        [double]$Y,
        [double]$Width,
        [double]$Height,
        [string]$TaskFile,
        [string]$TaskNodeId,
        [string]$EdgeId,
        [string]$RequiredOutput
    )

    [pscustomobject]@{
        Priority = $Priority
        CanonicalCode = $CanonicalCode
        File = $File
        Lane = $Lane
        X = $X
        Y = $Y
        Width = $Width
        Height = $Height
        TaskFile = $TaskFile
        TaskNodeId = $TaskNodeId
        EdgeId = $EdgeId
        RequiredOutput = $RequiredOutput
    }
}

$ProjectPlans = @(
    New-ProjectPlan "P1" "FIN.AI.FINANCE.MANAGEMENT.v1.2" "03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1.md" "ANALYSIS" 1325 320 340 120 "03_Projects/_Tasks/TASK_FIN.AI.FINANCE.MANAGEMENT.v1.2_PPJ-WEEKLY-20260727-20260801_finance-databricks-rule-engine.md" "weekly-task-20260801-p01" "weekly-edge-20260801-p01" "Databricks access decision and finalized Rule Engine Catalogue."
    New-ProjectPlan "P2" "PUR.GDI.Automation.v1.0" "03_Projects/PUR.GDI Automation.md" "ANALYSIS" 2120 325 340 115 "03_Projects/_Tasks/TASK_PUR.GDI.Automation.v1.0_PPJ-WEEKLY-20260727-20260801_gdi-wfx-api.md" "weekly-task-20260801-p02" "weekly-edge-20260801-p02" "WFX API request and target integration architecture."
    New-ProjectPlan "P3" "COSTING.AGENTIC.PLATFORM.v1.1" "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1.md" "DEVELOPMENT" 3920 323 340 152 "03_Projects/_Tasks/TASK_COSTING.AGENTIC.PLATFORM.v1.1_PPJ-WEEKLY-20260727-20260801_costing-sew-v12.md" "weekly-task-20260801-p03" "weekly-edge-20260801-p03" "Sew Costing v1.2 accuracy plan and GTAS/IED data contract."
    New-ProjectPlan "P4" "SCP.SOURCING.CHATBOT.v2.3" "03_Projects/SCP.SOURCING.CHATBOT.v2.3.md" "STABILIZE / UAT" 5600 325 340 155 "03_Projects/_Tasks/TASK_SCP.SOURCING.CHATBOT.v2.3_PPJ-WEEKLY-20260727-20260801_sourcing-closeout-data.md" "weekly-task-20260801-p04" "weekly-edge-20260801-p04" "UAT acceptance, handover and closeout package."
    New-ProjectPlan "P5" "HR.SSPFD.Workflow.v1.1" "03_Projects/HR.SS&PFD.v1.1.md" "PRODUCTION / SUPPORT" 6860 920 340 160 "03_Projects/_Tasks/TASK_HR.SSPFD.Workflow.v1.1_PPJ-WEEKLY-20260727-20260801_hr-rollout-ownership.md" "weekly-task-20260801-p05" "weekly-edge-20260801-p05" "Rollout monitoring and confirmed production ownership."
    New-ProjectPlan "P6" "TD.TechnicalKnowledge.Platform.v2.1" "03_Projects/TD.TechnicalPlatform_v2.1.md" "DEVELOPMENT" 3920 525 340 151 "03_Projects/_Tasks/TASK_TD.TechnicalKnowledge.Platform.v2.1_PPJ-WEEKLY-20260727-20260801_technical-etl-acceptance.md" "weekly-task-20260801-p06" "weekly-edge-20260801-p06" "ETL reconciliation and Technical data acceptance."
    New-ProjectPlan "P7" "PPJ.ExpenseInvoices.v1.1" "03_Projects/PPJ. Expense-Invoices.v1.1.md" "STABILIZE / UAT" 6000 325 340 155 "03_Projects/_Tasks/TASK_PPJ.ExpenseInvoices.v1.1_PPJ-WEEKLY-20260727-20260801_expense-supplier-uat.md" "weekly-task-20260801-p07" "weekly-edge-20260801-p07" "Supplier mapping completion and UAT defect closure."
    New-ProjectPlan "P8" "PPJxStratova.AI" "03_Projects/PPJxStratova AI.md" "CLOSED / CANCELLED" 11645 325 340 128 "03_Projects/_Tasks/TASK_PPJxStratova.AI_PPJ-WEEKLY-20260727-20260801_stratova-option-paper.md" "weekly-task-20260801-p08" "weekly-edge-20260801-p08" "Google/Stratova meeting note and leadership option paper."
    New-ProjectPlan "P9" "PUR.Inventory.Report.v2.1" "03_Projects/PUR.Inventory Report.md" "PRODUCTION / SUPPORT" 6485 725 340 160 "03_Projects/_Tasks/TASK_PUR.Inventory.Report.v2.1_PPJ-WEEKLY-20260727-20260801_inventory-v21-validation.md" "weekly-task-20260801-p09" "weekly-edge-20260801-p09" "Post-release validation and enhancement backlog."
    New-ProjectPlan "P10" "PPJxNUNOX.ScanTrial" "03_Projects/PPJxNUNOX.md" "EXTERNAL / THIRD PARTIES" 7775 534 340 151 "03_Projects/_Tasks/TASK_PPJxNUNOX.ScanTrial_PPJ-WEEKLY-20260727-20260801_nunox-visit-business-case.md" "weekly-task-20260801-p10" "weekly-edge-20260801-p10" "Leadership decision and vendor-visit preparation."
    New-ProjectPlan "P11" "PPJxQSee.AI" "03_Projects/PPJxQSee.ai.md" "BLOCKED / DEPENDENCY" 9065 525 340 165 "03_Projects/_Tasks/TASK_PPJxQSee.AI_PPJ-WEEKLY-20260727-20260801_qsee-hold-criteria.md" "weekly-task-20260801-p11" "weekly-edge-20260801-p11" "Formal hold status and reactivation criteria."
)

function Get-Utf8Content {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

function Set-Utf8Content {
    param([string]$Path, [string]$Content)
    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

function Resolve-CanvasPath {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return "" }
    return ($Path -replace "\\", "/").TrimStart("/")
}

function Get-NumberProperty {
    param([object]$Object, [string]$Name, [double]$Default = 0)
    if ($Object.PSObject.Properties.Name -contains $Name -and $null -ne $Object.$Name) {
        return [double]$Object.$Name
    }
    return $Default
}

function Set-ObjectProperty {
    param([object]$Object, [string]$Name, [object]$Value)
    if ($Object.PSObject.Properties.Name -contains $Name) {
        $Object.$Name = $Value
    }
    else {
        $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value
    }
}

function Get-NodeLane {
    param([object]$Node, [object[]]$Groups)
    $centerX = (Get-NumberProperty $Node "x") + ((Get-NumberProperty $Node "width" 300) / 2)
    $centerY = (Get-NumberProperty $Node "y") + ((Get-NumberProperty $Node "height" 80) / 2)
    $inside = @(
        $Groups | Where-Object {
            $gx = Get-NumberProperty $_ "x"
            $gy = Get-NumberProperty $_ "y"
            $gw = Get-NumberProperty $_ "width"
            $gh = Get-NumberProperty $_ "height"
            $centerX -ge $gx -and $centerX -le ($gx + $gw) -and
            $centerY -ge $gy -and $centerY -le ($gy + $gh)
        } | Sort-Object @{ Expression = { (Get-NumberProperty $_ "width") * (Get-NumberProperty $_ "height") } }
    )
    if ($inside.Count -eq 0) { return "" }
    return [string]$inside[0].label
}

function Get-TaskColor {
    param([string]$Priority)
    $rank = [int]($Priority.Substring(1))
    if ($rank -le 3) { return "1" }
    if ($rank -le 7) { return "4" }
    return "6"
}

function Get-TaskPosition {
    param([int]$Index, [object]$TaskLane)
    $column = $Index % 3
    $row = [math]::Floor($Index / 3)
    [pscustomobject]@{
        X = (Get-NumberProperty $TaskLane "x") + 35 + ($column * 375)
        Y = (Get-NumberProperty $TaskLane "y") + 240 + ($row * 150)
    }
}

function New-TaskNode {
    param([object]$Plan, [int]$Index, [object]$TaskLane)
    $position = Get-TaskPosition $Index $TaskLane
    [pscustomobject][ordered]@{
        id = $Plan.TaskNodeId
        type = "file"
        file = $Plan.TaskFile
        x = $position.X
        y = $position.Y
        width = 340
        height = 115
        color = Get-TaskColor $Plan.Priority
    }
}

function New-TaskEdge {
    param([object]$Plan, [object]$ProjectNode)
    [pscustomobject][ordered]@{
        id = $Plan.EdgeId
        fromNode = $ProjectNode.id
        fromSide = "right"
        toNode = $Plan.TaskNodeId
        toSide = "left"
        label = "$($Plan.Priority) task"
    }
}

function Get-ExpectedFocusText {
    return @"
PPJ_WEEKLY_TOP_FOCUS_20260727_20260801

WEEKLY PORTFOLIO FOCUS
Report: $ReportingPeriod
Plan: $PlanningPeriod

P1 Finance - Databricks access and Rule Engine Catalogue
P2 GDI - WFX API architecture and prototype
P3 Costing - Sew v1.2 accuracy and GTAS/IED contract
P4 Sourcing - UAT acceptance, handover and closeout

Watch: HR rollout; Technical data acceptance; QSee on hold
"@
}

function Get-ExpectedTitleText {
    return @"
PPJ EXECUTIVE BOARD - CURRENT CANONICAL LIFECYCLE VIEW
Updated: $UpdateDate
Source: $SourceEventId
Flow: Pending -> Analysis -> Design -> Development -> Stabilize/UAT -> Production/Support -> External/Blocked/Tasks -> Closed
"@
}

function Get-ExpectedCandidateText {
    param([string]$CurrentText)
    $line = "- ACC.Inventory.Control.Report.v1.0 / Accounting Inventory Report (proposal only; pending registration and resources)"
    if ($CurrentText -like "*$line*") { return $CurrentText }
    return $CurrentText.TrimEnd() + "`n" + $line
}

if (-not (Test-Path -LiteralPath $CanvasFullPath)) { throw "Canvas not found: $CanvasFullPath" }

$canvas = Get-Utf8Content $CanvasFullPath | ConvertFrom-Json
$nodes = @($canvas.nodes)
$edges = @($canvas.edges)
$groups = @($nodes | Where-Object { $_.type -eq "group" -and $AllowedLanes -contains $_.label })
$hardStops = New-Object System.Collections.Generic.List[string]

foreach ($lane in $AllowedLanes) {
    $laneGroupSet = @($groups | Where-Object { $_.label -eq $lane })
    if ($laneGroupSet.Count -ne 1) { $hardStops.Add("Expected exactly one '$lane' group; found $($laneGroupSet.Count).") }
}

$taskLane = @($groups | Where-Object { $_.label -eq "TASKS / DOCS TO UPDATE" } | Select-Object -First 1)
$projectNodeMap = @{}
$projectActions = @()
$taskActions = @()
$edgeActions = @()

foreach ($plan in $ProjectPlans) {
    $projectPath = Join-Path $VaultRoot ($plan.File -replace "/", "\")
    $taskPath = Join-Path $VaultRoot ($plan.TaskFile -replace "/", "\")
    if (-not (Test-Path -LiteralPath $projectPath)) { $hardStops.Add("Project note missing: $($plan.File)") }
    if (-not (Test-Path -LiteralPath $taskPath)) { $hardStops.Add("Weekly task missing: $($plan.TaskFile)") }

    $projectMatches = @($nodes | Where-Object { $_.type -eq "file" -and (Resolve-CanvasPath $_.file) -eq $plan.File })
    if ($projectMatches.Count -ne 1) {
        $hardStops.Add("Expected exactly one project card for $($plan.File); found $($projectMatches.Count).")
        continue
    }

    $projectNode = $projectMatches[0]
    $projectNodeMap[$plan.CanonicalCode] = $projectNode
    $currentLane = Get-NodeLane $projectNode $groups
    $action = if ($currentLane -eq $plan.Lane) { "KEEP" } else { "MOVE" }
    $projectActions += [pscustomobject]@{
        Priority = $plan.Priority
        Project = $plan.CanonicalCode
        File = $plan.File
        CurrentLane = $currentLane
        TargetLane = $plan.Lane
        Action = $action
    }

    $taskMatches = @($nodes | Where-Object { $_.type -eq "file" -and (Resolve-CanvasPath $_.file) -eq $plan.TaskFile })
    if ($taskMatches.Count -gt 1) { $hardStops.Add("Duplicate weekly task cards found for $($plan.TaskFile).") }
    $idConflicts = @($nodes | Where-Object { $_.id -eq $plan.TaskNodeId -and -not ($_.type -eq "file" -and (Resolve-CanvasPath $_.file) -eq $plan.TaskFile) })
    if ($idConflicts.Count -gt 0) { $hardStops.Add("Task node ID conflict: $($plan.TaskNodeId)") }
    $taskActions += [pscustomobject]@{
        Priority = $plan.Priority
        Project = $plan.CanonicalCode
        TaskFile = $plan.TaskFile
        Action = $(if ($taskMatches.Count -eq 0) { "CREATE" } else { "UPDATE" })
    }

    $expectedProjectId = [string]$projectNode.id
    $edgeById = @($edges | Where-Object { $_.id -eq $plan.EdgeId })
    if ($edgeById.Count -gt 1) { $hardStops.Add("Duplicate edge ID found: $($plan.EdgeId)") }
    if ($edgeById.Count -eq 1 -and ($edgeById[0].fromNode -ne $expectedProjectId -or $edgeById[0].toNode -ne $plan.TaskNodeId)) {
        $hardStops.Add("Edge ID conflict: $($plan.EdgeId)")
    }
    $sameLink = @($edges | Where-Object { $_.fromNode -eq $expectedProjectId -and $_.toNode -eq $plan.TaskNodeId })
    if ($sameLink.Count -gt 1) { $hardStops.Add("Duplicate project-task edges found for $($plan.CanonicalCode).") }
    $edgeActions += [pscustomobject]@{
        Priority = $plan.Priority
        Project = $plan.CanonicalCode
        Action = $(if ($sameLink.Count -eq 0 -and $edgeById.Count -eq 0) { "CREATE" } else { "UPDATE" })
    }
}

$titleMatches = @($nodes | Where-Object { $_.id -eq "exec-title" })
$focusMatches = @($nodes | Where-Object { $_.id -eq "exec-weekly-focus-20260629" })
$candidateMatches = @($nodes | Where-Object { $_.id -eq "exec-candidates" })
if ($titleMatches.Count -gt 1) { $hardStops.Add("Duplicate exec-title nodes found.") }
if ($focusMatches.Count -gt 1) { $hardStops.Add("Duplicate weekly-focus nodes found.") }
if ($candidateMatches.Count -gt 1) { $hardStops.Add("Duplicate candidate nodes found.") }

Write-Host "PPJ Executive Canvas Weekly Synchronization"
Write-Host "Mode: $(if ($DryRun) { 'DRYRUN' } else { 'APPLY' })"
Write-Host "Canvas: $CanvasPath"
Write-Host "Source Event: $SourceEventId"
Write-Host "Existing nodes: $($nodes.Count)"
Write-Host "Existing edges: $($edges.Count)"
Write-Host "Project cards: $($ProjectPlans.Count)"
foreach ($item in $projectActions) {
    Write-Host ("[{0}] {1} | {2} -> {3}" -f $item.Action, $item.Project, $item.CurrentLane, $item.TargetLane)
}
Write-Host "Weekly task cards: $($taskActions.Count)"
foreach ($item in $taskActions) { Write-Host ("[{0}] {1} -> {2}" -f $item.Action, $item.Priority, $item.TaskFile) }
Write-Host "Project-task edges: $($edgeActions.Count)"
Write-Host "Text updates: executive title, weekly focus, backlog candidate list"
Write-Host "Canvas-only operation: project notes and registries will not be modified"
Write-Host "Backup plan: $BackupRoot"
Write-Host "Hard stops: $($hardStops.Count)"
foreach ($stop in $hardStops) { Write-Host "- $stop" }

if ($hardStops.Count -gt 0) { exit 2 }
if ($DryRun) { Write-Host "DryRun PASS. No files modified."; exit 0 }

if (-not (Test-Path -LiteralPath $BackupRoot)) { New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null }
$backupPath = Join-Path $BackupRoot "PPJ_Executive_Board.canvas.bak"
Copy-Item -LiteralPath $CanvasFullPath -Destination $backupPath -Force
if (-not (Test-Path -LiteralPath $backupPath)) { throw "Canvas backup was not created." }

foreach ($plan in $ProjectPlans) {
    $projectNode = $projectNodeMap[$plan.CanonicalCode]
    $currentLane = Get-NodeLane $projectNode $groups
    if ($currentLane -ne $plan.Lane) {
        Set-ObjectProperty $projectNode "x" $plan.X
        Set-ObjectProperty $projectNode "y" $plan.Y
        Set-ObjectProperty $projectNode "width" $plan.Width
        Set-ObjectProperty $projectNode "height" $plan.Height
    }
}

for ($index = 0; $index -lt $ProjectPlans.Count; $index++) {
    $plan = $ProjectPlans[$index]
    $position = Get-TaskPosition $index $taskLane[0]
    $taskMatches = @($nodes | Where-Object { $_.type -eq "file" -and (Resolve-CanvasPath $_.file) -eq $plan.TaskFile })
    if ($taskMatches.Count -eq 0) {
        $taskNode = New-TaskNode $plan $index $taskLane[0]
        $nodes += $taskNode
    }
    else {
        $taskNode = $taskMatches[0]
        Set-ObjectProperty $taskNode "id" $plan.TaskNodeId
        Set-ObjectProperty $taskNode "file" $plan.TaskFile
        Set-ObjectProperty $taskNode "x" $position.X
        Set-ObjectProperty $taskNode "y" $position.Y
        Set-ObjectProperty $taskNode "width" 340
        Set-ObjectProperty $taskNode "height" 115
        Set-ObjectProperty $taskNode "color" (Get-TaskColor $plan.Priority)
    }

    $projectNode = $projectNodeMap[$plan.CanonicalCode]
    $edgeMatches = @($edges | Where-Object { $_.id -eq $plan.EdgeId -or ($_.fromNode -eq $projectNode.id -and $_.toNode -eq $plan.TaskNodeId) })
    if ($edgeMatches.Count -eq 0) {
        $edges += New-TaskEdge $plan $projectNode
    }
    else {
        $edge = $edgeMatches[0]
        Set-ObjectProperty $edge "id" $plan.EdgeId
        Set-ObjectProperty $edge "fromNode" $projectNode.id
        Set-ObjectProperty $edge "fromSide" "right"
        Set-ObjectProperty $edge "toNode" $plan.TaskNodeId
        Set-ObjectProperty $edge "toSide" "left"
        Set-ObjectProperty $edge "label" "$($plan.Priority) task"
    }
}

if ($titleMatches.Count -eq 0) {
    $nodes += [pscustomobject][ordered]@{ id = "exec-title"; type = "text"; text = Get-ExpectedTitleText; x = 785; y = -1440; width = 1420; height = 180; color = "6" }
}
else {
    Set-ObjectProperty $titleMatches[0] "text" (Get-ExpectedTitleText)
}

if ($focusMatches.Count -eq 0) {
    $nodes += [pscustomobject][ordered]@{ id = "exec-weekly-focus-20260629"; type = "text"; text = Get-ExpectedFocusText; x = 785; y = -1180; width = 1420; height = 220; color = "4" }
}
else {
    Set-ObjectProperty $focusMatches[0] "text" (Get-ExpectedFocusText)
    Set-ObjectProperty $focusMatches[0] "x" 785
    Set-ObjectProperty $focusMatches[0] "y" -1180
    Set-ObjectProperty $focusMatches[0] "width" 1420
    Set-ObjectProperty $focusMatches[0] "height" 220
    Set-ObjectProperty $focusMatches[0] "color" "4"
}

if ($candidateMatches.Count -eq 0) {
    $nodes += [pscustomobject][ordered]@{ id = "exec-candidates"; type = "text"; text = Get-ExpectedCandidateText "Memory-only candidates left uncreated:"; x = 9060; y = 1040; width = 760; height = 320; color = "1" }
}
else {
    Set-ObjectProperty $candidateMatches[0] "text" (Get-ExpectedCandidateText ([string]$candidateMatches[0].text))
    if ((Get-NumberProperty $candidateMatches[0] "height") -lt 320) { Set-ObjectProperty $candidateMatches[0] "height" 320 }
}

Set-ObjectProperty $canvas "nodes" @($nodes)
Set-ObjectProperty $canvas "edges" @($edges)
$json = $canvas | ConvertTo-Json -Depth 100
$preview = $json | ConvertFrom-Json

$previewGroups = @($preview.nodes | Where-Object { $_.type -eq "group" -and $AllowedLanes -contains $_.label })
$previewTaskNodes = @($preview.nodes | Where-Object { $_.type -eq "file" -and $_.file -like "03_Projects/_Tasks/*$SourceEventId*" })
$previewTaskEdges = @($preview.edges | Where-Object { $_.id -like "weekly-edge-20260801-*" })
$previewDuplicateFiles = @($preview.nodes | Where-Object { $_.type -eq "file" -and $_.file } | Group-Object file | Where-Object { $_.Count -gt 1 })
$validationFailures = New-Object System.Collections.Generic.List[string]

if ($previewGroups.Count -ne 10) { $validationFailures.Add("Expected ten lifecycle groups after update.") }
if ($previewTaskNodes.Count -ne 11) { $validationFailures.Add("Expected eleven weekly task cards after update; found $($previewTaskNodes.Count).") }
if ($previewTaskEdges.Count -ne 11) { $validationFailures.Add("Expected eleven weekly project-task edges after update; found $($previewTaskEdges.Count).") }
if ($previewDuplicateFiles.Count -gt 0) { $validationFailures.Add("Duplicate file cards exist after update.") }

foreach ($plan in $ProjectPlans) {
    $node = @($preview.nodes | Where-Object { $_.type -eq "file" -and (Resolve-CanvasPath $_.file) -eq $plan.File })
    if ($node.Count -ne 1) {
        $validationFailures.Add("Project-card validation failed for $($plan.CanonicalCode).")
        continue
    }
    $lane = Get-NodeLane $node[0] $previewGroups
    if ($lane -ne $plan.Lane) { $validationFailures.Add("$($plan.CanonicalCode) is in '$lane' instead of '$($plan.Lane)'.") }
}

if ($validationFailures.Count -gt 0) {
    foreach ($failure in $validationFailures) { Write-Host "- $failure" }
    throw "Canvas preview validation failed. Original Canvas was not overwritten."
}

Set-Utf8Content $CanvasFullPath $json
$written = Get-Utf8Content $CanvasFullPath | ConvertFrom-Json
$writtenTaskNodes = @($written.nodes | Where-Object { $_.type -eq "file" -and $_.file -like "03_Projects/_Tasks/*$SourceEventId*" })
$writtenTaskEdges = @($written.edges | Where-Object { $_.id -like "weekly-edge-20260801-*" })

Write-Host "Apply completed."
Write-Host "Backup: $backupPath"
Write-Host "Nodes: $($nodes.Count)"
Write-Host "Edges: $($edges.Count)"
Write-Host "Weekly task cards: $($writtenTaskNodes.Count)"
Write-Host "Weekly project-task edges: $($writtenTaskEdges.Count)"
Write-Host "Canvas JSON validation: PASS"
