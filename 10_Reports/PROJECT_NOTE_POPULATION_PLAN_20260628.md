# Project Note Population Plan - 20260628

## Executive Summary

The current canonical project filenames are kept as-is. No project files should be renamed, moved, archived, deleted, or merged in this stage.

A DryRun-first population script was created:

- `scripts/Populate-PPJCanonicalProjectNotes.ps1`

DryRun scanned 30 current root project/index notes and prepared managed project-detail blocks for canonical project notes only. `PROJECT_COMMAND_CENTER.md` is recognized as a command/index note and is not forced into the project detail template.

DryRun result:

- Projects scanned: 30
- Thin/corrupted notes found: 28
- Strong-evidence projects: 25
- Medium-evidence projects: 4
- Weak-evidence records: 1 command/index note
- Project notes modified: 0
- Canvas modified: 0
- Files moved/renamed/deleted: 0

## Project Notes Scanned

| Project Note                             | Evidence Count | Evidence Confidence | Classification                                     |
| ---------------------------------------- | -------------: | ------------------- | -------------------------------------------------- |
| MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md |              7 | Strong              | Canonical project                                  |
| ACC.GRN-SupplierInvoiceBot.v1.1.md       |              3 | Strong              | Canonical project                                  |
| AI Automation Workshop.md                |              1 | Medium              | Workshop / event note                              |
| E-commerce Market Intelligence.md        |              4 | Strong              | Canonical project                                  |
| FD.Datamart.v2.2.md                      |              5 | Strong              | Canonical project                                  |
| HR.SS&PFD.v1.1.md                        |              6 | Strong              | Canonical project                                  |
| MER.PO-Commit.md                         |              5 | Strong              | Canonical project                                  |
| PPJ XPrimo1D RFID Thread.md              |              3 | Strong              | External engagement                                |
| PPJ. Expense-Invoices.v1.1.md            |             16 | Strong              | Canonical project                                  |
| PPJ.AI.Hub.v2.1.md                       |              3 | Strong              | Platform / hub project                             |
| PPJ.COSTING.AGENT.PLATFORM.v1.1.md       |              6 | Strong              | Canonical project                                  |
| PPJ.GLPI-Helpdesk-AI Chatbot.md          |              0 | Medium              | Canonical chatbot note, needs reconstruction       |
| PPJ.Invoice Downloader.v1.2.md           |              7 | Strong              | Canonical project                                  |
| PPJ.PERRI.Chatbot.md                     |              0 | Medium              | Canonical chatbot note, needs reconstruction       |
| PPJxNUNOX.md                             |              3 | Strong              | External engagement                                |
| PPJxQSee.ai.md                           |              4 | Strong              | External engagement                                |
| PPJxStratova AI.md                       |              0 | Medium              | External engagement, weak vault evidence           |
| PROD.COWASH.md                           |              5 | Strong              | Canonical project                                  |
| PROD.IOT.CHuyenTreo_1.md                 |              4 | Strong              | Canonical project                                  |
| PROJECT_COMMAND_CENTER.md                |              0 | Weak                | Command/index note, excluded from project template |
| PUR.Adhoc Indent mien Nam.md             |              3 | Strong              | Canonical project                                  |
| PUR.GDI Automation.md                    |              8 | Strong              | Canonical project                                  |
| PUR.H&M Label-O Processing.md            |              4 | Strong              | Canonical project                                  |
| PUR.Inventory Report.md                  |              5 | Strong              | Canonical project                                  |
| PUR.Material.Allocation.v1.1.md          |              8 | Strong              | Canonical project                                  |
| SCP.SOURCING.CHATBOT.v2.3.md             |             13 | Strong              | Canonical sourcing project                         |
| TD.TechnicalPlatform_v2.1.md             |             10 | Strong              | Canonical platform project                         |
| VITAS Sharing.md                         |              6 | Strong              | Knowledge sharing / external engagement            |
| WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md  |              9 | Strong              | Canonical project                                  |
| Workshop Analysis.md                     |              6 | Strong              | Workshop analysis note                             |

## Thin / Corrupted Notes

Thin or incomplete notes identified by DryRun:

- MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md
- ACC.GRN-SupplierInvoiceBot.v1.1.md
- AI Automation Workshop.md
- E-commerce Market Intelligence.md
- FD.Datamart.v2.2.md
- HR.SS&PFD.v1.1.md
- MER.PO-Commit.md
- PPJ XPrimo1D RFID Thread.md
- PPJ. Expense-Invoices.v1.1.md
- PPJ.COSTING.AGENT.PLATFORM.v1.1.md
- PPJ.GLPI-Helpdesk-AI Chatbot.md
- PPJ.Invoice Downloader.v1.2.md
- PPJ.PERRI.Chatbot.md
- PPJxNUNOX.md
- PPJxQSee.ai.md
- PPJxStratova AI.md
- PROD.COWASH.md
- PROD.IOT.CHuyenTreo_1.md
- PUR.Adhoc Indent mien Nam.md
- PUR.GDI Automation.md
- PUR.H&M Label-O Processing.md
- PUR.Inventory Report.md
- PUR.Material.Allocation.v1.1.md
- SCP.SOURCING.CHATBOT.v2.3.md
- TD.TechnicalPlatform_v2.1.md
- VITAS Sharing.md
- WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md
- Workshop Analysis.md

Notes:

- `PPJ.GLPI-Helpdesk-AI Chatbot.md` and `PPJ.PERRI.Chatbot.md` are canonical notes even if tiny/corrupted and must be reconstructed, not converted to aliases.
- `PROJECT_COMMAND_CENTER.md` is not treated as a normal project note.

## Evidence Sources Used

The script uses these evidence sources:

- Existing project note content
- `03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md`
- `03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md`
- `03_Projects/_Registry/PPJ_PROJECT_ALIAS_MAP.md`
- `09_Stakeholders/PPJ_TEAM_WORKLOAD_MAP.md`
- `03_Projects/Canvas/`
- Filename/naming convention
- Approved seed context from the current governance discussion

The script does not rename files, move files, archive files, delete files, or update Canvas.

## Population Coverage

The managed block covers:

- Executive Summary
- Business Context
- Problem Statement
- Objectives
- Scope
- Stakeholders
- Current Process
- Target Process
- Data and Source of Truth
- System / Automation Design
- Business Rules
- User Flow
- KPI / Success Metrics
- Risks and Blockers
- Decisions Needed
- Next Actions
- Evidence and Confidence
- Related Concepts
- Methods
- Projects
- Deliverables

Frontmatter update behavior:

- Adds missing fields only.
- Does not destroy existing frontmatter.
- Does not remove existing user-written content.
- Uses managed block markers for idempotent updates.

Managed markers:

```text
<!-- PPJ_PROJECT_DETAIL_MANAGED_START -->
...
<!-- PPJ_PROJECT_DETAIL_MANAGED_END -->
```

## Projects With Strong Evidence

Strong-evidence projects:

- MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md
- ACC.GRN-SupplierInvoiceBot.v1.1.md
- E-commerce Market Intelligence.md
- FD.Datamart.v2.2.md
- HR.SS&PFD.v1.1.md
- MER.PO-Commit.md
- PPJ XPrimo1D RFID Thread.md
- PPJ. Expense-Invoices.v1.1.md
- PPJ.AI.Hub.v2.1.md
- PPJ.COSTING.AGENT.PLATFORM.v1.1.md
- PPJ.Invoice Downloader.v1.2.md
- PPJxNUNOX.md
- PPJxQSee.ai.md
- PROD.COWASH.md
- PROD.IOT.CHuyenTreo_1.md
- PUR.Adhoc Indent mien Nam.md
- PUR.GDI Automation.md
- PUR.H&M Label-O Processing.md
- PUR.Inventory Report.md
- PUR.Material.Allocation.v1.1.md
- SCP.SOURCING.CHATBOT.v2.3.md
- TD.TechnicalPlatform_v2.1.md
- VITAS Sharing.md
- WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md
- Workshop Analysis.md

## Projects With Weak Evidence

Weak or limited evidence projects:

- PPJ.GLPI-Helpdesk-AI Chatbot.md
- PPJ.PERRI.Chatbot.md
- PPJxStratova AI.md

Command/index note excluded from project template:

- PROJECT_COMMAND_CENTER.md

## Projects Needing Confirmation

Projects needing business confirmation:

- HR.SS&PFD.v1.1.md: confirm meaning of SS&PFD, owner, users, and workflow.
- FD.Datamart.v2.2.md: confirm FD/datamart/fabric/hanger scope and source of truth.
- PPJ.GLPI-Helpdesk-AI Chatbot.md: confirm GLPI service desk scope, owner, and integration approach.
- PPJ.PERRI.Chatbot.md: confirm PERRI chatbot/orchestrator scope and target users.
- PPJxStratova AI.md: confirm vendor engagement scope and outcome.
- MER.PO-Commit.md: confirm MER/customer commitment workflow and rollout status.
- PUR.Inventory Report.md: confirm report inputs, owner, and audience.
- PROD.COWASH.md: confirm COWASH process and factory/wash scope.

## Apply Plan

If approved, run:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Populate-PPJCanonicalProjectNotes.ps1" -Apply
```

Apply will:

1. Backup affected project notes to `99_Attachments/Audit/Project_Note_Population_Backup/YYYYMMDD_HHMMSS/`.
2. Add missing frontmatter fields safely.
3. Append or update only the managed project-detail block.
4. Preserve all original note content outside the managed block.
5. Skip `PROJECT_COMMAND_CENTER.md` as a command/index note.

Apply will not:

- Rename files.
- Move files.
- Archive files.
- Delete files.
- Modify Canvas layout.
- Merge project notes into PPJ.AI.Hub.

## Risks

- Some fields remain TBD because the vault does not yet contain confirmed business details.
- Seed context is used only with explicit confidence wording.
- Some registry/resource matrix names differ from current filenames after cleanup and renaming.
- Frontmatter will become richer but may need later human review.
- Broken method/template links remain a separate cleanup issue.

## Approval Checklist

Before Apply, confirm:

- Current filenames should remain unchanged.
- Managed block format is acceptable.
- `PROJECT_COMMAND_CENTER.md` should remain excluded from project template.
- GLPI and PERRI notes should be reconstructed as canonical notes.
- External/vendor notes should be populated as external engagements.
- Workshop notes should be populated as event/analysis notes.
- PPJ.AI.Hub should link modules but not absorb their project details.
