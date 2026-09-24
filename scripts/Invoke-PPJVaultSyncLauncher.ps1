<#
.SYNOPSIS
    Task Scheduler entry point for the vault sync, shared by every Windows
    machine in the fleet - whether the vault sits on a fixed internal drive or
    a removable USB drive.

.DESCRIPTION
    This file's canonical, version-controlled copy is here in the vault, but the
    copy Task Scheduler actually runs is deployed to a fixed path on the C: drive
    by Register-PPJVaultSyncTask.ps1. It has to live off the vault's own drive:
    on a USB machine its whole job is to notice when that drive is *not* plugged
    in and say so, which it obviously cannot do from a script sitting on the
    drive it is checking for. Fixed-drive machines inherit the same deployment
    for one reason: it is the one behaviour every host in the fleet shares.

    Resolution order for the vault path:
      1. $env:PPJ_VAULT_PATH, if set (manual override, no code change needed).
      2. $KnownHostPaths below, keyed by $env:COMPUTERNAME - the fast path for
         a machine whose vault sits on a fixed drive with a stable path. Add a
         line here for a new fixed-drive machine; do not add a USB machine here
         (step 3 exists for those).
      3. For a USB-style vault (HAKU today), scan every mounted drive's root for
         $RelativeVaultPath, in case the drive got reassigned a different
         letter. $LastKnownUsbPath is tried first as a shortcut.

    If none of those resolve to a real vault (folder + .git present), this raises
    a Windows toast, drops a marker file on the Desktop, and exits - it never
    guesses or falls back to the legacy local copy at
    C:\Users\nvakt\Documents\obsidian\BA_Obsidian_Vault (per AGENTS.md, that copy
    is reference-only and must not receive automated writes).

    Once the vault is found, this just delegates to the real sync logic in
    scripts\Sync-VaultGit.ps1 *on the vault itself* - so a vault-side update to
    that script takes effect immediately, with nothing to redeploy here.
#>

[CmdletBinding()]
param([switch]$Quiet)

$ErrorActionPreference = 'Stop'

# Fixed-drive machines: hostname -> vault path. Checked before the USB scan
# because it is exact and does not touch every drive letter on the machine.
$KnownHostPaths = @{
    'YOGHAAKU' = 'D:\PPJ\syncing'
}

# USB-style machines (HAKU today): relative path from a drive root down to the
# vault folder, used both as the fast-path guess and as the marker the scan
# looks for on every other drive.
$RelativeVaultPath = 'DATA\USB-VAULT\BA_Obsidian_Vault_FULL_LINUX_20260918\USB_BA_Obsidian_Vault'
$LastKnownUsbPath  = 'E:\DATA\USB-VAULT\BA_Obsidian_Vault_FULL_LINUX_20260918\USB_BA_Obsidian_Vault'

$AlertPath = Join-Path $env:USERPROFILE 'Desktop\PPJ_VAULT_SYNC_ALERT.txt'

function Show-PPJToast {
    param([string]$Title, [string]$Message)
    try {
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
        $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(
            [Windows.UI.Notifications.ToastTemplateType]::ToastText02)
        $texts = $template.GetElementsByTagName('text')
        $texts.Item(0).AppendChild($template.CreateTextNode($Title)) | Out-Null
        $texts.Item(1).AppendChild($template.CreateTextNode($Message)) | Out-Null
        $toast = [Windows.UI.Notifications.ToastNotification]::new($template)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Microsoft.Windows.Explorer').Show($toast)
    } catch { }
}

function Test-PPJVaultAt {
    param([string]$Path)
    return (Test-Path -LiteralPath $Path) -and (Test-Path -LiteralPath (Join-Path $Path '.git')) -and
           (Test-Path -LiteralPath (Join-Path $Path 'scripts\Sync-VaultGit.ps1'))
}

function Resolve-PPJVaultPath {
    if ($env:PPJ_VAULT_PATH -and (Test-PPJVaultAt $env:PPJ_VAULT_PATH)) {
        return $env:PPJ_VAULT_PATH
    }
    $known = $KnownHostPaths[$env:COMPUTERNAME]
    if ($known -and (Test-PPJVaultAt $known)) {
        return $known
    }
    if (Test-PPJVaultAt $LastKnownUsbPath) {
        return $LastKnownUsbPath
    }
    $drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue |
        Where-Object { $_.Root -ne (Split-Path $LastKnownUsbPath -Qualifier) + '\' }
    foreach ($drive in $drives) {
        $candidate = Join-Path $drive.Root $RelativeVaultPath
        if (Test-PPJVaultAt $candidate) { return $candidate }
    }
    return $null
}

$VaultPath = Resolve-PPJVaultPath

if (-not $VaultPath) {
    $message = "Vault not found at its known path, and no USB vault drive is connected either. If this machine's vault moved, update `$KnownHostPaths in Invoke-PPJVaultSyncLauncher.ps1. If it's on a USB drive, plug it in - the next scheduled run (or 'schtasks /run /tn `"PPJ Obsidian Vault Sync`"') will sync normally."
    Show-PPJToast -Title 'PPJ Vault sync skipped' -Message $message
    "PPJ Vault sync skipped - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n$message`r`n`r`nDeleted automatically once a sync succeeds." |
        Set-Content -Encoding UTF8 $AlertPath
    exit 0
}

if (Test-Path -LiteralPath $AlertPath) { Remove-Item -Force $AlertPath -ErrorAction SilentlyContinue }

# This vault previously synced via Syncthing (and, before that, Obsidian
# LiveSync) - see 99_Attachments/Legacy_Syncthing_Import/README.md. A live
# Syncthing/LiveSync process alongside git can silently overwrite files, so
# flag it (never blocks the sync - this machine can't tell if it's actually
# watching *this* folder, only that it's running at all).
$conflictingProcess = Get-Process -Name 'syncthing', 'syncthingtray' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($conflictingProcess) {
    Show-PPJToast -Title 'PPJ Vault: Syncthing detected' `
        -Message "Syncthing is running alongside the git sync. If it still watches this vault folder, the two can overwrite each other - see PPJ_SYNC_DEVICE_REGISTRY.md."
}

$syncScript = Join-Path $VaultPath 'scripts\Sync-VaultGit.ps1'
& $syncScript -VaultPath $VaultPath -Quiet:$Quiet
exit $LASTEXITCODE
