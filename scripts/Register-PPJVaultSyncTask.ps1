<#
.SYNOPSIS
    Installs (or re-installs) the Windows Task Scheduler job that runs the
    vault -> GitHub sync on this laptop.

.DESCRIPTION
    Run this once from a PowerShell window on this laptop (no admin rights
    required - it registers a per-user task). Re-run it any time to update
    the schedule/settings or to redeploy a newer Invoke-PPJVaultSyncLauncher.ps1;
    it replaces the existing task of the same name rather than duplicating it.

    Because the vault lives on a USB drive whose letter can change, the actual
    sync entry point (scripts\Invoke-PPJVaultSyncLauncher.ps1) is deployed to a
    fixed path on C: - it has to live somewhere that still exists when the USB
    drive is unplugged, so it can notice that and say so instead of just failing
    to launch. See that script's own header for how it then finds the vault.

    Schedule: every 8 hours, starting at 00:00 (00:00 / 08:00 / 16:00) - see
    PPJ_SYNC_DEVICE_REGISTRY.md for why (multiple devices are now actively
    edited the same day; once-daily left too wide a conflict window). Other
    devices in the registry should offset their own start time by 10-15 min
    from this one and from each other, so scheduled pushes don't race.
    - Runs only when you are logged on (needed for git/SSH and for the
      Windows toast notification to be visible).
    - "Start the task as soon as possible after a scheduled start is missed"
      is on, so if the laptop is asleep/off at a trigger time it catches up
      the next time you log in - it does not wake the machine.
    - Allowed to run on battery; will not be stopped if you unplug.
    - Won't stack a second run if a previous one is still going.
#>

$ErrorActionPreference = "Stop"

$TaskName    = "PPJ Obsidian Vault Sync"
$OldTaskName = "PPJ Obsidian Vault Daily Sync"  # superseded 2026-09-23 by the every-8-hours schedule below
$VaultRoot     = Split-Path $PSScriptRoot -Parent
$LauncherSrc   = Join-Path $PSScriptRoot "Invoke-PPJVaultSyncLauncher.ps1"
$DeployDir     = Join-Path $env:LOCALAPPDATA "PPJVaultSync"
$DeployedPath  = Join-Path $DeployDir "Invoke-PPJVaultSyncLauncher.ps1"

if (-not (Test-Path $LauncherSrc)) {
    throw "Launcher not found at $LauncherSrc - is this being run from the vault's scripts\ folder?"
}

New-Item -ItemType Directory -Force -Path $DeployDir | Out-Null
Copy-Item -Path $LauncherSrc -Destination $DeployedPath -Force
Write-Host "Deployed launcher to $DeployedPath (this is the copy Task Scheduler runs; re-run this script after editing the vault-side original)."

$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$DeployedPath`" -Quiet" `
    -WorkingDirectory $DeployDir

$trigger = New-ScheduledTaskTrigger -Once -At "00:00" `
    -RepetitionInterval (New-TimeSpan -Hours 8) -RepetitionDuration (New-TimeSpan -Days 3650)

$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -MultipleInstances IgnoreNew `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 15) `
    -RestartCount 2 -RestartInterval (New-TimeSpan -Minutes 5)

$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" `
    -LogonType Interactive -RunLevel Limited

Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName $OldTaskName -Confirm:$false -ErrorAction SilentlyContinue

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
    -Settings $settings -Principal $principal `
    -Description "Vault -> GitHub sync (every 8h) for the PPJ Obsidian vault, https://github.com/kohakumina18/OBSIDIAN_1.1.1. Entry point: $DeployedPath (deployed copy of scripts\Invoke-PPJVaultSyncLauncher.ps1), which finds the vault and hands off to scripts\Sync-VaultGit.ps1 on it. See 03_Projects/_Registry/PPJ_SYNC_DEVICE_REGISTRY.md." |
    Out-Null

Write-Host "Registered scheduled task '$TaskName':"
Get-ScheduledTaskInfo -TaskName $TaskName | Format-List NextRunTime, LastRunTime, LastTaskResult
Write-Host "Run it once by hand to test: Start-ScheduledTask -TaskName '$TaskName'"
