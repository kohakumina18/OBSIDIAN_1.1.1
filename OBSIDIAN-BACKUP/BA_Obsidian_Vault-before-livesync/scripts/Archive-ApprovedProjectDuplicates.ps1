param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [switch]$DeleteAfterArchive
)

$ErrorActionPreference = "Stop"

if (-not $Apply) {
    $DryRun = $true
}

$vaultRoot = (Get-Location).Path
$projectRoot = Join-Path $vaultRoot "03_Projects"
$auditRoot = Join-Path $vaultRoot "99_Attachments\Audit"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$dateStamp = Get-Date -Format "yyyyMMdd"
$backupRoot = Join-Path $auditRoot "Approved_Duplicate_Backup\$stamp"
$archiveRoot = Join-Path $projectRoot "_Archive\Delete_Approved\$stamp"
$logPath = Join-Path $auditRoot "APPROVED_PROJECT_DUPLICATE_ARCHIVE_LOG_$stamp.md"
$reportPath = Join-Path $vaultRoot "10_Reports\APPROVED_PROJECT_DUPLICATE_ARCHIVE_REPORT_$dateStamp.md"

$activeMarkdownRoots = @(
    "01_Daily_Notes",
    "02_BA_Knowledge",
    "03_Projects",
    "04_Data_Dictionary",
    "05_Process_Library",
    "06_AI_Automation",
    "07_Decision_Log",
    "08_Meeting_Notes",
    "09_Stakeholders",
    "10_Deliverables",
    "11_Templates"
)

$activeCanvasFiles = @(
    "03_Projects\Canvas\PPJ_Executive_Board.canvas",
    "03_Projects\Canvas\PPJ_Portfolio.canvas",
    "03_Projects\Canvas\PPJ_Data_Flow.canvas",
    "03_Projects\Canvas\PPJ_Roadmap_2026.canvas"
)

$approvedCandidates = @(
    [pscustomobject]@{ FileName = "EX-IM Expense Invoice Bot.md"; Canonical = "PPJ. Expense-Invoices.v1.1.md"; PreservationPattern = "(?is)(EXIM-first expense invoice|EX-IM Expense Invoice Bot|expense invoice automation)" },
    [pscustomobject]@{ FileName = "Import Export Automation.md"; Canonical = "PPJ. Expense-Invoices.v1.1.md"; PreservationPattern = "(?is)(Import Export Automation|EXIM-first expense invoice|expense invoice automation)" },
    [pscustomobject]@{ FileName = "Sourcing Chatbot v2.3.md"; Canonical = "SCP.SOURCING.CHATBOT.v2.3.md"; PreservationPattern = "(?is)(Sourcing Chatbot|supplier/material query|Consolidated sourcing scope)" },
    [pscustomobject]@{ FileName = "Sourcing VER2.md"; Canonical = "SCP.SOURCING.CHATBOT.v2.3.md"; PreservationPattern = "(?is)(Sourcing Chatbot|External Sample Data Repository|Consolidated sourcing scope|Sourcing data)" }
)

$needsConfirmationCandidates = @(
    "Web Tong Hop Tool.md",
    "Web Tổng Hợp Tool.md",
    "FD Hanger VER2.md",
    "PO Commit.md",
    "Purchasing Inventory Report.md"
)

function Read-Utf8 {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return "" }
    return Get-Content -Raw -Encoding UTF8 $Path
}

function Write-Utf8 {
    param([string]$Path, [string]$Text)
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $Text | Set-Content -Encoding UTF8 $Path
}

function Get-BaseName {
    param([string]$FileName)
    return [System.IO.Path]::GetFileNameWithoutExtension($FileName)
}

function Get-RelativePath {
    param([string]$Path)
    return (Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\')
}

function Test-InActiveMarkdownRoot {
    param([string]$RelativePath)
    foreach ($root in $activeMarkdownRoots) {
        if ($RelativePath -eq $root -or $RelativePath.StartsWith($root + "\")) { return $true }
    }
    return $false
}

function Test-NonBlockingMarkdownPath {
    param(
        [string]$RelativePath,
        [string]$OwnRelativePath
    )

    if ($RelativePath -eq $OwnRelativePath) { return $true }
    if ($RelativePath -match '(?i)(^|\\)03_Projects\\_Registry(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)03_Projects\\_Aliases(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)03_Projects\\_Archive(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)10_Reports(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)99_Attachments(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(^|\\)(backup|backups|audit|logs?|Project_Cleanup_Backup|Project_Folder_Hygiene_Backup|Alias_Reference_Backup|Approved_Duplicate_Backup)(\\|$)') { return $true }
    if ($RelativePath -match '(?i)(log|audit|backup|report).*\.md$') { return $true }
    if (-not (Test-InActiveMarkdownRoot $RelativePath)) { return $true }
    return $false
}

function Find-CandidateLocations {
    param([string]$FileName)
    $locations = @()
    $pathsToCheck = @(
        (Join-Path $projectRoot $FileName),
        (Join-Path $projectRoot ("_Aliases\" + $FileName))
    )
    foreach ($path in $pathsToCheck) {
        if (Test-Path $path) {
            $file = Get-Item $path
            $locations += [pscustomobject]@{
                FullName = $file.FullName
                Relative = Get-RelativePath $file.FullName
                Length = $file.Length
            }
        }
    }
    return $locations
}

function Test-AliasOrPreserved {
    param(
        [string]$CandidatePath,
        [string]$CanonicalPath,
        [string]$CandidateFileName,
        [string]$PreservationPattern
    )

    $candidateText = Read-Utf8 $CandidatePath
    $canonicalText = Read-Utf8 $CanonicalPath
    $candidateBase = Get-BaseName $CandidateFileName

    $isAlias = ($candidateText -match '(?im)^type\s*:\s*alias\s*$' -or $candidateText -match '(?im)^status\s*:\s*"?alias"?\s*$')
    $preservedByName = ($canonicalText -like "*$candidateBase*" -or $canonicalText -like "*$CandidateFileName*")
    $preservedBySection = ($canonicalText -match '(?im)^## Source Notes Preserved\s*$')
    $preservedByBusinessScope = ($PreservationPattern -and $canonicalText -match $PreservationPattern)

    return [pscustomobject]@{
        IsAlias = $isAlias
        IsPreserved = ($isAlias -or $preservedByName -or $preservedBySection -or $preservedByBusinessScope)
        Reason = if ($isAlias) { "Alias note" } elseif ($preservedByName) { "Candidate name appears in canonical note" } elseif ($preservedBySection) { "Canonical note has preserved source section" } elseif ($preservedByBusinessScope) { "Canonical note contains approved business scope" } else { "Not alias and preservation not detected" }
    }
}

function Find-MarkdownReferences {
    param(
        [string]$CandidateFileName,
        [string]$OwnPath
    )

    $candidateBase = Get-BaseName $CandidateFileName
    $escaped = [regex]::Escape($candidateBase)
    $pattern = "\[\[$escaped(\||\]\])"
    $ownRelativePath = Get-RelativePath $OwnPath
    $refs = @()

    foreach ($root in $activeMarkdownRoots) {
        $fullRoot = Join-Path $vaultRoot $root
        if (-not (Test-Path $fullRoot)) { continue }
        $mdFiles = @(Get-ChildItem -Path $fullRoot -Filter "*.md" -File -Recurse)
        foreach ($file in $mdFiles) {
            $relative = Get-RelativePath $file.FullName
            if (Test-NonBlockingMarkdownPath $relative $ownRelativePath) { continue }
            $lines = Get-Content -Encoding UTF8 $file.FullName
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match $pattern) {
                    $refs += [pscustomobject]@{ File = $relative; Line = $i + 1; Text = $lines[$i].Trim() }
                }
            }
        }
    }
    return $refs
}

function Find-CanvasFileNodeReferences {
    param([string]$CandidateFileName)

    $refs = @()
    $expected = "03_Projects/$CandidateFileName"
    $expectedBackslash = "03_Projects\$CandidateFileName"

    foreach ($relativeCanvas in $activeCanvasFiles) {
        $canvasPath = Join-Path $vaultRoot $relativeCanvas
        if (-not (Test-Path $canvasPath)) { continue }
        $raw = Read-Utf8 $canvasPath
        $json = $null
        try { $json = $raw | ConvertFrom-Json } catch { $json = $null }
        if ($null -eq $json) { continue }
        foreach ($node in @($json.nodes)) {
            if ($null -ne $node.file -and ($node.file -eq $expected -or $node.file -eq $expectedBackslash -or $node.file -eq $CandidateFileName)) {
                $refs += [pscustomobject]@{ Canvas = $relativeCanvas; NodeId = $node.id; File = $node.file }
            }
        }
    }
    return $refs
}

function Backup-File {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return }
    $relative = Get-RelativePath $Path
    $target = Join-Path $backupRoot $relative
    $targetDir = Split-Path $target -Parent
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item -Path $Path -Destination $target -Force
    $script:LogLines += "- Backup: $relative"
}

function Get-VersionGovernanceText {
    return @"
## Version Governance

Version 1.1:
EXIM-first expense invoice entry automation. This is the practical first implementation of the PPJ expense invoice automation scope.

Current Canonical:
[[PPJ. Expense-Invoices.v1.1]]

Historical / Archived Names:

- EX-IM Expense Invoice Bot
- Import Export Automation

Future Version:
PPJ.Expense-Invoices.v2.0 may be created later as the PPJ-wide version covering all relevant departments and factories.

Decision Needed:
Confirm v2.0 rollout scope, departments, factory usage, owner, and reusable invoice workflow design.

Do not create PPJ.Expense-Invoices.v2.0.md yet.
"@
}

function Update-VersionGovernance {
    param([string]$Path)
    $text = Read-Utf8 $Path
    $section = Get-VersionGovernanceText
    if ($text -match '(?ms)^## Version Governance\s*.*?(?=^## |\z)') {
        $updated = [regex]::Replace($text, '(?ms)^## Version Governance\s*.*?(?=^## |\z)', ($section.TrimEnd() + "`r`n`r`n"), 1)
    }
    else {
        $updated = $text.TrimEnd() + "`r`n`r`n" + $section.TrimEnd() + "`r`n"
    }
    Write-Utf8 $Path $updated
}

$plans = @()
foreach ($candidate in $approvedCandidates) {
    $canonicalPath = Join-Path $projectRoot $candidate.Canonical
    $canonicalExists = Test-Path $canonicalPath
    $canonicalLength = if ($canonicalExists) { (Get-Item $canonicalPath).Length } else { 0 }
    $canonicalValid = ($canonicalExists -and $canonicalLength -gt 0)
    $locations = @(Find-CandidateLocations $candidate.FileName)

    foreach ($location in $locations) {
        $preservation = Test-AliasOrPreserved $location.FullName $canonicalPath $candidate.FileName $candidate.PreservationPattern
        $mdRefs = @(Find-MarkdownReferences $candidate.FileName $location.FullName)
        $canvasRefs = @(Find-CanvasFileNodeReferences $candidate.FileName)
        $safe = ($canonicalValid -and $preservation.IsPreserved -and $mdRefs.Count -eq 0 -and $canvasRefs.Count -eq 0)
        $reasons = @()
        if (-not $canonicalValid) { $reasons += "Canonical missing or empty" }
        if (-not $preservation.IsPreserved) { $reasons += $preservation.Reason }
        if ($mdRefs.Count -gt 0) { $reasons += "Active Markdown references: $($mdRefs.Count)" }
        if ($canvasRefs.Count -gt 0) { $reasons += "Canvas file-node references: $($canvasRefs.Count)" }
        if ($reasons.Count -eq 0) { $reasons += "Safe to archive" }

        $plans += [pscustomobject]@{
            FileName = $candidate.FileName
            Canonical = $candidate.Canonical
            FullName = $location.FullName
            Relative = $location.Relative
            Length = $location.Length
            CanonicalExists = $canonicalExists
            CanonicalLength = $canonicalLength
            CanonicalValid = $canonicalValid
            IsAlias = $preservation.IsAlias
            IsPreserved = $preservation.IsPreserved
            PreservationReason = $preservation.Reason
            MarkdownRefs = $mdRefs
            CanvasRefs = $canvasRefs
            SafeToArchive = $safe
            Reason = ($reasons -join "; ")
        }
    }

    if ($locations.Count -eq 0) {
        $plans += [pscustomobject]@{
            FileName = $candidate.FileName
            Canonical = $candidate.Canonical
            FullName = ""
            Relative = "Not found"
            Length = 0
            CanonicalExists = $canonicalExists
            CanonicalLength = $canonicalLength
            CanonicalValid = $canonicalValid
            IsAlias = $false
            IsPreserved = $false
            PreservationReason = "Candidate file not found"
            MarkdownRefs = @()
            CanvasRefs = @()
            SafeToArchive = $false
            Reason = "Candidate file not found"
        }
    }
}

$needsConfirmation = @()
foreach ($fileName in $needsConfirmationCandidates) {
    $locations = @(Find-CandidateLocations $fileName)
    $locationText = if ($locations.Count -eq 0) { "Not found" } else { ($locations.Relative -join "; ") }
    $needsConfirmation += [pscustomobject]@{ FileName = $fileName; Locations = $locationText }
}

$safePlans = @($plans | Where-Object { $_.SafeToArchive })
$blockedPlans = @($plans | Where-Object { -not $_.SafeToArchive -and $_.Relative -ne "Not found" })
$notFoundPlans = @($plans | Where-Object { $_.Relative -eq "Not found" })

Write-Host "PPJ Approved Project Duplicate Archive"
Write-Host "Mode: $(if ($Apply) { 'Apply' } else { 'DryRun' })"
Write-Host ""
Write-Host "Summary:"
Write-Host " - Approved candidate records found: $(@($plans | Where-Object { $_.Relative -ne 'Not found' }).Count)"
Write-Host " - Safe to archive: $($safePlans.Count)"
Write-Host " - Blocked: $($blockedPlans.Count)"
Write-Host " - Not found: $($notFoundPlans.Count)"
Write-Host " - Needs confirmation candidates: $($needsConfirmation.Count)"
Write-Host ""
Write-Host "Safe to archive:"
if ($safePlans.Count -eq 0) { Write-Host " - None" }
foreach ($plan in $safePlans) { Write-Host " - $($plan.Relative) -> 03_Projects\_Archive\Delete_Approved\$stamp\$($plan.FileName)" }
Write-Host ""
Write-Host "Blocked:"
if ($blockedPlans.Count -eq 0) { Write-Host " - None" }
foreach ($plan in $blockedPlans) { Write-Host " - $($plan.Relative): $($plan.Reason)" }
Write-Host ""
Write-Host "Not found:"
if ($notFoundPlans.Count -eq 0) { Write-Host " - None" }
foreach ($plan in $notFoundPlans) { Write-Host " - $($plan.FileName)" }
Write-Host ""
Write-Host "Needs confirmation candidates, not archived by this script:"
foreach ($item in $needsConfirmation) { Write-Host " - $($item.FileName): $($item.Locations)" }

if ($DryRun) {
    Write-Host ""
    Write-Host "DryRun only. No files were moved, deleted, or modified. No report/log was written."
    exit 0
}

New-Item -ItemType Directory -Force -Path $auditRoot, $backupRoot, $archiveRoot | Out-Null
$script:LogLines = @()
$script:LogLines += "# Approved Project Duplicate Archive Log - $stamp"
$script:LogLines += ""
$script:LogLines += "Mode: Apply"
$script:LogLines += "DeleteAfterArchive: $([bool]$DeleteAfterArchive)"
$script:LogLines += ""

$archived = @()
$skipped = @()
foreach ($plan in $plans) {
    if (-not $plan.SafeToArchive) {
        $skipped += $plan
        continue
    }

    $destination = Join-Path $archiveRoot $plan.FileName
    if ((Test-Path $destination) -and -not $Force) {
        $plan.Reason = "Skipped because archive destination exists"
        $skipped += $plan
        continue
    }

    Backup-File $plan.FullName
    Move-Item -Path $plan.FullName -Destination $destination -Force:$Force
    $archived += [pscustomobject]@{ Source = $plan.Relative; Archive = (Get-RelativePath $destination); FileName = $plan.FileName }
    $script:LogLines += "- Archived: $($plan.Relative) -> $(Get-RelativePath $destination)"
}

$expenseCanonicalPath = Join-Path $projectRoot "PPJ. Expense-Invoices.v1.1.md"
if (Test-Path $expenseCanonicalPath) {
    Backup-File $expenseCanonicalPath
    Update-VersionGovernance $expenseCanonicalPath
    $script:LogLines += "- Updated governance section: 03_Projects\PPJ. Expense-Invoices.v1.1.md"
}

$deleted = @()
if ($DeleteAfterArchive) {
    foreach ($item in $archived) {
        $archivePath = Join-Path $vaultRoot $item.Archive
        $backupPath = Join-Path $backupRoot $item.Source
        if ((Test-Path $archivePath) -and (Test-Path $backupPath)) {
            Remove-Item -Path $archivePath -Force
            $deleted += $item
            $script:LogLines += "- Deleted archived copy after backup confirmation: $($item.Archive)"
        }
        else {
            $script:LogLines += "- Delete skipped, backup or archive copy missing: $($item.Archive)"
        }
    }
}

$report = New-Object System.Collections.Generic.List[string]
$report.Add("# Approved Project Duplicate Archive Report - $dateStamp")
$report.Add("")
$report.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
$report.Add("")
$report.Add("## Executive Summary")
$report.Add("")
$report.Add("Approved duplicate project notes were evaluated for safe archival. Canonical project notes were preserved. No Canvas files or global Markdown links were modified.")
$report.Add("")
$report.Add("- Approved candidate records found: $(@($plans | Where-Object { $_.Relative -ne 'Not found' }).Count)")
$report.Add("- Files archived: $($archived.Count)")
$report.Add("- Files skipped: $($skipped.Count)")
$report.Add("- DeleteAfterArchive: $([bool]$DeleteAfterArchive)")
$report.Add("")
$report.Add("## Approved Archive Candidates")
$report.Add("")
$report.Add("| Candidate | Canonical | Current Location | Safe | Reason |")
$report.Add("|---|---|---|---|---|")
foreach ($plan in $plans) { $report.Add("| $($plan.FileName) | $($plan.Canonical) | $($plan.Relative) | $($plan.SafeToArchive) | $($plan.Reason) |") }
$report.Add("")
$report.Add("## Needs Confirmation Candidates")
$report.Add("")
$report.Add("| Candidate | Current Location | Action |")
$report.Add("|---|---|---|")
foreach ($item in $needsConfirmation) { $report.Add("| $($item.FileName) | $($item.Locations) | Needs confirmation, not archived |") }
$report.Add("")
$report.Add("## Canonical Target Verification")
$report.Add("")
$report.Add("| Candidate | Canonical | Exists | Size |")
$report.Add("|---|---|---|---:|")
foreach ($plan in $plans) { $report.Add("| $($plan.FileName) | $($plan.Canonical) | $($plan.CanonicalExists) | $($plan.CanonicalLength) |") }
$report.Add("")
$report.Add("## Reference Check")
$report.Add("")
$report.Add("| Candidate | Active Markdown References | Canvas File-Node References |")
$report.Add("|---|---:|---:|")
foreach ($plan in $plans) { $report.Add("| $($plan.Relative) | $($plan.MarkdownRefs.Count) | $($plan.CanvasRefs.Count) |") }
$report.Add("")
$report.Add("## Archive Plan")
$report.Add("")
foreach ($plan in $safePlans) { $report.Add("- $($plan.Relative) -> 03_Projects\_Archive\Delete_Approved\$stamp\$($plan.FileName)") }
if ($safePlans.Count -eq 0) { $report.Add("- None.") }
$report.Add("")
$report.Add("## Files Archived")
$report.Add("")
if ($archived.Count -eq 0) { $report.Add("- None.") } else { foreach ($item in $archived) { $report.Add("- $($item.Source) -> $($item.Archive)") } }
$report.Add("")
$report.Add("## Files Skipped")
$report.Add("")
if ($skipped.Count -eq 0) { $report.Add("- None.") } else { foreach ($item in $skipped) { $report.Add("- $($item.Relative): $($item.Reason)") } }
$report.Add("")
$report.Add("## Governance Updates")
$report.Add("")
$report.Add("- Updated Version Governance in 03_Projects\PPJ. Expense-Invoices.v1.1.md.")
$report.Add("- PPJ.Expense-Invoices.v2.0.md was not created.")
$report.Add("")
$report.Add("## Remaining Cleanup Items")
$report.Add("")
$report.Add("- Needs confirmation candidates remain untouched.")
$report.Add("- Physical deletion should only be considered after archive and backup verification.")
$report.Add("")
$report.Add("## Next Action")
$report.Add("")
$report.Add("Review archived files and backup folder before considering DeleteAfterArchive.")

Write-Utf8 $reportPath ($report -join "`r`n")
$script:LogLines += ""
$script:LogLines += "## Safety Confirmation"
$script:LogLines += ""
$script:LogLines += "- No canonical files deleted."
$script:LogLines += "- No Canvas files modified."
$script:LogLines += "- No global Markdown links modified."
$script:LogLines += "- Needs confirmation candidates were not archived."
Write-Utf8 $logPath ($script:LogLines -join "`r`n")

Write-Host ""
Write-Host "Apply completed."
Write-Host " - Archived files: $($archived.Count)"
Write-Host " - Skipped files: $($skipped.Count)"
Write-Host " - Report: $reportPath"
Write-Host " - Log: $logPath"
Write-Host " - Backup folder: $backupRoot"
