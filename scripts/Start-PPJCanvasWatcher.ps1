<#
.SYNOPSIS
    Runs the Executive Canvas watcher in the background with a rotating log.

.DESCRIPTION
    The Windows counterpart of ppj-executive-canvas-watcher.service on the
    Ubuntu vault. Task Scheduler cannot redirect a process's output, and the
    watcher is a long-running poll loop whose output is the only record of what
    it did, so it is launched through here instead of directly.

    python.exe is used rather than pythonw.exe: pythonw is a GUI-subsystem
    binary, so PowerShell does not wait on it and this launcher would exit
    immediately, losing both the log and the single-instance guard. The console
    window is suppressed by launching this script hidden instead.

    Only one watcher may run at a time - two would race on the same Canvas and
    on the snapshot. A second invocation exits rather than starting a rival.

    Log:  <vault>\.git\canvas-watcher.log

.PARAMETER VaultPath
    Vault root. Defaults to the parent of the folder holding this script.

.PARAMETER DryRun
    Detect and log changes without writing them to the vault.
#>
[CmdletBinding()]
param(
    [string]$VaultPath,
    [switch]$DryRun
)

Set-StrictMode -Version 1.0
$ErrorActionPreference = 'Stop'

if (-not $VaultPath) {
    $VaultPath = Split-Path -Parent $PSScriptRoot
}

$LogFile = Join-Path $VaultPath '.git\canvas-watcher.log'
$Watcher = Join-Path $VaultPath 'scripts\watch_ppj_executive_canvas.py'

function Write-Log {
    param([string]$Level, [string]$Message)
    $line = '{0} [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
    try { Add-Content -LiteralPath $LogFile -Value $line -Encoding UTF8 } catch { }
}

function Resolve-Python {
    $candidates = @(
        "$env:LOCALAPPDATA\Programs\Python\Python313\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe"
    )
    foreach ($c in $candidates) { if (Test-Path -LiteralPath $c) { return $c } }
    # Any other 3.x the user may have installed, newest first.
    $found = Get-ChildItem "$env:LOCALAPPDATA\Programs\Python" -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending |
        ForEach-Object { Join-Path $_.FullName 'python.exe' } |
        Where-Object { Test-Path -LiteralPath $_ } |
        Select-Object -First 1
    if ($found) { return $found }
    # The Microsoft Store alias is a 0-byte stub that only opens the Store.
    $cmd = Get-Command python.exe -ErrorAction SilentlyContinue
    if ($cmd -and (Get-Item -LiteralPath $cmd.Source).Length -gt 0) { return $cmd.Source }
    return $null
}

try {
    if ((Test-Path -LiteralPath $LogFile) -and ((Get-Item -LiteralPath $LogFile).Length -gt 1MB)) {
        Move-Item -LiteralPath $LogFile -Destination "$LogFile.old" -Force
    }
} catch { }

if (-not (Test-Path -LiteralPath $Watcher)) {
    Write-Log 'ERROR' "Watcher script not found: $Watcher"
    exit 1
}

$python = Resolve-Python
if (-not $python) {
    Write-Log 'ERROR' 'python.exe not found - install Python 3 to run the Canvas watcher.'
    exit 1
}

# CommandLine carries the script path, which is what distinguishes this watcher
# from any other Python process the user happens to be running.
$running = Get-CimInstance Win32_Process -Filter "Name = 'python.exe'" -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -and $_.CommandLine -like '*watch_ppj_executive_canvas.py*' }
if ($running) {
    Write-Log 'WARN' "Watcher already running (PID $($running.ProcessId)) - not starting a second one."
    exit 0
}

$mode = if ($DryRun) { '--dry-run' } else { '--apply' }
Write-Log 'INFO' "Starting Canvas watcher on $env:COMPUTERNAME ($mode)"

# -u keeps the child unbuffered so the log stays current instead of appearing
# only when the process eventually exits.
#
# Out-File rather than *>> : in Windows PowerShell the redirection operators
# write UTF-16, which would interleave unreadably with the UTF-8 lines
# Write-Log appends to the same file.
& $python -u $Watcher $mode --verbose 2>&1 |
    ForEach-Object { $_.ToString() } |
    Out-File -LiteralPath $LogFile -Append -Encoding utf8

Write-Log 'WARN' "Canvas watcher exited with code $LASTEXITCODE"
exit $LASTEXITCODE
