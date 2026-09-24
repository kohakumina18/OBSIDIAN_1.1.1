#!/usr/bin/env python3
"""Sync this Obsidian vault with its GitHub remote (commit -> fetch -> merge -> push).

Linux port of scripts/Sync-VaultGit.ps1 - same behaviour, same commit message
convention, same conflict marker. Written for unattended runs from the
ppj-vault-sync systemd user timer, but safe to run by hand:

    python3 scripts/sync_vault_git.py

Order is deliberate: local changes are committed BEFORE any merge, so nothing
in the working tree can be lost by an incoming change. Remote changes are
merged, never rebased - several machines share this history.

On a merge conflict the script aborts the merge, leaves the working tree
exactly as it was, drops a SYNC-CONFLICT-README.md marker in the vault root
and exits non-zero. Conflicts are resolved by hand, never automatically.

Log:  <vault>/.git/vault-sync.log   (inside .git, so it is never committed)

Any ERROR-level log line also raises a desktop notification via notify-send
(best effort; silently skipped if there is no graphical session).
"""

from __future__ import annotations

import argparse
import os
import shutil
import socket
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path

VAULT = Path(__file__).resolve().parent.parent
LOG_FILE = VAULT / ".git" / "vault-sync.log"
LOCK_FILE = VAULT / ".git" / "vault-sync.lock"
CONFLICT_FILE = VAULT / "SYNC-CONFLICT-README.md"
HOST = socket.gethostname().upper()

LOG_ROTATE_BYTES = 1024 * 1024
LOCK_STALE_SECONDS = 3600

quiet = False


# Best-effort desktop notification so an unattended failure (fetch offline,
# push rejected, conflict) is actually seen instead of sitting quietly in the
# log. Needs a graphical session; silently does nothing otherwise.
def notify(title: str, message: str) -> None:
    try:
        exe = shutil.which("notify-send")
        if not exe or not (os.environ.get("DISPLAY") or os.environ.get("WAYLAND_DISPLAY")):
            return
        subprocess.run([exe, "--urgency=critical", title, message[:500]], timeout=10, check=False)
    except Exception:
        pass


def log(level: str, message: str) -> None:
    line = f"{datetime.now():%Y-%m-%d %H:%M:%S} [{level}] {message}"
    try:
        with LOG_FILE.open("a", encoding="utf-8") as fh:
            fh.write(line + "\n")
    except OSError:
        pass
    if not quiet:
        print(line, flush=True)
    if level == "ERROR":
        notify(f"Vault sync failed on {HOST}", message)


# Runs git and returns (code, combined output) instead of raising, so one
# failed git call can be logged with its stderr rather than killing the run.
def git(*args: str) -> tuple[int, str]:
    proc = subprocess.run(
        [GIT, "-C", str(VAULT), *args],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        errors="replace",
    )
    return proc.returncode, proc.stdout.strip()


def conflict_readme(branch: str, detail: str) -> str:
    return f"""# Vault sync conflict

The scheduled sync on **{HOST}** could not merge changes from GitHub
because the same file was edited on two devices.

**Nothing was lost.** The merge was aborted and your files are untouched.
Automatic syncing stays blocked until this is resolved.

Detected: {datetime.now():%Y-%m-%d %H:%M}

## To resolve

Open a terminal in `{VAULT}` and run:

```bash
git merge origin/{branch}
# fix the conflicted files, then:
git add -A
git commit
git push origin {branch}
```

Full log: `.git/vault-sync.log`

Delete this file once resolved - the next successful sync removes it anyway.

## Conflict detail

```
{detail}
```
"""


def clear_conflict_marker() -> None:
    try:
        CONFLICT_FILE.unlink(missing_ok=True)
    except OSError:
        pass


def sync() -> int:
    log("INFO", f"=== Sync start on {HOST} ({VAULT}) ===")

    code, branch = git("rev-parse", "--abbrev-ref", "HEAD")
    if code != 0 or not branch or branch == "HEAD":
        log("ERROR", "Detached HEAD or no branch - resolve by hand.")
        return 1

    # A merge/rebase left half-finished by an earlier run must be cleared by a
    # human; continuing would build on a broken state.
    _, git_dir = git("rev-parse", "--git-dir")
    git_dir_path = Path(git_dir)
    if not git_dir_path.is_absolute():
        git_dir_path = VAULT / git_dir_path
    for marker in ("MERGE_HEAD", "REBASE_HEAD", "CHERRY_PICK_HEAD"):
        if (git_dir_path / marker).exists():
            log("ERROR", f"Unfinished {marker} in the repository - resolve it before syncing again.")
            return 1

    # --- 1. commit local work -------------------------------------------------
    _, status = git("status", "--porcelain")
    if status:
        count = len([l for l in status.splitlines() if l.strip()])
        code, out = git("add", "-A")
        if code != 0:
            log("ERROR", f"git add failed: {out}")
            return 1
        msg = f"Vault sync from {HOST} - {datetime.now():%Y-%m-%d %H:%M}"
        code, out = git("commit", "-m", msg)
        if code != 0:
            log("ERROR", f"git commit failed: {out}")
            return 1
        log("INFO", f"Committed {count} local change(s).")
    else:
        log("INFO", "No local changes to commit.")

    # --- 2. fetch ---------------------------------------------------------------
    code, out = git("fetch", "origin", "--quiet")
    if code != 0:
        log("ERROR", f"git fetch failed (offline or auth expired): {out}")
        return 1

    _, local = git("rev-parse", branch)
    _, remote = git("rev-parse", f"origin/{branch}")

    if local == remote:
        log("INFO", "Already in sync - nothing to do.")
        clear_conflict_marker()
        log("INFO", "=== Sync end (no-op) ===")
        return 0

    # --- 3. merge remote --------------------------------------------------------
    _, behind = git("rev-list", "--count", f"{branch}..origin/{branch}")
    if behind != "0":
        log("INFO", f"Remote is {behind} commit(s) ahead - merging.")
        code, out = git("merge", "--no-edit", f"origin/{branch}")
        if code != 0:
            log("ERROR", f"MERGE CONFLICT - aborting, working tree left untouched.\n{out}")
            git("merge", "--abort")
            CONFLICT_FILE.write_text(conflict_readme(branch, out), encoding="utf-8")
            return 1
        log("INFO", "Merge OK.")

    # --- 4. push ----------------------------------------------------------------
    _, ahead = git("rev-list", "--count", f"origin/{branch}..{branch}")
    if ahead != "0":
        code, out = git("push", "origin", branch)
        if code != 0:
            log("ERROR", f"git push failed: {out}")
            return 1
        log("INFO", f"Pushed {ahead} commit(s) to origin/{branch}.")
    else:
        log("INFO", "Nothing to push.")

    clear_conflict_marker()
    log("INFO", "=== Sync end (OK) ===")
    return 0


def main() -> int:
    global quiet, GIT
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--quiet", action="store_true", help="suppress console output")
    quiet = parser.parse_args().quiet

    if not (VAULT / ".git").is_dir():
        # No .git/ means nowhere to log to either - say so on stderr.
        print(f"ERROR: Not a git repository: {VAULT}", file=sys.stderr)
        notify(f"Vault sync failed on {HOST}", f"Not a git repository: {VAULT}")
        return 1

    # --- log rotation -------------------------------------------------------------
    try:
        if LOG_FILE.exists() and LOG_FILE.stat().st_size > LOG_ROTATE_BYTES:
            LOG_FILE.replace(LOG_FILE.with_name(LOG_FILE.name + ".old"))
    except OSError:
        pass

    # --- single instance ----------------------------------------------------------
    # A stale lock (previous run killed mid-way) is cleared after 1 hour.
    if LOCK_FILE.exists():
        age = time.time() - LOCK_FILE.stat().st_mtime
        if age < LOCK_STALE_SECONDS:
            log("WARN", "Another sync is already running - skipping this run.")
            return 0
        log("WARN", f"Clearing stale lock ({age / 60:.0f} min old).")
        LOCK_FILE.unlink(missing_ok=True)

    GIT = shutil.which("git")
    if not GIT:
        log("ERROR", "git not found - install it (sudo apt install git) or add it to PATH.")
        return 1

    LOCK_FILE.touch()
    try:
        return sync()
    except Exception as exc:  # noqa: BLE001 - last-resort log, mirrors the .ps1 catch
        log("ERROR", f"Unhandled failure: {exc}")
        return 1
    finally:
        LOCK_FILE.unlink(missing_ok=True)


GIT = ""

if __name__ == "__main__":
    sys.exit(main())
