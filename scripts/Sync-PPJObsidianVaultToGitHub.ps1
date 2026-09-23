<#
.SYNOPSIS
    Daily sync of the PPJ Obsidian vault (E: USB drive) to its GitHub source-of-truth repo.

.DESCRIPTION
    Run unattended (Windows Task Scheduler) or by hand from the vault root.
    Safe by design:
      - Never force-pushes and never discards local changes.
      - If the vault drive is missing, or a pull/push runs into trouble, it logs the
        problem and raises a Windows notification instead of guessing.
      - Skips the commit entirely when there is nothing to sync beyond its own log line.
    Every run appends one line to 99_Attachments/Audit/PPJ_Daily_Vault_Sync_Log.md,
    which is committed along with any real vault changes - so the log doubles as a
    heartbeat: if that file's git history has a gap, the job did not run.

.NOTES
    Registered by Register-PPJVaultSyncTask.ps1. Re-run that script to (re)install
    the scheduled task; this script only does the sync itself.
#>

$ErrorActionPreference = "Stop"

$VaultRoot = Split-Path $PSScriptRoot -Parent
$LogPath   = Join-Path $VaultRoot "99_Attachments\Audit\PPJ_Daily_Vault_Sync_Log.md"
$AlertPath = Join-Path $env:USERPROFILE "Desktop\PPJ_VAULT_SYNC_ALERT.txt"
$Stamp     = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

function Show-PPJToast {
    param([string]$Title, [string]$Message)
    try {
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
        $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(
            [Windows.UI.Notifications.ToastTemplateType]::ToastText02)
        $texts = $template.GetElementsByTagName("text")
        $texts.Item(0).AppendChild($template.CreateTextNode($Title)) | Out-Null
        $texts.Item(1).AppendChild($template.CreateTextNode($Message)) | Out-Null
        $toast = [Windows.UI.Notifications.ToastNotification]::new($template)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Microsoft.Windows.Explorer").Show($toast)
    } catch {
        # Toast is best-effort only; the desktop alert file and log line below are
        # the guaranteed fallback, so a toast failure is never itself fatal.
    }
}

function Write-PPJAlert {
    param([string]$Reason)
    Show-PPJToast -Title "PPJ Vault sync needs attention" -Message $Reason
    "PPJ Vault sync problem - $Stamp`r`n`r`n$Reason`r`n`r`nDelete this file once resolved; it is recreated only when a run has a problem." |
        Set-Content -Encoding UTF8 $AlertPath
}

function Clear-PPJAlert {
    if (Test-Path $AlertPath) { Remove-Item -Force $AlertPath }
}

function Add-PPJLogLine {
    param([string]$Status, [string]$Detail)
    $dir = Split-Path $LogPath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    if (-not (Test-Path $LogPath)) {
        "# PPJ Daily Vault Sync Log`r`n`r`nAppend-only. One line per scheduled run of Sync-PPJObsidianVaultToGitHub.ps1.`r`n`r`n| Timestamp | Status | Detail |`r`n| --- | --- | --- |" |
            Set-Content -Encoding UTF8 $LogPath
    }
    $detailCell = $Detail -replace '\|', '\|' -replace "`r?`n", ' '
    "| $Stamp | $Status | $detailCell |" | Add-Content -Encoding UTF8 $LogPath
}

# --- 1. Vault present? --------------------------------------------------------------
if (-not (Test-Path $VaultRoot)) {
    Write-PPJAlert "USB vault drive not found at $VaultRoot. Plug it in, then the next scheduled run (or a manual one) will sync normally."
    exit 1
}

Set-Location $VaultRoot

if (-not (Test-Path ".git")) {
    Write-PPJAlert "$VaultRoot is not a git repository (no .git folder). Sync skipped."
    exit 1
}

# --- 2. Pull any remote changes first (rebase, never force) ------------------------
try {
    git fetch origin 2>&1 | Out-Null
} catch {
    Write-PPJAlert "git fetch failed (network/remote unreachable?): $($_.Exception.Message)"
    Add-PPJLogLine "ERROR" "fetch failed: $($_.Exception.Message)"
    exit 1
}

$behind = (git rev-list HEAD..origin/main --count 2>&1)
if ($behind -match '^\d+$' -and [int]$behind -gt 0) {
    git pull --rebase origin main 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        git rebase --abort 2>&1 | Out-Null
        Write-PPJAlert "Pulling $behind remote commit(s) failed (likely a conflict). Nothing was changed locally - open the vault and resolve it by hand, then re-run the sync."
        Add-PPJLogLine "ERROR" "rebase pull failed, $behind commit(s) behind; aborted cleanly"
        exit 1
    }
}

# --- 3. Record this run, then stage everything (this always changes the log file) --
Add-PPJLogLine "OK" "sync started"

git add -A 2>&1 | Out-Null

$statusLines = git status --porcelain
$changedCount = ($statusLines | Measure-Object -Line).Lines

if ($changedCount -eq 0) {
    # Should not normally happen (the log line above always changes something),
    # but if it does there is genuinely nothing to commit.
    Clear-PPJAlert
    exit 0
}

$commitMessage = "Daily vault sync - $Stamp ($changedCount file(s) changed)"
git commit -q -m $commitMessage 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-PPJAlert "git commit failed after staging $changedCount file(s). Check the vault manually."
    exit 1
}

# --- 4. Push ------------------------------------------------------------------------
git push origin main 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-PPJAlert "Commit succeeded locally but git push failed (network, or the remote moved again). It will retry on the next scheduled run; nothing is lost."
    exit 1
}

Clear-PPJAlert
exit 0
