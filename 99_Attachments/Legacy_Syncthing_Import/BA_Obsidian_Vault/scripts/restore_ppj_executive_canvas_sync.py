#!/usr/bin/env python3
"""List or restore PPJ Executive Canvas state-sync backups. Defaults dry-run."""

from __future__ import annotations

import argparse
import datetime as dt
import shutil
import sys
from pathlib import Path

import ppj_canvas_state_lib as lib


def backups() -> dict[str, list[Path]]:
    found: dict[str, list[Path]] = {}
    if not lib.STATE_BACKUP_ROOT.exists():
        return found
    for folder in lib.STATE_BACKUP_ROOT.iterdir():
        if not folder.is_dir() or not (folder / ".ppj-canvas-state-sync-backup").exists():
            continue
        found.setdefault(folder.name, []).append(folder)
        canvas = lib.CANVAS_BACKUP_ROOT / folder.name
        if canvas.is_dir():
            found[folder.name].append(canvas)
    return found


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--list", action="store_true", help="List available backup stamps")
    choice = parser.add_mutually_exclusive_group()
    choice.add_argument("--backup", help="Exact backup stamp")
    choice.add_argument("--latest", action="store_true", help="Select latest backup stamp")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Preview only (default)")
    mode.add_argument("--apply", action="store_true", help="Restore selected files")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    available = backups()
    if args.list or (not args.backup and not args.latest):
        print("Available PPJ Canvas sync backups:")
        for stamp in sorted(available, reverse=True):
            count = sum(1 for folder in available[stamp] for x in folder.rglob("*") if x.is_file() and x.name != ".ppj-canvas-state-sync-backup")
            print(f"  {stamp}: {count} files")
        return 0
    if not available:
        print("No sync backups found", file=sys.stderr)
        return 2
    stamp = max(available) if args.latest else args.backup
    if stamp not in available:
        print(f"Backup not found: {stamp}", file=sys.stderr)
        return 2
    selected: dict[Path, Path] = {}
    for folder in available[stamp]:
        for source in folder.rglob("*"):
            if source.is_file() and source.name != ".ppj-canvas-state-sync-backup":
                selected[lib.ROOT / source.relative_to(folder)] = source
    print(f"Selected backup: {stamp}")
    print(f"Mode: {'APPLY' if args.apply else 'DRY RUN'}")
    print(f"Files to restore: {len(selected)}")
    for target in sorted(selected):
        print(f"  {target.relative_to(lib.ROOT)}")
    if not args.apply:
        return 0
    safety_stamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    safety = lib.AUDIT_ROOT / "PPJ_EXECUTIVE_CANVAS_RESTORE_SAFETY_BACKUP" / safety_stamp
    for target, source in selected.items():
        if target.exists():
            copy = safety / target.relative_to(lib.ROOT)
            copy.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(target, copy)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
    print(f"Restored files: {len(selected)}")
    print(f"Pre-restore safety backup: {safety.relative_to(lib.ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
