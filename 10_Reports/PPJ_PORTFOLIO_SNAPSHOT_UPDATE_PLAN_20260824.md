# PPJ Portfolio Snapshot Update Plan - 2026-08-24

- Source Event: `PPJ-PORTFOLIO-SNAPSHOT-20260824`
- Mode: idempotent managed-section synchronization
- Current snapshot: Markdown and JSON
- Canonical records: 35
- Candidate initiatives: 2
- Domain exceptions: 2 (Admin Expense; Warehouse AWB OCR)
- Safety: validate mappings and Canvas JSON, dry-run, back up every changed file, apply without `--force`, audit.

## Synchronization Scope

Memory cards, root-note managed regions, existing workspaces, right-sized tasks, local boards, registry overlays, Command Center, five global canvases, decision/candidate records and final audit/report.
