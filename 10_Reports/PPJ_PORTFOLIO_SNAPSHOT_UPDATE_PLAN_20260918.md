# PPJ Portfolio Snapshot Update Plan - 2026-09-18

- Source Event: `PPJ-PORTFOLIO-SNAPSHOT-20260918`
- Baseline: 18/09/2026 naming and portfolio baseline (`DEPARTMENT_APPLICATION_vMAJOR.MINOR.PATCH`)
- Mode: idempotent managed-section synchronization; physical filenames and folders are retained
- Canonical records: 36 (29 renamed to the new standard)
- Candidate initiatives: 1
- Discovery items (outside registry): 5
- Safety: validate mappings and Canvas JSON, dry-run, back up every changed file, apply without `--force`, audit.

## Synchronization Scope

Snapshot (Markdown + JSON), memory cards, root-note managed regions, existing workspaces, right-sized tasks, local boards, registry overlays with legacy-to-canonical alias mapping, Command Center, domain model additions, discovery register, decision/candidate records, four generated global canvases, an in-place patch of the live Executive Board (`PPJ_Executive_Board_v2.canvas`) and the final audit/report.
