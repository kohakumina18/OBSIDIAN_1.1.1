param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [switch]$CreateCPDProject,
    [switch]$UpdateAgents,
    [switch]$UpdateProjectNotes,
    [switch]$UpdateRegistry,
    [switch]$UpdateReports
)

$ErrorActionPreference = "Stop"
if (-not $Apply) { $DryRun = $true }

$vaultRoot = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$dateStamp = Get-Date -Format "yyyyMMdd"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$backupRoot = Join-Path $auditRoot "FD_CPD_Datamart_Separation_Backup\$stamp"
$logPath = Join-Path $auditRoot "FD_CPD_DATAMART_SEPARATION_LOG_$stamp.md"
$reportPath = Join-Path $vaultRoot "10_Reports\FD_CPD_DATAMART_SEPARATION_CORRECTION_REPORT_$dateStamp.md"

$fdPath = Join-Path $vaultRoot "03_Projects\FD.Datamart.v2.2.md"
$cpdPath = Join-Path $vaultRoot "03_Projects\CPD.Datamart.v1.1.md"
$agentsPath = Join-Path $vaultRoot "AGENTS.md"
$readmePath = Join-Path $vaultRoot "README_PPJ_OBSIDIAN_SYSTEM.md.md"
$registryRoot = Join-Path $vaultRoot "03_Projects\_Registry"
$reportsRoot = Join-Path $vaultRoot "10_Reports"
$scriptsRoot = Join-Path $vaultRoot "scripts"
$canvasRoot = Join-Path $vaultRoot "03_Projects\Canvas"
$selfScriptName = "Correct-FD-CPD-Datamart-Separation.ps1"

$managedStart = "<!-- PPJ_PROJECT_KNOWLEDGE_START -->"
$managedEnd = "<!-- PPJ_PROJECT_KNOWLEDGE_END -->"

$wrongPatterns = @(
    "FD.Datamart.v2.2 represents Business Canonical Concept CPD.Datamart.v1.1",
    "Business Canonical Concept: CPD.Datamart.v1.1",
    "Current filename: FD.Datamart.v2.2.md",
    "Recommended Future Filename: CPD.Datamart.v1.1.md",
    "port CPD sample management website",
    "Chi Trang",
    "chi Trang",
    "3D Design",
    "CPD website/application",
    "FD.Datamart.v2.2 = CPD.Datamart.v1.1",
    "FD Datamart is CPD Datamart",
    "FD.Datamart.v2.2 is CPD.Datamart.v1.1",
    "business canonical concept is CPD.Datamart.v1.1",
    "CPD sample management portal for chi Trang",
    "CPD sample management datamart / portal"
)

function Read-Utf8 { param([string]$Path) if (Test-Path $Path) { Get-Content -Raw -Encoding UTF8 $Path } else { "" } }
function Write-Utf8 { param([string]$Path,[string]$Text) $dir = Split-Path $Path -Parent; if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }; $Text | Set-Content -Encoding UTF8 $Path }
function Add-Utf8 { param([string]$Path,[string]$Text) Add-Content -Encoding UTF8 -Path $Path -Value $Text }
function Get-Relative { param([string]$Path) return (Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\') }
function Backup-File { param([string]$Path) if(Test-Path $Path){ $relative=Get-Relative $Path; $target=Join-Path $backupRoot $relative; New-Item -ItemType Directory -Force -Path (Split-Path $target -Parent)|Out-Null; Copy-Item $Path $target -Force; $script:Log += "- Backup: $relative" } }

function Get-ManagedBlockInfo {
    param([string]$Text)
    $startIndex = $Text.IndexOf($managedStart)
    $endIndex = $Text.LastIndexOf($managedEnd)
    if ($startIndex -ge 0 -and $endIndex -gt $startIndex) {
        return [pscustomobject]@{ Found=$true; StartIndex=$startIndex; EndIndex=$endIndex; EndExclusive=($endIndex + $managedEnd.Length) }
    }
    return [pscustomobject]@{ Found=$false; StartIndex=-1; EndIndex=-1; EndExclusive=-1 }
}

function Replace-ManagedBlock {
    param([string]$Text,[string]$NewBlock)
    $info = Get-ManagedBlockInfo $Text
    if (-not $info.Found) { return $Text.TrimEnd() + "`r`n`r`n" + $NewBlock.TrimEnd() + "`r`n" }
    return $Text.Substring(0,$info.StartIndex) + $NewBlock.TrimEnd() + $Text.Substring($info.EndExclusive)
}

function Search-WrongMappings {
    $targets = @()
    foreach($p in @($agentsPath,$readmePath,$fdPath,$cpdPath)) { if(Test-Path $p){ $targets += Get-Item $p } }
    if(Test-Path $registryRoot){ $targets += Get-ChildItem $registryRoot -Filter "*.md" -File }
    if(Test-Path $reportsRoot){ $targets += Get-ChildItem $reportsRoot -Filter "*.md" -File | Where-Object { $_.FullName -ne $reportPath } }
    if(Test-Path $scriptsRoot){ $targets += Get-ChildItem $scriptsRoot -Filter "*.ps1" -File | Where-Object { $_.Name -ne $selfScriptName } }
    if(Test-Path $canvasRoot){ $targets += Get-ChildItem $canvasRoot -Filter "*.canvas" -File }
    $hits = @()
    foreach($file in ($targets | Sort-Object FullName -Unique)) {
        $text = Read-Utf8 $file.FullName
        foreach($pattern in $wrongPatterns) {
            if($text -like "*$pattern*") {
                $hits += [pscustomobject]@{ File=(Get-Relative $file.FullName); Pattern=$pattern }
            }
        }
        if((Get-Relative $file.FullName) -eq "03_Projects\FD.Datamart.v2.2.md") {
            foreach($pattern in @("CPD","3D Design","Chi Trang","chi Trang","CPD.Datamart.v1.1")) {
                if($text -like "*$pattern*") { $hits += [pscustomobject]@{ File=(Get-Relative $file.FullName); Pattern="FD-specific forbidden reference: $pattern" } }
            }
        }
    }
    return @($hits | Sort-Object File,Pattern -Unique)
}

$fdBlock = @"
$managedStart

# Project Knowledge Detail

## Executive Summary
FD.Datamart.v2.2 is the FD / fabric datamart project using Directus as a backend/admin/data platform. The project supports FD sample or fabric data management and includes a module for QR design or QR information formatting so QR codes can be attached to hangers.

This project is separate from CPD.Datamart.v1.1.

## Business Context
FD needs a structured way to manage fabric/sample/hanger-related data and make it reusable for lookup, printing, QR formatting, and operational follow-up. Directus can provide the admin/data management layer, while the QR design module supports hanger usage by turning the data into a scannable or printable format.

## Problem Statement
Fabric and hanger-related data can become fragmented if the data model, QR format, and ownership are not standardized. Without a governed datamart, FD users may need to manage sample/fabric information manually or across scattered files, making lookup, update, and QR hanger preparation inefficient.

## Objectives

- Build or stabilize FD datamart using Directus.
- Define fabric/sample/hanger data fields.
- Support QR design or QR information format for hanger usage.
- Improve lookup and reuse of FD data.
- Clarify ownership, permission, and update process.
- Prepare data foundation for future search, reporting, or AI-assisted lookup if approved.

## Scope

### In Scope

- FD / fabric / hanger-related data model
- Directus data management
- QR design or QR information module
- Hanger QR usage flow
- Data ownership and permission
- UAT with FD users
- Data quality checks for required fields

### Out of Scope

- CPD image search library
- 3D Design sample library
- CPD.Datamart.v1.1
- Sourcing chatbot repository
- R&D Wash sampling portal
- Full AI recommendation before data is stable

## Stakeholders

| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Business Owner | FD | Confirm data fields, hanger workflow, and usage | Needs Confirmation |
| BA / Coordination | Khoa | Process mapping, requirements, UAT coordination | Inferred from portfolio context |
| Technical / Data | Nghia, Nam, Linh | Directus, data model, UI or QR support | Needs Confirmation |
| Users | FD / sample / hanger users | Search, manage, print, or scan hanger information | Needs Confirmation |

## Current Process
TBD after walkthrough.

Expected current process:

1. FD users manage fabric/sample/hanger-related data.
2. Data is prepared for hanger usage.
3. QR format or QR information needs to be designed or generated.
4. QR is attached to hanger.
5. Users scan or use the hanger QR to access relevant information.

## Target Process

1. FD user manages data in Directus or the target FD datamart interface.
2. Required fields are validated.
3. User generates or designs QR information format for hanger.
4. QR is attached to the hanger.
5. Scanning or using the QR leads to the correct sample/fabric/hanger information.
6. Updates are governed by permission and ownership rules.

## Data and Source of Truth

| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| Fabric/sample record | FD Datamart / Directus | FD | Missing or inconsistent metadata | Needs Confirmation |
| Hanger information | FD Datamart / QR module | FD | Wrong QR mapping or outdated data | Needs Confirmation |
| QR format/design | QR design module | FD / IT | Format mismatch or unreadable QR | Needs Confirmation |
| User permission | Directus / internal access model | IT / FD | Incorrect edit/read access | Needs Confirmation |

## System / Automation Design
The system should use Directus or a similar data platform to manage FD data. A QR design or QR information module should generate the structure needed for hanger usage. The system should support data CRUD, validation, permission, and stable links between hanger QR and underlying FD records.

## Business Rules

- Every hanger QR should map to the correct FD record.
- Required metadata must be confirmed with FD.
- QR format should be readable and stable.
- Only authorized users can update FD records.
- Data changes should not break existing hanger QR links.
- UAT must include actual hanger usage or QR scan validation.

## User Flow

1. User opens FD Datamart / Directus.
2. User creates or updates fabric/sample/hanger record.
3. System validates mandatory fields.
4. User generates or previews QR information format.
5. User attaches QR to hanger.
6. User scans or opens QR link.
7. System displays the correct FD information.

## KPI / Success Metrics

| KPI | Target | Current | Notes |
|---|---|---|---|
| Hanger QR preparation time | TBD | TBD | Measure before/after |
| QR mapping accuracy | TBD | TBD | Must be validated in UAT |
| Required field completion | TBD | TBD | Data quality KPI |
| FD user adoption | TBD | TBD | Needs baseline |
| Data lookup time | TBD | TBD | Measure before/after |

## Risks and Blockers

- Directus data model may be incomplete.
- QR format may not match hanger operation.
- Data ownership may be unclear.
- QR link stability must be guaranteed.
- FD and CPD scopes may be confused if not documented separately.

## Decisions Needed

- Confirm final FD data model.
- Confirm Directus role and target architecture.
- Confirm QR design/module requirement.
- Confirm QR output format and scan behavior.
- Confirm owner and UAT users.
- Confirm whether this project should stay as FD.Datamart.v2.2 or be renamed later.

## Next Actions

- Walk through current FD hanger workflow.
- Confirm Directus collections and fields.
- Define QR/hanger data mapping.
- Validate QR scan behavior.
- Prepare UAT checklist with FD users.
- Keep CPD.Datamart.v1.1 as separate project.

## Evidence and Confidence

| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Project identity | FD Datamart with Directus and QR hanger design module | User correction | Strong |
| CPD relationship | Separate from CPD.Datamart.v1.1 | User correction | Strong |
| Technical platform | Directus | User correction | Strong |
| Business use | QR design / QR attached to hanger | User correction | Strong |
| Phase | TBD | Needs registry confirmation | Needs Confirmation |

Related Concepts
[[Project Governance]]
[[Traceability]]
[[Data Repository]]
[[QR Workflow]]
[[Data Quality]]
[[Permission Model]]

Methods
[[Requirement Elicitation]]
[[Current State Analysis]]
[[Data Mapping]]
[[UAT Planning]]
[[Acceptance Criteria]]

Projects
[[CPD.Datamart.v1.1]]
[[SCP.SOURCING.CHATBOT.v2.3]]
[[TD.TechnicalPlatform_v2.1]]
[[PPJ.AI.Hub.v2.1]]

Deliverables
[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]

$managedEnd
"@

$cpdBlock = @"
$managedStart

# Project Knowledge Detail

## Executive Summary
CPD.Datamart.v1.1 is a separate CPD / 3D Design datamart project. It focuses on image search and a 3D sample library for the 3D Design department.

This project is separate from FD.Datamart.v2.2.

## Business Context
The 3D Design department needs a searchable visual sample library where users can find sample images, references, and related 3D sample assets. The project should support image search, metadata governance, sample library structure, and reuse of visual sample knowledge.

## Problem Statement
Visual sample knowledge can become difficult to reuse if images and 3D sample references are stored across folders, unmanaged websites, or disconnected tools. Without a governed CPD datamart, users may struggle to find relevant sample images, compare designs, or reuse previous 3D sample assets.

## Objectives

- Build a CPD / 3D Design datamart for visual sample library.
- Support image search and sample lookup.
- Define sample image metadata.
- Organize 3D sample assets and references.
- Clarify permission and ownership.
- Prepare foundation for future AI visual search if approved.

## Scope

### In Scope

- CPD / 3D Design sample library
- Image search
- 3D sample asset metadata
- Visual sample lookup
- Permission and ownership
- Data quality and duplicate checking
- User validation with 3D Design users

### Out of Scope

- FD Directus hanger QR module
- FD.Datamart.v2.2
- R&D Wash sampling portal
- Sourcing chatbot repository
- AI visual recommendation before image data is stable

## Stakeholders

| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Business Owner | 3D Design / CPD | Confirm sample library workflow and metadata | Needs Confirmation |
| Key User | Chi Trang / 3D Design | Validate sample library and search workflow | Inferred from user correction |
| BA / Coordination | Khoa | Process mapping, requirements, UAT coordination | Inferred from portfolio context |
| Technical / Data | TBD | Datamart, image search, data model support | Needs Confirmation |
| Users | 3D Design / CPD users | Search and reuse sample images or 3D assets | Needs Confirmation |

## Current Process
TBD after walkthrough.

Expected current process:

1. 3D Design users manage or reference visual sample information.
2. Sample images and 3D sample assets are stored in the current library, website, folders, or application.
3. Users search manually or through existing limited search.
4. Reuse depends on naming, folder structure, and personal knowledge.

## Target Process

1. User opens CPD Datamart / 3D sample library.
2. User searches by keyword, metadata, image, category, buyer, style, fabric, or other agreed fields.
3. System returns relevant sample images and 3D sample references.
4. User opens sample detail.
5. Authorized users update metadata or upload new assets.
6. Data quality checks prevent duplicates and missing required fields.

## Data and Source of Truth

| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| Sample image | CPD / 3D Design library | 3D Design | Missing metadata or duplicate image | Needs Confirmation |
| 3D sample asset | CPD / 3D Design storage | 3D Design | Broken links or inconsistent naming | Needs Confirmation |
| Sample metadata | CPD Datamart | 3D Design / CPD | Inconsistent tags or categories | Needs Confirmation |
| User permission | Internal access model | IT / 3D Design | Wrong edit/read access | Needs Confirmation |

## System / Automation Design
The system should operate as a visual datamart and searchable library. It should support image storage or image references, metadata tagging, search/filter, duplicate detection, permission, and future AI-powered visual search if approved.

## Business Rules

- Every sample image should have stable metadata.
- 3D sample assets should be linked to the correct sample record.
- Duplicate or near-duplicate images should be flagged where possible.
- Editing rights should be limited to authorized users.
- Search fields must be confirmed with 3D Design users.
- UAT must include real search scenarios from 3D Design.

## User Flow

1. User opens CPD Datamart.
2. User searches by text, metadata, or image if available.
3. System returns matching sample images and 3D assets.
4. User opens sample detail.
5. User downloads, references, or reuses the sample.
6. Authorized user updates metadata or adds new samples.
7. Changes are logged or traceable.

## KPI / Success Metrics

| KPI | Target | Current | Notes |
|---|---|---|---|
| Sample search time | TBD | TBD | Measure before/after |
| Search relevance | TBD | TBD | Needs user validation |
| Metadata completeness | TBD | TBD | Data quality KPI |
| Duplicate reduction | TBD | TBD | Needs baseline |
| 3D Design adoption | TBD | TBD | Needs baseline |

## Risks and Blockers

- Image metadata may be incomplete.
- Existing image folders or library may not be standardized.
- Image search quality depends on tagging or visual embedding quality.
- 3D sample asset links may be unstable.
- Permission model may be unclear.
- FD and CPD scopes may be confused if not documented separately.

## Decisions Needed

- Confirm current CPD / 3D Design sample library source.
- Confirm whether image search is metadata-based, visual similarity-based, or both.
- Confirm required metadata fields.
- Confirm technical approach for image storage and search.
- Confirm owner and UAT users.
- Confirm whether to create or promote CPD.Datamart.v1.1 as canonical root project note.

## Next Actions

- Confirm current CPD / 3D Design library location.
- Walk through Chi Trang / 3D Design sample search workflow.
- Collect sample image and 3D asset examples.
- Define metadata dictionary.
- Define search scenarios.
- Prepare UAT checklist.
- Keep FD.Datamart.v2.2 separate.

## Evidence and Confidence

| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Project identity | CPD Datamart with image search and 3D sample library | User correction | Strong |
| Department | 3D Design / CPD | User correction | Strong |
| Key capability | Image search | User correction | Strong |
| Relationship to FD | Separate from FD.Datamart.v2.2 | User correction | Strong |
| Phase | TBD | Needs registry confirmation | Needs Confirmation |

Related Concepts
[[Project Governance]]
[[Traceability]]
[[Image Search]]
[[Sample Library]]
[[Data Repository]]
[[Data Quality]]
[[Permission Model]]

Methods
[[Requirement Elicitation]]
[[Current State Analysis]]
[[Data Mapping]]
[[Search Requirement Design]]
[[UAT Planning]]

Projects
[[FD.Datamart.v2.2]]
[[TD.TechnicalPlatform_v2.1]]
[[PPJ.AI.Hub.v2.1]]
[[SCP.SOURCING.CHATBOT.v2.3]]

Deliverables
[[Decision_Driven_BRD]]
[[Data_Dictionary_Template]]
[[User_Manual_Template]]
[[UAT_Checklist_Template]]

$managedEnd
"@

$cpdFullNote = @"
---
type: "project"
project_name: "CPD.Datamart.v1.1"
project_code: "CPD.Datamart.v1.1"
department: "CPD / 3D Design"
object: "3D sample library / image search"
project_characteristic: "datamart"
version: "v1.1"
phase: "TBD"
cluster: "Data / Dashboard / Portal"
owner: "TBD"
business_owner: "3D Design / CPD"
technical_owner: "TBD"
status: "TBD"
progress: "TBD"
priority: "TBD"
blocked: "TBD"
decision_needed: "Confirm source of truth, owner, metadata, and search approach"
next_action: "Walk through Chi Trang / 3D Design sample search workflow"
last_updated: "$(Get-Date -Format "yyyy-MM-dd")"
confidence: "Strong for corrected business concept; implementation details need confirmation"
source_files: []
---

$cpdBlock
"@

$agentCorrection = @"

## FD Datamart and CPD Datamart Separation

FD.Datamart.v2.2 and CPD.Datamart.v1.1 are separate projects.

### FD.Datamart.v2.2

FD.Datamart.v2.2 is the FD / fabric datamart project using Directus as a backend/admin/data platform. It includes a module for QR design or QR information formatting for hanger usage.

Do not describe FD.Datamart.v2.2 as CPD.Datamart.v1.1.

### CPD.Datamart.v1.1

CPD.Datamart.v1.1 is a separate CPD / 3D Design datamart project for image search and a 3D sample library.

Do not merge CPD.Datamart.v1.1 into FD.Datamart.v2.2.
"@

$registryCorrection = @"

## FD / CPD Datamart Separation

- [[FD.Datamart.v2.2]]: FD / fabric datamart using Directus, including QR design or QR information formatting for hanger usage.
- [[CPD.Datamart.v1.1]]: CPD / 3D Design datamart for image search and 3D sample library.

These are separate projects and must not be merged.
"@

$reportCorrection = @"

## Correction Note - FD / CPD Datamart Separation
FD.Datamart.v2.2 and CPD.Datamart.v1.1 are separate projects.
Previous mapping that treated FD as CPD is invalid.
"@

function Get-CorrectionPlan {
    $hits = Search-WrongMappings
    $cpdExists = Test-Path $cpdPath
    $fdNeedsUpdate = $false
    if(Test-Path $fdPath){
        $fdText = Read-Utf8 $fdPath
        foreach($p in @("CPD.Datamart.v1.1","CPD website/application","3D Design","Chi Trang","chi Trang","CPD sample")){
            if($fdText -like "*$p*"){ $fdNeedsUpdate = $true }
        }
    }
    $agentNeedsUpdate = (Test-Path $agentsPath) -and ((Read-Utf8 $agentsPath) -like "*FD.Datamart.v2.2*CPD.Datamart.v1.1*" -or (Read-Utf8 $agentsPath) -like "*Business canonical concept is CPD.Datamart.v1.1*")
    $registryFiles = if(Test-Path $registryRoot){ @(Get-ChildItem $registryRoot -Filter "*.md" -File) } else { @() }
    $registryNeedsUpdate = @()
    foreach($r in $registryFiles){ $raw=Read-Utf8 $r.FullName; if($raw -like "*FD.Datamart.v2.2*" -or $raw -like "*CPD.Datamart.v1.1*"){ $registryNeedsUpdate += $r.FullName } }
    $reportNeedsUpdate = @()
    if(Test-Path $reportsRoot){
        foreach($r in Get-ChildItem $reportsRoot -Filter "*.md" -File | Where-Object { $_.FullName -ne $reportPath }){ $raw=Read-Utf8 $r.FullName; if($raw -like "*FD.Datamart.v2.2*CPD.Datamart.v1.1*" -or $raw -like "*Recommended Future Filename: CPD.Datamart.v1.1.md*" -or $raw -like "*CPD sample management portal*" -or $raw -like "*FD Datamart business scope was corrected*"){ $reportNeedsUpdate += $r.FullName } }
    }
    return [pscustomobject]@{ Hits=$hits; CPDExists=$cpdExists; FDNeedsUpdate=$fdNeedsUpdate; AgentNeedsUpdate=$agentNeedsUpdate; RegistryNeedsUpdate=$registryNeedsUpdate; ReportNeedsUpdate=$reportNeedsUpdate }
}

function Write-Report {
    param([object]$Plan)
    $lines=@()
    $lines += "# FD / CPD Datamart Separation Correction Report - $dateStamp"
    $lines += ""
    $lines += "## Executive Summary"
    $lines += ""
    $lines += "FD.Datamart.v2.2 and CPD.Datamart.v1.1 are separate projects. This DryRun reports incorrect FD/CPD mapping references and proposes source-of-truth corrections. Canvas is detection-only and is not modified."
    $lines += ""
    $lines += "## Incorrect Assumption Found"
    $lines += ""
    $lines += "- Incorrect: FD.Datamart.v2.2 equals CPD.Datamart.v1.1."
    $lines += "- Correct: FD.Datamart.v2.2 is FD / Directus / QR hanger data. CPD.Datamart.v1.1 is CPD / 3D Design / image search / 3D sample library."
    $lines += ""
    $lines += "## Correct FD Datamart Definition"
    $lines += ""
    $lines += "FD.Datamart.v2.2 is the FD / fabric datamart project using Directus as a backend/admin/data platform. It supports FD sample/fabric/hanger-related data and QR design or QR information formatting for hanger usage."
    $lines += ""
    $lines += "## Correct CPD Datamart Definition"
    $lines += ""
    $lines += "CPD.Datamart.v1.1 is a separate CPD / 3D Design datamart for image search and 3D sample library management."
    $lines += ""
    $lines += "## Files Containing Wrong Mapping"
    $lines += ""
    if($Plan.Hits.Count -eq 0){ $lines += "- None found" } else { foreach($h in $Plan.Hits){ $lines += "- $($h.File): $($h.Pattern)" } }
    $lines += ""
    $lines += "## Correction Plan"
    $lines += ""
    $lines += "- FD.Datamart.v2.2.md managed block should be corrected to FD / Directus / QR hanger design module: $($Plan.FDNeedsUpdate)"
    $lines += "- CPD.Datamart.v1.1.md exists: $($Plan.CPDExists)"
    $lines += "- CPD.Datamart.v1.1.md should be created only with -Apply -CreateCPDProject if missing."
    $lines += "- AGENTS.md update needed: $($Plan.AgentNeedsUpdate)"
    $lines += "- Registry files considered for update: $($Plan.RegistryNeedsUpdate.Count)"
    $lines += "- Reports needing correction note: $($Plan.ReportNeedsUpdate.Count)"
    $lines += ""
    $lines += "## Apply Plan"
    $lines += ""
    $lines += "Use targeted flags only after approval: -UpdateProjectNotes, -CreateCPDProject, -UpdateAgents, -UpdateRegistry, -UpdateReports."
    $lines += ""
    $lines += "## Approval Checklist"
    $lines += ""
    $lines += "- Confirm FD and CPD are separate projects."
    $lines += "- Confirm no Canvas update in this script."
    $lines += "- Confirm CPD project note creation if missing."
    $lines += "- Confirm report correction notes are append-only."
    $lines += ""
    $lines += "## Canvas Update Dependency"
    $lines += ""
    $lines += "Canvas should be updated only after source-of-truth notes and registry are corrected."
    Write-Utf8 $reportPath ($lines -join "`r`n")
}

$plan = Get-CorrectionPlan
Write-Report $plan

Write-Host "FD / CPD Datamart Separation Correction"
Write-Host "Mode: $(if($Apply){'Apply'}else{'DryRun'})"
Write-Host "Wrong mapping hits: $($plan.Hits.Count)"
Write-Host "CPD.Datamart.v1.1.md exists: $($plan.CPDExists)"
Write-Host "FD note needs managed block correction: $($plan.FDNeedsUpdate)"
Write-Host "AGENTS.md update needed: $($plan.AgentNeedsUpdate)"
Write-Host "Registry files planned: $($plan.RegistryNeedsUpdate.Count)"
Write-Host "Reports planned: $($plan.ReportNeedsUpdate.Count)"
Write-Host "Canvas update: No"
Write-Host ""
Write-Host "Files containing wrong mapping:"
if($plan.Hits.Count -eq 0){ Write-Host " - None" } else { $plan.Hits | Select-Object -First 80 | ForEach-Object { Write-Host " - $($_.File): $($_.Pattern)" } }
Write-Host ""
Write-Host "Files that would be updated with selected Apply flags:"
if($UpdateProjectNotes -or -not $Apply){ if($plan.FDNeedsUpdate){ Write-Host " - 03_Projects\FD.Datamart.v2.2.md (with -UpdateProjectNotes)" } }
if(($CreateCPDProject -or -not $Apply) -and -not $plan.CPDExists){ Write-Host " - 03_Projects\CPD.Datamart.v1.1.md (create with -CreateCPDProject)" }
if($UpdateAgents -or -not $Apply){ if($plan.AgentNeedsUpdate){ Write-Host " - AGENTS.md (with -UpdateAgents)" } }
if($UpdateRegistry -or -not $Apply){ foreach($p in $plan.RegistryNeedsUpdate){ Write-Host " - $(Get-Relative $p) (with -UpdateRegistry)" } }
if($UpdateReports -or -not $Apply){ foreach($p in $plan.ReportNeedsUpdate){ Write-Host " - $(Get-Relative $p) (append correction note with -UpdateReports)" } }
Write-Host ""
Write-Host "FD corrected preview:"
($fdBlock -split "`r?`n" | Select-Object -First 50) | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "CPD corrected preview:"
($cpdBlock -split "`r?`n" | Select-Object -First 50) | ForEach-Object { Write-Host $_ }
Write-Host ""
Write-Host "Report: $reportPath"

if($DryRun){ Write-Host "DryRun only. No files were modified."; exit 0 }

New-Item -ItemType Directory -Force -Path $backupRoot,$auditRoot | Out-Null
$script:Log = @("# FD / CPD Datamart Separation Log - $stamp", "")

if($UpdateProjectNotes -and $plan.FDNeedsUpdate){
    Backup-File $fdPath
    $fdText = Read-Utf8 $fdPath
    Write-Utf8 $fdPath (Replace-ManagedBlock $fdText $fdBlock)
    $script:Log += "- Updated FD managed block: 03_Projects\FD.Datamart.v2.2.md"
}

if($CreateCPDProject -and -not $plan.CPDExists){
    Write-Utf8 $cpdPath $cpdFullNote
    $script:Log += "- Created CPD project note: 03_Projects\CPD.Datamart.v1.1.md"
}

if($UpdateAgents -and $plan.AgentNeedsUpdate){
    Backup-File $agentsPath
    $raw = Read-Utf8 $agentsPath
    if($raw -notlike "*## FD Datamart and CPD Datamart Separation*"){
        Write-Utf8 $agentsPath ($raw.TrimEnd() + "`r`n" + $agentCorrection.TrimEnd() + "`r`n")
    }
    $script:Log += "- Appended FD/CPD separation rule to AGENTS.md"
}

if($UpdateRegistry){
    foreach($p in $plan.RegistryNeedsUpdate){
        Backup-File $p
        $raw = Read-Utf8 $p
        if($raw -notlike "*## FD / CPD Datamart Separation*"){
            Write-Utf8 $p ($raw.TrimEnd() + "`r`n" + $registryCorrection.TrimEnd() + "`r`n")
            $script:Log += "- Appended registry separation note: $(Get-Relative $p)"
        }
    }
}

if($UpdateReports){
    foreach($p in $plan.ReportNeedsUpdate){
        Backup-File $p
        $raw = Read-Utf8 $p
        if($raw -notlike "*## Correction Note - FD / CPD Datamart Separation*"){
            Write-Utf8 $p ($raw.TrimEnd() + "`r`n" + $reportCorrection.TrimEnd() + "`r`n")
            $script:Log += "- Appended report correction note: $(Get-Relative $p)"
        }
    }
}

$script:Log += ""
$script:Log += "## Safety Confirmation"
$script:Log += "- No files renamed, moved, archived, or deleted."
$script:Log += "- Canvas files were not modified."
$script:Log += "- Historical reports were not rewritten; correction notes are append-only."
Write-Utf8 $logPath ($script:Log -join "`r`n")
Write-Host "Apply completed. Log: $logPath"
