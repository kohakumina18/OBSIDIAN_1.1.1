param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$SkipCanvas,
    [switch]$SkipRegistry,
    [switch]$CreateWeeklyReport
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if ($Apply -and $DryRun) {
    throw "Use only one mode: -DryRun or -Apply."
}

if (-not $Apply) {
    $DryRun = $true
}

$VaultRoot = (Get-Location).ProviderPath
$WeekId = "20260629_20260705"
$WeekLabel = "2026-06-29 to 2026-07-05"
$NowStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$BackupRoot = Join-Path $VaultRoot "99_Attachments/Audit/Weekly_Progress_Update_Backup/$WeekId/$(Get-Date -Format 'yyyyMMdd_HHmmss')"
$CanvasRelPath = "03_Projects/Canvas/PPJ_Executive_Board.canvas"
$WeeklyReportRelPath = "10_Reports/PPJ_Weekly_Executive_Recap_2026-06-29_to_2026-07-05.md"

$RegistryFiles = @(
    "03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md",
    "03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md",
    "03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md"
)

function Get-Utf8Content {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

function Set-Utf8Content {
    param(
        [string]$Path,
        [string]$Content
    )

    $dir = Split-Path -Path $Path -Parent
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

function Backup-File {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }

    if (-not (Test-Path -LiteralPath $BackupRoot)) {
        New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
    }

    $resolved = (Resolve-Path -LiteralPath $Path).ProviderPath
    $relative = $resolved.Substring($VaultRoot.Length).TrimStart("\")
    $safeName = ($relative -replace "[:/\\]", "_") + ".bak"
    $dest = Join-Path $BackupRoot $safeName

    Copy-Item -LiteralPath $Path -Destination $dest -Force
}

function Normalize-PathText {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return ""
    }

    return ($Path -replace "\\", "/").TrimStart("/")
}

function ConvertTo-YamlQuoted {
    param([string]$Value)

    if ($null -eq $Value) {
        $Value = ""
    }

    $safe = $Value -replace '"', '\"'
    return '"' + $safe + '"'
}

function Set-YamlScalar {
    param(
        [string]$Yaml,
        [string]$Key,
        [string]$Value
    )

    $escapedKey = [regex]::Escape($Key)
    $line = "${Key}: $Value"

    if ($Yaml -match "(?m)^$escapedKey\s*:") {
        return [regex]::Replace($Yaml, "(?m)^$escapedKey\s*:.*$", $line)
    }

    if ([string]::IsNullOrWhiteSpace($Yaml)) {
        return $line
    }

    return $Yaml.TrimEnd() + "`r`n" + $line
}

function Split-MarkdownTableRow {
    param([string]$Line)

    $trimmed = $Line.Trim()
    if ($trimmed.StartsWith("|")) {
        $trimmed = $trimmed.Substring(1)
    }
    if ($trimmed.EndsWith("|")) {
        $trimmed = $trimmed.Substring(0, $trimmed.Length - 1)
    }

    return @($trimmed -split "\|", -1)
}

function Join-MarkdownTableRow {
    param([string[]]$Cells)

    $clean = @()
    foreach ($cell in $Cells) {
        $clean += $cell.Trim()
    }

    return "| " + ($clean -join " | ") + " |"
}

function New-CanvasId {
    return ([guid]::NewGuid().ToString("N").Substring(0, 16))
}

function Get-NumberProperty {
    param(
        [object]$Object,
        [string]$Name,
        [double]$Default = 0
    )

    if ($Object.PSObject.Properties.Name -contains $Name) {
        if ($null -ne $Object.$Name) {
            return [double]$Object.$Name
        }
    }

    return $Default
}

function Set-ObjectProperty {
    param(
        [object]$Object,
        [string]$Name,
        [object]$Value
    )

    if ($Object.PSObject.Properties.Name -contains $Name) {
        $Object.$Name = $Value
    }
    else {
        Add-Member -InputObject $Object -NotePropertyName $Name -NotePropertyValue $Value
    }
}

$ProjectUpdates = @(
    [pscustomobject]@{
        Code = "FIN.AI.FINANCE.MANAGEMENT.v1.1"
        Note = "03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1.md"
        Phase = "Discovery / BRD / Strategic Program"
        Lane = "ANALYSIS"
        Priority = "P1 / Top Focus"
        Rank = "1"
        CreateIfMissing = $false
        Summary = @'
Official kick-off completed on 2026-07-04. Scope corrected: this is not a generic AI Finance or Cash Flow Analytics MVP. Current program has three workstreams: Financial Reporting Automation as MVP P1, Costing Analysis, and Order / Sales Efficiency Analysis. MVP principle is One Company + One Period + One Approved Financial Report. Automated output must reconcile with the manual approved Finance report, or differences must be explainable. Data first, AI second. Finance owns finance logic.
'@
    },
    [pscustomobject]@{
        Code = "COSTING.AGENTIC.PLATFORM.v1.1"
        Note = "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
        Phase = "Analysis / Data Acquisition / Sew-first Implementation"
        Lane = "ANALYSIS"
        Priority = "P1"
        Rank = "2"
        CreateIfMissing = $false
        Summary = @'
Direction shifted from broad multi-agent concept to practical Sew-first implementation. Lam is following up business process and requesting historical and technical Sew data. Focus includes Sew costing process, similar product history, construction complexity, sewing operations, time, labor, SMV if available, and expert judgement.
'@
    },
    [pscustomobject]@{
        Code = "SCP.SOURCING.CHATBOT.v2.3"
        Note = "03_Projects/SCP.SOURCING.CHATBOT.v2.3.md"
        Phase = "UAT / Iterative Improvement"
        Lane = "STABILIZE / UAT"
        Priority = "P1"
        Rank = "3"
        CreateIfMissing = $false
        Summary = @'
Completed demo round 3. Continued testing chatbot behavior, search logic, data retrieval and user experience. Feedback and change requests are being collected and should be classified into bug, data issue, search issue, UI/UX and enhancement before fix and retest.
'@
    },
    [pscustomobject]@{
        Code = "PPJ.ExpenseInvoices.v1.1"
        Note = "03_Projects/PPJ. Expense-Invoices.v1.1.md"
        Phase = "UAT / Cross-department Expansion"
        Lane = "STABILIZE / UAT"
        Priority = "P1"
        Rank = "4"
        CreateIfMissing = $false
        Summary = @'
Expanded from EXIM solution toward Accounting and cross-department usage. Entered UAT. Continuing bug fixing, data mapping validation and accounting rule validation.
'@
    },
    [pscustomobject]@{
        Code = "PPJxQSee.AI"
        Note = "03_Projects/PPJxQSee.ai.md"
        Phase = "PoC / Sample Data Collection"
        Lane = "EXTERNAL / THIRD PARTIES"
        Priority = "P2"
        Rank = "5"
        CreateIfMissing = $false
        Summary = @'
Officially kicked off. Started collecting, standardizing and sending sample data for QC AI PoC. Need to finalize defect/image dataset and PoC success criteria.
'@
    },
    [pscustomobject]@{
        Code = "PUR.GDI.Automation.v1.0"
        Note = "03_Projects/PUR.GDI Automation.md"
        Phase = "Scope Reassessment"
        Lane = "ANALYSIS"
        Priority = "P2"
        Rank = "6"
        CreateIfMissing = $false
        Summary = @'
Technical feasibility improved significantly. Technical team identified a way to retrieve required data from multiple system screens. User confirmation may be bypassed. User may only need to provide style, item code and company branch. Project needs re-scope to confirm automation level, risk and final control points.
'@
    },
    [pscustomobject]@{
        Code = "FD.Datamart.v2.2"
        Note = "03_Projects/FD.Datamart.v2.2.md"
        Phase = "Final Stabilization / Closeout"
        Lane = "STABILIZE / UAT"
        Priority = "P2"
        Rank = "7"
        CreateIfMissing = $false
        Summary = @'
Fully updated during the week. Preparing project closeout from the week starting 2026-07-06. After acceptance, expected transition is Closed / Maintenance Only.
'@
    },
    [pscustomobject]@{
        Code = "PPJ.UIT.ACADEMIC.COLLABORATION.v1.1"
        Note = "03_Projects/PPJ.UIT.ACADEMIC.COLLABORATION.v1.1.md"
        Phase = "Partnership Follow-up / Confirmed Direction"
        Lane = "EXTERNAL / THIRD PARTIES"
        Priority = "P2"
        Rank = "8"
        CreateIfMissing = $false
        Summary = @'
Madame Hong Phuong and UIT Information Systems Faculty confirmed collaboration direction. Next step is to convert broad direction into specific workstreams: thesis topics, course projects, AISC, mentoring, prototype topics and possible PPJ-themed contest.
'@
    },
    [pscustomobject]@{
        Code = "PPJ.InvoiceDownloader.v1.2"
        Note = "03_Projects/PPJ.Invoice Downloader.v1.2.md"
        Phase = "Production / Business Adoption"
        Lane = "PRODUCTION / SUPPORT"
        Priority = "P2"
        Rank = "9"
        CreateIfMissing = $false
        Summary = @'
Business adoption started. Chi Binh received data and started building reports and dashboard. Continue monitoring data quality and downstream business usage.
'@
    },
    [pscustomobject]@{
        Code = "MER.MARKET.INTELLIGENCE.v1.1"
        Note = "03_Projects/E-commerce Market Intelligence.md"
        Phase = "Analysis / Multi-source Data Follow-up"
        Lane = "ANALYSIS"
        Priority = "P2"
        Rank = "10"
        CreateIfMissing = $false
        Summary = @'
Scope confirmed as Market Intelligence, not a standalone e-commerce project. Continue following up multi-source data: sales history, PO, customer, inventory, product history and Quince consumer signals.
'@
    },
    [pscustomobject]@{
        Code = "QC.Primo1D.RFID.Thread.v1.0"
        Note = "03_Projects/PPJ XPrimo1D RFID Thread.md"
        Phase = "Pre-contact / Internal Alignment"
        Lane = "EXTERNAL / THIRD PARTIES"
        Priority = "TBD"
        Rank = "11"
        CreateIfMissing = $false
        Summary = @'
No official initial vendor contact yet. Already reported to anh Cuong. QC is identifying the responsible person. No vendor meeting or PoC yet.
'@
    },
    [pscustomobject]@{
        Code = "MER.PO.Commit.v1.1"
        Note = "03_Projects/MER.PO-Commit.md"
        Phase = "DONE / CLOSED"
        Lane = "CLOSED / CANCELLED"
        Priority = "Closed"
        Rank = ""
        CreateIfMissing = $false
        Summary = "Full scope completed and officially closed."
    },
    [pscustomobject]@{
        Code = "EXIM.ExpenseInvoices.Automation.v1.1"
        Note = "03_Projects/EXIM.ExpenseInvoices.Automation.v1.1.md"
        Phase = "DONE / CLOSED"
        Lane = "CLOSED / CANCELLED"
        Priority = "Closed"
        Rank = ""
        CreateIfMissing = $true
        Summary = "Project completed and closed. Solution foundation is now being extended through PPJ.ExpenseInvoices.v1.1 for Accounting and cross-department scope."
    },
    [pscustomobject]@{
        Code = "AI.Automation.Workshop.202606"
        Note = "03_Projects/AI Automation Workshop.md"
        Phase = "DONE / CLOSED"
        Lane = "CLOSED / CANCELLED"
        Priority = "Closed"
        Rank = ""
        CreateIfMissing = $false
        Summary = "Workshop project completed and closed. Follow-up analysis remains tracked separately in Workshop Analysis."
    },
    [pscustomobject]@{
        Code = "VITAS.Sharing.202606"
        Note = "03_Projects/VITAS Sharing.md"
        Phase = "DONE / CLOSED"
        Lane = "CLOSED / CANCELLED"
        Priority = "Closed"
        Rank = ""
        CreateIfMissing = $false
        Summary = "Sharing/conference scope completed and closed."
    }
)

function New-ProjectNoteContent {
    param([object]$Item)

    $name = [System.IO.Path]::GetFileNameWithoutExtension($Item.Note)
    $projectName = ConvertTo-YamlQuoted $name
    $code = ConvertTo-YamlQuoted $Item.Code
    $phase = ConvertTo-YamlQuoted $Item.Phase
    $priority = ConvertTo-YamlQuoted $Item.Priority
    $lane = ConvertTo-YamlQuoted $Item.Lane
    $created = ConvertTo-YamlQuoted $NowStamp

    return @"
---
type: "project"
project_name: $projectName
project_code: $code
phase: $phase
status: $phase
priority: $priority
phase_canvas_group: $lane
created_from: "weekly progress update $WeekLabel"
created: $created
---

# $($Item.Code)

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

## Executive Summary

$($Item.Summary)

## Current Phase / Status

$($Item.Phase)

## Next Actions

- Preserve weekly closure/update traceability.
- Confirm any remaining owner/action items with business stakeholders.

## Do Not Drift Rules

- Do not change project scope without new source update.
- Use weekly update and source project memory before making claims.

<!-- PPJ_PROJECT_KNOWLEDGE_END -->
"@
}

function Update-ProjectNote {
    param([object]$Item)

    $path = Join-Path $VaultRoot $Item.Note

    if (-not (Test-Path -LiteralPath $path)) {
        if (-not $Item.CreateIfMissing) {
            return [pscustomobject]@{ File = $Item.Note; Result = "SKIPPED"; Reason = "Project note not found" }
        }

        if ($DryRun) {
            return [pscustomobject]@{ File = $Item.Note; Result = "WOULD_CREATE"; Reason = "Missing project note would be created" }
        }

        Set-Utf8Content -Path $path -Content (New-ProjectNoteContent -Item $Item)
    }

    $content = Get-Utf8Content -Path $path
    $original = $content
    $frontmatterMatch = [regex]::Match($content, "(?s)\A---\r?\n(.*?)\r?\n---\r?\n?")

    $phaseValue = ConvertTo-YamlQuoted $Item.Phase
    $priorityValue = ConvertTo-YamlQuoted $Item.Priority
    $laneValue = ConvertTo-YamlQuoted $Item.Lane
    $codeValue = ConvertTo-YamlQuoted $Item.Code
    $updatedValue = ConvertTo-YamlQuoted $NowStamp
    $weekValue = ConvertTo-YamlQuoted $WeekLabel

    if ($frontmatterMatch.Success) {
        $yaml = $frontmatterMatch.Groups[1].Value
        $body = $content.Substring($frontmatterMatch.Length)

        $yaml = Set-YamlScalar -Yaml $yaml -Key "type" -Value (ConvertTo-YamlQuoted "project")
        $yaml = Set-YamlScalar -Yaml $yaml -Key "project_code" -Value $codeValue
        $yaml = Set-YamlScalar -Yaml $yaml -Key "phase" -Value $phaseValue
        $yaml = Set-YamlScalar -Yaml $yaml -Key "status" -Value $phaseValue
        $yaml = Set-YamlScalar -Yaml $yaml -Key "priority" -Value $priorityValue
        $yaml = Set-YamlScalar -Yaml $yaml -Key "phase_canvas_group" -Value $laneValue
        $yaml = Set-YamlScalar -Yaml $yaml -Key "last_updated" -Value $updatedValue
        $yaml = Set-YamlScalar -Yaml $yaml -Key "last_weekly_update" -Value $weekValue

        if (-not [string]::IsNullOrWhiteSpace($Item.Rank)) {
            $yaml = Set-YamlScalar -Yaml $yaml -Key "weekly_rank" -Value (ConvertTo-YamlQuoted $Item.Rank)
        }

        $content = "---`r`n$yaml`r`n---`r`n$body"
    }
    else {
        $front = @"
---
type: "project"
project_code: "$($Item.Code)"
phase: "$($Item.Phase)"
status: "$($Item.Phase)"
priority: "$($Item.Priority)"
phase_canvas_group: "$($Item.Lane)"
last_updated: "$NowStamp"
last_weekly_update: "$WeekLabel"
---

"@
        $content = $front + $content
    }

    $start = "<!-- PPJ_WEEKLY_UPDATE_${WeekId}_START -->"
    $end = "<!-- PPJ_WEEKLY_UPDATE_${WeekId}_END -->"
    $rankLine = ""
    if (-not [string]::IsNullOrWhiteSpace($Item.Rank)) {
        $rankLine = "- Weekly priority rank: $($Item.Rank)`r`n"
    }

    $block = @"
$start
## Weekly Update - $WeekLabel

- Project code: `$($Item.Code)`
- Phase: $($Item.Phase)
- Executive Canvas lane: $($Item.Lane)
- Priority: $($Item.Priority)
$rankLine
$($Item.Summary)

Related Concepts
[[Outcome Driven Thinking]]
[[System Thinking]]
[[Data Governance]]
[[Traceability]]

Methods
[[Impact Analysis]]
[[Requirement Elicitation]]
[[Data Mapping]]

Deliverables
[[Decision_Driven_BRD]]
[[ERD_Template]]
[[User_Manual_Template]]

$end
"@

    $pattern = "(?s)<!-- PPJ_WEEKLY_UPDATE_${WeekId}_START -->.*?<!-- PPJ_WEEKLY_UPDATE_${WeekId}_END -->"
    if ($content -match $pattern) {
        $content = [regex]::Replace($content, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $block })
    }
    else {
        $content = $content.TrimEnd() + "`r`n`r`n" + $block + "`r`n"
    }

    if ($content -ne $original) {
        if (-not $DryRun) {
            Backup-File -Path $path
            Set-Utf8Content -Path $path -Content $content
        }

        if ($DryRun) {
            return [pscustomobject]@{ File = $Item.Note; Result = "WOULD_UPDATE"; Reason = "Phase/status/weekly block would be updated" }
        }

        return [pscustomobject]@{ File = $Item.Note; Result = "UPDATED"; Reason = "Phase/status/weekly block updated" }
    }

    return [pscustomobject]@{ File = $Item.Note; Result = "UNCHANGED"; Reason = "Already up to date" }
}

function Update-MarkdownRegistryTable {
    param(
        [string]$RelPath,
        [object[]]$Updates
    )

    $path = Join-Path $VaultRoot $RelPath
    if (-not (Test-Path -LiteralPath $path)) {
        return @([pscustomobject]@{ File = $RelPath; Result = "SKIPPED"; Reason = "Registry file not found" })
    }

    $lines = @(Get-Content -LiteralPath $path -Encoding UTF8)
    $changed = $false
    $results = @()
    $headerIndex = -1

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^\s*\|" -and $lines[$i] -like "*Project*" -and $lines[$i] -like "*Phase*") {
            $headerIndex = $i
            break
        }
    }

    if ($headerIndex -lt 0) {
        return @([pscustomobject]@{ File = $RelPath; Result = "SKIPPED"; Reason = "No project table with Phase column found" })
    }

    $headers = Split-MarkdownTableRow -Line $lines[$headerIndex]
    $phaseCol = -1
    $priorityCol = -1
    $noteCol = -1

    for ($h = 0; $h -lt $headers.Count; $h++) {
        $name = $headers[$h].Trim()
        if ($name -eq "Phase") { $phaseCol = $h }
        if ($name -eq "Priority") { $priorityCol = $h }
        if ($name -eq "Project Note" -or $name -eq "Current File" -or $name -eq "Canonical File") { $noteCol = $h }
    }

    if ($phaseCol -lt 0) {
        return @([pscustomobject]@{ File = $RelPath; Result = "SKIPPED"; Reason = "Phase column not found" })
    }

    foreach ($item in $Updates) {
        $leaf = Split-Path -Path $item.Note -Leaf
        $noteBase = [System.IO.Path]::GetFileNameWithoutExtension($leaf)
        $found = $false

        for ($r = $headerIndex + 2; $r -lt $lines.Count; $r++) {
            if ($lines[$r] -notmatch "^\s*\|") { break }
            if ($lines[$r] -notlike "*$($item.Code)*" -and $lines[$r] -notlike "*$leaf*" -and $lines[$r] -notlike "*$noteBase*") { continue }

            $cells = Split-MarkdownTableRow -Line $lines[$r]

            if ($cells.Count -gt $phaseCol -and $cells[$phaseCol].Trim() -ne $item.Phase) {
                $cells[$phaseCol] = " $($item.Phase) "
                $changed = $true
            }

            if ($priorityCol -ge 0 -and $cells.Count -gt $priorityCol -and $cells[$priorityCol].Trim() -ne $item.Priority) {
                $cells[$priorityCol] = " $($item.Priority) "
                $changed = $true
            }

            if ($noteCol -ge 0 -and $cells.Count -gt $noteCol -and $cells[$noteCol].Trim() -eq "TBD" -and (Test-Path -LiteralPath (Join-Path $VaultRoot $item.Note))) {
                $cells[$noteCol] = " [[" + $noteBase + "]] "
                $changed = $true
            }

            $lines[$r] = Join-MarkdownTableRow -Cells $cells
            $found = $true

            if ($DryRun) {
                $results += [pscustomobject]@{ File = $RelPath; Result = "WOULD_UPDATE"; Reason = "$($item.Code) phase/priority would be synced" }
            }
            else {
                $results += [pscustomobject]@{ File = $RelPath; Result = "UPDATED"; Reason = "$($item.Code) phase/priority synced" }
            }

            break
        }

        if (-not $found) {
            $results += [pscustomobject]@{ File = $RelPath; Result = "SKIPPED"; Reason = "$($item.Code) not found in table" }
        }
    }

    if ($changed -and -not $DryRun) {
        Backup-File -Path $path
        Set-Utf8Content -Path $path -Content ($lines -join "`r`n")
    }

    return $results
}

function Update-ExecutiveCanvas {
    $path = Join-Path $VaultRoot $CanvasRelPath
    if (-not (Test-Path -LiteralPath $path)) {
        return @([pscustomobject]@{ File = $CanvasRelPath; Result = "SKIPPED"; Reason = "Canvas not found" })
    }

    $canvas = Get-Utf8Content -Path $path | ConvertFrom-Json
    $nodes = @($canvas.nodes)
    $lanes = @("PENDING", "ANALYSIS", "DESIGN", "DEVELOPMENT", "STABILIZE / UAT", "PRODUCTION / SUPPORT", "EXTERNAL / THIRD PARTIES", "BLOCKED / DEPENDENCY", "TASKS / DOCS TO UPDATE", "CLOSED / CANCELLED")
    $laneWidth = 520
    $laneHeight = 900
    $laneGap = 70
    $laneMap = @{}

    for ($i = 0; $i -lt $lanes.Count; $i++) {
        $label = $lanes[$i]
        $x = $i * ($laneWidth + $laneGap)
        $existing = @($nodes | Where-Object { $_.type -eq "group" -and $_.label -eq $label } | Select-Object -First 1)

        if ($existing.Count -eq 0) {
            $groupObj = [pscustomobject]@{ id = New-CanvasId; type = "group"; x = $x; y = 0; width = $laneWidth; height = $laneHeight; label = $label; color = "1" }
            $nodes += $groupObj
            $existing = @($groupObj)
        }
        else {
            Set-ObjectProperty -Object $existing[0] -Name "x" -Value $x
            Set-ObjectProperty -Object $existing[0] -Name "y" -Value 0
            Set-ObjectProperty -Object $existing[0] -Name "width" -Value $laneWidth
            Set-ObjectProperty -Object $existing[0] -Name "height" -Value $laneHeight
            Set-ObjectProperty -Object $existing[0] -Name "label" -Value $label
        }

        $laneMap[$label] = [pscustomobject]@{ X = $x; Y = 0; Width = $laneWidth; Height = $laneHeight }
    }

    $focusMarker = "PPJ_WEEKLY_TOP_FOCUS_20260629_20260705"
    $analysisLane = $laneMap["ANALYSIS"]
    $focusText = @"
$focusMarker

WEEKLY TOP FOCUS
2026-06-29 to 2026-07-05

FIN.AI.FINANCE.MANAGEMENT.v1.1
Phase: Discovery / BRD / Strategic Program
MVP: Financial Reporting Automation
Rule: One Company + One Period + One Report
"@

    $focusNode = @($nodes | Where-Object { $_.type -eq "text" -and $_.text -like "*$focusMarker*" } | Select-Object -First 1)
    if ($focusNode.Count -eq 0) {
        $nodes += [pscustomobject]@{ id = New-CanvasId; type = "text"; x = $analysisLane.X + 20; y = $analysisLane.Y + 45; width = 470; height = 160; text = $focusText; color = "4" }
    }
    else {
        Set-ObjectProperty -Object $focusNode[0] -Name "x" -Value ($analysisLane.X + 20)
        Set-ObjectProperty -Object $focusNode[0] -Name "y" -Value ($analysisLane.Y + 45)
        Set-ObjectProperty -Object $focusNode[0] -Name "width" -Value 470
        Set-ObjectProperty -Object $focusNode[0] -Name "height" -Value 160
        Set-ObjectProperty -Object $focusNode[0] -Name "text" -Value $focusText
        Set-ObjectProperty -Object $focusNode[0] -Name "color" -Value "4"
    }

    $laneCounters = @{}
    foreach ($lane in $lanes) { $laneCounters[$lane] = 0 }

    $orderedUpdates = @($ProjectUpdates | Sort-Object @{ Expression = { if ([string]::IsNullOrWhiteSpace($_.Rank)) { 999 } else { [int]$_.Rank } } })

    foreach ($item in $orderedUpdates) {
        if (-not $laneMap.ContainsKey($item.Lane)) { continue }

        $fullProjectPath = Join-Path $VaultRoot $item.Note
        if (-not (Test-Path -LiteralPath $fullProjectPath) -and -not $item.CreateIfMissing) { continue }

        $laneInfo = $laneMap[$item.Lane]
        $idx = [int]$laneCounters[$item.Lane]
        $baseY = $laneInfo.Y + 70
        if ($item.Lane -eq "ANALYSIS") { $baseY = $laneInfo.Y + 230 }

        $col = $idx % 2
        $row = [math]::Floor($idx / 2)
        $cardX = $laneInfo.X + 25 + ($col * 240)
        $cardY = $baseY + ($row * 85)
        $normalizedNote = Normalize-PathText $item.Note

        $fileNode = @($nodes | Where-Object { $_.type -eq "file" -and $_.file -and (Normalize-PathText $_.file) -eq $normalizedNote } | Select-Object -First 1)
        if ($fileNode.Count -eq 0) {
            $nodes += [pscustomobject]@{ id = New-CanvasId; type = "file"; x = $cardX; y = $cardY; width = 220; height = 60; file = $normalizedNote }
        }
        else {
            Set-ObjectProperty -Object $fileNode[0] -Name "x" -Value $cardX
            Set-ObjectProperty -Object $fileNode[0] -Name "y" -Value $cardY
            Set-ObjectProperty -Object $fileNode[0] -Name "width" -Value 220
            Set-ObjectProperty -Object $fileNode[0] -Name "height" -Value 60
            Set-ObjectProperty -Object $fileNode[0] -Name "file" -Value $normalizedNote
        }

        $laneCounters[$item.Lane] = $idx + 1
    }

    Set-ObjectProperty -Object $canvas -Name "nodes" -Value $nodes
    $json = $canvas | ConvertTo-Json -Depth 100

    if ($DryRun) {
        return @([pscustomobject]@{ File = $CanvasRelPath; Result = "WOULD_UPDATE"; Reason = "Executive Canvas lanes/project cards would be updated" })
    }

    Backup-File -Path $path
    Set-Utf8Content -Path $path -Content $json
    $null = Get-Utf8Content -Path $path | ConvertFrom-Json

    return @([pscustomobject]@{ File = $CanvasRelPath; Result = "UPDATED"; Reason = "Executive Canvas updated and JSON validated" })
}

function Write-WeeklyReportOptional {
    if (-not $CreateWeeklyReport) {
        return [pscustomobject]@{ File = $WeeklyReportRelPath; Result = "SKIPPED"; Reason = "Weekly report file not requested; use -CreateWeeklyReport to write it" }
    }

    $path = Join-Path $VaultRoot $WeeklyReportRelPath
    $content = @"
---
type: weekly_report
portfolio: "PPJ AI / Automation / Data"
week: "$WeekLabel"
created_from: "Apply-PPJWeeklyProgress-20260629-20260705.ps1"
---

# Weekly Executive Recap

## AI / Automation / Data Portfolio

## $WeekLabel

FIN.AI.FINANCE.MANAGEMENT.v1.1 is the top focus. Scope is corrected to Financial Reporting Automation MVP first, then Costing Analysis, then Order / Sales Efficiency Analysis.

Priority for the week starting 2026-07-06:

| Rank | Project | Focus |
|---:|---|---|
| 1 | [[FIN.AI.FINANCE.MANAGEMENT.v1.1]] | Current report, source report, mapping, pilot company/month and Discovery completion |
| 2 | [[PPJ.COSTING.AGENT.PLATFORM.v1.1]] | Sew data collection and costing process mapping |
| 3 | [[SCP.SOURCING.CHATBOT.v2.3]] | Demo 3 feedback, fix and retest |
| 4 | [[PPJ. Expense-Invoices.v1.1]] | UAT and defect fixing |
| 5 | [[PPJxQSee.ai]] | Sample dataset and PoC success criteria |
| 6 | [[PUR.GDI Automation]] | Re-scope and bypass confirmation risk review |
| 7 | [[FD.Datamart.v2.2]] | Project closeout |
| 8 | [[PPJ.UIT.ACADEMIC.COLLABORATION.v1.1]] | Workstream and topic list confirmation |
| 9 | [[PPJ.Invoice Downloader.v1.2]] | Business adoption and data quality monitoring |
"@

    if ($DryRun) {
        return [pscustomobject]@{ File = $WeeklyReportRelPath; Result = "WOULD_WRITE"; Reason = "Weekly report would be created/updated" }
    }

    if (Test-Path -LiteralPath $path) { Backup-File -Path $path }
    Set-Utf8Content -Path $path -Content $content
    return [pscustomobject]@{ File = $WeeklyReportRelPath; Result = "WRITTEN"; Reason = "Weekly report created/updated" }
}

Write-Host ""
Write-Host "PPJ Weekly Progress Update"
Write-Host "Vault: $VaultRoot"
Write-Host "Week: $WeekLabel"
Write-Host "Mode: $(if ($DryRun) { 'DRYRUN' } else { 'APPLY' })"
Write-Host ""

$results = @()
$results += Write-WeeklyReportOptional

foreach ($item in $ProjectUpdates) {
    $results += Update-ProjectNote -Item $item
}

if (-not $SkipRegistry) {
    foreach ($registry in $RegistryFiles) {
        $results += Update-MarkdownRegistryTable -RelPath $registry -Updates $ProjectUpdates
    }
}

if (-not $SkipCanvas) {
    $results += Update-ExecutiveCanvas
}

Write-Host "Results:"
Write-Host ""
foreach ($r in $results) {
    Write-Host ("[{0}] {1} - {2}" -f $r.Result, $r.File, $r.Reason)
}

if (-not $DryRun) {
    $logPath = Join-Path $BackupRoot "WEEKLY_PROGRESS_UPDATE_LOG_$WeekId.txt"
    if (-not (Test-Path -LiteralPath $BackupRoot)) {
        New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
    }

    $log = @()
    $log += "Weekly Progress Update Log"
    $log += "Week: $WeekLabel"
    $log += "Timestamp: $NowStamp"
    $log += "Backup root: $BackupRoot"
    $log += ""
    foreach ($r in $results) {
        $log += ("{0}`t{1}`t{2}" -f $r.Result, $r.File, $r.Reason)
    }

    Set-Utf8Content -Path $logPath -Content ($log -join "`r`n")
    Write-Host ""
    Write-Host "Apply complete."
    Write-Host "Backup root: $BackupRoot"
    Write-Host "Log: $logPath"
}
else {
    Write-Host ""
    Write-Host "DryRun complete. No files changed."
}
