<#
.SYNOPSIS
    Syncs this Obsidian vault with its GitHub remote (commit -> fetch -> merge -> push).

.DESCRIPTION
    Written for unattended runs from Windows Task Scheduler, but safe to run by hand.

    Order is deliberate: local changes are committed BEFORE any merge, so nothing
    in the working tree can be lost by an incoming change.

    On a merge conflict the script aborts the merge, leaves the working tree
    exactly as it was, drops a SYNC-CONFLICT-README.md marker in the vault root
    and exits non-zero. Conflicts are resolved by hand, never automatically.

    Log:  <vault>\.git\vault-sync.log   (inside .git, so it is never committed)

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

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

if (-not $VaultPath) {
    $VaultPath = Split-Path -Parent $PSScriptRoot
}

$LogFile      = Join-Path $VaultPath '.git\vault-sync.log'
$LockFile     = Join-Path $VaultPath '.git\vault-sync.lock'
$ConflictFile = Join-Path $VaultPath 'SYNC-CONFLICT-README.md'

function Write-Log {
    param([string]$Level, [string]$Message)
    $line = '{0} [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
    try { Add-Content -LiteralPath $LogFile -Value $line -Encoding UTF8 } catch { }
    if (-not $Quiet) { Write-Host $line }
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
function Invoke-Git {
    param([string[]]$Arguments)
    $out = & $Git -C $VaultPath @Arguments 2>&1
    $code = $LASTEXITCODE
    $text = ($out | ForEach-Object { $_.ToString() }) -join "`n"
    return [pscustomobject]@{ Code = $code; Text = $text }
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
        $count = ($status -split "`n" | Where-Object { $_.Trim() }).Count
        $add = Invoke-Git @('add', '-A')
        if ($add.Code -ne 0) {
            Write-Log 'ERROR' "git add failed: $($add.Text)"
            exit 1
        }
        $msg = 'Vault sync from {0} - {1}' -f $env:COMPUTERNAME, (Get-Date -Format 'yyyy-MM-dd HH:mm')
        $commit = Invoke-Git @('commit', '-m', $msg)
        if ($commit.Code -ne 0) {
            Write-Log 'ERROR' "git commit failed: $($commit.Text)"
            exit 1
        }
        Write-Log 'INFO' "Committed $count local change(s)."
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
