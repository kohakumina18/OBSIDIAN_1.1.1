param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Watch,
    [switch]$SkipPhaseSync,
    [switch]$SkipProjectNotes,
    [switch]$SkipMemoryCards,
    [switch]$SkipRegistry,
    [switch]$SkipResourceMatrix,
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
$RegistryRelPath = "03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md"
$RegistryPath = Join-Path $VaultRoot $RegistryRelPath
$ResourceMatrixRelPath = "03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md"
$ResourceMatrixPath = Join-Path $VaultRoot $ResourceMatrixRelPath

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

$CommandMarker = "PPJ_PROJECT_COMMAND"

function Get-Utf8Content {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

function Set-Utf8Content {
    param([string]$Path, [string]$Content)
    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

function Normalize-PathText {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return "" }
    return ($Path -replace "\\", "/").TrimStart("/")
}

function Clean-Wiki {
    param([string]$Value)
    if ($null -eq $Value) { return "" }
    $v = $Value.Trim()
    $v = $v -replace '^\[\[', '' -replace '\]\]$', ''
    if ($v -match '\|') { $v = ($v -split '\|')[0].Trim() }
    return $v.Trim()
}

function ConvertTo-YamlQuoted {
    param([string]$Value)
    if ($null -eq $Value) { $Value = "" }
    $safe = $Value -replace '"', '\"'
    return '"' + $safe + '"'
}

function Set-YamlScalar {
    param([string]$Yaml, [string]$Key, [string]$Value)
    $escapedKey = [regex]::Escape($Key)
    $line = "${Key}: $Value"
    if ($Yaml -match "(?m)^$escapedKey\s*:") {
        return [regex]::Replace($Yaml, "(?m)^$escapedKey\s*:.*$", $line)
    }
    if ([string]::IsNullOrWhiteSpace($Yaml)) { return $line }
    return $Yaml.TrimEnd() + "`r`n" + $line
}

function Get-NumberProperty {
    param([object]$Object, [string]$Name, [double]$Default = 0)
    if ($Object.PSObject.Properties.Name -contains $Name -and $null -ne $Object.$Name) {
        return [double]$Object.$Name
    }
    return $Default
}

function Backup-File {
    param([string]$Path, [string]$BackupRoot)
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

function Test-IsProjectNotePath {
    param([string]$Path)
    $p = Normalize-PathText $Path
    if ($p -notmatch "^03_Projects/[^/]+\.md$") { return $false }
    if ($p -like "*/PROJECT_COMMAND_CENTER.md") { return $false }
    return $true
}

function Get-MemoryIndexMap {
    $map = @{}
    if (-not (Test-Path -LiteralPath $MemoryIndexPath)) { return $map }
    $lines = Get-Content -LiteralPath $MemoryIndexPath -Encoding UTF8
    foreach ($line in $lines) {
        if ($line -notmatch '^\| \[\[') { continue }
        $cells = Split-MarkdownTableRow -Line $line
        if ($cells.Count -lt 6) { continue }
        $project = Clean-Wiki $cells[0]
        $memory = Clean-Wiki $cells[1]
        $note = Clean-Wiki $cells[2]
        if ([string]::IsNullOrWhiteSpace($note) -or $note -eq "TBD") { continue }
        $file = Normalize-PathText ("03_Projects/$note.md")
        $entry = [pscustomobject]@{ Project = $project; Memory = $memory; Note = $note; File = $file }
        $map[$project.ToLowerInvariant()] = $entry
        $map[$note.ToLowerInvariant()] = $entry
        $map[[System.IO.Path]::GetFileNameWithoutExtension($file).ToLowerInvariant()] = $entry
        $map[$file.ToLowerInvariant()] = $entry
    }
    return $map
}

function Resolve-ProjectRef {
    param([string]$ProjectRef, [hashtable]$IndexMap)
    $clean = Clean-Wiki $ProjectRef
    $clean = Normalize-PathText $clean
    $key = $clean.ToLowerInvariant()
    if ($IndexMap.ContainsKey($key)) { return $IndexMap[$key] }
    if ($clean -like "03_Projects/*.md") {
        $base = [System.IO.Path]::GetFileNameWithoutExtension($clean)
        if ($IndexMap.ContainsKey($base.ToLowerInvariant())) { return $IndexMap[$base.ToLowerInvariant()] }
    }
    return $null
}

function Parse-CommandTextNode {
    param([object]$Node, [hashtable]$IndexMap)
    if (-not $Node.text -or $Node.text -notlike "*$CommandMarker*") { return $null }
    if ($Node.text -like "*PPJ_COMMAND_TEMPLATE*") { return $null }

    $data = @{}
    $lines = $Node.text -split "\r?\n"
    foreach ($line in $lines) {
        if ($line -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*:\s*(.*)\s*$') {
            $data[$matches[1].ToLowerInvariant()] = $matches[2].Trim()
        }
    }
    if (-not $data.ContainsKey("project")) { return $null }

    $resolved = Resolve-ProjectRef -ProjectRef $data["project"] -IndexMap $IndexMap
    if ($null -eq $resolved) {
        return [pscustomobject]@{ Status = "UNRESOLVED"; Reason = "Cannot resolve project: $($data['project'])"; Data = $data; Project = $null; File = "" }
    }

    return [pscustomobject]@{
        Status = "READY"
        Reason = "Command parsed"
        Project = $resolved.Project
        Note = $resolved.Note
        Memory = $resolved.Memory
        File = $resolved.File
        Data = $data
    }
}

function Get-CanvasPhasePlan {
    $canvas = Get-Utf8Content -Path $CanvasFullPath | ConvertFrom-Json
    $nodes = @($canvas.nodes)
    $groups = @($nodes | Where-Object { $_.type -eq "group" -and $_.label -and ($AllowedLanes -contains $_.label) })
    $fileNodes = @($nodes | Where-Object { $_.type -eq "file" -and $_.file -and (Test-IsProjectNotePath $_.file) })
    $plan = @()
    foreach ($node in $fileNodes) {
        $file = Normalize-PathText $node.file
        $centerX = (Get-NumberProperty -Object $node -Name "x") + ((Get-NumberProperty -Object $node -Name "width" -Default 300) / 2)
        $centerY = (Get-NumberProperty -Object $node -Name "y") + ((Get-NumberProperty -Object $node -Name "height" -Default 80) / 2)
        $inside = @($groups | Where-Object {
            $gx = Get-NumberProperty -Object $_ -Name "x"
            $gy = Get-NumberProperty -Object $_ -Name "y"
            $gw = Get-NumberProperty -Object $_ -Name "width"
            $gh = Get-NumberProperty -Object $_ -Name "height"
            $centerX -ge $gx -and $centerX -le ($gx + $gw) -and $centerY -ge $gy -and $centerY -le ($gy + $gh)
        } | Select-Object -First 1)
        if ($inside.Count -gt 0) {
            $plan += [pscustomobject]@{ File = $file; Lane = $inside[0].label; Status = "READY" }
        }
    }
    return $plan
}

function Get-CanvasCommandPlan {
    $indexMap = Get-MemoryIndexMap
    $canvas = Get-Utf8Content -Path $CanvasFullPath | ConvertFrom-Json
    $commands = @()
    foreach ($node in @($canvas.nodes | Where-Object { $_.type -eq "text" -and $_.text -and $_.text -like "*$CommandMarker*" })) {
        $parsed = Parse-CommandTextNode -Node $node -IndexMap $indexMap
        if ($null -ne $parsed) { $commands += $parsed }
    }
    return $commands
}

function Update-ProjectNoteFromCommand {
    param([object]$Command, [object]$PhaseItem, [string]$BackupRoot)
    $path = Join-Path $VaultRoot $Command.File
    if (-not (Test-Path -LiteralPath $path)) { return [pscustomobject]@{ File = $Command.File; Result = "SKIPPED"; Reason = "Project note missing" } }
    $content = Get-Utf8Content -Path $path
    $original = $content
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $match = [regex]::Match($content, "(?s)\A---\r?\n(.*?)\r?\n---\r?\n?")
    if ($match.Success) {
        $yaml = $match.Groups[1].Value
        $body = $content.Substring($match.Length)
    } else {
        $yaml = "type: " + (ConvertTo-YamlQuoted "project")
        $body = $content
    }

    if ($null -ne $PhaseItem -and -not $SkipPhaseSync) {
        $yaml = Set-YamlScalar -Yaml $yaml -Key "phase" -Value (ConvertTo-YamlQuoted $PhaseItem.Lane)
        $yaml = Set-YamlScalar -Yaml $yaml -Key "status" -Value (ConvertTo-YamlQuoted $PhaseItem.Lane)
        $yaml = Set-YamlScalar -Yaml $yaml -Key "phase_canvas_group" -Value (ConvertTo-YamlQuoted $PhaseItem.Lane)
    }

    $keyMap = @{
        "owner" = "owner"
        "ba" = "ba_coordination"
        "ba_coordination" = "ba_coordination"
        "technical" = "technical_members"
        "technical_members" = "technical_members"
        "stakeholders" = "stakeholders"
        "business_stakeholders" = "stakeholders"
        "priority" = "priority"
        "next_action" = "next_action"
        "decision_needed" = "decision_needed"
        "blocker" = "blocker"
        "risk" = "risk"
    }
    foreach ($k in $keyMap.Keys) {
        if ($Command.Data.ContainsKey($k) -and -not [string]::IsNullOrWhiteSpace($Command.Data[$k])) {
            $yaml = Set-YamlScalar -Yaml $yaml -Key $keyMap[$k] -Value (ConvertTo-YamlQuoted $Command.Data[$k])
        }
    }
    $yaml = Set-YamlScalar -Yaml $yaml -Key "command_source" -Value (ConvertTo-YamlQuoted "PPJ_Executive_Board.canvas")
    $yaml = Set-YamlScalar -Yaml $yaml -Key "command_last_synced" -Value (ConvertTo-YamlQuoted $stamp)
    $content = "---`r`n$yaml`r`n---`r`n$body"
    if ($content -ne $original) {
        Backup-File -Path $path -BackupRoot $BackupRoot
        Set-Utf8Content -Path $path -Content $content
        return [pscustomobject]@{ File = $Command.File; Result = "UPDATED"; Reason = "Project YAML synced from Executive command card" }
    }
    return [pscustomobject]@{ File = $Command.File; Result = "UNCHANGED"; Reason = "Project YAML already matches command card" }
}

function Update-MemoryCardFromCommand {
    param([object]$Command, [string]$BackupRoot)
    if ([string]::IsNullOrWhiteSpace($Command.Memory)) { return [pscustomobject]@{ File = "Project_Memory"; Result = "SKIPPED"; Reason = "No memory card mapping for $($Command.Project)" } }
    $path = Join-Path $VaultRoot ("03_Projects/_Registry/Project_Memory/$($Command.Memory).md")
    if (-not (Test-Path -LiteralPath $path)) { return [pscustomobject]@{ File = $path; Result = "SKIPPED"; Reason = "Memory card missing" } }
    $content = Get-Utf8Content -Path $path
    $original = $content
    $stamp = Get-Date -Format "yyyy-MM-dd"
    $match = [regex]::Match($content, "(?s)\A---\r?\n(.*?)\r?\n---\r?\n?")
    if ($match.Success) {
        $yaml = $match.Groups[1].Value
        $body = $content.Substring($match.Length)
    } else {
        $yaml = "type: " + (ConvertTo-YamlQuoted "project_memory")
        $body = $content
    }
    $map = @{ "owner"="business_owner"; "ba"="ba_coordination"; "ba_coordination"="ba_coordination"; "technical"="technical_members"; "technical_members"="technical_members"; "stakeholders"="stakeholders"; "priority"="priority" }
    foreach ($k in $map.Keys) {
        if ($Command.Data.ContainsKey($k) -and -not [string]::IsNullOrWhiteSpace($Command.Data[$k])) {
            $yaml = Set-YamlScalar -Yaml $yaml -Key $map[$k] -Value (ConvertTo-YamlQuoted $Command.Data[$k])
        }
    }
    $yaml = Set-YamlScalar -Yaml $yaml -Key "last_verified" -Value (ConvertTo-YamlQuoted $stamp)
    $yaml = Set-YamlScalar -Yaml $yaml -Key "confidence" -Value (ConvertTo-YamlQuoted "Strong")
    $content = "---`r`n$yaml`r`n---`r`n$body"
    if ($content -ne $original) {
        Backup-File -Path $path -BackupRoot $BackupRoot
        Set-Utf8Content -Path $path -Content $content
        return [pscustomobject]@{ File = "03_Projects/_Registry/Project_Memory/$($Command.Memory).md"; Result = "UPDATED"; Reason = "Memory card frontmatter synced" }
    }
    return [pscustomobject]@{ File = "03_Projects/_Registry/Project_Memory/$($Command.Memory).md"; Result = "UNCHANGED"; Reason = "Memory card already matches" }
}

function Update-TableFromCommands {
    param([string]$RelPath, [object[]]$Commands, [string]$BackupRoot)
    $path = Join-Path $VaultRoot $RelPath
    if (-not (Test-Path -LiteralPath $path)) { return @([pscustomobject]@{ File=$RelPath; Result="SKIPPED"; Reason="File not found" }) }
    $lines = @(Get-Content -LiteralPath $path -Encoding UTF8)
    $headerIndex = -1
    for ($i=0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*\|' -and $lines[$i] -like '*Project*') { $headerIndex=$i; break }
    }
    if ($headerIndex -lt 0) { return @([pscustomobject]@{ File=$RelPath; Result="SKIPPED"; Reason="No table header found" }) }
    $headers = Split-MarkdownTableRow -Line $lines[$headerIndex]
    $col = @{}
    for ($h=0; $h -lt $headers.Count; $h++) { $col[$headers[$h].Trim().ToLowerInvariant()] = $h }
    $changed = $false
    $results = @()
    foreach ($cmd in $Commands) {
        if ($cmd.Status -ne "READY") { continue }
        $leaf = Split-Path $cmd.File -Leaf
        $base = [System.IO.Path]::GetFileNameWithoutExtension($leaf)
        $found = $false
        for ($r=$headerIndex+2; $r -lt $lines.Count; $r++) {
            if ($lines[$r] -notmatch '^\s*\|') { break }
            if ($lines[$r] -notlike "*$($cmd.Project)*" -and $lines[$r] -notlike "*$leaf*" -and $lines[$r] -notlike "*$base*") { continue }
            $cells = Split-MarkdownTableRow -Line $lines[$r]
            $updates = @{
                "ba / coordination" = @("ba","ba_coordination","owner")
                "technical members" = @("technical","technical_members")
                "technical owner / members" = @("technical","technical_members")
                "business stakeholder / department" = @("stakeholders","business_stakeholders")
                "department" = @("stakeholders","business_stakeholders")
                "current priority" = @("priority")
                "status / priority" = @("priority")
                "decision needed" = @("decision_needed")
                "next action" = @("next_action")
                "blocker" = @("blocker")
            }
            foreach ($tableCol in $updates.Keys) {
                if (-not $col.ContainsKey($tableCol)) { continue }
                foreach ($dataKey in $updates[$tableCol]) {
                    if ($cmd.Data.ContainsKey($dataKey) -and -not [string]::IsNullOrWhiteSpace($cmd.Data[$dataKey])) {
                        $idx = $col[$tableCol]
                        if ($cells.Count -gt $idx -and $cells[$idx].Trim() -ne $cmd.Data[$dataKey]) {
                            $cells[$idx] = " " + $cmd.Data[$dataKey] + " "
                            $changed = $true
                        }
                        break
                    }
                }
            }
            $lines[$r] = Join-MarkdownTableRow -Cells $cells
            $results += [pscustomobject]@{ File=$RelPath; Result="UPDATED"; Reason="$($cmd.Project) command fields synced" }
            $found = $true
            break
        }
        if (-not $found) { $results += [pscustomobject]@{ File=$RelPath; Result="SKIPPED"; Reason="$($cmd.Project) not found" } }
    }
    if ($changed) {
        Backup-File -Path $path -BackupRoot $BackupRoot
        Set-Utf8Content -Path $path -Content ($lines -join "`r`n")
    }
    return $results
}

function Invoke-SyncOnce {
    if (-not (Test-Path -LiteralPath $CanvasFullPath)) { throw "Canvas not found: $CanvasFullPath" }
    $mode = if ($Apply) { "APPLY" } else { "DRYRUN" }
    $phasePlan = @()
    if (-not $SkipPhaseSync) { $phasePlan = @(Get-CanvasPhasePlan) }
    $commands = @(Get-CanvasCommandPlan)
    $readyCommands = @($commands | Where-Object { $_.Status -eq "READY" })
    $badCommands = @($commands | Where-Object { $_.Status -ne "READY" })

    Write-Host ""
    Write-Host "PPJ Executive Command Center Sync"
    Write-Host "Vault: $VaultRoot"
    Write-Host "Mode: $mode"
    Write-Host ""
    Write-Host "Phase cards detected: $($phasePlan.Count)"
    Write-Host "Command cards detected: $($commands.Count)"
    Write-Host "Command cards ready: $($readyCommands.Count)"
    Write-Host "Command cards unresolved: $($badCommands.Count)"
    Write-Host ""

    foreach ($p in $phasePlan) { Write-Host ("[PHASE] {0} -> {1}" -f $p.File, $p.Lane) }
    foreach ($c in $commands) {
        if ($c.Status -eq "READY") { Write-Host ("[COMMAND] {0} -> {1}" -f $c.Project, $c.File) }
        else { Write-Host ("[COMMAND-ERROR] {0}" -f $c.Reason) }
    }

    if ($badCommands.Count -gt 0) { throw "Unresolved command card exists. Fix project reference before Apply." }
    if ($DryRun) { Write-Host ""; Write-Host "DryRun complete. No files changed."; return }

    $backupStamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupRoot = Join-Path $VaultRoot "99_Attachments/Audit/Executive_Command_Center_Sync_Backup/$backupStamp"
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    Backup-File -Path $CanvasFullPath -BackupRoot $backupRoot

    $results = @()
    foreach ($cmd in $readyCommands) {
        $phaseItem = @($phasePlan | Where-Object { $_.File -eq $cmd.File } | Select-Object -First 1)
        if ($phaseItem.Count -eq 0) { $phaseItem = $null } else { $phaseItem = $phaseItem[0] }
        if (-not $SkipProjectNotes) { $results += Update-ProjectNoteFromCommand -Command $cmd -PhaseItem $phaseItem -BackupRoot $backupRoot }
        if (-not $SkipMemoryCards) { $results += Update-MemoryCardFromCommand -Command $cmd -BackupRoot $backupRoot }
    }
    if (-not $SkipRegistry) { $results += Update-TableFromCommands -RelPath $RegistryRelPath -Commands $readyCommands -BackupRoot $backupRoot }
    if (-not $SkipResourceMatrix) { $results += Update-TableFromCommands -RelPath $ResourceMatrixRelPath -Commands $readyCommands -BackupRoot $backupRoot }

    Write-Host ""
    Write-Host "Apply results:"
    foreach ($r in $results) { Write-Host ("[{0}] {1} - {2}" -f $r.Result, $r.File, $r.Reason) }
    Write-Host ""
    Write-Host "Apply complete."
    Write-Host "Backup folder: $backupRoot"
}

if ($Watch) {
    Write-Host "Watching Executive Command Center. Press Ctrl+C to stop."
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
} else {
    Invoke-SyncOnce
}
