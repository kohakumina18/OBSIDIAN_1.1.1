---
type: "project_profile"
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

# Project Profile

## Identity

| Field | Value |
| --- | --- |
| Canonical Code | SCP.SOURCING.CHATBOT.v2.3 |
| Physical Project Note | SCP.SOURCING.CHATBOT.v2.3.md |
| Primary Domain | Sourcing / Purchasing |
| Cluster | Sourcing AI / Data Platform |
| Lifecycle Class | B. UAT / Stabilization |
| Lifecycle | Closeout Preparation |
| Current Gate | Output Finalization / UAT Acceptance / Handover Preparation |
| Priority | TBD |
| Business Owner | Needs Confirmation |

## One-Line Understanding

Consolidated Sourcing data platform and chatbot for supplier, material, fabric, trims, and sample lookup.

## Intended Outcome

Consolidated Sourcing data platform and chatbot for supplier, material, fabric, trims and sample lookup.

## Users and Delivery Participants

- Primary users: Sourcing; data/permission/support owners Need Confirmation
- BA / Coordination: Khoa
- Technical members: Huy, Khoa, Linh, Nghia, Huy, Linh, Nghĩa

## Current Scope

- One consolidated project covering sourcing data repository, external samples, and chatbot lookup.

## Explicit Boundaries

- Do not split into separate Sourcing Repository, External Sample Management, and Sourcing Chatbot projects without approval.

## Current Gate and Next Move

- Gate: Output Finalization / UAT Acceptance / Handover Preparation
- Next actions: Finalize output format and confirm UAT acceptance.; Complete User Manual and support handover.; Separate defects from enhancements and transfer remaining issues to maintenance backlog.; Create/update the Sourcing External Data Standardization Backlog section within this project.

## Evidence Basis

- Root project note: [[../SCP.SOURCING.CHATBOT.v2.3]]
- Project memory: [[03_Projects/_Registry/Project_Memory/SCP.SOURCING.CHATBOT.v2.3.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
