param(
    [Parameter(Mandatory=$true)]
    [string]$Project,

    [ValidateSet("PENDING","ANALYSIS","DESIGN","DEVELOPMENT","STABILIZE / UAT","PRODUCTION / SUPPORT","BLOCKED / DEPENDENCY","EXTERNAL","CLOSED / CANCELLED")]
    [string]$Phase = "ANALYSIS",

    [string]$Cluster = "TBD",

    [string]$Outcome = "TBD",

    [string]$Owner = "TBD",

    [string[]]$Related = @()
)

$ErrorActionPreference = "Stop"

function Safe-FileName {
    param([string]$Name)
    $safe = $Name -replace '[<>:"/\\|?*]', '-'
    return $safe.Trim()
}

$projectRoot = "03_Projects"
New-Item -ItemType Directory -Force -Path $projectRoot | Out-Null

$file = Safe-FileName $Project
$path = "$projectRoot\$file.md"
$date = Get-Date -Format "yyyy-MM-dd HH:mm"

$relatedLinks = "- TBD"
if ($Related.Count -gt 0) {
    $relatedLinks = ($Related | ForEach-Object { "- [[${_}]]" }) -join "`r`n"
}

if (Test-Path $path) {
    Write-Host "Project already exists: $path"
    exit
}

@"
---
type: project
project_name: "$Project"
phase: "$Phase"
cluster: "$Cluster"
owner: "$Owner"
created: "$date"
---

# $Project

Phase:
[[$Phase]]

Cluster:
[[$Cluster]]

Owner:
$Owner

Canvas:
- [[PPJ_Executive_Board]]
- [[PPJ_Portfolio]]
- [[PPJ_Data_Flow]]
- [[PPJ_Roadmap_2026]]

Business Outcome:
- $Outcome

Current Context:
- TBD

Problem / Pain Point:
- TBD

Scope:
- In scope:
  - TBD
- Out of scope:
  - TBD

Process:
- As-Is:
  - TBD
- To-Be:
  - TBD

Data:
- Business Source:
  - TBD
- Data Warehouse:
  - TBD
- Target System:
  - TBD

AI / Automation Scope:
- TBD

Human Check:
- TBD

Fallback:
- TBD

KPI:
- TBD

Risks:
- TBD

Next Actions:
- TBD

Related Documents:
$relatedLinks

Related Concepts
[[Outcome Driven Thinking]]
[[System Thinking]]
[[Decision Making]]
[[Stakeholder Management]]
[[Data Governance]]

Methods
[[Impact Analysis]]
[[Decision Matrix]]
[[Requirement Elicitation]]
[[Data Mapping]]

Deliverables
[[Decision_Driven_BRD]]
[[ERD_Template]]
[[User_Manual_Template]]
"@ | Set-Content -Encoding UTF8 $path

Write-Host "Created project:"
Write-Host " - $path"
