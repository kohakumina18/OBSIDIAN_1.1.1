param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force
)

$ErrorActionPreference = "Stop"
if (-not $Apply) { $DryRun = $true }

$vaultRoot = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$backupRoot = Join-Path $auditRoot "FD_CPD_Drift_Prevention_Backup\$stamp"
$logPath = Join-Path $auditRoot "FD_CPD_DRIFT_PREVENTION_LOG_$stamp.md"

$targetRelativePaths = @(
    "scripts\Repair-PPJProjectKnowledgePopulation.ps1",
    "scripts\Populate-PPJCanonicalProjectNotes.ps1",
    "scripts\Normalize-PPJProjectKnowledgeMarkers.ps1",
    "AGENTS.md",
    "03_Projects\_Registry\PPJ_PROJECT_MEMORY_INDEX.md",
    "03_Projects\_Registry\PPJ_PROJECT_MODULE_INDEX.md"
)

$fdDefinition = "FD.Datamart.v2.2 is the FD / fabric datamart project using Directus as a backend/admin/data platform. It supports FD fabric/sample/hanger data, QR design or QR information formatting, and QR attached to hanger usage. It is separate from CPD.Datamart.v1.1."
$cpdDefinition = "CPD.Datamart.v1.1 is the CPD / 3D Design datamart project for image search, 3D sample library management, and visual sample assets. It is separate from FD.Datamart.v2.2."

$wrongMappingPatterns = @(
    "Business canonical concept becomes CPD.Datamart.v1.1",
    "Business Canonical Concept | CPD.Datamart.v1.1",
    "Recommended future filename: CPD.Datamart.v1.1.md",
    "Recommended Future Filename | CPD.Datamart.v1.1.md",
    "FD.Datamart.v2.2.md currently exists as the Obsidian file, but the corrected business concept is CPD.Datamart.v1.1",
    "This project represents the CPD Datamart / sample management portal initiative",
    "Get-CPDBlock",
    "CPD Datamart business scope was corrected by the user and must not remain generic FD Datamart only",
    "User correction 2026-06-28: CPD sample management portal for chi Trang / 3D Design",
    "Confirm whether current filename should remain FD.Datamart.v2.2.md or be renamed later to CPD.Datamart.v1.1.md"
)

function Read-Utf8 {
    param([string]$Path)
    if (Test-Path $Path) { Get-Content -Raw -Encoding UTF8 $Path } else { "" }
}

function Write-Utf8 {
    param([string]$Path,[string]$Text)
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $Text | Set-Content -Encoding UTF8 $Path
}

function Get-RelativePath {
    param([string]$Path)
    return (Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\')
}

function Backup-File {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return }
    $relative = Get-RelativePath $Path
    $target = Join-Path $backupRoot $relative
    New-Item -ItemType Directory -Force -Path (Split-Path $target -Parent) | Out-Null
    Copy-Item -Path $Path -Destination $target -Force
    $script:LogLines += "- Backup: $relative"
}

function Count-Literal {
    param([string]$Text,[string]$Needle)
    return ([regex]::Matches($Text, [regex]::Escape($Needle))).Count
}

function Add-Replacement {
    param(
        [string]$File,
        [string]$Kind,
        [string]$From,
        [string]$To,
        [int]$Count
    )
    if ($Count -gt 0) {
        return [pscustomobject]@{ File=$File; Kind=$Kind; From=$From; To=$To; Count=$Count }
    }
    return $null
}

$fdFunctionReplacement = @'
function Get-FDBlock { param([string]$EvidenceText)
    $stake=@"
| Role | Name / Team | Responsibility | Confirmation |
|---|---|---|---|
| Business Owner | FD | Confirm data fields, hanger workflow, QR usage, and acceptance | Needs Confirmation |
| BA / Coordination | Khoa | Process mapping, requirements, UAT coordination | Inferred from portfolio context |
| Technical / Data | Nghia, Nam, Linh | Directus, data model, QR module, or UI support | Needs Confirmation |
| Users | FD / sample / hanger users | Manage, search, print, scan, or reuse hanger information | Needs Confirmation |
"@
    $data=@"
| Data Object | Source System | Owner | Quality Risk | Confirmation |
|---|---|---|---|---|
| Fabric/sample record | FD Datamart / Directus | FD | Missing or inconsistent metadata | Needs Confirmation |
| Hanger information | FD Datamart / QR module | FD | Wrong QR mapping or outdated data | Needs Confirmation |
| QR format/design | QR design module | FD / IT | Format mismatch or unreadable QR | Needs Confirmation |
| User permission | Directus / internal access model | IT / FD | Incorrect edit/read access | Needs Confirmation |
"@
    $kpi=@"
| KPI | Target | Current | Notes |
|---|---|---|---|
| Hanger QR preparation time | TBD | TBD | Measure before/after |
| QR mapping accuracy | TBD | TBD | Must be validated in UAT |
| Required field completion | TBD | TBD | Data quality KPI |
| FD user adoption | TBD | TBD | Needs baseline |
| Data lookup time | TBD | TBD | Measure before/after |
"@
    $evidence=@"
| Field | Value | Evidence Source | Confidence |
|---|---|---|---|
| Project identity | FD Datamart with Directus and QR hanger design module | User correction 2026-06-28 | Strong |
| CPD relationship | Separate from CPD.Datamart.v1.1 | User correction 2026-06-28 | Strong |
| Technical platform | Directus | User correction 2026-06-28 | Strong |
| Business use | QR design / QR attached to hanger | User correction 2026-06-28 | Strong |
| Phase | TBD | Needs registry confirmation | Needs Confirmation |

Evidence sources:
$EvidenceText
"@
    return Get-BlockTemplate -Title "FD.Datamart.v2.2" -Executive "FD.Datamart.v2.2 is the FD / fabric datamart project using Directus as a backend/admin/data platform. The project supports FD sample or fabric data management and includes a module for QR design or QR information formatting so QR codes can be attached to hangers.`r`n`r`nThis project is separate from CPD.Datamart.v1.1." -Context "FD needs a structured way to manage fabric/sample/hanger-related data and make it reusable for lookup, printing, QR formatting, and operational follow-up. Directus can provide the admin/data management layer, while the QR design module supports hanger usage by turning the data into a scannable or printable format." -Problem "Fabric and hanger-related data can become fragmented if the data model, QR format, and ownership are not standardized. Without a governed datamart, FD users may need to manage sample/fabric information manually or across scattered files, making lookup, update, and QR hanger preparation inefficient." -Objectives @("Build or stabilize FD datamart using Directus.","Define fabric/sample/hanger data fields.","Support QR design or QR information format for hanger usage.","Improve lookup and reuse of FD data.","Clarify ownership, permission, and update process.","Keep CPD.Datamart.v1.1 separate from FD.Datamart.v2.2.") -InScope @("FD / fabric / hanger-related data model","Directus data management","QR design or QR information module","Hanger QR usage flow","Data ownership and permission","UAT with FD users","Data quality checks for required fields") -OutScope @("CPD image search library","3D Design sample library","CPD.Datamart.v1.1","Sourcing chatbot repository","R&D Wash sampling portal","Full AI recommendation before data is stable") -Stakeholders $stake -Current "TBD after walkthrough.`r`n`r`nExpected current process:`r`n`r`n1. FD users manage fabric/sample/hanger-related data.`r`n2. Data is prepared for hanger usage.`r`n3. QR format or QR information needs to be designed or generated.`r`n4. QR is attached to hanger.`r`n5. Users scan or use the hanger QR to access relevant information." -Target "1. FD user manages data in Directus or the target FD datamart interface.`r`n2. Required fields are validated.`r`n3. User generates or designs QR information format for hanger.`r`n4. QR is attached to the hanger.`r`n5. Scanning or using the QR leads to the correct sample/fabric/hanger information.`r`n6. Updates are governed by permission and ownership rules." -Data $data -Design "The system should use Directus or a similar data platform to manage FD data. A QR design or QR information module should generate the structure needed for hanger usage. The system should support data CRUD, validation, permission, and stable links between hanger QR and underlying FD records." -Rules @("Every hanger QR should map to the correct FD record.","Required metadata must be confirmed with FD.","QR format should be readable and stable.","Only authorized users can update FD records.","Data changes should not break existing hanger QR links.","UAT must include actual hanger usage or QR scan validation.","Do not merge FD.Datamart.v2.2 with CPD.Datamart.v1.1.") -Kpi $kpi -Risks @("Directus data model may be incomplete.","QR format may not match hanger operation.","Data ownership may be unclear.","QR link stability must be guaranteed.","FD and CPD scopes may be confused if not documented separately.") -Decisions @("Confirm final FD data model.","Confirm Directus role and target architecture.","Confirm QR design/module requirement.","Confirm QR output format and scan behavior.","Confirm owner and UAT users.","Keep CPD.Datamart.v1.1 as a separate project.") -Next @("Walk through current FD hanger workflow.","Confirm Directus collections and fields.","Define QR/hanger data mapping.","Validate QR scan behavior.","Prepare UAT checklist with FD users.","Keep CPD.Datamart.v1.1 as separate project.") -Evidence $evidence -Projects "[[CPD.Datamart.v1.1]]`r`n[[SCP.SOURCING.CHATBOT.v2.3]]`r`n[[TD.TechnicalPlatform_v2.1]]`r`n[[PPJ.AI.Hub.v2.1]]" -Concepts "[[Project Governance]]`r`n[[Traceability]]`r`n[[Data Repository]]`r`n[[QR Workflow]]`r`n[[Data Quality]]`r`n[[Permission Model]]"
}
'@

function Apply-RepairScriptPatch {
    param([string]$Text,[string]$Relative)
    $out = $Text
    $changes = @()

    $oldEvidence = 'if($FileName -eq "FD.Datamart.v2.2.md") { $e += "User correction 2026-06-28: CPD sample management portal for chi Trang / 3D Design" }'
    $newEvidence = 'if($FileName -eq "FD.Datamart.v2.2.md") { $e += "User correction 2026-06-28: FD fabric datamart using Directus with QR design / QR information for hanger usage; separate from CPD.Datamart.v1.1" }'
    $count = Count-Literal $out $oldEvidence
    if ($count -gt 0) { $out = $out.Replace($oldEvidence,$newEvidence); $changes += Add-Replacement $Relative "literal" $oldEvidence $newEvidence $count }

    $oldParam = '    [switch]$RebuildCPDDatamart'
    $newParam = "    [switch]`$RebuildCPDDatamart,`r`n    [switch]`$RebuildFDDatamart"
    if ($out -like '*[switch]$RebuildCPDDatamart*' -and $out -notlike '*[switch]$RebuildFDDatamart*') {
        $out = $out.Replace($oldParam,$newParam)
        $changes += Add-Replacement $Relative "literal" $oldParam $newParam 1
    }

    $funcPattern = '(?s)function Get-CPDBlock \{ param\(\[string\]\$EvidenceText\).*?\r?\n\}\r?\nfunction Get-PERRIBlock'
    $funcMatch = [regex]::Match($out,$funcPattern)
    if ($funcMatch.Success) {
        $out = [regex]::Replace($out,$funcPattern,($fdFunctionReplacement.TrimEnd() + "`r`nfunction Get-PERRIBlock"),1)
        $changes += Add-Replacement $Relative "regex" "function Get-CPDBlock ... function Get-PERRIBlock" "function Get-FDBlock ... function Get-PERRIBlock" 1
    }

    $literalPairs = @(
        @{ From='Get-CPDBlock $evidenceText'; To='Get-FDBlock $evidenceText' },
        @{ From='if($RebuildCPDDatamart -and $f.Name -eq "FD.Datamart.v2.2.md"){ $needs = $true }'; To='if(($RebuildCPDDatamart -or $RebuildFDDatamart) -and $f.Name -eq "FD.Datamart.v2.2.md"){ $needs = $true }' },
        @{ From='- CPD Datamart business scope was corrected by the user and must not remain generic FD Datamart only.'; To='- FD Datamart business scope was corrected by the user and must remain separate from CPD.Datamart.v1.1.' },
        @{ From='## CPD Datamart Correction Plan'; To='## FD / CPD Datamart Separation Plan' },
        @{ From='- Current filename remains FD.Datamart.v2.2.md.'; To='- FD filename remains FD.Datamart.v2.2.md.' },
        @{ From='- Business canonical concept becomes CPD.Datamart.v1.1.'; To='- FD business concept remains FD.Datamart.v2.2: FD / fabric datamart with Directus and QR hanger support.' },
        @{ From='- Rename status: Needs Approval.'; To='- Rename status: No rename proposed. FD and CPD stay separate.' },
        @{ From='- Recommended future filename: CPD.Datamart.v1.1.md.'; To='- CPD.Datamart.v1.1 remains a separate project note for CPD / 3D Design image search and 3D sample library.' },
        @{ From='Confirm CPD Datamart concept correction.'; To='Confirm FD / CPD Datamart separation.' },
        @{ From='Write-Host "CPD Datamart repair preview:"'; To='Write-Host "FD Datamart repair preview:"' }
    )
    foreach ($pair in $literalPairs) {
        $count = Count-Literal $out $pair.From
        if ($count -gt 0) { $out = $out.Replace($pair.From,$pair.To); $changes += Add-Replacement $Relative "literal" $pair.From $pair.To $count }
    }

    $oldReportPath = '$cpdReport = Join-Path $vaultRoot "10_Reports\CPD_DATAMART_SCOPE_REPAIR_REPORT_$dateStamp.md"'
    $newReportPath = '$cpdReport = Join-Path $vaultRoot "10_Reports\FD_DATAMART_SCOPE_REPAIR_REPORT_$dateStamp.md"'
    $count = Count-Literal $out $oldReportPath
    if ($count -gt 0) { $out = $out.Replace($oldReportPath,$newReportPath); $changes += Add-Replacement $Relative "literal" $oldReportPath $newReportPath $count }

    $oldReportSummary = 'FD.Datamart.v2.2.md currently exists as the Obsidian file, but the corrected business concept is CPD.Datamart.v1.1: a CPD sample management portal/datamart for the existing CPD website/application used by chi Trang in 3D Design. No rename is performed in this repair stage.'
    $newReportSummary = 'FD.Datamart.v2.2.md is the FD / fabric datamart project using Directus and QR hanger support. CPD.Datamart.v1.1 is a separate CPD / 3D Design project for image search and 3D sample library. No rename, merge, move, archive, or Canvas update is performed in this repair stage.'
    $count = Count-Literal $out $oldReportSummary
    if ($count -gt 0) { $out = $out.Replace($oldReportSummary,$newReportSummary); $changes += Add-Replacement $Relative "literal" $oldReportSummary $newReportSummary $count }

    $reportPairs = @(
        @{ From='# CPD Datamart Scope Repair Report - $dateStamp'; To='# FD Datamart Scope Repair Report - $dateStamp' },
        @{ From='## Corrected Business Concept'; To='## Correct FD Business Concept' },
        @{ From='- CPD.Datamart.v1.1'; To='- FD.Datamart.v2.2: FD / fabric datamart using Directus with QR hanger support' },
        @{ From='## CPD Website / Application Context'; To='## FD Directus / QR Hanger Context' },
        @{ From='The project should document and port or modernize the existing CPD website/application used for sample information management.'; To='The project should document Directus data management, FD fabric/sample/hanger data, QR design or QR information formatting, and QR attached to hanger usage.' },
        @{ From='## chi Trang / 3D Design User Context'; To='## CPD.Datamart.v1.1 Separation' },
        @{ From='chi Trang and the 3D Design department are key users for sample management validation.'; To='CPD.Datamart.v1.1 is separate and covers CPD / 3D Design image search, 3D sample library, and visual sample assets.' },
        @{ From='Recommended future filename after separate approval: CPD.Datamart.v1.1.md'; To='No FD rename is proposed. FD.Datamart.v2.2 and CPD.Datamart.v1.1 remain separate projects.' },
        @{ From='- Approve scope correction in managed block.'; To='- Approve FD managed block correction if needed.' },
        @{ From='- Separately approve any future rename.'; To='- Do not rename FD to CPD.' },
        @{ From='- Schedule walkthrough with chi Trang / 3D Design.'; To='- Schedule walkthrough with FD users for Directus, QR, and hanger workflow.' },
        @{ From='- Capture current CPD website screens and data structure.'; To='- Capture current FD Directus collections, data fields, QR format, and hanger workflow.' },
        @{ From='- Draft metadata dictionary and UAT checklist.'; To='- Draft FD data dictionary, QR mapping, and UAT checklist.' }
    )
    foreach ($pair in $reportPairs) {
        $count = Count-Literal $out $pair.From
        if ($count -gt 0) { $out = $out.Replace($pair.From,$pair.To); $changes += Add-Replacement $Relative "literal" $pair.From $pair.To $count }
    }

    return [pscustomobject]@{ Text=$out; Changes=@($changes) }
}

function Apply-PopulateScriptPatch {
    param([string]$Text,[string]$Relative)
    $out = $Text
    $changes = @()

    $oldFdSeed = '"FD.Datamart.v2.2.md" = @{ Summary="FD/fabric/datamart/hanger or fabric database-related data project. Exact scope requires confirmation."; Department="FD"; Cluster="Sourcing / Material / Supplier Data"; Confidence="Needs Confirmation"; Type="data platform" }'
    $newFdSeed = '"FD.Datamart.v2.2.md" = @{ Summary="FD / fabric datamart using Directus as backend/admin/data platform, with QR design or QR information module and QR attached to hanger usage. Separate from CPD.Datamart.v1.1."; Department="FD"; Cluster="Sourcing / Material / Supplier Data"; Confidence="Strong for corrected business concept; implementation details need confirmation"; Type="data platform" }'
    $count = Count-Literal $out $oldFdSeed
    if ($count -gt 0) { $out = $out.Replace($oldFdSeed,$newFdSeed); $changes += Add-Replacement $Relative "literal" $oldFdSeed $newFdSeed $count }

    if ($out -like '*"FD.Datamart.v2.2.md",*' -and $out -notlike '*"CPD.Datamart.v1.1.md",*') {
        $from = '    "FD.Datamart.v2.2.md",'
        $to = "    `"FD.Datamart.v2.2.md`",`r`n    `"CPD.Datamart.v1.1.md`"," 
        $out = $out.Replace($from,$to)
        $changes += Add-Replacement $Relative "literal" $from $to 1
    }

    if ($out -notlike '*"CPD.Datamart.v1.1.md" = @{ Summary=*') {
        $anchor = $newFdSeed
        if ($out -like "*$anchor*") {
            $cpdSeed = "`r`n    `"CPD.Datamart.v1.1.md`" = @{ Summary=`"CPD / 3D Design datamart for image search, 3D sample library, and visual sample assets. Separate from FD.Datamart.v2.2.`"; Department=`"CPD / 3D Design`"; Cluster=`"Sourcing / Material / Supplier Data`"; Confidence=`"Strong for corrected business concept; implementation details need confirmation`"; Type=`"data platform`" }"
            $out = $out.Replace($anchor, $anchor + $cpdSeed)
            $changes += Add-Replacement $Relative "insert" "after FD seed" $cpdSeed 1
        }
    }

    return [pscustomobject]@{ Text=$out; Changes=@($changes) }
}

function Apply-NormalizeScriptPatch {
    param([string]$Text,[string]$Relative)
    $out = $Text
    $changes = @()

    $noop = '    @{ From="Chi Trang"; To="Chi Trang" }'
    $count = Count-Literal $out $noop
    if ($count -gt 0) {
        $out = $out.Replace($noop,'    # Semantic FD/CPD corrections are intentionally excluded from marker normalization.')
        $changes += Add-Replacement $Relative "literal" $noop '    # Semantic FD/CPD corrections are intentionally excluded from marker normalization.' $count
    }

    return [pscustomobject]@{ Text=$out; Changes=@($changes) }
}

function Apply-AgentsPatch {
    param([string]$Text,[string]$Relative)
    $out = $Text
    $changes = @()
    $wrong = "FD.Datamart.v2.2 is NOT CPD.Datamart.v1.1"
    $alreadyCorrect = ($out -like "*FD.Datamart.v2.2*Directus*QR*hanger*" -and $out -like "*CPD.Datamart.v1.1*3D Design*image search*3D sample library*")
    if (-not $alreadyCorrect) {
        $block = @"

## FD / CPD Datamart Separation Rule

- FD.Datamart.v2.2: FD / fabric datamart using Directus as backend/admin/data platform, with QR design or QR information module and QR attached to hanger usage.
- CPD.Datamart.v1.1: CPD / 3D Design datamart for image search, 3D sample library, and visual sample assets.
- Do not merge FD and CPD.
- Do not say FD business canonical concept is CPD.
- Do not say FD should be renamed to CPD.
"@
        $out = $out.TrimEnd() + "`r`n" + $block.TrimEnd() + "`r`n"
        $changes += Add-Replacement $Relative "insert" "missing FD / CPD separation rule" $block.Trim() 1
    }
    if ($out -like "*$wrong*") { $changes += Add-Replacement $Relative "scan" $wrong "Already stated as correction; no replacement needed" 1 }
    return [pscustomobject]@{ Text=$out; Changes=@($changes) }
}

function Apply-ModuleIndexPatch {
    param([string]$Text,[string]$Relative)
    $out = $Text
    $changes = @()
    if ($out -like '*[[FD.Datamart.v2.2]]*' -and $out -notlike '*[[CPD.Datamart.v1.1]]*') {
        $from = '- [[FD.Datamart.v2.2]]'
        $to = "- [[FD.Datamart.v2.2]]`r`n- [[CPD.Datamart.v1.1]]"
        $out = $out.Replace($from,$to)
        $changes += Add-Replacement $Relative "literal" $from $to 1
    }
    if ($out -notlike '*FD / CPD Datamart Separation*') {
        $block = @"

## FD / CPD Datamart Separation

- [[FD.Datamart.v2.2]]: FD / fabric datamart using Directus, including QR design or QR information formatting for hanger usage.
- [[CPD.Datamart.v1.1]]: CPD / 3D Design datamart for image search, 3D sample library, and visual sample assets.

These are separate projects and must not be merged.
"@
        $out = $out.TrimEnd() + "`r`n" + $block.TrimEnd() + "`r`n"
        $changes += Add-Replacement $Relative "insert" "missing FD / CPD separation block" $block.Trim() 1
    }
    return [pscustomobject]@{ Text=$out; Changes=@($changes) }
}

function Apply-MemoryIndexPatch {
    param([string]$Text,[string]$Relative)
    $out = $Text
    $changes = @()
    $wrongLinePattern = '(?im)^\|[^\r\n]*FD\.Datamart\.v2\.2[^\r\n]*CPD\.Datamart\.v1\.1[^\r\n]*\|\s*$'
    $matches = @([regex]::Matches($out,$wrongLinePattern))
    if ($matches.Count -gt 0) {
        $replacement = '| [[FD.Datamart.v2.2]] | [[FD.Datamart.v2.2.memory]] | [[FD.Datamart.v2.2]] | Data / Portal | TBD | TBD | FD / fabric datamart using Directus with QR hanger support | Manage FD/fabric/hanger data with QR support | Strong | 2026-06-28 |'
        $out = [regex]::Replace($out,$wrongLinePattern,$replacement)
        $changes += Add-Replacement $Relative "regex" "FD row incorrectly maps to CPD" $replacement $matches.Count
    }
    if ($out -notlike '*CPD.Datamart.v1.1*') {
        $line = '| [[CPD.Datamart.v1.1]] | [[CPD.Datamart.v1.1.memory]] | [[CPD.Datamart.v1.1]] | Data / Portal | TBD | TBD | CPD / 3D Design datamart for image search and 3D sample library | Build searchable visual sample library and image search for 3D Design | Strong | 2026-06-28 |'
        $out = $out.TrimEnd() + "`r`n" + $line + "`r`n"
        $changes += Add-Replacement $Relative "insert" "missing CPD memory index row" $line 1
    }
    return [pscustomobject]@{ Text=$out; Changes=@($changes) }
}

function Get-PatchedText {
    param([string]$Relative,[string]$Text)
    switch -Wildcard ($Relative) {
        "scripts\Repair-PPJProjectKnowledgePopulation.ps1" { return Apply-RepairScriptPatch $Text $Relative }
        "scripts\Populate-PPJCanonicalProjectNotes.ps1" { return Apply-PopulateScriptPatch $Text $Relative }
        "scripts\Normalize-PPJProjectKnowledgeMarkers.ps1" { return Apply-NormalizeScriptPatch $Text $Relative }
        "AGENTS.md" { return Apply-AgentsPatch $Text $Relative }
        "03_Projects\_Registry\PPJ_PROJECT_MEMORY_INDEX.md" { return Apply-MemoryIndexPatch $Text $Relative }
        "03_Projects\_Registry\PPJ_PROJECT_MODULE_INDEX.md" { return Apply-ModuleIndexPatch $Text $Relative }
        default { return [pscustomobject]@{ Text=$Text; Changes=@() } }
    }
}

$plans = @()
foreach ($relative in $targetRelativePaths) {
    $path = Join-Path $vaultRoot $relative
    if (-not (Test-Path $path)) {
        $plans += [pscustomobject]@{ File=$relative; Path=$path; Exists=$false; Hits=@(); Changes=@(); NewText=""; OldText=""; WouldPatch=$false }
        continue
    }
    $oldText = Read-Utf8 $path
    $hits = @()
    foreach ($pattern in $wrongMappingPatterns) {
        $count = Count-Literal $oldText $pattern
        if ($count -gt 0) { $hits += [pscustomobject]@{ Pattern=$pattern; Count=$count } }
    }
    $patch = Get-PatchedText $relative $oldText
    $wouldPatch = ($patch.Text -ne $oldText -or $Force) -and ($patch.Changes.Count -gt 0)
    $plans += [pscustomobject]@{ File=$relative; Path=$path; Exists=$true; Hits=$hits; Changes=$patch.Changes; NewText=$patch.Text; OldText=$oldText; WouldPatch=$wouldPatch }
}

$existing = @($plans | Where-Object Exists)
$missing = @($plans | Where-Object { -not $_.Exists })
$withHits = @($plans | Where-Object { $_.Hits.Count -gt 0 })
$toPatch = @($plans | Where-Object WouldPatch)

Write-Host "FD / CPD Drift Prevention Patch"
Write-Host "Mode: $(if($Apply){'Apply'}else{'DryRun'})"
Write-Host "Files scanned: $($existing.Count)"
Write-Host "Missing optional files: $($missing.Count)"
Write-Host "Files with wrong mapping hits: $($withHits.Count)"
Write-Host "Files that would be patched: $($toPatch.Count)"
Write-Host "Project notes updated: No"
Write-Host "Canvas updated: No"
Write-Host ""
Write-Host "Files scanned:"
foreach ($p in $plans) { Write-Host " - $($p.File): exists=$($p.Exists)" }
Write-Host ""
Write-Host "Wrong mappings found:"
if ($withHits.Count -eq 0) { Write-Host " - None" } else {
    foreach ($p in $withHits) {
        foreach ($h in $p.Hits) { Write-Host " - $($p.File): $($h.Pattern) ($($h.Count))" }
    }
}
Write-Host ""
Write-Host "Replacement plan:"
if ($toPatch.Count -eq 0) { Write-Host " - None" } else {
    foreach ($p in $toPatch) {
        Write-Host " - $($p.File)"
        foreach ($c in $p.Changes) {
            Write-Host "   [$($c.Kind)] count=$($c.Count)"
            Write-Host "     from: $($c.From)"
            Write-Host "     to:   $($c.To)"
        }
    }
}
Write-Host ""
Write-Host "FD replacement preview:"
Write-Host $fdDefinition
Write-Host ""
Write-Host "CPD replacement preview:"
Write-Host $cpdDefinition

if ($DryRun) { Write-Host "DryRun only. No files were modified."; exit 0 }

New-Item -ItemType Directory -Force -Path $auditRoot,$backupRoot | Out-Null
$script:LogLines = @("# FD / CPD Drift Prevention Patch Log - $stamp", "", "Mode: Apply", "")
foreach ($p in $toPatch) {
    Backup-File $p.Path
    Write-Utf8 $p.Path $p.NewText
    $script:LogLines += "- Patched: $($p.File)"
    foreach ($c in $p.Changes) { $script:LogLines += "  - $($c.Kind): $($c.Count) replacement(s)" }
}
$script:LogLines += ""
$script:LogLines += "## Safety Confirmation"
$script:LogLines += "- No project notes were modified."
$script:LogLines += "- No Canvas files were modified."
$script:LogLines += "- No files were renamed, moved, archived, or deleted."
$script:LogLines += "- Backups were written under $backupRoot."
Write-Utf8 $logPath ($script:LogLines -join "`r`n")
Write-Host "Apply completed. Log: $logPath"
