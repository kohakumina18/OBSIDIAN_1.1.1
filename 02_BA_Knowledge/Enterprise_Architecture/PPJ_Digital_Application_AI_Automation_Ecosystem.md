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

Two reading levels, from the BOD review of 24/09/2026: zoomed out the Canvas shows **coverage** (a badge on every WFX / GTAS module that AI / automation already touches: ● live, ◐ in development / planned, ○ evaluation / historical); hover or click shows the **exact relationships**. Project lines are hidden until a node is hovered or clicked, by the local plugin `.obsidian/plugins/ppj-canvas-focus` (PPJ Canvas Focus), which only acts on this Canvas. Without the plugin every line is visible at once.

Every line label starts with its type; `PRIMARY` marks a project's main module:

| Type | Meaning | Style | Lines drawn |
| --- | --- | --- | --- |
| INTEGRATION | Confirmed / validated integration | green, solid | 2 |
| PLANNED | In scope or in development, not delivered | orange, dashed | 3 |
| DATA | Data dependency / source | blue, dashed | 47 |
| KNOWLEDGE | Knowledge / RAG / reference | cyan, dotted | 6 |
| AFFINITY | Business relationship; no technical integration | grey, dotted | 23 |

By BOD decision, QC, Production Planning and Production Management carry no badge yet, and GTAS Transportation has no line. The full matrix and every change are in [[03_Projects/Canvas/CONNECTION_CHANGELOG|CONNECTION_CHANGELOG]]; checks in [[03_Projects/Canvas/CANVAS_VALIDATION_REPORT|CANVAS_VALIDATION_REPORT]].

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
- only two integrations are confirmed (Material Allocation, Invoice Downloader); everything else is PLANNED, DATA, KNOWLEDGE or AFFINITY.

## Canvas

![[PPJ_Digital_Application_AI_Automation_Ecosystem.canvas]]

Related: [[PPJ_Enterprise_Application_AI_Automation_Ecosystem]] · [[PPJ_Operational_Systems_Landscape]] · [[PPJ_PORTFOLIO_CURRENT_SNAPSHOT]]
