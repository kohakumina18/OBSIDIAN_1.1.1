---
type: implementation_plan
system: PPJ Executive Canvas Control
date: 2026-08-24
status: Implemented and validation pending
---

# PPJ Executive Canvas Control Upgrade Plan

## Objective

Turn `PPJ_Executive_Board.canvas` into a bidirectional operational state-control surface while preserving the Registry and current snapshot as persisted source of truth. A new Codex session must understand the current portfolio from `AGENTS.md` plus the fast snapshot without rereading historical reports.

## State Model

Exactly eight persistent delivery stages:

```text
BACKLOG -> KICK-OFF -> ANALYSIS -> DESIGN -> DEVELOPMENT
-> UAT / PRE-GO-LIVE -> GO-LIVE / PRODUCTION / SUPPORT -> CLOSED
```

`delivery_stage` is independent from Lifecycle, Status, Progress, Current Gate, Priority and Primary Domain. On Hold, Blocked, Waiting, Pending Decision and External Collaboration remain status/governance overlays at the furthest stage reached. Candidate initiatives remain outside the pipeline.

## Control Design

- Stable lane IDs are stored in `03_Projects/_Registry/PPJ_EXECUTIVE_CANVAS_STAGE_CONFIG.json`.
- Stable project-card IDs are derived from canonical codes.
- Each registered card contains `<!-- PPJ_PROJECT_CARD:CANONICAL_CODE -->`.
- Geometry resolves only when the card center belongs to exactly one configured stage group.
- Missing, duplicate, ambiguous, unassigned and unknown cards block Canvas-to-vault apply.
- Forward skips and backward/rework transitions are permitted and logged.
- Reopening CLOSED requires explicit approval or force.

## Synchronization Scope

Canvas-to-vault apply updates the current snapshot JSON/Markdown, registry overlays, memory card, root note, project home, profile, plan, milestones, weekly status, change log, local-board summary, Command Center, update ledger, Executive Canvas card text, Portfolio/Domain view cards and Roadmap. Data Flow is not changed by a stage-only transition.

## Safety and Recovery

- Dry-run is default for synchronizer, watcher and restore tool.
- Every changed Canvas is backed up under `99_Attachments/Canvas_Backup/<timestamp>/`.
- Other changed state files are backed up under `99_Attachments/Audit/PPJ_EXECUTIVE_CANVAS_STATE_SYNC_BACKUP/<timestamp>/`.
- Each run writes `99_Attachments/Audit/PPJ_EXECUTIVE_CANVAS_SYNC_LOG_*.md`.
- Restore creates a pre-restore safety backup before applying.
- The watcher service is prepared but is not installed, enabled or started automatically.

## Execution Sequence

1. Validate scripts and configuration.
2. Run the existing portfolio baseline in dry-run.
3. Apply the approved 2026-08-24 baseline with backups.
4. Run vault-to-Canvas dry-run and apply structural alignment if required.
5. Run Canvas-to-vault dry-run; expected transition count is zero.
6. Validate eight groups, stable card identity, unique geometry, candidate isolation and persisted-state consistency.
7. Run portfolio consistency audit and produce the result report.

## Manual Operations

```bash
python3 scripts/sync_ppj_executive_canvas_state.py --from-canvas --dry-run --all
python3 scripts/sync_ppj_executive_canvas_state.py --from-canvas --apply --all
python3 scripts/sync_ppj_executive_canvas_state.py --to-canvas --dry-run --all
python3 scripts/watch_ppj_executive_canvas.py --dry-run
python3 scripts/restore_ppj_executive_canvas_sync.py --list
```

