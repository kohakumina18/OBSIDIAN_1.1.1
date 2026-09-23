---
type: migration_report
date: 2026-09-18
source_vault: "C:/Users/nvakt/Documents/obsidian/BA_Obsidian_Vault"
target_vault: "E:/DATA/USB-VAULT/BA_Obsidian_Vault_FULL_LINUX_20260918/USB_BA_Obsidian_Vault"
status: applied
---

# USB Vault Migration from Windows Vault - 2026-09-18

## Decision

The USB vault is the canonical working vault. The Windows vault was treated as a legacy source and was merged without deleting files or overwriting newer USB portfolio data.

`AGENTS.md` and `README_PPJ_OBSIDIAN_SYSTEM.md.md` were updated to make the USB vault authoritative on Windows. Pre-change copies are stored under `99_Attachments/Audit/Vault_Migration_20260918/Pre_Migration_Metadata/`.

## Inventory Comparison

| Metric | Windows source | USB target |
|---|---:|---:|
| Total files | 964 | 6,381 before this migration |
| Markdown files | 505 | 4,667 before this migration |
| Canvas files | 35 | 336 before this migration |
| Files under `scripts/` | 38 | 67 |

Hash comparison found 831 identical files, 126 files with different content, 7 source-only files, and 5,424 USB-only files. The USB versions of differing portfolio files were retained because they contain the newer canonical naming, memory, workspace, registry, delivery-stream and Canvas model.

## Script Analysis

- 37 of 38 Windows PowerShell scripts are byte-for-byte identical to scripts already present on USB.
- `scripts/Register-PPJProject.ps1` differs. The USB version is the current guarded wrapper around `register_ppj_project.py`; it requires complete registration metadata, supports dry-run/apply separation and follows the current registration pipeline. The older Windows implementation was not copied over it.
- None of the 38 source scripts contains a hard-coded Windows vault root or Ubuntu vault root.
- 32 scripts derive the vault from the current working directory, so they must be launched from the USB vault root.
- 28 scripts expose a dry-run path and 32 contain backup logic.
- 16 legacy scripts still target `03_Projects/Canvas/PPJ_Executive_Board.canvas`, while the current live generated board is `PPJ_Executive_Board_v2.canvas`. Those legacy scripts must not be run against the USB vault until their Canvas target is reconciled.
- `Normalize-PPJProjectKnowledgeMarkers.ps1` has one PowerShell parser error at line 57 (`Missing expression after ','`). It was documented but not changed as part of this content migration.
- Two scripts contain `Remove-Item`: `Archive-ApprovedProjectDuplicates.ps1` and `Backup-ObsidianVault.ps1`. Review their resolved targets and use dry-run where available before execution.

## Imported into Active Vault

- `01_Daily_Notes/NOTES-JULU.canvas`
- `Pasted image 20260806191344.png`
- `Pasted image 20260806192130.png`
- `01_Daily_Notes/adw.md` (empty legacy note retained for completeness)

## Preserved as Audit-Only Legacy Artifacts

- Old `PPJ_Executive_Board.canvas`: preserved under `99_Attachments/Audit/Vault_Migration_20260918/Legacy_Not_Activated/` because its lane model predates the current two-stream/eight-stage board.
- Old `PUR.Material.Allocation.v2.1.md`: preserved under the same audit folder because its frontmatter identifies `PUR.Material.Allocation.v1.1`, its links contain corruption, and its business evidence already exists in the current Material Allocation workspace.
- Old self-contained `Register-PPJProject.ps1`: preserved in the audit folder as `Register-PPJProject.legacy-source.ps1`; it was not activated over the current Python-backed registration wrapper.

These audit copies are not active project or Canvas sources.

## Security Exclusion

`01_Daily_Notes/assd.canvas` was not copied because it contains a plaintext API credential. The credential should be revoked/rotated at the provider. Do not move that Canvas between vaults or commit it to source control.

## Canonical Material Allocation Resolution

The active canonical project remains `PUR_MaterialAllocation_v1.1.0`, resolved through `PPJ_PROJECT_ALIAS_MAP` to the physical root note `03_Projects/PUR.Material.Allocation.v1.2.md` and its workspace. The old source-only file was not activated as a second project.

## Related Governance

[[PPJ_PORTFOLIO_CURRENT_SNAPSHOT]]
[[PPJ_PROJECT_ALIAS_MAP]]
[[PPJ_PROJECT_REGISTRY]]
[[PPJ_EXECUTIVE_CANVAS_CONTROL_MANIFEST]]

## Validation

- Imported Canvas JSON parsed successfully: 9 nodes and 5 edges.
- Both referenced image attachments resolve in the USB vault.
- No API-key pattern was found in the imported text files.
- `scripts/audit_ppj_portfolio_consistency.py` completed with 0 errors and 0 warnings.
- Audit output: [[PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260918]].
