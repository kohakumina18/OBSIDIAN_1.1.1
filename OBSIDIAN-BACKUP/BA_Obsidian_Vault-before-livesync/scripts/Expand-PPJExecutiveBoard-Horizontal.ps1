$ErrorActionPreference = "Stop"

$canvasPath = "03_Projects\Canvas\PPJ_Executive_Board.canvas"
$backupRoot = "99_Attachments\Canvas_Backup"

New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null

if (-not (Test-Path $canvasPath)) {
    throw "Canvas not found: $canvasPath"
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
Copy-Item $canvasPath "$backupRoot\PPJ_Executive_Board.canvas.$stamp.expand-horizontal.bak"

function Normalize-Label {
    param([string]$Label)

    if (-not $Label) { return "" }

    $l = $Label.ToUpper()

    if ($l -match "PENDING") { return "PENDING" }
    if ($l -match "ANALYSIS") { return "ANALYSIS" }
    if ($l -match "DESIGN") { return "DESIGN" }
    if ($l -match "DEVELOPMENT") { return "DEVELOPMENT" }
    if ($l -match "STABILIZE|UAT") { return "STABILIZE / UAT" }
    if ($l -match "PRODUCTION|SUPPORT") { return "PRODUCTION / SUPPORT" }
    if ($l -match "BLOCKED|DEPEND") { return "BLOCKED / DEPENDENCY" }
    if ($l -match "EXTERNAL|THIRD") { return "EXTERNAL / THIRD PARTIES" }
    if ($l -match "CLOSED|CANCEL") { return "CLOSED / CANCELLED" }
    if ($l -match "TASKS|DOCS") { return "TASKS / DOCS TO UPDATE" }

    return $Label
}

function Is-In-Group {
    param($Node, $Group)

    if ($Node.id -eq $Group.id) { return $false }

    $nx = [double]$Node.x
    $ny = [double]$Node.y

    $gx = [double]$Group.x
    $gy = [double]$Group.y
    $gw = [double]$Group.width
    $gh = [double]$Group.height

    return (
        $nx -ge $gx -and
        $nx -lt ($gx + $gw) -and
        $ny -ge $gy -and
        $ny -lt ($gy + $gh)
    )
}

function Layout-Cards-In-Group {
    param(
        [object[]]$Cards,
        $Group,
        [int]$Columns = 2,
        [int]$CardWidth = 280,
        [int]$CardHeight = 85,
        [int]$GapX = 32,
        [int]$GapY = 32,
        [int]$TopPadding = 95,
        [int]$LeftPadding = 35
    )

    $sorted = @($Cards | Sort-Object @{Expression={[double]$_.y}}, @{Expression={[double]$_.x}})

    for ($i = 0; $i -lt $sorted.Count; $i++) {
        $col = $i % $Columns
        $row = [math]::Floor($i / $Columns)

        $sorted[$i].x = [double]$Group.x + $LeftPadding + ($col * ($CardWidth + $GapX))
        $sorted[$i].y = [double]$Group.y + $TopPadding + ($row * ($CardHeight + $GapY))
        $sorted[$i].width = $CardWidth
        $sorted[$i].height = $CardHeight
    }

    $rows = [math]::Ceiling([double]$sorted.Count / [double]$Columns)
    $neededHeight = $TopPadding + ($rows * ($CardHeight + $GapY)) + 80

    if ($neededHeight -gt [double]$Group.height) {
        $Group.height = $neededHeight
    }
}

$canvas = Get-Content -Raw -Encoding UTF8 $canvasPath | ConvertFrom-Json

$nodes = @($canvas.nodes)
$edges = @($canvas.edges)

# Normalize all group labels first
foreach ($node in $nodes) {
    if ($node.type -eq "group") {
        $node.label = Normalize-Label $node.label
    }
}

# Capture old group positions before moving
$oldGroups = @{}

foreach ($g in ($nodes | Where-Object { $_.type -eq "group" })) {
    $label = Normalize-Label $g.label
    $oldGroups[$label] = [pscustomobject]@{
        id     = $g.id
        label  = $label
        x      = [double]$g.x
        y      = [double]$g.y
        width  = [double]$g.width
        height = [double]$g.height
    }
}

# End-to-end horizontal layout
# Main lifecycle lanes are on the same Y plane.
$laneLayout = @(
    [pscustomobject]@{ Label="PENDING"; X=0;    Y=0; W=620;  H=1150; Columns=2; Color="1" }
    [pscustomobject]@{ Label="ANALYSIS"; X=760;  Y=0; W=700;  H=1150; Columns=2; Color="3" }
    [pscustomobject]@{ Label="DESIGN"; X=1580; Y=0; W=620;  H=1150; Columns=2; Color="3" }
    [pscustomobject]@{ Label="DEVELOPMENT"; X=2320; Y=0; W=620; H=1150; Columns=2; Color="4" }
    [pscustomobject]@{ Label="STABILIZE / UAT"; X=3060; Y=0; W=620; H=1150; Columns=2; Color="5" }
    [pscustomobject]@{ Label="PRODUCTION / SUPPORT"; X=3800; Y=0; W=860; H=1150; Columns=3; Color="2" }
    [pscustomobject]@{ Label="EXTERNAL / THIRD PARTIES"; X=4800; Y=0; W=700; H=1150; Columns=2; Color="6" }
    [pscustomobject]@{ Label="BLOCKED / DEPENDENCY"; X=5620; Y=0; W=700; H=1150; Columns=2; Color="1" }
    [pscustomobject]@{ Label="TASKS / DOCS TO UPDATE"; X=6440; Y=0; W=860; H=1150; Columns=2; Color="6" }
    [pscustomobject]@{ Label="CLOSED / CANCELLED"; X=7440; Y=0; W=700; H=1150; Columns=2; Color="1" }
)

# Create missing groups if needed
function New-CanvasId {
    return ([guid]::NewGuid().ToString("N").Substring(0,12))
}

foreach ($lane in $laneLayout) {
    $group = $nodes | Where-Object {
        $_.type -eq "group" -and
        (Normalize-Label $_.label) -eq $lane.Label
    } | Select-Object -First 1

    if (-not $group) {
        $group = [pscustomobject][ordered]@{
            id     = New-CanvasId
            type   = "group"
            label  = $lane.Label
            x      = $lane.X
            y      = $lane.Y
            width  = $lane.W
            height = $lane.H
            color  = $lane.Color
        }

        $nodes += $group

        $oldGroups[$lane.Label] = [pscustomobject]@{
            id     = $group.id
            label  = $lane.Label
            x      = [double]$lane.X
            y      = [double]$lane.Y
            width  = [double]$lane.W
            height = [double]$lane.H
        }
    }
}

# Reposition groups and their internal cards
foreach ($lane in $laneLayout) {
    $group = $nodes | Where-Object {
        $_.type -eq "group" -and
        (Normalize-Label $_.label) -eq $lane.Label
    } | Select-Object -First 1

    if (-not $group) { continue }

    $oldGroup = $oldGroups[$lane.Label]

    $cards = @()

    if ($oldGroup) {
        $cards = @($nodes | Where-Object {
            $_.type -ne "group" -and
            (Is-In-Group $_ $oldGroup)
        })
    }

    $group.label = $lane.Label
    $group.x = $lane.X
    $group.y = $lane.Y
    $group.width = $lane.W
    $group.height = $lane.H
    $group.color = $lane.Color

    Layout-Cards-In-Group `
        -Cards $cards `
        -Group $group `
        -Columns $lane.Columns `
        -CardWidth 250 `
        -CardHeight 85 `
        -GapX 28 `
        -GapY 28 `
        -TopPadding 95 `
        -LeftPadding 35
}

# Reposition header / text nodes outside groups
$textNodes = @($nodes | Where-Object { $_.type -eq "text" })

if ($textNodes.Count -gt 0) {
    $header = $textNodes | Sort-Object @{Expression={[double]$_.y}} | Select-Object -First 1
    $header.x = 0
    $header.y = -260
    $header.width = 1600
    $header.height = 160
    $header.text = "PPJ EXECUTIVE BOARD - END TO END LIFECYCLE VIEW`nFlow: Pending -> Analysis -> Design -> Development -> Stabilize/UAT -> Production/Support -> External/Blocked/Tasks -> Closed"
    $header.color = "6"
}

$out = [ordered]@{
    nodes = @($nodes)
    edges = @($edges)
}

$out | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 $canvasPath

Write-Host ""
Write-Host "Done. Expanded Executive Canvas into end-to-end horizontal lifecycle view."
Write-Host "Canvas:"
Write-Host " - $canvasPath"
Write-Host ""
Write-Host "Backup:"
Write-Host " - $backupRoot"
