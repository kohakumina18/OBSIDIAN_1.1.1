---
type: conceptual-model
title: "SOP-JD-KPI Conceptual Relationship Model"
status: "PROPOSED / NOT APPROVED"
evidence_status: "MIXED - SEE SOURCE ASSESSMENT"
last_updated: 2026-10-13
---

# SOP-JD-KPI Conceptual Relationship Model

Status: **CONCEPTUAL / NOT A VERIFIED PPJ MAPPING**

Business Process -> SOP -> Business Function -> Department -> Position / Role -> JD -> Responsibility -> Expected Deliverable -> KPI -> Measurement Source -> Evaluation Result

## Relationship cardinality to validate

- These are many-to-many relationship candidates, not confirmed master-data records.
- One SOP may involve several roles; one role may participate in several SOPs.
- One responsibility may contribute to several KPIs; one KPI may measure several responsibilities.
- One KPI may use multiple governed sources; one source may support several KPIs.
- A result must retain effective period, organizational scope, evidence and approval.

## Governance questions

1. Which object is the source of truth for each relationship?
2. Who approves changes and effective dates?
3. Can corporate KPIs cascade directly to individuals, or only through governed allocation?
4. How are temporary/cross-functional assignments represented without double counting?

Related: [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/00_INDEX|BSC/KPI Index]] | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Requirement_Register#REQ-002|REQ-002]]
