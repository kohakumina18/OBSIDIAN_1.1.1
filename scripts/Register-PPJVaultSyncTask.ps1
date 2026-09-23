<#
.SYNOPSIS
    Installs (or re-installs) the Windows Task Scheduler job that runs
    Sync-PPJObsidianVaultToGitHub.ps1 once a day.

.DESCRIPTION
    Run this once from an elevated-or-not PowerShell window on this laptop
    (no admin rights required - it registers a per-user task).

    Schedule: daily at 00:00 (midnight).
    - Runs only when you are logged on (needed for git/SSH and for the
      Windows toast notification to be visible).
    - "Start the task as soon as possible after a scheduled start is missed"
      is on, so if the laptop is asleep/off at midnight it catches up the
      next time you log in - it does not wake the machine.
    - Allowed to run on battery; will not be stopped if you unplug.
    - Won't stack a second run if a previous one is still going.

.NOTES
    Re-run this script any time to update the schedule/settings; it replaces
    the existing task of the same name rather than duplicating it.
#>

$ErrorActionPreference = "Stop"

$TaskName   = "PPJ Obsidian Vault Daily Sync"
$VaultRoot  = Split-Path $PSScriptRoot -Parent
$ScriptPath = Join-Path $PSScriptRoot "Sync-PPJObsidianVaultToGitHub.ps1"

if (-not (Test-Path $ScriptPath)) {
    throw "Sync script not found at $ScriptPath - is this being run from the vault's scripts\ folder?"
}

$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptPath`"" `
    -WorkingDirectory $VaultRoot

$trigger = New-ScheduledTaskTrigger -Daily -At "00:00"

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

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
    -Settings $settings -Principal $principal `
    -Description "Daily git sync of the PPJ Obsidian vault ($VaultRoot) to https://github.com/kohakumina18/OBSIDIAN_1.1.1. See Sync-PPJObsidianVaultToGitHub.ps1." |
    Out-Null

Write-Host "Registered scheduled task '$TaskName':"
Get-ScheduledTaskInfo -TaskName $TaskName | Format-List NextRunTime, LastRunTime, LastTaskResult
Write-Host "Run it once by hand to test: Start-ScheduledTask -TaskName '$TaskName'"
