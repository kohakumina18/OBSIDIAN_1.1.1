param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [switch]$UpdateProjectNote,
    [switch]$UpdateMemory,
    [switch]$UpdateRegistry,
    [switch]$UpdateDomainModel,
    [switch]$UpdateResourceMatrix,
    [switch]$UpdateLedger,
    [switch]$UpdateCommandCenter,
    [switch]$UpdateCanvases,
    [switch]$CreateTasks,
    [switch]$CreateDecisionLog
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if ($DryRun -and $Apply) { throw "Use only one mode: -DryRun or -Apply." }
if (-not $Apply) { $DryRun = $true }

$scopeSpecified = $UpdateProjectNote -or $UpdateMemory -or $UpdateRegistry -or $UpdateDomainModel -or $UpdateResourceMatrix -or $UpdateLedger -or $UpdateCommandCenter -or $UpdateCanvases -or $CreateTasks -or $CreateDecisionLog
if (-not $scopeSpecified) {
    $UpdateProjectNote = $true
    $UpdateMemory = $true
    $UpdateRegistry = $true
    $UpdateDomainModel = $true
    $UpdateResourceMatrix = $true
    $UpdateLedger = $true
    $UpdateCommandCenter = $true
    $UpdateCanvases = $true
    $CreateTasks = $true
    $CreateDecisionLog = $true
}

$VaultRoot = (Get-Location).ProviderPath
$SourceEventId = "PPJ-PROJECT-REGISTRATION-ACC-INVENTORY-REPORT-V1.0-20260802"
$CanonicalCode = "ACC.Inventory.Report.v1.0"
$ProjectName = "Accounting Inventory Report"
$ProjectRelativePath = "03_Projects/ACC.Inventory.Report.v1.0.md"
$MemoryRelativePath = "03_Projects/_Registry/Project_Memory/ACC.Inventory.Report.v1.0.memory.md"
$TaskRelativePath = "03_Projects/_Tasks/TASK_ACC.Inventory.Report.v1.0_20260802_business-discovery-preparation.md"
$DecisionRelativePath = "07_Decision_Log/DEC-WEEKLY-20260801-ACC-INV.md"
$ReportRelativePath = "10_Reports/ACC_INVENTORY_REPORT_REGISTRATION_AND_CANVAS_UPDATE_REPORT_20260802.md"
$ProposalRelativePath = "03_Projects/_Registry/Project_Update_Proposals/ACCOUNTING_INVENTORY_REPORT_PROPOSAL_20260801.md"
$Today = "2026-08-02"
$Stamp = "20260802_" + (Get-Date -Format "HHmmss")
$MarkdownBackupRoot = Join-Path $VaultRoot "99_Attachments/Audit/ACC_Inventory_Report_Registration_Backup/$Stamp"
$CanvasBackupRoot = Join-Path $VaultRoot "99_Attachments/Canvas_Backup/$Stamp"
$OperationLogRelativePath = "99_Attachments/Audit/ACC_INVENTORY_REPORT_REGISTRATION_LOG_$Stamp.md"

$Paths = [ordered]@{
    Project = Join-Path $VaultRoot $ProjectRelativePath
    Memory = Join-Path $VaultRoot $MemoryRelativePath
    Proposal = Join-Path $VaultRoot $ProposalRelativePath
    MemoryIndex = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md"
    Registry = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md"
    DomainModel = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PORTFOLIO_DOMAIN_MODEL.md"
    DomainMatrix = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md"
    NamingDictionary = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md"
    AliasMap = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_ALIAS_MAP.md"
    ModuleIndex = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_MODULE_INDEX.md"
    ResourceMatrix = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md"
    Ledger = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md"
    CommandCenter = Join-Path $VaultRoot "03_Projects/PROJECT_COMMAND_CENTER.md"
    Task = Join-Path $VaultRoot $TaskRelativePath
    Decision = Join-Path $VaultRoot $DecisionRelativePath
    DecisionIndex = Join-Path $VaultRoot "07_Decision_Log/Decision_Log.md"
    Report = Join-Path $VaultRoot $ReportRelativePath
    OperationLog = Join-Path $VaultRoot $OperationLogRelativePath
    PurchasingProject = Join-Path $VaultRoot "03_Projects/PUR.Inventory Report.md"
}

$CanvasRelativePaths = @(
    "03_Projects/Canvas/PPJ_Portfolio.canvas",
    "03_Projects/Canvas/PPJ_Executive_Board.canvas",
    "03_Projects/Canvas/PPJ_Data_Flow.canvas",
    "03_Projects/Canvas/PPJ_Roadmap_2026.canvas",
    "03_Projects/Canvas/PPJ_Domain_Encapsulation.canvas"
)

function Read-Utf8 {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return "" }
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

function Write-Utf8 {
    param([string]$Path, [string]$Content)
    $directory = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }
    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

function Get-RelativePath {
    param([string]$Path)
    $full = [System.IO.Path]::GetFullPath($Path)
    return $full.Substring($VaultRoot.Length).TrimStart("\", "/") -replace "\\", "/"
}

function ConvertTo-YamlQuotedScalar {
    param([string]$Value)
    return '"' + ($Value -replace '"', '\"') + '"'
}

function Set-YamlFrontMatter {
    param(
        [string]$Content,
        [System.Collections.IDictionary]$Scalars,
        [System.Collections.IDictionary]$Lists
    )

    $match = [regex]::Match($Content, '(?s)\A---\r?\n(.*?)\r?\n---')
    if (-not $match.Success) { throw "Frontmatter is missing." }

    $lines = New-Object System.Collections.ArrayList
    [void]$lines.AddRange([string[]]([regex]::Split($match.Groups[1].Value, "\r?\n")))

    foreach ($key in $Lists.Keys) {
        $indexes = @()
        for ($i = 0; $i -lt $lines.Count; $i++) { if ([string]$lines[$i] -match ('^' + [regex]::Escape([string]$key) + ':\s*$')) { $indexes += $i } }
        if ($indexes.Count -gt 1) { throw "Duplicate YAML key: $key" }
        $insertAt = $lines.Count
        if ($indexes.Count -eq 1) {
            $insertAt = $indexes[0]
            $removeCount = 1
            while (($insertAt + $removeCount) -lt $lines.Count -and [string]$lines[$insertAt + $removeCount] -match '^\s+-\s') { $removeCount++ }
            $lines.RemoveRange($insertAt, $removeCount)
        }
        [void]$lines.Insert($insertAt, "$key`:")
        $offset = 1
        foreach ($item in @($Lists[$key])) {
            [void]$lines.Insert($insertAt + $offset, "  - $item")
            $offset++
        }
    }

    foreach ($key in $Scalars.Keys) {
        $indexes = @()
        for ($i = 0; $i -lt $lines.Count; $i++) { if ([string]$lines[$i] -match ('^' + [regex]::Escape([string]$key) + ':')) { $indexes += $i } }
        if ($indexes.Count -gt 1) { throw "Duplicate YAML key: $key" }
        $newLine = "$key`: $($Scalars[$key])"
        if ($indexes.Count -eq 1) { $lines[$indexes[0]] = $newLine } else { [void]$lines.Add($newLine) }
    }

    $frontmatter = "---`r`n" + ($lines -join "`r`n") + "`r`n---"
    return $frontmatter + $Content.Substring($match.Length)
}

function Set-ManagedKnowledgeBlock {
    param([string]$Content, [string]$BlockContent)
    $start = '<!-- PPJ_PROJECT_KNOWLEDGE_START -->'
    $end = '<!-- PPJ_PROJECT_KNOWLEDGE_END -->'
    $startCount = ([regex]::Matches($Content, [regex]::Escape($start))).Count
    $endCount = ([regex]::Matches($Content, [regex]::Escape($end))).Count
    $replacement = $start + "`r`n" + $BlockContent.Trim() + "`r`n" + $end
    if ($startCount -eq 0 -and $endCount -eq 0) { return $Content.TrimEnd() + "`r`n`r`n" + $replacement + "`r`n" }
    if ($startCount -ne 1 -or $endCount -ne 1) { throw "Managed project knowledge markers are malformed." }
    return [regex]::Replace($Content, '(?s)' + [regex]::Escape($start) + '.*?' + [regex]::Escape($end), [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement }, 1)
}

function Set-HeadingSection {
    param([string]$Content, [string]$Heading, [string]$Body, [int]$Level)
    $section = $Heading + "`r`n`r`n" + $Body.Trim()
    $pattern = '(?ms)^' + [regex]::Escape($Heading) + '\r?\n.*?(?=^#{1,' + $Level + '}\s|\z)'
    if ([regex]::IsMatch($Content, $pattern)) {
        return [regex]::Replace($Content, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $section + "`r`n`r`n" }, 1).TrimEnd() + "`r`n"
    }
    return $Content.TrimEnd() + "`r`n`r`n" + $section + "`r`n"
}

function Set-TableRow {
    param(
        [string]$Content,
        [string]$HeaderPattern,
        [string]$MatchPattern,
        [string]$Row,
        [string]$InsertAfterPattern = ""
    )

    $lines = New-Object System.Collections.ArrayList
    [void]$lines.AddRange([string[]]([regex]::Split($Content, "\r?\n")))
    $headerIndexes = @()
    for ($i = 0; $i -lt $lines.Count; $i++) { if ([string]$lines[$i] -match $HeaderPattern) { $headerIndexes += $i } }
    if ($headerIndexes.Count -ne 1) { throw "Expected one table header for pattern '$HeaderPattern'; found $($headerIndexes.Count)." }
    $headerIndex = $headerIndexes[0]
    $tableEnd = $headerIndex + 2
    while ($tableEnd -lt $lines.Count -and [string]$lines[$tableEnd] -match '^\|') { $tableEnd++ }
    $rowIndexes = @()
    for ($i = $headerIndex + 2; $i -lt $tableEnd; $i++) { if ([string]$lines[$i] -match $MatchPattern) { $rowIndexes += $i } }
    if ($rowIndexes.Count -gt 1) { throw "Duplicate table rows for pattern '$MatchPattern'." }
    if ($rowIndexes.Count -eq 1) {
        $lines[$rowIndexes[0]] = $Row
    }
    else {
        $insertIndex = $tableEnd
        if (-not [string]::IsNullOrWhiteSpace($InsertAfterPattern)) {
            for ($i = $headerIndex + 2; $i -lt $tableEnd; $i++) { if ([string]$lines[$i] -match $InsertAfterPattern) { $insertIndex = $i + 1 } }
        }
        [void]$lines.Insert($insertIndex, $Row)
    }
    return $lines -join "`r`n"
}

function Set-OrAddLine {
    param([string]$Content, [string]$MatchPattern, [string]$Line, [string]$AfterPattern)
    $lines = New-Object System.Collections.ArrayList
    [void]$lines.AddRange([string[]]([regex]::Split($Content, "\r?\n")))
    $lineIndexes = @()
    for ($i = 0; $i -lt $lines.Count; $i++) { if ([string]$lines[$i] -match $MatchPattern) { $lineIndexes += $i } }
    if ($lineIndexes.Count -gt 1) { throw "Duplicate lines for pattern '$MatchPattern'." }
    if ($lineIndexes.Count -eq 1) { $lines[$lineIndexes[0]] = $Line; return $lines -join "`r`n" }
    $afterMatches = @()
    for ($i = 0; $i -lt $lines.Count; $i++) { if ([string]$lines[$i] -match $AfterPattern) { $afterMatches += $i } }
    if ($afterMatches.Count -ne 1) { throw "Expected one insertion anchor for '$AfterPattern'." }
    [void]$lines.Insert($afterMatches[0] + 1, $Line)
    return $lines -join "`r`n"
}

function Add-ListItemUnderHeading {
    param([string]$Content, [string]$Heading, [string]$Item)
    if ([regex]::IsMatch($Content, '(?m)^' + [regex]::Escape($Item) + '\s*$')) { return $Content }
    $lines = New-Object System.Collections.ArrayList
    [void]$lines.AddRange([string[]]([regex]::Split($Content, "\r?\n")))
    $headingIndexes = @()
    for ($i = 0; $i -lt $lines.Count; $i++) { if ([string]$lines[$i] -eq $Heading) { $headingIndexes += $i } }
    if ($headingIndexes.Count -ne 1) { throw "Expected one heading '$Heading'." }
    $insertAt = $headingIndexes[0] + 1
    while ($insertAt -lt $lines.Count -and ([string]::IsNullOrWhiteSpace([string]$lines[$insertAt]) -or [string]$lines[$insertAt] -match '^- ')) { $insertAt++ }
    [void]$lines.Insert($insertAt, $Item)
    return $lines -join "`r`n"
}

function Set-ObjectProperty {
    param([object]$Object, [string]$Name, [object]$Value)
    if ($Object.PSObject.Properties.Name -contains $Name) { $Object.$Name = $Value } else { $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value }
}

function Resolve-CanvasPath {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return "" }
    return ($Value -replace "\\", "/").TrimStart("/")
}

function Set-CanvasNode {
    param(
        [object[]]$Nodes,
        [System.Collections.IDictionary]$Properties,
        [string]$IdentityId,
        [string]$IdentityFile = ""
    )

    $nodeMatches = @($Nodes | Where-Object {
        $_.id -eq $IdentityId -or
        (-not [string]::IsNullOrWhiteSpace($IdentityFile) -and $_.type -eq "file" -and (Resolve-CanvasPath $_.file) -eq $IdentityFile)
    })
    $uniqueMatches = @($nodeMatches | Group-Object id | ForEach-Object { $_.Group[0] })
    if ($uniqueMatches.Count -gt 1) { throw "Canvas node identity conflict for $IdentityId / $IdentityFile." }
    $action = "UPDATE"
    if ($uniqueMatches.Count -eq 0) {
        $node = [pscustomobject]$Properties
        $Nodes += $node
        $action = "CREATE"
    }
    else {
        $node = $uniqueMatches[0]
        foreach ($key in $Properties.Keys) {
            if ($key -eq "id") { continue }
            Set-ObjectProperty $node ([string]$key) $Properties[$key]
        }
    }
    return [pscustomobject]@{ Nodes = @($Nodes); Node = $node; Action = $action }
}

function Set-CanvasEdge {
    param([object[]]$Edges, [System.Collections.IDictionary]$Properties)
    $edgeMatches = @($Edges | Where-Object { $_.id -eq $Properties.id })
    if ($edgeMatches.Count -gt 1) { throw "Duplicate Canvas edge ID: $($Properties.id)" }
    $action = "UPDATE"
    if ($edgeMatches.Count -eq 0) {
        $edge = [pscustomobject]$Properties
        $Edges += $edge
        $action = "CREATE"
    }
    else {
        $edge = $edgeMatches[0]
        foreach ($key in $Properties.Keys) { if ($key -ne "id") { Set-ObjectProperty $edge ([string]$key) $Properties[$key] } }
    }
    return [pscustomobject]@{ Edges = @($Edges); Edge = $edge; Action = $action }
}

function Get-NodeGroupLabel {
    param([object]$Node, [object[]]$Groups)
    $centerX = [double]$Node.x + ([double]$Node.width / 2)
    $centerY = [double]$Node.y + ([double]$Node.height / 2)
    $inside = @($Groups | Where-Object {
        $centerX -ge [double]$_.x -and $centerX -le ([double]$_.x + [double]$_.width) -and
        $centerY -ge [double]$_.y -and $centerY -le ([double]$_.y + [double]$_.height)
    } | Sort-Object { [double]$_.width * [double]$_.height })
    if ($inside.Count -eq 0) { return "" }
    return [string]$inside[0].label
}

function Test-RectanglesOverlap {
    param([object]$A, [object]$B)
    return -not (([double]$A.x + [double]$A.width) -le [double]$B.x -or ([double]$B.x + [double]$B.width) -le [double]$A.x -or ([double]$A.y + [double]$A.height) -le [double]$B.y -or ([double]$B.y + [double]$B.height) -le [double]$A.y)
}

function Backup-MarkdownFile {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $relative = Get-RelativePath $Path
    $destination = Join-Path $MarkdownBackupRoot ($relative -replace "/", "\")
    $directory = Split-Path -Parent $destination
    if (-not (Test-Path -LiteralPath $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }
    Copy-Item -LiteralPath $Path -Destination $destination -Force
    if (-not (Test-Path -LiteralPath $destination)) { throw "Backup failed: $relative" }
}

$hardStops = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
$actions = New-Object System.Collections.Generic.List[object]
$writeMap = [ordered]@{}
$canvasJsonMap = [ordered]@{}
$canvasSummaries = New-Object System.Collections.Generic.List[object]

function Add-PlannedWrite {
    param([string]$Path, [string]$Content, [string]$Description)
    $status = if (Test-Path -LiteralPath $Path) { "UPDATE" } else { "CREATE" }
    $writeMap[$Path] = $Content
    $actions.Add([pscustomobject]@{ Status = $status; Path = Get-RelativePath $Path; Description = $Description }) | Out-Null
}

$eventSearchPaths = @($Paths.Project, $Paths.Memory, $Paths.Proposal, $Paths.Ledger, $Paths.Task, $Paths.Decision, $Paths.Report)
$existingEventFiles = @()
foreach ($path in $eventSearchPaths) { if ((Test-Path -LiteralPath $path) -and (Read-Utf8 $path) -like "*$SourceEventId*") { $existingEventFiles += Get-RelativePath $path } }
if ($existingEventFiles.Count -gt 0 -and -not $Force) {
    Write-Host "ACC Inventory Report Registration"
    Write-Host "Mode: $(if ($Apply) { 'APPLY' } else { 'DRYRUN' })"
    Write-Host "Source event already registered: $SourceEventId"
    foreach ($path in $existingEventFiles) { Write-Host "- Existing event: $path" }
    Write-Host "No files modified. Use -Force only for an explicitly approved refresh."
    exit 0
}

$requiredByScope = @()
if ($UpdateRegistry) { $requiredByScope += @($Paths.MemoryIndex, $Paths.Registry, $Paths.NamingDictionary, $Paths.AliasMap, $Paths.ModuleIndex, $Paths.Proposal) }
if ($UpdateDomainModel) { $requiredByScope += @($Paths.DomainModel, $Paths.DomainMatrix) }
if ($UpdateResourceMatrix) { $requiredByScope += $Paths.ResourceMatrix }
if ($UpdateLedger) { $requiredByScope += $Paths.Ledger }
if ($UpdateCommandCenter) { $requiredByScope += $Paths.CommandCenter }
if ($CreateDecisionLog) { $requiredByScope += @($Paths.Decision, $Paths.DecisionIndex) }
if ($UpdateCanvases) { foreach ($relative in $CanvasRelativePaths) { $requiredByScope += Join-Path $VaultRoot $relative } }
foreach ($required in @($requiredByScope | Select-Object -Unique)) { if (-not (Test-Path -LiteralPath $required)) { $hardStops.Add("Required source file missing: $(Get-RelativePath $required)") } }
if (-not (Test-Path -LiteralPath $Paths.PurchasingProject)) { $hardStops.Add("Separate Purchasing project note is missing: 03_Projects/PUR.Inventory Report.md") }

$rootProjectFiles = @(Get-ChildItem -LiteralPath (Join-Path $VaultRoot "03_Projects") -File -Filter "*.md")
$activeRootMatches = @()
foreach ($file in $rootProjectFiles) {
    $content = Read-Utf8 $file.FullName
    if ($file.Name -eq "ACC.Inventory.Report.v1.0.md" -or $content -match '(?m)^(canonical_code|project_code):\s*"?ACC\.Inventory\.(Control\.)?Report\.v1\.0"?\s*$' -or $content -match '(?m)^# Accounting Inventory Report\s*$') { $activeRootMatches += $file }
}
if ($activeRootMatches.Count -gt 1) { $hardStops.Add("ACC.Inventory.Report.v1.0 maps to multiple active root project notes: $($activeRootMatches.Name -join ', ')") }
if ($activeRootMatches.Count -eq 1 -and $activeRootMatches[0].Name -ne "ACC.Inventory.Report.v1.0.md") { $hardStops.Add("A conflicting active root note exists: $($activeRootMatches[0].Name)") }

$proposalMatches = @(Get-ChildItem -LiteralPath (Split-Path -Parent $Paths.Proposal) -File -Filter "*ACCOUNTING_INVENTORY_REPORT_PROPOSAL*.md")
if ($proposalMatches.Count -gt 1) { $hardStops.Add("Multiple Accounting Inventory candidate proposals exist.") }
if ($proposalMatches.Count -eq 0) { $warnings.Add("No prior candidate proposal was found; registration can proceed without proposal resolution.") }

if (Test-Path -LiteralPath $Paths.Task) {
    $taskExisting = Read-Utf8 $Paths.Task
    if ($taskExisting -notlike "*$SourceEventId*" -and -not $Force) { $hardStops.Add("Task filename already exists with a different source event.") }
}

$projectWasPresent = Test-Path -LiteralPath $Paths.Project
$memoryWasPresent = Test-Path -LiteralPath $Paths.Memory
$proposalWasPresent = Test-Path -LiteralPath $Paths.Proposal
$taskWasPresent = Test-Path -LiteralPath $Paths.Task
$decisionWasPresent = Test-Path -LiteralPath $Paths.Decision
$purHashBefore = if (Test-Path -LiteralPath $Paths.PurchasingProject) { (Get-FileHash -LiteralPath $Paths.PurchasingProject -Algorithm SHA256).Hash } else { "" }

$projectKnowledgeTemplate = @'
# Accounting Inventory Report

## Executive Summary

`ACC.Inventory.Report.v1.0` is the officially registered Finance / Accounting project for an Accounting-controlled inventory dataset and report. It remains **Backlog / Pending Resource**, progress is **Not Started**, and Business Discovery has not started. The next gate is **Business Discovery Approval**.

## Business Goal

Build an Accounting-controlled inventory report and dataset that helps Accounting determine inventory quantity and value at a reporting date or period, reconcile Accounting, Warehouse and Purchasing information, verify inventory before period close, identify data and posting exceptions, and produce trusted inventory data for reporting and downstream processes.

## Primary Output

Accounting-controlled Inventory Dataset and Inventory Control Report:

1. Standardized inventory dataset.
2. Quantity report.
3. Inventory-value report where source data is available.
4. Reconciliation differences.
5. Exception list.
6. Source-system and refresh information.
7. Reporting-period version.
8. Reconciliation with related reports.
9. Basic evidence and audit trace.

## Business Context

`PUR.Inventory.Report.v2.1` already supports Purchasing operational visibility. Accounting requires a separate control view.

Inventory Source Data -> Accounting Validation and Reconciliation -> ACC.Inventory.Report.v1.0 -> Approved Inventory Dataset -> Purchasing Report / Finance Analysis / Audit

The exact shared-data relationship must be confirmed by Accounting and Purchasing during Business Discovery.

Purchasing Inventory Report = operational visibility and purchasing decision support.

Accounting Inventory Report = inventory quantity, value, period control and reconciliation.

## Business Problems

1. No single Accounting-controlled inventory view.
2. Different reports may use different refresh times, filters and source systems.
3. Quantity and inventory value may not reconcile.
4. Inventory data may be posted to the wrong period.
5. Unit-of-measure inconsistency may distort quantity.
6. Inventory differences are difficult to trace.
7. Inventory errors may affect purchasing decisions, material allocation, asset value, costing, COGS, period closing and audit evidence.

## Scope

### In Scope - Proposed MVP

- Inventory quantity and inventory value where available.
- Company, factory, warehouse and location where available.
- Material code, description, category and unit of measure.
- Inventory status and reporting period.
- Opening balance; receipts; issues; returns; transfers; adjustments; closing balance.
- Source refresh time, exception detection and reconciliation.
- Excel export and basic audit trail.

Scope Status: **Proposed / Pending Business Discovery**.

### Potential Later Scope

- Inventory aging, slow-moving and obsolete inventory.
- Negative, unallocated and reserved-but-unused inventory.
- Inventory by OC, Style or Buyer Reference.
- Finance Control Platform integration.
- Natural-language analysis and automated exception assignment.

## Out of Scope

- Automatic inventory-transaction correction.
- Automatic accounting entries or adjustment approval.
- Automatic costing changes or purchasing decisions.
- Automatic stock-disposal decisions.
- Full inventory forecasting.

## Target Users

| User | Main Need |
| --- | --- |
| Accounting | Quantity, value, period control and reconciliation |
| Warehouse | Transaction and physical-quantity verification |
| Purchasing | Approved inventory view for purchasing decisions |
| Finance Management | Inventory value and movement monitoring |
| Audit | Traceability and evidence |
| IT / Data | Pipeline, source and refresh operation |

Business Owner: **Needs Confirmation**.

Primary Owner Group: **Accounting**.

## Target Process

Inventory Transactions -> Source Data Extraction -> Material / Warehouse / UOM Standardization -> Opening + Movement + Closing Calculation -> Inventory Valuation -> Accounting Reconciliation -> Exception Detection -> Accounting Review -> Approved Inventory Dataset -> Purchasing / Finance / Audit Reporting

1. Extract inventory data from the approved source.
2. Validate source-refresh date and time.
3. Standardize material, warehouse, location and unit of measure.
4. Determine opening balance.
5. Aggregate receipt, issue, return, transfer and adjustment.
6. Calculate closing balance.
7. Retrieve or calculate inventory value using approved Accounting rules.
8. Reconcile quantity and value.
9. Detect exceptions.
10. Accounting reviews exceptions.
11. Assign exceptions to Warehouse, Purchasing or another responsible unit.
12. Re-run after source correction.
13. Accounting confirms the dataset.
14. Downstream reporting uses the approved dataset.

## Potential Data Sources

All sources remain **Potential / Pending Data Discovery**.

| Source Group | Required Data |
| --- | --- |
| Material Master | Material code, description, category, UOM |
| Warehouse Master | Company, factory, warehouse, location |
| Opening Balance | Opening quantity and value |
| Goods Receipt | Receipt, GRN, supplier, PO |
| Goods Issue | Issue, OC, Style, department |
| Return | Warehouse return or supplier return |
| Transfer | Warehouse, company or location transfer |
| Adjustment | Inventory adjustment |
| Reservation | Reserved and available quantity |
| Accounting Posting | Recorded Accounting value |
| Currency | Currency and exchange rate |
| Period Master | Reporting period, cut-off and closed status |
| Purchasing Report | PUR.Inventory.Report.v2.1 dataset for reconciliation |

Open questions include the approved source, official inventory table or snapshot availability, stored versus calculated value, source ownership and approved read-access method. WFX, Databricks, Warehouse systems and other platforms are potential sources only. No source table is confirmed.

## Proposed Data Model

### Inventory Balance

Proposed / Pending Data Discovery:

`company_code`, `factory_code`, `warehouse_code`, `location_code`, `material_code`, `material_category`, `base_uom`, `reporting_period`, `opening_qty`, `receipt_qty`, `issue_qty`, `return_qty`, `transfer_in_qty`, `transfer_out_qty`, `adjustment_qty`, `closing_qty`, `inventory_value`, `currency`, `refresh_timestamp`, `source_system`.

### Inventory Exception

Proposed / Pending Data Discovery:

`exception_id`, `exception_type`, `severity`, `company`, `warehouse`, `material_code`, `period`, `affected_qty`, `affected_value`, `source`, `rule_id`, `owner`, `status`, `resolution_note`.

## Business Rules

### Balance Equation

Proposed equation:

Closing Balance = Opening Balance + Receipt + Transfer In + Return In - Issue - Transfer Out +/- Adjustment

Accounting must confirm transaction classification.

### Period Rule

Confirm cut-off date, transaction date versus posting date, backdated transactions, post-close transactions, reopened periods and closing snapshots.

### Valuation Rule

Moving average, weighted average, standard cost, actual cost, FIFO, direct WFX value, exchange rate, landed cost and adjustment value are options requiring Accounting confirmation. No valuation method is approved.

### Unit of Measure

Potential units include Meter, Yard, Kilogram, Piece, Roll, Box and Dozen. Quantities with incompatible units must not be aggregated before approved conversion.

### Inventory Status

Potential statuses include Available, Reserved, Allocated, Blocked, QC Hold, In Transit, Returned, Damaged and Obsolete.

## Draft Rule Engine

Rule Status: **Draft / Pending Accounting Approval**.

- INV-01: Closing quantity does not match movements.
- INV-02: Negative inventory.
- INV-03: Quantity exists but value is zero.
- INV-04: Value exists but quantity is zero.
- INV-05: Material is missing from Material Master.
- INV-06: Invalid warehouse or location.
- INV-07: Missing or invalid UOM.
- INV-08: UOM cannot be converted.
- INV-09: Duplicate transaction.
- INV-10: Transaction posted to wrong period.
- INV-11: Backdated transaction after closing.
- INV-12: Reserved quantity exceeds on-hand quantity.
- INV-13: Purchasing and Accounting reports do not reconcile.
- INV-14: Warehouse and Accounting balances do not reconcile.
- INV-15: Abnormal inventory-value movement.
- INV-16: Source has not refreshed within the required interval.
- INV-17: Inventory age exceeds threshold.
- INV-18: Adjustment exceeds threshold.
- INV-19: Missing exchange rate.
- INV-20: Source transaction cannot be identified.

## Proposed MVP

- One company.
- One or two warehouses.
- One reporting period.
- One material category.
- Quantity reconciliation first.
- Inventory value only if source data is ready.
- Reconciliation against one Accounting baseline report and PUR.Inventory.Report.v2.1.

Outputs: inventory dataset, quantity reconciliation, value reconciliation where feasible, exception list, source trace, Excel output and Accounting review result.

## Proposed Acceptance Criteria

Acceptance Status: **Proposed / Pending Business Discovery**.

- AC-01: Material Master mapping is complete for target scope.
- AC-02: Warehouse and location are correctly identified.
- AC-03: Opening balance matches Accounting baseline.
- AC-04: Receipt, issue, return and transfer match sample evidence.
- AC-05: Closing balance matches Accounting-approved report.
- AC-06: Inventory value matches baseline where included in MVP.
- AC-07: No record is silently removed.
- AC-08: Unmapped records create exceptions.
- AC-09: Duplicate records are detected.
- AC-10: Report displays correct period and refresh time.
- AC-11: Differences with Purchasing report can be explained.
- AC-12: Accounting performs final acceptance.
- AC-13: Basic export and audit trail are available.

## Dependencies

- Accounting Business Owner - Needs Confirmation.
- Warehouse Data Owner - Needs Confirmation.
- Purchasing representative - Needs Confirmation.
- Current Accounting inventory report.
- PUR.Inventory.Report.v2.1 dataset.
- WFX or approved inventory-source access - Needs Confirmation.
- Databricks access if applicable - Needs Confirmation.
- Material Master, Warehouse Master, period and valuation rules.
- BA, Data and Development resources - Needs Confirmation.

## Risks

- Source of truth is unclear.
- Purchasing and Accounting may use different periods.
- Quantity may be correct while value is incorrect.
- UOM, material codes and historical snapshots may be incomplete or inconsistent.
- Backdated transactions may change closed-period reports.
- Accounting scope could be incorrectly merged into Purchasing reporting.
- Delivery resources, Business Owner and valuation rules are not confirmed.

## Current Status

Officially confirmed:

- Canonical code: ACC.Inventory.Report.v1.0.
- Primary Domain: Finance / Accounting.
- Lifecycle: Backlog / Pending Resource.
- Progress: Not Started.
- Next Gate: Business Discovery Approval.
- Registration Status: Approved / Registered.
- Relationship exists with PUR.Inventory.Report.v2.1, but scope remains separate.

Not confirmed: named Business Owner, source system, report format, valuation method, MVP company/warehouse, timeline, technical owner, approved acceptance criteria and shared dataset design.

## Decisions Needed

- Assign Accounting Business Owner.
- Assign BA, Data and Technical resources.
- Confirm approved inventory source, period rules and valuation method.
- Confirm MVP company, warehouse, period and material category.
- Confirm the shared-data and reconciliation relationship with PUR.Inventory.Report.v2.1.
- Approve Business Discovery start.

## Immediate Next Actions

These are backlog actions, not active sprint commitments:

1. Assign Accounting Business Owner.
2. Assign BA, Data and Technical resources.
3. Collect current Accounting inventory report.
4. Collect PUR.Inventory.Report.v2.1 dataset and logic.
5. Document AS-IS process and Warehouse-Accounting-Purchasing data flow.
6. Confirm source of truth, quantity/value boundary, valuation method and period rules.
7. Select MVP company, warehouse and period.
8. Build Source Inventory, Field Catalogue and Rule Engine Catalogue.
9. Reconcile sample data.
10. Build BRD and WBS.

## Do Not Drift Rules

1. Do not merge with PUR.Inventory.Report.v2.1.
2. Do not place under Sourcing / Purchasing.
3. Do not mark Analysis started before Business Discovery approval.
4. Do not mark a valuation method approved without Accounting confirmation.
5. Do not invent source tables.
6. Do not invent owners or resources.
7. Keep draft rules separate from approved Accounting rules.

## Evidence and Confidence

- Evidence: User-approved project definition for ACC.Inventory.Report.v1.0.
- Source Event: {{SOURCE_EVENT}}.
- Registration, canonical code, primary domain and lifecycle confidence: Strong.
- Detailed requirements, sources, ownership, valuation and acceptance confidence: Needs Confirmation pending Business Discovery.

## Projects

- [[PUR.Inventory Report|PUR.Inventory.Report.v2.1]]
- [[FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN.AI.FINANCE.MANAGEMENT.v1.2]]
- [[PUR.Material.Allocation.v1.2]]

## Related Concepts

- [[Inventory Reconciliation]]
- [[Inventory Valuation]]
- [[Data Quality]]
- [[Exception Management]]
- [[Period Closing]]
- [[Audit Trail]]

## Methods

- [[Business Discovery]]
- [[Source Inventory]]
- [[Data Profiling]]
- [[Rule Engine Design]]
- [[UAT Planning]]

## Deliverables

- [[Decision_Driven_BRD]]
- [[Data_Dictionary_Template]]
- [[UAT_Checklist_Template]]
- [[WBS_Template]]
'@
$projectKnowledge = $projectKnowledgeTemplate.Replace("{{SOURCE_EVENT}}", $SourceEventId)

$projectFrontmatter = @"
---
type: project
project_name: "Accounting Inventory Report"
canonical_code: "ACC.Inventory.Report.v1.0"
primary_domain: "Finance / Accounting"
secondary_domains:
  - Warehouse
  - Purchasing
  - Data
  - Audit
lifecycle: "Backlog / Pending Resource"
progress: "Not Started"
current_gate: "Business Discovery Approval"
registration_status: "Approved / Registered"
resource_status: "Pending Resource"
business_owner: "Needs Confirmation"
current_file: "ACC.Inventory.Report.v1.0.md"
last_verified: "2026-08-02"
confidence: "Strong"
source_event: "$SourceEventId"
---
"@

$memoryTemplate = @'
---
type: project_memory
project_name: "Accounting Inventory Report"
project_file: "ACC.Inventory.Report.v1.0.md"
project_code: "ACC.Inventory.Report.v1.0"
canonical_code: "ACC.Inventory.Report.v1.0"
primary_domain: "Finance / Accounting"
secondary_domains: ["Warehouse", "Purchasing", "Data", "Audit"]
lifecycle: "Backlog / Pending Resource"
progress: "Not Started"
current_gate: "Business Discovery Approval"
registration_status: "Approved / Registered"
resource_status: "Pending Resource"
priority: "Backlog"
business_owner: "Needs Confirmation"
last_verified: "2026-08-02"
confidence: "Strong"
---

# Project Memory: ACC.Inventory.Report.v1.0

## One-Line Understanding

Accounting-controlled inventory dataset and report for quantity, value, period control, reconciliation and exception management.

## Current Outcome

Prepare a trusted Accounting inventory baseline for Purchasing, Finance and Audit after Business Discovery and resource approval.

## Current Status

- Lifecycle: Backlog / Pending Resource
- Progress: Not Started
- Gate: Business Discovery Approval
- Registration: Approved / Registered
- Resources: Pending Resource
- Business Owner: Needs Confirmation

## Latest Update Summary

The project is officially registered as ACC.Inventory.Report.v1.0 and remains Backlog / Pending Resource. Business Discovery has not started.

## What This Project Is

- Finance / Accounting inventory-control dataset and report.
- Quantity, value, period, reconciliation, exception and audit control layer.
- Related to PUR.Inventory.Report.v2.1 through future shared-data and reconciliation design.

## What This Project Is Not

- Not PUR.Inventory.Report.v2.1.
- Not an additional Purchasing-report tab.
- Not an active Analysis, Development, UAT or Production project.
- Not approval for automated transactions, accounting entries or adjustments.

## Key Users

Accounting is the primary user group. Warehouse, Purchasing, Finance Management, Audit and IT/Data are secondary users.

## Systems / Data

Potential only: Material Master, Warehouse Master, opening balance, receipts, issues, returns, transfers, adjustments, reservations, Accounting posting, currency, Period Master and PUR.Inventory.Report.v2.1. Approved source and source tables require Data Discovery.

## Known Risks / Blockers

- Business Owner and delivery resources are not assigned.
- Source of truth, periods, UOM conversion and valuation rules are not confirmed.
- Accounting and Purchasing scope could be incorrectly merged.

## Decisions Needed

- Business Owner, BA, Data and Technical resources.
- Approved source, valuation rule, period/cut-off rule and MVP boundary.
- Business Discovery start and relationship with PUR.Inventory.Report.v2.1.

## Next Actions

Assign resources, collect current Accounting and Purchasing reports, confirm source of truth, and approve Business Discovery.

## Dependencies

Accounting owner; Warehouse data owner; Purchasing representative; Accounting baseline report; PUR.Inventory.Report.v2.1; approved source access; Material/Warehouse masters; period and valuation rules; BA/Data/Development resources.

## Recent Update Events

| Date | Update Type | Summary | Source | Confidence |
| --- | --- | --- | --- | --- |
| 2026-08-02 | project_registration | Officially registered; remains Backlog / Pending Resource and has not started Business Discovery. | {{SOURCE_EVENT}} | Strong |

## Do Not Drift Rules

- Do not merge with PUR.Inventory.Report.v2.1.
- Do not place under Sourcing / Purchasing.
- Do not mark Analysis started before Business Discovery approval.
- Do not approve valuation methods, source tables, owners or resources without evidence.
- Keep draft rules separate from approved Accounting controls.

## Source Links

- [[ACC.Inventory.Report.v1.0]]
- [[PUR.Inventory Report|PUR.Inventory.Report.v2.1]]
- [[FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN.AI.FINANCE.MANAGEMENT.v1.2]]
'@
$memoryContent = $memoryTemplate.Replace("{{SOURCE_EVENT}}", $SourceEventId)

try {
    if ($UpdateProjectNote) {
        if (Test-Path -LiteralPath $Paths.Project) {
            $projectContent = Read-Utf8 $Paths.Project
            $projectContent = Set-YamlFrontMatter $projectContent ([ordered]@{
                type = ConvertTo-YamlQuotedScalar "project"
                project_name = ConvertTo-YamlQuotedScalar $ProjectName
                canonical_code = ConvertTo-YamlQuotedScalar $CanonicalCode
                primary_domain = ConvertTo-YamlQuotedScalar "Finance / Accounting"
                lifecycle = ConvertTo-YamlQuotedScalar "Backlog / Pending Resource"
                progress = ConvertTo-YamlQuotedScalar "Not Started"
                current_gate = ConvertTo-YamlQuotedScalar "Business Discovery Approval"
                registration_status = ConvertTo-YamlQuotedScalar "Approved / Registered"
                resource_status = ConvertTo-YamlQuotedScalar "Pending Resource"
                business_owner = ConvertTo-YamlQuotedScalar "Needs Confirmation"
                current_file = ConvertTo-YamlQuotedScalar "ACC.Inventory.Report.v1.0.md"
                last_verified = ConvertTo-YamlQuotedScalar $Today
                confidence = ConvertTo-YamlQuotedScalar "Strong"
                source_event = ConvertTo-YamlQuotedScalar $SourceEventId
            }) ([ordered]@{ secondary_domains = @("Warehouse", "Purchasing", "Data", "Audit") })
            $projectContent = Set-ManagedKnowledgeBlock $projectContent $projectKnowledge
        }
        else {
            $projectContent = $projectFrontmatter.TrimEnd() + "`r`n`r`n<!-- PPJ_PROJECT_KNOWLEDGE_START -->`r`n" + $projectKnowledge.Trim() + "`r`n<!-- PPJ_PROJECT_KNOWLEDGE_END -->`r`n"
        }
        Add-PlannedWrite $Paths.Project $projectContent "official project note and managed approved knowledge"
    }

    if ($UpdateMemory) {
        if (([regex]::Split($memoryContent, "\r?\n")).Count -gt 120) { throw "Memory card exceeds 120 lines." }
        Add-PlannedWrite $Paths.Memory $memoryContent "compact project memory card"
    }

    if ($UpdateRegistry) {
        $proposalContent = Read-Utf8 $Paths.Proposal
        if (-not [string]::IsNullOrWhiteSpace($proposalContent)) {
            $proposalContent = Set-YamlFrontMatter $proposalContent ([ordered]@{
                proposed_canonical_code = ConvertTo-YamlQuotedScalar $CanonicalCode
                primary_domain = ConvertTo-YamlQuotedScalar "Finance / Accounting"
                lifecycle = ConvertTo-YamlQuotedScalar "Backlog / Pending Resource"
                progress = ConvertTo-YamlQuotedScalar "Not Started"
                status = ConvertTo-YamlQuotedScalar "Approved / Registered"
                registration_status = ConvertTo-YamlQuotedScalar "Approved / Registered"
                resource_status = ConvertTo-YamlQuotedScalar "Pending Resource"
                registration_approved = "true"
                approval_date = ConvertTo-YamlQuotedScalar $Today
                registered_project = ConvertTo-YamlQuotedScalar $CanonicalCode
                registration_source_event = ConvertTo-YamlQuotedScalar $SourceEventId
            }) ([ordered]@{})
            $proposalBody = @"
The candidate history from `PPJ-WEEKLY-20260727-20260801` is preserved. Registration was approved on 2026-08-02.

- Canonical project: [[ACC.Inventory.Report.v1.0]]
- Registration Status: Approved / Registered
- Lifecycle: Backlog / Pending Resource
- Progress: Not Started
- Current Gate: Business Discovery Approval
- Business Owner: Needs Confirmation
- Source Event: $SourceEventId

The project remains separate from [[PUR.Inventory Report|PUR.Inventory.Report.v2.1]]. Business Discovery and delivery have not started.
"@
            $proposalContent = Set-HeadingSection $proposalContent "## Registration Resolution - 2026-08-02" $proposalBody 2
            Add-PlannedWrite $Paths.Proposal $proposalContent "candidate history resolution and approved registration link"
        }

        $index = Read-Utf8 $Paths.MemoryIndex
        $index = Set-TableRow $index '^\| Project\s+\| Memory Card' '^\| \[\[ACC\.Inventory\.Report\.v1\.0' '| [[ACC.Inventory.Report.v1.0]] | [[ACC.Inventory.Report.v1.0.memory]] | [[ACC.Inventory.Report.v1.0]] | Finance / Accounting | Backlog / Pending Resource | Backlog | Accounting-controlled inventory dataset and report for quantity, value, period control, reconciliation and exception management. | Prepare a trusted Accounting inventory baseline for Purchasing, Finance and Audit after Business Discovery and resource approval. | PPJ-PROJECT-REGISTRATION-ACC-INVENTORY-REPORT-V1.0-20260802 | Strong registration; Needs Confirmation requirements/ownership | 2026-08-02 |' '^\| \[\[PUR\.Inventory Report'
        $index = Set-TableRow $index '^\| Canonical Code\s+\| Current File\s+\| Primary Domain\s+\| Secondary Domains\s+\| Lifecycle\s+\| Progress\s+\| Current Gate' '^\| ACC\.Inventory\.Report\.v1\.0\s+\|' '| ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Finance / Accounting | Warehouse, Purchasing, Data, Audit | Backlog / Pending Resource | Not Started | Business Discovery Approval |' '^\| FIN\.AI\.FINANCE\.MANAGEMENT\.v1\.2\s+\|'
        Add-PlannedWrite $Paths.MemoryIndex $index "memory index main row and domain overlay"

        $registry = Read-Utf8 $Paths.Registry
        $registry = Set-TableRow $registry '^\| Project Name\s+\| Canonical Filename' '^\| ACC\.Inventory\.Report\.v1\.0\s+\|' '| ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Backlog / Pending Resource | Accounting Inventory Control | Needs Confirmation | Needs Confirmation | Finance / Accounting | Approved / Registered / Backlog | Not Started | Accounting owner, delivery resources, approved source and Accounting rules are not confirmed. | Approve Business Discovery start after resourcing. | Assign resources and approve Business Discovery. | Decision_Driven_BRD; Data_Dictionary_Template; UAT_Checklist_Template; WBS_Template | Potential inventory source / PUR.Inventory.Report.v2.1 reconciliation | ACC.Inventory.Report.v1.0.md | 90 | Accounting-controlled inventory report; separate from Purchasing visibility. |' '^\| FIN\.AI\.FINANCE\.MANAGEMENT\.v1\.2\s+\|'
        $registry = Set-TableRow $registry '^\| Project Name \| Canonical Code \| Current File \| Primary Domain' '^\| ACC\.Inventory\.Report\.v1\.0\s+\|' '| ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Finance / Accounting | Inventory quantity, value, period control and reconciliation | Backlog / Pending Resource | Not Started | Business Discovery Approval |' '^\| FIN\.AI\.FINANCE\.MANAGEMENT\.v1\.2\s+\|'
        Add-PlannedWrite $Paths.Registry $registry "master registry and primary-domain overlay"

        $dictionary = Read-Utf8 $Paths.NamingDictionary
        $dictionary = Set-TableRow $dictionary '^\| Canonical Code\s+\| Main Alias / Old Names' '^\| `?ACC\.Inventory\.Report\.v1\.0`?\s+\|' '| `ACC.Inventory.Report.v1.0` | Accounting Inventory Report; ACC Inventory Report; Accounting-controlled Inventory Report; ACC.Inventory.Control.Report.v1.0 | Accounting Inventory Control | Backlog / Pending Resource | Accounting; owners and resources Needs Confirmation | [[ACC.Inventory.Report.v1.0]] | Accounting-controlled inventory quantity, value, period, reconciliation and exception-reporting project. |' '^\| `?FIN\.AI\.FINANCE\.MANAGEMENT'
        $dictionary = Set-TableRow $dictionary '^\| Canonical Code\s+\| Main Alias / Old Names' '^\| `?PUR\.Inventory\.Report\.v(1\.0|2\.1)`?\s+\|' '| `PUR.Inventory.Report.v2.1` | Purchasing Inventory Report; PUR.Inventory Report; Inventory Report | Purchasing Report | Production / Support | Purchasing and material-planning users | [[PUR.Inventory Report]] | Operational inventory visibility and purchasing decision support; separate from Accounting inventory control. |'
        $dictionary = Set-TableRow $dictionary '^\| If user says\s+\| Interpret as' '^\| accounting inventory report\s+\|' '| accounting inventory report | `ACC.Inventory.Report.v1.0` |'
        $dictionary = Set-TableRow $dictionary '^\| If user says\s+\| Interpret as' '^\| ACC inventory report\s+\|' '| ACC inventory report | `ACC.Inventory.Report.v1.0` |'
        $dictionary = Set-TableRow $dictionary '^\| If user says\s+\| Interpret as' '^\| accounting-controlled inventory report\s+\|' '| accounting-controlled inventory report | `ACC.Inventory.Report.v1.0` |'
        $dictionary = Set-TableRow $dictionary '^\| If user says\s+\| Interpret as' '^\| purchasing inventory report\s+\|' '| purchasing inventory report | `PUR.Inventory.Report.v2.1` |'
        $dictionary = Set-TableRow $dictionary '^\| Canonical Code \| Current Storage Note \| Primary Domain \| Alias / Old Names \| Rename Pending' '^\| `?ACC\.Inventory\.Report\.v1\.0`?\s+\|' '| `ACC.Inventory.Report.v1.0` | [[ACC.Inventory.Report.v1.0]] | Finance / Accounting | Accounting Inventory Report; ACC Inventory Report; Accounting-controlled Inventory Report; ACC.Inventory.Control.Report.v1.0 | No |' '^\| `?FIN\.AI\.FINANCE\.MANAGEMENT'
        $dictionary = Set-TableRow $dictionary '^\| Canonical Code \| Current Storage Note \| Primary Domain \| Alias / Old Names \| Rename Pending' '^\| `?PUR\.Inventory\.Report\.v(1\.0|2\.1)`?\s+\|' '| `PUR.Inventory.Report.v2.1` | [[PUR.Inventory Report]] | Sourcing / Purchasing | PUR.Inventory Report; Purchasing Inventory Report; Inventory Report | Yes - physical filename retained |'
        Add-PlannedWrite $Paths.NamingDictionary $dictionary "canonical code, aliases, discussion mapping and PUR separation"

        $aliasMap = Read-Utf8 $Paths.AliasMap
        $legacyAliasRows = @(
            @('^\| ACC\.Inventory\.Control\.Report\.v1\.0\.md\s+\|', '| ACC.Inventory.Control.Report.v1.0.md | ACC.Inventory.Report.v1.0.md | Superseded proposal code; approved canonical project is ACC.Inventory.Report.v1.0. | High | Resolve to approved canonical project | Yes | Yes |'),
            @('^\| Accounting Inventory Report\.md\s+\|', '| Accounting Inventory Report.md | ACC.Inventory.Report.v1.0.md | Approved spoken-name alias for the Accounting-controlled inventory project. | High | Resolve to approved canonical project | Yes | Yes |'),
            @('^\| ACC Inventory Report\.md\s+\|', '| ACC Inventory Report.md | ACC.Inventory.Report.v1.0.md | Approved compact alias for the Accounting-controlled inventory project. | High | Resolve to approved canonical project | Yes | Yes |'),
            @('^\| Accounting-controlled Inventory Report\.md\s+\|', '| Accounting-controlled Inventory Report.md | ACC.Inventory.Report.v1.0.md | Approved capability alias for the Accounting-controlled inventory project. | High | Resolve to approved canonical project | Yes | Yes |')
        )
        foreach ($entry in $legacyAliasRows) { $aliasMap = Set-TableRow $aliasMap '^\| Alias Filename\s+\| Canonical Filename' $entry[0] $entry[1] }
        $overlayAliasRows = @(
            @('^\| ACC\.Inventory\.Report\.v1\.0\.md\s+\|', '| ACC.Inventory.Report.v1.0.md | ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Current storage note for the approved Accounting inventory project | Strong |'),
            @('^\| ACC\.Inventory\.Report\.v1\.0\s+\|', '| ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Approved canonical code | Strong |'),
            @('^\| Accounting Inventory Report\s+\|', '| Accounting Inventory Report | ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Approved spoken project name; not the Purchasing report | Strong |'),
            @('^\| ACC Inventory Report\s+\|', '| ACC Inventory Report | ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Approved compact alias | Strong |'),
            @('^\| Accounting-controlled Inventory Report\s+\|', '| Accounting-controlled Inventory Report | ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Approved capability alias | Strong |'),
            @('^\| ACC\.Inventory\.Control\.Report\.v1\.0\s+\|', '| ACC.Inventory.Control.Report.v1.0 | ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Superseded candidate code retained as alias history | Strong |')
        )
        foreach ($entry in $overlayAliasRows) { $aliasMap = Set-TableRow $aliasMap '^\| Alias / Current Name \| Canonical Code \| Current Storage Note' $entry[0] $entry[1] }
        $purAliasRows = @(
            @('^\| PUR\.Inventory Report\.md\s+\|', '| PUR.Inventory Report.md | PUR.Inventory.Report.v2.1 | PUR.Inventory Report.md | Current storage note; physical filename retained | Strong |'),
            @('^\| PUR\.Inventory Report\s+\|', '| PUR.Inventory Report | PUR.Inventory.Report.v2.1 | PUR.Inventory Report.md | Purchasing operational inventory visibility alias | Strong |'),
            @('^\| Purchasing Inventory Report\s+\|', '| Purchasing Inventory Report | PUR.Inventory.Report.v2.1 | PUR.Inventory Report.md | Purchasing operational inventory visibility; separate from Accounting control | Strong |'),
            @('^\| Inventory Report\s+\|', '| Inventory Report | PUR.Inventory.Report.v2.1 | PUR.Inventory Report.md | Legacy generic Purchasing alias; use Accounting qualifier for ACC project | Strong |')
        )
        foreach ($entry in $purAliasRows) { $aliasMap = Set-TableRow $aliasMap '^\| Alias / Current Name \| Canonical Code \| Current Storage Note' $entry[0] $entry[1] }
        Add-PlannedWrite $Paths.AliasMap $aliasMap "approved aliases, superseded candidate code and PUR boundary"

        $moduleIndex = Read-Utf8 $Paths.ModuleIndex
        $moduleIndex = Add-ListItemUnderHeading $moduleIndex "## Accounting / Invoice Automation" "- [[ACC.Inventory.Report.v1.0]]"
        Add-PlannedWrite $Paths.ModuleIndex $moduleIndex "Accounting module registration"
    }

    if ($UpdateDomainModel) {
        $domainModel = Read-Utf8 $Paths.DomainModel
        $domainModel = Set-OrAddLine $domainModel '^Last updated:' 'Last updated: 2026-08-02' '^# PPJ Portfolio Domain Model$'
        $domainModel = Set-TableRow $domainModel '^\| Primary Domain \| Capability \|' '^\| Finance / Accounting\s+\|' '| Finance / Accounting | Financial analysis, reporting, invoices, GRN and inventory control |'
        $domainModel = Set-OrAddLine $domainModel '^- Backlog / Pending Resource$' '- Backlog / Pending Resource' '^- Analysis$'
        $domainModel = Set-OrAddLine $domainModel '^- ACC\.Inventory\.Report\.v1\.0 and PUR\.Inventory\.Report\.v2\.1' '- ACC.Inventory.Report.v1.0 and PUR.Inventory.Report.v2.1 are separate projects: Accounting controls quantity/value/period/reconciliation; Purchasing supports operational visibility and purchasing decisions.' '^- PPJ\.InvoiceDownloader\.v1\.2 belongs to Finance / Accounting'
        $domainModel = Set-TableRow $domainModel '^\| Canonical Code \| Primary Domain \| Lifecycle \| Current File \|' '^\| PUR\.Inventory\.Report\.v(1\.0|2\.1)\s+\|' '| PUR.Inventory.Report.v2.1 | Sourcing / Purchasing | Production / Support | PUR.Inventory Report.md |'
        $domainModel = Set-TableRow $domainModel '^\| Canonical Code \| Primary Domain \| Lifecycle \| Current File \|' '^\| ACC\.Inventory\.Report\.v1\.0\s+\|' '| ACC.Inventory.Report.v1.0 | Finance / Accounting | Backlog / Pending Resource | ACC.Inventory.Report.v1.0.md |' '^\| FIN\.AI\.FINANCE\.MANAGEMENT'
        Add-PlannedWrite $Paths.DomainModel $domainModel "official domain capability, lifecycle, boundary and canonical placement"

        $domainMatrix = Read-Utf8 $Paths.DomainMatrix
        $domainMatrix = Set-TableRow $domainMatrix '^\| Canonical Code \| Current File \| Primary Domain \| Primary Capability' '^\| ACC\.Inventory\.Report\.v1\.0\s+\|' '| ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Finance / Accounting | Inventory quantity, value, period control and reconciliation | Warehouse, Purchasing, Data, Audit | Backlog / Pending Resource | Not Started | Business Discovery Approval | Accounting / Business Owner Needs Confirmation | Strong registration; Needs Confirmation requirements and ownership | Separate from PUR.Inventory.Report.v2.1; shared-data relationship pending Business Discovery. |' '^\| FIN\.AI\.FINANCE\.MANAGEMENT\.v1\.2\s+\|'
        Add-PlannedWrite $Paths.DomainMatrix $domainMatrix "Finance/Accounting primary-domain assignment"
    }

    if ($UpdateResourceMatrix) {
        $resource = Read-Utf8 $Paths.ResourceMatrix
        $resource = Set-TableRow $resource '^\| Canonical Project Name\s+\| Alias Names\s+\| Phase / Progress' '^\| \[\[ACC\.Inventory\.Report\.v1\.0\]\]' '| [[ACC.Inventory.Report.v1.0]] | Accounting Inventory Report; ACC Inventory Report; Accounting-controlled Inventory Report | Backlog / Pending Resource / Not Started | Needs Confirmation | Needs Confirmation | Accounting; Warehouse, Purchasing, Finance Management, Audit | Finance / Accounting | High - pending owner, source and delivery resources | Backlog | Accounting owner, BA/Data/Technical resources, approved source, period and valuation rules are not confirmed. | Approve Business Discovery after resource assignment. | Assign resources and approve Business Discovery. | ACC.Inventory.Report.v1.0.md | 90 |' '^\| \[\[FIN\.AI\.FINANCE\.MANAGEMENT'
        $resource = Set-TableRow $resource '^\| Canonical Project Name\s+\| Current File\s+\| Primary Domain\s+\| Primary Capability' '^\| ACC\.Inventory\.Report\.v1\.0\s+\|' '| ACC.Inventory.Report.v1.0 | ACC.Inventory.Report.v1.0.md | Finance / Accounting | Inventory quantity, value, period control and reconciliation | Warehouse, Purchasing, Data, Audit | Backlog / Pending Resource / Not Started | Accounting; Business Owner, BA, Data and Technical Needs Confirmation | Business Discovery Approval |' '^\| FIN\.AI\.FINANCE\.MANAGEMENT\.v1\.2\s+\|'
        Add-PlannedWrite $Paths.ResourceMatrix $resource "pending-resource row and domain/capability overlay"
    }

    if ($UpdateLedger) {
        $ledger = Read-Utf8 $Paths.Ledger
        $ledger = Set-TableRow $ledger '^\| Date \| Project \| Update Type \| Summary' ('\|[^\r\n]*' + [regex]::Escape($SourceEventId)) '| 2026-08-02 | ACC.Inventory.Report.v1.0 | project_registration | Accounting Inventory Report was officially registered as a Finance / Accounting project. It remains Backlog / Pending Resource and awaits Business Discovery approval. PUR.Inventory.Report.v2.1 remains separate. | registration_status | Candidate / Pending Registration | Approved / Registered | User-approved project definition / PPJ-PROJECT-REGISTRATION-ACC-INVENTORY-REPORT-V1.0-20260802 | Strong | Project Note, Memory Card, Registry, Domain Matrix, Resource Matrix, Command Center and Canvas views | Assign resources and approve Business Discovery. |'
        Add-PlannedWrite $Paths.Ledger $ledger "append-only project registration event"
    }

    if ($UpdateCommandCenter) {
        $commandCenter = Read-Utf8 $Paths.CommandCenter
        $commandBody = @'
- **`ACC.Inventory.Report.v1.0`**
  - Domain: Finance / Accounting
  - Lifecycle: Backlog / Pending Resource
  - Gate: Business Discovery Approval
  - Outcome: Accounting-controlled inventory dataset, reconciliation report and exception list.
  - Dependency: Accounting owner, resources, inventory source and relationship with PUR.Inventory.Report.v2.1.
'@
        $commandCenter = Set-HeadingSection $commandCenter "### Registered Backlog" $commandBody 3
        $commandCenter = [regex]::Replace($commandCenter, '(?m)^- Accounting Inventory Report - Pending Resource / Pending Registration Approval; no root note created\.\r?\n?', '')
        $commandCenter = $commandCenter -replace '### Backlog / Candidate\s*(?=\r?\n\r?\n|\z)', ''
        Add-PlannedWrite $Paths.CommandCenter $commandCenter "compact registered backlog entry"
    }

    if ($CreateTasks) {
        $taskContent = @"
---
type: task
created: "2026-08-02"
project: "ACC.Inventory.Report.v1.0"
lane: "TASKS / DOCS TO UPDATE"
status: "Backlog"
priority: "Backlog"
source_event: "$SourceEventId"
---

# ACC.Inventory.Report.v1.0 - Business Discovery Preparation

Project
[[ACC.Inventory.Report.v1.0]]

Outcome
Prepare the Accounting inventory project for a controlled Business Discovery decision without starting delivery.

Scope

- Assign Accounting Business Owner.
- Assign BA, Data and Technical resources.
- Collect the current Accounting inventory report.
- Collect [[PUR.Inventory Report|PUR.Inventory.Report.v2.1]] dataset and logic.
- Confirm source of truth and proposed MVP boundary.
- Confirm valuation and period rules.

Next Action
Assign resources and approve Business Discovery.

Dependencies
Accounting owner; Warehouse Data Owner; Purchasing representative; approved source access; period and valuation rules.

Source / Context
User-approved project definition for ACC.Inventory.Report.v1.0.

Validation
This remains a backlog-preparation task and must not be treated as an active sprint commitment.
"@
        Add-PlannedWrite $Paths.Task $taskContent "grouped backlog Business Discovery preparation task"
    }

    if ($CreateDecisionLog) {
        $decisionContent = @"
---
type: decision
id: "DEC-WEEKLY-20260801-ACC-INV"
date: "2026-08-02"
project: "ACC.Inventory.Report.v1.0"
status: "Registration Approved / Discovery Gate Pending"
owner: "Accounting / Portfolio Governance"
source_event: "$SourceEventId"
---

# ACC.Inventory.Report.v1.0 - Registration and Business Discovery Gate

## Decision Made

- Project registration is approved.
- Canonical code is `ACC.Inventory.Report.v1.0`.
- Primary Domain is Finance / Accounting.
- Lifecycle remains Backlog / Pending Resource.
- Progress remains Not Started.
- The project remains separate from [[PUR.Inventory Report|PUR.Inventory.Report.v2.1]].

## Open Decisions

- Accounting Business Owner.
- BA, Data and Technical resources.
- Approved data source and access method.
- Valuation and period rules.
- MVP company, warehouse, period and material category.
- Business Discovery start.

## Evidence

User-approved project definition for ACC.Inventory.Report.v1.0.

## Next Step

Assign resources and approve Business Discovery. Do not start Analysis before the gate is approved.
"@
        Add-PlannedWrite $Paths.Decision $decisionContent "registration decision and open discovery gates"
        $decisionIndex = Read-Utf8 $Paths.DecisionIndex
        $decisionIndex = Set-TableRow $decisionIndex '^\| Decision ID \| Decision \| Date \| Owner \| Impact \| Link \|' '^\| DEC-WEEKLY-20260801-ACC-INV\s+\|' '| DEC-WEEKLY-20260801-ACC-INV | ACC.Inventory.Report.v1.0 Registration and Business Discovery Gate | 2026-08-02 | Accounting / Portfolio Governance | ACC.Inventory.Report.v1.0 | [[DEC-WEEKLY-20260801-ACC-INV]] |'
        Add-PlannedWrite $Paths.DecisionIndex $decisionIndex "decision index canonical impact update"
    }
}
catch {
    $hardStops.Add("Markdown preview failed: $($_.Exception.Message)")
}

if ($UpdateCanvases -and $hardStops.Count -eq 0) {
    try {
        foreach ($relativePath in $CanvasRelativePaths) {
            $canvasPath = Join-Path $VaultRoot $relativePath
            $canvas = Read-Utf8 $canvasPath | ConvertFrom-Json
            $originalNodes = @($canvas.nodes)
            $originalEdges = @($canvas.edges)
            $nodes = @($canvas.nodes)
            $edges = @($canvas.edges)
            $name = Split-Path -Leaf $canvasPath
            $nodeActions = New-Object System.Collections.Generic.List[string]
            $edgeActions = New-Object System.Collections.Generic.List[string]

            if ($name -eq "PPJ_Portfolio.canvas") {
                $brokenMaterial = @($nodes | Where-Object { $_.id -eq "effdbd488aa8" })
                if ($brokenMaterial.Count -eq 1) { Set-ObjectProperty $brokenMaterial[0] "file" "03_Projects/PUR.Material.Allocation.v1.2.md"; $nodeActions.Add("REPAIR broken Material Allocation file reference") | Out-Null }
                $brokenMarket = @($nodes | Where-Object { $_.id -eq "3ed4f5a8c9d7" })
                if ($brokenMarket.Count -eq 1) { Set-ObjectProperty $brokenMarket[0] "file" "03_Projects/E-commerce Market Intelligence v.2.3.md"; $nodeActions.Add("REPAIR broken Market Intelligence file reference") | Out-Null }
                $result = Set-CanvasNode $nodes ([ordered]@{ id = "port-acc-inventory-report-v1-0"; type = "file"; file = $ProjectRelativePath; x = 6330; y = 120; width = 350; height = 110; color = "4" }) "port-acc-inventory-report-v1-0" $ProjectRelativePath
                $nodes = $result.Nodes
                $nodeActions.Add("$($result.Action) Finance/Accounting portfolio project card") | Out-Null
            }
            elseif ($name -eq "PPJ_Executive_Board.canvas") {
                $result = Set-CanvasNode $nodes ([ordered]@{ id = "exec-acc-inventory-report-v1-0"; type = "file"; file = $ProjectRelativePath; x = 0; y = 325; width = 340; height = 160; color = "4" }) "exec-acc-inventory-report-v1-0" $ProjectRelativePath
                $nodes = $result.Nodes
                $projectNode = $result.Node
                $nodeActions.Add("$($result.Action) PENDING project card") | Out-Null
                $candidate = @($nodes | Where-Object { $_.id -eq "exec-candidates" })
                if ($candidate.Count -gt 1) { throw "Duplicate exec-candidates nodes." }
                if ($candidate.Count -eq 1) {
                    $cleanLines = @([regex]::Split([string]$candidate[0].text, "\r?\n") | Where-Object { $_ -notmatch 'ACC\.Inventory\.(Control\.)?Report\.v1\.0|Accounting Inventory Report' })
                    Set-ObjectProperty $candidate[0] "text" (($cleanLines -join "`n").TrimEnd())
                    $nodeActions.Add("UPDATE candidate text to remove registered project") | Out-Null
                }
                if ($CreateTasks) {
                    $taskResult = Set-CanvasNode $nodes ([ordered]@{ id = "exec-task-acc-inventory-report-v1-0"; type = "file"; file = $TaskRelativePath; x = 11105; y = 1100; width = 340; height = 115; color = "6" }) "exec-task-acc-inventory-report-v1-0" $TaskRelativePath
                    $nodes = $taskResult.Nodes
                    $nodeActions.Add("$($taskResult.Action) backlog preparation task card") | Out-Null
                    $edgeResult = Set-CanvasEdge $edges ([ordered]@{ id = "exec-edge-acc-inventory-report-v1-0-task"; fromNode = $projectNode.id; fromSide = "right"; toNode = $taskResult.Node.id; toSide = "left"; label = "backlog preparation" })
                    $edges = $edgeResult.Edges
                    $edgeActions.Add("$($edgeResult.Action) project-to-task edge") | Out-Null
                }
            }
            elseif ($name -eq "PPJ_Data_Flow.canvas") {
                $sourceText = "Potential / Pending Data Discovery`nMaterial Master; Warehouse Master; Inventory Transactions; Accounting Posting; Period Master; Currency / Exchange Rate`nWFX, Databricks or other sources are not confirmed."
                $validationText = "Accounting Validation and Reconciliation`nMaterial / Warehouse / UOM standardization`nOpening + Movement + Closing`nQuantity/value reconciliation and draft exceptions"
                $projectText = "[[ACC.Inventory.Report.v1.0]]`n`nACC.Inventory.Report.v1.0`nFinance / Accounting`nBacklog / Pending Resource`nBusiness Discovery Approval"
                $outputText = "Approved Inventory Dataset`n- Accounting-controlled quantity/value baseline`n- Reconciliation Report and Exception List`n- Downstream: PUR.Inventory.Report.v2.1, Finance Analysis, Audit"
                foreach ($definition in @(
                    [ordered]@{ id = "src-acc-inventory"; type = "text"; text = $sourceText; x = 30; y = 2250; width = 410; height = 200; color = "6" },
                    [ordered]@{ id = "data-acc-inventory"; type = "text"; text = $validationText; x = 590; y = 2250; width = 460; height = 200; color = "4" },
                    [ordered]@{ id = "apps-acc-inventory-report-v1-0"; type = "text"; text = $projectText; x = 1200; y = 2230; width = 760; height = 220; color = "4" },
                    [ordered]@{ id = "out-acc-inventory"; type = "text"; text = $outputText; x = 2110; y = 2250; width = 540; height = 200; color = "4" }
                )) {
                    $result = Set-CanvasNode $nodes $definition ([string]$definition.id)
                    $nodes = $result.Nodes
                    $nodeActions.Add("$($result.Action) $($definition.id)") | Out-Null
                }
                foreach ($definition in @(
                    [ordered]@{ id = "e-acc-inv-1"; fromNode = "src-acc-inventory"; fromSide = "right"; toNode = "data-acc-inventory"; toSide = "left"; label = "potential source data" },
                    [ordered]@{ id = "e-acc-inv-2"; fromNode = "data-acc-inventory"; fromSide = "right"; toNode = "apps-acc-inventory-report-v1-0"; toSide = "left"; label = "validated and reconciled" },
                    [ordered]@{ id = "e-acc-inv-3"; fromNode = "apps-acc-inventory-report-v1-0"; fromSide = "right"; toNode = "out-acc-inventory"; toSide = "left"; label = "approved Accounting output" },
                    [ordered]@{ id = "e-acc-inv-pur-relationship"; fromNode = "apps-acc-inventory-report-v1-0"; fromSide = "top"; toNode = "apps-purchasing"; toSide = "bottom"; label = "reconciliation / approved-data relationship; does not replace" }
                )) {
                    $result = Set-CanvasEdge $edges $definition
                    $edges = $result.Edges
                    $edgeActions.Add("$($result.Action) $($definition.id)") | Out-Null
                }
            }
            elseif ($name -eq "PPJ_Roadmap_2026.canvas") {
                $weeklyGroup = @($nodes | Where-Object { $_.id -eq "road-WEEKLY-PRIORITY" })
                $backlogGroup = @($nodes | Where-Object { $_.id -eq "road-backlog-idea-20260703" })
                if ($weeklyGroup.Count -ne 1 -or $backlogGroup.Count -ne 1) { throw "Roadmap backlog or weekly-priority group is missing or duplicated." }
                if (Test-RectanglesOverlap $weeklyGroup[0] $backlogGroup[0]) {
                    Set-ObjectProperty $weeklyGroup[0] "x" 7200
                    $weeklyText = @($nodes | Where-Object { $_.id -eq "road-weekly-priority-text-20260629" })
                    if ($weeklyText.Count -eq 1) { Set-ObjectProperty $weeklyText[0] "x" 7230 }
                    $nodeActions.Add("MOVE weekly-priority group to remove pre-existing overlap") | Out-Null
                }
                $result = Set-CanvasNode $nodes ([ordered]@{ id = "road-acc-inventory-report-v1-0"; type = "file"; file = $ProjectRelativePath; x = 6330; y = 400; width = 330; height = 85; color = "6" }) "road-acc-inventory-report-v1-0" $ProjectRelativePath
                $nodes = $result.Nodes
                $nodeActions.Add("$($result.Action) backlog roadmap card") | Out-Null
                $milestones = "ACC.Inventory.Report.v1.0`nTimeline: TBD`n1. Resource Allocation`n2. Business Discovery Approval`n3. Source Inventory`n4. Rule Confirmation`n5. MVP Definition`n6. Future Development - Unscheduled"
                $result = Set-CanvasNode $nodes ([ordered]@{ id = "road-acc-inventory-milestones-v1-0"; type = "text"; text = $milestones; x = 6330; y = 520; width = 760; height = 200; color = "6" }) "road-acc-inventory-milestones-v1-0"
                $nodes = $result.Nodes
                $nodeActions.Add("$($result.Action) unscheduled milestone gates") | Out-Null
            }
            elseif ($name -eq "PPJ_Domain_Encapsulation.canvas") {
                $capability = @($nodes | Where-Object { $_.id -eq "domain-6-capability" })
                if ($capability.Count -ne 1) { throw "Finance / Accounting capability node is missing or duplicated." }
                Set-ObjectProperty $capability[0] "text" "Capability: Financial analysis, reporting, invoices, GRN and inventory control"
                $purCard = @($nodes | Where-Object { $_.id -eq "card-PUR-Inventory-Report-v1-0" })
                if ($purCard.Count -eq 1) {
                    Set-ObjectProperty $purCard[0] "text" "[[PUR.Inventory Report|PUR.Inventory.Report.v2.1]]`n`nPUR.Inventory.Report.v2.1`n`nDomain: Sourcing / Purchasing`nLifecycle: Production / Support`nProgress: v2.1 enhancement completed`nGate: Post-release Validation`nCapability: Operational visibility and purchasing decision support"
                }
                $cardText = "[[ACC.Inventory.Report.v1.0]]`n`nACC.Inventory.Report.v1.0`n`nDomain: Finance / Accounting`nLifecycle: Backlog / Pending Resource`nProgress: Not Started`nGate: Business Discovery Approval`nOutcome: Accounting-controlled inventory dataset, reconciliation report and exception list.`nSecondary: Warehouse, Purchasing, Data, Audit`nRelationship: Related to but separate from PUR.Inventory.Report.v2.1."
                $result = Set-CanvasNode $nodes ([ordered]@{ id = "card-ACC-Inventory-Report-v1-0"; type = "text"; text = $cardText; x = 6195; y = 2355; width = 760; height = 270; color = "4" }) "card-ACC-Inventory-Report-v1-0"
                $nodes = $result.Nodes
                $nodeActions.Add("$($result.Action) Finance/Accounting domain card") | Out-Null
            }

            Set-ObjectProperty $canvas "nodes" @($nodes)
            Set-ObjectProperty $canvas "edges" @($edges)
            $json = $canvas | ConvertTo-Json -Depth 100
            $preview = $json | ConvertFrom-Json

            foreach ($oldNode in $originalNodes) { if (@($preview.nodes | Where-Object { $_.id -eq $oldNode.id }).Count -ne 1) { throw "Unrelated/original Canvas node was deleted: $($oldNode.id)" } }
            foreach ($oldEdge in $originalEdges) { if (@($preview.edges | Where-Object { $_.id -eq $oldEdge.id }).Count -ne 1) { throw "Unrelated/original Canvas edge was deleted: $($oldEdge.id)" } }
            $duplicateIds = @($preview.nodes | Group-Object id | Where-Object { $_.Count -gt 1 })
            if ($duplicateIds.Count -gt 0) { throw "Duplicate Canvas node IDs in $name." }
            $duplicateFiles = @($preview.nodes | Where-Object { $_.type -eq "file" -and $_.file } | Group-Object file | Where-Object { $_.Count -gt 1 })
            if ($duplicateFiles.Count -gt 0) { throw ("Duplicate Canvas file cards in {0}: {1}" -f $name, ($duplicateFiles.Name -join ', ')) }
            foreach ($fileNode in @($preview.nodes | Where-Object { $_.type -eq "file" -and $_.file })) {
                $fileRelative = Resolve-CanvasPath $fileNode.file
                $filePath = Join-Path $VaultRoot ($fileRelative -replace "/", "\")
                $planned = $fileRelative -eq $ProjectRelativePath -or ($CreateTasks -and $fileRelative -eq $TaskRelativePath)
                if (-not (Test-Path -LiteralPath $filePath) -and -not $planned) { throw ("Canvas file node targets a missing file in {0}: {1}" -f $name, $fileRelative) }
            }

            if ($name -eq "PPJ_Portfolio.canvas" -or $name -eq "PPJ_Executive_Board.canvas" -or $name -eq "PPJ_Roadmap_2026.canvas") {
                $targetCards = @($preview.nodes | Where-Object { $_.type -eq "file" -and (Resolve-CanvasPath $_.file) -eq $ProjectRelativePath })
                if ($targetCards.Count -ne 1) { throw "$name must contain exactly one ACC.Inventory.Report.v1.0 file card." }
            }
            if ($name -eq "PPJ_Executive_Board.canvas") {
                $groups = @($preview.nodes | Where-Object { $_.type -eq "group" })
                $targetCard = @($preview.nodes | Where-Object { $_.id -eq "exec-acc-inventory-report-v1-0" })
                if ($targetCard.Count -ne 1 -or (Get-NodeGroupLabel $targetCard[0] $groups) -ne "PENDING") { throw "Executive Board card is not in PENDING." }
                if (@($preview.nodes | Where-Object { $_.id -eq "exec-candidates" -and $_.text -match 'ACC\.Inventory\.(Control\.)?Report|Accounting Inventory Report' }).Count -gt 0) { throw "Executive candidate text still describes the project as unregistered." }
            }
            if ($name -eq "PPJ_Roadmap_2026.canvas") {
                $weekly = @($preview.nodes | Where-Object { $_.id -eq "road-WEEKLY-PRIORITY" })
                $backlog = @($preview.nodes | Where-Object { $_.id -eq "road-backlog-idea-20260703" })
                if ($weekly.Count -ne 1 -or $backlog.Count -ne 1 -or (Test-RectanglesOverlap $weekly[0] $backlog[0])) { throw "Roadmap backlog and weekly-priority groups still overlap." }
                $targetCard = @($preview.nodes | Where-Object { $_.id -eq "road-acc-inventory-report-v1-0" })
                if ($targetCard.Count -ne 1 -or (Get-NodeGroupLabel $targetCard[0] @($backlog[0])) -ne "BACKLOG / IDEA / PARTNERSHIP") { throw "Roadmap project card is not in the backlog group." }
            }
            if ($name -eq "PPJ_Domain_Encapsulation.canvas") {
                $finance = @($preview.nodes | Where-Object { $_.type -eq "group" -and $_.label -eq "Finance / Accounting" })
                $sourcing = @($preview.nodes | Where-Object { $_.type -eq "group" -and $_.label -eq "Sourcing / Purchasing" })
                $targetCard = @($preview.nodes | Where-Object { $_.id -eq "card-ACC-Inventory-Report-v1-0" })
                if ($finance.Count -ne 1 -or $targetCard.Count -ne 1 -or (Get-NodeGroupLabel $targetCard[0] @($finance[0])) -ne "Finance / Accounting") { throw "Domain Encapsulation card is not in Finance / Accounting." }
                if ($sourcing.Count -eq 1 -and (Get-NodeGroupLabel $targetCard[0] @($sourcing[0])) -eq "Sourcing / Purchasing") { throw "Domain Encapsulation duplicates the Accounting project under Purchasing." }
            }
            if ($name -eq "PPJ_Data_Flow.canvas") {
                foreach ($id in @("src-acc-inventory", "data-acc-inventory", "apps-acc-inventory-report-v1-0", "out-acc-inventory")) { if (@($preview.nodes | Where-Object { $_.id -eq $id }).Count -ne 1) { throw "Data Flow node missing: $id" } }
                foreach ($id in @("e-acc-inv-1", "e-acc-inv-2", "e-acc-inv-3", "e-acc-inv-pur-relationship")) { if (@($preview.edges | Where-Object { $_.id -eq $id }).Count -ne 1) { throw "Data Flow edge missing: $id" } }
                if (@($preview.nodes | Where-Object { $_.id -eq "src-acc-inventory" -and $_.text -like '*Potential / Pending Data Discovery*' }).Count -ne 1) { throw "Data Flow sources are not marked potential." }
            }

            $canvasJsonMap[$canvasPath] = $json
            $canvasSummaries.Add([pscustomobject]@{
                Canvas = $relativePath
                BeforeNodes = $originalNodes.Count
                AfterNodes = @($preview.nodes).Count
                BeforeEdges = $originalEdges.Count
                AfterEdges = @($preview.edges).Count
                NodeActions = $nodeActions -join "; "
                EdgeActions = $edgeActions -join "; "
            }) | Out-Null
        }
    }
    catch {
        $hardStops.Add("Canvas preview failed: $($_.Exception.Message)")
    }
}

if ($writeMap.Contains($Paths.Project)) {
    $previewProject = [string]$writeMap[$Paths.Project]
    if (([regex]::Matches($previewProject, '<!-- PPJ_PROJECT_KNOWLEDGE_START -->')).Count -ne 1 -or ([regex]::Matches($previewProject, '<!-- PPJ_PROJECT_KNOWLEDGE_END -->')).Count -ne 1) { $hardStops.Add("Project note managed markers are invalid.") }
    if ($previewProject -cmatch '\bPROJECT_NAME\b|PASTE UPDATE HERE|INTAKE_FILE\.md') { $hardStops.Add("Forbidden placeholder found in project note preview.") }
    if ($previewProject -match '(?m)^lifecycle:\s*"?(Analysis|Development|UAT|Production)') { $hardStops.Add("Project lifecycle was incorrectly advanced.") }
    if ($previewProject -notmatch 'Business Owner: \*\*Needs Confirmation\*\*' -or $previewProject -notmatch 'Rule Status: \*\*Draft / Pending Accounting Approval\*\*') { $hardStops.Add("Owner or draft-rule safeguards are missing from the project note.") }
}
if ($writeMap.Contains($Paths.Memory) -and ([regex]::Split([string]$writeMap[$Paths.Memory], "\r?\n")).Count -gt 120) { $hardStops.Add("Memory card exceeds 120 lines.") }

Write-Host "ACC Inventory Report Registration and Canvas Synchronization"
Write-Host "Mode: $(if ($Apply) { 'APPLY' } else { 'DRYRUN' })"
Write-Host "Canonical Code: $CanonicalCode"
Write-Host "Physical File: $ProjectRelativePath"
Write-Host "Lifecycle: Backlog / Pending Resource"
Write-Host "Progress: Not Started"
Write-Host "Gate: Business Discovery Approval"
Write-Host "Source Event: $SourceEventId"
Write-Host "Existing project note: $projectWasPresent"
Write-Host "Existing memory card: $memoryWasPresent"
Write-Host "Existing proposal: $proposalWasPresent"
Write-Host "Existing task file: $taskWasPresent"
Write-Host "Existing decision file: $decisionWasPresent"
Write-Host "Active root matches: $($activeRootMatches.Count)"
Write-Host "Duplicate proposal findings: $($proposalMatches.Count)"
Write-Host "PUR.Inventory.Report.v2.1 remains separate: $(Test-Path -LiteralPath $Paths.PurchasingProject)"
Write-Host "Registration plan: Approved / Registered; Backlog / Pending Resource; no Analysis start"
Write-Host "Memory plan: compact card with source event and protected boundary"
Write-Host "Registry plan: memory index, registry, naming dictionary, alias map and module index"
Write-Host "Domain plan: domain model and domain assignment matrix under Finance / Accounting"
Write-Host "Resource plan: all delivery roles remain Needs Confirmation"
Write-Host "Ledger plan: one idempotent project_registration event"
Write-Host "Command Center plan: compact Registered Backlog entry"
Write-Host "Task plan: $(if ($CreateTasks) { 'one backlog Business Discovery preparation task' } else { 'not requested' })"
Write-Host "Decision plan: $(if ($CreateDecisionLog) { 'update existing ACC-INV decision; no duplicate' } else { 'not requested' })"
Write-Host "Files planned: $($writeMap.Count) Markdown/source files"
foreach ($action in $actions) { Write-Host ("[{0}] {1} - {2}" -f $action.Status, $action.Path, $action.Description) }
Write-Host "Canvas files planned: $($canvasJsonMap.Count)"
foreach ($summary in $canvasSummaries) {
    Write-Host ("[CANVAS] {0} | nodes {1}->{2} | edges {3}->{4}" -f $summary.Canvas, $summary.BeforeNodes, $summary.AfterNodes, $summary.BeforeEdges, $summary.AfterEdges)
    Write-Host ("  Nodes: {0}" -f $summary.NodeActions)
    if ($summary.EdgeActions) { Write-Host ("  Edges: {0}" -f $summary.EdgeActions) }
}
Write-Host "Canvas placement: Portfolio Finance group; Executive PENDING; Data Flow pending-discovery chain; Roadmap Backlog/TBD; Domain Finance / Accounting"
Write-Host "Markdown backup plan: $MarkdownBackupRoot"
Write-Host "Canvas backup plan: $CanvasBackupRoot"
Write-Host "Operation log plan: $OperationLogRelativePath"
Write-Host "Final report plan: $ReportRelativePath"
Write-Host "Warnings: $($warnings.Count)"
foreach ($warning in $warnings) { Write-Host "- $warning" }
Write-Host "Hard stops: $($hardStops.Count)"
foreach ($hardStop in $hardStops) { Write-Host "- $hardStop" }

if ($hardStops.Count -gt 0) { exit 2 }
if ($DryRun) { Write-Host "DryRun PASS. No files modified."; exit 0 }

New-Item -ItemType Directory -Path $MarkdownBackupRoot -Force | Out-Null
if ($UpdateCanvases) { New-Item -ItemType Directory -Path $CanvasBackupRoot -Force | Out-Null }
foreach ($path in $writeMap.Keys) { Backup-MarkdownFile $path }
Backup-MarkdownFile $Paths.Report

if ($UpdateCanvases) {
    foreach ($canvasPath in $canvasJsonMap.Keys) {
        $destination = Join-Path $CanvasBackupRoot (Split-Path -Leaf $canvasPath)
        Copy-Item -LiteralPath $canvasPath -Destination $destination -Force
        if (-not (Test-Path -LiteralPath $destination)) { throw "Canvas backup failed: $(Get-RelativePath $canvasPath)" }
    }
}

foreach ($path in $writeMap.Keys) { Write-Utf8 $path ([string]$writeMap[$path]) }
foreach ($canvasPath in $canvasJsonMap.Keys) {
    Write-Utf8 $canvasPath ([string]$canvasJsonMap[$canvasPath])
    Read-Utf8 $canvasPath | ConvertFrom-Json | Out-Null
}

if (-not (Test-Path -LiteralPath $Paths.Project)) { throw "Project note was not created." }
if (-not (Test-Path -LiteralPath $Paths.Memory)) { throw "Memory card was not created." }
if ($purHashBefore -and (Get-FileHash -LiteralPath $Paths.PurchasingProject -Algorithm SHA256).Hash -ne $purHashBefore) { throw "PUR.Inventory.Report project note changed unexpectedly." }

$postValidation = New-Object System.Collections.Generic.List[string]
foreach ($path in @($Paths.Project, $Paths.Memory, $Paths.MemoryIndex, $Paths.Registry, $Paths.DomainMatrix, $Paths.NamingDictionary, $Paths.AliasMap, $Paths.ResourceMatrix, $Paths.Ledger)) {
    if ((Read-Utf8 $path) -notlike "*$CanonicalCode*") { $postValidation.Add("Canonical code missing after Apply: $(Get-RelativePath $path)") | Out-Null }
}
if ((Read-Utf8 $Paths.Project) -notlike "*$SourceEventId*" -or (Read-Utf8 $Paths.Memory) -notlike "*$SourceEventId*" -or (Read-Utf8 $Paths.Ledger) -notlike "*$SourceEventId*") { $postValidation.Add("Source event is missing from required project sources.") | Out-Null }
if ((Read-Utf8 $Paths.DomainMatrix) -notmatch '(?m)^\| ACC\.Inventory\.Report\.v1\.0 .*\| Finance / Accounting \|' -or (Read-Utf8 $Paths.DomainMatrix) -notmatch '(?m)^\| PUR\.Inventory\.Report\.v2\.1 .*\| Sourcing / Purchasing \|') { $postValidation.Add("ACC/PUR domain separation validation failed.") | Out-Null }
if ($postValidation.Count -gt 0) { throw ($postValidation -join " ") }

$canvasReportLines = @()
foreach ($summary in $canvasSummaries) { $canvasReportLines += "- $($summary.Canvas): nodes $($summary.BeforeNodes) -> $($summary.AfterNodes); edges $($summary.BeforeEdges) -> $($summary.AfterEdges); $($summary.NodeActions); $($summary.EdgeActions)" }
$remainingUnknowns = @(
    "Named Accounting Business Owner",
    "BA, Data and Technical resources",
    "Approved source system and read-access method",
    "Report format and refresh schedule",
    "Valuation method and period/cut-off rules",
    "MVP company, warehouse, period and material category",
    "Approved acceptance criteria and shared-data design with PUR.Inventory.Report.v2.1"
)

$reportContent = @"
# ACC Inventory Report Registration and Canvas Update Report

## Executive Summary

`ACC.Inventory.Report.v1.0` was officially registered on 2026-08-02 as a Finance / Accounting project. It remains Backlog / Pending Resource, progress is Not Started, and the next gate is Business Discovery Approval.

## Canonical Registration

- Canonical Code: `ACC.Inventory.Report.v1.0`
- Project Name: Accounting Inventory Report
- Physical File: `ACC.Inventory.Report.v1.0.md`
- Registration Status: Approved / Registered
- Source Event: $SourceEventId

## Project Note Created or Updated

- Status: $(if ($projectWasPresent) { 'Updated' } else { 'Created' })
- Managed markers validated: PASS

## Memory Card Created or Updated

- Status: $(if ($memoryWasPresent) { 'Updated' } else { 'Created' })
- Compact line limit: PASS

## Registry Updates

Memory Index, Project Registry, Canonical Naming Dictionary, Alias Map and Module Index were synchronized without rewriting unrelated rows.

## Candidate Proposal Resolution

The existing candidate history was preserved and updated to Approved / Registered with approval date 2026-08-02 and link to [[ACC.Inventory.Report.v1.0]].

## Domain Assignment

Primary Domain is Finance / Accounting. Warehouse, Purchasing, Data and Audit remain secondary domains only.

## Resource Matrix

Business Owner, BA, Data and Technical assignments remain Needs Confirmation. Resource Status is Pending Resource.

## Ledger Event

One idempotent project_registration event was appended for $SourceEventId.

## Command Center

A compact Registered Backlog entry was added. No priority number or delivery commitment was invented.

## Canvas Updates

$($canvasReportLines -join "`r`n")

## Canvas JSON Validation

All five modified Canvas files parsed successfully with `ConvertFrom-Json`. Original nodes and edges were preserved, target-card duplicates were rejected, and file-node targets were validated.

## Relationship with PUR.Inventory.Report.v2.1

`ACC.Inventory.Report.v1.0` is an Accounting control project for quantity, value, period and reconciliation. `PUR.Inventory.Report.v2.1` remains the separate Purchasing operational-visibility project. The Purchasing project note was not modified.

## Protected-Scope Validation

- Lifecycle remains Backlog / Pending Resource.
- Progress remains Not Started.
- Business Discovery is not marked started.
- No named owner or delivery resource was invented.
- Sources and valuation methods remain unconfirmed.
- Draft rules remain Draft / Pending Accounting Approval.

## Remaining Unknowns

$($remainingUnknowns | ForEach-Object { "- $_" } | Out-String)
## Next Gate

Assign resources and approve Business Discovery.

## Remaining Warnings

- Historical reports retain candidate wording as historical evidence.
- Older weekly Canvas scripts contain stale candidate text and should not be rerun without review.
"@
Write-Utf8 $Paths.Report $reportContent

$logContent = @"
# ACC Inventory Report Registration Operation Log

- Timestamp: $Stamp
- Date: 2026-08-02
- Source Event: $SourceEventId
- Mode: Apply
- Force: $Force
- Canonical Code: $CanonicalCode
- Lifecycle: Backlog / Pending Resource
- Progress: Not Started
- Markdown Backup: $(Get-RelativePath $MarkdownBackupRoot)
- Canvas Backup: $(Get-RelativePath $CanvasBackupRoot)

## Results

$($actions | ForEach-Object { "- [$($_.Status)] $($_.Path) - $($_.Description)" } | Out-String)
## Canvas Results

$($canvasReportLines -join "`r`n")

## Validation

- Hard Stops: 0
- Project Note: PASS
- Memory Card: PASS
- Registry and Domain Separation: PASS
- PUR Project Note Unchanged: PASS
- Canvas JSON: PASS
- Duplicate Project Cards: PASS
"@
Write-Utf8 $Paths.OperationLog $logContent

Write-Host "Apply completed."
Write-Host "Project note: $ProjectRelativePath"
Write-Host "Memory card: $MemoryRelativePath"
Write-Host "Registration status: Approved / Registered"
Write-Host "Candidate proposal: Resolved with history preserved"
Write-Host "Task: $(if ($CreateTasks) { $TaskRelativePath } else { 'Not requested' })"
Write-Host "Decision: $(if ($CreateDecisionLog) { $DecisionRelativePath } else { 'Not requested' })"
Write-Host "Markdown backup: $MarkdownBackupRoot"
Write-Host "Canvas backup: $CanvasBackupRoot"
Write-Host "Operation log: $OperationLogRelativePath"
Write-Host "Final report: $ReportRelativePath"
Write-Host "Canvas JSON validation: PASS"
Write-Host "Duplicate-card validation: PASS"
Write-Host "PUR separation validation: PASS"
