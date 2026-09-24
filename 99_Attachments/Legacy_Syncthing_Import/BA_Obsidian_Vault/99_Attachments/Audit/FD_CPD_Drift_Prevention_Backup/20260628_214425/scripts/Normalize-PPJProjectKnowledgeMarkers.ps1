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
$dateStamp = Get-Date -Format "yyyyMMdd"
$backupRoot = Join-Path $auditRoot "Project_Knowledge_Marker_Normalization_Backup\$stamp"
$logPath = Join-Path $auditRoot "PROJECT_KNOWLEDGE_MARKER_NORMALIZATION_LOG_$stamp.md"
$reportPath = Join-Path $vaultRoot "10_Reports\PROJECT_KNOWLEDGE_MARKER_NORMALIZATION_REPORT_$dateStamp.md"

$standardStart = "<!-- PPJ_PROJECT_KNOWLEDGE_START -->"
$standardEnd = "<!-- PPJ_PROJECT_KNOWLEDGE_END -->"

$markerPairs = @(
    @{ Type="standard PPJ project knowledge"; Start=$standardStart; End=$standardEnd; Output=$true },
    @{ Type="generic identical generated project knowledge content"; Start="<!-- generated project knowledge content -->"; End="<!-- generated project knowledge content -->"; Identical=$true },
    @{ Type="previous generated project knowledge content start/end"; Start="<!-- generated project knowledge content start -->"; End="<!-- generated project knowledge content end -->" },
    @{ Type="incorrect generated content"; Start="<!-- generated content start -->"; End="<!-- generated content end -->" },
    @{ Type="old PPJ project detail managed"; Start="<!-- PPJ_PROJECT_DETAIL_MANAGED_START -->"; End="<!-- PPJ_PROJECT_DETAIL_MANAGED_END -->" },
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

$textFixes = @(
    @{ From="userscan"; To="users can" },
    @{ From="wrongtool"; To="wrong tool" },
    @{ From="automationmodules"; To="automation modules" },
    @{ From="timeon"; To="time on" },
    @{ From="answersor"; To="answers or" },
    @{ From="businessconcept"; To="business concept" },
    @{ From="forcorrected"; To="for corrected" },
    @{ From="does notmerge"; To="does not merge" },
    @{ From="modulenote"; To="module note" },
    @{ From="officiallyexpanded"; To="officially expanded" },
    @{ From="andalias"; To="and alias" },
    @{ From="project notes.It"; To="project notes. It" },
    @{ From="workflow.This"; To="workflow. This" },
    @{ From="Chi Trang"; To="Chi Trang" }
)

function Read-Utf8 { param([string]$Path) if (Test-Path $Path) { Get-Content -Raw -Encoding UTF8 $Path } else { "" } }
function Write-Utf8 { param([string]$Path,[string]$Text) $dir = Split-Path $Path -Parent; if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }; $Text | Set-Content -Encoding UTF8 $Path }
function Count-Text { param([string]$Text,[string]$Needle) return ([regex]::Matches($Text, [regex]::Escape($Needle))).Count }
function Safe-Value { param($Value) if ($null -eq $Value -or [string]::IsNullOrWhiteSpace([string]$Value)) { "None" } else { [string]$Value } }

function Get-MarkerRegions {
    param([string]$Text)
    $regions = @()
    $ambiguous = @()
    foreach ($pair in $markerPairs) {
        if ($pair.ContainsKey("Identical") -and $pair.Identical) {
            $matches = @([regex]::Matches($Text, [regex]::Escape($pair.Start)))
            if ($matches.Count -eq 1) {
                $ambiguous += [pscustomobject]@{ Type=$pair.Type; Reason="Single identical marker only"; Count=$matches.Count }
            } elseif ($matches.Count -eq 2) {
                $start = $matches[0].Index
                $endExclusive = $matches[1].Index + $matches[1].Length
                $regions += [pscustomobject]@{ Type=$pair.Type; StartMarker=$pair.Start; EndMarker=$pair.End; Index=$start; Length=($endExclusive - $start); StartIndex=$start; EndIndex=$matches[1].Index; Unambiguous=$true }
            } elseif ($matches.Count -gt 2) {
                $ambiguous += [pscustomobject]@{ Type=$pair.Type; Reason="More than two identical markers"; Count=$matches.Count }
            }
        } else {
            $pattern = "(?s)$([regex]::Escape($pair.Start)).*?$([regex]::Escape($pair.End))"
            foreach ($m in [regex]::Matches($Text, $pattern)) {
                $regions += [pscustomobject]@{ Type=$pair.Type; StartMarker=$pair.Start; EndMarker=$pair.End; Index=$m.Index; Length=$m.Length; StartIndex=$m.Index; EndIndex=($m.Index + $m.Length - $pair.End.Length); Unambiguous=$true }
            }
            $startCount = Count-Text $Text $pair.Start
            $endCount = Count-Text $Text $pair.End
            if ($startCount -ne $endCount) {
                $ambiguous += [pscustomobject]@{ Type=$pair.Type; Reason="Start/end marker count mismatch"; Count="start=$startCount; end=$endCount" }
            }
        }
    }
    $regions = @($regions | Sort-Object Index)
    return [pscustomobject]@{ Regions=$regions; Ambiguous=$ambiguous }
}

function Get-TextFixPlan {
    param([string]$Text)
    $plan = @()
    foreach ($fix in $textFixes) {
        $count = Count-Text $Text $fix.From
        if ($count -gt 0) {
            $plan += [pscustomobject]@{ From=$fix.From; To=$fix.To; Count=$count }
        }
    }
    return @($plan)
}

function Apply-TextFixes {
    param([string]$Text)
    $out = $Text
    foreach ($fix in $textFixes) {
        if ($fix.From -eq "Chi Trang") {
            $out = $out.Replace($fix.From, $fix.To)
        } else {
            $out = $out.Replace($fix.From, $fix.To)
        }
    }
    return $out
}

function Normalize-Region {
    param([string]$RegionText,[string]$StartMarker,[string]$EndMarker)
    $body = $RegionText
    if ($StartMarker -eq $EndMarker) {
        $first = $body.IndexOf($StartMarker)
        $last = $body.LastIndexOf($EndMarker)
        if ($first -ge 0 -and $last -gt $first) {
            $body = $body.Remove($last, $EndMarker.Length)
            $body = $body.Remove($first, $StartMarker.Length)
        }
    } else {
        if ($body.StartsWith($StartMarker)) { $body = $body.Substring($StartMarker.Length) }
        $last = $body.LastIndexOf($EndMarker)
        if ($last -ge 0) { $body = $body.Remove($last, $EndMarker.Length) }
    }
    $body = Apply-TextFixes $body
    return $standardStart + $body + $standardEnd
}

function Test-NormalizedText {
    param([string]$Text)
    $startCount = Count-Text $Text $standardStart
    $endCount = Count-Text $Text $standardEnd
    $forbidden = @()
    foreach ($pair in $markerPairs) {
        if ($pair.Start -ne $standardStart) {
            $c = Count-Text $Text $pair.Start
            if ($c -gt 0) { $forbidden += "$($pair.Type) start=$c" }
        }
        if ($pair.End -ne $standardEnd -and $pair.End -ne $pair.Start) {
            $c = Count-Text $Text $pair.End
            if ($c -gt 0) { $forbidden += "$($pair.Type) end=$c" }
        }
    }
    $startIndex = $Text.IndexOf($standardStart)
    $endIndex = $Text.LastIndexOf($standardEnd)
    $pass = ($startCount -eq 1 -and $endCount -eq 1 -and $forbidden.Count -eq 0 -and $startIndex -ge 0 -and $endIndex -gt $startIndex)
    return [pscustomobject]@{ Pass=$pass; StartCount=$startCount; EndCount=$endCount; Forbidden=($forbidden -join "; "); StartBeforeEnd=($startIndex -ge 0 -and $endIndex -gt $startIndex) }
}

function Backup-File {
    param([string]$Path)
    $relative = (Resolve-Path $Path).Path.Substring($vaultRoot.Length).TrimStart('\')
    $target = Join-Path $backupRoot $relative
    New-Item -ItemType Directory -Force -Path (Split-Path $target -Parent) | Out-Null
    Copy-Item -Path $Path -Destination $target -Force
    $script:LogLines += "- Backup: $relative"
}

$explicitTarget = -not [string]::IsNullOrWhiteSpace($ProjectName)
$files = @(Get-ChildItem -Path $projectRoot -Filter "*.md" -File)
if ($explicitTarget) {
    $needle = $ProjectName
    if ($needle.EndsWith(".md")) {
        $files = @($files | Where-Object { $_.Name -eq $needle })
    } else {
        $files = @($files | Where-Object { $_.BaseName -eq $needle -or $_.Name -eq "$needle.md" -or $_.Name -like "*$needle*" })
    }
} else {
    $files = @($files | Where-Object { $_.Name -ne "PROJECT_COMMAND_CENTER.md" })
}

$plans = @()
foreach ($file in $files) {
    $text = Read-Utf8 $file.FullName
    $scan = Get-MarkerRegions $text
    $regions = @($scan.Regions)
    $ambiguous = @($scan.Ambiguous)
    $markerTypes = (($regions | Select-Object -ExpandProperty Type -Unique) -join "; ")
    $wrongMarker = $false
    foreach ($r in $regions) { if ($r.StartMarker -ne $standardStart -or $r.EndMarker -ne $standardEnd) { $wrongMarker = $true } }
    $multipleBlocks = ($regions.Count -gt 1)
    $singleAmbiguous = ($ambiguous.Count -gt 0)
    $normalizable = $false
    $reason = "No managed block found"
    $newText = $text
    $textPlan = @()

    if ($regions.Count -eq 1 -and -not $singleAmbiguous) {
        $region = $regions[0]
        $regionText = $text.Substring($region.Index, $region.Length)
        $textPlan = Get-TextFixPlan $regionText
        $normalizedRegion = Normalize-Region $regionText $region.StartMarker $region.EndMarker
        $newText = $text.Remove($region.Index, $region.Length).Insert($region.Index, $normalizedRegion)
        $validation = Test-NormalizedText $newText
        $normalizable = ($validation.Pass -and ($wrongMarker -or $textPlan.Count -gt 0 -or $Force))
        $reason = if ($normalizable) { "Safe to normalize one unambiguous managed block" } else { "Already normalized or validation did not require change" }
    } elseif ($regions.Count -eq 0 -and $singleAmbiguous -and $Force) {
        $textPlan = Get-TextFixPlan $text
        $newText = Apply-TextFixes $text
        $validation = Test-NormalizedText $newText
        $normalizable = $false
        $reason = "Ambiguous single marker found; Force does not infer missing boundary automatically"
    } elseif ($multipleBlocks) {
        $validation = Test-NormalizedText $text
        $reason = "Multiple managed blocks found; manual review required"
    } elseif ($singleAmbiguous) {
        $validation = Test-NormalizedText $text
        $reason = "Ambiguous marker count; manual inspection required"
    } else {
        $validation = Test-NormalizedText $text
    }

    $plans += [pscustomobject]@{
        File=$file.Name
        Path=$file.FullName
        Regions=$regions.Count
        MarkerTypes=(Safe-Value $markerTypes)
        AmbiguousCount=$ambiguous.Count
        AmbiguousReason=(Safe-Value (($ambiguous | ForEach-Object { "$($_.Type): $($_.Reason) [$($_.Count)]" }) -join "; "))
        WrongMarker=$wrongMarker
        MultipleBlocks=$multipleBlocks
        TextPlan=$textPlan
        WouldNormalize=$normalizable
        Reason=$reason
        BeforeStartCount=(Count-Text $text $standardStart)
        BeforeEndCount=(Count-Text $text $standardEnd)
        AfterStartCount=$validation.StartCount
        AfterEndCount=$validation.EndCount
        ValidationPass=$validation.Pass
        ValidationForbidden=(Safe-Value $validation.Forbidden)
        StartBeforeEnd=$validation.StartBeforeEnd
        NewText=$newText
    }
}

$wrongMarkerFiles = @($plans | Where-Object { $_.WrongMarker })
$ambiguousFiles = @($plans | Where-Object { $_.AmbiguousCount -gt 0 -or $_.MultipleBlocks })
$toNormalize = @($plans | Where-Object { $_.WouldNormalize })
$safeToApply = @($toNormalize | Where-Object { $_.ValidationPass })
$manualReview = @($plans | Where-Object { ($_.AmbiguousCount -gt 0 -or $_.MultipleBlocks -or -not $_.ValidationPass) -and -not $_.WouldNormalize })

function Write-Report {
    $lines = @()
    $lines += "# Project Knowledge Marker Normalization Report - $dateStamp"
    $lines += ""
    $lines += "## Executive Summary"
    $lines += ""
    $lines += "Scanned $($plans.Count) root project note(s). $($wrongMarkerFiles.Count) file(s) have wrong markers. $($ambiguousFiles.Count) file(s) require manual review. $($safeToApply.Count) file(s) are safe to apply. Canvas and project filenames are not modified."
    $lines += ""
    $lines += "Standard output markers: $standardStart and $standardEnd"
    $lines += ""
    $lines += "## Files Scanned"
    $lines += ""
    foreach ($p in $plans) { $lines += "- $($p.File): regions=$($p.Regions); wrong_marker=$($p.WrongMarker); ambiguous=$($p.AmbiguousCount); validation=$($p.ValidationPass)" }
    $lines += ""
    $lines += "## Wrong Marker Files"
    $lines += ""
    if ($wrongMarkerFiles.Count -eq 0) { $lines += "- None" } else { foreach ($p in $wrongMarkerFiles) { $lines += "- $($p.File): $($p.MarkerTypes)" } }
    $lines += ""
    $lines += "## Ambiguous Files"
    $lines += ""
    if ($ambiguousFiles.Count -eq 0) { $lines += "- None" } else { foreach ($p in $ambiguousFiles) { $lines += "- $($p.File): $($p.AmbiguousReason); multiple_blocks=$($p.MultipleBlocks)" } }
    $lines += ""
    $lines += "## Normalization Plan"
    $lines += ""
    foreach ($p in $plans) { $lines += "- $($p.File): $($p.Reason); would_normalize=$($p.WouldNormalize)" }
    $lines += ""
    $lines += "## Text Quality Fixes"
    $lines += ""
    foreach ($p in $plans) {
        if ($p.TextPlan.Count -eq 0) { $lines += "- $($p.File): None" }
        else { $lines += "- $($p.File): " + (($p.TextPlan | ForEach-Object { "$($_.From) -> $($_.To) [$($_.Count)]" }) -join "; ") }
    }
    $lines += ""
    $lines += "## Validation Result"
    $lines += ""
    foreach ($p in $plans) { $lines += "- $($p.File): start_before=$($p.BeforeStartCount); end_before=$($p.BeforeEndCount); start_after=$($p.AfterStartCount); end_after=$($p.AfterEndCount); pass=$($p.ValidationPass); forbidden=$($p.ValidationForbidden)" }
    $lines += ""
    $lines += "## Files Safe To Apply"
    $lines += ""
    if ($safeToApply.Count -eq 0) { $lines += "- None" } else { foreach ($p in $safeToApply) { $lines += "- $($p.File)" } }
    $lines += ""
    $lines += "## Files Requiring Manual Review"
    $lines += ""
    if ($manualReview.Count -eq 0) { $lines += "- None" } else { foreach ($p in $manualReview) { $lines += "- $($p.File): $($p.Reason)" } }
    $lines += ""
    $lines += "## Next Action"
    $lines += ""
    $lines += "Run targeted Apply only after approval."
    Write-Utf8 $reportPath ($lines -join "`r`n")
}

Write-Report

Write-Host "PPJ Project Knowledge Marker Normalization"
Write-Host "Mode: $(if($Apply){'Apply'}else{'DryRun'})"
Write-Host "Standard output markers: $standardStart / $standardEnd"
Write-Host "Files scanned: $($plans.Count)"
Write-Host "Wrong marker files: $($wrongMarkerFiles.Count)"
Write-Host "Ambiguous files: $($ambiguousFiles.Count)"
Write-Host "Files that would be normalized: $($toNormalize.Count)"
Write-Host ""
foreach ($p in $plans) {
    Write-Host "File: $($p.File)"
    Write-Host "  Marker types: $($p.MarkerTypes)"
    Write-Host "  Marker count before: start=$($p.BeforeStartCount); end=$($p.BeforeEndCount); managed_regions=$($p.Regions)"
    Write-Host "  Marker count after: start=$($p.AfterStartCount); end=$($p.AfterEndCount)"
    Write-Host "  Wrong marker: $($p.WrongMarker)"
    Write-Host "  Ambiguous: $($p.AmbiguousCount); $($p.AmbiguousReason)"
    Write-Host "  Multiple blocks: $($p.MultipleBlocks)"
    $fixText = if ($p.TextPlan.Count -eq 0) { "None" } else { (($p.TextPlan | ForEach-Object { "$($_.From) -> $($_.To) [$($_.Count)]" }) -join "; ") }
    Write-Host "  Text replacements: $fixText"
    Write-Host "  Validation: $(if($p.ValidationPass){'PASS'}else{'FAIL'})"
    Write-Host "  Would normalize: $($p.WouldNormalize)"
}
Write-Host ""
Write-Host "Report: $reportPath"

if ($DryRun) {
    Write-Host "DryRun only. No files were modified."
    exit 0
}

New-Item -ItemType Directory -Force -Path $auditRoot,$backupRoot | Out-Null
$script:LogLines = @("# Project Knowledge Marker Normalization Log - $stamp", "", "Mode: Apply", "")
foreach ($p in $safeToApply) {
    $current = Read-Utf8 $p.Path
    if ($current -ne $p.NewText -or $Force) {
        Backup-File $p.Path
        Write-Utf8 $p.Path $p.NewText
        $script:LogLines += "- Normalized: $($p.File)"
    }
}
$script:LogLines += ""
$script:LogLines += "## Safety Confirmation"
$script:LogLines += "- No files renamed, moved, archived, or deleted."
$script:LogLines += "- Canvas files were not modified."
$script:LogLines += "- Only marker normalization and safe text replacements were applied."
Write-Utf8 $logPath ($script:LogLines -join "`r`n")
Write-Host "Apply completed. Log: $logPath"
