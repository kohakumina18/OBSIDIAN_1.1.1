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

    GitHub wins conflicts (owner decision 2026-09-29 - a blocked machine stopped
    syncing for days). On a merge conflict the script:
      1. saves this machine's version as branch sync-backup/<HOST>-<yyyyMMdd-HHmmss>
         and pushes that branch to GitHub, so nothing is lost for good;
      2. merges again with GitHub's side taking every conflicting hunk
         (-X theirs) and every edit/delete clash; local edits to other files
         are kept;
      3. if that merge still fails, or leaves a .canvas / .json file that no
         longer parses, resets the vault to GitHub's version outright
         (ignored files such as local credentials are never touched);
      4. pushes, logs a WARN and shows a toast.
    A merge / rebase / cherry-pick left half-finished by an earlier run is aborted
    at the start instead of blocking every later run. A push rejected because
    another device pushed first is retried (fetch, merge, push) up to 3 times.
    Linux counterpart: scripts/sync_vault_git.py - keep both in step.

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
$BackupPrefix = 'sync-backup'
$PushAttempts = 3

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

# True when the text parses as JSON. Windows PowerShell 5.1's ConvertFrom-Json refuses anything over 2 MB (some
# canvases are larger), so use the .NET Framework parser with the limit lifted; PowerShell 7 has no such limit.
function Test-PPJJson {
    param([string]$Text)
    $serializer = $null
    try {
        Add-Type -AssemblyName System.Web.Extensions -ErrorAction Stop
        $serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
        $serializer.MaxJsonLength = [int]::MaxValue
        $serializer.RecursionLimit = 1000
    } catch {
        $serializer = $null                      # PowerShell 7: no System.Web.Extensions - ConvertFrom-Json below
    }
    if ($serializer) {
        try { $null = $serializer.DeserializeObject($Text); return $true } catch { return $false }
    }
    try { $null = $Text | ConvertFrom-Json -ErrorAction Stop; return $true } catch { return $false }
}

# .canvas / .json files changed since $Before that no longer parse (a line-level merge can break them).
function Get-PPJBrokenJson {
    param([string]$Before)
    $names = (Invoke-Git @('diff', '--name-only', '--diff-filter=AM', $Before, 'HEAD', '--', '*.canvas', '*.json')).Text
    $bad = @()
    foreach ($name in ($names -split "`n" | Where-Object { $_.Trim() })) {
        $path = Join-Path $VaultPath $name.Trim()
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { continue }
        try { $text = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8) } catch { $bad += $name; continue }
        if (-not (Test-PPJJson -Text $text)) { $bad += $name }
    }
    return ,$bad
}

# Resolve a failed merge in GitHub's favour, keeping this machine's version on a backup branch. Returns $true when
# the vault is back on a state that includes GitHub's latest.
function Invoke-PPJGitHubWins {
    param([string]$Branch, [string]$MergeOutput)
    $conflicted = @($MergeOutput -split "`n" | Where-Object { $_ -match 'Merge conflict in (.+)$' } |
        ForEach-Object { ($_ -split 'Merge conflict in ', 2)[1].Trim() })
    $backup = '{0}/{1}-{2}' -f $BackupPrefix, $env:COMPUTERNAME, (Get-Date -Format 'yyyyMMdd-HHmmss')
    Invoke-Git @('branch', '-f', $backup, 'HEAD') | Out-Null
    $pushBackup = Invoke-Git @('push', '--quiet', 'origin', "${backup}:refs/heads/$backup")
    $where = if ($pushBackup.Code -eq 0) { 'on GitHub and locally' } else { "locally only (push failed: $($pushBackup.Text))" }
    $what = if ($conflicted.Count) { "$($conflicted.Count) file(s): $($conflicted -join ', ')" } else { "some file(s): $MergeOutput" }
    Write-Log 'WARN' "Merge conflict in $what. This machine's version is saved as branch $backup $where."

    $before = (Invoke-Git @('rev-parse', 'HEAD')).Text.Trim()
    $merge = Invoke-Git @('merge', '--no-edit', '-X', 'theirs', "origin/$Branch")
    $code = $merge.Code
    if ($code -ne 0) {
        # -X theirs settles content conflicts only. For the rest (edited here, deleted on GitHub, or the reverse)
        # take GitHub's side path by path, so local edits to other files still survive.
        $unmerged = (Invoke-Git @('diff', '--name-only', '--diff-filter=U')).Text
        foreach ($p in ($unmerged -split "`n" | Where-Object { $_.Trim() })) {
            $p = $p.Trim()
            if ((Invoke-Git @('checkout', '--theirs', '--', $p)).Code -eq 0) {
                Invoke-Git @('add', '--', $p) | Out-Null
            } else {                                  # no GitHub side: GitHub deleted it
                Invoke-Git @('rm', '-q', '--cached', '--ignore-unmatch', '--', $p) | Out-Null
                $full = Join-Path $VaultPath $p
                if (Test-Path -LiteralPath $full) { Remove-Item -LiteralPath $full -Force -ErrorAction SilentlyContinue }
            }
        }
        $code = (Invoke-Git @('commit', '--no-edit')).Code
    }
    $bad = if ($code -eq 0) { Get-PPJBrokenJson -Before $before } else { @() }
    if ($code -eq 0 -and $bad.Count -eq 0) {
        $how = "GitHub's version kept for the conflicting parts; other local edits kept"
    } else {
        if ($code -ne 0) { Invoke-Git @('merge', '--abort') | Out-Null }
        $reset = Invoke-Git @('reset', '--hard', "origin/$Branch")
        if ($reset.Code -ne 0) {
            Write-Log 'ERROR' "Could not reset to origin/${Branch}: $($reset.Text)"
            return $false
        }
        $reason = if ($bad.Count) { "invalid JSON after merge: $($bad -join ', ')" } else { 'the merge could not complete' }
        $how = "vault reset to GitHub's version ($reason)"
    }
    Write-Log 'WARN' "GitHub wins: $how. Recover anything needed from branch $backup."
    Show-PPJToast -Title "Vault sync on ${env:COMPUTERNAME}: GitHub version kept" -Message "$how. Your version is saved as branch $backup."
    return $true
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

    # A merge / rebase / cherry-pick left half-finished (a killed run, or by hand) would block every later run;
    # abort it and carry on - GitHub-wins below settles whatever conflict caused it.
    $gitDir = (Invoke-Git @('rev-parse', '--git-dir')).Text.Trim()
    if (-not [System.IO.Path]::IsPathRooted($gitDir)) { $gitDir = Join-Path $VaultPath $gitDir }
    foreach ($pair in @(@('MERGE_HEAD', 'merge'), @('REBASE_HEAD', 'rebase'), @('CHERRY_PICK_HEAD', 'cherry-pick'))) {
        $markerPath = Join-Path $gitDir $pair[0]
        if (Test-Path -LiteralPath $markerPath) {
            Write-Log 'WARN' "Unfinished $($pair[0]) left in the repository - aborting it."
            Invoke-Git @($pair[1], '--abort') | Out-Null
            if (Test-Path -LiteralPath $markerPath) {
                Write-Log 'ERROR' "Could not abort the unfinished $($pair[1]) - resolve it by hand."
                exit 1
            }
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

    # --- 2-4. fetch, merge, push - retried when another device pushed in between (push rejected) --------
    for ($attempt = 1; $attempt -le $PushAttempts; $attempt++) {
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

        $behind = (Invoke-Git @('rev-list', '--count', "$branch..origin/$branch")).Text.Trim()
        if ($behind -ne '0') {
            Write-Log 'INFO' "Remote is $behind commit(s) ahead - merging."
            $merge = Invoke-Git @('merge', '--no-edit', "origin/$branch")
            if ($merge.Code -ne 0) {
                Invoke-Git @('merge', '--abort') | Out-Null
                if (-not (Invoke-PPJGitHubWins -Branch $branch -MergeOutput $merge.Text)) {
                    $conflictText = @"
# Vault sync conflict

The scheduled sync on **$env:COMPUTERNAME** could not merge changes from GitHub, and
could not fall back to GitHub's version either (see the log). This machine's
version is on a ``$BackupPrefix/$env:COMPUTERNAME-...`` branch.

Detected: $(Get-Date -Format 'yyyy-MM-dd HH:mm')

Full log: ``.git\vault-sync.log``

## Conflict detail

``````
$($merge.Text)
``````
"@
                    Set-Content -LiteralPath $ConflictFile -Value $conflictText -Encoding UTF8
                    exit 1
                }
            } else {
                Write-Log 'INFO' 'Merge OK.'
            }
        }

        $ahead = (Invoke-Git @('rev-list', '--count', "origin/$branch..$branch")).Text.Trim()
        if ($ahead -eq '0') {
            Write-Log 'INFO' 'Nothing to push.'
            break
        }
        $push = Invoke-Git @('push', 'origin', $branch)
        if ($push.Code -eq 0) {
            Write-Log 'INFO' "Pushed $ahead commit(s) to origin/$branch."
            break
        }
        if ($attempt -lt $PushAttempts -and $push.Text -match 'rejected|fetch first|non-fast-forward') {
            Write-Log 'WARN' "Push rejected - another device pushed first; fetching again (attempt $($attempt + 1))."
            continue
        }
        Write-Log 'ERROR' "git push failed: $($push.Text)"
        exit 1
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
