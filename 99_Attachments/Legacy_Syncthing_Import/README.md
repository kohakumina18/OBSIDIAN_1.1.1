# Legacy Syncthing Import

Carried over from a Syncthing folder that synced this vault before git became
the source of truth (2026-09-23). It replaced two earlier sync systems in
sequence: Obsidian Self-hosted LiveSync first (see `OBSIDIAN-BACKUP/*-before-livesync`),
then Syncthing (`.stfolder` marker), now git.

Contents:

- `BA_Obsidian_Vault/` — a full nested vault copy from that Syncthing folder.
- `OBSIDIAN-BACKUP/` — a pre-LiveSync backup snapshot.
- `Obsidian/` — images and ESL material.
- `ESL/` — 7 `.docx` files.
- `.stfolder/` — the Syncthing folder marker itself (kept only as evidence
  the folder was actively Syncthing-managed; delete freely once confirmed
  Syncthing is fully retired on every device — see `PPJ_SYNC_DEVICE_REGISTRY`).

Reference-only. Nothing here is written to automatically, and none of it
feeds the portfolio scripts, the Canvas boards, or `PPJ_PORTFOLIO_CURRENT_SNAPSHOT`.
It was moved out of the vault root on 2026-09-23 (via `git mv`, history
preserved) purely so it stops inflating the working tree every clone/sync -
see `PPJ_SYNC_DEVICE_REGISTRY.md` for the reasoning.
