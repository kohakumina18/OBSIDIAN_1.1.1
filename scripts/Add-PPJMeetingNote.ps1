param(
    [Parameter(Mandatory=$true)]
    [string]$Project,

    [Parameter(Mandatory=$true)]
    [string]$Title,

    [string]$Stakeholders = "TBD",

    [string]$Decision = "TBD",

    [string]$NextAction = "TBD"
)

$ErrorActionPreference = "Stop"

function Safe-FileName {
    param([string]$Name)
    $safe = $Name -replace '[<>:"/\\|?*]', '-'
    return $safe.Trim()
}

$meetingRoot = "08_Meeting_Notes"
$projectRoot = "03_Projects"

New-Item -ItemType Directory -Force -Path $meetingRoot | Out-Null

$date = Get-Date -Format "yyyy-MM-dd"
$time = Get-Date -Format "HH:mm"
$stamp = Get-Date -Format "yyyyMMdd_HHmm"

$fileTitle = Safe-FileName $Title
$projectFile = Safe-FileName $Project

$meetingFile = "${stamp}_MEETING_${projectFile}_${fileTitle}.md"
$meetingPath = "$meetingRoot\$meetingFile"
$meetingLink = $meetingFile -replace '\.md$',''

@"
---
type: meeting
date: "$date"
time: "$time"
project: "$Project"
---

# MEETING - $Title

Project:
[[$Project]]

Stakeholders:
$Stakeholders

Context:
- TBD

Current Process:
- TBD

Pain Points:
- TBD

Requirements:
- TBD

Data / Source of Truth:
- TBD

Systems:
- TBD

Decisions:
- $Decision

Risks / Gaps:
- TBD

Action Items:
- $NextAction

Open Questions:
- TBD

Next Steps:
- TBD

Related Concepts
[[Stakeholder Management]]
[[Communication Strategy]]
[[Outcome Driven Thinking]]
[[Decision Making]]

Methods
[[Requirement Elicitation]]
[[Impact Analysis]]
[[Five Whys]]

Projects
[[$Project]]

Deliverables
[[Decision_Driven_BRD]]
[[User_Manual_Template]]
[[ERD_Template]]
"@ | Set-Content -Encoding UTF8 $meetingPath

$projectPath = "$projectRoot\$projectFile.md"

if (Test-Path $projectPath) {
@"

---

Meeting Update - $date $time

Meeting:
[[$meetingLink]]

Decision:
- $Decision

Next Action:
- $NextAction
"@ | Add-Content -Encoding UTF8 $projectPath
}

Write-Host "Meeting note created:"
Write-Host " - $meetingPath"
