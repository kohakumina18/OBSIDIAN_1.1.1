# Project Knowledge Population Repair Plan - 20260628

## Executive Summary

DryRun scanned 29 root canonical project notes and found 29 notes that would be repaired. No files were renamed, moved, archived, deleted, or Canvas-updated.

## Why Repair Is Needed

- Previous generated blocks contain generic wording and spacing bugs.
- Evidence confidence needs to be conservative when evidence is weak or zero.
- CPD Datamart business scope was corrected by the user and must not remain generic FD Datamart only.
- PERRI and GLPI are canonical notes and need real reconstruction, not alias conversion.

## Files Scanned

- ACC.GRN-SupplierInvoiceBot.v2.3.md: Complete enough; evidence=3; managed_blocks=1; repair=True
- AI Automation Workshop.md: Populated but needs QA; evidence=3; managed_blocks=1; repair=True
- E-commerce Market Intelligence.md: Populated but needs QA; evidence=8; managed_blocks=1; repair=True
- FD.Datamart.v2.2.md: Populated but needs QA; evidence=6; managed_blocks=1; repair=True
- HR.SS&PFD.v1.1.md: Populated but needs QA; evidence=8; managed_blocks=1; repair=True
- MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md: Populated but needs QA; evidence=6; managed_blocks=1; repair=True
- MER.PO-Commit.md: Populated but needs QA; evidence=5; managed_blocks=1; repair=True
- PPJ XPrimo1D RFID Thread.md: Populated but needs QA; evidence=4; managed_blocks=1; repair=True
- PPJ. Expense-Invoices.v1.1.md: Populated but needs QA; evidence=16; managed_blocks=1; repair=True
- PPJ.AI.Hub.v2.1.md: Populated but needs QA; evidence=4; managed_blocks=1; repair=True
- PPJ.COSTING.AGENT.PLATFORM.v1.1.md: Populated but needs QA; evidence=6; managed_blocks=1; repair=True
- PPJ.GLPI-Helpdesk-AI Chatbot.md: Populated but needs QA; evidence=3; managed_blocks=1; repair=True
- PPJ.Invoice Downloader.v1.2.md: Populated but needs QA; evidence=9; managed_blocks=1; repair=True
- PPJ.PERRI.Chatbot.md: Populated but needs QA; evidence=5; managed_blocks=1; repair=True
- PPJxNUNOX.md: Populated but needs QA; evidence=4; managed_blocks=1; repair=True
- PPJxQSee.ai.md: Populated but needs QA; evidence=5; managed_blocks=1; repair=True
- PPJxStratova AI.md: Populated but needs QA; evidence=0; managed_blocks=1; repair=True
- PROD.COWASH.md: Populated but needs QA; evidence=4; managed_blocks=1; repair=True
- PROD.IOT.CHuyenTreo_1.md: Populated but needs QA; evidence=3; managed_blocks=1; repair=True
- PUR.Adhoc Indent mien Nam.md: Populated but needs QA; evidence=3; managed_blocks=1; repair=True
- PUR.GDI Automation.md: Populated but needs QA; evidence=9; managed_blocks=1; repair=True
- PUR.H&M Label-O Processing.md: Populated but needs QA; evidence=4; managed_blocks=1; repair=True
- PUR.Inventory Report.md: Populated but needs QA; evidence=5; managed_blocks=1; repair=True
- PUR.Material.Allocation.v1.1.md: Populated but needs QA; evidence=9; managed_blocks=1; repair=True
- SCP.SOURCING.CHATBOT.v2.3.md: Populated but needs QA; evidence=15; managed_blocks=1; repair=True
- TD.TechnicalPlatform_v2.1.md: Populated but needs QA; evidence=13; managed_blocks=1; repair=True
- VITAS Sharing.md: Populated but needs QA; evidence=8; managed_blocks=1; repair=True
- WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md: Populated but needs QA; evidence=9; managed_blocks=1; repair=True
- Workshop Analysis.md: Populated but needs QA; evidence=8; managed_blocks=1; repair=True

## Actual Filename Validation

- Missing expected protected file: ACC.GRN-SupplierInvoiceBot.v1.1.md
- Unexpected protected filename present: ACC.GRN-SupplierInvoiceBot.v2.3.md

## Managed Block Marker Audit

Standard marker after repair: <!-- PPJ_PROJECT_KNOWLEDGE_START --> / <!-- PPJ_PROJECT_KNOWLEDGE_END -->

Recognized marker variants:
- standard PPJ project knowledge: <!-- PPJ_PROJECT_KNOWLEDGE_START --> / <!-- PPJ_PROJECT_KNOWLEDGE_END -->
- invalid generated project knowledge identical: <!-- generated project knowledge content --> / <!-- generated project knowledge content -->
- previous generated project knowledge start/end: <!-- generated project knowledge content start --> / <!-- generated project knowledge content end -->
- incorrect generated content: <!-- generated content start --> / <!-- generated content end -->
- old PPJ_PROJECT_DETAIL: <!-- PPJ_PROJECT_DETAIL_MANAGED_START --> / <!-- PPJ_PROJECT_DETAIL_MANAGED_END -->
- generic generated project detail: <!-- generated project detail start --> / <!-- generated project detail end -->
- project detail managed: <!-- PROJECT_DETAIL_MANAGED_START --> / <!-- PROJECT_DETAIL_MANAGED_END -->
- project knowledge managed: <!-- PROJECT_KNOWLEDGE_MANAGED_START --> / <!-- PROJECT_KNOWLEDGE_MANAGED_END -->
- PPJ project knowledge managed: <!-- PPJ_PROJECT_KNOWLEDGE_MANAGED_START --> / <!-- PPJ_PROJECT_KNOWLEDGE_MANAGED_END -->
- PPJ project detail generated: <!-- PPJ_PROJECT_DETAIL_GENERATED_START --> / <!-- PPJ_PROJECT_DETAIL_GENERATED_END -->
- PPJ generated project detail: <!-- PPJ_GENERATED_PROJECT_DETAIL_START --> / <!-- PPJ_GENERATED_PROJECT_DETAIL_END -->
- PPJ generated project knowledge: <!-- PPJ_GENERATED_PROJECT_KNOWLEDGE_START --> / <!-- PPJ_GENERATED_PROJECT_KNOWLEDGE_END -->
- managed project knowledge: <!-- MANAGED_PROJECT_KNOWLEDGE_START --> / <!-- MANAGED_PROJECT_KNOWLEDGE_END -->
- managed project detail: <!-- MANAGED_PROJECT_DETAIL_START --> / <!-- MANAGED_PROJECT_DETAIL_END -->
- project knowledge generated: <!-- PROJECT_KNOWLEDGE_GENERATED_START --> / <!-- PROJECT_KNOWLEDGE_GENERATED_END -->
- generated knowledge: <!-- GENERATED_KNOWLEDGE_START --> / <!-- GENERATED_KNOWLEDGE_END -->
- auto generated project knowledge: <!-- AUTO_GENERATED_PROJECT_KNOWLEDGE_START --> / <!-- AUTO_GENERATED_PROJECT_KNOWLEDGE_END -->
- AI generated project knowledge: <!-- AI_GENERATED_PROJECT_KNOWLEDGE_START --> / <!-- AI_GENERATED_PROJECT_KNOWLEDGE_END -->

Marker variants found in scanned files:
- incorrect generated content: 26
- standard PPJ project knowledge: 3

## Text Quality Issues

- Total detected issue instances: 35
- AI Automation Workshop.md: TBD overuse
- E-commerce Market Intelligence.md: TBD overuse
- FD.Datamart.v2.2.md: obvious joined sentence boundary; TBD overuse
- HR.SS&PFD.v1.1.md: TBD overuse
- MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md: obvious joined sentence boundary; TBD overuse
- MER.PO-Commit.md: obvious joined sentence boundary; TBD overuse
- PPJ XPrimo1D RFID Thread.md: TBD overuse
- PPJ. Expense-Invoices.v1.1.md: TBD overuse
- PPJ.AI.Hub.v2.1.md: TBD overuse
- PPJ.COSTING.AGENT.PLATFORM.v1.1.md: TBD overuse
- PPJ.GLPI-Helpdesk-AI Chatbot.md: obvious joined sentence boundary
- PPJ.Invoice Downloader.v1.2.md: TBD overuse
- PPJ.PERRI.Chatbot.md: obvious joined sentence boundary; TBD overuse
- PPJxNUNOX.md: TBD overuse
- PPJxQSee.ai.md: TBD overuse
- PPJxStratova AI.md: TBD overuse
- PROD.COWASH.md: TBD overuse
- PROD.IOT.CHuyenTreo_1.md: TBD overuse
- PUR.Adhoc Indent mien Nam.md: TBD overuse
- PUR.GDI Automation.md: TBD overuse
- PUR.H&M Label-O Processing.md: TBD overuse
- PUR.Inventory Report.md: TBD overuse
- PUR.Material.Allocation.v1.1.md: TBD overuse
- SCP.SOURCING.CHATBOT.v2.3.md: obvious joined sentence boundary; TBD overuse
- TD.TechnicalPlatform_v2.1.md: TBD overuse
- VITAS Sharing.md: obvious joined sentence boundary; TBD overuse
- WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md: TBD overuse
- Workshop Analysis.md: obvious joined sentence boundary; TBD overuse

## Evidence Confidence Issues

- No evidence=0 records retain non-conservative confidence in the repair plan.

## Project-Specific Repair Plan

- ACC.GRN-SupplierInvoiceBot.v2.3.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- AI Automation Workshop.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- E-commerce Market Intelligence.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- FD.Datamart.v2.2.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong for corrected business concept; implementation details need confirmation; marker_validation=True
- HR.SS&PFD.v1.1.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- MER.PO-Commit.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PPJ XPrimo1D RFID Thread.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PPJ. Expense-Invoices.v1.1.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PPJ.AI.Hub.v2.1.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PPJ.COSTING.AGENT.PLATFORM.v1.1.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PPJ.GLPI-Helpdesk-AI Chatbot.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong for corrected business concept; implementation details need confirmation; marker_validation=True
- PPJ.Invoice Downloader.v1.2.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PPJ.PERRI.Chatbot.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong for corrected business concept; implementation details need confirmation; marker_validation=True
- PPJxNUNOX.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PPJxQSee.ai.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PPJxStratova AI.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Weak / Needs Confirmation; marker_validation=True
- PROD.COWASH.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PROD.IOT.CHuyenTreo_1.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PUR.Adhoc Indent mien Nam.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PUR.GDI Automation.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PUR.H&M Label-O Processing.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PUR.Inventory Report.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- PUR.Material.Allocation.v1.1.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- SCP.SOURCING.CHATBOT.v2.3.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- TD.TechnicalPlatform_v2.1.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- VITAS Sharing.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True
- Workshop Analysis.md: replace/consolidate managed block only; marker -> PPJ_PROJECT_KNOWLEDGE_START / PPJ_PROJECT_KNOWLEDGE_END; confidence -> Strong; marker_validation=True

## CPD Datamart Correction Plan

- Current filename remains FD.Datamart.v2.2.md.
- Business canonical concept becomes CPD.Datamart.v1.1.
- Rename status: Needs Approval.
- Recommended future filename: CPD.Datamart.v1.1.md.

## High Priority Repairs

- FD.Datamart.v2.2.md
- PPJ.PERRI.Chatbot.md
- PPJ.GLPI-Helpdesk-AI Chatbot.md
- PPJ.COSTING.AGENT.PLATFORM.v1.1.md
- MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md
- SCP.SOURCING.CHATBOT.v2.3.md
- PPJ.AI.Hub.v2.1.md
- PPJ.Invoice Downloader.v1.2.md
- PPJ. Expense-Invoices.v1.1.md

## Apply Plan

Run only after approval:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\Repair-PPJProjectKnowledgePopulation.ps1" -Apply
```

Apply will backup affected notes, replace or consolidate managed blocks, preserve user-written content outside managed blocks, and avoid Canvas changes.
Apply will hard stop before writing if any generated block fails marker validation.

## Approval Checklist

- Confirm no file renaming in this stage.
- Confirm CPD Datamart concept correction.
- Confirm PERRI and GLPI reconstruction direction.
- Confirm standard marker: <!-- PPJ_PROJECT_KNOWLEDGE_START --> / <!-- PPJ_PROJECT_KNOWLEDGE_END -->.
