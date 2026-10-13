---
type: traceability-model
title: "Requirements Traceability Model"
status: "ACTIVE BA CONTROL"
evidence_status: "MIXED - SEE SOURCE ASSESSMENT"
last_updated: 2026-10-13
---

# Requirements Traceability Model

Trace chain:

`SRC -> PP -> RC/GAP -> OQ/WP -> REQ/BR -> DEC -> future design/test`

## Rules

1. A requirement candidate must trace to a reported/confirmed need or a clearly marked hypothesis.
2. Hypotheses remain TO VERIFY until evidence is added.
3. A decision becomes DECIDED only with date, decision maker and supporting evidence.
4. Cross-domain links use stable IDs and Obsidian links.
5. Register updates preserve IDs; retired items keep history.
6. Future BRD, data spec and UAT cases should reuse these IDs.

## Example

SRC-003 -> PP-003 -> RC-002/RC-004 -> OQ-003/WP01 -> REQ-003 -> DEC-008.

Related: [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/00_INDEX|BSC/KPI Index]] | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Requirement_Register|Requirement Register]]
