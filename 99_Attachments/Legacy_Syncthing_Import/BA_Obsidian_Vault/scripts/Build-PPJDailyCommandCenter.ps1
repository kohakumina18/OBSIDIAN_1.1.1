param(
    [datetime]$Date = (Get-Date),

    [int]$LookbackDays = 14,

    [int]$MaxItems = 12,

    [switch]$Force
)

$ErrorActionPreference = "Stop"

# -------------------------
# Paths
# -------------------------
$vaultRoot = (Get-Location).Path
$dailyRoot = Join-Path $vaultRoot "01_Daily_Notes"
$projectRoot = Join-Path $vaultRoot "03_Projects"
$taskRoot = Join-Path $vaultRoot "03_Projects\_Tasks"
$decisionRoot = Join-Path $vaultRoot "07_Decision_Log"
$meetingRoot = Join-Path $vaultRoot "08_Meeting_Notes"
$deliverableRoot = Join-Path $vaultRoot "10_Deliverables"

New-Item -ItemType Directory -Force -Path $dailyRoot | Out-Null
New-Item -ItemType Directory -Force -Path $taskRoot | Out-Null
New-Item -ItemType Directory -Force -Path $decisionRoot | Out-Null
New-Item -ItemType Directory -Force -Path $meetingRoot | Out-Null
New-Item -ItemType Directory -Force -Path $deliverableRoot | Out-Null

$dateStamp = $Date.ToString("yyyy-MM-dd")
$dailyPath = Join-Path $dailyRoot "${dateStamp}_Daily_Command_Center.md"
$cutoff = (Get-Date).AddDays(-1 * [Math]::Abs($LookbackDays))

if ((Test-Path $dailyPath) -and (-not $Force)) {
    throw "Daily command center already exists: $dailyPath. Re-run with -Force to overwrite."
}

# -------------------------
# Helpers
# -------------------------
function Read-Utf8 {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return ""
    }

    return Get-Content -Raw -Encoding UTF8 $Path
}

function Write-Utf8 {
    param(
        [string]$Path,
        [string]$Text
    )

    $Text | Set-Content -Encoding UTF8 $Path
}

function ConvertTo-WikiName {
    param([string]$Path)
    return [System.IO.Path]::GetFileNameWithoutExtension($Path)
}

function New-WikiLink {
    param([string]$Name)

    if ([string]::IsNullOrWhiteSpace($Name)) {
        return "[[TBD]]"
    }

    return "[[$($Name.Trim())]]"
}

function Clean-Line {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return "TBD"
    }

    $clean = $Value.Trim()
    $clean = $clean -replace '^[-*#>\s]+', ''
    $clean = $clean -replace '^\[[ xX]\]\s*', ''
    $clean = $clean -replace '[\r\n]+', ' '

    if ([string]::IsNullOrWhiteSpace($clean)) {
        return "TBD"
    }

    return $clean
}

function Get-Field {
    param(
        [string]$Text,
        [string[]]$Names,
        [string]$Default = "TBD"
    )

    foreach ($name in $Names) {
        $escaped = [regex]::Escape($name)

        $frontMatterPattern = "(?im)^$escaped\s*:\s*`"?([^`"\r\n]+)`"?\s*$"
        $match = [regex]::Match($Text, $frontMatterPattern)
        if ($match.Success) {
            return (Clean-Line $match.Groups[1].Value)
        }

        $labelPattern = "(?im)^$escaped\s*:\s*(.+)$"
        $match = [regex]::Match($Text, $labelPattern)
        if ($match.Success) {
            return (Clean-Line $match.Groups[1].Value)
        }
    }

    return $Default
}

function Get-FirstLineMatching {
    param(
        [string]$Text,
        [string[]]$Patterns,
        [string]$Default = "TBD"
    )

    $lines = $Text -split "`r?`n"
    foreach ($pattern in $Patterns) {
        foreach ($line in $lines) {
            if ($line -match $pattern) {
                return (Clean-Line $line)
            }
        }
    }

    return $Default
}

function Get-UncheckedTasks {
    param(
        [string]$Text,
        [string]$Source
    )

    $items = @()
    $lines = $Text -split "`r?`n"

    foreach ($line in $lines) {
        if ($line -match '^\s*[-*]\s+\[\s\]\s+(.+)$') {
            $items += [pscustomobject]@{
                Text = Clean-Line $matches[1]
                Source = $Source
            }
        }
    }

    return $items
}

function Get-RecentMarkdownFiles {
    param([string]$Root)

    if (-not (Test-Path $Root)) {
        return @()
    }

    return @(Get-ChildItem -Path $Root -Filter "*.md" -File -Recurse | Where-Object {
        $_.FullName -notmatch '\\.obsidian\\' -and
        $_.FullName -notmatch '\\99_Attachments\\' -and
        $_.LastWriteTime -ge $cutoff
    } | Sort-Object LastWriteTime -Descending)
}

function Get-ProjectFiles {
    if (-not (Test-Path $projectRoot)) {
        return @()
    }

    return @(Get-ChildItem -Path $projectRoot -Filter "*.md" -File | Sort-Object LastWriteTime -Descending)
}

function Get-ProjectRecords {
    $records = @()

    foreach ($file in (Get-ProjectFiles)) {
        $raw = Read-Utf8 $file.FullName
        $wikiName = ConvertTo-WikiName $file.FullName
        $projectName = Get-Field $raw @("project_name", "Project name", "Project") $wikiName
        if ($projectName -eq "TBD") {
            $projectName = $wikiName
        }

        $phase = Get-Field $raw @("phase", "Phase") "TBD"
        $owner = Get-Field $raw @("owner", "Owner") "TBD"
        $department = Get-Field $raw @("department", "Department", "cluster", "Cluster") "TBD"
        $status = Get-Field $raw @("status", "Current status", "Status") "TBD"
        $progress = Get-Field $raw @("progress", "Progress", "progress_percentage", "Progress percentage") "TBD"
        $outcome = Get-Field $raw @("business_outcome", "Business Outcome", "Outcome") "TBD"
        $nextAction = Get-Field $raw @("next_action", "Next action", "Next Action") "TBD"
        if ($nextAction -eq "TBD") {
            $nextAction = Get-FirstLineMatching $raw @("(?i)next action", "(?i)next step", "(?i)follow.?up") "TBD"
        }

        $blocker = Get-Field $raw @("blocker", "Blocker", "blocked_by", "Blocked by") "TBD"
        if ($blocker -eq "TBD") {
            $blocker = Get-FirstLineMatching $raw @("(?i)blocked", "(?i)blocker", "(?i)dependency", "(?i)waiting for") "TBD"
        }

        $decision = Get-Field $raw @("decision_needed", "Decision needed", "Decision Needed") "TBD"
        if ($decision -eq "TBD") {
            $decision = Get-FirstLineMatching $raw @("(?i)decision needed", "(?i)decision", "(?i)approval", "(?i)confirm") "TBD"
        }

        $docSignal = Get-FirstLineMatching $raw @("(?i)BRD", "(?i)ERD", "(?i)SOP", "(?i)user manual", "(?i)deliverable", "(?i)document") "TBD"
        $openTasks = @(Get-UncheckedTasks $raw $wikiName)

        $isActive = $phase -notmatch '(?i)closed|cancelled' -and $status -notmatch '(?i)closed|done|cancelled'
        $isBlocked = ($phase -match '(?i)blocked|dependency') -or ($blocker -ne "TBD")
        $needsDecision = $decision -ne "TBD"
        $needsDocs = $docSignal -ne "TBD"
        $recent = $file.LastWriteTime -ge $cutoff

        $records += [pscustomobject]@{
            Name = $projectName
            WikiName = $wikiName
            Link = New-WikiLink $wikiName
            Phase = $phase
            Owner = $owner
            Department = $department
            Status = $status
            Progress = $progress
            Outcome = $outcome
            NextAction = $nextAction
            Blocker = $blocker
            Decision = $decision
            DocumentSignal = $docSignal
            OpenTaskCount = $openTasks.Count
            IsActive = $isActive
            IsBlocked = $isBlocked
            NeedsDecision = $needsDecision
            NeedsDocs = $needsDocs
            Recent = $recent
            LastWriteTime = $file.LastWriteTime
        }
    }

    return $records
}

function Add-Section {
    param(
        [System.Collections.ArrayList]$Lines,
        [string]$Title
    )

    [void]$Lines.Add("")
    [void]$Lines.Add("## $Title")
    [void]$Lines.Add("")
}

function Add-EmptyState {
    param(
        [System.Collections.ArrayList]$Lines,
        [string]$Text
    )

    [void]$Lines.Add("- $Text")
}

function Limit-Items {
    param([object[]]$Items)
    return @($Items | Select-Object -First $MaxItems)
}

# -------------------------
# Scan vault context
# -------------------------
$projects = @(Get-ProjectRecords)
$activeProjects = @($projects | Where-Object { $_.IsActive })
$criticalProjects = @($activeProjects | Where-Object { $_.IsBlocked -or $_.NeedsDecision -or $_.Phase -match '(?i)development|stabilize|production' } | Sort-Object @{ Expression = "IsBlocked"; Descending = $true }, @{ Expression = "NeedsDecision"; Descending = $true }, LastWriteTime -Descending)
$blockedProjects = @($activeProjects | Where-Object { $_.IsBlocked } | Sort-Object LastWriteTime -Descending)
$decisionProjects = @($activeProjects | Where-Object { $_.NeedsDecision } | Sort-Object LastWriteTime -Descending)
$docProjects = @($activeProjects | Where-Object { $_.NeedsDocs -or $_.OpenTaskCount -gt 0 } | Sort-Object LastWriteTime -Descending)

$taskFiles = @(Get-RecentMarkdownFiles $taskRoot)
$decisionFiles = @(Get-RecentMarkdownFiles $decisionRoot)
$meetingFiles = @(Get-RecentMarkdownFiles $meetingRoot)
$deliverableFiles = @(Get-RecentMarkdownFiles $deliverableRoot)

$openTaskItems = @()
foreach ($file in @($taskFiles + (Get-ProjectFiles))) {
    $raw = Read-Utf8 $file.FullName
    $source = ConvertTo-WikiName $file.FullName
    $openTaskItems += @(Get-UncheckedTasks $raw $source)
}

$decisionItems = @()
foreach ($file in $decisionFiles) {
    $raw = Read-Utf8 $file.FullName
    $source = ConvertTo-WikiName $file.FullName
    $summary = Get-FirstLineMatching $raw @("(?i)decision", "(?i)approval", "(?i)option", "(?i)recommend") "Review decision log for pending decision or rationale."
    $decisionItems += [pscustomobject]@{
        Text = $summary
        Source = $source
        LastWriteTime = $file.LastWriteTime
    }
}

$meetingItems = @()
foreach ($file in $meetingFiles) {
    $raw = Read-Utf8 $file.FullName
    $source = ConvertTo-WikiName $file.FullName
    $next = Get-FirstLineMatching $raw @("(?i)next action", "(?i)action item", "(?i)follow.?up", "(?i)decision") "Review meeting note for actions and decisions."
    $meetingItems += [pscustomobject]@{
        Text = $next
        Source = $source
        LastWriteTime = $file.LastWriteTime
    }
}

# -------------------------
# Build Markdown
# -------------------------
$lines = New-Object System.Collections.ArrayList

[void]$lines.Add("# PPJ Daily Command Center - $dateStamp")
[void]$lines.Add("")
[void]$lines.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
[void]$lines.Add("")
[void]$lines.Add("Source scope: project notes, task notes, decision logs, deliverables, and meeting notes updated in the last $LookbackDays days.")
[void]$lines.Add("")
[void]$lines.Add("Related Concepts")
[void]$lines.Add("[[Outcome Driven Thinking]]")
[void]$lines.Add("[[System Thinking]]")
[void]$lines.Add("[[Decision Making]]")
[void]$lines.Add("[[Traceability]]")
[void]$lines.Add("[[Portfolio Management]]")
[void]$lines.Add("")
[void]$lines.Add("Methods")
[void]$lines.Add("[[Impact Analysis]]")
[void]$lines.Add("[[Decision Matrix]]")
[void]$lines.Add("[[Requirement Validation]]")
[void]$lines.Add("[[Data Mapping]]")

Add-Section $lines "Today Focus"
if ($criticalProjects.Count -gt 0) {
    foreach ($p in (Limit-Items $criticalProjects)) {
        $insight = "Protect progress for $($p.Link): phase $($p.Phase), owner $($p.Owner), next action: $($p.NextAction)."
        if ($p.IsBlocked) {
            $insight = "Unblock $($p.Link): $($p.Blocker). Business impact: delivery or automation adoption may wait until dependency is cleared."
        }
        elseif ($p.NeedsDecision) {
            $insight = "Get decision for $($p.Link): $($p.Decision). Business impact: scope, priority, or handover cannot move cleanly without confirmation."
        }
        [void]$lines.Add("- $insight")
    }
}
else {
    Add-EmptyState $lines "No critical project signal found. Review recent meetings and choose one project to move forward today."
}

Add-Section $lines "Critical Projects"
if ($criticalProjects.Count -gt 0) {
    [void]$lines.Add("| Project | Phase | Owner | Business Insight | Next Action |")
    [void]$lines.Add("|---|---|---|---|---|")
    foreach ($p in (Limit-Items $criticalProjects)) {
        $businessInsight = "Progress needs active management."
        if ($p.IsBlocked) { $businessInsight = "Blocked by dependency or unclear ownership." }
        elseif ($p.NeedsDecision) { $businessInsight = "Decision needed before next execution step." }
        elseif ($p.NeedsDocs) { $businessInsight = "Documentation or deliverable update is needed for traceability." }
        [void]$lines.Add("| $($p.Link) | $($p.Phase) | $($p.Owner) | $businessInsight | $($p.NextAction) |")
    }
}
else {
    Add-EmptyState $lines "No critical projects detected from current project notes."
}

Add-Section $lines "Open Tasks"
if ($openTaskItems.Count -gt 0) {
    foreach ($t in (Limit-Items $openTaskItems)) {
        [void]$lines.Add("- [ ] $($t.Text) Source: $(New-WikiLink $t.Source)")
    }
}
else {
    Add-EmptyState $lines "No unchecked tasks found in recent task and project notes."
}

Add-Section $lines "Blocked Items"
if ($blockedProjects.Count -gt 0) {
    foreach ($p in (Limit-Items $blockedProjects)) {
        [void]$lines.Add("- $($p.Link): $($p.Blocker). Required action: identify owner, dependency, and escalation path.")
    }
}
else {
    Add-EmptyState $lines "No blockers detected. Confirm during end-of-day review whether any hidden dependency exists."
}

Add-Section $lines "Decisions Needed"
if (($decisionProjects.Count + $decisionItems.Count) -gt 0) {
    foreach ($p in (Limit-Items $decisionProjects)) {
        [void]$lines.Add("- $($p.Link): $($p.Decision). Recommended handling: prepare options, trade-offs, and preferred recommendation.")
    }
    foreach ($d in (Limit-Items $decisionItems)) {
        [void]$lines.Add("- $(New-WikiLink $d.Source): $($d.Text)")
    }
}
else {
    Add-EmptyState $lines "No explicit pending decisions found. Review active projects for approval or scope confirmation gaps."
}

Add-Section $lines "Documents to Update"
if (($docProjects.Count + $deliverableFiles.Count + $meetingItems.Count) -gt 0) {
    foreach ($p in (Limit-Items $docProjects)) {
        [void]$lines.Add("- $($p.Link): update related BRD, ERD, SOP, user manual, task note, or Canvas traceability. Signal: $($p.DocumentSignal)")
    }
    foreach ($m in (Limit-Items $meetingItems)) {
        [void]$lines.Add("- $(New-WikiLink $m.Source): convert meeting action into project task, decision log, or deliverable update. Signal: $($m.Text)")
    }
    foreach ($d in (Limit-Items $deliverableFiles)) {
        [void]$lines.Add("- $(New-WikiLink (ConvertTo-WikiName $d.FullName)): verify whether this deliverable reflects latest project status.")
    }
}
else {
    Add-EmptyState $lines "No document update signal found. Check whether active projects have current BRD, ERD, SOP, or user manual links."
}

Add-Section $lines "Project Progress Snapshot"
if ($activeProjects.Count -gt 0) {
    [void]$lines.Add("| Project | Phase | Owner | Progress | Status | Next Action |")
    [void]$lines.Add("|---|---|---|---|---|---|")
    foreach ($p in (Limit-Items ($activeProjects | Sort-Object LastWriteTime -Descending))) {
        [void]$lines.Add("| $($p.Link) | $($p.Phase) | $($p.Owner) | $($p.Progress) | $($p.Status) | $($p.NextAction) |")
    }
}
else {
    Add-EmptyState $lines "No active project notes detected."
}

Add-Section $lines "Calendar Suggestions"
if ($criticalProjects.Count -gt 0) {
    foreach ($p in (Limit-Items $criticalProjects | Select-Object -First 5)) {
        $blockType = "Focus block"
        if ($p.IsBlocked) { $blockType = "Escalation block" }
        elseif ($p.NeedsDecision) { $blockType = "Decision preparation block" }
        [void]$lines.Add("- ${blockType}: $($p.Link) - clarify next action, owner, blocker, and expected output.")
    }
}
else {
    Add-EmptyState $lines "Reserve one focus block for project review and one short block for task cleanup."
}
[void]$lines.Add("- End-of-day review: update completed tasks, blockers, decisions, and tomorrow focus.")

Add-Section $lines "PowerShell Commands"
[void]$lines.Add("Run from vault root:")
[void]$lines.Add("")
[void]$lines.Add('```powershell')
[void]$lines.Add('powershell -ExecutionPolicy Bypass -File "scripts\Build-PPJDailyCommandCenter.ps1"')
[void]$lines.Add('powershell -ExecutionPolicy Bypass -File "scripts\Build-PPJWeeklyReport.ps1"')
[void]$lines.Add('powershell -ExecutionPolicy Bypass -File "scripts\Audit-ObsidianLinks.ps1"')
[void]$lines.Add('powershell -ExecutionPolicy Bypass -File "scripts\Backup-ObsidianVault.ps1"')
[void]$lines.Add('```')

Add-Section $lines "End-of-Day Review"
[void]$lines.Add("- [ ] What changed today?")
[void]$lines.Add("- [ ] Which project moved phase or should move phase?")
[void]$lines.Add("- [ ] Which blocker needs escalation?")
[void]$lines.Add("- [ ] Which decision needs management, business owner, IT, vendor, or data owner confirmation?")
[void]$lines.Add("- [ ] Which BRD, ERD, SOP, user manual, task note, or Canvas item must be updated?")
[void]$lines.Add("- [ ] What is the first action for tomorrow?")

$text = $lines -join "`r`n"
Write-Utf8 $dailyPath $text

Write-Host "Daily command center created:"
Write-Host " - $dailyPath"
Write-Host "Source scope: last $LookbackDays days"
Write-Host "Projects scanned: $($projects.Count)"
Write-Host "Open task items found: $($openTaskItems.Count)"
