# PPJ Project Folder Hygiene Audit - 20260627

Generated: 2026-06-27

## Executive Summary

The top-level `03_Projects/` folder is visually messy because alias/history notes, tiny placeholder notes, and duplicate-review notes still remain beside canonical project notes.

No files were moved, renamed, deleted, or modified during this audit. Canvas files were not updated.

DryRun result shows that no alias note is currently safe to move to `03_Projects/_Aliases/` because all detected alias notes still have Markdown backlinks and some still have Canvas references.

## Scope

Included:

- Top-level Markdown files directly under `03_Projects/`

Excluded folders:

- `Canvas/`
- `Project_SmartFlow/`
- `_Archive/`
- `_Kanban/`
- `_Registry/`
- `_Tasks/`
- `_Templates/`
- `_Aliases/`

## Summary Counts

| Classification             | Count |
| -------------------------- | ----: |
| Canonical Project          |    26 |
| Alias Note                 |    10 |
| Safe-to-move Alias         |     0 |
| Blocked Alias              |    10 |
| Placeholder / Suspicious   |     4 |
| Non-empty Duplicate Review |     5 |
| Command / Index File       |     1 |

## Safe-to-Move Alias Notes

None.

## Blocked Alias Notes

| Alias Note                    | Markdown Backlink Risk | Canvas Reference Risk | Hygiene Decision                                                    |
| ----------------------------- | ---------------------: | --------------------: | ------------------------------------------------------------------- |
| [[Adhoc Indent]]              |                      5 |                     2 | Blocked. Do not move until links and Canvas references are handled. |
| [[Cowash VER2]]               |                      5 |                     0 | Blocked. Do not move until backlinks are handled.                   |
| [[CPD Fabric Database]]       |                      5 |                     0 | Blocked. Do not move until backlinks are handled.                   |
| [[E-commerce Exploration]]    |                      5 |                     0 | Blocked. Do not move until backlinks are handled.                   |
| [[EX-IM Expense Invoice Bot]] |                      6 |                     0 | Blocked. Do not move until backlinks are handled.                   |
| [[GDI Automation]]            |                      5 |                     2 | Blocked. Do not move until links and Canvas references are handled. |
| [[Import Export Automation]]  |                      6 |                     0 | Blocked. Do not move until backlinks are handled.                   |
| [[Market Intelligence]]       |                      5 |                     4 | Blocked. Do not move until links and Canvas references are handled. |
| [[PPJ x Nunox]]               |                      5 |                     0 | Blocked. Do not move until backlinks are handled.                   |
| [[PPJ x Stratova AI]]         |                      5 |                     0 | Blocked. Do not move until backlinks are handled.                   |

## Placeholder / Suspicious Tiny Files

These files are less than or equal to 20 bytes or are not valid project notes. They should be reviewed, not moved automatically.

| File                             |    Size | Recommended Action                                                         |
| -------------------------------- | ------: | -------------------------------------------------------------------------- |
| [[Chuyền Treo IoT Dashboard]]    | 5 bytes | Review manually. Likely alias/placeholder for [[PROD.IOT.CHuyenTreo_1]].        |
| [[PPJ.GLPI-Helpdesk-AI Chatbot]] | 5 bytes | Review manually. Decide whether it is active, alias, or archive candidate. |
| [[PPJ.PERRI.Chatbot]]            | 5 bytes | Review manually. Decide whether it is active, alias, or archive candidate. |
| [[Web Tổng Hợp Tool]]            | 5 bytes | Review manually. Likely alias/placeholder for [[Web Tong Hop Tool]].       |

## Non-empty Duplicate Review

These files contain content or are not safe to move automatically. They need manual merge/alias review before any folder hygiene action.

| File                            |      Size | Recommended Action                                                                                        |
| ------------------------------- | --------: | --------------------------------------------------------------------------------------------------------- |
| [[FD.Datamart.v2.2]]              | 388 bytes | Review manually. Confirm whether it is canonical, alias, or needs project definition.                     |
| [[MER.PO-Commit]]                   | 402 bytes | Review manually. Confirm MER/Purchasing ownership and whether it is active.                               |
| [[PUR.Inventory Report]] | 397 bytes | Review manually. Confirm report source of truth and technical owner.                                      |
| [[Sourcing Chatbot v2.3]]       | 762 bytes | Review manually before alias move. Sourcing must remain consolidated under [[SCP.SOURCING.CHATBOT.v2.3]]. |
| [[Sourcing VER2]]               | 287 bytes | Review manually before alias move. Sourcing must remain consolidated under [[SCP.SOURCING.CHATBOT.v2.3]]. |

## Canonical Project Notes

Canonical project notes remain directly under `03_Projects/`. They are not moved by the hygiene script.

Canonical count from DryRun: 26.

## Canvas Risk

Alias notes still referenced in Canvas:

- [[Adhoc Indent]]
- [[GDI Automation]]
- [[Market Intelligence]]

Canvas updates are out of scope for this stage. Do not move these files until Canvas references are approved for update or confirmed safe.

## Backlink Risk

All detected alias notes still have Markdown backlinks. Moving them now could break navigation or reduce Obsidian traceability.

## Recommended Folder Hygiene Sequence

1. Keep all canonical project notes at `03_Projects/` root.
2. Do not move blocked alias notes yet.
3. Review suspicious tiny files and decide whether each should become alias, archive, or a real project note.
4. Review non-empty duplicate notes and decide whether to merge, preserve, or convert to alias.
5. Clean Markdown backlinks for approved aliases in a separate controlled step.
6. Clean Canvas references only after explicit approval.
7. Re-run `Clean-PPJProjectFolderVisuals.ps1 -DryRun`.
8. Apply only when safe-to-move aliases are reported.

## PowerShell Commands

DryRun:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Clean-PPJProjectFolderVisuals.ps1" -DryRun
```

Apply, approval required:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Clean-PPJProjectFolderVisuals.ps1" -Apply
```

## Related Concepts

[[Project Governance]]
[[Traceability]]
[[Data Governance]]
[[Portfolio Management]]

## Methods

[[Impact Analysis]]
[[Data Mapping]]
[[Requirement Validation]]
