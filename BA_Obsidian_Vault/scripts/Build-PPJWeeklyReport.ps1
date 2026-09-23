param(
    [string]$ReportTitle = "PPJ Portfolio Weekly Report"
)

$ErrorActionPreference = "Stop"

$projectRoot = "03_Projects"
$reportRoot = "10_Deliverables\Reports"

New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

$date = Get-Date -Format "yyyy-MM-dd"
$stamp = Get-Date -Format "yyyyMMdd"

$reportPath = "$reportRoot\PPJ_Portfolio_Report_$stamp.md"

function Get-Field {
    param(
        [string]$Text,
        [string]$Field
    )

    $pattern = "(?m)^$Field`:\s*`"?([^`"`r`n]+)`"?"
    $m = [regex]::Match($Text, $pattern)

    if ($m.Success) {
        return $m.Groups[1].Value.Trim()
    }

    return "TBD"
}

$projects = @()

Get-ChildItem $projectRoot -Filter "*.md" | ForEach-Object {
    $raw = Get-Content -Raw -Encoding UTF8 $_.FullName

    if ($raw -match "type:\s*project") {
        $name = Get-Field $raw "project_name"
        if ($name -eq "TBD") {
            $name = $_.BaseName
        }

        $phase = Get-Field $raw "phase"
        $cluster = Get-Field $raw "cluster"
        $owner = Get-Field $raw "owner"

        $projects += [pscustomobject]@{
            Name = $name
            File = $_.BaseName
            Phase = $phase
            Cluster = $cluster
            Owner = $owner
        }
    }
}

$phases = @(
    "PENDING",
    "ANALYSIS",
    "DESIGN",
    "DEVELOPMENT",
    "STABILIZE / UAT",
    "PRODUCTION / SUPPORT",
    "BLOCKED / DEPENDENCY",
    "EXTERNAL",
    "CLOSED / CANCELLED",
    "TBD"
)

$lines = @()

$lines += "# $ReportTitle ($date)"
$lines += ""
$lines += "Executive Summary"
$lines += ""
$lines += "- Total projects: $($projects.Count)"
$lines += "- Main focus: stabilize active delivery, clarify blocked dependencies, and protect data foundation before AI scale."
$lines += ""
$lines += "Portfolio by Phase"
$lines += ""

foreach ($phase in $phases) {
    $items = @($projects | Where-Object { $_.Phase -eq $phase })

    if ($items.Count -eq 0) {
        continue
    }

    $lines += "---"
    $lines += ""
    $lines += "$phase"
    $lines += ""

    foreach ($p in $items) {
        $lines += "- [[$($p.File)]]"
    }

    $lines += ""
}

$lines += "---"
$lines += ""
$lines += "Key Risks"
$lines += ""
$lines += "- Data quality risk affects AI readiness."
$lines += "- WFX dependency can block automation handover."
$lines += "- Production systems need monitoring and support ownership."
$lines += ""
$lines += "Decision Needed"
$lines += ""
$lines += "- Which blocked items require management escalation?"
$lines += "- Which analysis projects are ready to move into design?"
$lines += "- Which production systems need SOP or user manual updates?"
$lines += ""
$lines += "Related Concepts"
$lines += "[[Portfolio Management]]"
$lines += "[[Outcome Driven Thinking]]"
$lines += "[[System Thinking]]"
$lines += "[[Decision Making]]"
$lines += ""
$lines += "Methods"
$lines += "[[Impact Analysis]]"
$lines += "[[Decision Matrix]]"
$lines += "[[Project Prioritization]]"
$lines += ""
$lines += "Deliverables"
$lines += "[[Decision_Driven_BRD]]"
$lines += "[[ERD_Template]]"
$lines += "[[User_Manual_Template]]"

$lines -join "`r`n" | Set-Content -Encoding UTF8 $reportPath

Write-Host "Weekly report created:"
Write-Host " - $reportPath"
