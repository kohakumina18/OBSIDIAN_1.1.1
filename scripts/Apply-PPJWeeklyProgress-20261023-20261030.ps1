param(
    [switch]$Apply,
    [string]$VaultRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$SourceEvent = 'PPJ-WEEKLY-20261023-20261030'
$VerifiedDate = '2026-10-30'
$DecisionId = 'DEC-WEEKLY-20261030-PORTFOLIO-GATES'
$ReportLink = '[[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]'
$DecisionLink = '[[07_Decision_Log/DEC-WEEKLY-20261030-PORTFOLIO-GATES]]'

function P([string]$Relative) { Join-Path $VaultRoot ($Relative -replace '/', '\') }
function Read-Utf8([string]$Path) { [IO.File]::ReadAllText($Path, [Text.Encoding]::UTF8) }
function Write-Utf8([string]$Path, [string]$Content) {
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    $preferredEol = "`n"
    if (Test-Path -LiteralPath $Path) {
        $existing = [IO.File]::ReadAllText($Path, [Text.Encoding]::UTF8)
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
    if ([regex]::IsMatch($Text, $pattern)) { return [regex]::Replace($Text, $pattern, [Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement }, 1) }
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

$updates = @(
    [pscustomobject]@{
        Code='FIN_FinanceManagement_v1.2.0'; Alias='FIN.AI.FINANCE.MANAGEMENT.v1.1'; Root='03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1.md'; Memory='03_Projects/_Registry/Project_Memory/FIN.AI.FINANCE.MANAGEMENT.v1.1.memory.md'; Folder='03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1'; Gate='WS4 v0.2 evidence review and WS3 input closure';
        Latest='WS4 traced one Knit golden case, completed transaction-stage classification and prepared a v0.2 rule-change proposal. The evidence confirms 1-to-many and line-level Det-Nhuom mapping requirements, but does not prove production accuracy. WS3 received two HR/Payroll responses; broader Accounting and Planning/Production inputs remain incomplete, and HR-WFX/GTAS mappings and month-finalization practices are inconsistent. WS1, WS2 and WS5 have no new confirmed movement.';
        Risks=@('WS4 evidence is limited to one golden-case package and a partial historical window.','Line-level lineage, metric definitions, history completeness and accounting interpretation remain unresolved.','WS3 survey closure is overdue; HR-WFX/GTAS mappings and month-finalization practices are inconsistent.','WS1 UAT ownership, WS2 BC-04 policies/source gaps and the WS3/WS5 boundary remain open.');
        Decisions=@('Approve WS4 line-level lineage, historical-window controls, provisional mapping review and golden-case method.','Mandate WS3 closure and confirm the WS3/WS5 boundary.','Approve the four open BC-04 policies and source-remediation plan.');
        Next=@('Review the WS4 v0.2 evidence model, provisional mappings, lineage method and priority accounting questions.','Collect remaining Accounting and Planning/Production WS3 inputs and consolidate the data/rule/gap register.','Define supported WS1 questions and pilot gate; preserve WS2 source-remediation and BC-04 policy actions.');
        Confidence='Strong'
    },
    [pscustomobject]@{
        Code='PUR_MaterialAllocation_v1.1.0'; Alias='PUR.Material.Allocation.v1.2'; Root='03_Projects/PUR.Material.Allocation.v1.2.md'; Memory='03_Projects/_Registry/Project_Memory/PUR.Material.Allocation.v1.1.memory.md'; Folder='03_Projects/PUR.Material.Allocation.v1.2'; Gate='Confirm API implementation and controlled GET/POST transaction UAT';
        Latest='WFX documented GET/POST behaviour and issued the Style/Article API enhancement specification dated 26-28 October, including partial Style/Article search. This is API-definition progress only; deployment and transaction-control testing are not confirmed.';
        Risks=@('Deployment status, performance, concurrency and audit behaviour are unconfirmed.','Duplicate prevention, rollback, partial allocation and exception controls still require transaction UAT.');
        Decisions=@('Confirm API deployment ownership and the transaction-control UAT gate.');
        Next=@('Confirm the specified API is implemented in the controlled environment.','Execute controlled GET/POST tests for partial Style/Article search and allocation transactions.','Validate duplicate prevention, rollback, concurrency, audit and user confirmation.'); Confidence='Strong'
    },
    [pscustomobject]@{
        Code='MER_CostingAgenticPlatform_v1.1.0'; Alias='PPJ.COSTING.AGENT.PLATFORM.v1.1'; Root='03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1.md'; Memory='03_Projects/_Registry/Project_Memory/COSTING.AGENTIC.PLATFORM.v1.1.memory.md'; Folder='03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1'; Gate='Wash/COMIT POC data-contract approval and expert-owned dataset';
        Latest='COMIT Wash Image Analysis Requirement v1.1 entered structured POC definition. Scope, responsibilities, data contract, expert review and proposed targets are documented. No trained model or POC result exists yet. Sew Agent has no new confirmed movement.';
        Risks=@('Taxonomy, metadata, annotation rules and expert-owned dataset are not frozen.','Proposed targets and the expert-review fallback are not approved.','A requirement document is not evidence of model training, accuracy or a successful POC.');
        Decisions=@('Approve Wash/COMIT POC scope, dataset ownership, proposed targets and mandatory expert-review fallback.');
        Next=@('Freeze the Wash/COMIT taxonomy, metadata, annotation guide and data contract.','Assign the expert-owned POC dataset and acceptance review gate.','Keep all model targets labelled proposed until approved and tested.'); Confidence='Strong'
    },
    [pscustomobject]@{
        Code='MER_MarketIntelligence_v1.1.0'; Alias='E-commerce Market Intelligence v.2.3'; Root='03_Projects/E-commerce Market Intelligence v.2.3.md'; Memory='03_Projects/_Registry/Project_Memory/MER.MARKET.INTELLIGENCE.v1.1.memory.md'; Folder='03_Projects/E-commerce Market Intelligence v.2.3'; Gate='5 November Chino MVP demonstration readiness';
        Latest='No new delivery result is confirmed as of 30 October. The Chino MVP demonstration remains planned for 5 November 2026 and is not confirmed delivered; fresh readiness evidence is missing.';
        Risks=@('Demo readiness is not evidenced.','Scope expansion and inconsistent SKU/pricing data could weaken the Chino MVP.','Knit and Denim must remain staged follow-on scope unless separately approved.');
        Decisions=@('Confirm Chino demo readiness and retain Knit/Denim as staged follow-on scope.');
        Next=@('Run a readiness gate covering the Chino MVP scope, data quality, demo script and fallback.','Record a go/no-go result before treating the planned demo as deliverable evidence.'); Confidence='Strong'
    },
    [pscustomobject]@{
        Code='ADMIN_ExpenseManagement_v1.1.0'; Alias='ADMIN_ExpenseManagement_v1.1.0'; Root='03_Projects/ADMIN_ExpenseManagement_v1.1.0.md'; Memory='03_Projects/_Registry/Project_Memory/ADMIN_ExpenseManagement_v1.1.0.memory.md'; Folder='03_Projects/ADMIN_ExpenseManagement_v1.1.0'; Gate='Formal Business Travel release decision';
        Latest='No new confirmed release result exists as of 30 October. The project remains in release preparation; Accounting mappings, authorization, migrations, training, eOffice budget and release ownership remain open.';
        Risks=@('Accounting mappings and authorization/access testing are not confirmed.','Migration, training, eOffice budget and release ownership remain unresolved.');
        Decisions=@('Approve release authority, accounting exceptions, access testing, training and eOffice budget.');
        Next=@('Run the formal release gate and record owners for every unresolved control.'); Confidence='Strong'
    },
    [pscustomobject]@{
        Code='PUR_GDIAutomation_v1.0.0'; Alias='PUR.GDI Automation'; Root='03_Projects/PUR.GDI Automation.md'; Memory='03_Projects/_Registry/Project_Memory/PUR.GDI.Automation.v1.0.memory.md'; Folder='03_Projects/PUR.GDI Automation'; Gate='WFX GET/POST delivery and transaction-control UAT ownership';
        Latest='No new confirmed API delivery or UAT result exists as of 30 October. The project remains in API/requirements development.';
        Risks=@('WFX delivery, authentication and operation schemas remain unconfirmed.','Duplicate prevention, rollback, retry, timeout, audit and transaction confirmation require controlled testing.');
        Decisions=@('Escalate GDI GET/POST delivery and appoint PPJ/WFX UAT owners.');
        Next=@('Freeze supported API operations and sandbox scenarios.','Assign PPJ and WFX UAT owners and execute controlled transaction tests.'); Confidence='Strong'
    },
    [pscustomobject]@{
        Code='LOG_ExpenseInvoiceProcessing_v1.2.2'; Alias='PPJ. Expense-Invoices.v1.1'; Root='03_Projects/PPJ. Expense-Invoices.v1.1.md'; Memory='03_Projects/_Registry/Project_Memory/PPJ.ExpenseInvoices.v1.1.memory.md'; Folder='03_Projects/PPJ. Expense-Invoices.v1.1'; Gate='Defect ownership, regression and production exit criteria';
        Latest='No confirmed defect fix exists as of 30 October. Active-use and defect-remediation evidence still points to VAT, attachment, regional-rule and duplicate/error risks.';
        Risks=@('VAT, attachment and regional rules remain defect-prone.','Duplicate/error handling and regression evidence are incomplete.','Hotfix and production support ownership are not assigned.');
        Decisions=@('Assign Expense Invoice defect ownership and explicit exit criteria.');
        Next=@('Assign the hotfix owner and freeze the regression pack.','Run regression against VAT, attachments, regional rules and duplicate/error scenarios.','Record exit criteria and the production-support handoff.'); Confidence='Strong'
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
$targetFiles = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($r in $mirrorFiles) { [void]$targetFiles.Add((P $r)) }
[void]$targetFiles.Add((P '03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md'))
[void]$targetFiles.Add((P '07_Decision_Log/Decision_Log.md'))

foreach ($u in $updates) {
    foreach ($rel in @($u.Root, $u.Memory, "$($u.Folder)/00_Project_Home.md", "$($u.Folder)/01_Management/Weekly_Status.md", "$($u.Folder)/10_Governance/Risks_Issues.md", "$($u.Folder)/10_Governance/Decision_Log.md")) {
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
Write-Host "Existing files to back up/update: $($targetFiles.Count)"
Write-Host 'Global Executive Canvas stage changes: 0'
if (-not $Apply) { Write-Host 'DryRun only. No files modified.'; exit 0 }

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupRoot = P "99_Attachments/Audit/Weekly_Progress_20261023_20261030_Backup/$stamp"
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
    $riskBody = @"
## Weekly Risk Update - $VerifiedDate

$(MdList $u.Risks)

Source: $ReportLink ($SourceEvent)
"@
    $decisionBody = @"
## Weekly Decision Gate - $VerifiedDate

$(MdList $u.Decisions)

Portfolio decision record: $DecisionLink
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

    foreach ($item in @(
        @{ Path=P $u.Root; Marker='PPJ_WEEKLY_20261023_20261030'; Body=$eventBody; CurrentMarker='PPJ_PROJECT_KNOWLEDGE' },
        @{ Path=P $u.Memory; Marker='PPJ_WEEKLY_20261023_20261030'; Body=$eventBody; CurrentMarker='PPJ_PORTFOLIO_SNAPSHOT_20260824' },
        @{ Path=P "$($u.Folder)/00_Project_Home.md"; Marker='PPJ_WEEKLY_20261023_20261030'; Body=$eventBody; CurrentMarker='PPJ_PORTFOLIO_SNAPSHOT_20260824' },
        @{ Path=P "$($u.Folder)/01_Management/Weekly_Status.md"; Marker='PPJ_WEEKLY_20261023_20261030'; Body=$weeklyBody; CurrentMarker='' },
        @{ Path=P "$($u.Folder)/10_Governance/Risks_Issues.md"; Marker='PPJ_WEEKLY_20261023_20261030_RISKS'; Body=$riskBody; CurrentMarker='' },
        @{ Path=P "$($u.Folder)/10_Governance/Decision_Log.md"; Marker='PPJ_WEEKLY_20261023_20261030_DECISIONS'; Body=$decisionBody; CurrentMarker='' }
    )) {
        $text = Read-Utf8 $item.Path
        foreach ($field in @(@('source_event',$SourceEvent), @('last_verified',$VerifiedDate), @('current_gate',$u.Gate))) {
            $text = Set-FrontmatterField $text $field[0] $field[1]
        }
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
}

foreach ($rel in $mirrorFiles) {
    $path = P $rel
    $text = Read-Utf8 $path
    $text = Update-TableMirrors $text $byCode
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
    $row = "| $VerifiedDate | $($u.Code) | weekly_portfolio_update | $summary | current_gate | carried | $($u.Gate) | $SourceEvent | Strong | memory / root / workspace / task board / registry | $next |"
    $rowPattern = '(?m)^\| ' + [regex]::Escape($VerifiedDate) + ' \| ' + [regex]::Escape($u.Code) + ' \| weekly_portfolio_update \|.*\|\r?\n?'
    $ledger = [regex]::Replace($ledger, $rowPattern, '')
    $ledger = $ledger.TrimEnd() + "`n" + $row
}
Write-Utf8 $ledgerPath $ledger

$decisionIndexPath = P '07_Decision_Log/Decision_Log.md'
$decisionIndex = Read-Utf8 $decisionIndexPath
if ($decisionIndex -notmatch [regex]::Escape($DecisionId)) {
    $decisionIndex = $decisionIndex.TrimEnd() + "`n| $DecisionId | Weekly portfolio management gates | $VerifiedDate | Needs Confirmation | Seven registered projects plus discovery governance | [[$DecisionId]] |`n"
}
Write-Utf8 $decisionIndexPath $decisionIndex

Write-Host 'Apply completed.'
Write-Host "Backup folder: $backupRoot"
Write-Host "Report: $(P '10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030.md')"
Write-Host "Decision gate: $(P '07_Decision_Log/DEC-WEEKLY-20261030-PORTFOLIO-GATES.md')"
