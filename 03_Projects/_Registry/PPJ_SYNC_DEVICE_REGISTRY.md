---
type: sync_device_registry
last_verified: 2026-09-29
device_count: 3
---

# PPJ Sync Device Registry

Every machine that syncs this vault to `https://github.com/kohakumina18/OBSIDIAN_1.1.1`,
so a new session can read this instead of reconstructing the topology from
`git log`. Update this file (and push) whenever a device is added, moved, or
retired - it is part of the normal sync commit, not a separate step.

## Standard

- **Sync engine (Windows):** `scripts/Sync-VaultGit.ps1`, invoked via
  `scripts/Invoke-PPJVaultSyncLauncher.ps1` so the actually-scheduled entry
  point can live off the vault's own drive - see "Finding the vault" below for
  how it locates the vault. One shared script across every Windows device - do
  not fork a per-machine copy; fix it in place and let the next sync propagate
  the fix.
- **Sync engine (Linux):** `scripts/sync_vault_git.py` - a behaviour-exact
  port of `Sync-VaultGit.ps1` (same order, lock, log path, conflict marker and
  commit message format; `notify-send` instead of a toast). Change the two
  scripts together so the fleet keeps one behaviour.
- **Commit messages are self-tracing** (2026-09-24): subject stays `Vault sync
  from <HOST> - <date>`, but the body lists every changed file (git's own
  `--stat`, capped at 30 lines) plus a one-line added/modified/deleted count
  and total data volume touched, e.g. `2 file(s) changed (2 modified) | ~25.9
  KB touched`. `git log` alone now answers "what changed and how much" without
  a separate `git show --stat`.
- **Registration:** `scripts/Register-PPJVaultSyncTask.ps1 -StartTime "HH:mm"`
  (Windows Task Scheduler, per-user, no admin needed; `-StartTime` picks this
  device's offset - see Devices below before choosing one). Re-run after
  pulling changes to the launcher, or to change the schedule. Linux:
  `scripts/install_ppj_vault_sync_timer.sh` (per-user systemd timer from
  `ppj-vault-sync.{service,timer}.template`; installs, enables and starts it).
- **Finding the vault:** `Invoke-PPJVaultSyncLauncher.ps1` resolves the vault
  path in order: `$env:PPJ_VAULT_PATH` override, then `$KnownHostPaths[$env:COMPUTERNAME]`
  (fixed-drive machines - add a line here for a new one), then a USB drive-letter
  scan (USB machines only, e.g. HAKU). Add a fixed-drive machine to the table
  instead of forking the script.
- **Cadence:** every 3 hours while logged on (decided 2026-09-24, superseding
  the 8h schedule from 2026-09-23, which itself superseded the original
  once-daily-at-midnight setup - each step narrowed the window in which two
  devices can edit the same file before either learns about the other's
  change). `Register-PPJVaultSyncTask.ps1` defaults to `-IntervalHours 3`;
  Linux's `ppj-vault-sync.timer.template` is `OnCalendar=*-*-* 00/3:20:00`.
  Stagger each device's start time by 10-15 min from the others on the shared
  grid (00, 03, 06, ... 21) to avoid simultaneous pushes - see Devices below
  for the current offsets. **Plus a run 2 minutes after logon / boot**
  (decided 2026-09-29): a machine that was off compares with GitHub and
  updates as soon as it is switched on. Linux: `OnStartupSec=2min` in the
  timer; Windows: an `-AtLogOn` trigger (2 min delay) added by
  `Register-PPJVaultSyncTask.ps1` - re-run it once on each Windows machine.
- **Conflict handling: GitHub wins** (decided 2026-09-29, replacing "never
  automatic" - one unresolved conflict had stopped a machine from syncing for
  days). Both engines (`Sync-VaultGit.ps1`, `sync_vault_git.py`) now:
  save the machine's version as branch `sync-backup/<HOST>-<yyyymmdd-HHmmss>`
  and push it to GitHub; re-merge with GitHub's side winning every conflicting
  hunk and every edit/delete clash (local edits to other files survive); if
  that fails or leaves a `.canvas` / `.json` that no longer parses, reset the
  vault to `origin/main` (gitignored files such as local credentials are never
  touched); push; WARN in the log plus a toast / desktop notification. A
  half-finished merge / rebase / cherry-pick is aborted at the start instead of
  blocking; a push rejected because another device pushed first is retried up
  to 3 times. `SYNC-CONFLICT-README.md` now appears only if even the reset
  fails. Recover lost work from the backup branch
  (`git log sync-backup/<HOST>-...`, `git checkout <branch> -- <file>`); delete
  old backup branches from GitHub once they are no longer needed.
- **Do not run two sync systems on the same folder.** This vault previously
  used Obsidian Self-hosted LiveSync, then Syncthing, before git (see
  `99_Attachments/Legacy_Syncthing_Import/README.md`). If Syncthing or
  LiveSync is still active on any device pointed at this vault, it will fight
  git for the same files. `Invoke-PPJVaultSyncLauncher.ps1` warns (toast) if
  it detects a local `syncthing`/`syncthingtray` process, but cannot see
  other machines - status per device below must be confirmed by hand.
  **Check the parent folders too:** on the Ubuntu machine the Syncthing share
  was `~/Documents` (the vault's parent), so a `.stfolder` search inside the
  vault found nothing while the vault was in fact being synced.
- **Line endings:** GitHub stores LF. A copy that came from Windows via
  Syncthing/USB may be CRLF on disk; set `git config core.autocrlf input` on
  Linux (`true` on Windows) before the first commit, or every file shows as
  modified.
- **Secrets:** a vault copy that never went through git may hold credential
  files the shared `.gitignore` does not know about. Exclude them per machine
  in `.git/info/exclude` - never commit them.

## Devices

| Host | OS | Vault path | Sync engine | Schedule | Syncthing/LiveSync status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| HAKU | Windows 11 (ideapad3 gaming laptop) | USB drive, currently `E:\DATA\USB-VAULT\BA_Obsidian_Vault_FULL_LINUX_20260918\USB_BA_Obsidian_Vault` (letter may change - do not hard-code) | `Sync-VaultGit.ps1` via launcher + Task Scheduler | **Stale: still 8h at 00:00/08:00/16:00.** Target: every 3h at 00:00 / 03:00 / ... / 21:00 plus 2 min after logon - run the one-time recovery below. | Confirmed off (no local process) - 2026-09-23 | Vault is portable/USB; drive-letter resolution is handled by the launcher. |
| YOGHAAKU (hostname `YOGHAAKU`, Yoga ThinkPad laptop) | Windows 11 Pro 10.0.26200 | `D:\PPJ\syncing` - fixed internal drive, not USB/removable | `Sync-VaultGit.ps1` via `Invoke-PPJVaultSyncLauncher.ps1` (registered in `$KnownHostPaths`) + Task Scheduler (`Register-PPJVaultSyncTask.ps1 -StartTime "00:15"`) | Every 3h at 00:15 / 03:15 / ... / 21:15 (moved off 8h 2026-09-24). **Needs the one-time recovery below** to pick up GitHub-wins and the logon trigger. | Confirmed off - 2026-09-24: no `syncthing`/`syncthingtray` process, no install under `%LOCALAPPDATA%\Programs`, no autostart entry in `HKCU\...\Run`, no Syncthing scheduled task. `.stfolder` already archived under `99_Attachments/Legacy_Syncthing_Import/` (not at the vault root). | Also runs `PPJ Executive Canvas Watcher` (Task Scheduler port of the systemd Canvas watcher, registered by `scripts/Register-PPJCanvasWatcherTask.ps1`: `scripts/Start-PPJCanvasWatcher.ps1` -> `watch_ppj_executive_canvas.py --apply`, log `.git/canvas-watcher.log`). Self-healing via a 5-minute supervisor trigger, not just at-logon - Task Scheduler can't detect an externally-killed long-running process the way systemd's `Restart=always` can, so a repeating tick re-runs the idempotent launcher instead; verified 2026-09-24 by killing the watcher and confirming a re-run of the task revived it. Added card-text-drives-vault to `sync_ppj_executive_canvas_state.py` (Domain/Lifecycle/Status/Progress/Priority/Gate/Outcome editable from a card; canonical-code rename via `--approve-rename`, `PPJ_CARD_SIG` fingerprint tells a hand edit from a stale card). This row previously appeared twice, as "YOGHAAKU" and "Yoga ThinkPad" - same physical device, same vault path; merged 2026-09-24. |
| NVAKHOA-THINKPAD-E14-GEN-7 (hostname `nvakhoa-ThinkPad-E14-Gen-7`) | Ubuntu | `/home/nvakhoa/Documents/BA_Obsidian_Vault` - ordinary folder on the internal disk (ext4, `/dev/nvme0n1p2`); not a symlink, not the USB drive, an independent clone | `sync_vault_git.py` via systemd user timer `ppj-vault-sync.timer` (joined 2026-09-24) | Every 3h at 00:20 / 03:20 / 06:20 / ... / 21:20 and 2 min after login (`OnStartupSec=2min`, installed 2026-09-29). `Persistent=true` - catches up after downtime. | Syncthing **was active** (share `obsidian-vault` = `~/Documents`, send-receive with device `obsidian-storage`); stopped, config deleted and package purged 2026-09-24. LiveSync plugin not installed in this vault. The LiveSync CouchDB server (`~/services/obsidian-livesync`, Docker `obsidian-couchdb` + nightly backup timer) still runs here but does not touch this folder. | Also runs `ppj-executive-canvas-watcher.service` (local Canvas-state only). First sync took origin/main for everything except 2 locally newer canvases - the local copy was the stale Aug 24 portfolio state. A local credentials file is excluded via `.git/info/exclude` (never pushed). |

## Legacy / reference-only (not part of the sync topology)

| Location | Status |
| --- | --- |
| `C:\Users\nvakt\Documents\obsidian\BA_Obsidian_Vault` | Reference-only per `AGENTS.md`; do not write project updates, registry changes, tasks, reports, or Canvas state here automatically. |
| `99_Attachments/Legacy_Syncthing_Import/` | Historical Syncthing/LiveSync snapshot, moved out of the working root 2026-09-23 to stop inflating every clone. See its own `README.md`. |

## Open items

- Device `obsidian-storage` (the former Syncthing peer of the Ubuntu machine) still has its own copy of `~/Documents`; retire that share there, and decide whether the LiveSync CouchDB server on the Ubuntu machine is still used by any device.
- **NVAKHOA-THINKPAD-E14-GEN-7 syncs over HTTPS, not SSH** (since 2026-09-30). The "Sinnika Office" Wi-Fi silently drops the SSH protocol to GitHub (on port 22 and 443 alike - GitHub's banner arrives, but anything after the client's own `SSH-2.0-...` line is dropped), while HTTPS passes. Remote is `https://github.com/kohakumina18/OBSIDIAN_1.1.1.git`; credentials via GitHub CLI (`~/.local/bin/gh`, logged in as kohakumina18, `gh auth setup-git`). If a Windows machine is used on that network, it needs an HTTPS remote too (YOGHAAKU already has one).
- **One-time recovery on each Windows machine (YOGHAAKU, HAKU)** - a machine stuck on an old conflict cannot pull the new GitHub-wins script by itself. In PowerShell, from the vault root (YOGHAAKU `D:\PPJ\syncing`; HAKU the USB vault):

  ```powershell
  git merge --abort 2>$null
  git add -A; git commit -q -m "Pre-recovery snapshot from $env:COMPUTERNAME"
  $b = "sync-backup/$env:COMPUTERNAME-$(Get-Date -Format yyyyMMdd-HHmmss)"
  git branch $b; git push origin "${b}:refs/heads/$b"
  git fetch origin; git reset --hard origin/main
  powershell -ExecutionPolicy Bypass -File .\scripts\Register-PPJVaultSyncTask.ps1 -StartTime "00:15"   # HAKU: "00:00"
  ```

  This keeps the machine's version on a backup branch, takes GitHub's version, and re-registers the task (3h grid plus logon trigger; also redeploys the launcher copy in `%LOCALAPPDATA%\PPJVaultSync\`).
- **Ubuntu: restart the Canvas watcher after pulling 2026-09-24** - `systemctl --user restart ppj-executive-canvas-watcher.service`. The new `watch_ppj_executive_canvas.py` also regenerates the ecosystem Canvas whenever the portfolio snapshot changes (see `AGENTS.md`, "Ecosystem Canvas auto-sync"); a running service keeps the old code until restarted. YOGHAAKU already runs it. Both devices produce byte-identical output, so they cannot conflict.
