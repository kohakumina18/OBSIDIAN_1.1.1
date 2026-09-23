# FD / CPD Datamart Separation Correction Report - 20260628

## Executive Summary

FD.Datamart.v2.2 and CPD.Datamart.v1.1 are separate projects. This DryRun reports incorrect FD/CPD mapping references and proposes source-of-truth corrections. Canvas is detection-only and is not modified.

## Incorrect Assumption Found

- Incorrect: FD.Datamart.v2.2 equals CPD.Datamart.v1.1.
- Correct: FD.Datamart.v2.2 is FD / Directus / QR hanger data. CPD.Datamart.v1.1 is CPD / 3D Design / image search / 3D sample library.

## Correct FD Datamart Definition

FD.Datamart.v2.2 is the FD / fabric datamart project using Directus as a backend/admin/data platform. It supports FD sample/fabric/hanger-related data and QR design or QR information formatting for hanger usage.

## Correct CPD Datamart Definition

CPD.Datamart.v1.1 is a separate CPD / 3D Design datamart for image search and 3D sample library management.

## Files Containing Wrong Mapping

- 03_Projects\_Registry\PPJ_PROJECT_MODULE_INDEX.md: 3D Design
- 03_Projects\_Registry\PPJ_PROJECT_RESOURCE_MATRIX.md: 3D Design
- 03_Projects\CPD.Datamart.v1.1.md: 3D Design
- 03_Projects\CPD.Datamart.v1.1.md: Chi Trang
- 03_Projects\FD.Datamart.v2.2.md: 3D Design
- 03_Projects\FD.Datamart.v2.2.md: FD-specific forbidden reference: 3D Design
- 03_Projects\FD.Datamart.v2.2.md: FD-specific forbidden reference: CPD
- 03_Projects\FD.Datamart.v2.2.md: FD-specific forbidden reference: CPD.Datamart.v1.1
- 10_Reports\CPD_DATAMART_SCOPE_REPAIR_REPORT_20260628.md: 3D Design
- 10_Reports\CPD_DATAMART_SCOPE_REPAIR_REPORT_20260628.md: Chi Trang
- 10_Reports\CPD_DATAMART_SCOPE_REPAIR_REPORT_20260628.md: CPD website/application
- 10_Reports\PROJECT_KNOWLEDGE_POPULATION_REPAIR_PLAN_20260628.md: Recommended Future Filename: CPD.Datamart.v1.1.md
- scripts\Normalize-PPJProjectKnowledgeMarkers.ps1: chi Trang
- scripts\Repair-PPJProjectKnowledgePopulation.ps1: 3D Design
- scripts\Repair-PPJProjectKnowledgePopulation.ps1: chi Trang
- scripts\Repair-PPJProjectKnowledgePopulation.ps1: CPD sample management datamart / portal
- scripts\Repair-PPJProjectKnowledgePopulation.ps1: CPD sample management portal for chi Trang
- scripts\Repair-PPJProjectKnowledgePopulation.ps1: CPD website/application
- scripts\Repair-PPJProjectKnowledgePopulation.ps1: Recommended Future Filename: CPD.Datamart.v1.1.md

## Correction Plan

- FD.Datamart.v2.2.md managed block should be corrected to FD / Directus / QR hanger design module: True
- CPD.Datamart.v1.1.md exists: True
- CPD.Datamart.v1.1.md should be created only with -Apply -CreateCPDProject if missing.
- AGENTS.md update needed: False
- Registry files considered for update: 2
- Reports needing correction note: 2

## Apply Plan

Use targeted flags only after approval: -UpdateProjectNotes, -CreateCPDProject, -UpdateAgents, -UpdateRegistry, -UpdateReports.

## Approval Checklist

- Confirm FD and CPD are separate projects.
- Confirm no Canvas update in this script.
- Confirm CPD project note creation if missing.
- Confirm report correction notes are append-only.

## Canvas Update Dependency

Canvas should be updated only after source-of-truth notes and registry are corrected.
