param(
    [switch]$Apply,
    [string]$VaultRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$SourceEvent = 'PPJ-WEEKLY-20261030-20261106'
$VerifiedDate = '2026-11-06'
$DecisionId = 'DEC-WEEKLY-20261106-PORTFOLIO-GATES'
$ReportLink = '[[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261106]]'
$DecisionLink = '[[07_Decision_Log/DEC-WEEKLY-20261106-PORTFOLIO-GATES]]'

function P([string]$Relative) { Join-Path $VaultRoot ($Relative -replace '/', '\') }
function Read-Utf8([string]$Path) { [IO.File]::ReadAllText($Path, [Text.Encoding]::UTF8) }
function Write-Utf8([string]$Path, [string]$Content) {
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    $preferredEol = "`n"
    if (Test-Path -LiteralPath $Path) {
        $existing = Read-Utf8 $Path
        if ($existing.Contains("`r`n")) { $preferredEol = "`r`n" }
    }
    $normalized = $Content -replace "`r`n", "`n" -replace "`r", "`n"
    if ($preferredEol -eq "`r`n") { $normalized = $normalized -replace "`n", "`r`n" }
    [IO.File]::WriteAllText($Path, ($normalized.TrimEnd() + $preferredEol), [Text.UTF8Encoding]::new($false))
}
function MdList([string[]]$Items) { (@($Items | ForEach-Object { "- $_" }) -join "`n") }
function Set-FrontmatterField([string]$Text, [string]$Key, [string]$Value) {
    $match = [regex]::Match($Text, '(?ms)\A---\r?\n(?<fm>.*?)\r?\n---')
    if (-not $match.Success) { return $Text }
    $fm = $match.Groups['fm'].Value
    $line = $Key + ': "' + ($Value -replace '"','\"') + '"'
    $pattern = '(?m)^' + [regex]::Escape($Key) + ':.*$'
    if ([regex]::IsMatch($fm, $pattern)) { $fm = [regex]::Replace($fm, $pattern, $line, 1) }
    else { $fm = $fm.TrimEnd() + "`n" + $line }
    return $Text.Substring(0, $match.Groups['fm'].Index) + $fm + $Text.Substring($match.Groups['fm'].Index + $match.Groups['fm'].Length)
}
function Set-ManagedBlock([string]$Text, [string]$Name, [string]$Body) {
    $start = "<!-- ${Name}_START -->"
    $end = "<!-- ${Name}_END -->"
    $replacement = $start + "`n" + $Body.Trim() + "`n" + $end
    $pattern = '(?ms)' + [regex]::Escape($start) + '.*?' + [regex]::Escape($end)
    if ([regex]::IsMatch($Text, $pattern)) {
        return [regex]::Replace($Text, $pattern, [Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement }, 1)
    }
    return $Text.TrimEnd() + "`n`n" + $replacement + "`n"
}
function Set-Section([string]$Block, [string]$Heading, [string]$Body) {
    $pattern = '(?ms)(^## ' + [regex]::Escape($Heading) + '\s*\r?\n).*?(?=^## |\z)'
    if (-not [regex]::IsMatch($Block, $pattern)) { return $Block }
    $replacement = '## ' + $Heading + "`n`n" + $Body.Trim() + "`n`n"
    return [regex]::Replace($Block, $pattern, [Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement }, 1)
}
function Update-CurrentBlock([string]$Text, [string]$MarkerName, [object]$Update) {
    $start = "<!-- ${MarkerName}_START -->"
    $end = "<!-- ${MarkerName}_END -->"
    $pattern = '(?ms)' + [regex]::Escape($start) + '(?<body>.*?)' + [regex]::Escape($end)
    $match = [regex]::Match($Text, $pattern)
    if (-not $match.Success) { return $Text }
    $body = $match.Groups['body'].Value
    $body = [regex]::Replace($body, '(?m)^\| Current Gate \|.*?\|$', "| Current Gate | $($Update.Gate) |")
    $body = [regex]::Replace($body, '(?m)^\| Gate \|.*?\|$', "| Gate | $($Update.Gate) |")
    $body = [regex]::Replace($body, '(?m)^\| Last Verified \|.*?\|$', "| Last Verified | $VerifiedDate |")
    $body = [regex]::Replace($body, '(?m)^\| Source Event \|.*?\|$', "| Source Event | $SourceEvent |")
    $body = Set-Section $body 'Latest Update' $Update.Latest
    $body = Set-Section $body 'Risks / Blockers' (MdList $Update.Risks)
    $body = Set-Section $body 'Decisions Needed' (MdList $Update.Decisions)
    $body = Set-Section $body 'Next Actions' (MdList $Update.Next)
    $body = Set-Section $body 'Evidence and Confidence' ("- Date: $VerifiedDate`n- Source Event: $SourceEvent`n- Source: $ReportLink`n- Confidence: Strong")
    $replacement = $start + $body + $end
    return $Text.Substring(0, $match.Index) + $replacement + $Text.Substring($match.Index + $match.Length)
}
function Update-TableMirrors([string]$Text, [hashtable]$Updates) {
    $lines = $Text -split '\r?\n'
    $headers = $null
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -notmatch '^\|.*\|\s*$') { $headers = $null; continue }
        $cells = @($line.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() })
        if ($cells -match '^(Project|Canonical Project|Canonical Code)$') { $headers = $cells; continue }
        if ($line -match '^\|\s*:?-{2,}') { continue }
        if (-not $headers -or $cells.Count -ne $headers.Count) { continue }
        $code = $cells[0]
        if (-not $Updates.ContainsKey($code)) { continue }
        $u = $Updates[$code]
        for ($c = 0; $c -lt $headers.Count; $c++) {
            switch ($headers[$c]) {
                'Current Gate' { $cells[$c] = $u.Gate }
                'Gate' { $cells[$c] = $u.Gate }
                'Latest Update' { $cells[$c] = $u.Latest }
                'Next Action' { $cells[$c] = (($u.Next | ForEach-Object { $_.Trim().TrimEnd('.') }) -join '; ') }
                'Last Verified' { $cells[$c] = $VerifiedDate }
                'Source Event' { $cells[$c] = $SourceEvent }
                'Confidence' { $cells[$c] = 'Strong' }
            }
        }
        $lines[$i] = '| ' + ($cells -join ' | ') + ' |'
    }
    return ($lines -join "`n")
}
function Update-BoardSummary([string]$Path, [object]$Update) {
    $board = Read-Utf8 $Path | ConvertFrom-Json
    $summary = $board.nodes | Where-Object { $_.id -eq 'ppj-exec-summary' } | Select-Object -First 1
    if ($summary) {
        $summary.text = [regex]::Replace([string]$summary.text, '(?ms)(\nGate:\n).*?(\n\nOutcome:)', [Text.RegularExpressions.MatchEvaluator]{ param($m) $m.Groups[1].Value + $Update.Gate + $m.Groups[2].Value }, 1)
        if ([string]$summary.text -match '\nLast Verified:\n') {
            $summary.text = [regex]::Replace([string]$summary.text, '(?ms)(\nLast Verified:\n).*?$', [Text.RegularExpressions.MatchEvaluator]{ param($m) $m.Groups[1].Value + $VerifiedDate }, 1)
        } else {
            $summary.text = [regex]::Replace([string]$summary.text, '(?ms)\n\$1\d{4}-\d{2}-\d{2}$', [Text.RegularExpressions.MatchEvaluator]{ param($m) "`n`nLast Verified:`n$VerifiedDate" }, 1)
        }
    }
    $attention = $board.nodes | Where-Object { $_.id -eq 'ppj-management-attention' } | Select-Object -First 1
    if ($attention) {
        $attention.text = "KEY MANAGEMENT ATTENTION`n`nTop Risks`n$(MdList $Update.Risks)`n`nDecisions Needed`n$(MdList $Update.Decisions)`n`nExternal Dependencies`n$(MdList $Update.Dependencies)"
    }
    Write-Utf8 $Path ($board | ConvertTo-Json -Depth 100)
}

$updates = @(
    [pscustomobject]@{
        Code='FIN_FinanceManagement_v1.2.0'; Root='03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1.md'; Memory='03_Projects/_Registry/Project_Memory/FIN.AI.FINANCE.MANAGEMENT.v1.1.memory.md'; Folder='03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1'; Gate='Approve WS4 lineage and accounting semantics; scope-gate four FIN-AI enhancements';
        Latest='WS4 Golden Cases 02-03 confirm many-to-one Dệt-to-Nhuộm lineage, line-level Pick List evidence, cross-year source lots and voucher-level cost bridges. Daily NPL and Final Efficiency remain blocked. Four new FIN-AI enhancement requests are proposed only: internal-subcontracting OC analysis, expense allocation to net profit, receivables alerts and buyer credit limits. WS1, WS2 delivery, WS3 and WS5 have no new confirmed movement.';
        Risks=@('Daily NPL and Final Efficiency evidence remains blocked.','Lineage join keys, voucher-level accounting semantics, source extracts, historical cutoff and version control are not approved.','The four FIN-AI enhancement requests have no approved scope, stage or accountable owner.','WS3 closure and the WS3/WS5 boundary remain unresolved.');
        Decisions=@('Approve WS4 lineage, accounting semantics, source extracts and acceptance method.','Approve, stage or reject each new FIN-AI enhancement and assign accountable owners.','Confirm WS3/WS5 boundaries and mandate overdue WS3 closure.');
        Next=@('Freeze WS4 lineage join keys and voucher-level accounting semantics using the two selected Golden Transactions.','Scope-gate the four FIN-AI enhancements before estimation or development.','Close the WS3 evidence gap and confirm the WS3/WS5 boundary.');
        Dependencies=@('Finance and Accounting policy ownership.','WFX, DWH and source-system lineage evidence.','BA, Data, QA and Finance reviewer capacity.');
        TaskPath='03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1/Tasks/FIN_FinanceManagement_v1.2.0-TASK-001_Close-WS4-evidence-review-and-WS3-input-gates.md';
        TaskTitle='Freeze WS4 lineage and accounting semantics'; TaskStatus='this_week'; TaskPriority='P0'; TaskDue=''; TaskAcceptance='Approved evidence records the WS4 join keys, voucher-level accounting semantics, source extracts and acceptance method using the two selected Golden Transactions.'
    },
    [pscustomobject]@{
        Code='PUR_MaterialAllocation_v1.1.0'; Root='03_Projects/PUR.Material.Allocation.v1.2.md'; Memory='03_Projects/_Registry/Project_Memory/PUR.Material.Allocation.v1.1.memory.md'; Folder='03_Projects/PUR.Material.Allocation.v1.2'; Gate='Controlled WFX dry-run and Save testing';
        Latest='The controlled-flow build is documented with preview, dry run, fingerprints, audit history, emergency stop and rerun controls. This is documentation and build-control progress, not evidence of successful real WFX transactions. Business rules and controlled Save testing remain open.';
        Risks=@('Real WFX transaction behaviour and Save safety are not confirmed.','Duplicate, concurrency, cross-division, partial-allocation and rerun rules remain open.','Emergency-stop, rollback, audit and recovery controls require controlled evidence.');
        Decisions=@('Approve Material Allocation business rules and the transaction-control UAT gate.');
        Next=@('Execute preview and dry-run tests against controlled WFX data.','Execute controlled Save tests covering duplicates, concurrency, cross-division cases, partial allocation and emergency stop.','Record fingerprints, audit history, rollback and rerun evidence.');
        Dependencies=@('WFX controlled test environment and transaction authority.','Purchasing business-rule ownership.','QA evidence for audit and recovery.');
        TaskPath='03_Projects/PUR.Material.Allocation.v1.2/Tasks/PUR_MaterialAllocation_v1.1.0-TASK-001_Confirm-API-implementation-and-run-controlled-GET-POST-UAT.md';
        TaskTitle='Execute controlled WFX dry-run and Save testing'; TaskStatus='this_week'; TaskPriority='P0'; TaskDue=''; TaskAcceptance='Controlled evidence covers preview, dry run and Save across duplicate, concurrency, cross-division, partial-allocation, emergency-stop, audit, rollback and rerun cases.'
    },
    [pscustomobject]@{
        Code='ADMIN_ExpenseManagement_v1.1.0'; Root='03_Projects/ADMIN_ExpenseManagement_v1.1.0.md'; Memory='03_Projects/_Registry/Project_Memory/ADMIN_ExpenseManagement_v1.1.0.memory.md'; Folder='03_Projects/ADMIN_ExpenseManagement_v1.1.0'; Gate='Formal UAT and release decision';
        Latest='Employee and Admin operating guides are complete. This is release-enablement progress and does not confirm go-live. Access, accounting mappings, migrations, irreversible actions, release authority, UAT ownership and support remain unresolved.';
        Risks=@('Guide completion may be mistaken for release approval or production readiness.','Access, accounting mappings and migrations are not confirmed.','Irreversible actions, release authority, UAT ownership, training and support remain unresolved.');
        Decisions=@('Approve Business Travel release authority, UAT ownership and support model.');
        Next=@('Run the release gate covering access, accounting, migrations, irreversible actions, training and support.','Record formal UAT outcomes and release authority before any go-live claim.');
        Dependencies=@('Administration and Accounting process ownership.','eOffice/WFX access and migration controls.','Release, training and support capacity.');
        TaskPath='03_Projects/ADMIN_ExpenseManagement_v1.1.0/Tasks/ADMIN_ExpenseManagement_v1.1.0-TASK-001_Run-formal-Business-Travel-release-gate.md';
        TaskTitle='Run formal Business Travel UAT and release gate'; TaskStatus='this_week'; TaskPriority='P0'; TaskDue=''; TaskAcceptance='Formal outcomes cover access, accounting mappings, migrations, irreversible actions, training, release authority, UAT ownership and the support model.'
    },
    [pscustomobject]@{
        Code='MER_MarketIntelligence_v1.1.0'; Root='03_Projects/E-commerce Market Intelligence v.2.3.md'; Memory='03_Projects/_Registry/Project_Memory/MER.MARKET.INTELLIGENCE.v1.1.memory.md'; Folder='03_Projects/E-commerce Market Intelligence v.2.3'; Gate='Record Chino demo outcome and rebaseline';
        Latest='The 5 November Chino demonstration target passed without confirmed outcome evidence. No delivery result is claimed. The current requirement is to record the actual outcome and accept, rework or rebaseline the Chino MVP.';
        Risks=@('The planned demonstration date passed without documented delivery evidence.','Chino MVP acceptance, data quality and follow-on scope remain unconfirmed.','Knit and Denim must remain staged follow-on scope unless separately approved.');
        Decisions=@('Accept, rework or rebaseline the Market Intelligence Chino MVP.');
        Next=@('Record the 5 November demonstration outcome and available evidence.','Run an accept/rework/rebaseline decision and publish the revised gate.');
        Dependencies=@('Merchandising product owner and demo evidence.','Validated SKU, pricing and market-signal data.');
        TaskPath='03_Projects/E-commerce Market Intelligence v.2.3/Tasks/MER_MarketIntelligence_v1.1.0-TASK-001_Run-Chino-MVP-demonstration-readiness-gate.md';
        TaskTitle='Record Chino MVP outcome and rebaseline'; TaskStatus='blocked'; TaskPriority='P1'; TaskDue='2026-11-05'; TaskAcceptance='A documented outcome records the 5 November evidence and an approved accept, rework or rebaseline decision with a revised gate.'
    }
)

$byCode = @{}
foreach ($u in $updates) { $byCode[$u.Code] = $u }
$mirrorFiles = @(
    '03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT.md',
    '03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md',
    '03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md',
    '03_Projects/_Registry/PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md',
    '03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md',
    '03_Projects/_Registry/PPJ_PROJECT_MODULE_INDEX.md',
    '03_Projects/PROJECT_COMMAND_CENTER.md'
)
$reportPath = P '10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261106.md'
$decisionPath = P '07_Decision_Log/DEC-WEEKLY-20261106-PORTFOLIO-GATES.md'
$discoveryPath = P '03_Projects/_Registry/PPJ_DISCOVERY_REGISTER.md'
$discoveryIntakePath = P '03_Projects/_Registry/Project_Update_Intake/DET_PHU_THO_ERP_DISCOVERY_20261106.md'
$targetFiles = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($r in $mirrorFiles) { [void]$targetFiles.Add((P $r)) }
foreach ($r in @('03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md','07_Decision_Log/Decision_Log.md','03_Projects/_Registry/PPJ_DISCOVERY_REGISTER.md')) { [void]$targetFiles.Add((P $r)) }
foreach ($u in $updates) {
    foreach ($rel in @($u.Root,$u.Memory,"$($u.Folder)/00_Project_Home.md","$($u.Folder)/01_Management/Weekly_Status.md","$($u.Folder)/10_Governance/Risks_Issues.md","$($u.Folder)/10_Governance/Decision_Log.md","$($u.Folder)/Project_Executive_Board.canvas",$u.TaskPath)) {
        $path = P $rel
        if (-not (Test-Path -LiteralPath $path)) { throw "Required path missing: $rel" }
        [void]$targetFiles.Add($path)
    }
}

Write-Host 'PPJ Weekly Portfolio Update'
Write-Host "Mode: $(if ($Apply) {'APPLY'} else {'DRYRUN'})"
Write-Host "Source Event: $SourceEvent"
Write-Host "Affected canonical projects: $($updates.Count)"
foreach ($u in $updates) { Write-Host "- $($u.Code): $($u.Gate)" }
Write-Host '- DISCOVERY_DetPhuThoERP: structured discovery only; no project registration or Canvas card'
Write-Host "Existing files to back up/update: $($targetFiles.Count)"
Write-Host 'Global Executive Canvas stage changes: 0'
if (-not $Apply) { Write-Host 'DryRun only. No files modified.'; exit 0 }

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupRoot = P "99_Attachments/Audit/Weekly_Progress_20261030_20261106_Backup/$stamp"
foreach ($path in $targetFiles) {
    $relative = $path.Substring($VaultRoot.TrimEnd('\').Length).TrimStart('\')
    $backup = Join-Path $backupRoot $relative
    New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force | Out-Null
    Copy-Item -LiteralPath $path -Destination $backup -Force
}

foreach ($u in $updates) {
    $eventBody = @"
## Weekly Synchronization Event: $SourceEvent

### Verified movement

$($u.Latest)

### Current gate

$($u.Gate)

### Risks / blockers

$(MdList $u.Risks)

### Decisions required

$(MdList $u.Decisions)

### Next actions

$(MdList $u.Next)

### Traceability

- Report: $ReportLink
- Decision gate: $DecisionLink
- Last verified: $VerifiedDate
- Confidence: Strong
"@
    $weeklyBody = @"
## Weekly Status - $VerifiedDate

- **Canonical project:** $($u.Code)
- **Current gate:** $($u.Gate)
- **Stage change:** None confirmed

### Latest verified update

$($u.Latest)

### Current blockers and risks

$(MdList $u.Risks)

### Decisions needed

$(MdList $u.Decisions)

### Next actions

$(MdList $u.Next)

### Evidence basis

- $ReportLink
- Source event: $SourceEvent
- Last verified: $VerifiedDate
- Confidence: Strong
"@
    $riskBody = "## Weekly Risk Update - $VerifiedDate`n`n$(MdList $u.Risks)`n`nSource: $ReportLink ($SourceEvent)"
    $decisionBody = "## Weekly Decision Gate - $VerifiedDate`n`n$(MdList $u.Decisions)`n`nPortfolio decision record: $DecisionLink"
    foreach ($item in @(
        @{ Path=P $u.Root; Marker='PPJ_WEEKLY_20261030_20261106'; Body=$eventBody; CurrentMarker='PPJ_PROJECT_KNOWLEDGE' },
        @{ Path=P $u.Memory; Marker='PPJ_WEEKLY_20261030_20261106'; Body=$eventBody; CurrentMarker='PPJ_PORTFOLIO_SNAPSHOT_20260824' },
        @{ Path=P "$($u.Folder)/00_Project_Home.md"; Marker='PPJ_WEEKLY_20261030_20261106'; Body=$eventBody; CurrentMarker='PPJ_PORTFOLIO_SNAPSHOT_20260824' },
        @{ Path=P "$($u.Folder)/01_Management/Weekly_Status.md"; Marker='PPJ_WEEKLY_20261030_20261106'; Body=$weeklyBody; CurrentMarker='' },
        @{ Path=P "$($u.Folder)/10_Governance/Risks_Issues.md"; Marker='PPJ_WEEKLY_20261030_20261106_RISKS'; Body=$riskBody; CurrentMarker='' },
        @{ Path=P "$($u.Folder)/10_Governance/Decision_Log.md"; Marker='PPJ_WEEKLY_20261030_20261106_DECISIONS'; Body=$decisionBody; CurrentMarker='' }
    )) {
        $text = Read-Utf8 $item.Path
        foreach ($field in @(@('source_event',$SourceEvent),@('last_verified',$VerifiedDate),@('current_gate',$u.Gate))) { $text = Set-FrontmatterField $text $field[0] $field[1] }
        if ([IO.Path]::GetFileName($item.Path) -eq [IO.Path]::GetFileName($u.Root)) { $text = Set-FrontmatterField $text 'last_updated' $VerifiedDate }
        if ($item.CurrentMarker) { $text = Update-CurrentBlock $text $item.CurrentMarker $u }
        $text = Update-CurrentBlock $text 'PPJ_EXECUTIVE_DELIVERY_STAGE' $u
        $text = Set-ManagedBlock $text $item.Marker $item.Body
        Write-Utf8 $item.Path $text
    }
    $memoryPath = P $u.Memory
    $memory = Read-Utf8 $memoryPath
    $memory = Set-FrontmatterField $memory 'latest_update_summary' $u.Latest
    $memory = Set-FrontmatterField $memory 'next_actions' ($u.Next -join ' | ')
    Write-Utf8 $memoryPath $memory

    $blocked = if ($u.TaskStatus -eq 'blocked') { '["Missing documented outcome evidence for 5 November Chino target"]' } else { '[]' }
    $task = @"
---
type: project_task
project: "$($u.Code)"
task_id: "$($u.Code)-TASK-001"
title: "$($u.TaskTitle)"
status: $($u.TaskStatus)
priority: $($u.TaskPriority)
owner: "Needs Confirmation"
due: "$($u.TaskDue)"
source_event: "$SourceEvent"
created: 2026-11-02
updated: $VerifiedDate
blocked_by: $blocked
depends_on: []
acceptance: "$($u.TaskAcceptance)"
---

# $($u.TaskTitle)

## Project

[[../00_Project_Home|$($u.Code)]]

## Acceptance

$($u.TaskAcceptance)

## Source Event

$SourceEvent

## Notes

Updated from the 6 November 2026 executive weekly report. No delivery-stage change or completion is claimed.
"@
    Write-Utf8 (P $u.TaskPath) $task
    Update-BoardSummary (P "$($u.Folder)/Project_Executive_Board.canvas") $u
}

foreach ($rel in $mirrorFiles) {
    $path = P $rel
    $text = Update-TableMirrors (Read-Utf8 $path) $byCode
    if ($rel -eq '03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT.md') {
        $text = Set-FrontmatterField $text 'source_event' $SourceEvent
        $text = Set-FrontmatterField $text 'last_verified' $VerifiedDate
        $text = [regex]::Replace($text, '(?m)^- Source Event:.*$', "- Source Event: $SourceEvent")
        $text = [regex]::Replace($text, '(?m)^- Last Verified:.*$', "- Last Verified: $VerifiedDate")
    }
    Write-Utf8 $path $text
}

$ledgerPath = P '03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md'
$ledger = Read-Utf8 $ledgerPath
foreach ($u in $updates) {
    $summary = ($u.Latest -replace '\|','/' -replace "`r?`n",' ')
    $next = ((($u.Next | ForEach-Object { $_.Trim().TrimEnd('.') }) -join '; ') -replace '\|','/')
    $row = "| $VerifiedDate | $($u.Code) | weekly_portfolio_update | $summary | current_gate | carried | $($u.Gate) | $SourceEvent | Strong | memory / root / workspace / task / local board / registry | $next |"
    $rowPattern = '(?m)^\| ' + [regex]::Escape($VerifiedDate) + ' \| ' + [regex]::Escape($u.Code) + ' \| weekly_portfolio_update \|.*\|\r?\n?'
    $ledger = [regex]::Replace($ledger, $rowPattern, '')
    $ledger = $ledger.TrimEnd() + "`n" + $row
}
Write-Utf8 $ledgerPath $ledger

$discovery = Read-Utf8 $discoveryPath
$discovery = Set-FrontmatterField $discovery 'source_event' $SourceEvent
$discovery = Set-FrontmatterField $discovery 'last_verified' $VerifiedDate
$discoveryRow = '| DISCOVERY_DetPhuThoERP | ERP vendor / solution TBD | Structured ERP Discovery / Questionnaire Issued | Dệt Phú Thọ discovery covering Sales, Production, Labor and Cotton Blending through a 100-question questionnaire. No answers or requirements are confirmed. | Assign process owners; collect questionnaire evidence; identify source systems and gaps; authorize BRD / ERP-gap gate; protect P0 UAT capacity |'
if ($discovery -match '(?m)^\| DISCOVERY_DetPhuThoERP \|.*$') {
    $discovery = [regex]::Replace($discovery, '(?m)^\| DISCOVERY_DetPhuThoERP \|.*$', [Text.RegularExpressions.MatchEvaluator]{ param($m) $discoveryRow }, 1)
} else {
    $discovery = $discovery -replace '(?m)^## Rules\s*$', ($discoveryRow + "`n`n## Rules")
}
$discoveryBody = @"
## Weekly Discovery Update - $VerifiedDate

- A 100-question questionnaire now covers Sales, Production, Labor and Cotton Blending.
- No answers, requirements, ERP fit/gap result, project scope, owner or delivery stage is confirmed.
- The item remains in discovery and receives no canonical project code or Canvas card.
- Management gate: assign process owners and authorize evidence collection plus the BRD / ERP-gap review without displacing P0 UAT work.

Source: $ReportLink ($SourceEvent)
"@
$discovery = Set-ManagedBlock $discovery 'PPJ_WEEKLY_20261030_20261106_DISCOVERY' $discoveryBody
Write-Utf8 $discoveryPath $discovery

$discoveryIntake = @"
---
type: discovery_intake
label: DISCOVERY_DetPhuThoERP
status: "Structured ERP Discovery"
source_event: "$SourceEvent"
last_verified: "$VerifiedDate"
registration: "Not approved"
---

# Dệt Phú Thọ ERP Discovery - 6 November 2026

## Reported evidence

- A 100-question questionnaire covers Sales, Production, Labor and Cotton Blending.
- No questionnaire answers or requirements are confirmed.
- No ERP solution, vendor, owner, delivery stage or implementation scope is approved.

## Required discovery gate

1. Assign Dệt Phú Thọ process owners for each questionnaire domain.
2. Collect answers and source evidence.
3. Identify current systems, data ownership, process gaps and integration constraints.
4. Authorize a BRD / ERP fit-gap gate only after evidence review.
5. Protect existing P0 UAT work from unapproved discovery demand.

## Governance

Keep this item in [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER]] until project registration is approved.

Related report: $ReportLink
Decision gate: $DecisionLink
"@
Write-Utf8 $discoveryIntakePath $discoveryIntake

$report = @"
---
type: weekly_portfolio_report
as_of: 2026-11-06
comparison_baseline: 2026-10-30
source_event: $SourceEvent
evidence_status: mixed_confirmed_and_unconfirmed
confidence: Strong
---

# PPJ AI, Automation & Digital Portfolio - Weekly Status

**As of:** 6 November 2026

**Baseline:** 30 October 2026

**Source freshness:** Evidence updated through 6 November, covering WS4 Fabric OC, Business Travel, Finance enhancements, Material Allocation and Dệt Phú Thọ ERP discovery. The 30 October baseline remains authoritative elsewhere.

[Management report source](https://chatgpt.com/library?file_id=libfile_b5fcb69a2b108191966ad873e0fc9303&account_id=personal)

## Evidence boundary

Only the five reported areas above receive new evidence treatment. Guides, knowledge packs, re-analysis and questionnaires are deliverables, not proof of project completion, release or production readiness. Proposed FIN-AI enhancements are not approved scope. Dệt Phú Thọ remains a discovery item, not a registered project. No delivery-stage change is confirmed.

## Executive summary

- **WS4 Fabric OC made the strongest analytical progress.** Golden Cases 02-03 confirm many-to-one Dệt-to-Nhuộm lineage, line-level Pick List evidence, cross-year source lots and voucher-level cost bridges. Daily NPL and Final Efficiency remain blocked.
- **Material Allocation advanced to a documented controlled-flow build.** Preview, dry run, fingerprints, audit history, emergency stop and rerun controls are documented. Real WFX transaction testing and several business rules remain open.
- **Business Travel progressed in release enablement.** Employee and Admin guides are complete, but this does not confirm go-live. Access, accounting mappings, migrations, irreversible actions and release authority remain unresolved.
- **Four new FIN-AI enhancement requests require scope approval:** internal-subcontracting OC analysis, expense allocation to net profit, receivables alerts and buyer credit limits.
- **Dệt Phú Thọ entered structured ERP discovery.** A 100-question questionnaire now covers Sales, Production, Labor and Cotton Blending. No answers or requirements are confirmed yet.
- The **Market Intelligence Chino demo target of 5 November passed without confirmed outcome evidence**.
- No project or workstream was confirmed complete.

## Canonical resolution

| Report workstream | Canonical project / record | Treatment |
|---|---|---|
| WS4 Fabric OC and FIN-AI enhancements | [[FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN_FinanceManagement_v1.2.0]] | Confirmed WS4 evidence movement; enhancement requests remain proposed |
| Material Allocation | [[PUR.Material.Allocation.v1.2|PUR_MaterialAllocation_v1.1.0]] | Controlled-flow documentation movement; real WFX transaction evidence pending |
| Business Travel | [[ADMIN_ExpenseManagement_v1.1.0]] | Guides complete; formal UAT and release decision pending |
| Market Intelligence | [[E-commerce Market Intelligence v.2.3|MER_MarketIntelligence_v1.1.0]] | Planned target passed without confirmed outcome evidence |
| Dệt Phú Thọ ERP | [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER|DISCOVERY_DetPhuThoERP]] | Structured discovery only; no registration, stage or Canvas card |

## Weekly movement

| Workstream | Movement versus 30 October | Current gate |
|---|---|---|
| WS4 Fabric OC | Major analytical progress from two additional Golden Cases | Approve lineage, accounting semantics and source extracts |
| Material Allocation | Business and technical control model documented | Controlled WFX dry-run and Save testing |
| Business Travel | User/Admin operating guides completed | Formal UAT and release decision |
| FIN-AI enhancements | New proposed scope | Approve, stage or reject each request |
| Dệt Phú Thọ ERP | New structured discovery | Assign owners and collect evidence |
| Market Intelligence | No delivery evidence after planned demo date | Record outcome and rebaseline |
| WS1, WS2 delivery, WS3, WS5, GDI, invoices, AWB, Sew, Wash/COMIT, Stratova, BSC-KPI, shared platforms | No new confirmed update | Previous blockers and decisions remain open |

## Main portfolio constraints

- Finance and Accounting policy ownership across WS2-WS5, Travel, invoices and the new enhancements.
- WFX transaction safety across Allocation, GDI, Travel and invoice automation.
- Incomplete lineage, historical cutoff and version control across Fabric OC, DWH and Market Intelligence.
- Competing BA, QA, Finance, WFX and factory-expert capacity.
- Missing common authorization, audit and recovery standards for irreversible system actions.

## Milestone assessment

**Moved forward:** WS4 Golden Cases, Material Allocation documentation, Business Travel guidance, FIN-AI scope review and Dệt Phú Thọ discovery.

**Completed deliverables:** WS4 re-analysis, Business Travel guides, Material Allocation knowledge packs and the Dệt Phú Thọ questionnaire. These are deliverables, not completed projects.

**Delayed or at risk:** Market Intelligence demo evidence, WS3 survey closure, Business Travel release, Allocation/GDI transaction UAT, Expense Invoice defects, WS2 readiness and WS4 production-rule readiness.

## Top five actions for next week

1. Freeze WS4 lineage join keys and voucher-level accounting semantics using the two selected Golden Transactions.
2. Scope-gate the four new FIN-AI enhancements before estimation or development.
3. Execute Material Allocation dry-run and controlled Save tests, including duplicate, concurrency, cross-division and emergency-stop cases.
4. Run the Business Travel release gate covering access, accounting, migrations, irreversible actions, training and support.
5. Close the Market Intelligence and WS3 evidence gaps; appoint Dệt Phú Thọ process owners without displacing P0 UAT work.

## Management decisions required

| Priority | Decision |
|---|---|
| P0 | Approve WS4 lineage, accounting semantics, source extracts and acceptance method |
| P0 | Approve, stage or reject each new FIN-AI enhancement and assign accountable owners |
| P0 | Approve Business Travel release authority, UAT ownership and support model |
| P0 | Approve Material Allocation business rules and transaction-control UAT gate |
| P1 | Accept, rework or rebaseline the Market Intelligence Chino MVP |
| P1 | Confirm WS3/WS5 boundaries and mandate overdue WS3 closure |
| P1 | Authorize Dệt Phú Thọ discovery ownership and BRD/ERP-gap gate |
| P1 | Escalate GDI and assign Expense Invoice defect ownership |
| P1 | Approve the Wash/COMIT POC dataset and expert-review model |
| P2 | Pause vendor or research initiatives without an owner, KPI, dataset and production path |

## Traceability

- Decision gate: $DecisionLink
- Current snapshot: [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT]]
- Memory index: [[03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX]]
- Update ledger: [[03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER]]
- Discovery register: [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER]]
"@
Write-Utf8 $reportPath $report

$decision = @"
---
type: decision_gate
id: $DecisionId
date: $VerifiedDate
status: Pending
owner: Needs Confirmation
source_event: $SourceEvent
---

# Weekly Portfolio Management Decision Gate - 6 November 2026

## Decision required

| Priority | Decision | Canonical project / record | Status |
|---|---|---|---|
| P0 | Approve WS4 lineage, accounting semantics, source extracts and acceptance method. | [[FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN_FinanceManagement_v1.2.0]] | Pending |
| P0 | Approve, stage or reject each new FIN-AI enhancement and assign accountable owners. | [[FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN_FinanceManagement_v1.2.0]] | Pending |
| P0 | Approve Business Travel release authority, UAT ownership and support model. | [[ADMIN_ExpenseManagement_v1.1.0]] | Pending |
| P0 | Approve Material Allocation business rules and transaction-control UAT gate. | [[PUR.Material.Allocation.v1.2|PUR_MaterialAllocation_v1.1.0]] | Pending |
| P1 | Accept, rework or rebaseline the Market Intelligence Chino MVP. | [[E-commerce Market Intelligence v.2.3|MER_MarketIntelligence_v1.1.0]] | Pending |
| P1 | Confirm WS3/WS5 boundaries and mandate overdue WS3 closure. | [[FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN_FinanceManagement_v1.2.0]] | Pending |
| P1 | Authorize Dệt Phú Thọ discovery ownership and BRD/ERP-gap gate. | [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER|DISCOVERY_DetPhuThoERP]] | Pending |
| P1 | Escalate GDI and assign Expense Invoice defect ownership. | [[PUR.GDI Automation|PUR_GDIAutomation_v1.0.0]] / [[PPJ. Expense-Invoices.v1.1|LOG_ExpenseInvoiceProcessing_v1.2.2]] | Pending |
| P1 | Approve the Wash/COMIT POC dataset and expert-review model. | [[PPJ.COSTING.AGENT.PLATFORM.v1.1|MER_CostingAgenticPlatform_v1.1.0]] | Pending |
| P2 | Pause vendor or research initiatives without an owner, KPI, dataset and production path. | [[03_Projects/_Registry/PPJ_DISCOVERY_REGISTER]] | Pending |

## Evidence boundary

- New evidence is applied only to Finance/WS4, Material Allocation, Business Travel, Market Intelligence and Dệt Phú Thọ discovery.
- Proposed enhancements remain unapproved.
- Dệt Phú Thọ remains outside the project registry.
- No delivery-stage change or project completion is claimed.

## Evidence

- $ReportLink
- Source event: $SourceEvent

## Exit condition

Record each decision owner, outcome, effective date and resulting task or gate change. Do not move a delivery stage until evidence shows the gate was passed.
"@
Write-Utf8 $decisionPath $decision

$decisionIndexPath = P '07_Decision_Log/Decision_Log.md'
$decisionIndex = Read-Utf8 $decisionIndexPath
if ($decisionIndex -notmatch [regex]::Escape($DecisionId)) { $decisionIndex = $decisionIndex.TrimEnd() + "`n| $DecisionId | Weekly portfolio management gates | $VerifiedDate | Needs Confirmation | Four registered projects plus discovery governance | [[$DecisionId]] |`n" }
Write-Utf8 $decisionIndexPath $decisionIndex

Write-Host 'Apply completed.'
Write-Host "Backup folder: $backupRoot"
Write-Host "Report: $reportPath"
Write-Host "Decision gate: $decisionPath"
Write-Host "Discovery intake: $discoveryIntakePath"
