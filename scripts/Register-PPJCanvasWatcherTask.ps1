<#
.SYNOPSIS
    Installs (or re-installs) the Windows Task Scheduler job that keeps the
    Executive Canvas watcher running on this laptop.

.DESCRIPTION
    Run this once from a PowerShell window on this laptop (no admin rights
    required - it registers a per-user task). Re-run it any time to redeploy
    after editing Start-PPJCanvasWatcher.ps1's scheduling, or if the task was
    ever deleted or lost its self-healing trigger (see below - this task was
    first registered ad hoc, without one).

    On Linux, ppj-executive-canvas-watcher.service uses `Restart=always` +
    `RestartSec=5`: if the watcher process dies for any reason, systemd starts
    a new one within 5 seconds. Windows Task Scheduler has no equivalent for a
    long-running process that exits unexpectedly - its restart settings only
    fire when the *task* itself reports failure, not when something outside
    Task Scheduler (a crash, a manual `Stop-Process`, a reboot mid-run) kills
    the process it launched.

    The fix here is a second trigger: a supervisor tick every 2 hours that
    just runs Start-PPJCanvasWatcher.ps1 again. The launcher is already
    idempotent - it checks for a running watcher process before starting one
    (see its own header) - so a tick either no-ops (watcher alive) or starts a
    fresh watcher (watcher dead). This gives the same self-healing as the Linux
    service without adding any state, just slower: a dead watcher comes back
    within 2 hours. (Was 5 minutes until 2026-10-22, when the owner asked for
    a looser tick - the watcher normally runs for the whole session anyway.)

    Two triggers:
      1. At logon (1 min delay) - the normal start.
      2. Every 2 hours, indefinitely - the self-healing supervisor tick.
#>

$ErrorActionPreference = "Stop"

$TaskName  = "PPJ Executive Canvas Watcher"
$VaultRoot = Split-Path $PSScriptRoot -Parent
$Launcher  = Join-Path $PSScriptRoot "Start-PPJCanvasWatcher.ps1"

if (-not (Test-Path $Launcher)) {
    throw "Launcher not found at $Launcher - is this being run from the vault's scripts\ folder?"
}

$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$Launcher`"" `
    -WorkingDirectory $VaultRoot

$logonTrigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
$logonTrigger.Delay = "PT1M"

$supervisorTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) `
    -RepetitionInterval (New-TimeSpan -Hours 2) -RepetitionDuration (New-TimeSpan -Days 3650)

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit ([TimeSpan]::Zero) `
    -MultipleInstances IgnoreNew

$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" `
    -LogonType Interactive -RunLevel Limited

Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $logonTrigger, $supervisorTrigger `
    -Settings $settings -Principal $principal `
    -Description "Watches 03_Projects/Canvas/PPJ_Executive_Board_v2.canvas and syncs card geometry and card text into the vault. Windows counterpart of ppj-executive-canvas-watcher.service. Self-healing: a 2-hour supervisor tick restarts the watcher if it died, since Task Scheduler cannot detect an externally-killed long-running process the way systemd's Restart=always can. Log: $VaultRoot\.git\canvas-watcher.log. See 03_Projects/_Registry/PPJ_SYNC_DEVICE_REGISTRY.md." |
    Out-Null

Write-Host "Registered scheduled task '$TaskName' (at logon + every 2 h self-healing tick):"
Get-ScheduledTaskInfo -TaskName $TaskName | Format-List NextRunTime, LastRunTime, LastTaskResult
Write-Host "Run it once by hand to test: Start-ScheduledTask -TaskName '$TaskName'"
