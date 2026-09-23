---
type: "risks_issues"
project: "SCP.SOURCING.CHATBOT.v2.3"
source_project: "SCP.SOURCING.CHATBOT.v2.3.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---

<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_START -->
## Current State - 2026-09-18

| Field | Value |
| --- | --- |
| Canonical Code | SCP_SourcingChatbot_v2.3.0 |
| Domain | Sourcing / Purchasing |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | GO-LIVE / PRODUCTION / SUPPORT |
| Lifecycle | Production |
| Status | Active |
| Progress | TBD |
| Gate | Production monitoring, data quality and retrieval quality |
| Priority | P9 |
| Outcome | One production application for supplier/material intelligence: Supplier Data + Material Data + Search + Comparison + RAG + Chatbot. |
| Source Event | PPJ-PORTFOLIO-SNAPSHOT-20260918 |

### Latest Update

Stays one application; do not split into sourcing database / search / RAG / chatbot unless business lifecycles genuinely diverge. Focus: production monitoring, data quality, retrieval quality, supplier/material coverage and answer traceability.

### Current Risks

- Manual external-data input
- Non-standard naming and metadata
- Data-quality drift

### Dependencies

- None recorded in the current portfolio snapshot.

### Next Actions

- Clean missing fields, mixed types, duplicates and naming
- Stress-test retrieval with real Sourcing questions
- Monitor adoption and production quality
<!-- PPJ_PORTFOLIO_SNAPSHOT_20260824_END -->

# Risks and Issues

| ID | Risk / Issue | Impact | Owner | Status | Source |
| --- | --- | --- | --- | --- | --- |
| RISK-001 | UAT acceptance, data owner, permission owner and support owner are not confirmed. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |
| RISK-002 | External data remains manually entered and inconsistent. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |
| RISK-003 | Closing chatbot development could be confused with completing the data foundation. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |
| RISK-004 | Future MER usage requires stress, permission, search-quality and data-normalization tests. | Needs Confirmation | Needs Confirmation | Open | PPJ-WEEKLY-20260727-20260801 |

## Evidence Basis

- Root project note: [[../SCP.SOURCING.CHATBOT.v2.3]]
- Project memory: [[03_Projects/_Registry/Project_Memory/SCP.SOURCING.CHATBOT.v2.3.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
