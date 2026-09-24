---
type: sync_device_registry
last_verified: 2026-09-24
---

# PPJ Sync Device Registry

Every machine that syncs this vault to `https://github.com/kohakumina18/OBSIDIAN_1.1.1`,
so a new session can read this instead of reconstructing the topology from
`git log`. Update this file (and push) whenever a device is added, moved, or
retired - it is part of the normal sync commit, not a separate step.

## Standard

- **Sync engine (Windows):** `scripts/Sync-VaultGit.ps1`, invoked via
  `scripts/Invoke-PPJVaultSyncLauncher.ps1` (finds the vault across drive
  letters, toasts if it can't) so the actually-scheduled entry point can live
  off the vault's own drive. One shared script - do not fork a per-machine
  copy; fix it in place and let the next sync propagate the fix.
- **Sync engine (Linux):** `scripts/sync_vault_git.py` - a behaviour-exact
  port of `Sync-VaultGit.ps1` (same order, lock, log path, conflict marker and
  `Vault sync from <HOST> - <date>` commit message; `notify-send` instead of a
  toast). Change the two scripts together so the fleet keeps one behaviour.
- **Registration:** `scripts/Register-PPJVaultSyncTask.ps1` (Windows Task
  Scheduler, per-user, no admin needed). Re-run after pulling changes to the
  launcher, or to change the schedule. Linux: `scripts/install_ppj_vault_sync_timer.sh`
  (per-user systemd timer from `ppj-vault-sync.{service,timer}.template`;
  installs, enables and starts it).
- **Cadence:** every 8 hours while logged on (decided 2026-09-23, superseding
  the original once-daily-at-midnight setup - multiple devices are now
  actively edited on the same days). Stagger each device's start time by
  10-15 min from the others to avoid simultaneous pushes.
- **Conflict handling:** never automatic. A real conflict aborts the merge,
  leaves the working tree untouched, and drops `SYNC-CONFLICT-README.md` in
  the vault root (gitignored, local only) - resolve by hand, then it
  self-clears on the next successful sync.
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
| HAKU | Windows 11 (ideapad3 gaming laptop) | USB drive, currently `E:\DATA\USB-VAULT\BA_Obsidian_Vault_FULL_LINUX_20260918\USB_BA_Obsidian_Vault` (letter may change - do not hard-code) | `Sync-VaultGit.ps1` via launcher + Task Scheduler | Every 8h | Confirmed off (no local process) - 2026-09-23 | Vault is portable/USB; drive-letter resolution is handled by the launcher. |
| YOGHAAKU | Windows (unknown edition) | Unknown - not yet recorded here | `Sync-VaultGit.ps1` (same shared script) | Unknown - recommend offsetting from HAKU, e.g. 00:15/08:15/16:15 | **Needs verification** | Actively pushing portfolio/Canvas changes as of 2026-09-23; added the Windows Canvas-watcher launcher. Fill in this row from that machine. |
| Yoga ThinkPad | Windows (unknown edition) | `D:\PPJ\syncing` | Unknown - not yet registered | Unknown | **Needs verification** | Path name suggests this may still be (or have been) an active Syncthing folder - check before assuming it only syncs via git. |
| NVAKHOA-THINKPAD-E14-GEN-7 (hostname `nvakhoa-ThinkPad-E14-Gen-7`) | Ubuntu | `/home/nvakhoa/Documents/BA_Obsidian_Vault` - ordinary folder on the internal disk (ext4, `/dev/nvme0n1p2`); not a symlink, not the USB drive, an independent clone | `sync_vault_git.py` via systemd user timer `ppj-vault-sync.timer` (joined 2026-09-24) | Every 8h at 00:20 / 08:20 / 16:20 (`Persistent=true` - catches up after downtime) | Syncthing **was active** (share `obsidian-vault` = `~/Documents`, send-receive with device `obsidian-storage`); stopped, config deleted and package purged 2026-09-24. LiveSync plugin not installed in this vault. The LiveSync CouchDB server (`~/services/obsidian-livesync`, Docker `obsidian-couchdb` + nightly backup timer) still runs here but does not touch this folder. | Also runs `ppj-executive-canvas-watcher.service` (local Canvas-state only). First sync took origin/main for everything except 2 locally newer canvases - the local copy was the stale Aug 24 portfolio state. A local credentials file is excluded via `.git/info/exclude` (never pushed). |

## Legacy / reference-only (not part of the sync topology)

| Location | Status |
| --- | --- |
| `C:\Users\nvakt\Documents\obsidian\BA_Obsidian_Vault` | Reference-only per `AGENTS.md`; do not write project updates, registry changes, tasks, reports, or Canvas state here automatically. |
| `99_Attachments/Legacy_Syncthing_Import/` | Historical Syncthing/LiveSync snapshot, moved out of the working root 2026-09-23 to stop inflating every clone. See its own `README.md`. |

## Open items

- Confirm Syncthing/LiveSync status on YOGHAAKU and the ThinkPad; if either is still active, retire it before trusting git sync there.
- Fill in YOGHAAKU's and the ThinkPad's vault path and schedule rows from those machines.
- Device `obsidian-storage` (the former Syncthing peer of the Ubuntu machine) still has its own copy of `~/Documents`; retire that share there, and decide whether the LiveSync CouchDB server on the Ubuntu machine is still used by any device.
- Apply the every-8-hours cadence and staggered start times to YOGHAAKU and the ThinkPad's own Task Scheduler entries.
