param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [string]$ProjectName
)

$ErrorActionPreference = "Stop"

if (-not $Apply) { $DryRun = $true }

$vaultRoot = (Get-Location).Path
$projectRoot = Join-Path $vaultRoot "03_Projects"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$today = Get-Date -Format "yyyy-MM-dd"
$backupRoot = Join-Path $auditRoot "Project_Note_Population_Backup\$stamp"
$logPath = Join-Path $auditRoot "PROJECT_NOTE_POPULATION_LOG_$stamp.md"

$managedStart = "<!-- PPJ_PROJECT_DETAIL_MANAGED_START -->"
$managedEnd = "<!-- PPJ_PROJECT_DETAIL_MANAGED_END -->"

$canonicalFiles = @(
    "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md",
    "ACC.GRN-SupplierInvoiceBot.v1.1.md",
    "AI Automation Workshop.md",
    "E-commerce Market Intelligence.md",
    "FD.Datamart.v2.2.md",
    "HR.SS&PFD.v1.1.md",
    "MER.PO-Commit.md",
    "PPJ XPrimo1D RFID Thread.md",
    "PPJ. Expense-Invoices.v1.1.md",
    "PPJ.AI.Hub.v2.1.md",
    "PPJ.COSTING.AGENT.PLATFORM.v1.1.md",
    "PPJ.GLPI-Helpdesk-AI Chatbot.md",
    "PPJ.Invoice Downloader.v1.2.md",
    "PPJ.PERRI.Chatbot.md",
    "PPJxNUNOX.md",
    "PPJxQSee.ai.md",
    "PPJxStratova AI.md",
    "PROD.COWASH.md",
    "PROD.IOT.CHuyenTreo_1.md",
    "PROJECT_COMMAND_CENTER.md",
    "PUR.Adhoc Indent mien Nam.md",
    "PUR.GDI Automation.md",
    "PUR.H&M Label-O Processing.md",
    "PUR.Inventory Report.md",
    "PUR.Material.Allocation.v1.1.md",
    "SCP.SOURCING.CHATBOT.v2.3.md",
    "TD.TechnicalPlatform_v2.1.md",
    "VITAS Sharing.md",
    "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md",
    "Workshop Analysis.md"
)

$moduleProjects = @(
    "SCP.SOURCING.CHATBOT.v2.3",
    "PPJ.PERRI.Chatbot",
    "PPJ.GLPI-Helpdesk-AI Chatbot",
    "PPJ.Invoice Downloader.v1.2",
    "PPJ. Expense-Invoices.v1.1",
    "ACC.GRN-SupplierInvoiceBot.v1.1",
    "PUR.GDI Automation",
    "PUR.Material.Allocation.v1.1",
    "TD.TechnicalPlatform_v2.1"
)

$seed = @{
    "ACC.GRN-SupplierInvoiceBot.v1.1.md" = @{ Summary="Accounting GRN and supplier invoice automation. Helps automate GRN and supplier invoice processing."; Department="Accounting"; Cluster="Accounting / Invoice Automation"; Confidence="Inferred from prior governance discussion"; Type="internal automation" }
    "PPJ. Expense-Invoices.v1.1.md" = @{ Summary="EXIM-first expense invoice entry automation for the current v1.1 implementation. Future v2 may expand to all departments and factories, but no v2 note should be created yet."; Department="EXIM / Accounting"; Cluster="Accounting / Invoice Automation"; Confidence="Supported by governance notes"; Type="internal automation" }
    "PPJ.Invoice Downloader.v1.2.md" = @{ Summary="VNPT/supplier e-invoice download and merging tool supporting invoice retrieval, XML/PDF handling, and accounting/EXIM workflow."; Department="Accounting / EXIM / Purchasing"; Cluster="Accounting / Invoice Automation"; Confidence="Inferred from prior governance discussion"; Type="internal automation" }
    "SCP.SOURCING.CHATBOT.v2.3.md" = @{ Summary="Sourcing chatbot and sourcing data management platform supporting supplier, material, fabric, trims, sample, and sourcing lookup."; Department="Sourcing"; Cluster="Sourcing / Material / Supplier Data"; Confidence="Supported by vault governance"; Type="chatbot / data platform" }
    "PPJ.PERRI.Chatbot.md" = @{ Summary="PERRI chatbot/orchestrator concept for document Q&A, data lookup, and possible workflow triggers."; Department="TBD"; Cluster="AI Platform / Chatbots / Hub"; Confidence="Inferred from prior governance discussion"; Type="chatbot" }
    "PPJ.GLPI-Helpdesk-AI Chatbot.md" = @{ Summary="Helpdesk AI chatbot for GLPI support and IT service desk assistance."; Department="IT / Helpdesk"; Cluster="AI Platform / Chatbots / Hub"; Confidence="Inferred from filename and prior governance discussion"; Type="chatbot" }
    "PUR.Material.Allocation.v1.1.md" = @{ Summary="Purchasing/material allocation workflow with likely WFX dependency and process clarity requirements."; Department="Purchasing / Sourcing"; Cluster="Purchasing Automation"; Confidence="Supported by registry/resource matrix"; Type="workflow automation" }
    "PUR.GDI Automation.md" = @{ Summary="Purchasing GDI automation with likely WFX/input standardization dependency."; Department="Purchasing"; Cluster="Purchasing Automation"; Confidence="Supported by registry/resource matrix"; Type="workflow automation" }
    "PUR.H&M Label-O Processing.md" = @{ Summary="H&M label processing automation or workflow support. Exact scope needs confirmation."; Department="Production / QC / Purchasing"; Cluster="Purchasing Automation"; Confidence="Needs Confirmation"; Type="workflow automation" }
    "PUR.Inventory Report.md" = @{ Summary="Purchasing inventory report automation/reporting project."; Department="Purchasing"; Cluster="Purchasing Automation"; Confidence="Inferred from filename and resource matrix"; Type="reporting" }
    "PUR.Adhoc Indent mien Nam.md" = @{ Summary="Adhoc indent automation/support for miền Nam regional purchasing workflow."; Department="Purchasing"; Cluster="Purchasing Automation"; Confidence="Supported by resource matrix"; Type="workflow support" }
    "MER.PO-Commit.md" = @{ Summary="PO Commit project for merchandising/customer commitment workflow. Exact production/support or rollout context needs confirmation."; Department="MER / Purchasing"; Cluster="Merchandising / Costing"; Confidence="Inferred from filename and resource matrix"; Type="workflow governance" }
    "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md" = @{ Summary="MER-owned Chico's invoice/costing recheck/audit project. Do not classify as purely Accounting unless evidence proves it."; Department="MER / Accounting"; Cluster="Merchandising / Costing"; Confidence="Supported by business correction"; Type="audit / recheck" }
    "PPJ.COSTING.AGENT.PLATFORM.v1.1.md" = @{ Summary="Costing agentic platform for costing intelligence and costing workflow support."; Department="MER"; Cluster="Merchandising / Costing"; Confidence="Inferred from filename and resource matrix"; Type="agentic platform" }
    "E-commerce Market Intelligence.md" = @{ Summary="Market intelligence/dashboard/forecast/external market analysis concept for e-commerce or market exploration."; Department="MER"; Cluster="Merchandising / Costing"; Confidence="Supported by registry"; Type="market intelligence" }
    "FD.Datamart.v2.2.md" = @{ Summary="FD/fabric/datamart/hanger or fabric database-related data project. Exact scope requires confirmation."; Department="FD"; Cluster="Sourcing / Material / Supplier Data"; Confidence="Needs Confirmation"; Type="data platform" }
    "PROD.COWASH.md" = @{ Summary="Production/COWASH project related to wash/factory process. Exact business process requires confirmation."; Department="R&D Wash / Factory"; Cluster="Production / Factory / IoT / Wash"; Confidence="Supported by resource matrix, scope needs confirmation"; Type="factory / wash workflow" }
    "PROD.IOT.CHuyenTreo_1.md" = @{ Summary="Production IoT chuyền treo project/dashboard for factory or line monitoring context."; Department="Factory"; Cluster="Production / Factory / IoT / Wash"; Confidence="Supported by resource matrix"; Type="IoT dashboard" }
    "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md" = @{ Summary="R&D/Wash sampling management portal for managing sampling workflow across PPJ group."; Department="R&D Wash"; Cluster="Production / Factory / IoT / Wash"; Confidence="Supported by vault instructions"; Type="portal / workflow" }
    "HR.SS&PFD.v1.1.md" = @{ Summary="HR-related project. Exact meaning of SS&PFD needs confirmation from business owner."; Department="HR"; Cluster="HR"; Confidence="Needs Confirmation"; Type="HR workflow" }
    "PPJ.AI.Hub.v2.1.md" = @{ Summary="Central AI tools, bots, chatbots, automation apps, and internal hub. Links to modules but does not merge projects."; Department="AI Team / Management"; Cluster="AI Platform / Chatbots / Hub"; Confidence="Supported by governance notes"; Type="platform / hub" }
    "TD.TechnicalPlatform_v2.1.md" = @{ Summary="Technical/data/knowledge platform foundation for AI automation team. Role as platform source or technical backbone needs confirmation."; Department="Data / CPD / AI"; Cluster="AI Platform / Chatbots / Hub"; Confidence="Supported by resource matrix, scope needs confirmation"; Type="technical platform" }
    "PPJxNUNOX.md" = @{ Summary="External vendor/partnership note for NUNOX."; Department="Factory / Warehouse"; Cluster="External Vendors / Partnerships"; Confidence="Supported by resource matrix"; Type="external engagement" }
    "PPJxQSee.ai.md" = @{ Summary="External vendor/partnership note for QSee.ai, likely QC/defect/inspection related."; Department="QC"; Cluster="External Vendors / Partnerships"; Confidence="Inferred from filename and resource matrix"; Type="external engagement" }
    "PPJxStratova AI.md" = @{ Summary="External vendor/partnership note for Stratova AI."; Department="TBD"; Cluster="External Vendors / Partnerships"; Confidence="Inferred from filename"; Type="external engagement" }
    "PPJ XPrimo1D RFID Thread.md" = @{ Summary="External technology/vendor exploration for Primo1D RFID thread."; Department="FD / Production"; Cluster="External Vendors / Partnerships"; Confidence="Supported by resource matrix"; Type="external engagement" }
    "VITAS Sharing.md" = @{ Summary="External sharing, knowledge event, or industry engagement."; Department="Management"; Cluster="Events / Workshops / Knowledge Sharing"; Confidence="Supported by resource matrix"; Type="knowledge sharing" }
    "AI Automation Workshop.md" = @{ Summary="Workshop/event note for AI automation workshop context, agenda, stakeholders, outputs, and follow-up."; Department="AI Automation"; Cluster="Events / Workshops / Knowledge Sharing"; Confidence="Inferred from filename"; Type="workshop" }
    "Workshop Analysis.md" = @{ Summary="Analysis note for workshop insights and follow-up; not a product system."; Department="AI Automation"; Cluster="Events / Workshops / Knowledge Sharing"; Confidence="Supported by registry"; Type="analysis" }
}

function Read-Utf8 { param([string]$Path) if (Test-Path $Path) { Get-Content -Raw -Encoding UTF8 $Path } else { "" } }
function Write-Utf8 { param([string]$Path,[string]$Text) $Text | Set-Content -Encoding UTF8 $Path }
function Get-BaseName { param([string]$FileName) [System.IO.Path]::GetFileNameWithoutExtension($FileName) }
function Test-AliasNote { param([string]$Text) return ($Text -match '(?im)^type\s*:\s*alias\s*$' -or $Text -match '(?im)^status\s*:\s*"?alias"?\s*$') }
function Test-ProjectNote { param([string]$Text) return ($Text -match '(?im)^type\s*:\s*project\s*$') }
function Get-FieldValue { param([string]$Text,[string]$Field) $m=[regex]::Match($Text,"(?im)^$([regex]::Escape($Field))\s*:\s*`"?([^`"\r\n]+)`"?\s*$"); if($m.Success){$m.Groups[1].Value.Trim()}else{"TBD"} }
function Test-HasSection { param([string]$Text,[string]$Section) return ($Text -match "(?im)^##\s+$([regex]::Escape($Section))\s*$") }

function Backup-File {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return }
    $relative = (Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\')
    $target = Join-Path $backupRoot $relative
    $targetDir = Split-Path $target -Parent
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item -Path $Path -Destination $target -Force
    $script:LogLines += "- Backup: $relative"
}

function Get-EvidenceLines {
    param([string]$FileName,[string]$ProjectCode)
    $sources = @(
        "03_Projects\_Registry\PPJ_PROJECT_REGISTRY.md",
        "03_Projects\_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md",
        "03_Projects\_Registry\PPJ_PROJECT_ALIAS_MAP.md",
        "09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md"
    )
    $lines = @()
    foreach ($source in $sources) {
        $path = Join-Path $vaultRoot $source
        if (-not (Test-Path $path)) { continue }
        $content = Get-Content -Encoding UTF8 $path
        foreach ($line in $content) {
            if ($line -like "*$FileName*" -or $line -like "*$ProjectCode*") {
                $lines += [pscustomobject]@{ Source=$source; Line=$line.Trim() }
            }
        }
    }
    return $lines
}

function Get-CanvasMentions {
    param([string]$FileName)
    $mentions = @()
    $canvasRoot = Join-Path $projectRoot "Canvas"
    if (-not (Test-Path $canvasRoot)) { return $mentions }
    foreach ($canvas in Get-ChildItem $canvasRoot -Filter "*.canvas" -File) {
        $raw = Read-Utf8 $canvas.FullName
        if ($raw -like "*$FileName*") { $mentions += $canvas.Name }
    }
    return $mentions
}

function Get-ProjectMeta {
    param([string]$FileName,[string]$Text)
    $code = Get-BaseName $FileName
    $s = if ($seed.ContainsKey($FileName)) { $seed[$FileName] } else { @{ Summary="TBD"; Department="TBD"; Cluster="TBD"; Confidence="Needs Confirmation"; Type="TBD" } }
    $phase = Get-FieldValue $Text "phase"
    if ($phase -eq "TBD") { $phase = Get-FieldValue $Text "status" }
    $cluster = Get-FieldValue $Text "cluster"
    if ($cluster -eq "TBD") { $cluster = $s.Cluster }
    $versionValue = "TBD"
    if ($code -match '(v\d+(\.\d+)*)') { $versionValue = $matches[1] }
    return [pscustomobject]@{
        FileName=$FileName; ProjectName=$code; ProjectCode=$code; Department=$s.Department; Object="Inferred from filename"; Characteristic=$s.Type; Version=$versionValue; Phase=$phase; Cluster=$cluster; Owner="TBD"; BusinessOwner="TBD"; TechnicalOwner="TBD"; Status=(Get-FieldValue $Text "status"); Priority=(Get-FieldValue $Text "priority"); Summary=$s.Summary; Confidence=$s.Confidence
    }
}

function Get-PopulationBlock {
    param([pscustomobject]$Meta,[object[]]$Evidence,[string[]]$CanvasMentions)
    $projectLinks = @()
    if ($Meta.FileName -eq "PPJ.AI.Hub.v2.1.md") { $projectLinks = $moduleProjects }
    elseif ($Meta.FileName -eq "PPJ. Expense-Invoices.v1.1.md") { $projectLinks = @("PPJ.Invoice Downloader.v1.2", "ACC.GRN-SupplierInvoiceBot.v1.1") }
    elseif ($Meta.FileName -eq "SCP.SOURCING.CHATBOT.v2.3.md") { $projectLinks = @("TD.TechnicalPlatform_v2.1", "PPJ.AI.Hub.v2.1") }
    else { $projectLinks = @($Meta.ProjectCode) }
    $projectLinkText = ($projectLinks | ForEach-Object { "[[${_}]]" }) -join "`r`n"
    $evidenceText = if ($Evidence.Count -gt 0) { (($Evidence | Select-Object -First 8 | ForEach-Object { "- $($_.Source): $($_.Line)" }) -join "`r`n") } else { "- Existing note content`r`n- Filename / naming convention`r`n- Needs Confirmation" }
    $canvasText = if ($CanvasMentions.Count -gt 0) { ($CanvasMentions -join ", ") } else { "TBD" }

    return @"
$managedStart

# Project Detail

## Executive Summary
$($Meta.Summary)

This note is populated as a canonical PPJ project record for $($Meta.ProjectCode). It serves $($Meta.Department) and should be maintained as the source of truth for this project, unless a linked module note is explicitly marked canonical.

## Business Context
Department / process area: $($Meta.Department)

Project category: $($Meta.Cluster)

Business impact: $($Meta.Summary)

Canvas evidence: $canvasText

## Problem Statement
The current business or operational problem is partially documented. Known context: $($Meta.Summary)

Where evidence is incomplete, details are marked as TBD or Needs Confirmation.

## Objectives

- Clarify scope, ownership, data, workflow, and support model.
- Confirm source of truth, users, and system dependencies.
- Define measurable outcome and next actions for execution tracking.

## Scope

### In Scope

- Project governance and scope clarification.
- Business workflow and data/source-of-truth documentation.
- Ownership, phase, risk, decision, and next-action tracking.

### Out of Scope

- Renaming project files.
- Merging this project into another project unless explicitly approved.
- Canvas layout changes.
- Replacing department-specific workflow ownership.

## Stakeholders

| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Business Owner | $($Meta.BusinessOwner) | Own business process and acceptance | Needs Confirmation |
| Technical Owner | $($Meta.TechnicalOwner) | Own implementation, support, or integration | Needs Confirmation |
| Users | $($Meta.Department) | Use or validate the workflow/tool/output | Needs Confirmation |

## Current Process
TBD. Current process should be confirmed with the business owner and existing users.

## Target Process
Target process should support the project objective described above. The future state should clarify user trigger, system action, exception handling, ownership, monitoring, and support process.

## Data and Source of Truth

| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| TBD | TBD | TBD | TBD | Needs Confirmation |

## System / Automation Design
Project characteristic: $($Meta.Characteristic)

Design concept: $($Meta.Summary)

System dependencies and integration points remain TBD unless confirmed in registry or project notes.

## Business Rules

- TBD

## User Flow

1. User opens or triggers the tool/process.
2. User submits or searches information.
3. System processes request.
4. User receives output.
5. Exceptions are handled or escalated.

## KPI / Success Metrics

| KPI | Target | Current | Notes |
|---|---|---|---|
| Time saved | TBD | TBD | TBD |
| Error reduction | TBD | TBD | TBD |
| Adoption | TBD | TBD | TBD |

## Risks and Blockers

- Ownership and process details may be incomplete.
- Data source and source-of-truth confirmation may be required.
- System dependency and support ownership may need clarification.

## Decisions Needed

- Confirm business owner.
- Confirm technical owner.
- Confirm source of truth and data fields.
- Confirm next release scope and acceptance criteria.

## Next Actions

- Review this populated project detail block.
- Confirm missing owners, phase, data, and workflow details.
- Update deliverables and tasks after confirmation.

## Evidence and Confidence

| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Phase | $($Meta.Phase) | Existing note / registry | $($Meta.Confidence) |
| Owner | $($Meta.Owner) | Registry/resource matrix if available | Needs Confirmation |
| Scope | $($Meta.Summary) | Seed context and vault evidence | $($Meta.Confidence) |
| Cluster | $($Meta.Cluster) | Existing note / registry / seed | $($Meta.Confidence) |

Evidence sources found:

$evidenceText

## Related Concepts

[[Project Governance]]
[[Traceability]]
[[AI Automation]]
[[Business Process Design]]

## Methods

[[Requirement Elicitation]]
[[Impact Analysis]]
[[Data Mapping]]
[[User Journey Mapping]]
[[Acceptance Criteria]]

## Projects

$projectLinkText

## Deliverables

[[Decision_Driven_BRD]]
[[User_Manual_Template]]
[[System_Design_Template]]

$managedEnd
"@
}

function Update-ManagedBlock {
    param([string]$Text,[string]$Block)
    if ($Text -match [regex]::Escape($managedStart)) {
        return [regex]::Replace($Text, "(?s)$([regex]::Escape($managedStart)).*?$([regex]::Escape($managedEnd))", [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $Block.TrimEnd() }, 1)
    }
    return $Text.TrimEnd() + "`r`n`r`n" + $Block.TrimEnd() + "`r`n"
}

function Update-FrontmatterSafely {
    param([string]$Text,[pscustomobject]$Meta)
    $fields = [ordered]@{
        "type"="project"; "project_name"=$Meta.ProjectName; "project_code"=$Meta.ProjectCode; "department"=$Meta.Department; "object"=$Meta.Object; "project_characteristic"=$Meta.Characteristic; "version"=$Meta.Version; "phase"=$Meta.Phase; "cluster"=$Meta.Cluster; "owner"=$Meta.Owner; "business_owner"=$Meta.BusinessOwner; "technical_owner"=$Meta.TechnicalOwner; "members"="[]"; "stakeholders"="[]"; "systems"="[]"; "data_sources"="[]"; "status"=$Meta.Status; "progress"="TBD"; "priority"=$Meta.Priority; "blocked"="TBD"; "decision_needed"="TBD"; "next_action"="TBD"; "last_updated"=$today; "confidence"=$Meta.Confidence; "source_files"="[]"
    }
    if ($Text -notmatch '(?s)^---\s*\r?\n.*?\r?\n---') {
        $fm = @("---")
        foreach ($k in $fields.Keys) { $v=$fields[$k]; if($v -match '^\[\]$'){ $fm += "$k`: []" } else { $fm += "$k`: `"$v`"" } }
        $fm += "---"
        return ($fm -join "`r`n") + "`r`n`r`n" + $Text.TrimStart()
    }
    $front = [regex]::Match($Text,'(?s)^---\s*\r?\n(.*?)\r?\n---').Groups[1].Value
    $newFront = $front.TrimEnd()
    foreach ($k in $fields.Keys) {
        if ($newFront -notmatch "(?im)^$([regex]::Escape($k))\s*:") {
            $v=$fields[$k]
            if($v -match '^\[\]$'){ $newFront += "`r`n$k`: []" } else { $newFront += "`r`n$k`: `"$v`"" }
        }
    }
    return [regex]::Replace($Text,'(?s)^---\s*\r?\n.*?\r?\n---',("---`r`n"+$newFront+"`r`n---"),1)
}

$plans = @()
foreach ($fileName in $canonicalFiles) {
    if ($ProjectName -and $fileName -notlike "*$ProjectName*" -and (Get-BaseName $fileName) -notlike "*$ProjectName*") { continue }
    $path = Join-Path $projectRoot $fileName
    if (-not (Test-Path $path)) { continue }
    $text = Read-Utf8 $path
    if (Test-AliasNote $text) { continue }
    $isCommand = ($fileName -eq "PROJECT_COMMAND_CENTER.md")
    $thin = (($text.Length -lt 800) -or -not (Test-ProjectNote $text) -or -not (Test-HasSection $text "Executive Summary")) -and -not $isCommand
    $meta = Get-ProjectMeta $fileName $text
    $evidence = @(Get-EvidenceLines $fileName $meta.ProjectCode)
    $canvas = @(Get-CanvasMentions $fileName)
    $block = if ($isCommand) { "" } else { Get-PopulationBlock $meta $evidence $canvas }
    $updated = if ($isCommand) { $text } else { Update-ManagedBlock (Update-FrontmatterSafely $text $meta) $block }
    $hasBlock = $text -match [regex]::Escape($managedStart)
    $confidence = if ($evidence.Count -ge 2 -or $meta.Confidence -match 'Supported') { "Strong" } elseif ($meta.Confidence -match 'Needs') { "Weak" } else { "Medium" }
    $plans += [pscustomobject]@{ FileName=$fileName; Path=$path; IsCommand=$isCommand; Size=$text.Length; Thin=$thin; HasManagedBlock=$hasBlock; EvidenceCount=$evidence.Count; Confidence=$confidence; Meta=$meta; Block=$block; UpdatedText=$updated; HasFrontmatter=($text -match '(?s)^---\s*\r?\n.*?\r?\n---'); HasExecutive=(Test-HasSection $text "Executive Summary"); HasScope=(Test-HasSection $text "Scope"); HasStakeholders=(Test-HasSection $text "Stakeholders"); HasData=(Test-HasSection $text "Data and Source of Truth"); HasDesign=(Test-HasSection $text "System / Automation Design"); HasRisks=(Test-HasSection $text "Risks and Blockers"); HasNext=(Test-HasSection $text "Next Actions") }
}

Write-Host "PPJ Canonical Project Note Population"
Write-Host "Mode: $(if($Apply){'Apply'}else{'DryRun'})"
Write-Host "Projects scanned: $($plans.Count)"
Write-Host "Thin/corrupted notes: $(@($plans | Where-Object Thin).Count)"
Write-Host "Strong evidence: $(@($plans | Where-Object Confidence -eq 'Strong').Count)"
Write-Host "Weak evidence: $(@($plans | Where-Object Confidence -eq 'Weak').Count)"
Write-Host ""
foreach ($p in $plans) {
    Write-Host " - $($p.FileName): thin=$($p.Thin); evidence=$($p.EvidenceCount); confidence=$($p.Confidence); command=$($p.IsCommand)"
}
Write-Host ""
Write-Host "Sample preview: PPJ.AI.Hub.v2.1"
($plans | Where-Object FileName -eq "PPJ.AI.Hub.v2.1.md" | Select-Object -First 1).Block.Split("`n") | Select-Object -First 45 | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "Sample preview: PPJ.PERRI.Chatbot"
($plans | Where-Object FileName -eq "PPJ.PERRI.Chatbot.md" | Select-Object -First 1).Block.Split("`n") | Select-Object -First 45 | ForEach-Object { Write-Host $_ }

if ($DryRun) {
    Write-Host ""
    Write-Host "DryRun only. No project notes were modified."
    exit 0
}

New-Item -ItemType Directory -Force -Path $auditRoot, $backupRoot | Out-Null
$script:LogLines = @("# Project Note Population Log - $stamp", "", "Mode: Apply", "")
foreach ($p in $plans) {
    if ($p.IsCommand) { $script:LogLines += "- Skipped command/index note: $($p.FileName)"; continue }
    if (($p.UpdatedText -ne (Read-Utf8 $p.Path)) -or $Force) {
        Backup-File $p.Path
        Write-Utf8 $p.Path $p.UpdatedText
        $script:LogLines += "- Populated managed block: $($p.FileName)"
    }
}
$script:LogLines += ""
$script:LogLines += "## Safety Confirmation"
$script:LogLines += ""
$script:LogLines += "- No files renamed, moved, archived, or deleted."
$script:LogLines += "- Canvas files were not modified."
$script:LogLines += "- Only managed content blocks and missing frontmatter fields were updated."
Write-Utf8 $logPath ($script:LogLines -join "`r`n")
Write-Host "Apply completed. Log: $logPath"
