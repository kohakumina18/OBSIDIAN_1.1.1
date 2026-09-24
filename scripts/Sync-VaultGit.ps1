<#
.SYNOPSIS
    Syncs this Obsidian vault with its GitHub remote (commit -> fetch -> merge -> push).

.DESCRIPTION
    Written for unattended runs from Windows Task Scheduler, but safe to run by hand.

    Order is deliberate: local changes are committed BEFORE any merge, so nothing
    in the working tree can be lost by an incoming change.

    Commit messages are self-tracing: subject line stays "Vault sync from
    <HOST> - <date>" for a familiar `git log --oneline`, but the body lists
    every changed file (git's own --stat, capped at 30 lines so a bulk
    changeset doesn't blow the message up) plus a one-line summary of
    added/modified/deleted counts and total data volume touched - so `git log`
    alone answers "what changed and how much" without a separate `git show`.

    On a merge conflict the script aborts the merge, leaves the working tree
    exactly as it was, drops a SYNC-CONFLICT-README.md marker in the vault root
    and exits non-zero. Conflicts are resolved by hand, never automatically.

    Log:  <vault>\.git\vault-sync.log   (inside .git, so it is never committed)

    Any ERROR-level log line also raises a Windows toast notification (best
    effort; silently skipped if there is no interactive logon session).

.PARAMETER VaultPath
    Vault root. Defaults to the parent of the folder holding this script.

.PARAMETER Quiet
    Suppress console output (Task Scheduler runs pass this implicitly by being hidden).
#>
[CmdletBinding()]
param(
    [string]$VaultPath,
    [switch]$Quiet
)

Set-StrictMode -Version 1.0
$ErrorActionPreference = 'Stop'

if (-not $VaultPath) {
    $VaultPath = Split-Path -Parent $PSScriptRoot
}

$LogFile      = Join-Path $VaultPath '.git\vault-sync.log'
$LockFile     = Join-Path $VaultPath '.git\vault-sync.lock'
$ConflictFile = Join-Path $VaultPath 'SYNC-CONFLICT-README.md'

# Best-effort Windows toast so an unattended failure (fetch offline, push
# rejected, conflict) is actually seen instead of sitting quietly in the log.
# Requires an interactive logon session; silently does nothing otherwise.
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

function Write-Log {
    param([string]$Level, [string]$Message)
    $line = '{0} [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
    try { Add-Content -LiteralPath $LogFile -Value $line -Encoding UTF8 } catch { }
    if (-not $Quiet) { Write-Host $line }
    if ($Level -eq 'ERROR') { Show-PPJToast -Title "Vault sync failed on $env:COMPUTERNAME" -Message $Message }
}

function Resolve-Git {
    # PATH first, then the known install locations on this machine.
    $cmd = Get-Command git.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $candidates = @(
        'D:\Microsoft VS Code\Git\cmd\git.exe',
        'C:\Program Files\Git\cmd\git.exe',
        'C:\Program Files (x86)\Git\cmd\git.exe',
        "$env:LOCALAPPDATA\Programs\Git\cmd\git.exe"
    )
    foreach ($c in $candidates) { if (Test-Path -LiteralPath $c) { return $c } }
    return $null
}

# Runs git and returns a result object instead of throwing, so one failed git
# call can be logged with its stderr rather than killing the run silently.
#
# Under $ErrorActionPreference = 'Stop' (set script-wide above), PowerShell
# promotes *any* stderr line from a native command captured via 2>&1 into a
# terminating error - including git's routine progress/warning chatter on
# fetch, push and status, not just real failures. That would abort straight
# to the outer catch before Code/Text are ever inspected, so stderr is
# non-terminating for the duration of this call; Code is still the real
# signal callers check.
function Invoke-Git {
    param([string[]]$Arguments)
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $out = & $Git -C $VaultPath @Arguments 2>&1
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previous
    }
    $text = ($out | ForEach-Object { $_.ToString() }) -join "`n"
    return [pscustomobject]@{ Code = $code; Text = $text }
}

function Format-PPJByteSize {
    param([double]$Bytes)
    if ($Bytes -lt 1KB) { return "$([int]$Bytes) B" }
    if ($Bytes -lt 1MB) { return "{0:N1} KB" -f ($Bytes / 1KB) }
    if ($Bytes -lt 1GB) { return "{0:N1} MB" -f ($Bytes / 1MB) }
    return "{0:N2} GB" -f ($Bytes / 1GB)
}

# Builds a commit message that traces which files changed and how much data
# moved, instead of the bare "Vault sync from <HOST>" subject that gave no way
# to tell what a sync actually touched without a separate `git show --stat`.
#
# Byte totals are summed from working-tree/HEAD file sizes, not from git's
# line-based --stat (meaningless for binary files beyond its own per-file
# "Bin X -> Y bytes" note) - computed once here so the header states one plain
# total instead of making the reader add up every binary line by hand.
function Get-PPJSyncCommitMessage {
    param([string]$Subject)

    $nameStatus = (Invoke-Git @('diff', '--cached', '--name-status')).Text
    $entries = @($nameStatus -split "`n" | Where-Object { $_.Trim() })

    $added = 0; $modified = 0; $deleted = 0; $renamed = 0
    $totalBytes = 0
    # A changeset this large is a bulk operation (import, mass rename), not a
    # normal editing session - walking every file's size would be slow and the
    # per-file stat table below is already capped, so the byte total is
    # skipped rather than silently wrong for only part of the changeset.
    $skipByteCount = $entries.Count -gt 500

    foreach ($entry in $entries) {
        $parts = $entry -split "`t"
        $status = $parts[0]
        $path = $parts[-1]
        switch -Regex ($status) {
            '^A' { $added++ }
            '^M' { $modified++ }
            '^D' { $deleted++ }
            '^R' { $renamed++ }
            default { $modified++ }
        }
        if ($skipByteCount) { continue }
        if ($status.StartsWith('D')) {
            $sizeText = (Invoke-Git @('cat-file', '-s', "HEAD:$path")).Text.Trim()
            if ($sizeText -match '^\d+$') { $totalBytes += [int64]$sizeText }
        } else {
            $fp = Join-Path $VaultPath $path
            if (Test-Path -LiteralPath $fp) { $totalBytes += (Get-Item -LiteralPath $fp).Length }
        }
    }

    $breakdown = @(
        if ($added)    { "$added added" }
        if ($modified) { "$modified modified" }
        if ($deleted)  { "$deleted deleted" }
        if ($renamed)  { "$renamed renamed" }
    ) -join ', '
    $volumeText = if ($skipByteCount) { '' } else { " | ~$(Format-PPJByteSize $totalBytes) touched" }

    # width=200,name-width=88,count=30: wide enough that Vietnamese/long paths
    # don't get ellipsis-truncated in the middle (git's default width would),
    # capped at 30 files so a bulk changeset doesn't blow the message up -
    # git appends its own "...and N more files" line past the cap.
    $statTable = (Invoke-Git @('diff', '--cached', '--stat=200,88,30')).Text.TrimEnd()

    return (@(
        $Subject,
        '',
        "$($entries.Count) file(s) changed ($breakdown)$volumeText",
        '',
        $statTable
    ) -join "`n")
}

# --- log rotation -----------------------------------------------------------
try {
    if ((Test-Path -LiteralPath $LogFile) -and ((Get-Item -LiteralPath $LogFile).Length -gt 1MB)) {
        Move-Item -LiteralPath $LogFile -Destination "$LogFile.old" -Force
    }
} catch { }

# --- single instance --------------------------------------------------------
# A stale lock (previous run killed mid-way) is cleared after 1 hour.
if (Test-Path -LiteralPath $LockFile) {
    $age = (Get-Date) - (Get-Item -LiteralPath $LockFile).LastWriteTime
    if ($age.TotalHours -lt 1) {
        Write-Log 'WARN' 'Another sync is already running - skipping this run.'
        exit 0
    }
    Write-Log 'WARN' ('Clearing stale lock ({0:N0} min old).' -f $age.TotalMinutes)
    Remove-Item -LiteralPath $LockFile -Force
}

$Git = Resolve-Git
if (-not $Git) {
    Write-Log 'ERROR' 'git.exe not found - install Git or add it to PATH.'
    exit 1
}

if (-not (Test-Path -LiteralPath (Join-Path $VaultPath '.git'))) {
    Write-Log 'ERROR' "Not a git repository: $VaultPath"
    exit 1
}

New-Item -ItemType File -Path $LockFile -Force | Out-Null

try {
    Write-Log 'INFO' "=== Sync start on $env:COMPUTERNAME ($VaultPath) ==="

    $branch = (Invoke-Git @('rev-parse', '--abbrev-ref', 'HEAD')).Text.Trim()
    if (-not $branch -or $branch -eq 'HEAD') {
        Write-Log 'ERROR' 'Detached HEAD or no branch - resolve by hand.'
        exit 1
    }

    # A merge/rebase left half-finished by an earlier run must be cleared by a
    # human; continuing would build on a broken state.
    $gitDir = (Invoke-Git @('rev-parse', '--git-dir')).Text.Trim()
    if (-not [System.IO.Path]::IsPathRooted($gitDir)) { $gitDir = Join-Path $VaultPath $gitDir }
    foreach ($marker in @('MERGE_HEAD', 'REBASE_HEAD', 'CHERRY_PICK_HEAD')) {
        if (Test-Path -LiteralPath (Join-Path $gitDir $marker)) {
            Write-Log 'ERROR' "Unfinished $marker in the repository - resolve it before syncing again."
            exit 1
        }
    }

    # --- 1. commit local work -----------------------------------------------
    $status = (Invoke-Git @('status', '--porcelain')).Text
    if ($status.Trim()) {
        $add = Invoke-Git @('add', '-A')
        if ($add.Code -ne 0) {
            Write-Log 'ERROR' "git add failed: $($add.Text)"
            exit 1
        }
        $subject = 'Vault sync from {0} - {1}' -f $env:COMPUTERNAME, (Get-Date -Format 'yyyy-MM-dd HH:mm')
        $msg = Get-PPJSyncCommitMessage -Subject $subject
        $commit = Invoke-Git @('commit', '-m', $msg)
        if ($commit.Code -ne 0) {
            Write-Log 'ERROR' "git commit failed: $($commit.Text)"
            exit 1
        }
        # Log only the traceable summary line, not the full per-file table -
        # that stays in the commit itself (`git show --stat`), one place, not two.
        $summaryLine = ($msg -split "`n")[2]
        Write-Log 'INFO' "Committed: $summaryLine"
    } else {
        Write-Log 'INFO' 'No local changes to commit.'
    }

    # --- 2. fetch ------------------------------------------------------------
    $fetch = Invoke-Git @('fetch', 'origin', '--quiet')
    if ($fetch.Code -ne 0) {
        Write-Log 'ERROR' "git fetch failed (offline or auth expired): $($fetch.Text)"
        exit 1
    }

    $local  = (Invoke-Git @('rev-parse', $branch)).Text.Trim()
    $remote = (Invoke-Git @('rev-parse', "origin/$branch")).Text.Trim()

    if ($local -eq $remote) {
        Write-Log 'INFO' 'Already in sync - nothing to do.'
        if (Test-Path -LiteralPath $ConflictFile) { Remove-Item -LiteralPath $ConflictFile -Force }
        Write-Log 'INFO' '=== Sync end (no-op) ==='
        exit 0
    }

    # --- 3. merge remote -----------------------------------------------------
    $behind = (Invoke-Git @('rev-list', '--count', "$branch..origin/$branch")).Text.Trim()
    if ($behind -ne '0') {
        Write-Log 'INFO' "Remote is $behind commit(s) ahead - merging."
        $merge = Invoke-Git @('merge', '--no-edit', "origin/$branch")
        if ($merge.Code -ne 0) {
            Write-Log 'ERROR' "MERGE CONFLICT - aborting, working tree left untouched.`n$($merge.Text)"
            Invoke-Git @('merge', '--abort') | Out-Null

            $conflictText = @"
# Vault sync conflict

The scheduled sync on **$env:COMPUTERNAME** could not merge changes from GitHub
because the same file was edited on two devices.

**Nothing was lost.** The merge was aborted and your files are untouched.
Automatic syncing stays blocked until this is resolved.

Detected: $(Get-Date -Format 'yyyy-MM-dd HH:mm')

## To resolve

Open a terminal in ``$VaultPath`` and run:

``````powershell
git merge origin/$branch
# fix the conflicted files, then:
git add -A
git commit
git push origin $branch
``````

Full log: ``.git\vault-sync.log``

Delete this file once resolved - the next successful sync removes it anyway.

## Conflict detail

``````
$($merge.Text)
``````
"@
            Set-Content -LiteralPath $ConflictFile -Value $conflictText -Encoding UTF8
            exit 1
        }
        Write-Log 'INFO' 'Merge OK.'
    }

    # --- 4. push -------------------------------------------------------------
    $ahead = (Invoke-Git @('rev-list', '--count', "origin/$branch..$branch")).Text.Trim()
    if ($ahead -ne '0') {
        $push = Invoke-Git @('push', 'origin', $branch)
        if ($push.Code -ne 0) {
            Write-Log 'ERROR' "git push failed: $($push.Text)"
            exit 1
        }
        Write-Log 'INFO' "Pushed $ahead commit(s) to origin/$branch."
    } else {
        Write-Log 'INFO' 'Nothing to push.'
    }

    if (Test-Path -LiteralPath $ConflictFile) { Remove-Item -LiteralPath $ConflictFile -Force }
    Write-Log 'INFO' '=== Sync end (OK) ==='
    exit 0
}
catch {
    Write-Log 'ERROR' "Unhandled failure: $($_.Exception.Message)"
    exit 1
}
finally {
    if (Test-Path -LiteralPath $LockFile) { Remove-Item -LiteralPath $LockFile -Force -ErrorAction SilentlyContinue }
}
