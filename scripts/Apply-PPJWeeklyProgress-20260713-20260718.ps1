param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [switch]$UpdateMemory,
    [switch]$UpdateProjectNotes,
    [switch]$UpdateRegistry,
    [switch]$UpdateResourceMatrix,
    [switch]$UpdateLedger,
    [switch]$CreateTasks,
    [switch]$CreateDecisions,
    [switch]$CreateWeeklyReport,
    [switch]$UpdateDomainCanvas
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if ($DryRun -and $Apply) { throw "Use only one mode: -DryRun or -Apply." }
if (-not $Apply) { $DryRun = $true }

$VaultRoot = (Get-Location).ProviderPath
$SourceEventId = "PPJ-WEEKLY-20260713-20260718"
$ReportingPeriod = "2026-07-13 to 2026-07-18"
$PlanningPeriod = "2026-07-20 to 2026-07-25"
$UpdateDate = "2026-07-18"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupRoot = Join-Path $VaultRoot "99_Attachments/Audit/Weekly_Progress_20260713_20260718_Backup/$Stamp"
$OperationLogPath = Join-Path $VaultRoot "99_Attachments/Audit/PPJ_WEEKLY_PROGRESS_20260713_20260718_LOG_$Stamp.md"
$WeeklyReportPath = Join-Path $VaultRoot "10_Reports/PPJ_WEEKLY_PORTFOLIO_UPDATE_20260713_20260718.md"
$ApplyReportPath = Join-Path $VaultRoot "10_Reports/PPJ_WEEKLY_PORTFOLIO_UPDATE_APPLY_REPORT_20260718.md"
$MemoryIndexPath = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md"
$RegistryPath = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md"
$ResourceMatrixPath = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md"
$LedgerPath = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md"
$TaskDir = Join-Path $VaultRoot "03_Projects/_Tasks"
$DecisionDir = Join-Path $VaultRoot "07_Decision_Log"
$DecisionIndexPath = Join-Path $DecisionDir "Decision_Log.md"
$KnowledgeStart = "<!-- PPJ_PROJECT_KNOWLEDGE_START -->"
$KnowledgeEnd = "<!-- PPJ_PROJECT_KNOWLEDGE_END -->"
$Evidence = "User-approved weekly portfolio report 2026-07-13 to 2026-07-18"

function New-WeeklyUpdate {
    param(
        [string]$Project,[string]$CurrentFile,[string]$MemoryFile,[string]$PrimaryDomain,
        [string]$Lifecycle,[string]$Progress,[string]$CurrentGate,[string]$PriorityNextWeek,
        [string]$Goal,[string]$PrimaryOutput,[string]$LatestUpdateSummary,
        [string[]]$Risks,[string[]]$DecisionsNeeded,[string[]]$NextActions,
        [string]$RequiredOutput,[string]$Ownership,[string]$SecondaryWorkstreamGate = "",
        [string]$ProposedCanonicalCode = "",[string]$VersionMigrationStatus = ""
    )
    [pscustomobject]@{
        Project=$Project; SourceEventId=$SourceEventId; UpdateDate=$UpdateDate; CurrentFile=$CurrentFile; MemoryFile=$MemoryFile
        PrimaryDomain=$PrimaryDomain; Lifecycle=$Lifecycle; Progress=$Progress; CurrentGate=$CurrentGate
        SecondaryWorkstreamGate=$SecondaryWorkstreamGate; PriorityNextWeek=$PriorityNextWeek; Goal=$Goal
        PrimaryOutput=$PrimaryOutput; LatestUpdateSummary=$LatestUpdateSummary; Risks=$Risks
        DecisionsNeeded=$DecisionsNeeded; NextActions=$NextActions; Tasks=@(); Evidence=$Evidence
        Confidence="Strong"; RequiredOutput=$RequiredOutput; Ownership=$Ownership
        ProposedCanonicalCode=$ProposedCanonicalCode; VersionMigrationStatus=$VersionMigrationStatus
    }
}

$WeeklyProjectUpdates = @(
    New-WeeklyUpdate "FIN.AI.FINANCE.MANAGEMENT.v1.1" "03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1.md" "03_Projects/_Registry/Project_Memory/FIN.AI.FINANCE.MANAGEMENT.v1.1.memory.md" "Finance / Accounting" "Analysis / Design" "TBD" "Discovery / Control Design / Business Rule Definition" "P1" `
        "Build a centralized financial control and analysis platform helping Accounting verify completeness, reconcile planned and actual OC costs, manage exceptions, automatically recheck corrections, and provide trusted data to Power BI and AI assistance." `
        "OC Cost Reconciliation and Exception Management Tool" `
        "After the 2026-07-17 discussion, the project was repositioned from a standalone chatbot/reporting initiative into a centralized financial-control platform. The operating sequence is Data Control -> Exception Handling -> Trusted Data Confirmation -> Reporting -> Analysis -> AI-assisted Q&A. MVP covers materials and trims, subcontracting, basic overhead, correct OC/period posting, missing cost detection, exception assignment, automatic recheck, and evidence traceability." `
        @("Official Costing source and version-selection logic are not confirmed.","Material variance threshold and correct-period rule are not confirmed.","Responsible owner is incomplete for several exception types.") `
        @("Approve or defer canonical migration to FIN.AI.FINANCE.MANAGEMENT.v1.2.","Confirm official Costing source and version-selection rule.","Confirm exception ownership and financial-control thresholds.") `
        @("Collect 20-30 sample OCs and approved Costing plans.","Collect BOM, standard consumption, material issue/return, PO, receipt, invoice and accounting posting evidence.","Build standard cost and exception catalogues with responsible owners.","Define thresholds and design the exception-list assignment flow.") `
        "OC sample set, exception catalogue and control-process specification." "Accounting; exact control owners Needs Confirmation" "" "FIN.AI.FINANCE.MANAGEMENT.v1.2" "Pending Confirmation"

    New-WeeklyUpdate "COSTING.AGENTIC.PLATFORM.v1.1" "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1.md" "03_Projects/_Registry/Project_Memory/COSTING.AGENTIC.PLATFORM.v1.1.memory.md" "Merchandising" "Development" "TBD" "Sew Prototype / Demo Preparation" "P2 (Sew); P9 (Wash workstream)" `
        "Support Merchandising in creating costing faster for review and customer quotation proposals across Sew, BOM, Wash, Fabric Consumption, Historical Costing and Cost Consolidation workstreams." `
        "Sew extraction prototype and Wash MVP data/input-output definition" `
        "Sew prototype validated the flow Sewing Description -> Description Analysis -> Sewing Operation Extraction -> Standardized Operation List -> Expert Review. Extraction is not validated SMV, CM, final Sew Cost, or production-ready costing. Wash remains a workstream under this project: free-text input must be structured into attributes, missing-information checks, similar recipe retrieval, draft process recommendation, and mandatory Wash expert review." `
        @("Sew descriptions may lack technical detail.","Buyer formats are not standardized across more than 150 buyers.","Wash recipes are high-risk references and cannot be automatically applied.","Expert recommendation and final approved costing must remain separate.") `
        @("Approve Sew extraction acceptance criteria.","Confirm Wash MVP input/output and Wash data owner.","Confirm GTAS/IED Wash integration boundary and expert-approval boundary.") `
        @("Run Sew demo and expert validation; classify correct, missing, excessive and incorrectly ordered operations.","Establish extraction accuracy baseline, then map operation to machine type and standard time.","Collect 20-30 Wash requests with recipes/processes and build Wash Type Taxonomy.","Confirm Wash outputs, recipe storage, GTAS/IED boundary and expert approval; build similarity-search prototype.") `
        "Sew extraction demo and expert-validation result; Wash dataset request and MVP input/output confirmation." "MER / Sew experts / Wash data owner Needs Confirmation" "Wash Discovery / Dataset Preparation"

    New-WeeklyUpdate "PUR.Material.Allocation.v1.1" "03_Projects/PUR.Material.Allocation.v1.1.md" "03_Projects/_Registry/Project_Memory/PUR.Material.Allocation.v1.1.memory.md" "Sourcing / Purchasing" "UAT / Stabilization" "TBD" "First Flow Validated / Extended Exception Testing" "P5" `
        "Automate reallocation of surplus Sewing and Embroidery materials/trims between split OCs while reducing manual WFX operations and allocation errors." `
        "Validated unreserve, destination-OC matching and allocation flow with controlled UAT foundation" `
        "The first business flow was successfully tested: Source OC with Surplus -> Validate Surplus -> Unreserve -> Find Destination OC -> Validate Style and Buyer Reference -> Allocate -> Verify Result. Destination OCs are split OCs with the same Style and Buyer Reference." `
        @("Only Sewing and Embroidery scope is confirmed.","Quantity may change during transaction execution.","Rollback is undefined when unreserve succeeds but allocation fails.") `
        @("Confirm transaction rollback design.","Confirm auditability and user confirmation before posting.","Confirm whether additional material categories enter scope.") `
        @("Test many-to-one, one-to-many, partial allocation, insufficient quantity, Buyer Reference mismatch and duplicate allocation.","Test transaction failure/retry and define rollback.","Define audit log and user review before posting.","Prepare UAT with Ms. Tuyet and Precision users.") `
        "Exception-case testing and UAT plan." "UAT: Ms. Tuyet and Precision users"

    New-WeeklyUpdate "PPJ.ExpenseInvoices.v1.1" "03_Projects/PPJ. Expense-Invoices.v1.1.md" "03_Projects/_Registry/Project_Memory/PPJ.ExpenseInvoices.v1.1.memory.md" "Finance / Accounting" "UAT / Stabilization" "TBD" "Pre-go-live / Mapping Validation / User Testing" "P3" `
        "Deploy expense-invoice processing for departments and factories, excluding Export in the current rollout." `
        "Approved mapping table, validated upload, defect closure, pre-go-live checklist and user support guide" `
        "The business period was confirmed; departments/factories began submitting mapping files and testing real data. Mappings continued changing, users received upload/operating support, and defects found with real data were fixed during pre-go-live. Current active scope is departments and factories, with Export excluded. Older EXIM-first wording remains historical only." `
        @("Mapping changes close to go-live.","Inconsistent user templates and incomplete unit inputs.","Real-data defects may appear late.","Go-live may occur before Accounting approval.") `
        @("Approve mapping cut-off and go-live readiness.","Confirm Accounting acceptance owner.","Confirm production-support ownership and escalation flow.") `
        @("Follow units missing mappings and validate mapping completeness.","Check duplicate invoices, company/factory/department and ledger/account mapping.","Resolve upload failures, fix and retest.","Confirm mapping cut-off, go-live date, acceptance owner and support escalation.") `
        "Completed mapping, defect closure and go-live readiness decision." "Accounting; acceptance owner Needs Confirmation"

    New-WeeklyUpdate "SCP.SOURCING.CHATBOT.v2.3" "03_Projects/SCP.SOURCING.CHATBOT.v2.3.md" "03_Projects/_Registry/Project_Memory/SCP.SOURCING.CHATBOT.v2.3.memory.md" "Sourcing / Purchasing" "UAT / Stabilization" "TBD" "Guided UAT / User Adoption" "P7" `
        "Help Sourcing users search supplier, fabric, trims, material and sample data." `
        "Post-training usage assessment and prioritized feedback backlog" `
        "The third user-training session was completed for Ms. Lam and Ms. Minh Anh, covering login, permissions, question formulation, data search, result validation, and feedback/defect reporting. Real use cases and adoption support continue." `
        @("Low usage may reflect weak habit, incomplete data, poor search quality, complex permissions or insufficient business value.") `
        @("Confirm UAT acceptance owner.","Define adoption KPI and minimum successful-use threshold.") `
        @("Monitor usage and collect actual questions from Ms. Lam and Ms. Minh Anh.","Measure search success rate.","Classify data, search, permission, answer-quality and training feedback.","Fix/retest and prepare quick user guide.") `
        "Post-training usage assessment and prioritized feedback." "Training users: Ms. Lam and Ms. Minh Anh; UAT owner Needs Confirmation"

    New-WeeklyUpdate "HR.SSPFD.Workflow.v1.1" "03_Projects/HR.SS&PFD.v1.1.md" "03_Projects/_Registry/Project_Memory/HR.SSPFD.Workflow.v1.1.memory.md" "HR" "On Hold / Pending Decision" "TBD" "Transfer Preparation / Pending Handover" "P6" `
        "Analyze and audit HR, payroll and BHXH workflows, with the original MVP focused on GREA BHXH data." `
        "Complete Software Team handover package with scope, data, rules, workflow, roles and security requirements" `
        "Stakeholders agreed the solution is more appropriate for transfer to the Software Team because it behaves as a business application, workflow management, data-processing software, rule-based validation and user-facing system rather than an AI-led initiative. The project is pending handover and is not completed or closed." `
        @("Software Team owner and remaining AI Team responsibility are not confirmed.","HR data is highly sensitive.","Verbal-only handover and missing formal acceptance are insufficient.") `
        @("Assign Software Team owner.","Confirm AI Team support boundary.","Approve handover package and acceptance criteria.") `
        @("Prepare business context, problem, MVP scope, data sources and field inventory.","Document audit rules, current process, target workflow and user roles.","Document security requirements, open questions, samples and meeting notes.","Secure formal owner assignment and handover acceptance.") `
        "Software Team handover package." "Software Team; exact owner TBD"

    New-WeeklyUpdate "FD.Datamart.v2.2" "03_Projects/FD.Datamart.v2.2.md" "03_Projects/_Registry/Project_Memory/FD.Datamart.v2.2.memory.md" "Fabric / Textiles Technique" "Maintenance" "100% of current implementation scope" "Production Support" "P8" `
        "Manage Fabric, Hanger and QR information in Directus for search, sample management and FD operations." `
        "Support ownership and classified maintenance backlog" `
        "The current implementation scope is complete and the project moved from active delivery into support after training and handover. Defects, data corrections, QR/Hanger configuration, permissions and minor enhancements enter a support backlog; new functions or major process changes require enhancement approval or a new version/project." `
        @("Formal support owner, SLA and enhancement approval process are not confirmed.") `
        @("Confirm formal support ownership.","Confirm enhancement approval process.") `
        @("Confirm support owner and SLA.","Create/update maintenance backlog.","Classify open requests as defect, data correction, configuration or enhancement.") `
        "Support ownership and maintenance backlog." "FD support owner Needs Confirmation"

    New-WeeklyUpdate "PPJxQSee.AI" "03_Projects/PPJxQSee.ai.md" "03_Projects/_Registry/Project_Memory/PPJxQSee.AI.memory.md" "QC / TQM" "PoC / Sample Data Preparation" "TBD" "Formal Proposal Evaluation" "P4" `
        "Evaluate QSee collaboration for QC AI Vision, defect detection, visual inspection, real-time quality data, customer transparency and potential reduction of third-party inspection." `
        "QSee Collaboration Evaluation and Recommendation" `
        "QSee submitted a formal proposal, PPJ QC received it, and Ms. Tien requested detailed evaluation by the AI & Automation Team. This stage is proposal evaluation, not implementation approval." `
        @("Proposal may be broader than PPJ need and PoC KPI is unclear.","Dataset may be insufficient and vendor data-use rights may be unacceptable.","Customer-facing sharing lacks governance; post-PoC cost and factory stability are unclear.") `
        @("Approve evaluation criteria and confirm pilot scope.","Confirm data ownership terms.","Approve, condition, revise, hold or reject collaboration after evaluation.") `
        @("Evaluate business fit, scope, feasibility, accuracy, security, commercial model and operational readiness.","Extract commitments, assumptions and exclusions; confirm JC/official pilot scope.","Define dataset, top defects, ground truth and PoC success criteria with QC.","Clarify data ownership and commercial terms; issue recommendation.") `
        "Proposal evaluation and collaboration recommendation." "Evaluation request: Ms. Tien / QC"
)

$TaskGroups = @(
    [pscustomobject]@{ Slug="finance-oc-control"; Project="FIN.AI.FINANCE.MANAGEMENT.v1.1"; Title="Finance OC Control Dataset and Exception Catalogue"; Outcome="OC sample set, exception catalogue and control-process specification"; Priority="P1" }
    [pscustomobject]@{ Slug="costing-sew-demo"; Project="COSTING.AGENTIC.PLATFORM.v1.1"; Title="Costing Sew Demo and Expert Validation"; Outcome="Sew extraction demo and expert-validation result"; Priority="P2" }
    [pscustomobject]@{ Slug="costing-wash-mvp"; Project="COSTING.AGENTIC.PLATFORM.v1.1"; Title="Costing Wash Dataset and MVP Definition"; Outcome="Wash dataset request and MVP input/output confirmation"; Priority="P9 workstream" }
    [pscustomobject]@{ Slug="material-allocation-exceptions"; Project="PUR.Material.Allocation.v1.1"; Title="Material Allocation Exception Testing and Transaction Safety"; Outcome="Exception-case testing and UAT plan"; Priority="P5" }
    [pscustomobject]@{ Slug="expense-go-live"; Project="PPJ.ExpenseInvoices.v1.1"; Title="Expense Invoice Mapping Closure and Go-live Readiness"; Outcome="Mapping closure, defect closure and go-live decision"; Priority="P3" }
    [pscustomobject]@{ Slug="sourcing-adoption"; Project="SCP.SOURCING.CHATBOT.v2.3"; Title="Sourcing Post-training Usage Assessment"; Outcome="Usage assessment and prioritized feedback"; Priority="P7" }
    [pscustomobject]@{ Slug="hr-handover"; Project="HR.SSPFD.Workflow.v1.1"; Title="HR Software Handover Package"; Outcome="Formal Software Team handover package"; Priority="P6" }
    [pscustomobject]@{ Slug="fd-maintenance"; Project="FD.Datamart.v2.2"; Title="FD Support Ownership and Maintenance Backlog"; Outcome="Support owner, SLA and classified backlog"; Priority="P8" }
    [pscustomobject]@{ Slug="qsee-evaluation"; Project="PPJxQSee.AI"; Title="QSee Proposal Evaluation and Recommendation"; Outcome="Formal collaboration recommendation"; Priority="P4" }
)

$DecisionGroups = @(
    [pscustomobject]@{ Id="DEC-WEEKLY-20260718-FIN-V12"; Project="FIN.AI.FINANCE.MANAGEMENT.v1.1"; Title="Finance v1.2 canonical migration and control scope"; Owner="Accounting / Portfolio Governance" }
    [pscustomobject]@{ Id="DEC-WEEKLY-20260718-EXP-GOLIVE"; Project="PPJ.ExpenseInvoices.v1.1"; Title="Expense Invoice go-live approval"; Owner="Accounting" }
    [pscustomobject]@{ Id="DEC-WEEKLY-20260718-MAT-ROLLBACK"; Project="PUR.Material.Allocation.v1.1"; Title="Material Allocation rollback and audit model"; Owner="Purchasing / WFX Owner" }
    [pscustomobject]@{ Id="DEC-WEEKLY-20260718-HR-HANDOVER"; Project="HR.SSPFD.Workflow.v1.1"; Title="HR handover ownership and acceptance"; Owner="HR / Software Team" }
    [pscustomobject]@{ Id="DEC-WEEKLY-20260718-QSEE"; Project="PPJxQSee.AI"; Title="QSee collaboration recommendation"; Owner="QC / Ms. Tien" }
    [pscustomobject]@{ Id="DEC-WEEKLY-20260718-WASH-MVP"; Project="COSTING.AGENTIC.PLATFORM.v1.1"; Title="Costing Wash MVP and expert-approval boundary"; Owner="MER / Wash Owner" }
)

function Get-Path([string]$Rel) { Join-Path $VaultRoot ($Rel -replace "/","\") }
function Get-Utf8([string]$Path) { if (Test-Path -LiteralPath $Path) { Get-Content -LiteralPath $Path -Raw -Encoding UTF8 } else { "" } }
function Set-Utf8([string]$Path,[string]$Content) { $d=Split-Path $Path -Parent; if(-not(Test-Path $d)){New-Item -ItemType Directory -Path $d -Force|Out-Null}; Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8 }
function Quote-Yaml([string]$Value) { '"' + (($Value -replace '"','\"') -replace "`r?`n",' ') + '"' }
function Join-Items([string[]]$Items) { ($Items | ForEach-Object { $_.Trim() } | Where-Object { $_ }) -join " | " }
function Escape-Cell([string]$Value) { if($null -eq $Value){return ""}; ($Value -replace '\|','/' -replace "`r?`n",' ').Trim() }

function Set-YamlScalar([string]$Yaml,[string]$Key,[string]$RawValue) {
    $pattern = "(?m)^" + [regex]::Escape($Key) + "\s*:.*$"
    $line = "${Key}: $RawValue"
    if($Yaml -match $pattern){ return [regex]::Replace($Yaml,$pattern,$line) }
    return $Yaml.TrimEnd()+"`r`n"+$line
}

function Backup-File([string]$Path) {
    if(-not(Test-Path -LiteralPath $Path)){return}
    if(-not(Test-Path -LiteralPath $BackupRoot)){New-Item -ItemType Directory -Path $BackupRoot -Force|Out-Null}
    $rel=(Resolve-Path $Path).ProviderPath.Substring($VaultRoot.Length).TrimStart('\')
    $dest=Join-Path $BackupRoot (($rel -replace '[:\\/]','_')+'.bak')
    Copy-Item -LiteralPath $Path -Destination $dest -Force
}

function Write-Changed([string]$Path,[string]$Content,[string]$Reason) {
    $old=Get-Utf8 $Path
    if($old -eq $Content){return [pscustomobject]@{File=$Path;Result="UNCHANGED";Reason=$Reason}}
    if($DryRun){return [pscustomobject]@{File=$Path;Result="WOULD_UPDATE";Reason=$Reason}}
    Backup-File $Path
    Set-Utf8 $Path $Content
    [pscustomobject]@{File=$Path;Result="UPDATED";Reason=$Reason}
}

function Split-Row([string]$Line){
    $t=$Line.Trim(); if($t.StartsWith('|')){$t=$t.Substring(1)}; if($t.EndsWith('|')){$t=$t.Substring(0,$t.Length-1)}
    @($t -split '\|',-1)
}
function Join-Row([string[]]$Cells){ '| '+(($Cells|ForEach-Object{$_.Trim()}) -join ' | ')+' |' }

function Test-HardStops {
    $hard=New-Object System.Collections.Generic.List[string]
    if($UpdateDomainCanvas){$hard.Add("Canvas update is prohibited in this first Apply workflow.")}
    foreach($u in $WeeklyProjectUpdates){
        $note=Get-Path $u.CurrentFile; $memory=Get-Path $u.MemoryFile
        if(-not(Test-Path -LiteralPath $note)){$hard.Add("Missing root note: $($u.CurrentFile)")}
        if(-not(Test-Path -LiteralPath $memory)){$hard.Add("Missing memory card: $($u.MemoryFile)")}
        if(Test-Path $note){
            $c=Get-Utf8 $note
            if(([regex]::Matches($c,[regex]::Escape($KnowledgeStart))).Count -ne 1 -or ([regex]::Matches($c,[regex]::Escape($KnowledgeEnd))).Count -ne 1){$hard.Add("Managed knowledge block cannot be parsed safely: $($u.CurrentFile)")}
            if($c -match '(?mi)^project_name\s*:\s*["'']?PROJECT_NAME["'']?\s*$|generated project knowledge content'){$hard.Add("Placeholder/generic content found: $($u.CurrentFile)")}
        }
        if($u.Lifecycle -match '^\s*\d+%\s*$'){$hard.Add("Lifecycle is percentage for $($u.Project)")}
    }
    if(($WeeklyProjectUpdates|Where-Object{$_.Project -eq 'HR.SSPFD.Workflow.v1.1'}).Lifecycle -match 'Closed|Completed'){$hard.Add("HR cannot be marked completed.")}
    if(($WeeklyProjectUpdates|Where-Object{$_.Project -eq 'FD.Datamart.v2.2'}).Lifecycle -ne 'Maintenance'){$hard.Add("FD must be Maintenance.")}
    if(($WeeklyProjectUpdates|Where-Object{$_.Project -eq 'PPJxQSee.AI'}).CurrentGate -match 'Approved|Implementation'){$hard.Add("QSee cannot be marked approved/implemented.")}
    $expense=$WeeklyProjectUpdates|Where-Object{$_.Project -eq 'PPJ.ExpenseInvoices.v1.1'}
    if($expense.LatestUpdateSummary -notmatch 'Export excluded'){$hard.Add("Expense Invoice scope correction is missing Export exclusion.")}
    # Existing source events are skipped by individual upsert functions unless -Force is used.
    # This permits safe recovery from an interrupted Apply without duplicating records.
    if(Test-Path (Get-Path '03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.2.md')){$hard.Add("Duplicate Finance v1.2 root note exists.")}
    if(Test-Path (Get-Path '03_Projects/COSTING.AGENTIC.PLATFORM.v1.1 - Wash.md')){$hard.Add("Costing Wash exists as separate project.")}
    @($hard)
}

function Build-WeeklyBlock([object]$U){
    $risk=($U.Risks|ForEach-Object{"- $_"}) -join "`r`n"
    $dec=($U.DecisionsNeeded|ForEach-Object{"- $_"}) -join "`r`n"
    $next=($U.NextActions|ForEach-Object{"- $_"}) -join "`r`n"
    $secondary=if($U.SecondaryWorkstreamGate){"`r`n- Secondary Workstream Gate: $($U.SecondaryWorkstreamGate)"}else{""}
    $version=if($U.ProposedCanonicalCode){"`r`n- Proposed Canonical Code: $($U.ProposedCanonicalCode)`r`n- Version Migration Status: $($U.VersionMigrationStatus)"}else{""}
@"
## Weekly Synchronization Event: $SourceEventId

### Executive Summary

$($U.LatestUpdateSummary)

### Current Outcome

$($U.Goal)

Primary output: $($U.PrimaryOutput)

### Current Status

- Canonical Code: $($U.Project)
- Current File: $($U.CurrentFile)
- Primary Domain: $($U.PrimaryDomain)
- Lifecycle: $($U.Lifecycle)
- Progress: $($U.Progress)
- Current Gate: $($U.CurrentGate)$secondary
- Priority for ${PlanningPeriod}: $($U.PriorityNextWeek)$version

### Latest Update

$($U.LatestUpdateSummary)

### Current Risks / Blockers

$risk

### Decisions Needed

$dec

### Next Actions

$next

Required next-period output: $($U.RequiredOutput)

### Evidence and Confidence

- Date: $UpdateDate
- Source Event: $SourceEventId
- Source: User-approved Weekly Portfolio Report
- Evidence: $Evidence
- Confidence: $($U.Confidence)
"@
}

function Update-RootNote([object]$U){
    $path=Get-Path $U.CurrentFile; $content=Get-Utf8 $path; $original=$content
    $fm=[regex]::Match($content,'(?s)\A---\r?\n(.*?)\r?\n---\r?\n?')
    if($fm.Success){$yaml=$fm.Groups[1].Value;$body=$content.Substring($fm.Length)}else{$yaml='type: "project"';$body=$content}
    $yaml=Set-YamlScalar $yaml 'project_code' (Quote-Yaml $U.Project)
    $yaml=Set-YamlScalar $yaml 'canonical_code' (Quote-Yaml $U.Project)
    $yaml=Set-YamlScalar $yaml 'current_file' (Quote-Yaml ([IO.Path]::GetFileName($U.CurrentFile)))
    $yaml=Set-YamlScalar $yaml 'primary_domain' (Quote-Yaml $U.PrimaryDomain)
    $yaml=Set-YamlScalar $yaml 'lifecycle' (Quote-Yaml $U.Lifecycle)
    $yaml=Set-YamlScalar $yaml 'phase' (Quote-Yaml $U.Lifecycle)
    $yaml=Set-YamlScalar $yaml 'status' (Quote-Yaml $U.Lifecycle)
    $yaml=Set-YamlScalar $yaml 'progress' (Quote-Yaml $U.Progress)
    $yaml=Set-YamlScalar $yaml 'current_gate' (Quote-Yaml $U.CurrentGate)
    $yaml=Set-YamlScalar $yaml 'priority' (Quote-Yaml $U.PriorityNextWeek)
    $yaml=Set-YamlScalar $yaml 'last_verified' (Quote-Yaml $UpdateDate)
    $yaml=Set-YamlScalar $yaml 'source_event' (Quote-Yaml $SourceEventId)
    if($U.ProposedCanonicalCode){$yaml=Set-YamlScalar $yaml 'proposed_canonical_code' (Quote-Yaml $U.ProposedCanonicalCode);$yaml=Set-YamlScalar $yaml 'version_migration_status' (Quote-Yaml $U.VersionMigrationStatus)}
    $block=Build-WeeklyBlock $U
    $eventPattern='(?s)\r?\n## Weekly Synchronization Event: '+[regex]::Escape($SourceEventId)+'.*?(?=\r?\n'+[regex]::Escape($KnowledgeEnd)+')'
    if($body -match $eventPattern){
        if(-not $Force){return [pscustomobject]@{File=$U.CurrentFile;Result='SKIPPED';Reason='Weekly event already exists'}}
        $body=[regex]::Replace($body,$eventPattern,"`r`n$block`r`n")
    }else{
        $body=$body -replace [regex]::Escape($KnowledgeEnd),("`r`n"+$block+"`r`n`r`n"+$KnowledgeEnd)
    }
    $new="---`r`n$yaml`r`n---`r`n$body"
    Write-Changed $path $new 'frontmatter and managed weekly knowledge update'
}

function Update-MemoryCard([object]$U){
    $path=Get-Path $U.MemoryFile; $content=Get-Utf8 $path
    $fm=[regex]::Match($content,'(?s)\A---\r?\n(.*?)\r?\n---\r?\n?')
    if(-not $fm.Success){throw "Memory frontmatter missing: $($U.MemoryFile)"}
    $yaml=$fm.Groups[1].Value; $body=$content.Substring($fm.Length)
    $yaml=Set-YamlScalar $yaml 'canonical_code' (Quote-Yaml $U.Project)
    $yaml=Set-YamlScalar $yaml 'current_file' (Quote-Yaml ([IO.Path]::GetFileName($U.CurrentFile)))
    $yaml=Set-YamlScalar $yaml 'primary_domain' (Quote-Yaml $U.PrimaryDomain)
    $yaml=Set-YamlScalar $yaml 'lifecycle' (Quote-Yaml $U.Lifecycle)
    $yaml=Set-YamlScalar $yaml 'phase' (Quote-Yaml $U.Lifecycle)
    $yaml=Set-YamlScalar $yaml 'status' (Quote-Yaml $U.Lifecycle)
    $yaml=Set-YamlScalar $yaml 'progress' (Quote-Yaml $U.Progress)
    $yaml=Set-YamlScalar $yaml 'current_gate' (Quote-Yaml $U.CurrentGate)
    $yaml=Set-YamlScalar $yaml 'current_outcome' (Quote-Yaml $U.PrimaryOutput)
    $yaml=Set-YamlScalar $yaml 'latest_update_summary' (Quote-Yaml $U.LatestUpdateSummary)
    $yaml=Set-YamlScalar $yaml 'known_risks' (Quote-Yaml (Join-Items $U.Risks))
    $yaml=Set-YamlScalar $yaml 'decisions_needed' (Quote-Yaml (Join-Items $U.DecisionsNeeded))
    $yaml=Set-YamlScalar $yaml 'next_actions' (Quote-Yaml (Join-Items $U.NextActions))
    $yaml=Set-YamlScalar $yaml 'priority' (Quote-Yaml $U.PriorityNextWeek)
    $yaml=Set-YamlScalar $yaml 'last_verified' (Quote-Yaml $UpdateDate)
    $yaml=Set-YamlScalar $yaml 'recent_update_events' ('["'+$SourceEventId+'"]')
    if($U.SecondaryWorkstreamGate){$yaml=Set-YamlScalar $yaml 'secondary_workstream_gate' (Quote-Yaml $U.SecondaryWorkstreamGate)}
    if($U.ProposedCanonicalCode){$yaml=Set-YamlScalar $yaml 'proposed_canonical_code' (Quote-Yaml $U.ProposedCanonicalCode);$yaml=Set-YamlScalar $yaml 'version_migration_status' (Quote-Yaml $U.VersionMigrationStatus)}
    $heading='## Recent Update Events'
    $header='| Date | Update Type | Summary | Source | Confidence |'
    $sep='| --- | --- | --- | --- | --- |'
    $row='| '+$UpdateDate+' | Weekly Portfolio Update | '+(Escape-Cell $U.LatestUpdateSummary)+' | '+$SourceEventId+' | Strong |'
    if($body -notmatch [regex]::Escape($heading)){$body=$body.TrimEnd()+"`r`n`r`n$heading`r`n`r`n$header`r`n$sep`r`n$row`r`n"}
    elseif($body -notmatch [regex]::Escape($SourceEventId)){
        $tablePattern='(?s)('+[regex]::Escape($heading)+'.*?\|\s*---.*?\|\r?\n)'
        $body=[regex]::Replace($body,$tablePattern,'$1'+$row+"`r`n",1)
    }elseif($Force){
        $body=[regex]::Replace($body,'(?m)^\|\s*'+[regex]::Escape($UpdateDate)+'.*?'+[regex]::Escape($SourceEventId)+'.*?\|$',$row)
    }
    Write-Changed $path ("---`r`n$yaml`r`n---`r`n$body") 'memory metadata and recent event'
}

function Update-Table([string]$Path,[string[]]$RequiredHeaders,[scriptblock]$Matcher,[scriptblock]$Updater,[string]$Reason){
    $lines=@(Get-Content -LiteralPath $Path -Encoding UTF8); $header=-1
    for($i=0;$i -lt $lines.Count;$i++){if($lines[$i] -match '^\s*\|'){ $cells=Split-Row $lines[$i]; $names=@($cells|ForEach-Object{$_.Trim()}); $ok=$true; foreach($h in $RequiredHeaders){if($names -notcontains $h){$ok=$false}}; if($ok){$header=$i;break}}}
    if($header -lt 0){throw "Required table not found: $Path"}
    $headers=@((Split-Row $lines[$header])|ForEach-Object{$_.Trim()}); $changed=$false
    foreach($u in $WeeklyProjectUpdates){
        $found=$false
        for($r=$header+2;$r -lt $lines.Count;$r++){if($lines[$r] -notmatch '^\s*\|'){break};$cells=Split-Row $lines[$r];if(& $Matcher $u $cells $headers){$before=$lines[$r];$cells=& $Updater $u $cells $headers;$lines[$r]=Join-Row $cells;if($lines[$r] -ne $before){$changed=$true};$found=$true;break}}
        if(-not $found){throw "Project row not found for $($u.Project) in $Path"}
    }
    if($changed){Write-Changed $Path ($lines -join "`r`n") $Reason}else{[pscustomobject]@{File=$Path;Result='UNCHANGED';Reason=$Reason}}
}
function Set-Cell([string[]]$Cells,[string[]]$Headers,[string]$Header,[string]$Value){$i=[array]::IndexOf($Headers,$Header);if($i -ge 0 -and $i -lt $Cells.Count){$Cells[$i]=' '+(Escape-Cell $Value)+' '};$Cells}

function Update-Index {
    Update-Table $MemoryIndexPath @('Project','Project Note','Phase','Priority','Current Outcome','Latest Update','Last Verified') `
        {param($u,$c,$h) (($c -join '|') -like "*$($u.Project)*") -or (($c -join '|') -like "*$([IO.Path]::GetFileNameWithoutExtension($u.CurrentFile))*")} `
        {param($u,$c,$h) $c=Set-Cell $c $h 'Phase' $u.Lifecycle;$c=Set-Cell $c $h 'Priority' $u.PriorityNextWeek;$c=Set-Cell $c $h 'Current Outcome' $u.PrimaryOutput;$c=Set-Cell $c $h 'Latest Update' $SourceEventId;$c=Set-Cell $c $h 'Last Verified' $UpdateDate;$c} 'memory index weekly sync'
}
function Update-RegistryTable {
    Update-Table $RegistryPath @('Project Name','Canonical Filename','Phase','Status / Priority','Progress','Decision Needed','Next Action','Source File') `
        {param($u,$c,$h) (($c -join '|') -like "*$($u.Project)*") -or (($c -join '|') -like "*$([IO.Path]::GetFileName($u.CurrentFile))*")} `
        {param($u,$c,$h) $c=Set-Cell $c $h 'Project Name' $u.Project;$c=Set-Cell $c $h 'Canonical Filename' ([IO.Path]::GetFileName($u.CurrentFile));$c=Set-Cell $c $h 'Phase' $u.Lifecycle;$c=Set-Cell $c $h 'Status / Priority' ($u.CurrentGate+' / '+$u.PriorityNextWeek);$c=Set-Cell $c $h 'Progress' $u.Progress;$c=Set-Cell $c $h 'Decision Needed' $u.DecisionsNeeded[0];$c=Set-Cell $c $h 'Next Action' $u.NextActions[0];$c=Set-Cell $c $h 'Source File' ([IO.Path]::GetFileName($u.CurrentFile));$c} 'master registry weekly sync'
}
function Update-ResourceTable {
    Update-Table $ResourceMatrixPath @('Canonical Project Name','Phase / Progress','Business Stakeholder / Department','Current Priority','Decision Needed','Next Action','Source File') `
        {param($u,$c,$h) (($c -join '|') -like "*$($u.Project)*") -or (($c -join '|') -like "*$([IO.Path]::GetFileNameWithoutExtension($u.CurrentFile))*")} `
        {param($u,$c,$h) $c=Set-Cell $c $h 'Canonical Project Name' ('[['+$u.Project+']]');$c=Set-Cell $c $h 'Phase / Progress' ($u.Lifecycle+' / '+$u.Progress);$c=Set-Cell $c $h 'Business Stakeholder / Department' $u.Ownership;$c=Set-Cell $c $h 'Current Priority' $u.PriorityNextWeek;$c=Set-Cell $c $h 'Decision Needed' $u.DecisionsNeeded[0];$c=Set-Cell $c $h 'Next Action' $u.NextActions[0];$c=Set-Cell $c $h 'Source File' ([IO.Path]::GetFileName($u.CurrentFile));$c} 'resource matrix explicit ownership sync'
}

function Update-Ledger {
    $content=Get-Utf8 $LedgerPath
    if($content -match [regex]::Escape($SourceEventId) -and -not $Force){return [pscustomobject]@{File=$LedgerPath;Result='SKIPPED';Reason='event already exists'}}
    if($Force){$content=(@($content -split "`r?`n")|Where-Object{$_ -notmatch [regex]::Escape($SourceEventId)}) -join "`r`n"}
    $rows=@();foreach($u in $WeeklyProjectUpdates){
        $summary=Escape-Cell $u.LatestUpdateSummary;$next=Escape-Cell $u.NextActions[0]
        $rows+='| '+$UpdateDate+' | '+$u.Project+' | weekly_sync | '+$summary+' | lifecycle / gate / priority | prior current state | '+(Escape-Cell($u.Lifecycle+'; '+$u.CurrentGate+'; '+$u.PriorityNextWeek))+' | '+$SourceEventId+' | Strong | memory / note / registry | '+$next+' |'
        if($u.Project -eq 'PPJ.ExpenseInvoices.v1.1'){$rows+='| '+$UpdateDate+' | '+$u.Project+' | scope_change | Current active rollout covers departments and factories; Export excluded. EXIM-first remains historical only. | active scope | EXIM-first historical wording | departments/factories; Export excluded | '+$SourceEventId+' | Strong | memory / note / registry | Confirm mapping cut-off and go-live |'}
        if($u.ProposedCanonicalCode){$rows+='| '+$UpdateDate+' | '+$u.Project+' | proposed_version_migration | Latest BRD displays v1.2; physical v1.1 note retained pending approval. | proposed_canonical_code | none | '+$u.ProposedCanonicalCode+' / Pending Confirmation | '+$SourceEventId+' | Strong | memory / note / registry | Decide registry version migration |'}
    }
    Write-Changed $LedgerPath ($content.TrimEnd()+"`r`n"+($rows -join "`r`n")+"`r`n") 'idempotent weekly ledger events'
}

function Write-Task([object]$T){
    $name='TASK_'+$T.Project+'_'+$SourceEventId+'_'+$T.Slug+'.md';$path=Join-Path $TaskDir $name
    if((Test-Path $path) -and -not $Force){return [pscustomobject]@{File=$path;Result='SKIPPED';Reason='task already exists'}}
    $u=$WeeklyProjectUpdates|Where-Object{$_.Project -eq $T.Project}|Select-Object -First 1
    $content=@"
---
type: task
created: "$UpdateDate"
project: "$($T.Project)"
lane: "TASKS / DOCS TO UPDATE"
status: "Open"
priority: "$($T.Priority)"
source_event: "$SourceEventId"
---

# $($T.Title)

Project
[[$([IO.Path]::GetFileNameWithoutExtension($u.CurrentFile))]]

Outcome
$($T.Outcome)

Next Action
$($u.NextActions[0])

Source / Context
$Evidence

Validation
Deliverable reviewed by the named business owner or marked Needs Confirmation.
"@
    Write-Changed $path $content 'deterministic next-week task'
}

function Write-Decision([object]$D){
    $path=Join-Path $DecisionDir ($D.Id+'.md')
    if((Test-Path $path) -and -not $Force){return [pscustomobject]@{File=$path;Result='SKIPPED';Reason='decision already exists'}}
    $u=$WeeklyProjectUpdates|Where-Object{$_.Project -eq $D.Project}|Select-Object -First 1
    $content=@"
---
type: decision
id: "$($D.Id)"
date: "$UpdateDate"
project: "$($D.Project)"
status: "Pending"
owner: "$($D.Owner)"
source_event: "$SourceEventId"
---

# $($D.Title)

## Decision Required

$($u.DecisionsNeeded -join "`r`n- ")

## Context

$($u.LatestUpdateSummary)

## Evidence

$Evidence

## Next Step

$($u.NextActions[0])
"@
    Write-Changed $path $content 'deterministic significant decision'
}

function Update-DecisionIndex {
    $content=Get-Utf8 $DecisionIndexPath
    foreach($d in $DecisionGroups){if($content -notmatch [regex]::Escape($d.Id)){$content=$content.TrimEnd()+"`r`n| $($d.Id) | $($d.Title) | $UpdateDate | $($d.Owner) | $($d.Project) | [[$($d.Id)]] |"}}
    Write-Changed $DecisionIndexPath ($content+"`r`n") 'decision index rows'
}

function Build-WeeklyReport {
    $domainGroups=$WeeklyProjectUpdates|Group-Object PrimaryDomain
    $detail=@();foreach($g in $domainGroups){$detail+="## $($g.Name)";foreach($u in $g.Group){$detail+=@"

### **``$($u.Project)``**

Business Problem
: $($u.Goal)

Delivered Progress
: $($u.LatestUpdateSummary)

Current Capability
: $($u.PrimaryOutput)

Risk / Decision
: $($u.Risks[0]) / $($u.DecisionsNeeded[0])

Next Action
: $($u.NextActions[0])
"@}}
    $priorities=($WeeklyProjectUpdates|Sort-Object {[int](($_.PriorityNextWeek -replace '^P(\d+).*','$1') -as [int])}|ForEach-Object{"- **``$($_.Project)``** - $($_.PriorityNextWeek): $($_.RequiredOutput)"}) -join "`r`n"
@"
# PPJ AI & Automation Team

# Weekly Portfolio Update

## Reporting Period

$ReportingPeriod

Next planning period: $PlanningPeriod

## Executive Summary

Eight portfolio projects moved through control design, prototype validation, guided UAT, pre-go-live testing, handover preparation, production support and proposal evaluation. The weekly direction emphasizes trusted data and business controls before AI, expert validation before costing automation, and explicit ownership before go-live or handover.

## Portfolio Movement Summary

- Finance shifted to centralized OC cost control and exception management; v1.2 remains a proposed canonical migration pending approval.
- Costing entered Sew prototype/demo preparation; Wash remains a lower-priority workstream under the same project.
- Material Allocation validated its first split-OC unreserve/allocation flow and moved to exception testing.
- Expense Invoices entered pre-go-live mapping validation for departments/factories, with Export excluded.
- Sourcing completed the third guided training session and moved into adoption measurement.
- HR prepared for Software Team transfer but remains on hold, not completed.
- FD moved to maintenance/production support at 100% of current implementation scope.
- QSee entered formal proposal evaluation, not implementation approval.

## Detailed Project Updates

$($detail -join "`r`n")

## Lifecycle Changes

$($WeeklyProjectUpdates|ForEach-Object{"- **``$($_.Project)``**: $($_.Lifecycle) | Gate: $($_.CurrentGate) | Progress: $($_.Progress)"}|Out-String)

## Priority Plan: $PlanningPeriod

$priorities
- **``COSTING.AGENTIC.PLATFORM.v1.1``** - P9 Wash workstream: Wash dataset request and MVP input/output confirmation. This is not a separate project.

## Management Attention

Finance control rules and v1.2 migration, Expense Invoice go-live readiness, Material Allocation rollback, HR handover owner, QSee proposal evaluation, and Wash expert-approval boundary require management or domain-owner attention.

## Decisions Required

$($WeeklyProjectUpdates|ForEach-Object{"- **``$($_.Project)``**: $($_.DecisionsNeeded -join '; ')"}|Out-String)

## Portfolio Risks

- Source data, mapping and ownership remain the main constraints across Finance, Expense Invoices and Costing.
- Transaction safety and rollback remain critical for Material Allocation.
- Adoption must be measured after Sourcing training.
- HR and QSee require governance before transfer or collaboration decisions.

## Conclusion

The portfolio is moving from broad concepts toward controlled operational capability. Next week should prioritize evidence, validation, ownership and explicit go/no-go decisions rather than expanding scope.
"@
}

function Build-ApplyReport([object[]]$Results,[string[]]$HardStops){
@"
# PPJ Weekly Portfolio Update Apply Report

- Source Event: $SourceEventId
- Reporting Period: $ReportingPeriod
- Applied: $Apply
- Canvas Updated: No
- Projects Resolved: $($WeeklyProjectUpdates.Count)
- Hard Stops: $($HardStops.Count)
- Backup Folder: $BackupRoot

## Results

$($Results|ForEach-Object{"- [$($_.Result)] $($_.File) - $($_.Reason)"}|Out-String)

## Finance Version Handling

Physical/current file remains FIN.AI.FINANCE.MANAGEMENT.v1.1.md. Proposed canonical code FIN.AI.FINANCE.MANAGEMENT.v1.2 is Pending Confirmation. No duplicate note was created.

## Expense Invoice Scope Correction

Current active scope is departments and factories with Export excluded. EXIM-first wording is preserved only as historical context.
"@
}

$hardStops=@(Test-HardStops)
Write-Host "PPJ Weekly Portfolio Synchronization"
Write-Host "Mode: $(if($DryRun){'DRYRUN'}else{'APPLY'})"
Write-Host "Source Event: $SourceEventId"
Write-Host "Affected projects: $($WeeklyProjectUpdates.Count)"
foreach($u in $WeeklyProjectUpdates){Write-Host ("- {0} -> {1} | {2} | {3} | {4}" -f $u.Project,$u.CurrentFile,$u.Lifecycle,$u.CurrentGate,$u.PriorityNextWeek)}
Write-Host "Task groups proposed: $($TaskGroups.Count)"
foreach($t in $TaskGroups){Write-Host "- $($t.Title)"}
Write-Host "Decision logs proposed: $($DecisionGroups.Count)"
foreach($d in $DecisionGroups){Write-Host "- $($d.Title)"}
Write-Host "Ledger project events proposed: $($WeeklyProjectUpdates.Count) plus scope/version events"
Write-Host "Backup plan: $BackupRoot"
Write-Host "Canvas update planned: No"
Write-Host "Hard stops: $($hardStops.Count)"
foreach($h in $hardStops){Write-Host "- $h"}
if($hardStops.Count -gt 0){exit 2}
if($DryRun){Write-Host "DryRun PASS. No files modified.";exit 0}

$results=@()
if(-not(Test-Path $BackupRoot)){New-Item -ItemType Directory -Path $BackupRoot -Force|Out-Null}
if(-not(Test-Path $BackupRoot)){throw "Backup folder could not be created."}

if($UpdateMemory){foreach($u in $WeeklyProjectUpdates){$results+=Update-MemoryCard $u}}
if($UpdateProjectNotes){foreach($u in $WeeklyProjectUpdates){$results+=Update-RootNote $u}}
if($UpdateRegistry){$results+=Update-Index;$results+=Update-RegistryTable}
if($UpdateResourceMatrix){$results+=Update-ResourceTable}
if($UpdateLedger){$results+=Update-Ledger}
if($CreateTasks){foreach($t in $TaskGroups){$results+=Write-Task $t}}
if($CreateDecisions){foreach($d in $DecisionGroups){$results+=Write-Decision $d};$results+=Update-DecisionIndex}
if($CreateWeeklyReport){$results+=Write-Changed $WeeklyReportPath (Build-WeeklyReport) 'management-ready weekly report'}
$results+=Write-Changed $ApplyReportPath (Build-ApplyReport $results $hardStops) 'weekly apply report'

$log="# PPJ Weekly Progress Operation Log`r`n`r`n- Source Event: $SourceEventId`r`n- Timestamp: $Stamp`r`n- Backup: $BackupRoot`r`n- Canvas Updated: No`r`n`r`n## Results`r`n`r`n"+(($results|ForEach-Object{"- [$($_.Result)] $($_.File) - $($_.Reason)"}) -join "`r`n")
Set-Utf8 $OperationLogPath $log
Write-Host "Apply completed."
Write-Host "Backup folder: $BackupRoot"
Write-Host "Operation log: $OperationLogPath"
Write-Host "Weekly report: $WeeklyReportPath"
Write-Host "Apply report: $ApplyReportPath"
foreach($r in $results){Write-Host ("[{0}] {1} - {2}" -f $r.Result,$r.File,$r.Reason)}
