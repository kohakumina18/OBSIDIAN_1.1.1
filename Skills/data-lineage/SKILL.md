---
name: data-lineage
description: Produce data specifications, source-of-truth mapping, lineage, validation, reconciliation and data-quality rules for WFX, DWH, Excel, PDF, APIs, and target applications.
---
# Data lineage and mapping

## Mandatory conceptual flow
**Business Source → Data Warehouse → Target System**
Treat WFX, spreadsheets, source APIs, and other source systems separately from DWH transformations/storage and downstream target applications. Never assert that WFX and DWH are the same system.

## Workflow
1. Clarify business metric/output, grain, filter and timeframe.
2. For each item, capture business meaning, source of truth, known source table/API/field, type/format, transformations, DWH layer, target field, ownership, update cadence and history expectations.
3. Label each value: **Direct**, **Calculated**, **Aggregated**, **AI-Inferred**, or **Human-Confirmed**.
4. Specify null handling, duplicates, precedence/conflicts, reconciliation, data quality checks, data lineage, sample cases and test criteria.
5. If exact schema/API/data is absent, use `TBD / Verification Required` rather than synthetic names presented as fact.
6. Identify access dependencies and questions for data owners.

## Output
A compact mapping table plus business logic, reconciliation controls, sample tests, risks and a prioritized open-gap list.
