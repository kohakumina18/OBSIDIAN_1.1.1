param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [switch]$UpdateMemory,
    [switch]$UpdateProjectNotes,
    [switch]$UpdateRegistry,
    [switch]$UpdateDomainMatrix,
    [switch]$UpdateResourceMatrix,
    [switch]$UpdateLedger,
    [switch]$UpdateCommandCenter,
    [switch]$CreateTasks,
    [switch]$CreateDecisions,
    [switch]$CreateWeeklyReport
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if ($DryRun -and $Apply) { throw "Use only one mode: -DryRun or -Apply." }
if (-not $Apply) { $DryRun = $true }

$VaultRoot = (Get-Location).ProviderPath
$SourceEventId = "PPJ-WEEKLY-20260727-20260801"
$Evidence = "User-approved Weekly Portfolio Update for 2026-07-27 to 2026-08-01"
$ReportingPeriod = "2026-07-27 to 2026-08-01"
$PlanningPeriod = "2026-08-03 to 2026-08-08"
$UpdateDate = "2026-08-01"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupRoot = Join-Path $VaultRoot "99_Attachments/Audit/Weekly_Progress_20260727_20260801_Backup/$Stamp"
$OperationLogPath = Join-Path $VaultRoot "99_Attachments/Audit/PPJ_WEEKLY_PROGRESS_20260727_20260801_LOG_$Stamp.md"
$ApplyReportPath = Join-Path $VaultRoot "10_Reports/PPJ_WEEKLY_PORTFOLIO_UPDATE_APPLY_REPORT_20260801.md"
$WeeklyReportPath = Join-Path $VaultRoot "10_Reports/PPJ_WEEKLY_PORTFOLIO_UPDATE_20260727_20260801.md"
$WeeklySourcePath = Join-Path $VaultRoot "11_PROJECT_MANAGEMENT/AI_PROJECTS/WEEKLY PORTFOLIO UPDATE.md"
$MemoryIndexPath = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md"
$RegistryPath = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md"
$DomainMatrixPath = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md"
$ResourceMatrixPath = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md"
$ModuleIndexPath = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_MODULE_INDEX.md"
$LedgerPath = Join-Path $VaultRoot "03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md"
$CommandCenterPath = Join-Path $VaultRoot "03_Projects/PROJECT_COMMAND_CENTER.md"
$TaskDir = Join-Path $VaultRoot "03_Projects/_Tasks"
$DecisionDir = Join-Path $VaultRoot "07_Decision_Log"
$DecisionIndexPath = Join-Path $DecisionDir "Decision_Log.md"
$ProposalDir = Join-Path $VaultRoot "03_Projects/_Registry/Project_Update_Proposals"
$ProposalPath = Join-Path $ProposalDir "ACCOUNTING_INVENTORY_REPORT_PROPOSAL_20260801.md"
$KnowledgeStart = "<!-- PPJ_PROJECT_KNOWLEDGE_START -->"
$KnowledgeEnd = "<!-- PPJ_PROJECT_KNOWLEDGE_END -->"

function New-WeeklyUpdate {
    param(
        [string]$Project,
        [string]$PreviousCanonicalCode,
        [string]$CurrentFile,
        [string]$MemoryFile,
        [string]$PrimaryDomain,
        [string]$Lifecycle,
        [string]$Progress,
        [string]$CurrentGate,
        [string]$PriorityNextWeek,
        [string]$CurrentOutcome,
        [string]$LatestUpdateSummary,
        [string[]]$Blockers,
        [string[]]$Risks,
        [string[]]$DecisionsNeeded,
        [string[]]$NextActions,
        [string[]]$Dependencies,
        [string]$RequiredOutput,
        [string]$Ownership,
        [string]$VersionMigrationStatus = ""
    )
    [pscustomobject]@{
        Project = $Project
        PreviousCanonicalCode = $PreviousCanonicalCode
        SourceEventId = $SourceEventId
        UpdateDate = $UpdateDate
        CurrentFile = $CurrentFile
        MemoryFile = $MemoryFile
        PrimaryDomain = $PrimaryDomain
        Lifecycle = $Lifecycle
        Progress = $Progress
        CurrentGate = $CurrentGate
        PriorityNextWeek = $PriorityNextWeek
        CurrentOutcome = $CurrentOutcome
        LatestUpdateSummary = $LatestUpdateSummary
        Blockers = $Blockers
        Risks = $Risks
        DecisionsNeeded = $DecisionsNeeded
        NextActions = $NextActions
        Tasks = @()
        Dependencies = $Dependencies
        Evidence = $Evidence
        Confidence = "Strong"
        RequiredOutput = $RequiredOutput
        Ownership = $Ownership
        VersionMigrationStatus = $VersionMigrationStatus
    }
}

$WeeklyProjectUpdates = @(
    New-WeeklyUpdate "FIN.AI.FINANCE.MANAGEMENT.v1.2" "FIN.AI.FINANCE.MANAGEMENT.v1.1" "03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1.md" "03_Projects/_Registry/Project_Memory/FIN.AI.FINANCE.MANAGEMENT.v1.1.memory.md" "Finance / Accounting" "Analysis / Design" "TBD" "Data Discovery / Databricks Access Blocked / Rule Engine Design" "P1" `
        "Centralized financial control and analysis platform for OC cost completeness, exception detection, order effectiveness, drill-down reporting, Power BI and AI-assisted analysis." `
        "Workstream 2 source inventory is nearly complete and Workstream 3 factory drill-down is partially covered. Most required sources appear to exist in Databricks rather than the governed DWH. Rule Engine groups now cover materials and trims, subcontracting, and order effectiveness." `
        @("Approved Databricks account and read permission are not available.","Source table, schema, grain, linking key and source owner are not fully confirmed.") `
        @("Required data is outside the currently governed DWH.","OC linking keys may be incomplete.","Accounting approval and warning thresholds are pending.","Workstream 3 could expand before Workstream 2 stabilizes.") `
        @("Define official Databricks access governance.","Approve Accounting rules and thresholds.","Confirm source owners and sources of truth.") `
        @("Follow up Databricks account approval and confirm account, role, catalog, schema, table and read-only permission.","Complete Workstream 2 Source Inventory and profile each source.","Confirm OC linking keys and finalize the Rule Engine Catalogue.","Select 20-30 sample OCs and compare Rule Engine results with manual Accounting controls.","Do not expand Workstream 3 before Workstream 2 stabilizes.") `
        @("Databricks Sources -> Finance Source Inventory -> Data Profiling -> Rule Engine -> OC Exception Detection -> Accounting Validation") `
        "Databricks access decision and finalized Rule Engine Catalogue." "Accounting; data-access governance owner Needs Confirmation" "Pending Confirmation"

    New-WeeklyUpdate "HR.SSPFD.Workflow.v1.1" "HR.SSPFD.Workflow.v1.1" "03_Projects/HR.SS&PFD.v1.1.md" "03_Projects/_Registry/Project_Memory/HR.SSPFD.Workflow.v1.1.memory.md" "HR" "Production Rollout / Stabilization" "TBD" "UAT Completed / Initial Deployment / Group Rollout" "P5" `
        "Group employee master-data standardization and applicant-data extraction/application-form prefill workflows." `
        "Demo, UAT, initial testing and User Manual were completed. Deployment started, including group-wide employee-data standardization rollout. The project now contains employee master-data standardization and applicant data extraction/prefill workflows." `
        @("Production-support ownership across HR, Software Team, AI Team and HR IT is not confirmed.","Conflicting-record correction authority is unclear.") `
        @("Sensitive HR and applicant data require strict permissions.","Incorrect matching may merge unrelated employee records.","Applicant consent and privacy controls require confirmation.") `
        @("Assign production owner and correction authority.","Approve applicant consent and privacy controls.","Confirm post-rollout support boundary.") `
        @("Monitor rollout by company and factory.","Finalize employee matching and conflict-handling rules.","Monitor rollout issues, fix and retest.","Build rollout-status dashboard and complete Workflow 2 user guidance.","Confirm production-support handover.") `
        @("Employee source data -> Matching Rules -> Trusted Employee Master -> Group Rollout","Applicant Input -> Extraction -> Mandatory-field Validation -> Prefill -> Review -> Structured Submission") `
        "Rollout monitoring and confirmed production ownership." "HR; production owner Needs Confirmation"

    New-WeeklyUpdate "PUR.GDI.Automation.v1.0" "PUR.GDI.Automation.v1.0" "03_Projects/PUR.GDI Automation.md" "03_Projects/_Registry/Project_Memory/PUR.GDI.Automation.v1.0.memory.md" "Sourcing / Purchasing" "Analysis / Solution Redesign" "TBD" "Business Flow Confirmed / API Integration Discovery" "P2" `
        "API-first GDI creation and update workflow that reduces manual Purchasing work while preserving review, transaction control and auditability in WFX." `
        "Purchasing and selected MER leaders/managers confirmed the business flow, required input, creation conditions, review responsibilities and target output. Architecture direction changed from Selenium screen simulation to approved API integration." `
        @("Official WFX API documentation, authorization and non-production environment are not confirmed.","Rollback, draft/review and idempotency behavior are not confirmed.") `
        @("Direct unapproved Databricks writes would not constitute a governed WFX transaction.","Duplicate transactions and incomplete rollback could damage operational data.") `
        @("Approve WFX API or vendor-approved transactional service.","Confirm transaction, rollback, approval and audit architecture.") `
        @("Request WFX API documentation and supported create/update/draft/submit/cancel/status operations.","Confirm authentication, request/response schema, idempotency and duplicate rules.","Confirm rollback, audit and approval-before-submit requirements.","Build and test an API prototype in a non-production environment.","Do not write production transactions without vendor approval.") `
        @("Confirmed Purchasing Workflow -> WFX API -> Controlled GDI Transaction -> Audit and Status") `
        "WFX API request and target integration architecture." "Purchasing and participating MER leaders/managers"

    New-WeeklyUpdate "TD.TechnicalKnowledge.Platform.v2.1" "TD.TechnicalKnowledge.Platform.v2.1" "03_Projects/TD.TechnicalPlatform_v2.1.md" "03_Projects/_Registry/Project_Memory/TD.TechnicalKnowledge.Platform.v2.1.memory.md" "Fabric / Textiles Technique" "Development / Data Validation" "ETL completed for currently identified v2.1 sources" "ETL Completed / Data Foundation Available / Data Acceptance Pending" "P6" `
        "Technical data and knowledge foundation for search, retrieval, Pattern, BOM, construction, consumption, historical cases, Costing and future domain AI." `
        "ETL completed for the Technical sources currently identified in v2.1 scope. Data was extracted, transformed, initially standardized, loaded into the Technical Platform data layer and organized for future search, retrieval and AI capability." `
        @("Technical-user acceptance is pending.","Completeness, freshness, approved-version logic, lineage and permissions are not fully confirmed.") `
        @("ETL completion does not mean production-ready data.","Duplicate records, missing keys or wrong versions could affect Costing outputs.") `
        @("Approve Technical data completeness, accuracy and version logic.","Confirm data owner, lineage and permission model.") `
        @("Measure ETL coverage and reconcile with source systems.","Detect duplicates and missing keys.","Confirm record version and approved/latest version logic.","Build search/retrieval and permission layers.","Connect consumption data to Costing and prepare Technical-user UAT.") `
        @("Technical Platform ETL -> Pattern / BOM / Consumption / Construction -> Sew and Consumption Costing -> Costing Package") `
        "ETL reconciliation and Technical data acceptance." "Technical team"

    New-WeeklyUpdate "COSTING.AGENTIC.PLATFORM.v1.1" "COSTING.AGENTIC.PLATFORM.v1.1" "03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1.md" "03_Projects/_Registry/Project_Memory/COSTING.AGENTIC.PLATFORM.v1.1.memory.md" "Merchandising" "Development" "TBD" "Sew Costing v1.1 Demo Completed / v1.2 Development" "P3" `
        "Costing and Quotation Package for Merchandising review and customer quotation proposals." `
        "Sew Costing v1.1 demo completed, demonstrating description intake, operation extraction, operation-list standardization and an initial SAM/Sew Cost data foundation. v1.2 focuses on SAM accuracy, machine/standard-time mapping, incomplete descriptions, historical similarity, confidence, expert review and GTAS/IED transfer." `
        @("GTAS/IED data contract and integration format are not confirmed.","Technical data acceptance remains pending.") `
        @("SAM is not final without validated standards and expert review.","AI suggestion and approved costing must remain separate.") `
        @("Approve Sew v1.2 accuracy and acceptance plan.","Confirm GTAS/IED data contract and expert-approval boundary.") `
        @("Evaluate the v1.1 demo with Sew experts and establish an accuracy baseline.","Analyze extraction errors and improve SAM calculation.","Confirm GTAS/IED data contract and API/integration format.","Connect Technical consumption data.","Continue the Wash dataset workstream without creating a separate root project.") `
        @("TD.TechnicalKnowledge.Platform.v2.1 -> Consumption / Pattern / BOM / Construction / History -> Costing Platform","AI Suggestion -> Expert-approved Result -> Final GTAS/IED Transfer") `
        "Sew Costing v1.2 accuracy plan and GTAS/IED data contract." "Merchandising and Sew experts"

    New-WeeklyUpdate "SCP.SOURCING.CHATBOT.v2.3" "SCP.SOURCING.CHATBOT.v2.3" "03_Projects/SCP.SOURCING.CHATBOT.v2.3.md" "03_Projects/_Registry/Project_Memory/SCP.SOURCING.CHATBOT.v2.3.memory.md" "Sourcing / Purchasing" "Closeout Preparation" "TBD" "Output Finalization / UAT Acceptance / Handover Preparation" "P4" `
        "Consolidated Sourcing data platform and chatbot for supplier, material, fabric, trims and sample lookup." `
        "The team is finalizing the official output format for the current release. Expected next movement is UAT acceptance, handover and closure of active-development scope. External Sourcing data standardization remains a backlog workstream under the same consolidated project." `
        @("UAT acceptance, data owner, permission owner and support owner are not confirmed.","External data remains manually entered and inconsistent.") `
        @("Closing chatbot development could be confused with completing the data foundation.","Future MER usage requires stress, permission, search-quality and data-normalization tests.") `
        @("Approve active-development closeout separately from external-data backlog.","Confirm data, permission and support ownership.") `
        @("Finalize output format and confirm UAT acceptance.","Complete User Manual and support handover.","Separate defects from enhancements and transfer remaining issues to maintenance backlog.","Create/update the Sourcing External Data Standardization Backlog section within this project.") `
        @("External Manual Input -> Validation -> Standardization -> Sourcing Data Platform -> Chatbot Search Quality") `
        "UAT acceptance, handover and closeout package." "Sourcing; data/permission/support owners Need Confirmation"

    New-WeeklyUpdate "PPJ.ExpenseInvoices.v1.1" "PPJ.ExpenseInvoices.v1.1" "03_Projects/PPJ. Expense-Invoices.v1.1.md" "03_Projects/_Registry/Project_Memory/PPJ.ExpenseInvoices.v1.1.memory.md" "Finance / Accounting" "UAT / Stabilization" "TBD" "Supplier and Mapping Expansion / Defect Closure" "P7" `
        "Expense-invoice workflow for approved business scope, supplier mapping, department/factory mapping, ledger/account mapping, validation and controlled entry." `
        "UAT continued with mapping expansion, frequent-supplier additions, bot adjustments, real-data defect capture, fixes and retesting. The current approved scope remains protected; EXIM-first wording is historical only, not current scope." `
        @("Mapping ownership and go-live boundary are not confirmed.","Critical real-data defects and supplier-code inconsistencies remain open.") `
        @("Duplicate invoices, invalid mappings and weak error handling could affect Accounting operations.","Production monitoring and escalation ownership are pending.") `
        @("Approve supplier and mapping ownership.","Confirm go-live boundary and production-support escalation.") `
        @("Finalize frequent-supplier list and standardize supplier codes.","Confirm mapping ownership and close critical defects.","Run regression testing.","Confirm go-live boundary, production monitoring and support escalation.") `
        @("Supplier Master -> Supplier Mapping -> Department/Factory and Ledger Mapping -> Validation -> Expense Invoice Entry -> Monitoring") `
        "Supplier mapping completion and UAT defect closure." "Accounting"

    New-WeeklyUpdate "PUR.Inventory.Report.v2.1" "PUR.Inventory.Report.v1.0" "03_Projects/PUR.Inventory Report.md" "03_Projects/_Registry/Project_Memory/PUR.Inventory.Report.v1.0.memory.md" "Sourcing / Purchasing" "Production / Support" "v2.1 enhancement completed" "v2.1 Enhancement Completed / Post-release Validation" "P9" `
        "Purchasing inventory reporting with additional reports, tables, filters, operational visibility and analysis." `
        "Purchasing Inventory Report was enhanced to v2.1 with additional reports, tables, filters and operational analysis capability. The active physical note is retained while canonical metadata moves to v2.1." `
        @("Post-release totals, refresh and source reconciliation require validation.") `
        @("Upstream source changes may create inconsistent inventory totals.","Enhancement requests may be mixed with production defects.") `
        @("Confirm post-release acceptance and enhancement backlog.") `
        @("Collect post-v2.1 feedback.","Validate totals, refresh and source reconciliation.","Separate defects from enhancements.","Confirm enhancement backlog and monitor production stability.") `
        @("Inventory Source Data -> Report Refresh -> Purchasing Visibility -> Operational Analysis") `
        "Post-release validation and enhancement backlog." "Purchasing and material planning" "Canonical metadata updated; physical filename retained"

    New-WeeklyUpdate "PPJxNUNOX.ScanTrial" "PPJxNUNOX.ScanTrial" "03_Projects/PPJxNUNOX.md" "03_Projects/_Registry/Project_Memory/PPJxNUNOX.ScanTrial.memory.md" "Fabric / Textiles Technique" "Hardware Trial / Feasibility Assessment" "TBD" "Vendor Visit Proposed / Pending Leadership Approval" "P10" `
        "Evaluate NUNOX scanning and a Digital Library opportunity linking fabric, hanger, garment sample, visual and Technical metadata." `
        "NUNOX proposed an official working/training session around 2026-08-17 and 2026-08-18 for hardware guidance, adoption, digitization workflow and Digital Online Library discussion." `
        @("Leadership direction, schedule, objective, sample dataset and sponsor are not confirmed.") `
        @("Scanner workflow, storage, access, integration and commercial value are not validated.","Scope may overlap FD, CPD and Technical platforms if boundaries are not explicit.") `
        @("Approve or decline the vendor visit and Digital Library assessment.","Confirm leadership sponsor and business-case scope.") `
        @("Obtain leadership direction and confirm the 17-18 August schedule.","Define session objective, sample dataset and user groups.","Evaluate scanner workflow, storage and access.","Assess integration boundaries with FD, CPD and Technical Platform.","Build a business case before commercial agreement.") `
        @("NUNOX Scan Trial -> Fabric Image Capture -> FD / CPD / Technical Integration Assessment -> Digital Library Business Case") `
        "Leadership decision and vendor-visit preparation." "Leadership sponsor Needs Confirmation"

    New-WeeklyUpdate "PPJxStratova.AI" "PPJxStratova.AI" "03_Projects/PPJxStratova AI.md" "03_Projects/_Registry/Project_Memory/PPJxStratova.AI.memory.md" "Fabric / Textiles Technique" "Closed / Opportunity Under Review" "TBD" "Reopened Discussion / Pending Leadership Direction" "P8" `
        "Preserve the closed Stratova Pattern/Technical AI engagement while evaluating a new Google-related funding opportunity without automatic reactivation." `
        "The partner reported new Google-related funding or support and an expected Google/Stratova meeting. Cloud cost, licensing, funding coverage, post-funding cost, data ownership, model ownership and leadership direction remain unclear." `
        @("Formal leadership direction and a PPJ-specific business case are not available.","Commercial and ownership terms are unclear.") `
        @("Funding or credits may not cover implementation or long-term cost.","The closed project could be incorrectly reactivated without approval.") `
        @("Choose Proceed, Pilot with credits, Negotiate, Hold or Reject.","Confirm funding, licensing, implementation/support cost and data/model ownership.") `
        @("Capture the Google/Stratova meeting.","Clarify funding, credits, licensing, implementation and support costs.","Clarify data and model ownership.","Define a PPJ-specific use case and prepare a leadership option paper.") `
        @("Google/Stratova Opportunity -> Commercial and Ownership Review -> PPJ Business Case -> Leadership Decision") `
        "Google/Stratova meeting note and leadership option paper." "Leadership decision owner Needs Confirmation"

    New-WeeklyUpdate "PPJxQSee.AI" "PPJxQSee.AI" "03_Projects/PPJxQSee.ai.md" "03_Projects/_Registry/Project_Memory/PPJxQSee.AI.memory.md" "QC / TQM" "On Hold / Pending Decision" "TBD" "Internal Resource Constraint / Reactivation Criteria Required" "P11" `
        "Preserve the QSee QC AI Vision opportunity while holding execution until ownership, resources, dataset readiness, pilot scope and go/no-go authority are confirmed." `
        "QC and TQM reported insufficient internal resources to continue follow-up. An NDA is signed, but it does not approve PoC execution, implementation, commercial engagement or continued investment." `
        @("QC owner, TQM owner, dataset owner, labeling resources, validation resources, budget and go/no-go authority are not confirmed.") `
        @("NDA status could be misread as implementation approval.","Scheduling work without internal resources would create unmanaged vendor and data commitments.") `
        @("Formally approve hold status and reactivation criteria.","Confirm whether the vendor has been notified.") `
        @("Confirm formal hold status.","Define reactivation criteria covering owners, dataset, labeling, validation, pilot scope, success criteria, factory availability, budget and authority.","Preserve NDA and proposal documents.","Do not schedule implementation work until resources and ownership are confirmed.") `
        @("Confirmed Owners + Dataset + Resources + Pilot Scope + Success Criteria + Budget -> Reactivation Decision") `
        "Formal hold status and reactivation criteria." "QC and TQM owners required"
)

$BacklogCandidate = [pscustomobject]@{
    Name = "Accounting Inventory Report"
    ProposedCanonicalCode = "ACC.Inventory.Control.Report.v1.0"
    PrimaryDomain = "Finance / Accounting"
    Lifecycle = "Backlog / Pending Resource"
    Progress = "Not Started"
    Status = "Pending Resource / Pending Registration Approval"
    Goal = "Create an Accounting-focused inventory report that provides control data or a financial baseline before inventory information is used by downstream Purchasing or Finance processes."
    RequiredClarifications = @("Accounting business questions","Official source of truth","Relationship with PUR.Inventory.Report.v2.1","Report grain","Closing-period logic","Valuation logic","Inventory aging","Owner","Acceptance criteria")
}

$TaskGroups = @(
    [pscustomobject]@{Slug="finance-databricks-rule-engine";Project="FIN.AI.FINANCE.MANAGEMENT.v1.2";Title="Finance Databricks Access and Rule Engine Finalization";Priority="P1"}
    [pscustomobject]@{Slug="gdi-wfx-api";Project="PUR.GDI.Automation.v1.0";Title="GDI WFX API Architecture and Prototype";Priority="P2"}
    [pscustomobject]@{Slug="costing-sew-v12";Project="COSTING.AGENTIC.PLATFORM.v1.1";Title="Costing Sew v1.2 Accuracy and GTAS-IED Contract";Priority="P3"}
    [pscustomobject]@{Slug="sourcing-closeout-data";Project="SCP.SOURCING.CHATBOT.v2.3";Title="Sourcing Closeout and External Data Standardization Backlog";Priority="P4"}
    [pscustomobject]@{Slug="hr-rollout-ownership";Project="HR.SSPFD.Workflow.v1.1";Title="HR Group Rollout and Production Ownership";Priority="P5"}
    [pscustomobject]@{Slug="technical-etl-acceptance";Project="TD.TechnicalKnowledge.Platform.v2.1";Title="Technical ETL Reconciliation and Data Acceptance";Priority="P6"}
    [pscustomobject]@{Slug="expense-supplier-uat";Project="PPJ.ExpenseInvoices.v1.1";Title="Expense Invoice Supplier Mapping and UAT Closure";Priority="P7"}
    [pscustomobject]@{Slug="stratova-option-paper";Project="PPJxStratova.AI";Title="Stratova Commercial and Funding Option Paper";Priority="P8"}
    [pscustomobject]@{Slug="inventory-v21-validation";Project="PUR.Inventory.Report.v2.1";Title="Purchasing Inventory v2.1 Post-release Validation";Priority="P9"}
    [pscustomobject]@{Slug="nunox-visit-business-case";Project="PPJxNUNOX.ScanTrial";Title="NUNOX Visit Preparation and Digital Library Business Case";Priority="P10"}
    [pscustomobject]@{Slug="qsee-hold-criteria";Project="PPJxQSee.AI";Title="QSee Formal Hold and Reactivation Criteria";Priority="P11"}
)

$DecisionGroups = @(
    [pscustomobject]@{Id="DEC-WEEKLY-20260801-DATABRICKS";Project="FIN.AI.FINANCE.MANAGEMENT.v1.2";Title="Databricks Access Governance";Owner="Data Governance / Accounting"}
    [pscustomobject]@{Id="DEC-WEEKLY-20260801-GDI-API";Project="PUR.GDI.Automation.v1.0";Title="GDI WFX API and Transaction Architecture";Owner="Purchasing / WFX Owner"}
    [pscustomobject]@{Id="DEC-WEEKLY-20260801-HR-OWNER";Project="HR.SSPFD.Workflow.v1.1";Title="HR Production Ownership";Owner="HR / Software Team / HR IT"}
    [pscustomobject]@{Id="DEC-WEEKLY-20260801-TECH-ACCEPT";Project="TD.TechnicalKnowledge.Platform.v2.1";Title="Technical Data Acceptance";Owner="Technical Team"}
    [pscustomobject]@{Id="DEC-WEEKLY-20260801-SOURCING-CLOSE";Project="SCP.SOURCING.CHATBOT.v2.3";Title="Sourcing Closeout versus External Data Backlog";Owner="Sourcing"}
    [pscustomobject]@{Id="DEC-WEEKLY-20260801-ACC-INV";Project="Accounting Inventory Report";Title="Accounting Inventory Report Registration";Owner="Accounting / Portfolio Governance"}
    [pscustomobject]@{Id="DEC-WEEKLY-20260801-NUNOX";Project="PPJxNUNOX.ScanTrial";Title="NUNOX Visit and Digital Library Direction";Owner="Leadership"}
    [pscustomobject]@{Id="DEC-WEEKLY-20260801-STRATOVA";Project="PPJxStratova.AI";Title="Stratova Funding and Commercial Direction";Owner="Leadership"}
    [pscustomobject]@{Id="DEC-WEEKLY-20260801-QSEE";Project="PPJxQSee.AI";Title="QSee Hold and Reactivation Criteria";Owner="QC / TQM"}
)

function Get-Path([string]$RelativePath) { Join-Path $VaultRoot ($RelativePath -replace "/", "\") }
function Get-Utf8([string]$Path) { if (Test-Path -LiteralPath $Path) { Get-Content -LiteralPath $Path -Raw -Encoding UTF8 } else { "" } }
function Set-Utf8([string]$Path, [string]$Content) { $directory = Split-Path $Path -Parent; if (-not (Test-Path -LiteralPath $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }; Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8 }
function ConvertTo-YamlQuoted([string]$Value) { '"' + (($Value -replace '"','\"') -replace "`r?`n", ' ') + '"' }
function ConvertTo-FlatText([string[]]$Items) { (@($Items | ForEach-Object { $_.Trim() } | Where-Object { $_ }) -join " | ") }
function ConvertTo-CellText([string]$Value) { if ($null -eq $Value) { return "" }; return (($Value -replace '(?<!\\)\|','\|' -replace "`r?`n",' ').Trim()) }
function ConvertTo-YamlInlineArray([string[]]$Items) { '[' + ((@($Items) | ForEach-Object { ConvertTo-YamlQuoted $_ }) -join ', ') + ']' }

function Get-YamlScalar([string]$Yaml, [string]$Key) {
    $match = [regex]::Match($Yaml, "(?m)^" + [regex]::Escape($Key) + "\s*:\s*(.*?)\s*$")
    if (-not $match.Success) { return "" }
    return $match.Groups[1].Value.Trim().Trim('"').Trim("'")
}

function Set-YamlScalar([string]$Yaml, [string]$Key, [string]$RawValue) {
    $pattern = "(?m)^" + [regex]::Escape($Key) + "\s*:.*$"
    $line = "${Key}: $RawValue"
    if ($Yaml -match $pattern) { return [regex]::Replace($Yaml, $pattern, $line) }
    return $Yaml.TrimEnd() + "`r`n" + $line
}

function Add-YamlListValue([string]$Yaml, [string]$Key, [string]$Value) {
    $pattern = "(?m)^" + [regex]::Escape($Key) + "\s*:\s*\[(.*?)\]\s*$"
    $match = [regex]::Match($Yaml, $pattern)
    if (-not $match.Success) { return Set-YamlScalar $Yaml $Key ('[' + (ConvertTo-YamlQuoted $Value) + ']') }
    $existing = @([regex]::Matches($match.Groups[1].Value, '"((?:\.|[^"])*)"') | ForEach-Object { $_.Groups[1].Value })
    if ($existing -contains $Value) { return $Yaml }
    $newValues = @($existing + $Value)
    return [regex]::Replace($Yaml, $pattern, ($Key + ': ' + (ConvertTo-YamlInlineArray $newValues)))
}

function Split-TableRow([string]$Line) {
    $text = $Line.Trim()
    if ($text.StartsWith('|')) { $text = $text.Substring(1) }
    if ($text.EndsWith('|')) { $text = $text.Substring(0, $text.Length - 1) }
    $sentinel = [char]0x1F
    $text = $text.Replace('\|', [string]$sentinel)
    return @(($text -split '\|', -1) | ForEach-Object { $_.Replace([string]$sentinel, '\|') })
}

function Join-TableRow([string[]]$Cells) { return '| ' + (($Cells | ForEach-Object { $_.Trim() }) -join ' | ') + ' |' }
function Set-TableCell([string[]]$Cells, [string[]]$Headers, [string]$Header, [string]$Value) { $index = [array]::IndexOf($Headers, $Header); if ($index -ge 0 -and $index -lt $Cells.Count) { $Cells[$index] = ' ' + (ConvertTo-CellText $Value) + ' ' }; return $Cells }

function Get-CanonicalLink([object]$Update) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($Update.CurrentFile)
    if ($base -eq $Update.Project) { return '[[' + $base + ']]' }
    return '[[' + $base + '|' + $Update.Project + ']]'
}

function Backup-File([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return }
    if (-not (Test-Path -LiteralPath $BackupRoot)) { New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null }
    $resolved = (Resolve-Path -LiteralPath $Path).ProviderPath
    $relative = $resolved.Substring($VaultRoot.Length).TrimStart('\')
    $destination = Join-Path $BackupRoot (($relative -replace '[:\\/]', '_') + '.bak')
    Copy-Item -LiteralPath $Path -Destination $destination -Force
}

function Write-Changed([string]$Path, [string]$Content, [string]$Reason) {
    $existing = Get-Utf8 $Path
    if ($existing -eq $Content) { return [pscustomobject]@{ File = $Path; Result = 'UNCHANGED'; Reason = $Reason } }
    if ($DryRun) { return [pscustomobject]@{ File = $Path; Result = $(if (Test-Path -LiteralPath $Path) { 'WOULD_UPDATE' } else { 'WOULD_CREATE' }); Reason = $Reason } }
    if (Test-Path -LiteralPath $Path) { Backup-File $Path }
    Set-Utf8 $Path $Content
    return [pscustomobject]@{ File = $Path; Result = $(if ($existing) { 'UPDATED' } else { 'CREATED' }); Reason = $Reason }
}

function Get-RootFrontmatter([string]$Path) {
    $content = Get-Utf8 $Path
    $match = [regex]::Match($content, '(?s)\A---\r?\n(.*?)\r?\n---\r?\n?')
    if (-not $match.Success) { return [pscustomobject]@{ Yaml = ''; Body = $content; HasFrontmatter = $false } }
    return [pscustomobject]@{ Yaml = $match.Groups[1].Value; Body = $content.Substring($match.Length); HasFrontmatter = $true }
}

function Get-SourceEventReferences {
    $references = @()
    $paths = @($LedgerPath, $MemoryIndexPath, $RegistryPath, $DomainMatrixPath, $ResourceMatrixPath, $CommandCenterPath, $WeeklyReportPath, $ApplyReportPath, $ProposalPath)
    $paths += @($WeeklyProjectUpdates | ForEach-Object { Get-Path $_.CurrentFile })
    $paths += @($WeeklyProjectUpdates | ForEach-Object { Get-Path $_.MemoryFile })
    if (Test-Path -LiteralPath $TaskDir) { $paths += @(Get-ChildItem -LiteralPath $TaskDir -File | ForEach-Object { $_.FullName }) }
    if (Test-Path -LiteralPath $DecisionDir) { $paths += @(Get-ChildItem -LiteralPath $DecisionDir -File | ForEach-Object { $_.FullName }) }
    foreach ($path in @($paths | Select-Object -Unique)) {
        if (-not (Test-Path -LiteralPath $path)) { continue }
        $count = ([regex]::Matches((Get-Utf8 $path), [regex]::Escape($SourceEventId))).Count
        if ($count -gt 0) { $references += [pscustomobject]@{ Path = $path; Count = $count } }
    }
    return @($references)
}

function Test-HardStops {
    $hardStops = New-Object System.Collections.Generic.List[string]
    if (-not (Test-Path -LiteralPath (Join-Path $VaultRoot 'AGENTS.md'))) { $hardStops.Add('AGENTS.md not found at vault root.') }
    if (-not (Test-Path -LiteralPath $WeeklySourcePath)) { $hardStops.Add('Approved weekly source file is missing.') }
    if ($WeeklyProjectUpdates.Count -ne 11) { $hardStops.Add('Expected exactly eleven root-backed projects.') }

    $eventReferences = @(Get-SourceEventReferences)
    if ($eventReferences.Count -gt 0 -and -not $Force) { $hardStops.Add("Source event already exists in $($eventReferences.Count) file(s); use -Force only for approved replacement.") }

    foreach ($update in $WeeklyProjectUpdates) {
        $notePath = Get-Path $update.CurrentFile
        $memoryPath = Get-Path $update.MemoryFile
        if (-not (Test-Path -LiteralPath $notePath)) { $hardStops.Add("Missing root note: $($update.CurrentFile)") }
        if (-not (Test-Path -LiteralPath $memoryPath)) { $hardStops.Add("Missing memory card: $($update.MemoryFile)") }
        if ($update.Lifecycle -match '^\s*\d+%\s*$') { $hardStops.Add("Lifecycle is a percentage for $($update.Project)") }
        if (Test-Path -LiteralPath $notePath) {
            $content = Get-Utf8 $notePath
            if (([regex]::Matches($content, [regex]::Escape($KnowledgeStart))).Count -ne 1 -or ([regex]::Matches($content, [regex]::Escape($KnowledgeEnd))).Count -ne 1) { $hardStops.Add("Managed block cannot be parsed safely: $($update.CurrentFile)") }
            if ($content -match '(?mi)^\s*(PROJECT_NAME|PASTE UPDATE HERE|INTAKE_FILE\.md)\s*$') { $hardStops.Add("Generic placeholder found: $($update.CurrentFile)") }
            $frontmatter = Get-RootFrontmatter $notePath
            if ((Get-YamlScalar $frontmatter.Yaml 'type') -match 'alias' -or (Get-YamlScalar $frontmatter.Yaml 'status') -match '^Archived$') { $hardStops.Add("Target note is archived or alias-only: $($update.CurrentFile)") }
        }
    }

    $rootFiles = @(Get-ChildItem -LiteralPath (Join-Path $VaultRoot '03_Projects') -File -Filter '*.md')
    foreach ($update in $WeeklyProjectUpdates) {
        $targetPath = (Get-Path $update.CurrentFile)
        $duplicates = @()
        foreach ($file in $rootFiles) {
            if ($file.FullName -eq $targetPath) { continue }
            $frontmatter = Get-RootFrontmatter $file.FullName
            $code = Get-YamlScalar $frontmatter.Yaml 'canonical_code'
            $projectCode = Get-YamlScalar $frontmatter.Yaml 'project_code'
            if ($code -eq $update.Project -or $projectCode -eq $update.Project) { $duplicates += $file.FullName }
        }
        if ($duplicates.Count -gt 0) { $hardStops.Add("$($update.Project) resolves to multiple active root notes: $($duplicates -join ', ')") }
    }

    if (Test-Path -LiteralPath (Join-Path $VaultRoot '03_Projects/Accounting Inventory Report.md')) { $hardStops.Add('Accounting Inventory Report exists as an active root project without this task approving registration.') }
    if (@($rootFiles | Where-Object { $_.Name -match '(?i)COSTING.*WASH|WASH.*COSTING' }).Count -gt 0) { $hardStops.Add('A separate Costing Wash root project exists.') }
    if (($WeeklyProjectUpdates | Where-Object { $_.Project -eq 'HR.SSPFD.Workflow.v1.1' }).Lifecycle -match 'Closed') { $hardStops.Add('HR cannot be marked Closed.') }
    if (($WeeklyProjectUpdates | Where-Object { $_.Project -eq 'PPJxQSee.AI' }).Lifecycle -notmatch '^On Hold') { $hardStops.Add('QSee must remain On Hold.') }
    if (($WeeklyProjectUpdates | Where-Object { $_.Project -eq 'PPJxStratova.AI' }).Lifecycle -notmatch '^Closed') { $hardStops.Add('Stratova cannot be automatically reactivated.') }
    if (($WeeklyProjectUpdates | Where-Object { $_.Project -eq 'TD.TechnicalKnowledge.Platform.v2.1' }).CurrentGate -notmatch 'Acceptance Pending') { $hardStops.Add('Technical ETL must retain data-acceptance pending state.') }
    $gdi = $WeeklyProjectUpdates | Where-Object { $_.Project -eq 'PUR.GDI.Automation.v1.0' }
    if (($gdi.Dependencies -join ' ') -notmatch 'WFX API' -or ($gdi.Risks -join ' ') -notmatch 'Databricks') { $hardStops.Add('GDI API-first architecture protection is missing.') }
    if (($WeeklyProjectUpdates | Where-Object { $_.Project -eq 'SCP.SOURCING.CHATBOT.v2.3' }).LatestUpdateSummary -notmatch 'backlog workstream under the same consolidated project') { $hardStops.Add('Sourcing external-data backlog must remain within the consolidated project.') }
    if (($WeeklyProjectUpdates | Where-Object { $_.Project -eq 'FIN.AI.FINANCE.MANAGEMENT.v1.2' }).CurrentGate -notmatch 'Databricks Access Blocked') { $hardStops.Add('Finance Databricks blocker is missing.') }
    return @($hardStops)
}

function Get-WeeklyBlock([object]$Update) {
    $blockers = (@($Update.Blockers) | ForEach-Object { '- ' + $_ }) -join "`r`n"
    $risks = (@($Update.Risks) | ForEach-Object { '- ' + $_ }) -join "`r`n"
    $decisions = (@($Update.DecisionsNeeded) | ForEach-Object { '- ' + $_ }) -join "`r`n"
    $actions = (@($Update.NextActions) | ForEach-Object { '- ' + $_ }) -join "`r`n"
    $dependencies = (@($Update.Dependencies) | ForEach-Object { '- ' + $_ }) -join "`r`n"
    $versionLine = if ($Update.VersionMigrationStatus) { "`r`n- Version Migration Status: $($Update.VersionMigrationStatus)" } else { '' }
    return @"
## Weekly Synchronization Event: $SourceEventId

### Stable Project Understanding

$($Update.CurrentOutcome)

### Current Weekly Delta

$($Update.LatestUpdateSummary)

### Current State

- Canonical Code: $($Update.Project)
- Current Physical File: $($Update.CurrentFile)
- Primary Domain: $($Update.PrimaryDomain)
- Lifecycle: $($Update.Lifecycle)
- Progress: $($Update.Progress)
- Current Gate: $($Update.CurrentGate)
- Priority for ${PlanningPeriod}: $($Update.PriorityNextWeek)$versionLine

### Current Outcome

$($Update.CurrentOutcome)

Required output: $($Update.RequiredOutput)

### Systems / Data and Dependencies

$dependencies

### Current Blockers

$blockers

### Current Risks

$risks

### Current Decisions

$decisions

### Next Actions

$actions

### Evidence and Confidence

- Date: $UpdateDate
- Source Event: $SourceEventId
- Source: User-approved Weekly Portfolio Update
- Evidence: $Evidence
- Confidence: $($Update.Confidence)
"@
}

function Update-DomainGovernanceBlock([string]$Body, [object]$Update) {
    $pattern = '(?s)(<!-- PPJ_DOMAIN_GOVERNANCE_START -->)(.*?)(<!-- PPJ_DOMAIN_GOVERNANCE_END -->)'
    $match = [regex]::Match($Body, $pattern)
    if (-not $match.Success) { return $Body }
    $middle = $match.Groups[2].Value
    $values = @{
        'Canonical Code' = $Update.Project
        'Current File' = '[[' + [System.IO.Path]::GetFileNameWithoutExtension($Update.CurrentFile) + ']]'
        'Primary Domain' = $Update.PrimaryDomain
        'Lifecycle' = $Update.Lifecycle
        'Progress' = $Update.Progress
        'Current Gate' = $Update.CurrentGate
    }
    foreach ($key in $values.Keys) {
        $linePattern = '(?m)^- ' + [regex]::Escape($key) + ':.*$'
        if ($middle -match $linePattern) { $middle = [regex]::Replace($middle, $linePattern, ('- ' + $key + ': ' + $values[$key])) }
    }
    return $Body.Substring(0, $match.Index) + $match.Groups[1].Value + $middle + $match.Groups[3].Value + $Body.Substring($match.Index + $match.Length)
}

function Update-ProjectNote([object]$Update) {
    $path = Get-Path $Update.CurrentFile
    $parts = Get-RootFrontmatter $path
    $yaml = $parts.Yaml
    if (-not $parts.HasFrontmatter) { $yaml = 'type: "project"' }
    $yaml = Set-YamlScalar $yaml 'project_code' (ConvertTo-YamlQuoted $Update.Project)
    $yaml = Set-YamlScalar $yaml 'canonical_code' (ConvertTo-YamlQuoted $Update.Project)
    $yaml = Set-YamlScalar $yaml 'current_file' (ConvertTo-YamlQuoted ([System.IO.Path]::GetFileName($Update.CurrentFile)))
    $yaml = Set-YamlScalar $yaml 'primary_domain' (ConvertTo-YamlQuoted $Update.PrimaryDomain)
    $yaml = Set-YamlScalar $yaml 'lifecycle' (ConvertTo-YamlQuoted $Update.Lifecycle)
    $yaml = Set-YamlScalar $yaml 'phase' (ConvertTo-YamlQuoted $Update.Lifecycle)
    $yaml = Set-YamlScalar $yaml 'status' (ConvertTo-YamlQuoted $Update.Lifecycle)
    $yaml = Set-YamlScalar $yaml 'progress' (ConvertTo-YamlQuoted $Update.Progress)
    $yaml = Set-YamlScalar $yaml 'current_gate' (ConvertTo-YamlQuoted $Update.CurrentGate)
    $yaml = Set-YamlScalar $yaml 'priority' (ConvertTo-YamlQuoted $Update.PriorityNextWeek)
    $yaml = Set-YamlScalar $yaml 'last_verified' (ConvertTo-YamlQuoted $UpdateDate)
    $yaml = Set-YamlScalar $yaml 'source_event' (ConvertTo-YamlQuoted $SourceEventId)
    $yaml = Set-YamlScalar $yaml 'dependencies' (ConvertTo-YamlInlineArray $Update.Dependencies)
    if ($Update.VersionMigrationStatus) { $yaml = Set-YamlScalar $yaml 'version_migration_status' (ConvertTo-YamlQuoted $Update.VersionMigrationStatus) }

    $body = $parts.Body
    $block = Get-WeeklyBlock $Update
    $eventPattern = '(?s)\r?\n## Weekly Synchronization Event: ' + [regex]::Escape($SourceEventId) + '.*?(?=\r?\n' + [regex]::Escape($KnowledgeEnd) + ')'
    if ($body -match $eventPattern) {
        if (-not $Force) { return [pscustomobject]@{ File = $Update.CurrentFile; Result = 'SKIPPED'; Reason = 'source event already exists' } }
        $body = [regex]::Replace($body, $eventPattern, "`r`n$block`r`n")
    }
    else {
        $body = $body -replace [regex]::Escape($KnowledgeEnd), ("`r`n" + $block + "`r`n`r`n" + $KnowledgeEnd)
    }
    $newContent = "---`r`n$yaml`r`n---`r`n$body"
    return Write-Changed $path $newContent 'canonical metadata and managed weekly knowledge delta'
}

function Update-MemoryCard([object]$Update) {
    $path = Get-Path $Update.MemoryFile
    $parts = Get-RootFrontmatter $path
    if (-not $parts.HasFrontmatter) { throw "Memory frontmatter missing: $($Update.MemoryFile)" }
    $yaml = $parts.Yaml
    $yaml = Set-YamlScalar $yaml 'project_code' (ConvertTo-YamlQuoted $Update.Project)
    $yaml = Set-YamlScalar $yaml 'canonical_code' (ConvertTo-YamlQuoted $Update.Project)
    $yaml = Set-YamlScalar $yaml 'current_file' (ConvertTo-YamlQuoted ([System.IO.Path]::GetFileName($Update.CurrentFile)))
    $yaml = Set-YamlScalar $yaml 'primary_domain' (ConvertTo-YamlQuoted $Update.PrimaryDomain)
    $yaml = Set-YamlScalar $yaml 'lifecycle' (ConvertTo-YamlQuoted $Update.Lifecycle)
    $yaml = Set-YamlScalar $yaml 'phase' (ConvertTo-YamlQuoted $Update.Lifecycle)
    $yaml = Set-YamlScalar $yaml 'status' (ConvertTo-YamlQuoted $Update.Lifecycle)
    $yaml = Set-YamlScalar $yaml 'progress' (ConvertTo-YamlQuoted $Update.Progress)
    $yaml = Set-YamlScalar $yaml 'current_gate' (ConvertTo-YamlQuoted $Update.CurrentGate)
    $yaml = Set-YamlScalar $yaml 'current_outcome' (ConvertTo-YamlQuoted $Update.CurrentOutcome)
    $yaml = Set-YamlScalar $yaml 'latest_update_summary' (ConvertTo-YamlQuoted $Update.LatestUpdateSummary)
    $yaml = Set-YamlScalar $yaml 'known_blockers' (ConvertTo-YamlQuoted (ConvertTo-FlatText $Update.Blockers))
    $yaml = Set-YamlScalar $yaml 'known_risks' (ConvertTo-YamlQuoted (ConvertTo-FlatText $Update.Risks))
    $yaml = Set-YamlScalar $yaml 'decisions_needed' (ConvertTo-YamlQuoted (ConvertTo-FlatText $Update.DecisionsNeeded))
    $yaml = Set-YamlScalar $yaml 'next_actions' (ConvertTo-YamlQuoted (ConvertTo-FlatText $Update.NextActions))
    $yaml = Set-YamlScalar $yaml 'priority' (ConvertTo-YamlQuoted $Update.PriorityNextWeek)
    $yaml = Set-YamlScalar $yaml 'dependencies' (ConvertTo-YamlInlineArray $Update.Dependencies)
    $yaml = Set-YamlScalar $yaml 'last_verified' (ConvertTo-YamlQuoted $UpdateDate)
    $yaml = Add-YamlListValue $yaml 'recent_update_events' $SourceEventId
    if ($Update.VersionMigrationStatus) { $yaml = Set-YamlScalar $yaml 'version_migration_status' (ConvertTo-YamlQuoted $Update.VersionMigrationStatus) }

    $body = Update-DomainGovernanceBlock $parts.Body $Update
    $heading = '## Recent Update Events'
    $header = '| Date | Update Type | Summary | Source | Confidence |'
    $separator = '| --- | --- | --- | --- | --- |'
    $row = '| ' + $UpdateDate + ' | Weekly Portfolio Update | ' + (ConvertTo-CellText $Update.LatestUpdateSummary) + ' | ' + $SourceEventId + ' | Strong |'
    if ($body -notmatch [regex]::Escape($heading)) {
        $body = $body.TrimEnd() + "`r`n`r`n$heading`r`n`r`n$header`r`n$separator`r`n$row`r`n"
    }
    elseif ($body -notmatch [regex]::Escape($SourceEventId)) {
        $tablePattern = '(?s)(' + [regex]::Escape($heading) + '.*?\|\s*---.*?\|\r?\n)'
        $body = [regex]::Replace($body, $tablePattern, '$1' + $row + "`r`n", 1)
    }
    elseif ($Force) {
        $body = [regex]::Replace($body, '(?m)^\|\s*' + [regex]::Escape($UpdateDate) + '.*?' + [regex]::Escape($SourceEventId) + '.*?\|\r?$', $row)
    }
    return Write-Changed $path ("---`r`n$yaml`r`n---`r`n$body") 'memory metadata, governance state and recent event'
}

function Test-RowMatchesUpdate([object]$Update, [string[]]$Cells) {
    $text = $Cells -join '|'
    $base = [System.IO.Path]::GetFileNameWithoutExtension($Update.CurrentFile)
    $leaf = [System.IO.Path]::GetFileName($Update.CurrentFile)
    return ($text -like "*$($Update.Project)*" -or $text -like "*$($Update.PreviousCanonicalCode)*" -or $text -like "*$base*" -or $text -like "*$leaf*")
}

function Update-TableRows([string]$Path, [scriptblock]$TableUpdater, [string]$Reason) {
    $lines = @(Get-Content -LiteralPath $Path -Encoding UTF8)
    $changed = $false
    $matchedProjects = @{}
    for ($index = 0; $index -lt $lines.Count; $index++) {
        if ($lines[$index] -notmatch '^\s*\|') { continue }
        $headers = @((Split-TableRow $lines[$index]) | ForEach-Object { $_.Trim() })
        if ($index + 1 -ge $lines.Count -or $lines[$index + 1] -notmatch '^\s*\|\s*[-:]') { continue }
        for ($rowIndex = $index + 2; $rowIndex -lt $lines.Count; $rowIndex++) {
            if ($lines[$rowIndex] -notmatch '^\s*\|') { break }
            $cells = Split-TableRow $lines[$rowIndex]
            foreach ($update in $WeeklyProjectUpdates) {
                if (-not (Test-RowMatchesUpdate $update $cells)) { continue }
                $before = $lines[$rowIndex]
                $cells = & $TableUpdater $update $cells $headers
                $lines[$rowIndex] = Join-TableRow $cells
                if ($lines[$rowIndex] -ne $before) { $changed = $true }
                $matchedProjects[$update.Project] = $true
                break
            }
        }
    }
    if ($changed) { return Write-Changed $Path ($lines -join "`r`n") $Reason }
    return [pscustomobject]@{ File = $Path; Result = 'UNCHANGED'; Reason = $Reason }
}

function Update-MemoryIndex {
    return Update-TableRows $MemoryIndexPath {
        param($update, $cells, $headers)
        if ($headers -contains 'Project' -and $headers -contains 'Memory Card' -and $headers -contains 'Project Note') {
            $cells = Set-TableCell $cells $headers 'Project' (Get-CanonicalLink $update)
            $cells = Set-TableCell $cells $headers 'Project Note' ('[[' + [System.IO.Path]::GetFileNameWithoutExtension($update.CurrentFile) + ']]')
            $cells = Set-TableCell $cells $headers 'Phase' $update.Lifecycle
            $cells = Set-TableCell $cells $headers 'Priority' $update.PriorityNextWeek
            $cells = Set-TableCell $cells $headers 'Current Outcome' $update.CurrentOutcome
            $cells = Set-TableCell $cells $headers 'Latest Update' $SourceEventId
            $cells = Set-TableCell $cells $headers 'Last Verified' $UpdateDate
        }
        elseif ($headers -contains 'Canonical Code' -and $headers -contains 'Current File' -and $headers -contains 'Current Gate') {
            $cells = Set-TableCell $cells $headers 'Canonical Code' $update.Project
            $cells = Set-TableCell $cells $headers 'Current File' ([System.IO.Path]::GetFileName($update.CurrentFile))
            $cells = Set-TableCell $cells $headers 'Primary Domain' $update.PrimaryDomain
            $cells = Set-TableCell $cells $headers 'Lifecycle' $update.Lifecycle
            $cells = Set-TableCell $cells $headers 'Progress' $update.Progress
            $cells = Set-TableCell $cells $headers 'Current Gate' $update.CurrentGate
        }
        return $cells
    } 'memory index and governance overlay synchronization'
}

function Update-RegistryFile {
    return Update-TableRows $RegistryPath {
        param($update, $cells, $headers)
        if ($headers -contains 'Project Name' -and $headers -contains 'Canonical Filename' -and $headers -contains 'Status / Priority') {
            $cells = Set-TableCell $cells $headers 'Project Name' $update.Project
            $cells = Set-TableCell $cells $headers 'Canonical Filename' ([System.IO.Path]::GetFileName($update.CurrentFile))
            $cells = Set-TableCell $cells $headers 'Phase' $update.Lifecycle
            $cells = Set-TableCell $cells $headers 'Department' $update.PrimaryDomain
            $cells = Set-TableCell $cells $headers 'Status / Priority' ($update.CurrentGate + ' / ' + $update.PriorityNextWeek)
            $cells = Set-TableCell $cells $headers 'Progress' $update.Progress
            $cells = Set-TableCell $cells $headers 'Blocker' $(if ($update.Blockers.Count) { $update.Blockers[0] } else { 'TBD' })
            $cells = Set-TableCell $cells $headers 'Decision Needed' $update.DecisionsNeeded[0]
            $cells = Set-TableCell $cells $headers 'Next Action' $update.NextActions[0]
            $cells = Set-TableCell $cells $headers 'Source File' ([System.IO.Path]::GetFileName($update.CurrentFile))
        }
        elseif ($headers -contains 'Canonical Code' -and $headers -contains 'Current File' -and $headers -contains 'Status / Gate') {
            $cells = Set-TableCell $cells $headers 'Project Name' $update.Project
            $cells = Set-TableCell $cells $headers 'Canonical Code' $update.Project
            $cells = Set-TableCell $cells $headers 'Current File' ([System.IO.Path]::GetFileName($update.CurrentFile))
            $cells = Set-TableCell $cells $headers 'Primary Domain' $update.PrimaryDomain
            $cells = Set-TableCell $cells $headers 'Lifecycle' $update.Lifecycle
            $cells = Set-TableCell $cells $headers 'Progress' $update.Progress
            $cells = Set-TableCell $cells $headers 'Status / Gate' $update.CurrentGate
        }
        return $cells
    } 'project registry and domain overlay synchronization'
}

function Update-DomainAssignmentMatrix {
    return Update-TableRows $DomainMatrixPath {
        param($update, $cells, $headers)
        if ($headers -contains 'Canonical Code' -and $headers -contains 'Current File' -and $headers -contains 'Status / Gate') {
            $cells = Set-TableCell $cells $headers 'Canonical Code' $update.Project
            $cells = Set-TableCell $cells $headers 'Current File' ([System.IO.Path]::GetFileName($update.CurrentFile))
            $cells = Set-TableCell $cells $headers 'Primary Domain' $update.PrimaryDomain
            $cells = Set-TableCell $cells $headers 'Lifecycle' $update.Lifecycle
            $cells = Set-TableCell $cells $headers 'Progress' $update.Progress
            $cells = Set-TableCell $cells $headers 'Status / Gate' $update.CurrentGate
            $cells = Set-TableCell $cells $headers 'Owner / Primary Users' $update.Ownership
            $cells = Set-TableCell $cells $headers 'Confidence' $update.Confidence
        }
        return $cells
    } 'official domain assignment synchronization'
}

function Update-ResourceMatrixFile {
    return Update-TableRows $ResourceMatrixPath {
        param($update, $cells, $headers)
        if ($headers -contains 'Canonical Project Name' -and $headers -contains 'Phase / Progress' -and $headers -contains 'Current Priority') {
            $cells = Set-TableCell $cells $headers 'Canonical Project Name' (Get-CanonicalLink $update)
            $cells = Set-TableCell $cells $headers 'Phase / Progress' ($update.Lifecycle + ' / ' + $update.Progress)
            $cells = Set-TableCell $cells $headers 'Business Stakeholder / Department' $update.Ownership
            $cells = Set-TableCell $cells $headers 'Current Priority' $update.PriorityNextWeek
            $cells = Set-TableCell $cells $headers 'Blocker' $(if ($update.Blockers.Count) { $update.Blockers[0] } else { 'TBD' })
            $cells = Set-TableCell $cells $headers 'Decision Needed' $update.DecisionsNeeded[0]
            $cells = Set-TableCell $cells $headers 'Next Action' $update.NextActions[0]
            $cells = Set-TableCell $cells $headers 'Source File' ([System.IO.Path]::GetFileName($update.CurrentFile))
        }
        elseif ($headers -contains 'Current File' -and $headers -contains 'Lifecycle / Progress' -and $headers -contains 'Current Gate') {
            $cells = Set-TableCell $cells $headers 'Canonical Project Name' $update.Project
            $cells = Set-TableCell $cells $headers 'Current File' ([System.IO.Path]::GetFileName($update.CurrentFile))
            $cells = Set-TableCell $cells $headers 'Primary Domain' $update.PrimaryDomain
            $cells = Set-TableCell $cells $headers 'Lifecycle / Progress' ($update.Lifecycle + ' / ' + $update.Progress)
            $cells = Set-TableCell $cells $headers 'Owner / Primary Users' $update.Ownership
            $cells = Set-TableCell $cells $headers 'Current Gate' $update.CurrentGate
        }
        return $cells
    } 'resource matrix explicit ownership synchronization'
}

function Update-ModuleIndexFile {
    if (-not (Test-Path -LiteralPath $ModuleIndexPath)) { return [pscustomobject]@{ File = $ModuleIndexPath; Result = 'SKIPPED'; Reason = 'module index not present' } }
    $content = Get-Utf8 $ModuleIndexPath
    $replacements = @{
        '[[PUR.GDI Automation]]' = '[[PUR.GDI Automation|PUR.GDI.Automation.v1.0]]'
        '[[PUR.Inventory Report]]' = '[[PUR.Inventory Report|PUR.Inventory.Report.v2.1]]'
        '[[PPJ.COSTING.AGENT.PLATFORM.v1.1]]' = '[[PPJ.COSTING.AGENT.PLATFORM.v1.1|COSTING.AGENTIC.PLATFORM.v1.1]]'
        '[[TD.TechnicalPlatform_v2.1]]' = '[[TD.TechnicalPlatform_v2.1|TD.TechnicalKnowledge.Platform.v2.1]]'
        '[[PPJxNUNOX]]' = '[[PPJxNUNOX|PPJxNUNOX.ScanTrial]]'
        '[[PPJxQSee.ai]]' = '[[PPJxQSee.ai|PPJxQSee.AI]]'
        '[[PPJxStratova AI]]' = '[[PPJxStratova AI|PPJxStratova.AI]]'
    }
    foreach ($key in $replacements.Keys) { $content = $content.Replace($key, $replacements[$key]) }
    $financeLink = '- [[FIN.AI.FINANCE.MANAGEMENT.v1.1|FIN.AI.FINANCE.MANAGEMENT.v1.2]]'
    if ($content -notmatch [regex]::Escape($financeLink)) {
        $content = $content -replace '(?m)(^## Accounting / Invoice Automation\r?\n)', ('$1' + "`r`n" + $financeLink + "`r`n")
    }
    return Write-Changed $ModuleIndexPath $content 'affected module links and Finance module entry'
}

function Update-LedgerFile {
    $content = Get-Utf8 $LedgerPath
    if ($content -match [regex]::Escape($SourceEventId)) {
        if (-not $Force) { return [pscustomobject]@{ File = $LedgerPath; Result = 'SKIPPED'; Reason = 'source event already exists' } }
        $content = (@($content -split "`r?`n") | Where-Object { $_ -notmatch [regex]::Escape($SourceEventId) }) -join "`r`n"
    }
    $rows = @()
    foreach ($update in $WeeklyProjectUpdates) {
        $rows += '| ' + $UpdateDate + ' | ' + $update.Project + ' | weekly_sync | ' + (ConvertTo-CellText $update.LatestUpdateSummary) + ' | canonical / lifecycle / progress / gate / priority / dependencies | prior current state | ' + (ConvertTo-CellText ($update.Lifecycle + '; ' + $update.Progress + '; ' + $update.CurrentGate + '; ' + $update.PriorityNextWeek)) + ' | ' + $SourceEventId + ' | Strong | memory / note / registry / domain / resource | ' + (ConvertTo-CellText $update.NextActions[0]) + ' |'
        if ($update.Project -ne $update.PreviousCanonicalCode) {
            $rows += '| ' + $UpdateDate + ' | ' + $update.Project + ' | canonical_mapping | Weekly canonical code updated while physical file is retained. | canonical_code / current_file | ' + $update.PreviousCanonicalCode + ' | ' + $update.Project + ' / ' + [System.IO.Path]::GetFileName($update.CurrentFile) + ' / ' + $update.VersionMigrationStatus + ' | ' + $SourceEventId + ' | Strong | memory / note / registry / domain / resource | Do not rename the physical file in this task. |'
        }
    }
    $rows += '| ' + $UpdateDate + ' | Accounting Inventory Report | backlog_candidate | Proposed Accounting inventory-control report; no active root project created. | candidate status | none | Pending Resource / Pending Registration Approval | ' + $SourceEventId + ' | Strong | proposal only | Complete registration clarifications and resourcing decision. |'
    return Write-Changed $LedgerPath ($content.TrimEnd() + "`r`n" + ($rows -join "`r`n") + "`r`n") 'weekly project, canonical mapping and backlog events'
}

function Get-UpdateByProject([string]$Project) { return $WeeklyProjectUpdates | Where-Object { $_.Project -eq $Project } | Select-Object -First 1 }

function Write-TaskFile([object]$Task) {
    $update = Get-UpdateByProject $Task.Project
    $name = 'TASK_' + $Task.Project + '_' + $SourceEventId + '_' + $Task.Slug + '.md'
    $path = Join-Path $TaskDir $name
    if ((Test-Path -LiteralPath $path) -and -not $Force) { return [pscustomobject]@{ File = $path; Result = 'SKIPPED'; Reason = 'task already exists' } }
    $content = @"
---
type: task
created: "$UpdateDate"
project: "$($Task.Project)"
lane: "TASKS / DOCS TO UPDATE"
status: "Open"
priority: "$($Task.Priority)"
source_event: "$SourceEventId"
---

# $($Task.Title)

Project
$((Get-CanonicalLink $update))

Outcome
$($update.RequiredOutput)

Next Action
$($update.NextActions[0])

Dependencies
$($update.Dependencies -join "`r`n- ")

Source / Context
$Evidence

Validation
Required output is reviewed by the named business owner or explicitly marked Needs Confirmation.
"@
    return Write-Changed $path $content 'deterministic grouped task'
}

function Get-DecisionContext([object]$Decision) {
    $update = Get-UpdateByProject $Decision.Project
    if ($null -ne $update) {
        return [pscustomobject]@{ Context = $update.LatestUpdateSummary; Decision = ($update.DecisionsNeeded -join ' | '); Next = $update.NextActions[0] }
    }
    return [pscustomobject]@{ Context = $BacklogCandidate.Goal; Decision = 'Approve registration and resourcing, or keep as backlog candidate.'; Next = 'Complete required clarifications before project registration.' }
}

function Write-DecisionFile([object]$Decision) {
    $path = Join-Path $DecisionDir ($Decision.Id + '.md')
    if ((Test-Path -LiteralPath $path) -and -not $Force) { return [pscustomobject]@{ File = $path; Result = 'SKIPPED'; Reason = 'decision already exists' } }
    $context = Get-DecisionContext $Decision
    $content = @"
---
type: decision
id: "$($Decision.Id)"
date: "$UpdateDate"
project: "$($Decision.Project)"
status: "Pending"
owner: "$($Decision.Owner)"
source_event: "$SourceEventId"
---

# $($Decision.Title)

## Decision Required

$($context.Decision)

## Context

$($context.Context)

## Evidence

$Evidence

## Next Step

$($context.Next)
"@
    return Write-Changed $path $content 'deterministic material decision'
}

function Update-DecisionIndexFile {
    $content = Get-Utf8 $DecisionIndexPath
    foreach ($decision in $DecisionGroups) {
        $row = '| ' + $decision.Id + ' | ' + $decision.Title + ' | ' + $UpdateDate + ' | ' + $decision.Owner + ' | ' + $decision.Project + ' | [[' + $decision.Id + ']] |'
        if ($content -notmatch [regex]::Escape($decision.Id)) { $content = $content.TrimEnd() + "`r`n" + $row }
    }
    return Write-Changed $DecisionIndexPath ($content.TrimEnd() + "`r`n") 'decision index synchronization'
}

function Get-ProposalContent {
    $clarifications = ($BacklogCandidate.RequiredClarifications | ForEach-Object { '- ' + $_ }) -join "`r`n"
    return @"
---
type: project_update_proposal
proposal_date: "$UpdateDate"
source_event: "$SourceEventId"
proposed_canonical_code: "$($BacklogCandidate.ProposedCanonicalCode)"
primary_domain: "$($BacklogCandidate.PrimaryDomain)"
lifecycle: "$($BacklogCandidate.Lifecycle)"
progress: "$($BacklogCandidate.Progress)"
status: "$($BacklogCandidate.Status)"
registration_approved: false
---

# Accounting Inventory Report Proposal

## Proposed Canonical Code

$($BacklogCandidate.ProposedCanonicalCode)

## Domain

$($BacklogCandidate.PrimaryDomain)

## Business Problem

$($BacklogCandidate.Goal)

## Potential Scope

- Accounting inventory control and financial baseline.
- Closing-period logic and inventory valuation.
- Inventory aging and reconciliation.
- Accounting-specific control questions and acceptance criteria.

## Relationship with Purchasing Inventory Report

PUR.Inventory.Report.v2.1 serves Purchasing and material-planning visibility. This proposal may require different finance logic, grain, source, closing period and valuation controls. It must not be assumed to be another Purchasing-report tab.

## Information Required Before Registration

$clarifications

## Status

Pending Resource / Pending Registration Approval.

No active root project note is created by this weekly synchronization.
"@
}

function Get-CommandCenterBlock {
    $priorities = ($WeeklyProjectUpdates | Sort-Object { [int](($_.PriorityNextWeek -replace '^P(\d+).*','$1') -as [int]) } | ForEach-Object { '- ' + $_.PriorityNextWeek + ' - ' + (Get-CanonicalLink $_) + ': ' + $_.RequiredOutput }) -join "`r`n"
    return @"
## Current Priority Plan

- Reporting period: $ReportingPeriod
- Next planning period: $PlanningPeriod
- Source event: $SourceEventId

### P1-P11

$priorities

### Portfolio-level Blockers

- Databricks access governance blocks practical Finance validation and may affect Technical, Costing and reporting initiatives.
- GDI transactions require WFX or another approved transactional service; unapproved Databricks writes are prohibited.
- HR rollout requires confirmed production ownership.
- Technical ETL requires business data acceptance.

### Lifecycle Watch

- Rollout: HR.SSPFD.Workflow.v1.1.
- Closeout preparation: SCP.SOURCING.CHATBOT.v2.3.
- Production/support: PUR.Inventory.Report.v2.1.
- Closed opportunity under review: PPJxStratova.AI.
- On hold: PPJxQSee.AI.

### Backlog / Candidate

- Accounting Inventory Report - Pending Resource / Pending Registration Approval; no root note created.
"@
}

function Update-CommandCenterFile {
    $content = Get-Utf8 $CommandCenterPath
    $block = Get-CommandCenterBlock
    $pattern = '(?ms)^## Current Priority Plan\r?\n.*?(?=^## |\z)'
    if ($content -match $pattern) { $content = [regex]::Replace($content, $pattern, $block + "`r`n`r`n") }
    else { $content = $content.TrimEnd() + "`r`n`r`n" + $block + "`r`n" }
    return Write-Changed $CommandCenterPath $content 'compact current-priority command-center section'
}

function Get-WeeklyReportContent {
    $source = Get-Utf8 $WeeklySourcePath
    $frontmatter = @"
---
type: weekly_portfolio_report
reporting_period: "$ReportingPeriod"
planning_period: "$PlanningPeriod"
source_event: "$SourceEventId"
evidence: "$Evidence"
last_verified: "$UpdateDate"
---

"@
    return $frontmatter + $source.TrimStart([char]0xFEFF)
}

function Get-ApplyReportContent([object[]]$Results, [string[]]$HardStops, [object[]]$IdempotencyFindings) {
    $resultText = ($Results | ForEach-Object { '- [' + $_.Result + '] ' + $_.File + ' - ' + $_.Reason }) -join "`r`n"
    $idempotencyText = if ($IdempotencyFindings.Count) { ($IdempotencyFindings | ForEach-Object { '- ' + $_.Path + ': ' + $_.Count }) -join "`r`n" } else { '- No existing source-event references before Apply.' }
    $physical = ($WeeklyProjectUpdates | ForEach-Object { '- ' + $_.Project + ' -> ' + $_.CurrentFile + ' / ' + $_.MemoryFile }) -join "`r`n"
    return @"
# PPJ Weekly Portfolio Update Apply Report

- Source Event: $SourceEventId
- Reporting Period: $ReportingPeriod
- Next Planning Period: $PlanningPeriod
- Applied: $Apply
- Root-backed Projects Resolved: $($WeeklyProjectUpdates.Count)
- Backlog Candidates: 1
- Canvas Updated: No
- Hard Stops: $($HardStops.Count)
- Backup Folder: $BackupRoot

## Canonical and Physical Resolution

$physical

## Backlog Candidate

Accounting Inventory Report remains proposal-only. No active root project note was created.

## Idempotency Findings Before Apply

$idempotencyText

## Results

$resultText

## Protected State Validation

- Finance uses weekly canonical v1.2 while retaining FIN.AI.FINANCE.MANAGEMENT.v1.1.md; migration is Pending Confirmation.
- HR records completed UAT and group rollout and is not Closed.
- GDI uses API-first WFX transaction architecture and prohibits unapproved Databricks transaction writes.
- Technical ETL is complete for identified sources, but business data acceptance is pending.
- Costing Wash remains a workstream under COSTING.AGENTIC.PLATFORM.v1.1.
- Sourcing remains consolidated; external-data standardization is a backlog workstream.
- PUR.Inventory.Report.v2.1 retains PUR.Inventory Report.md as its physical file.
- Stratova remains a closed project with a new opportunity under review.
- QSee is On Hold due to internal resource constraints.
- Canvas was not updated.
"@
}

function Get-TargetPathsForBackup {
    $paths = @()
    if ($UpdateMemory) { $paths += @($WeeklyProjectUpdates | ForEach-Object { Get-Path $_.MemoryFile }) }
    if ($UpdateProjectNotes) { $paths += @($WeeklyProjectUpdates | ForEach-Object { Get-Path $_.CurrentFile }) }
    if ($UpdateRegistry) { $paths += @($MemoryIndexPath, $RegistryPath, $ModuleIndexPath) }
    if ($UpdateDomainMatrix) { $paths += $DomainMatrixPath }
    if ($UpdateResourceMatrix) { $paths += $ResourceMatrixPath }
    if ($UpdateLedger) { $paths += $LedgerPath }
    if ($UpdateCommandCenter) { $paths += $CommandCenterPath }
    if ($CreateTasks) { $paths += @($TaskGroups | ForEach-Object { Join-Path $TaskDir ('TASK_' + $_.Project + '_' + $SourceEventId + '_' + $_.Slug + '.md') }) }
    if ($CreateDecisions) { $paths += @($DecisionGroups | ForEach-Object { Join-Path $DecisionDir ($_.Id + '.md') }); $paths += $DecisionIndexPath }
    if ($CreateWeeklyReport) { $paths += @($WeeklyReportPath, $ApplyReportPath, $ProposalPath) }
    return @($paths | Select-Object -Unique)
}

$idempotencyFindings = @(Get-SourceEventReferences)
$hardStops = @(Test-HardStops)

Write-Host "PPJ Weekly Portfolio Knowledge Synchronization"
Write-Host "Mode: $(if ($DryRun) { 'DRYRUN' } else { 'APPLY' })"
Write-Host "Source Event: $SourceEventId"
Write-Host "Affected root-backed projects: $($WeeklyProjectUpdates.Count)"
foreach ($update in $WeeklyProjectUpdates) {
    $memoryParts = Get-RootFrontmatter (Get-Path $update.MemoryFile)
    $oldLifecycle = Get-YamlScalar $memoryParts.Yaml 'lifecycle'
    $oldProgress = Get-YamlScalar $memoryParts.Yaml 'progress'
    $oldPriority = Get-YamlScalar $memoryParts.Yaml 'priority'
    Write-Host ("- {0} -> {1} | memory={2}" -f $update.Project, $update.CurrentFile, $update.MemoryFile)
    Write-Host ("  lifecycle: {0} -> {1}" -f $oldLifecycle, $update.Lifecycle)
    Write-Host ("  progress: {0} -> {1}" -f $oldProgress, $update.Progress)
    Write-Host ("  priority: {0} -> {1}" -f $oldPriority, $update.PriorityNextWeek)
    Write-Host ("  gate: {0}" -f $update.CurrentGate)
}
Write-Host "Backlog candidate: Accounting Inventory Report -> proposal only"
Write-Host "Proposal path: $ProposalPath"
Write-Host "Memory cards planned: $($WeeklyProjectUpdates.Count)"
Write-Host "Project notes planned: $($WeeklyProjectUpdates.Count)"
Write-Host "Registry/index files planned: PPJ_PROJECT_MEMORY_INDEX.md, PPJ_PROJECT_REGISTRY.md, PPJ_PROJECT_MODULE_INDEX.md"
Write-Host "Domain matrix planned: $UpdateDomainMatrix"
Write-Host "Resource matrix planned: $UpdateResourceMatrix"
Write-Host "Command center planned: $UpdateCommandCenter"
Write-Host "Ledger events planned: 14 (11 project + 2 canonical mappings + 1 backlog candidate)"
Write-Host "Grouped tasks planned: $($TaskGroups.Count)"
foreach ($task in $TaskGroups) { Write-Host "- $($task.Title)" }
Write-Host "Decision logs planned: $($DecisionGroups.Count)"
foreach ($decision in $DecisionGroups) { Write-Host "- $($decision.Title)" }
Write-Host "Weekly report plan: copy approved Vietnamese management source with traceability frontmatter"
Write-Host "Backup plan: $BackupRoot"
Write-Host "Canvas update planned: No"
Write-Host "Existing source-event references: $($idempotencyFindings.Count)"
foreach ($finding in $idempotencyFindings) { Write-Host "- $($finding.Path): $($finding.Count)" }
Write-Host "Hard stops: $($hardStops.Count)"
foreach ($hardStop in $hardStops) { Write-Host "- $hardStop" }

if ($hardStops.Count -gt 0) { exit 2 }
if ($DryRun) { Write-Host "DryRun PASS. No files modified."; exit 0 }

$targets = @(Get-TargetPathsForBackup)
if (-not (Test-Path -LiteralPath $BackupRoot)) { New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null }
if (-not (Test-Path -LiteralPath $BackupRoot)) { throw "Backup folder could not be created." }
foreach ($target in $targets) { if (Test-Path -LiteralPath $target) { Backup-File $target } }

$results = @()
if ($UpdateMemory) { foreach ($update in $WeeklyProjectUpdates) { $results += Update-MemoryCard $update } }
if ($UpdateProjectNotes) { foreach ($update in $WeeklyProjectUpdates) { $results += Update-ProjectNote $update } }
if ($UpdateRegistry) { $results += Update-MemoryIndex; $results += Update-RegistryFile; $results += Update-ModuleIndexFile }
if ($UpdateDomainMatrix) { $results += Update-DomainAssignmentMatrix }
if ($UpdateResourceMatrix) { $results += Update-ResourceMatrixFile }
if ($UpdateLedger) { $results += Update-LedgerFile }
if ($UpdateCommandCenter) { $results += Update-CommandCenterFile }
if ($CreateTasks) { foreach ($task in $TaskGroups) { $results += Write-TaskFile $task } }
if ($CreateDecisions) { foreach ($decision in $DecisionGroups) { $results += Write-DecisionFile $decision }; $results += Update-DecisionIndexFile }
if ($CreateWeeklyReport) {
    $results += Write-Changed $ProposalPath (Get-ProposalContent) 'Accounting Inventory proposal-only record'
    $results += Write-Changed $WeeklyReportPath (Get-WeeklyReportContent) 'Vietnamese management-ready weekly report'
}
$results += Write-Changed $ApplyReportPath (Get-ApplyReportContent $results $hardStops $idempotencyFindings) 'weekly Apply report'

$operationLog = "# PPJ Weekly Progress Operation Log`r`n`r`n- Source Event: $SourceEventId`r`n- Timestamp: $Stamp`r`n- Backup: $BackupRoot`r`n- Canvas Updated: No`r`n`r`n## Results`r`n`r`n" + (($results | ForEach-Object { '- [' + $_.Result + '] ' + $_.File + ' - ' + $_.Reason }) -join "`r`n")
Set-Utf8 $OperationLogPath $operationLog

Write-Host "Apply completed."
Write-Host "Backup folder: $BackupRoot"
Write-Host "Operation log: $OperationLogPath"
Write-Host "Weekly report: $WeeklyReportPath"
Write-Host "Apply report: $ApplyReportPath"
Write-Host "Proposal: $ProposalPath"
foreach ($result in $results) { Write-Host ("[{0}] {1} - {2}" -f $result.Result, $result.File, $result.Reason) }
