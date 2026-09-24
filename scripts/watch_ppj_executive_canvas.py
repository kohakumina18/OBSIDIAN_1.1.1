#!/usr/bin/env python3
"""Watch the PPJ Executive Canvas and invoke the guarded state synchronizer.

The watcher defaults to dry-run. It is prepared for manual use but is never
started or enabled by the upgrade process.

In --apply mode it also keeps the generated ecosystem Canvas
(PPJ_Digital_Application_AI_Automation_Ecosystem.canvas) in step with the
portfolio snapshot: whenever the snapshot changes - because this watcher just
applied a Canvas edit, because a project was registered or renamed by another
script, or because a git pull brought a newer snapshot - build_ppj_ecosystem_canvas.py
--write runs after the same debounce. The builder writes only when the bytes
change and never on a failed structural check, so every device converging on the
same snapshot produces the identical file and git sees no conflict.
Pass --no-ecosystem to turn this off.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import time
from pathlib import Path

import ppj_canvas_state_lib as lib


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Preview every saved change (default)")
    mode.add_argument("--apply", action="store_true", help="Apply only after an error-free dry-run")
    parser.add_argument("--poll", type=float, default=2.0, help="Polling interval in seconds")
    parser.add_argument("--debounce", type=float, default=2.0, help="Wait for writes to settle")
    parser.add_argument("--once", action="store_true", help="Process current Canvas once and exit")
    parser.add_argument("--no-ecosystem", action="store_true",
                        help="Do not regenerate the ecosystem Canvas when the snapshot changes (--apply only)")
    parser.add_argument("--verbose", action="store_true")
    return parser.parse_args()


ECOSYSTEM_BUILDER = Path(__file__).with_name("build_ppj_ecosystem_canvas.py")


def sync_ecosystem() -> int:
    """Regenerate the ecosystem Canvas. Prints one summary line; a blocked run leaves the old file in place."""
    if not ECOSYSTEM_BUILDER.exists():
        return 0
    result = subprocess.run([sys.executable, str(ECOSYSTEM_BUILDER), "--write", "--quiet"], cwd=lib.ROOT, check=False)
    return result.returncode


def snapshot_mtime() -> int | None:
    try:
        return lib.SNAPSHOT_JSON.stat().st_mtime_ns
    except FileNotFoundError:
        return None


def run_sync(apply: bool, verbose: bool) -> int:
    script = Path(__file__).with_name("sync_ppj_executive_canvas_state.py")
    preview = [sys.executable, str(script), "--from-canvas", "--dry-run"]
    if verbose:
        preview.append("--verbose")
    result = subprocess.run(preview, cwd=lib.ROOT, check=False)
    if result.returncode or not apply:
        return result.returncode
    command = [sys.executable, str(script), "--from-canvas", "--apply"]
    if verbose:
        command.append("--verbose")
    return subprocess.run(command, cwd=lib.ROOT, check=False).returncode


def main() -> int:
    args = parse_args()
    if args.poll <= 0 or args.debounce < 0:
        print("--poll must be > 0 and --debounce must be >= 0", file=sys.stderr)
        return 2
    ecosystem = args.apply and not args.no_ecosystem
    if args.once:
        code = run_sync(args.apply, args.verbose)
        if ecosystem:
            sync_ecosystem()
        return code
    print(f"Watching {lib.CANVAS_PATH}")
    print(f"Mode: {'APPLY after clean dry-run' if args.apply else 'DRY RUN'}")
    if ecosystem:
        print(f"Also keeping the ecosystem Canvas in step with {lib.SNAPSHOT_JSON.name}")
        sync_ecosystem()          # catch up on anything that changed while the watcher was not running
    last_seen = lib.CANVAS_PATH.stat().st_mtime_ns
    snapshot_seen = snapshot_mtime()
    pending_since: float | None = None
    snapshot_pending_since: float | None = None
    try:
        while True:
            time.sleep(args.poll)
            if ecosystem:
                current_snapshot = snapshot_mtime()
                if current_snapshot != snapshot_seen:
                    snapshot_seen = current_snapshot
                    snapshot_pending_since = time.monotonic()
                if snapshot_pending_since is not None and time.monotonic() - snapshot_pending_since >= args.debounce:
                    sync_ecosystem()
                    snapshot_pending_since = None
            try:
                current = lib.CANVAS_PATH.stat().st_mtime_ns
            except FileNotFoundError:
                # Obsidian may briefly replace the file during an atomic save.
                continue
            if current != last_seen:
                last_seen = current
                pending_since = time.monotonic()
                if args.verbose:
                    print("Canvas write detected; waiting for debounce")
            if pending_since is not None and time.monotonic() - pending_since >= args.debounce:
                run_sync(args.apply, args.verbose)
                try:
                    # Ignore the synchronizer's own card-text refresh write.
                    last_seen = lib.CANVAS_PATH.stat().st_mtime_ns
                except FileNotFoundError:
                    pass
                pending_since = None
    except KeyboardInterrupt:
        print("Watcher stopped by user")
        return 0


if __name__ == "__main__":
    sys.exit(main())
