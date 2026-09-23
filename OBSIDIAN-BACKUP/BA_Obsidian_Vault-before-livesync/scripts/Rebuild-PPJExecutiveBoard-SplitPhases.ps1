$ErrorActionPreference = "Stop"

$projectRoot = "03_Projects"
$canvasRoot  = "03_Projects/Canvas"
$backupRoot  = "99_Attachments/Canvas_Backup"
$canvasPath  = "$canvasRoot/PPJ_Executive_Board.canvas"

New-Item -ItemType Directory -Force -Path $projectRoot | Out-Null
New-Item -ItemType Directory -Force -Path $canvasRoot | Out-Null
New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null

if (Test-Path $canvasPath) {
    $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    Copy-Item $canvasPath "$backupRoot/PPJ_Executive_Board.canvas.$stamp.splitphase.bak"
}

function New-Id {
    return ([guid]::NewGuid().ToString("N").Substring(0,12))
}

function New-GroupNode {
    param($Label, $X, $Y, $W, $H, $Color)

    [ordered]@{
        id     = New-Id
        type   = "group"
        label  = $Label
        x      = $X
        y      = $Y
        width  = $W
        height = $H
        color  = $Color
    }
}

function New-TextNode {
    param($Text, $X, $Y, $W, $H, $Color)

    [ordered]@{
        id     = New-Id
        type   = "text"
        text   = $Text
        x      = $X
        y      = $Y
        width  = $W
        height = $H
        color  = $Color
    }
}

function New-FileNode {
    param($File, $X, $Y, $W=280, $H=80, $Color="")

    $node = [ordered]@{
        id     = New-Id
        type   = "file"
        file   = $File
        x      = $X
        y      = $Y
        width  = $W
        height = $H
    }

    if ($Color -ne "") {
        $node.color = $Color
    }

    return $node
}

function Safe-FileName {
    param([string]$Name)

    $safe = $Name -replace '[<>:"/\\|?*]', '-'
    $safe = $safe.Trim()

    if ($safe.Length -gt 120) {
        $safe = $safe.Substring(0,120).Trim()
    }

    return $safe
}

$projects = @(
    # ANALYSIS
    [pscustomobject]@{Name="ACC.CHICOS.INVOICE.RECHECK-AUDIT.v1.1"; File="ACC.CHICOS.INVOICE.RECHECK-AUDIT.v1.1"; Phase="ANALYSIS"; Cluster="Automation"; Note="Invoice recheck / audit pilot for CHICO'S. Foundation for reusable invoice checking across Accounting, Import and Export."}
    [pscustomobject]@{Name="RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1"; File="RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1"; Phase="ANALYSIS"; Cluster="Portal / R&D"; Note="Port Wash R&D sampling management process into PPJ Group Portal."}
    [pscustomobject]@{Name="Accounting Expense Invoices"; File="Accounting Expense Invoices"; Phase="ANALYSIS"; Cluster="Automation"; Note="Expense invoice processing and ledger mapping."}
    [pscustomobject]@{Name="MER Costing Intelligence"; File="MER Costing Intelligence"; Phase="ANALYSIS"; Cluster="AI"; Note="Costing search, BOM, price history, product similarity."}
    [pscustomobject]@{Name="E-commerce Market Intelligence"; File="E-commerce Market Intelligence"; Phase="ANALYSIS"; Cluster="AI"; Note="Consumer, market, product and fabric intelligence."}
    [pscustomobject]@{Name="Workshop Analysis"; File="Workshop Analysis"; Phase="ANALYSIS"; Cluster="Governance"; Note="Workshop feedback and AI use-case classification."}

    # DESIGN
    [pscustomobject]@{Name="CPD Fabric Database"; File="CPD Fabric Database"; Phase="DESIGN"; Cluster="Data"; Note="Fabric database for CPD and 3D team."}
    [pscustomobject]@{Name="HR Project"; File="HR Project"; Phase="DESIGN"; Cluster="Governance"; Note="Need more information from HR/project owner."}

    # DEVELOPMENT
    [pscustomobject]@{Name="SCP.SOURCING.CHATBOT.v2.3"; File="SCP.SOURCING.CHATBOT.v2.3"; Phase="DEVELOPMENT"; Cluster="AI / Data"; Note="Sourcing Chatbot and External Sample Data Repository. Consolidated sourcing scope."}
    [pscustomobject]@{Name="Chuyen treo ver1"; File="Chuyen treo ver1"; Phase="DEVELOPMENT"; Cluster="Factory / IoT"; Note="Realtime dashboard for efficiency, output and downtime."}

    # STABILIZE / UAT
    [pscustomobject]@{Name="FD QR Hanger"; File="FD QR Hanger"; Phase="STABILIZE / UAT"; Cluster="Factory / Data"; Note="QR Format Designer, training, feedback and stabilization."}

    # PRODUCTION / SUPPORT
    [pscustomobject]@{Name="PERRI Chatbot"; File="PERRI Chatbot"; Phase="PRODUCTION / SUPPORT"; Cluster="AI"; Note="Internal AI orchestrator and assistant."}
    [pscustomobject]@{Name="GLPI Helpdesk AI Chatbot"; File="GLPI Helpdesk AI Chatbot"; Phase="PRODUCTION / SUPPORT"; Cluster="AI"; Note="Helpdesk AI chatbot."}
    [pscustomobject]@{Name="Invoice Downloader"; File="Invoice Downloader"; Phase="PRODUCTION / SUPPORT"; Cluster="Automation"; Note="Supplier invoice download and user support."}
    [pscustomobject]@{Name="PO Commit"; File="PO Commit"; Phase="PRODUCTION / SUPPORT"; Cluster="Automation"; Note="PO commit automation."}
    [pscustomobject]@{Name="Accounting Automation"; File="Accounting Automation"; Phase="PRODUCTION / SUPPORT"; Cluster="Automation"; Note="Accounting automation umbrella."}
    [pscustomobject]@{Name="Accounting GRN Supplier Invoice Bot"; File="Accounting GRN Supplier Invoice Bot"; Phase="PRODUCTION / SUPPORT"; Cluster="Automation"; Note="GRN / Supplier Invoice bot."}
    [pscustomobject]@{Name="EXIM Expense Invoice Bot"; File="EXIM Expense Invoice Bot"; Phase="PRODUCTION / SUPPORT"; Cluster="Automation"; Note="EXIM expense invoice automation."}
    [pscustomobject]@{Name="Adhoc Indent mien Nam"; File="Adhoc Indent mien Nam"; Phase="PRODUCTION / SUPPORT"; Cluster="Automation"; Note="Adhoc indent support for South region."}
    [pscustomobject]@{Name="CPD Datamart"; File="CPD Datamart"; Phase="PRODUCTION / SUPPORT"; Cluster="Data"; Note="CPD datamart support."}
    [pscustomobject]@{Name="Purchasing Inventory Report"; File="Purchasing Inventory Report"; Phase="PRODUCTION / SUPPORT"; Cluster="Reporting"; Note="Purchasing inventory dashboard/report."}
    [pscustomobject]@{Name="Web Tong Hop Tool"; File="Web Tong Hop Tool"; Phase="PRODUCTION / SUPPORT"; Cluster="Reporting"; Note="Consolidated web reporting/support tool."}

    # BLOCKED / DEPENDENCY
    [pscustomobject]@{Name="Material Allocation"; File="Material Allocation"; Phase="BLOCKED / DEPENDENCY"; Cluster="Automation"; Note="Waiting WFX Save function."}
    [pscustomobject]@{Name="PUR.GDI Automation"; File="PUR.GDI Automation"; Phase="BLOCKED / DEPENDENCY"; Cluster="Automation"; Note="Waiting WFX modification."}

    # EXTERNAL
    [pscustomobject]@{Name="QSee.ai"; File="QSee.ai"; Phase="EXTERNAL"; Cluster="External"; Note="External collaboration, NDA approved."}
    [pscustomobject]@{Name="Primo1D RFID Thread"; File="Primo1D RFID Thread"; Phase="EXTERNAL"; Cluster="External"; Note="RFID thread exploration."}
    [pscustomobject]@{Name="NUNOX"; File="NUNOX"; Phase="EXTERNAL"; Cluster="External"; Note="Hardware scanner feasibility trial."}
    [pscustomobject]@{Name="VITAS Sharing"; File="VITAS Sharing"; Phase="EXTERNAL"; Cluster="External"; Note="External sharing / industry event."}

    # PENDING
    [pscustomobject]@{Name="COWASH"; File="COWASH"; Phase="PENDING"; Cluster="Factory / Wash"; Note="Need technical rescope with Wash/Cosin."}
    [pscustomobject]@{Name="H&M Label-O Processing"; File="H&M Label-O Processing"; Phase="PENDING"; Cluster="Automation"; Note="Customer-specific label process, delayed."}

    # CLOSED / CANCELLED
    [pscustomobject]@{Name="Stratova AI"; File="Stratova AI"; Phase="CLOSED / CANCELLED"; Cluster="External"; Note="Closed due to unclear PoC/resource."}
    [pscustomobject]@{Name="AI Automation Workshop"; File="AI Automation Workshop"; Phase="CLOSED / CANCELLED"; Cluster="Governance"; Note="Workshop completed."}
)

# Create / update project notes
$marker = "Lifecycle Update 2026-W26"

foreach ($p in $projects) {
    $path = "$projectRoot/$($p.File).md"

    if (-not (Test-Path $path)) {
@"
---
type: project
project_name: "$($p.Name)"
phase: "$($p.Phase)"
cluster: "$($p.Cluster)"
---

# $($p.Name)

Phase:
[[$($p.Phase)]]

Cluster:
[[$($p.Cluster)]]

Canvas:
- [[PPJ_Executive_Board]]
- [[PPJ_Portfolio]]
- [[PPJ_Data_Flow]]
- [[PPJ_Roadmap_2026]]

Current Summary:
- $($p.Note)

Latest Update:
- $marker

Risks / Blockers:
- TBD

Next Actions:
- TBD

Related Concepts
[[Outcome Driven Thinking]]
[[System Thinking]]
[[Decision Making]]
[[Stakeholder Management]]

Methods
[[Impact Analysis]]
[[Decision Matrix]]
[[Requirement Elicitation]]

Deliverables
[[Decision_Driven_BRD]]
[[ERD_Template]]
[[User_Manual_Template]]
"@ | Set-Content -Encoding UTF8 $path
    }
    else {
        $raw = Get-Content -Raw -Encoding UTF8 $path

        if ($raw -notlike "*$marker*") {
@"

---

Update - $marker

Phase:
[[$($p.Phase)]]

Cluster:
[[$($p.Cluster)]]

Current Summary:
- $($p.Note)

Canvas:
- [[PPJ_Executive_Board]]
"@ | Add-Content -Encoding UTF8 $path
        }
    }
}

# Layout
$nodes = @()
$edges = @()

$nodes += New-TextNode `
    -Text "PPJ EXECUTIVE BOARD - SPLIT PHASE VIEW`nLifecycle is separated by phase: Analysis, Design, Development, Stabilize/UAT, Production, Blocked, External, Pending, Closed." `
    -X 0 -Y -220 -W 1200 -H 140 -Color "6"

$lanes = @(
    [pscustomobject]@{Phase="ANALYSIS"; Label="ANALYSIS"; X=0; Y=0; W=620; H=760; Color="3"}
    [pscustomobject]@{Phase="DESIGN"; Label="DESIGN"; X=700; Y=0; W=620; H=520; Color="3"}
    [pscustomobject]@{Phase="DEVELOPMENT"; Label="DEVELOPMENT"; X=1400; Y=0; W=620; H=640; Color="4"}
    [pscustomobject]@{Phase="STABILIZE / UAT"; Label="STABILIZE / UAT"; X=2100; Y=0; W=620; H=520; Color="5"}
    [pscustomobject]@{Phase="PRODUCTION / SUPPORT"; Label="PRODUCTION / SUPPORT"; X=0; Y=880; W=1320; H=980; Color="2"}
    [pscustomobject]@{Phase="BLOCKED / DEPENDENCY"; Label="BLOCKED / DEPENDENCY"; X=1400; Y=760; W=620; H=520; Color="1"}
    [pscustomobject]@{Phase="EXTERNAL"; Label="EXTERNAL / THIRD PARTIES"; X=2100; Y=760; W=620; H=620; Color="6"}
    [pscustomobject]@{Phase="PENDING"; Label="PENDING"; X=1400; Y=1400; W=620; H=420; Color="1"}
    [pscustomobject]@{Phase="CLOSED / CANCELLED"; Label="CLOSED / CANCELLED"; X=2100; Y=1500; W=620; H=420; Color="1"}
    [pscustomobject]@{Phase="TASKS / DOCS TO UPDATE"; Label="TASKS / DOCS TO UPDATE"; X=2800; Y=0; W=700; H=760; Color="6"}
)

foreach ($lane in $lanes) {
    $nodes += New-GroupNode $lane.Label $lane.X $lane.Y $lane.W $lane.H $lane.Color

    $items = $projects | Where-Object { $_.Phase -eq $lane.Phase }

    $i = 0
    foreach ($p in $items) {
        $col = $i % 2
        $row = [math]::Floor($i / 2)

        $x = $lane.X + 30 + ($col * 300)
        $y = $lane.Y + 70 + ($row * 105)

        $nodes += New-FileNode "03_Projects/$($p.File).md" $x $y 280 80
        $i++
    }
}

# Add existing task notes into TASKS / DOCS TO UPDATE
$taskFolder = "$projectRoot/_Tasks"

if (Test-Path $taskFolder) {
    $taskLane = $lanes | Where-Object { $_.Phase -eq "TASKS / DOCS TO UPDATE" } | Select-Object -First 1
    $tasks = Get-ChildItem $taskFolder -Filter "*.md" | Sort-Object LastWriteTime -Descending | Select-Object -First 12

    $i = 0
    foreach ($t in $tasks) {
        $col = $i % 2
        $row = [math]::Floor($i / 2)

        $x = $taskLane.X + 30 + ($col * 320)
        $y = $taskLane.Y + 70 + ($row * 105)

        $relative = "03_Projects/_Tasks/$($t.Name)"
        $nodes += New-FileNode $relative $x $y 300 80 "6"

        $i++
    }
}

$out = [ordered]@{
    nodes = @($nodes)
    edges = @($edges)
}

$out | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 $canvasPath

Write-Host ""
Write-Host "Done. Rebuilt split-phase Executive Canvas:"
Write-Host " - 03_Projects/Canvas/PPJ_Executive_Board.canvas"
Write-Host ""
Write-Host "Backup saved under:"
Write-Host " - 99_Attachments/Canvas_Backup"
Write-Host ""
Write-Host "Phases:"
Write-Host " - ANALYSIS"
Write-Host " - DESIGN"
Write-Host " - DEVELOPMENT"
Write-Host " - STABILIZE / UAT"
Write-Host " - PRODUCTION / SUPPORT"
Write-Host " - BLOCKED / DEPENDENCY"
Write-Host " - EXTERNAL / THIRD PARTIES"
Write-Host " - PENDING"
Write-Host " - CLOSED / CANCELLED"
Write-Host " - TASKS / DOCS TO UPDATE"
