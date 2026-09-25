---
type: enterprise_architecture
source_event: PPJ-DIGITAL-ECOSYSTEM-CANVAS-20260924
last_verified: 2026-09-24
scope: Executive view of WFX, third-party, GTAS and AI & Automation
status: canonical executive view
---

# PPJ Digital Application, AI & Automation Ecosystem

## Purpose

One executive Canvas showing what PPJ already runs, which projects the AI & Automation team has added around it, and how strongly each relationship is documented. Written for management, BA, IT, the AI & Automation team and business owners.

## Layer Model

A layered ecosystem, not a strict dependency stack. Read the centre column top to bottom:

```text
Shared AI platforms        PERRI · AI Hub · GLPI helpdesk chatbot
GTAS internal applications 16 applications built before the AI programme
Third-party applications   MMSx · E-office · Gerber · ShapeShifter · FastReactPlan · HRIS + vault-confirmed additions
WFX ERP core               16 modules, the transaction backbone
Data / knowledge           DWH / Databricks · Power BI · technical knowledge
```

Business-domain groups sit left and right of that column. Vendor evaluations are at the far left, collaboration and closed items at the far right.

## Systems

- **WFX** - 16 modules, source: [[PPJ_Operational_Systems_Landscape]]
- **Third-party** - the six named on the operating-systems diagram, plus VNPT e-Invoice, Power BI, GLPI and IoT / WISER / INA confirmed elsewhere in the vault
- **GTAS** - 16 internal applications, including GTAS Costing
- **AI / Automation** - 36 registered records from `PPJ_PORTFOLIO_SNAPSHOT_20260918`, each linked to its project note

## Relationship Semantics

Every line label starts with its strength, because a Canvas edge cannot be dashed or thinned:

| Prefix | Meaning | Lines drawn |
| --- | --- | --- |
| INTEGRATION | Implemented / validated | 2 |
| PLANNED | In scope or in development, not delivered | 3 |
| DATA | Data / knowledge dependency | 14 |
| AFFINITY | Same business capability; no technical integration confirmed | 29 |

## Portfolio Snapshot

Baseline 19/09/2026 holds 35 initiatives. The vault registry holds 36 records: the baseline's two expense-invoice projects are one project (confirmed by the owner 2026-09-25), and it also carries two closed records outside the baseline. Both count sets are shown on the Canvas, neither overwriting the other.

Latest review input: [[BOD_REVIEW_20260924_Madame_Phuong]].

## Architecture Principles

- WFX remains core ERP and transaction backbone; AI augments it.
- System of record stays explicit.
- Prefer API-based integration where available.
- Business affinity does not imply technical integration.
- Human review remains required for uncertain AI decisions.
- Reusable data and knowledge layers should serve several projects.
- Status and lifecycle are independent of business domain.

## Known Gaps

Recorded on the Canvas under DATA / GOVERNANCE GAP:

- expense-invoice projects: baseline listed two, the owner confirmed one on 2026-09-25 (resolved; the Export exclusion is still open);
- three canonical-code or status differences between the baseline and the vault (GRN bot, Stratova, GLPI chatbot domain);
- MMSx vs MMX naming, GTAS Factory / Quantity / Efficiency / ID names, and the unexplained highlights on the source diagram;
- no integration is documented at WFX-module or GTAS-application level.

## Canvas

![[PPJ_Digital_Application_AI_Automation_Ecosystem.canvas]]

Related: [[PPJ_Enterprise_Application_AI_Automation_Ecosystem]] · [[PPJ_Operational_Systems_Landscape]] · [[PPJ_PORTFOLIO_CURRENT_SNAPSHOT]]
