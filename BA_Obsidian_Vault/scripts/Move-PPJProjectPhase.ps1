param(
    [Parameter(Mandatory=$true)]
    [string]$Project,

    [Parameter(Mandatory=$true)]
    [ValidateSet("PENDING","ANALYSIS","DESIGN","DEVELOPMENT","STABILIZE / UAT","PRODUCTION / SUPPORT","BLOCKED / DEPENDENCY","EXTERNAL","CLOSED / CANCELLED")]
    [string]$Phase,

    [string]$Reason = "Phase updated",

    [string]$NextAction = "TBD"
)

$ErrorActionPreference = "Stop"

function Safe-FileName {
    param([string]$Name)
    $safe = $Name -replace '[<>:"/\\|?*]', '-'
    return $safe.Trim()
}

function New-Id {
    return ([guid]::NewGuid().ToString("N").Substring(0,12))
}

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
    if ($l -match "EXTERNAL|THIRD") { return "EXTERNAL" }
    if ($l -match "CLOSED|CANCEL") { return "CLOSED / CANCELLED" }

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

    return ($nx -ge $gx -and $nx -lt ($gx + $gw) -and $ny -ge $gy -and $ny -lt ($gy + $gh))
}

$projectRoot = "03_Projects"
$canvasPath = "03_Projects\Canvas\PPJ_Executive_Board.canvas"
$backupRoot = "99_Attachments\Canvas_Backup"

New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null

$file = Safe-FileName $Project
$projectPath = "$projectRoot\$file.md"

if (-not (Test-Path $projectPath)) {
    throw "Project note not found: $projectPath"
}

if (-not (Test-Path $canvasPath)) {
    throw "Canvas not found: $canvasPath"
}

$date = Get-Date -Format "yyyy-MM-dd HH:mm"

# Update project note
$content = Get-Content -Raw -Encoding UTF8 $projectPath

if ($content -match '(?m)^phase:\s*".*"$') {
    $content = $content -replace '(?m)^phase:\s*".*"$', "phase: `"$Phase`""
}
elseif ($content -match '(?m)^phase:\s*.*$') {
    $content = $content -replace '(?m)^phase:\s*.*$', "phase: `"$Phase`""
}

$content += @"

---

Phase Update - $date

New Phase:
[[$Phase]]

Reason:
- $Reason

Next Action:
- $NextAction
"@

$content | Set-Content -Encoding UTF8 $projectPath

# Backup canvas
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
Copy-Item $canvasPath "$backupRoot\PPJ_Executive_Board.canvas.$stamp.movephase.bak"

$canvas = Get-Content -Raw -Encoding UTF8 $canvasPath | ConvertFrom-Json
$nodes = @($canvas.nodes)
$edges = @($canvas.edges)

$targetGroup = $nodes | Where-Object {
    $_.type -eq "group" -and (Normalize-Label $_.label) -eq $Phase
} | Select-Object -First 1

if (-not $targetGroup) {
    throw "Target phase group not found in canvas: $Phase"
}

$relativeFile = "03_Projects/$file.md"

$projectNode = $nodes | Where-Object {
    $_.type -eq "file" -and $_.file -eq $relativeFile
} | Select-Object -First 1

if (-not $projectNode) {
    $projectNode = [pscustomobject][ordered]@{
        id     = New-Id
        type   = "file"
        file   = $relativeFile
        x      = 0
        y      = 0
        width  = 250
        height = 85
    }

    $nodes += $projectNode
}

$cards = @($nodes | Where-Object {
    $_.type -ne "group" -and $_.id -ne $projectNode.id -and (Is-In-Group $_ $targetGroup)
})

$index = $cards.Count
$columns = 2

if ($Phase -eq "PRODUCTION / SUPPORT") {
    $columns = 3
}

$cardWidth = 250
$cardHeight = 85
$gapX = 28
$gapY = 28

$col = $index % $columns
$row = [math]::Floor($index / $columns)

$projectNode.x = [double]$targetGroup.x + 35 + ($col * ($cardWidth + $gapX))
$projectNode.y = [double]$targetGroup.y + 95 + ($row * ($cardHeight + $gapY))
$projectNode.width = $cardWidth
$projectNode.height = $cardHeight

$neededHeight = 95 + (($row + 1) * ($cardHeight + $gapY)) + 80
if ($neededHeight -gt [double]$targetGroup.height) {
    $targetGroup.height = $neededHeight
}

$out = [ordered]@{
    nodes = @($nodes)
    edges = @($edges)
}

$out | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 $canvasPath

Write-Host "Project phase updated:"
Write-Host " - $Project"
Write-Host " - $Phase"
Write-Host "Canvas updated:"
Write-Host " - $canvasPath"
