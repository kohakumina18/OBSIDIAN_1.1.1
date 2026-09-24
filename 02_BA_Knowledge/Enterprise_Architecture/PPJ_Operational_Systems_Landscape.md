---
type: enterprise_architecture
source_event: PPJ-OPERATIONAL-SYSTEMS-LANDSCAPE-20260924
last_verified: 2026-09-24
scope: Systems operating in PPJ, excluding the projects of the AI & Automation team
status: canonical systems inventory (owner-provided infographic)
---

# PPJ Operational Systems Landscape

The systems that already operate in PPJ - **WFX ERP**, the **GTAS** internal applications and the named **third-party** applications. It does **not** describe any AI & Automation project; those are in [[PPJ_Enterprise_Application_AI_Automation_Ecosystem]] and the portfolio registry.

## Source

Ring infographic supplied by the vault owner on 2026-09-24:

- centre ellipse - WFX ERP, one cloud-tagged box per module;
- outer ring - GTAS applications, one icon per application;
- names set around the ring - third-party applications.

The original image was pasted into a working session and is **not stored in the vault**. Open item: save it under `99_Attachments/` and embed it here.

The diagram shows *which systems exist*. It draws no relationships between them, so nothing on this page implies an integration.

## 1. WFX ERP - 16 modules

| # | Module | Indicative business area |
| --- | --- | --- |
| 1 | Finance | Finance / Accounting |
| 2 | Style Library | Merchandising / Product Development |
| 3 | BrandPLM | Merchandising / Product Development |
| 4 | Sampling | Merchandising / Technical |
| 5 | Budgeting & Costing | Merchandising / Costing |
| 6 | Bill of Material | Technical / Costing |
| 7 | Buyer Order Management | Merchandising |
| 8 | Raw Material Planning | Purchasing / Sourcing |
| 9 | Purchase Order Management | Purchasing |
| 10 | Logistics In-bound | Warehouse / Logistics |
| 11 | Inventory Control | Warehouse / Purchasing |
| 12 | QC | QC / TQM |
| 13 | Production Planning | Production |
| 14 | Production Management | Production |
| 15 | QA | QC / TQM |
| 16 | Logistics Out-bound | Logistics |

The business-area column is an **indicative grouping added for navigation**; the diagram itself does not group the modules.

Descriptors printed at the centre of the diagram: **Reporting & Analysis** and **Time & Action Tracking**, each for Textiles / Garments (Spinning - Yarn - Weaving - Dyeing).

Production Planning is highlighted green in the diagram. The diagram does not say why.

## 2. GTAS - 16 internal applications

Applications developed inside PPJ before the current AI & Automation portfolio.

| Icon | Application | Note |
| --- | --- | --- |
| Ct | GTAS Costing | Marked with a red star in the diagram - meaning not stated |
| Sp | GTAS Sampling | |
| Cs | GTAS Consumption | |
| IED | GTAS IED | |
| Ci | GTAS Coats Integration | |
| Mb | GTAS Mixable | Printed "Mixbale" in the diagram; read as a typo |
| In | GTAS Inventory | |
| Co | GTAS Compliance | Printed "Complaince" in the diagram; read as a typo |
| Pr | GTAS Production | Referenced by the Finance AI canvas |
| Fqm | GTAS FQM | |
| Qc | GTAS QC | |
| Sa | GTAS Salary | Referenced by the Finance AI canvas |
| Tp | GTAS Transportation | |
| Ec | GTAS ECUS | |
| Bl | GTAS BI Report | The Finance AI canvas calls it "GTAS Reports" |
| Fs | GTAS Financial Statements | |

**GTAS Costing was missing from the 15-application list previously in circulation.** The diagram is the authority: 16 applications.

## 3. Third-party applications - 6 on the diagram

| Application | Purpose |
| --- | --- |
| HRIS | Human Resources Information System |
| E-office | Document receiving, workflow and digital signing |
| MMSx | Material management |
| FastReactPlan | Production planning |
| Gerber | Pattern / technical design (CAD) |
| ShapeShifter | Technical / pattern / product development |

Operating systems confirmed elsewhere in the vault but **not on the diagram**: VNPT e-Invoice, Power BI, GLPI, IoT / WISER / INA, and the DWH / Databricks data platform.

## 4. Reading rules

- WFX is the transaction backbone; GTAS is the PPJ-specific application layer; AI & Automation attaches to both and to the third-party systems. It does not replace them.
- Proximity on the diagram is not architecture. Do not infer an integration between two systems because they are drawn near each other.
- A relationship is drawn on a Canvas only when a vault document states it, and it is labelled with what is known: implemented, planned, data dependency, or business affinity.

## 5. Open items

- Store the original infographic under `99_Attachments/` and embed it above.
- **MMSx or MMX?** This diagram and `ADMIN.WORK-TRAVEL.canvas` write "MMSx"; the 2026-09-18 ecosystem note writes "MMX". Treated as the same system; confirm the correct name.
- The Finance AI canvas also names **GTAS Factory, GTAS Quantity, GTAS Efficiency and GTAS ID**. None appears in the diagram. Decide whether they are aliases or sub-modules of the 16 above, or separate applications.
- Meaning of the red star on GTAS Costing and the green highlight on Production Planning.

## Related

Canvas: [[PPJ_Digital_Application_AI_Automation_Ecosystem.canvas]]

Architecture: [[PPJ_Enterprise_Application_AI_Automation_Ecosystem]] · [[PPJ_Project_Process_Map]]

Governance: [[PPJ_PORTFOLIO_CURRENT_SNAPSHOT]] · [[PPJ_PORTFOLIO_DOMAIN_MODEL]]
