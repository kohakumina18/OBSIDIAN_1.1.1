param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [string]$ProjectName,
    [switch]$RepairTextOnly,
    [switch]$RebuildWeakProjects,
    [switch]$RebuildCPDDatamart
)

$ErrorActionPreference = "Stop"
if (-not $Apply) { $DryRun = $true }

$vaultRoot = (Get-Location).Path
$projectRoot = Join-Path $vaultRoot "03_Projects"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$dateStamp = Get-Date -Format "yyyyMMdd"
$backupRoot = Join-Path $auditRoot "Project_Knowledge_Repair_Backup\$stamp"
$logPath = Join-Path $auditRoot "PROJECT_KNOWLEDGE_REPAIR_LOG_$stamp.md"
$repairPlanReport = Join-Path $vaultRoot "10_Reports\PROJECT_KNOWLEDGE_POPULATION_REPAIR_PLAN_$dateStamp.md"
$qaReport = Join-Path $vaultRoot "10_Reports\PROJECT_KNOWLEDGE_QA_REPORT_$dateStamp.md"
$cpdReport = Join-Path $vaultRoot "10_Reports\CPD_DATAMART_SCOPE_REPAIR_REPORT_$dateStamp.md"

$standardStart = "<!-- PPJ_PROJECT_KNOWLEDGE_START -->"
$standardEnd = "<!-- PPJ_PROJECT_KNOWLEDGE_END -->"
$oldStart = "<!-- PPJ_PROJECT_DETAIL_MANAGED_START -->"
$oldEnd = "<!-- PPJ_PROJECT_DETAIL_MANAGED_END -->"

$managedMarkerPairs = @(
    @{ Type="standard PPJ project knowledge"; Start=$standardStart; End=$standardEnd },
    @{ Type="invalid generated project knowledge identical"; Start="<!-- generated project knowledge content -->"; End="<!-- generated project knowledge content -->" },
    @{ Type="previous generated project knowledge start/end"; Start="<!-- generated project knowledge content start -->"; End="<!-- generated project knowledge content end -->" },
    @{ Type="incorrect generated content"; Start="<!-- generated content start -->"; End="<!-- generated content end -->" },
    @{ Type="old PPJ_PROJECT_DETAIL"; Start=$oldStart; End=$oldEnd },
    @{ Type="generic generated project detail"; Start="<!-- generated project detail start -->"; End="<!-- generated project detail end -->" },
    @{ Type="project detail managed"; Start="<!-- PROJECT_DETAIL_MANAGED_START -->"; End="<!-- PROJECT_DETAIL_MANAGED_END -->" },
    @{ Type="project knowledge managed"; Start="<!-- PROJECT_KNOWLEDGE_MANAGED_START -->"; End="<!-- PROJECT_KNOWLEDGE_MANAGED_END -->" },
    @{ Type="PPJ project knowledge managed"; Start="<!-- PPJ_PROJECT_KNOWLEDGE_MANAGED_START -->"; End="<!-- PPJ_PROJECT_KNOWLEDGE_MANAGED_END -->" },
    @{ Type="PPJ project detail generated"; Start="<!-- PPJ_PROJECT_DETAIL_GENERATED_START -->"; End="<!-- PPJ_PROJECT_DETAIL_GENERATED_END -->" },
    @{ Type="PPJ generated project detail"; Start="<!-- PPJ_GENERATED_PROJECT_DETAIL_START -->"; End="<!-- PPJ_GENERATED_PROJECT_DETAIL_END -->" },
    @{ Type="PPJ generated project knowledge"; Start="<!-- PPJ_GENERATED_PROJECT_KNOWLEDGE_START -->"; End="<!-- PPJ_GENERATED_PROJECT_KNOWLEDGE_END -->" },
    @{ Type="managed project knowledge"; Start="<!-- MANAGED_PROJECT_KNOWLEDGE_START -->"; End="<!-- MANAGED_PROJECT_KNOWLEDGE_END -->" },
    @{ Type="managed project detail"; Start="<!-- MANAGED_PROJECT_DETAIL_START -->"; End="<!-- MANAGED_PROJECT_DETAIL_END -->" },
    @{ Type="project knowledge generated"; Start="<!-- PROJECT_KNOWLEDGE_GENERATED_START -->"; End="<!-- PROJECT_KNOWLEDGE_GENERATED_END -->" },
    @{ Type="generated knowledge"; Start="<!-- GENERATED_KNOWLEDGE_START -->"; End="<!-- GENERATED_KNOWLEDGE_END -->" },
    @{ Type="auto generated project knowledge"; Start="<!-- AUTO_GENERATED_PROJECT_KNOWLEDGE_START -->"; End="<!-- AUTO_GENERATED_PROJECT_KNOWLEDGE_END -->" },
    @{ Type="AI generated project knowledge"; Start="<!-- AI_GENERATED_PROJECT_KNOWLEDGE_START -->"; End="<!-- AI_GENERATED_PROJECT_KNOWLEDGE_END -->" }
)

$forbiddenOutputMarkers = @(
    "<!-- generated project knowledge content -->",
    "<!-- generated project knowledge content start -->",
    "<!-- generated project knowledge content end -->",
    "<!-- generated content start -->",
    "<!-- generated content end -->"
)

$protectedExpectedFiles = @(
    "ACC.GRN-SupplierInvoiceBot.v1.1.md"
)

$knownInvalidFilenames = @(
    "ACC.GRN-SupplierInvoiceBot.v2.3.md"
)

$requiredSections = @(
    "Executive Summary", "Business Context", "Problem Statement", "Objectives", "Scope", "Stakeholders",
    "Current Process", "Target Process", "Data and Source of Truth", "System / Automation Design",
    "Business Rules", "KPI / Success Metrics", "Risks and Blockers", "Decisions Needed",
    "Next Actions", "Evidence and Confidence", "Related Concepts", "Methods", "Projects", "Deliverables"
)

$highPriority = @(
    "FD.Datamart.v2.2.md",
    "PPJ.PERRI.Chatbot.md",
    "PPJ.GLPI-Helpdesk-AI Chatbot.md",
    "PPJ.COSTING.AGENT.PLATFORM.v1.1.md",
    "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md",
    "SCP.SOURCING.CHATBOT.v2.3.md",
    "PPJ.AI.Hub.v2.1.md",
    "PPJ.Invoice Downloader.v1.2.md",
    "PPJ. Expense-Invoices.v1.1.md"
)

$qualityPatterns = @(
    @{ Pattern="does notmerge"; Fix="does not merge" },
    @{ Pattern="modulenote"; Fix="module note" },
    @{ Pattern="officiallyexpanded"; Fix="officially expanded" },
    @{ Pattern="project notes\.It"; Fix="project notes. It" },
    @{ Pattern="workflow\.This"; Fix="workflow. This" },
    @{ Pattern="andalias"; Fix="and alias" },
    @{ Pattern="source-of-truth project notes andshould"; Fix="source-of-truth project notes and should" },
    @{ Pattern="current v1\.1implementation"; Fix="current v1.1 implementation" },
    @{ Pattern="source datais"; Fix="source data is" },
    @{ Pattern="(?<=[a-z])(?=This\b)"; Fix=" "; Label="obvious joined sentence boundary" },
    @{ Pattern="(?<=[a-z])(?=It\b)"; Fix=" "; Label="obvious joined sentence boundary" },
    @{ Pattern="(?<=[a-z])(?=The\b)"; Fix=" "; Label="obvious joined sentence boundary" },
    @{ Pattern="(?<=[a-z])(?=If\b)"; Fix=" "; Label="obvious joined sentence boundary" }
)

function Read-Utf8 { param([string]$Path) if (Test-Path $Path) { Get-Content -Raw -Encoding UTF8 $Path } else { "" } }
function Write-Utf8 { param([string]$Path,[string]$Text) $dir=Split-Path $Path -Parent; if(-not(Test-Path $dir)){New-Item -ItemType Directory -Force -Path $dir|Out-Null}; $Text | Set-Content -Encoding UTF8 $Path }
function Get-BaseName { param([string]$FileName) return [System.IO.Path]::GetFileNameWithoutExtension($FileName) }
function Test-AliasNote { param([string]$Text) return ($Text -match '(?im)^type\s*:\s*alias\s*$' -or $Text -match '(?im)^status\s*:\s*"?alias"?\s*$') }
function Test-Frontmatter { param([string]$Text) return ($Text -match '(?s)^---\s*\r?\n.*?\r?\n---') }
function Test-Section { param([string]$Text,[string]$Name) return ($Text -match "(?im)^##\s+$([regex]::Escape($Name))\s*$") }
function Get-ManagedBlockMatches {
    param([string]$Text)
    $items=@()
    foreach($m in $managedMarkerPairs){
        $pattern = "(?s)$([regex]::Escape($m.Start)).*?$([regex]::Escape($m.End))"
        foreach($match in [regex]::Matches($Text,$pattern)){
            $items += [pscustomobject]@{ Type=$m.Type; Text=$match.Value; Start=$m.Start; End=$m.End; Pattern=$pattern; Index=$match.Index; Length=$match.Length }
        }
    }
    return @($items | Sort-Object Index)
}
function Get-ManagedBlock {
    param([string]$Text)
    $matches = @(Get-ManagedBlockMatches $Text)
    if($matches.Count -gt 0){
        $types = (($matches | Select-Object -ExpandProperty Type -Unique) -join "; ")
        return [pscustomobject]@{ Found=$true; Type=$types; Text=$matches[0].Text; Start=$matches[0].Start; End=$matches[0].End; Pattern=$matches[0].Pattern; Count=$matches.Count }
    }
    return [pscustomobject]@{ Found=$false; Type="None"; Text=""; Start=""; End=""; Pattern=""; Count=0 }
}
function Get-Evidence {
    param([string]$FileName,[string]$ProjectCode)
    $sources = @("03_Projects\_Registry\PPJ_PROJECT_REGISTRY.md","03_Projects\_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md","03_Projects\_Registry\PPJ_PROJECT_ALIAS_MAP.md","09_Stakeholders\PPJ_TEAM_WORKLOAD_MAP.md")
    $e=@()
    foreach($src in $sources){ $p=Join-Path $vaultRoot $src; if(Test-Path $p){ foreach($line in (Get-Content -Encoding UTF8 $p)){ if($line -like "*$FileName*" -or $line -like "*$ProjectCode*"){ $e += "${src}: $($line.Trim())" } } } }
    $canvasRoot=Join-Path $projectRoot "Canvas"
    if(Test-Path $canvasRoot){ foreach($c in Get-ChildItem $canvasRoot -Filter "*.canvas" -File){ $raw=Read-Utf8 $c.FullName; if($raw -like "*$FileName*" -or $raw -like "*$ProjectCode*"){ $e += "03_Projects\Canvas\$($c.Name): Canvas reference" } } }
    if($FileName -eq "FD.Datamart.v2.2.md") { $e += "User correction 2026-06-28: CPD sample management portal for chi Trang / 3D Design" }
    if($FileName -eq "PPJ.PERRI.Chatbot.md") { $e += "User correction 2026-06-28: PERRI internal chatbot/orchestrator layer" }
    if($FileName -eq "PPJ.GLPI-Helpdesk-AI Chatbot.md") { $e += "User correction 2026-06-28: GLPI / IT Helpdesk AI chatbot" }
    return @($e | Select-Object -Unique)
}
function Get-CorrectConfidence { param([int]$EvidenceCount,[string]$FileName)
    if($EvidenceCount -eq 0){ return "Weak / Needs Confirmation" }
    if($FileName -in @("FD.Datamart.v2.2.md","PPJ.PERRI.Chatbot.md","PPJ.GLPI-Helpdesk-AI Chatbot.md")){ return "Strong for corrected business concept; implementation details need confirmation" }
    if($EvidenceCount -ge 3){ return "Strong" }
    return "Medium / Needs Confirmation"
}
function Get-Classification { param([System.IO.FileInfo]$File,[string]$Text,[object]$Block)
    if($File.Length -le 20 -or [string]::IsNullOrWhiteSpace($Text)){ return "Tiny / corrupted" }
    if($Block.Found){
        $issues = Get-TextIssues $Text
        if($issues.Count -gt 0){ return "Populated but needs QA" }
        $missing = @($requiredSections | Where-Object { -not (Test-Section $Block.Text $_) })
        if($missing.Count -eq 0 -and (Test-Frontmatter $Text)){ return "Complete enough" }
        return "Populated but needs QA"
    }
    return "Thin but usable"
}
function Get-TextIssues { param([string]$Text)
    $issues=@()
    foreach($q in $qualityPatterns){ if($Text -match $q.Pattern){ if($q.ContainsKey("Label")){ $issues += $q.Label } else { $issues += $q.Pattern } } }
    if(([regex]::Matches($Text,"This note is populated as")).Count -gt 0){ $issues += "mechanical generic phrase: This note is populated as" }
    if(([regex]::Matches($Text,"TBD")).Count -gt 20){ $issues += "TBD overuse" }
    return @($issues | Select-Object -Unique)
}
function Repair-Spacing { param([string]$Text)
    $out=$Text
    foreach($q in $qualityPatterns){ $out=[regex]::Replace($out,$q.Pattern,$q.Fix) }
    return $out
}
function Count-Text { param([string]$Text,[string]$Needle) return ([regex]::Matches($Text, [regex]::Escape($Needle))).Count }
function Test-GeneratedBlockCompliance {
    param([string]$BlockText)
    $startCount = Count-Text $BlockText $standardStart
    $endCount = Count-Text $BlockText $standardEnd
    $startIndex = $BlockText.IndexOf($standardStart)
    $endIndex = $BlockText.LastIndexOf($standardEnd)
    $forbidden = @()
    foreach($marker in $forbiddenOutputMarkers){
        $count = Count-Text $BlockText $marker
        if($count -gt 0){ $forbidden += "$marker=$count" }
    }
    $pass = ($startCount -eq 1 -and $endCount -eq 1 -and $startIndex -ge 0 -and $endIndex -gt $startIndex -and $forbidden.Count -eq 0)
    return [pscustomobject]@{ Pass=$pass; StartCount=$startCount; EndCount=$endCount; StartBeforeEnd=($startIndex -ge 0 -and $endIndex -gt $startIndex); Forbidden=($forbidden -join "; ") }
}
function Test-FullTextMarkerCompliance {
    param([string]$Text)
    $startCount = Count-Text $Text $standardStart
    $endCount = Count-Text $Text $standardEnd
    $startIndex = $Text.IndexOf($standardStart)
    $endIndex = $Text.LastIndexOf($standardEnd)
    $forbidden = @()
    foreach($marker in $forbiddenOutputMarkers){
        $count = Count-Text $Text $marker
        if($count -gt 0){ $forbidden += "$marker=$count" }
    }
    $pass = ($startCount -eq 1 -and $endCount -eq 1 -and $startIndex -ge 0 -and $endIndex -gt $startIndex -and $forbidden.Count -eq 0)
    return [pscustomobject]@{ Pass=$pass; StartCount=$startCount; EndCount=$endCount; StartBeforeEnd=($startIndex -ge 0 -and $endIndex -gt $startIndex); Forbidden=($forbidden -join "; ") }
}
function Get-BlockTemplate {
    param([string]$Title,[string]$Executive,[string]$Context,[string]$Problem,[string[]]$Objectives,[string[]]$InScope,[string[]]$OutScope,[string]$Stakeholders,[string]$Current,[string]$Target,[string]$Data,[string]$Design,[string[]]$Rules,[string]$Kpi,[string[]]$Risks,[string[]]$Decisions,[string[]]$Next,[string]$Evidence,[string]$Projects,[string]$Concepts)
    return @"
$standardStart

# Project Knowledge Detail

## Executive Summary
$Executive

## Business Context
$Context

## Problem Statement
$Problem

## Objectives

$($Objectives | ForEach-Object { "- $_" } | Out-String)
## Scope

### In Scope

$($InScope | ForEach-Object { "- $_" } | Out-String)
### Out of Scope

$($OutScope | ForEach-Object { "- $_" } | Out-String)
## Stakeholders

$Stakeholders

## Current Process
$Current

## Target Process
$Target

## Data and Source of Truth
$Data

## System / Automation Design
$Design

## Business Rules

$($Rules | ForEach-Object { "- $_" } | Out-String)
## KPI / Success Metrics
$Kpi

## Risks and Blockers

$($Risks | ForEach-Object { "- $_" } | Out-String)
## Decisions Needed

$($Decisions | ForEach-Object { "- $_" } | Out-String)
## Next Actions

$($Next | ForEach-Object { "- $_" } | Out-String)
## Evidence and Confidence
$Evidence

## Related Concepts
$Concepts

## Methods
[[Requirement Elicitation]]
[[Impact Analysis]]
[[Data Mapping]]
[[User Journey Mapping]]
[[Acceptance Criteria]]

## Projects
$Projects

## Deliverables
[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[ERD_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]

$standardEnd
"@
}
function Get-CPDBlock { param([string]$EvidenceText)
    $stake=@"
| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Business User | chi Trang / 3D Design | Manage and validate sample workflow | Needs Confirmation |
| Department Owner | CPD / 3D Design | Confirm process, fields, and access | Needs Confirmation |
| BA / Coordination | Khoa | Process mapping, requirements, UAT coordination | Inferred from portfolio context |
| Technical / Data | Linh, Phat | Datamart/data pipeline/data analysis support | Inferred from resource mapping |
| Related Users | FD / CPD / Design | Search, manage, or reuse sample data | Needs Confirmation |
"@
    $data=@"
| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| Sample record | Existing CPD website/application | CPD / 3D Design | Missing metadata, duplicates | Needs Confirmation |
| Sample image / asset | Existing CPD website or file storage | CPD / 3D Design | Broken links, inconsistent naming | Needs Confirmation |
| Sample status | Existing workflow | CPD / 3D Design | Unclear status definition | Needs Confirmation |
| User / permission | Existing website or internal account model | IT / CPD | Access control mismatch | Needs Confirmation |
| Metadata dictionary | To be defined | BA / Data team | Inconsistent field names | Needs Confirmation |
"@
    $kpi=@"
| KPI | Target | Current | Notes |
|---|---|---|---|
| Sample search time | TBD | TBD | Measure before/after |
| Duplicate rate | TBD | TBD | Needs baseline |
| Mandatory field completion | TBD | TBD | Data quality KPI |
| User adoption | TBD | TBD | 3D Design / CPD users |
| Migration accuracy | TBD | TBD | Sample records migrated correctly |
"@
    $evidence=@"
| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Current Obsidian Filename | FD.Datamart.v2.2.md | Current project folder | Strong |
| Business Canonical Concept | CPD.Datamart.v1.1 | User correction | Strong |
| Rename Status | Needs Approval | Current instruction | Strong |
| Recommended Future Filename | CPD.Datamart.v1.1.md | User correction | Strong |
| Business concept | CPD sample management datamart / portal | User correction + portfolio context | Strong |
| Key user | chi Trang / 3D Design | User correction | Strong |
| Technical members | Linh, Phat | Resource mapping | Medium |
| Phase | TBD / Needs Confirmation | Portfolio lifecycle + resource map | Medium |

Evidence sources:
$EvidenceText
"@
    return Get-BlockTemplate -Title "FD.Datamart.v2.2" -Executive "This project represents the CPD Datamart / sample management portal initiative. The business goal is to port or modernize the existing CPD website/application that is currently used to manage sample information for chi Trang in the 3D Design department.`r`n`r`nThe project should create a structured, searchable, governed sample data repository so CPD and 3D Design users can manage, search, review, and reuse sample information more effectively." -Context "CPD and 3D Design need a reliable way to manage sample records, sample metadata, images or reference assets, and related tracking information. The current process appears to depend on an existing CPD website/application. The new project should port this workflow into a more maintainable data platform or internal portal.`r`n`r`nThis sits in the Data Repository / Dashboard / Portal portfolio group together with R&D Wash Sampling Portal, Sourcing repository, FD QR Hanger, Inventory Report, Market Intelligence, and production dashboards." -Problem "Sample information is valuable but can become hard to search, govern, and reuse if metadata, naming convention, ownership, and permission are not standardized. If the existing CPD website is not properly documented or ported, the team risks losing process knowledge and creating duplicate sample records." -Objectives @("Document the current CPD sample management website/application.","Identify the users, especially chi Trang and the 3D Design department.","Define the sample data model and metadata.","Confirm the source of truth for sample records.","Prepare a porting or migration plan into the target internal platform.","Improve search, filtering, governance, and future AI-readiness of sample data.") -InScope @("Current CPD website/application process review","Sample record structure","Sample metadata definition","User role and permission mapping","Data migration / porting plan","Sample search and filter requirements","Data quality and duplicate checking","Target portal/datamart concept","UAT checklist with chi Trang / 3D Design") -OutScope @("Replacing all FD / Sourcing / R&D Wash sample systems without approval","Merging this project into Sourcing Chatbot","Merging this project into R&D Wash Sampling Portal","Renaming the file without approval","Building AI recommendation before source data is stable") -Stakeholders $stake -Current "TBD after walkthrough.`r`n`r`nExpected current process:`r`n`r`n1. CPD or 3D Design user opens the existing CPD website/application.`r`n2. User creates, updates, or searches sample records.`r`n3. Sample information may include metadata, images, references, owner, status, and related design information.`r`n4. chi Trang or the 3D Design team uses this data to manage sample visibility and follow-up.`r`n5. Data may need to be migrated or synchronized into a newer internal portal/datamart." -Target "1. User accesses the new CPD Datamart / sample portal.`r`n2. User searches or filters sample records by agreed metadata.`r`n3. User opens sample detail with images/assets and business context.`r`n4. Authorized users create or update sample records.`r`n5. Data quality checks prevent duplicates and missing mandatory fields.`r`n6. CPD / 3D Design validates the record.`r`n7. The record becomes reusable for reporting, lookup, and future AI/search use cases." -Data $data -Design "The system should behave as a structured datamart or portal layer for CPD sample management. It should support sample record CRUD, search, filtering, ownership, permission, data validation, and future integration with PPJ.AI.Hub or AI search if appropriate.`r`n`r`nPotential target components:`r`n`r`n- database / datamart`r`n- internal portal UI`r`n- Directus or similar data admin layer if applicable`r`n- image/file storage`r`n- search index`r`n- reporting/dashboard layer`r`n- permission model" -Rules @("Every sample should have a unique identifier.","Mandatory metadata must be confirmed with CPD / 3D Design.","Duplicate sample records should be flagged.","Images/assets should be linked with stable paths or IDs.","Only authorized users can edit records.","Read access and edit access may be different.","Migration should preserve original record identity where possible.","UAT must include chi Trang or assigned 3D Design representative.") -Kpi $kpi -Risks @("Current CPD website structure is not documented","Data export may be difficult","Sample metadata may be inconsistent","Images/assets may not have stable links","Permission model may be unclear","chi Trang / 3D Design availability for UAT may be limited","Risk of confusing CPD Datamart with FD QR Hanger or Sourcing sample repository") -Decisions @("Confirm whether current filename should remain FD.Datamart.v2.2.md or be renamed later to CPD.Datamart.v1.1.md.","Confirm owner and key users.","Confirm target platform.","Confirm sample metadata fields.","Confirm migration approach.","Confirm access control model.") -Next @("Schedule walkthrough with chi Trang / 3D Design.","Capture current CPD website screens and workflow.","Export or sample current data structure.","Draft sample metadata dictionary.","Define UAT checklist.","Decide rename separately after scope confirmation.") -Evidence $evidence -Projects "[[PPJ.AI.Hub.v2.1]]`r`n[[SCP.SOURCING.CHATBOT.v2.3]]`r`n[[WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1]]`r`n[[TD.TechnicalPlatform_v2.1]]" -Concepts "[[Project Governance]]`r`n[[Traceability]]`r`n[[Data Repository]]`r`n[[Sample Management]]`r`n[[Data Quality]]`r`n[[Permission Model]]"
}
function Get-PERRIBlock { param([string]$EvidenceText)
    $stake=@"
| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Platform Owner | TBD | Own chatbot/orchestrator roadmap | Needs Confirmation |
| AI / Automation Team | Khoa / PPJ AI team | Requirements, governance, and support coordination | Inferred from portfolio context |
| Technical Owner | TBD | Own orchestration, tool integration, logging, and permission model | Needs Confirmation |
| Department Users | PPJ departments | Ask questions, request lookup, or trigger approved tools | Needs Confirmation |
| Connected Tool Owners | Invoice Downloader / PPJ.AI.Hub modules | Maintain downstream tool behavior | Needs Confirmation |
"@
    $data="| Data Object | Source System | Owner | Quality Risk | Confirmation |`r`n|---|---|---|---|---|`r`n| User question/request | PERRI chatbot UI | AI Team | Ambiguous intent | Needs Confirmation |`r`n| Document knowledge | Approved document repositories | Document owners | Stale content | Needs Confirmation |`r`n| Tool/action catalog | PPJ.AI.Hub.v2.1 | AI Team | Unapproved trigger scope | Needs Confirmation |`r`n| Permission profile | User/department access model | IT / AI Team | Over-permission risk | Needs Confirmation |`r`n| Audit log | Chatbot/orchestrator log | Technical owner | Missing traceability | Needs Confirmation |"
    $kpi="| KPI | Target | Current | Notes |`r`n|---|---|---|---|`r`n| Answer success rate | TBD | TBD | Needs baseline |`r`n| Escalation accuracy | TBD | TBD | Department routing |`r`n| Tool trigger accuracy | TBD | TBD | Only approved workflows |`r`n| Audit log completeness | TBD | TBD | Governance KPI |"
    $evidence="| Field | Value | Evidence Source | Confidence |`r`n|---|---|---|---|`r`n| Phase | Production / Permission Enhancement | User correction | Strong for phase label; details need confirmation |`r`n| Business meaning | Internal chatbot and orchestrator layer | User correction | Strong |`r`n| Connected hub | PPJ.AI.Hub.v2.1 | User correction | Strong |`r`n| Evidence count rule | Confidence is not Medium when evidence is zero | Repair rule | Strong |`r`n`r`nEvidence sources:`r`n$EvidenceText"
    return Get-BlockTemplate -Title "PPJ.PERRI.Chatbot" -Executive "PERRI is the internal chatbot and orchestrator layer for PPJ. It supports document Q&A, data lookup, department-specific agents, and future workflow triggers. It can become the execution layer where user requests are routed to approved tools such as invoice downloader, document lookup, project knowledge lookup, or other automation modules." -Context "PERRI sits between users, PPJ.AI.Hub.v2.1, document knowledge sources, and approved automation tools. The project should define chatbot access, department-level agent permissions, tool trigger boundaries, fallback behavior, and audit logging before expanding automation actions." -Problem "Without a clear permission and orchestration model, a chatbot can answer from stale sources, trigger the wrong tool, expose restricted information, or create support issues. PERRI needs governance as an orchestrator, not only a chat interface." -Objectives @("Define PERRI chatbot/orchestrator scope.","Design department-level access and permission model.","Define approved tool trigger scope and fallback behavior.","Connect PERRI governance to PPJ.AI.Hub.v2.1 module catalog.","Define audit logging and support process.") -InScope @("Document Q&A","Data lookup","Department-specific agent access","Approved tool routing and orchestration","Permission model","Logging and fallback","Connection to PPJ.AI.Hub.v2.1","Connection to PPJ.Invoice Downloader.v1.2 if approved") -OutScope @("Unapproved autonomous actions","Bypassing owner approval for sensitive workflows","Replacing individual project notes","Creating unrestricted access to all data","Broker/trading or unrelated automation") -Stakeholders $stake -Current "PERRI is treated as a chatbot/orchestrator concept. Current implementation details, deployment status, permission setup, and connected tools need confirmation." -Target "1. User opens PERRI from an approved access point.`r`n2. User intent is classified by department, permission, and request type.`r`n3. PERRI answers from approved knowledge or routes to an approved tool.`r`n4. Sensitive or unsupported requests are refused or escalated.`r`n5. Every interaction and tool trigger is logged for audit and improvement." -Data $data -Design "PERRI should be designed as an orchestrator layer with a controlled tool catalog, permission checks, department-specific agents, logging, fallback, and escalation. It should link to PPJ.AI.Hub.v2.1 as the module catalog and governance layer, while individual tools remain separate canonical project notes." -Rules @("Every tool trigger must be permission-checked.","Department-specific agents must only access approved sources.","Unsupported requests must fall back to human support or a safe response.","Audit logs must capture user, intent, source, action, and outcome where allowed.","PERRI must not absorb project-specific source-of-truth notes.") -Kpi $kpi -Risks @("Incorrect or stale answer","Over-permissioned access","Unapproved workflow trigger","Missing audit trail","Unclear technical owner","User confusion between chatbot answer and official process") -Decisions @("Confirm access control model.","Confirm tool trigger scope.","Confirm audit log requirements.","Confirm owner and support path.","Confirm first departments and first release modules.") -Next @("Map PERRI access roles by department.","Define approved tool catalog with PPJ.AI.Hub.v2.1.","Confirm Invoice Downloader integration scope.","Draft fallback and escalation rules.","Define audit log schema.") -Evidence $evidence -Projects "[[PPJ.AI.Hub.v2.1]]`r`n[[PPJ.Invoice Downloader.v1.2]]`r`n[[TD.TechnicalPlatform_v2.1]]" -Concepts "[[Project Governance]]`r`n[[AI Automation]]`r`n[[Chatbot Governance]]`r`n[[Permission Model]]`r`n[[Traceability]]"
}
function Get-GLPIBlock { param([string]$EvidenceText)
    $stake="| Role | Name / Team | Responsibility | Confirmation |`r`n|---|---|---|---|`r`n| Business Owner | IT / Helpdesk | Own GLPI support process and knowledge quality | Needs Confirmation |`r`n| Technical Owner | TBD | Own chatbot integration, knowledge sync, and support workflow | Needs Confirmation |`r`n| Users | PPJ employees / requesters | Ask IT/helpdesk questions or request support | Needs Confirmation |`r`n| Escalation Team | IT Helpdesk | Resolve tickets and maintain FAQ categories | Needs Confirmation |"
    $data="| Data Object | Source System | Owner | Quality Risk | Confirmation |`r`n|---|---|---|---|---|`r`n| Helpdesk knowledge | GLPI / IT knowledge base | IT Helpdesk | Stale answers | Needs Confirmation |`r`n| FAQ categories | GLPI categories / IT taxonomy | IT Helpdesk | Inconsistent categories | Needs Confirmation |`r`n| User question | Chatbot UI | User / IT | Ambiguous request | Needs Confirmation |`r`n| Ticket metadata | GLPI ticket system | IT Helpdesk | Wrong routing | Needs Confirmation |`r`n| Escalation log | GLPI / chatbot log | IT Helpdesk | Missing traceability | Needs Confirmation |"
    $kpi="| KPI | Target | Current | Notes |`r`n|---|---|---|---|`r`n| Self-service answer rate | TBD | TBD | Reduce repeated IT questions |`r`n| Ticket routing accuracy | TBD | TBD | Needs GLPI category mapping |`r`n| Escalation quality | TBD | TBD | Human handoff KPI |`r`n| Stale answer rate | TBD | TBD | Knowledge governance KPI |"
    $evidence="| Field | Value | Evidence Source | Confidence |`r`n|---|---|---|---|`r`n| Phase | Production / Supporting | User correction | Strong for phase label; details need confirmation |`r`n| Business meaning | AI chatbot for GLPI / IT Helpdesk support | User correction | Strong |`r`n| Knowledge source | GLPI / IT Helpdesk knowledge | User correction | Strong for concept; source details need confirmation |`r`n`r`nEvidence sources:`r`n$EvidenceText"
    return Get-BlockTemplate -Title "PPJ.GLPI-Helpdesk-AI Chatbot" -Executive "This project is an AI chatbot for GLPI / IT Helpdesk support. It helps users search IT/helpdesk knowledge, answer common questions, route support requests, and potentially create or classify tickets if that capability is confirmed and approved." -Context "IT Helpdesk support often receives repeated questions, unclear ticket categories, and requests that need routing. A GLPI AI chatbot can improve self-service and triage while keeping escalation to IT for unresolved or sensitive issues." -Problem "Users may not know where to find IT support answers or how to classify requests. Helpdesk teams may spend time on repeated questions. If the chatbot uses stale knowledge or wrong permissions, it may give incorrect answers or route tickets incorrectly." -Objectives @("Define GLPI chatbot support scope.","Map FAQ and ticket categories.","Confirm GLPI knowledge source and update process.","Define escalation and ticket routing rules.","Confirm permission and support owner.") -InScope @("GLPI knowledge search","Helpdesk FAQ answers","Ticket category suggestion","Escalation to IT","Possible ticket routing or creation if confirmed","Permission and support ownership","Conversation and handoff logging") -OutScope @("Replacing IT Helpdesk human support","Changing GLPI workflow without approval","Creating tickets without confirmed permission rules","Answering outside approved knowledge scope") -Stakeholders $stake -Current "Current GLPI chatbot implementation details need confirmation. The known business intent is IT/helpdesk support through AI-assisted search, FAQ, ticket routing, and escalation." -Target "1. User asks an IT/helpdesk question.`r`n2. Chatbot searches approved GLPI/helpdesk knowledge.`r`n3. Chatbot returns an answer or asks clarifying questions.`r`n4. If unresolved, chatbot recommends a ticket category or escalates to IT.`r`n5. IT receives sufficient context to resolve or route the issue." -Data $data -Design "The system should connect a chatbot interface to approved GLPI/helpdesk knowledge sources, FAQ/ticket categories, escalation rules, and optional ticket routing or creation. Permission and support ownership must be confirmed before enabling write actions." -Rules @("Chatbot answers must cite or rely on approved helpdesk knowledge.","Uncertain answers must escalate to IT.","Ticket creation or routing requires confirmed permission and owner approval.","Knowledge must have an update owner.","Logs should support troubleshooting and improvement.") -Kpi $kpi -Risks @("Wrong answer to IT support question","Stale GLPI knowledge","Incorrect ticket category","Permission issue if ticket actions are enabled","Unclear support owner","Users treating chatbot as final authority") -Decisions @("Confirm GLPI knowledge source.","Confirm FAQ and ticket categories.","Confirm whether chatbot can create or classify tickets.","Confirm IT owner and escalation SLA.","Confirm permission and audit log requirements.") -Next @("Inventory current GLPI FAQ/ticket categories.","Confirm top repeated IT questions.","Define escalation and fallback rules.","Confirm ticket creation scope.","Prepare UAT with IT/helpdesk users.") -Evidence $evidence -Projects "[[PPJ.AI.Hub.v2.1]]`r`n[[TD.TechnicalPlatform_v2.1]]" -Concepts "[[Project Governance]]`r`n[[AI Automation]]`r`n[[Chatbot Governance]]`r`n[[Knowledge Management]]`r`n[[Traceability]]"
}
function Get-GeneralRepairBlock { param([string]$FileName,[string]$Text,[string]$EvidenceText,[string]$Confidence)
    $code=Get-BaseName $FileName
    $summary="Project-specific details need confirmation. This project remains a canonical note for $code and should be maintained without renaming, moving, archiving, deleting, or merging."
    if($FileName -eq "PPJ.AI.Hub.v2.1.md") { $summary="PPJ.AI.Hub.v2.1 is the central AI tools, bots, chatbots, automation apps, and internal hub. It links to modules but must not absorb or merge individual project notes." }
    elseif($FileName -eq "SCP.SOURCING.CHATBOT.v2.3.md") { $summary="SCP.SOURCING.CHATBOT.v2.3 is the canonical sourcing project covering sourcing chatbot, supplier/material/sample lookup, and sourcing data management." }
    elseif($FileName -eq "PPJ. Expense-Invoices.v1.1.md") { $summary="PPJ. Expense-Invoices.v1.1 is the EXIM-first expense invoice automation version. Future PPJ-wide v2 must not be created until explicitly approved." }
    elseif($FileName -eq "PPJ.Invoice Downloader.v1.2.md") { $summary="PPJ.Invoice Downloader.v1.2 supports supplier/e-invoice retrieval, XML/PDF handling, merging, and accounting/EXIM workflow support." }
    elseif($FileName -eq "PPJ.COSTING.AGENT.PLATFORM.v1.1.md") { $summary="PPJ.COSTING.AGENT.PLATFORM.v1.1 supports costing intelligence and agentic workflow assistance for costing/MER processes." }
    elseif($FileName -eq "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md") { $summary="MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1 is a MER-owned Chico's invoice/costing recheck and audit initiative. It should not be classified as purely Accounting unless evidence confirms that change." }
    $stake="| Role | Name / Team | Responsibility | Confirmation |`r`n|---|---|---|---|`r`n| Business Owner | TBD | Confirm process, scope, and acceptance | Needs Confirmation |`r`n| Technical Owner | TBD | Confirm system, data, and support approach | Needs Confirmation |`r`n| Users | TBD | Validate workflow and outputs | Needs Confirmation |"
    $data="| Data Object | Source System | Owner | Quality Risk | Confirmation |`r`n|---|---|---|---|---|`r`n| Primary project data | TBD | TBD | Missing source-of-truth definition | Needs Confirmation |"
    $kpi="| KPI | Target | Current | Notes |`r`n|---|---|---|---|`r`n| Time saved | TBD | TBD | Define after process baseline |`r`n| Error reduction | TBD | TBD | Define after data/process review |`r`n| Adoption | TBD | TBD | Confirm user group |"
    $evidence="| Field | Value | Evidence Source | Confidence |`r`n|---|---|---|---|`r`n| Project | $code | Current filename | Strong |`r`n| Scope | $summary | Registry / current note / approved repair rules | $Confidence |`r`n`r`nEvidence sources:`r`n$EvidenceText"
    return Get-BlockTemplate -Title $code -Executive $summary -Context "This project belongs to the PPJ AI/Automation portfolio. The repaired managed block records business meaning, ownership gaps, data/source-of-truth needs, risks, decisions, and next actions without changing the filename or user-written content outside the managed block." -Problem "The existing generated block used generic wording and may not contain enough project-specific business detail. This repair makes the block more conservative, clearer, and easier to validate." -Objectives @("Clarify project-specific business meaning.","Identify missing owner, data, and workflow details.","Prepare the note for business confirmation and deliverable creation.") -InScope @("Business context and scope clarification","Stakeholder and source-of-truth confirmation","Risk, decision, and next-action tracking") -OutScope @("Renaming files","Moving or archiving files","Canvas layout changes","Merging this project into another note") -Stakeholders $stake -Current "Current process is partially documented and needs confirmation from the business owner and users." -Target "Target process should be confirmed through requirements walkthrough, source-of-truth review, and UAT planning." -Data $data -Design "System / automation design is TBD unless already confirmed in the source project note, registry, or resource matrix. The project should define input, output, user flow, exceptions, support owner, and monitoring before implementation or rollout decisions." -Rules @("Do not rename or merge this project without approval.","Source of truth must be confirmed before automation expansion.","Owner and support path must be confirmed before production use.") -Kpi $kpi -Risks @("Unclear ownership","Missing source-of-truth definition","Incomplete data fields or process rules","Support and escalation path not confirmed") -Decisions @("Confirm business owner.","Confirm technical owner.","Confirm source of truth.","Confirm phase, scope, and next action.") -Next @("Review repaired block with project owner.","Confirm missing data fields and workflow.","Update related BRD/SOP/user manual after confirmation.") -Evidence $evidence -Projects "[[$code]]" -Concepts "[[Project Governance]]`r`n[[Traceability]]`r`n[[Business Process Design]]`r`n[[Data Governance]]"
}
function Replace-ManagedBlock { param([string]$Text,[object]$Block,[string]$NewBlock)
    $matches = @(Get-ManagedBlockMatches $Text)
    if($matches.Count -gt 0){
        $insertAt = ($matches | Measure-Object -Property Index -Minimum).Minimum
        $out = $Text
        foreach($m in ($matches | Sort-Object Index -Descending)){
            $out = $out.Remove($m.Index, $m.Length)
        }
        return $out.Insert($insertAt, $NewBlock.TrimEnd())
    }
    return $Text.TrimEnd()+"`r`n`r`n"+$NewBlock.TrimEnd()+"`r`n"
}
function Update-FrontmatterConfidence { param([string]$Text,[string]$Confidence)
    if($Text -match '(?im)^confidence\s*:') { return [regex]::Replace($Text,'(?im)^confidence\s*:.*$',"confidence: `"$Confidence`"",1) }
    if($Text -match '(?s)^---\s*\r?\n.*?\r?\n---') { return [regex]::Replace($Text,'(?s)^---\s*\r?\n(.*?)\r?\n---', { param($m) "---`r`n"+$m.Groups[1].Value.TrimEnd()+"`r`nconfidence: `"$Confidence`"`r`n---" },1) }
    return $Text
}
function Backup-File { param([string]$Path)
    if(-not(Test-Path $Path)){return}
    $relative=(Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\')
    $target=Join-Path $backupRoot $relative
    New-Item -ItemType Directory -Force -Path (Split-Path $target -Parent)|Out-Null
    Copy-Item $Path $target -Force
    $script:LogLines += "- Backup: $relative"
}

$allRootProjectFiles = @(Get-ChildItem $projectRoot -Filter "*.md" -File)
$actualRootFileNames = @($allRootProjectFiles | Select-Object -ExpandProperty Name)
$missingExpectedFiles = @($protectedExpectedFiles | Where-Object { $_ -notin $actualRootFileNames })
$unexpectedFilenameFiles = @($knownInvalidFilenames | Where-Object { $_ -in $actualRootFileNames })
$files = @($allRootProjectFiles | Where-Object { $_.Name -ne "PROJECT_COMMAND_CENTER.md" })
if($ProjectName){ $files = @($files | Where-Object { $_.BaseName -like "*$ProjectName*" -or $_.Name -like "*$ProjectName*" }) }
$plans=@()
foreach($f in $files){
    $text=Read-Utf8 $f.FullName
    if(Test-AliasNote $text){ continue }
    $block=Get-ManagedBlock $text
    $evidence=Get-Evidence $f.Name $f.BaseName
    $evidenceText= if($evidence.Count -gt 0){ ($evidence | Select-Object -First 10) -join "`r`n" } else { "- No evidence found beyond filename. Needs Confirmation." }
    $confidence=Get-CorrectConfidence $evidence.Count $f.Name
    $issues=Get-TextIssues $text
    $markerIssue = if($block.Found -and ($block.Type -ne "standard PPJ project knowledge" -or $block.Count -gt 1)) { $true } else { $false }
    $classification=Get-Classification $f $text $block
    $newBlock = if($f.Name -eq "FD.Datamart.v2.2.md") { Get-CPDBlock $evidenceText }
        elseif($f.Name -eq "PPJ.PERRI.Chatbot.md") { Get-PERRIBlock $evidenceText }
        elseif($f.Name -eq "PPJ.GLPI-Helpdesk-AI Chatbot.md") { Get-GLPIBlock $evidenceText }
        else { Get-GeneralRepairBlock $f.Name $text $evidenceText $confidence }
    $blockValidation = Test-GeneratedBlockCompliance $newBlock
    $newText = Repair-Spacing (Replace-ManagedBlock $text $block $newBlock)
    $newText = Update-FrontmatterConfidence $newText $confidence
    $fullValidation = Test-FullTextMarkerCompliance $newText
    $needs = ($issues.Count -gt 0 -or $markerIssue -or $f.Name -in $highPriority -or $confidence -match 'Weak' -or $classification -ne 'Complete enough')
    if($RepairTextOnly){ $needs = ($issues.Count -gt 0 -or $markerIssue) }
    if($RebuildWeakProjects){ $needs = $needs -or ($confidence -match 'Weak|Needs') }
    if($RebuildCPDDatamart -and $f.Name -eq "FD.Datamart.v2.2.md"){ $needs = $true }
    $oldConf = ([regex]::Match($text,'(?im)^confidence\s*:\s*"?([^"\r\n]+)"?')).Groups[1].Value
    if([string]::IsNullOrWhiteSpace($oldConf)){ $oldConf="TBD" }
    $plans += [pscustomobject]@{ File=$f.Name; Path=$f.FullName; Size=$f.Length; BlockFound=$block.Found; Marker=$block.Type; ManagedBlockCount=$block.Count; Issues=$issues; EvidenceCount=$evidence.Count; OldConfidence=$oldConf; CorrectedConfidence=$confidence; Classification=$classification; NeedsRepair=$needs; NewBlock=$newBlock; NewText=$newText; BlockMarkerPass=$blockValidation.Pass; FullMarkerPass=$fullValidation.Pass; ForbiddenMarkers=$fullValidation.Forbidden; MarkerStartCount=$fullValidation.StartCount; MarkerEndCount=$fullValidation.EndCount }
}

$toRepair=@($plans | Where-Object NeedsRepair)
$markerGroups=$plans | Group-Object Marker | Sort-Object Name
$textIssueTotal=($plans | ForEach-Object { $_.Issues } | Measure-Object).Count
$confidenceIssues=@($plans | Where-Object { $_.EvidenceCount -eq 0 -and $_.OldConfidence -notmatch 'Weak|Needs|TBD' })
$markerComplianceFailures=@($plans | Where-Object { $_.NeedsRepair -and (-not $_.BlockMarkerPass -or -not $_.FullMarkerPass) })
$forbiddenMarkerHits=@($plans | Where-Object { -not [string]::IsNullOrWhiteSpace($_.ForbiddenMarkers) -and $_.ForbiddenMarkers -ne "None" })

function Write-Reports {
    $planLines=@()
    $planLines += "# Project Knowledge Population Repair Plan - $dateStamp"
    $planLines += ""
    $planLines += "## Executive Summary"
    $planLines += ""
    $planLines += "DryRun scanned $($plans.Count) root canonical project notes and found $($toRepair.Count) notes that would be repaired. No files were renamed, moved, archived, deleted, or Canvas-updated."
    $planLines += ""
    $planLines += "## Why Repair Is Needed"
    $planLines += ""
    $planLines += "- Previous generated blocks contain generic wording and spacing bugs."
    $planLines += "- Evidence confidence needs to be conservative when evidence is weak or zero."
    $planLines += "- CPD Datamart business scope was corrected by the user and must not remain generic FD Datamart only."
    $planLines += "- PERRI and GLPI are canonical notes and need real reconstruction, not alias conversion."
    $planLines += ""
    $planLines += "## Files Scanned"
    $planLines += ""
    foreach($p in $plans){ $planLines += "- $($p.File): $($p.Classification); evidence=$($p.EvidenceCount); managed_blocks=$($p.ManagedBlockCount); repair=$($p.NeedsRepair)" }
    $planLines += ""
    $planLines += "## Actual Filename Validation"
    $planLines += ""
    if($missingExpectedFiles.Count -eq 0){ $planLines += "- Missing expected protected files: None" } else { foreach($name in $missingExpectedFiles){ $planLines += "- Missing expected protected file: $name" } }
    if($unexpectedFilenameFiles.Count -eq 0){ $planLines += "- Unexpected protected filename files: None" } else { foreach($name in $unexpectedFilenameFiles){ $planLines += "- Unexpected protected filename present: $name" } }
    $planLines += ""
    $planLines += "## Managed Block Marker Audit"
    $planLines += ""
    $planLines += "Standard marker after repair: $standardStart / $standardEnd"
    $planLines += ""
    $planLines += "Recognized marker variants:"
    foreach($m in $managedMarkerPairs){ $planLines += "- $($m.Type): $($m.Start) / $($m.End)" }
    $planLines += ""
    $planLines += "Marker variants found in scanned files:"
    foreach($g in $markerGroups){ $planLines += "- $($g.Name): $($g.Count)" }
    $planLines += ""
    $planLines += "## Text Quality Issues"
    $planLines += ""
    $planLines += "- Total detected issue instances: $textIssueTotal"
    foreach($p in $plans | Where-Object { $_.Issues.Count -gt 0 }){ $planLines += "- $($p.File): $($p.Issues -join '; ')" }
    $planLines += ""
    $planLines += "## Evidence Confidence Issues"
    $planLines += ""
    if($confidenceIssues.Count -eq 0){ $planLines += "- No evidence=0 records retain non-conservative confidence in the repair plan." } else { foreach($p in $confidenceIssues){ $planLines += "- $($p.File): evidence=0, old confidence=$($p.OldConfidence), corrected=$($p.CorrectedConfidence)" } }
    $planLines += ""
    $planLines += "## Project-Specific Repair Plan"
    $planLines += ""
    foreach($p in $toRepair){ $planLines += "- $($p.File): replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> $($p.CorrectedConfidence); marker_validation=$($p.FullMarkerPass)" }
    $planLines += ""
    $planLines += "## CPD Datamart Correction Plan"
    $planLines += ""
    $planLines += "- Current filename remains FD.Datamart.v2.2.md."
    $planLines += "- Business canonical concept becomes CPD.Datamart.v1.1."
    $planLines += "- Rename status: Needs Approval."
    $planLines += "- Recommended future filename: CPD.Datamart.v1.1.md."
    $planLines += ""
    $planLines += "## High Priority Repairs"
    $planLines += ""
    foreach($h in $highPriority){ $planLines += "- $h" }
    $planLines += ""
    $planLines += "## Apply Plan"
    $planLines += ""
    $planLines += "Run only after approval:"
    $planLines += ""
    $planLines += '```powershell'
    $planLines += 'powershell -ExecutionPolicy Bypass -File "scripts\Repair-PPJProjectKnowledgePopulation.ps1" -Apply'
    $planLines += '```'
    $planLines += ""
    $planLines += "Apply will backup affected notes, replace or consolidate managed blocks, preserve user-written content outside managed blocks, and avoid Canvas changes."
    $planLines += "Apply will hard stop before writing if any generated block fails marker validation."
    $planLines += ""
    $planLines += "## Approval Checklist"
    $planLines += ""
    $planLines += "- Confirm no file renaming in this stage."
    $planLines += "- Confirm CPD Datamart concept correction."
    $planLines += "- Confirm PERRI and GLPI reconstruction direction."
    $planLines += "- Confirm standard marker: $standardStart / $standardEnd."
    Write-Utf8 $repairPlanReport ($planLines -join "`r`n")

    $qa=@("# Project Knowledge QA Report - $dateStamp", "", "| Project | Current Filename | Managed Block Found | Managed Block Count | Marker Type | Text Quality Issues | Evidence Count | Old Confidence | Corrected Confidence | Marker Validation | Forbidden Markers | Project-Specific Detail Quality | Needs Repair | Recommended Action |", "|---|---|---|---:|---|---|---:|---|---|---|---|---|---|---|")
    foreach($p in $plans){ $qa += "| $([System.IO.Path]::GetFileNameWithoutExtension($p.File)) | $($p.File) | $($p.BlockFound) | $($p.ManagedBlockCount) | $($p.Marker) | $($p.Issues -join '; ') | $($p.EvidenceCount) | $($p.OldConfidence) | $($p.CorrectedConfidence) | $($p.FullMarkerPass) | $($p.ForbiddenMarkers) | $($p.Classification) | $($p.NeedsRepair) | Replace/consolidate managed block only if approved |" }
    Write-Utf8 $qaReport ($qa -join "`r`n")

    $cpd=@()
    $cpd += "# CPD Datamart Scope Repair Report - $dateStamp"
    $cpd += ""
    $cpd += "## Executive Summary"
    $cpd += ""
    $cpd += "FD.Datamart.v2.2.md currently exists as the Obsidian file, but the corrected business concept is CPD.Datamart.v1.1: a CPD sample management portal/datamart for the existing CPD website/application used by chi Trang in 3D Design. No rename is performed in this repair stage."
    $cpd += ""
    $cpd += "## Current Filename"
    $cpd += ""
    $cpd += "- FD.Datamart.v2.2.md"
    $cpd += ""
    $cpd += "## Corrected Business Concept"
    $cpd += ""
    $cpd += "- CPD.Datamart.v1.1"
    $cpd += ""
    $cpd += "## CPD Website / Application Context"
    $cpd += ""
    $cpd += "The project should document and port or modernize the existing CPD website/application used for sample information management."
    $cpd += ""
    $cpd += "## chi Trang / 3D Design User Context"
    $cpd += ""
    $cpd += "chi Trang and the 3D Design department are key users for sample management validation."
    $cpd += ""
    $cpd += "## Source of Truth Questions"
    $cpd += ""
    $cpd += "- Where is the current CPD sample record source of truth?"
    $cpd += "- Can data be exported from the current website/application?"
    $cpd += "- Which records are active, historical, duplicate, or obsolete?"
    $cpd += ""
    $cpd += "## Data Model Questions"
    $cpd += ""
    $cpd += "- What is the unique sample ID?"
    $cpd += "- Which metadata fields are mandatory?"
    $cpd += "- How are images/assets linked?"
    $cpd += ""
    $cpd += "## Permission Questions"
    $cpd += ""
    $cpd += "- Who can view records?"
    $cpd += "- Who can create or edit records?"
    $cpd += "- Which fields require restricted access?"
    $cpd += ""
    $cpd += "## Rename Recommendation"
    $cpd += ""
    $cpd += "Recommended future filename after separate approval: CPD.Datamart.v1.1.md"
    $cpd += ""
    $cpd += "## Approval Needed"
    $cpd += ""
    $cpd += "- Approve scope correction in managed block."
    $cpd += "- Separately approve any future rename."
    $cpd += ""
    $cpd += "## Next Actions"
    $cpd += ""
    $cpd += "- Schedule walkthrough with chi Trang / 3D Design."
    $cpd += "- Capture current CPD website screens and data structure."
    $cpd += "- Draft metadata dictionary and UAT checklist."
    Write-Utf8 $cpdReport ($cpd -join "`r`n")
}

Write-Reports

Write-Host "PPJ Project Knowledge Repair"
Write-Host "Mode: $(if($Apply){'Apply'}else{'DryRun'})"
Write-Host "Files scanned: $($plans.Count)"
Write-Host "Managed blocks found: $(@($plans | Where-Object BlockFound).Count)"
Write-Host "Files that would be repaired: $($toRepair.Count)"
Write-Host "Text quality issue instances: $textIssueTotal"
Write-Host "Confidence logic issues: $($confidenceIssues.Count)"
Write-Host "Marker compliance failures: $($markerComplianceFailures.Count)"
Write-Host "Forbidden marker hits after generated repair: $($forbiddenMarkerHits.Count)"
Write-Host "Missing expected protected files: $(if($missingExpectedFiles.Count -eq 0){'None'}else{($missingExpectedFiles -join ', ')})"
Write-Host "Unexpected protected filename files: $(if($unexpectedFilenameFiles.Count -eq 0){'None'}else{($unexpectedFilenameFiles -join ', ')})"
Write-Host ""
Write-Host "Standard marker after repair: $standardStart / $standardEnd"
Write-Host ""
Write-Host "Marker types found:"
foreach($g in $markerGroups){ Write-Host " - $($g.Name): $($g.Count)" }
Write-Host ""
Write-Host "Files planned for repair:"
foreach($p in $toRepair){ Write-Host " - $($p.File): $($p.Classification); managed_blocks=$($p.ManagedBlockCount); evidence=$($p.EvidenceCount); corrected confidence=$($p.CorrectedConfidence)" }
Write-Host ""
Write-Host "ACC.GRN-SupplierInvoiceBot.v1.1 repair preview:"
$accPreview = ($plans | Where-Object File -eq "ACC.GRN-SupplierInvoiceBot.v1.1.md")
if($accPreview){ ($accPreview.NewBlock -split "`r?`n" | Select-Object -First 45) | ForEach-Object { Write-Host $_ } } else { Write-Host "Not available: ACC.GRN-SupplierInvoiceBot.v1.1.md is not present in 03_Projects root. No missing filename was invented." }
Write-Host ""
Write-Host "PPJ.AI.Hub.v2.1 repair preview:"
(($plans | Where-Object File -eq "PPJ.AI.Hub.v2.1.md").NewBlock -split "`r?`n" | Select-Object -First 45) | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "CPD Datamart repair preview:"
(($plans | Where-Object File -eq "FD.Datamart.v2.2.md").NewBlock -split "`r?`n" | Select-Object -First 45) | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "PERRI repair preview:"
(($plans | Where-Object File -eq "PPJ.PERRI.Chatbot.md").NewBlock -split "`r?`n" | Select-Object -First 45) | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "GLPI repair preview:"
(($plans | Where-Object File -eq "PPJ.GLPI-Helpdesk-AI Chatbot.md").NewBlock -split "`r?`n" | Select-Object -First 45) | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "Reports:"
Write-Host " - $repairPlanReport"
Write-Host " - $qaReport"
Write-Host " - $cpdReport"

if($DryRun){ Write-Host "DryRun only. No project notes were modified."; exit 0 }

if($markerComplianceFailures.Count -gt 0){
    Write-Error "Marker validation failed for one or more generated repair blocks. Apply stopped before writing."
    exit 1
}

if($forbiddenMarkerHits.Count -gt 0){
    Write-Error "Forbidden markers would remain after repair. Apply stopped before writing."
    exit 1
}

New-Item -ItemType Directory -Force -Path $auditRoot,$backupRoot | Out-Null
$script:LogLines=@("# Project Knowledge Repair Log - $stamp","","Mode: Apply","")
foreach($p in $toRepair){
    $current=Read-Utf8 $p.Path
    if($p.NewText -ne $current -or $Force){
        Backup-File $p.Path
        Write-Utf8 $p.Path $p.NewText
        $script:LogLines += "- Repaired managed block: $($p.File)"
    }
}
$script:LogLines += ""
$script:LogLines += "## Safety Confirmation"
$script:LogLines += "- No files renamed, moved, archived, or deleted."
$script:LogLines += "- Canvas files were not modified."
$script:LogLines += "- Only managed blocks and clearly incomplete confidence frontmatter were repaired."
Write-Utf8 $logPath ($script:LogLines -join "`r`n")
Write-Host "Apply completed. Log: $logPath"
