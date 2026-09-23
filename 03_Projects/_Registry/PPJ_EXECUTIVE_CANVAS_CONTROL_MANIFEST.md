---
type: executive_canvas_control_manifest
canvas: 03_Projects/Canvas/PPJ_Executive_Board_v2.canvas
stage_config: 03_Projects/_Registry/PPJ_EXECUTIVE_CANVAS_STAGE_CONFIG.json
version: "2.0"
last_verified: 2026-09-19
---

# PPJ Executive Canvas Control Manifest

## Control Architecture

```text
Executive Canvas = Operational Control Surface
Registry / Current Snapshot JSON = Persisted Source of Truth
Project Memory = Fast Agent Context
Root Project Note = Stable Project Knowledge
Project Workspace = Detailed Working Documentation
Local Project Board = Task-Level Execution
```

New Codex sessions read `AGENTS.md`, the current snapshot and Registry. They do not infer persisted state directly from Canvas coordinates.

## Persistent Delivery Streams and Stages

| Order | Delivery Stage | Internal Group ID | External Group ID | Safe Default Lifecycle |
| ---: | --- | --- | --- | --- |
| 1 | BACKLOG | `internal-lane-0` | `external-lane-0` | Backlog |
| 2 | KICK-OFF | `internal-lane-1` | `external-lane-1` | Kick-Off |
| 3 | ANALYSIS | `internal-lane-2` | `external-lane-2` | Analysis |
| 4 | DESIGN | `internal-lane-3` | `external-lane-3` | Design |
| 5 | DEVELOPMENT | `internal-lane-4` | `external-lane-4` | Development |
| 6 | UAT / PRE-GO-LIVE | `internal-lane-5` | `external-lane-5` | UAT / Pre-Go-Live |
| 7 | GO-LIVE / PRODUCTION / SUPPORT | `internal-lane-6` | `external-lane-6` | Production / Support |
| 8 | CLOSED | `internal-lane-7` | `external-lane-7` | Closed |

All sixteen stream-stage groups remain visible even when empty. `delivery_stream` is either `INTERNAL DEVELOPMENT` or `EXTERNAL DEVELOPMENT`. `ON HOLD`, `BLOCKED`, `WAITING` and `PENDING DECISION` are Status values, not delivery stages. Candidate initiatives remain in side panels until registration.

## Card Identity and Stage Resolution

Registered text cards contain an immutable marker:

```text
<!-- PPJ_PROJECT_CARD:CANONICAL_CODE -->
```

The resolver calculates the card center and compares it with all sixteen stream-stage bounding boxes. Exactly one containing group is required. That group resolves both `delivery_stream` and `delivery_stage`. Zero groups means Unassigned; more than one means Ambiguous. Neither condition is applied.

## Drag Behavior

```text
User drag -> Canvas save -> resolver -> delivery_stream + delivery_stage delta -> dry-run validation
-> changed-file backup -> Registry/Snapshot -> Memory -> Root Note -> Project Home
-> local board summary -> Command Center -> dependent portfolio views -> Ledger
```

A horizontal drag changes `delivery_stage`; a vertical drag between streams changes `delivery_stream`. Moving to External sets `status: External Collaboration`; moving back derives a safe internal status. A drag may update `lifecycle`, `stage_entered_date` and `last_verified` through safe mapping. It never changes domain, priority, progress, owner or current gate automatically.

Current external set: Stratova, QSee.AI, NUNOX, UIT, COWASH and Primo1D. PUR.H&M.Label-O remains Internal Development with On Hold status.

Compatible detailed lifecycle is preserved. Forward skips and backward rework are allowed and logged. Reopening a CLOSED project requires selecting the project with `--project PROJECT_CODE` and adding `--approve-reopen`, or using `--force`.

## Commands

Canvas to vault dry-run:

```bash
python3 scripts/sync_ppj_executive_canvas_state.py --dry-run --from-canvas --all
```

Canvas to vault apply:

```bash
python3 scripts/sync_ppj_executive_canvas_state.py --apply --from-canvas --all
```

Vault to Canvas:

```bash
python3 scripts/sync_ppj_executive_canvas_state.py --apply --to-canvas --all
```

Manual watcher:

```bash
python3 scripts/watch_ppj_executive_canvas.py --apply
```

## Watcher and Recovery

The watcher defaults to dry-run when launched manually. The installed user service runs guarded apply mode: it polls every 0.75 seconds, waits 1 second for Obsidian writes to settle, performs a safety dry-run, and applies only an error-free result. Invalid, ambiguous, duplicate, unassigned and reopen-conflict changes are never applied.

Current Ubuntu operating mode: `ppj-executive-canvas-watcher.service` is enabled as a user service and starts automatically with the user session.

List or restore backups:

```bash
python3 scripts/restore_ppj_executive_canvas_sync.py --list
python3 scripts/restore_ppj_executive_canvas_sync.py --backup BACKUP_STAMP --dry-run
```

Backups are stored under:

- `99_Attachments/Canvas_Backup/<timestamp>/`
- `99_Attachments/Audit/PPJ_EXECUTIVE_CANVAS_STATE_SYNC_BACKUP/<timestamp>/`

Restore is never automatic.
