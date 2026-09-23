param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Watch,
    [switch]$UpdateMemoryIndex,
    [int]$PollSeconds = 5,
    [string]$CanvasPath = "03_Projects/Canvas/PPJ_Executive_Board.canvas"
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if ($Apply -and $DryRun) {
    throw "Use only one mode: -DryRun or -Apply."
}

if (-not $Apply) {
    $DryRun = $true
}

$VaultRoot = (Get-Location).ProviderPath
$CanvasFullPath = Join-Path $VaultRoot $CanvasPath
$MemoryIndexRelPath = "03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md"
$MemoryIndexPath = Join-Path $VaultRoot $MemoryIndexRelPath

$AllowedLanes = @(
    "PENDING",
    "ANALYSIS",
    "DESIGN",
    "DEVELOPMENT",
    "STABILIZE / UAT",
    "PRODUCTION / SUPPORT",
    "EXTERNAL / THIRD PARTIES",
    "BLOCKED / DEPENDENCY",
    "TASKS / DOCS TO UPDATE",
    "CLOSED / CANCELLED"
)

function Get-Utf8Content {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

function Set-Utf8Content {
    param(
        [string]$Path,
        [string]$Content
    )
    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

function Normalize-CanvasPath {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return "" }
    return ($Path -replace "\\", "/").TrimStart("/")
}

function Test-IsProjectNotePath {
    param([string]$Path)

    $p = Normalize-CanvasPath $Path
    if ($p -notmatch "^03_Projects/[^/]+\.md$") { return $false }
    if ($p -like "*/PROJECT_COMMAND_CENTER.md") { return $false }
    return $true
}

function Get-NumberProperty {
    param(
        [object]$Object,
        [string]$Name,
        [double]$Default = 0
    )

    if ($Object.PSObject.Properties.Name -contains $Name -and $null -ne $Object.$Name) {
        return [double]$Object.$Name
    }

    return $Default
}

function ConvertTo-YamlQuoted {
    param([string]$Value)
    if ($null -eq $Value) { $Value = "" }
    $safe = $Value -replace '"', '\"'
    return '"' + $safe + '"'
}

function Set-YamlScalar {
    param(
        [string]$Yaml,
        [string]$Key,
        [string]$Value
    )

    $escapedKey = [regex]::Escape($Key)
    $newLine = "${Key}: $Value"

    if ($Yaml -match "(?m)^$escapedKey\s*:") {
        return [regex]::Replace($Yaml, "(?m)^$escapedKey\s*:.*$", $newLine)
    }

    if ([string]::IsNullOrWhiteSpace($Yaml)) { return $newLine }
    return $Yaml.TrimEnd() + "`r`n" + $newLine
}

function Backup-File {
    param(
        [string]$Path,
        [string]$BackupRoot
    )

    if (-not (Test-Path -LiteralPath $Path)) { return }
    if (-not (Test-Path -LiteralPath $BackupRoot)) {
        New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
    }

    $resolved = (Resolve-Path -LiteralPath $Path).ProviderPath
    $relative = $resolved.Substring($VaultRoot.Length).TrimStart("\")
    $safeName = ($relative -replace "[:/\\]", "_") + ".bak"
    Copy-Item -LiteralPath $Path -Destination (Join-Path $BackupRoot $safeName) -Force
}

function Split-MarkdownTableRow {
    param([string]$Line)

    $trimmed = $Line.Trim()
    if ($trimmed.StartsWith("|")) { $trimmed = $trimmed.Substring(1) }
    if ($trimmed.EndsWith("|")) { $trimmed = $trimmed.Substring(0, $trimmed.Length - 1) }
    return @($trimmed -split "\|", -1)
}

function Join-MarkdownTableRow {
    param([string[]]$Cells)

    $clean = @()
    foreach ($cell in $Cells) { $clean += $cell.Trim() }
    return "| " + ($clean -join " | ") + " |"
}

function Get-CanvasPhasePlan {
    if (-not (Test-Path -LiteralPath $CanvasFullPath)) {
        throw "Canvas not found: $CanvasFullPath"
    }

    $canvas = Get-Utf8Content -Path $CanvasFullPath | ConvertFrom-Json
    $nodes = @($canvas.nodes)

    $groups = @(
        $nodes | Where-Object {
            $_.type -eq "group" -and
            $_.label -and
            ($AllowedLanes -contains $_.label)
        }
    )

    if ($groups.Count -eq 0) {
        throw "No recognized phase lanes found in $CanvasPath."
    }

    $fileNodes = @(
        $nodes | Where-Object {
            $_.type -eq "file" -and
            $_.file -and
            (Test-IsProjectNotePath $_.file)
        }
    )

    $plan = @()

    foreach ($node in $fileNodes) {
        $file = Normalize-CanvasPath $node.file
        $centerX = (Get-NumberProperty -Object $node -Name "x") + ((Get-NumberProperty -Object $node -Name "width" -Default 300) / 2)
        $centerY = (Get-NumberProperty -Object $node -Name "y") + ((Get-NumberProperty -Object $node -Name "height" -Default 80) / 2)

        $inside = @(
            $groups | Where-Object {
                $gx = Get-NumberProperty -Object $_ -Name "x"
                $gy = Get-NumberProperty -Object $_ -Name "y"
                $gw = Get-NumberProperty -Object $_ -Name "width"
                $gh = Get-NumberProperty -Object $_ -Name "height"
                $centerX -ge $gx -and $centerX -le ($gx + $gw) -and $centerY -ge $gy -and $centerY -le ($gy + $gh)
            } | Sort-Object @{ Expression = { (Get-NumberProperty -Object $_ -Name "width") * (Get-NumberProperty -Object $_ -Name "height") } }
        )

        if ($inside.Count -eq 0) {
            $plan += [pscustomobject]@{
                File = $file
                Lane = ""
                Status = "SKIPPED"
                Reason = "Card is not inside a recognized lane"
            }
        }
        else {
            $plan += [pscustomobject]@{
                File = $file
                Lane = $inside[0].label
                Status = "READY"
                Reason = "Card center is inside lane"
            }
        }
    }

    return $plan
}

function Update-ProjectNotePhase {
    param(
        [object]$Item,
        [string]$BackupRoot
    )

    $projectPath = Join-Path $VaultRoot $Item.File
    if (-not (Test-Path -LiteralPath $projectPath)) {
        return [pscustomobject]@{ File = $Item.File; Result = "SKIPPED"; Reason = "Project note not found" }
    }

    $content = Get-Utf8Content -Path $projectPath
    $original = $content
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $phaseValue = ConvertTo-YamlQuoted $Item.Lane

    $match = [regex]::Match($content, "(?s)\A---\r?\n(.*?)\r?\n---\r?\n?")

    if ($match.Success) {
        $yaml = $match.Groups[1].Value
        $body = $content.Substring($match.Length)

        $yaml = Set-YamlScalar -Yaml $yaml -Key "phase" -Value $phaseValue
        $yaml = Set-YamlScalar -Yaml $yaml -Key "status" -Value $phaseValue
        $yaml = Set-YamlScalar -Yaml $yaml -Key "phase_canvas_group" -Value $phaseValue
        $yaml = Set-YamlScalar -Yaml $yaml -Key "phase_source" -Value (ConvertTo-YamlQuoted "PPJ_Executive_Board.canvas")
        $yaml = Set-YamlScalar -Yaml $yaml -Key "phase_last_synced_from_canvas" -Value (ConvertTo-YamlQuoted $stamp)

        $content = "---`r`n$yaml`r`n---`r`n$body"
    }
    else {
        $projectName = [System.IO.Path]::GetFileNameWithoutExtension($Item.File)
        $front = @"
---
type: "project"
project_name: "$(Split-Path $Item.File -LeafBase)"
phase: $phaseValue
status: $phaseValue
phase_canvas_group: $phaseValue
phase_source: "PPJ_Executive_Board.canvas"
phase_last_synced_from_canvas: "$stamp"
---

"@
        $content = $front + $content
    }

    if ($content -ne $original) {
        Backup-File -Path $projectPath -BackupRoot $BackupRoot
        Set-Utf8Content -Path $projectPath -Content $content
        return [pscustomobject]@{ File = $Item.File; Result = "UPDATED"; Reason = "YAML phase/status synced to $($Item.Lane)" }
    }

    return [pscustomobject]@{ File = $Item.File; Result = "UNCHANGED"; Reason = "Already matches lane $($Item.Lane)" }
}

function Update-MemoryIndexPhase {
    param(
        [object[]]$ReadyItems,
        [string]$BackupRoot
    )

    if (-not (Test-Path -LiteralPath $MemoryIndexPath)) {
        return @([pscustomobject]@{ File = $MemoryIndexRelPath; Result = "SKIPPED"; Reason = "Memory index not found" })
    }

    $lines = @(Get-Content -LiteralPath $MemoryIndexPath -Encoding UTF8)
    $changed = $false
    $results = @()
    $headerIndex = -1

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^\s*\|" -and $lines[$i] -like "*Project*" -and $lines[$i] -like "*Phase*") {
            $headerIndex = $i
            break
        }
    }

    if ($headerIndex -lt 0) {
        return @([pscustomobject]@{ File = $MemoryIndexRelPath; Result = "SKIPPED"; Reason = "No table header found" })
    }

    $headers = Split-MarkdownTableRow -Line $lines[$headerIndex]
    $phaseCol = -1
    for ($h = 0; $h -lt $headers.Count; $h++) {
        if ($headers[$h].Trim() -eq "Phase") { $phaseCol = $h; break }
    }

    if ($phaseCol -lt 0) {
        return @([pscustomobject]@{ File = $MemoryIndexRelPath; Result = "SKIPPED"; Reason = "Phase column not found" })
    }

    foreach ($item in $ReadyItems) {
        $leaf = Split-Path -Path $item.File -Leaf
        $base = [System.IO.Path]::GetFileNameWithoutExtension($leaf)
        $found = $false

        for ($r = $headerIndex + 2; $r -lt $lines.Count; $r++) {
            if ($lines[$r] -notmatch "^\s*\|") { break }
            if ($lines[$r] -notlike "*$leaf*" -and $lines[$r] -notlike "*$base*") { continue }

            $cells = Split-MarkdownTableRow -Line $lines[$r]
            if ($cells.Count -gt $phaseCol) {
                $old = $cells[$phaseCol].Trim()
                if ($old -ne $item.Lane) {
                    $cells[$phaseCol] = " $($item.Lane) "
                    $lines[$r] = Join-MarkdownTableRow -Cells $cells
                    $changed = $true
                    $results += [pscustomobject]@{ File = $MemoryIndexRelPath; Result = "UPDATED"; Reason = "$base phase changed from '$old' to '$($item.Lane)'" }
                }
                else {
                    $results += [pscustomobject]@{ File = $MemoryIndexRelPath; Result = "UNCHANGED"; Reason = "$base already has phase '$($item.Lane)'" }
                }
            }

            $found = $true
            break
        }

        if (-not $found) {
            $results += [pscustomobject]@{ File = $MemoryIndexRelPath; Result = "SKIPPED"; Reason = "$base not found in memory index" }
        }
    }

    if ($changed) {
        Backup-File -Path $MemoryIndexPath -BackupRoot $BackupRoot
        Set-Utf8Content -Path $MemoryIndexPath -Content ($lines -join "`r`n")
    }

    return $results
}

function Invoke-SyncOnce {
    $mode = if ($Apply) { "APPLY" } else { "DRYRUN" }
    $plan = @(Get-CanvasPhasePlan)
    $ready = @($plan | Where-Object { $_.Status -eq "READY" })
    $skipped = @($plan | Where-Object { $_.Status -ne "READY" })

    Write-Host ""
    Write-Host "PPJ Executive Canvas Phase Sync"
    Write-Host "Vault: $VaultRoot"
    Write-Host "Canvas: $CanvasPath"
    Write-Host "Mode: $mode"
    Write-Host ""
    Write-Host "Detected project cards: $($plan.Count)"
    Write-Host "Ready to sync: $($ready.Count)"
    Write-Host "Skipped: $($skipped.Count)"
    Write-Host ""

    foreach ($item in $plan) {
        if ($item.Status -eq "READY") {
            Write-Host ("[READY] {0} -> {1}" -f $item.File, $item.Lane)
        }
        else {
            Write-Host ("[SKIP]  {0} -> {1}" -f $item.File, $item.Reason)
        }
    }

    if ($DryRun) {
        Write-Host ""
        Write-Host "DryRun complete. No files changed."
        return
    }

    $backupStamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupRoot = Join-Path $VaultRoot "99_Attachments/Audit/Executive_Canvas_Phase_Sync_Backup/$backupStamp"
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null

    Backup-File -Path $CanvasFullPath -BackupRoot $backupRoot

    $results = @()
    foreach ($item in $ready) {
        $results += Update-ProjectNotePhase -Item $item -BackupRoot $backupRoot
    }

    if ($UpdateMemoryIndex) {
        $results += Update-MemoryIndexPhase -ReadyItems $ready -BackupRoot $backupRoot
    }

    Write-Host ""
    Write-Host "Apply results:"
    foreach ($result in $results) {
        Write-Host ("[{0}] {1} - {2}" -f $result.Result, $result.File, $result.Reason)
    }

    Write-Host ""
    Write-Host "Apply complete."
    Write-Host "Backup folder: $backupRoot"
}

if ($Watch) {
    Write-Host "Watching Executive Canvas. Press Ctrl+C to stop."
    if (-not (Test-Path -LiteralPath $CanvasFullPath)) { throw "Canvas not found: $CanvasFullPath" }
    $lastWrite = (Get-Item -LiteralPath $CanvasFullPath).LastWriteTimeUtc
    Invoke-SyncOnce

    while ($true) {
        Start-Sleep -Seconds $PollSeconds
        $currentWrite = (Get-Item -LiteralPath $CanvasFullPath).LastWriteTimeUtc
        if ($currentWrite -gt $lastWrite) {
            $lastWrite = $currentWrite
            Start-Sleep -Seconds 1
            Invoke-SyncOnce
        }
    }
}
else {
    Invoke-SyncOnce
}
