#!/usr/bin/env python3
"""Watch the PPJ Executive Canvas and invoke the guarded state synchronizer.

The watcher defaults to dry-run. It is prepared for manual use but is never
started or enabled by the upgrade process.
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
    parser.add_argument("--verbose", action="store_true")
    return parser.parse_args()


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
    if args.once:
        return run_sync(args.apply, args.verbose)
    print(f"Watching {lib.CANVAS_PATH}")
    print(f"Mode: {'APPLY after clean dry-run' if args.apply else 'DRY RUN'}")
    last_seen = lib.CANVAS_PATH.stat().st_mtime_ns
    pending_since: float | None = None
    try:
        while True:
            time.sleep(args.poll)
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
