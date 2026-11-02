---
type: "project"
project_name: MER Costing Intelligence
cluster: AI
status: "Active"
priority: "P2"
project_code: "MER_CostingAgenticPlatform_v1.1.0"
department: "MER"
object: "Inferred from filename"
project_characteristic: "agentic platform"
version: "v1.1"
phase: "DEVELOPMENT"
owner: "TBD"
business_owner: "TBD"
technical_owner: "TBD"
members: []
stakeholders: []
systems: []
data_sources: []
progress: "TBD"
blocked: "TBD"
decision_needed: "TBD"
next_action: "TBD"
last_updated: "2026-10-30"
confidence: "Strong"
source_files: []
phase_canvas_group: "ANALYSIS"
last_weekly_update: "2026-06-29 to 2026-07-05"
weekly_rank: "2"
canonical_code: "MER_CostingAgenticPlatform_v1.1.0"
current_file: "PPJ.COSTING.AGENT.PLATFORM.v1.1.md"
primary_domain: "Merchandising"
lifecycle: "Active Development"
current_gate: "Wash/COMIT POC data-contract approval and expert-owned dataset"
last_verified: "2026-10-30"
source_event: "PPJ-WEEKLY-20261023-20261030"
dependencies: ["TD.TechnicalKnowledge.Platform.v2.1 -> Consumption / Pattern / BOM / Construction / History -> Costing Platform", "AI Suggestion -> Expert-approved Result -> Final GTAS/IED Transfer"]
delivery_stage: "DEVELOPMENT"
stage_entered_date: "Needs Confirmation"
delivery_stream: "INTERNAL DEVELOPMENT"
---

# MER Costing Intelligence

Status: [[Analysis]]
Cluster: [[AI]]
Priority: P1

Canvas:
- [[PPJ_Portfolio]]
- [[PPJ_Executive_Board]]
- [[PPJ_Data_Flow]]
- [[PPJ_Roadmap_2026]]

🎯 Outcome

- Costing search, BOM, price history, product similarity

📌 Current Status

- Analysis

⚠️ Risks / Blockers

- TBD

✅ Next Actions

- TBD

🔗 Related Concepts  
[[Outcome Driven Thinking]]  
[[System Thinking]]  
[[Decision Making]]  
[[Stakeholder Management]]

🔧 Methods  
[[Impact Analysis]]  
[[Decision Matrix]]  
[[Requirement Elicitation]]

📎 Deliverables  
[[Decision_Driven_BRD]]  
[[ERD_Template]]  
[[User_Manual_Template]]

---

Update - Lifecycle Update 2026-W26

Phase:
[[ANALYSIS]]

Cluster:
[[AI]]

Current Summary:
- Costing search, BOM, price history, product similarity.

Canvas:
- [[PPJ_Executive_Board]]

---

## Project Resource Governance

BA / Coordination:
Khoa

Technical Members:
Huy, Linh

Business Stakeholder / Department:
MER

Portfolio Group:
Agentic / Chatbot / Knowledge

Priority:
P1 Next Week

Phase:
ANALYSIS

Progress:
TBD

Blocker:
TBD

Decision Needed:
TBD

Next Action:
Next Actions

Workload Risk:
High - new agentic platform scope

Source:
[[PPJ_PROJECT_RESOURCE_MATRIX]]

<!-- PPJ_PROJECT_KNOWLEDGE_START -->

## Current Portfolio State

| Field | Value |
| --- | --- |
| Canonical Code | MER_CostingAgenticPlatform_v1.1.0 |
| Legacy Code(s) | COSTING.AGENTIC.PLATFORM.v1.1; PPJ.COSTING.AGENT.PLATFORM.v1.1 |
| Primary Domain | Merchandising |
| Delivery Stream | INTERNAL DEVELOPMENT |
| Delivery Stage | DEVELOPMENT |
| Lifecycle | Active Development |
| Status | Active |
| Progress | TBD |
| Current Gate | Wash/COMIT POC data-contract approval and expert-owned dataset |
| Priority | P2 |
| Business Owner | Needs Confirmation |
| Registration | Registered |
| Last Verified | 2026-10-30 |
| Confidence | Strong |

## Executive Summary

Generate a Costing / Quotation Package for Merchandising review and customer quotation through one platform.

## Current Capability

Garment Requirement -> Operation Breakdown -> Operation Normalization -> Machine Mapping -> SAM -> Cost -> Confidence -> IED / Expert Review; Wash: Requirement -> Attribute Extraction -> Recipe Search -> Process Recommendation -> Cost/Risk -> Wash Expert Review.

## Latest Update

COMIT Wash Image Analysis Requirement v1.1 entered structured POC definition. Scope, responsibilities, data contract, expert review and proposed targets are documented. No trained model or POC result exists yet. Sew Agent has no new confirmed movement.

## Risks / Blockers

- Taxonomy, metadata, annotation rules and expert-owned dataset are not frozen.
- Proposed targets and the expert-review fallback are not approved.
- A requirement document is not evidence of model training, accuracy or a successful POC.

## Decisions Needed

- Approve Wash/COMIT POC scope, dataset ownership, proposed targets and mandatory expert-review fallback.

## Dependencies

- TD_TechnicalKnowledgePlatform_v2.1.0 -> Pattern/BOM/Consumption -> Sew/Wash/Costing AI

## Next Actions

- Freeze the Wash/COMIT taxonomy, metadata, annotation guide and data contract.
- Assign the expert-owned POC dataset and acceptance review gate.
- Keep all model targets labelled proposed until approved and tested.

## Do Not Drift Rules

- Lifecycle and progress are separate.
- Preserve historical evidence outside this managed current-state block.
- Do not invent owners, dates, source tables, APIs, thresholds or approvals.
- Current state is governed by `PPJ-PORTFOLIO-SNAPSHOT-20260918`.

## Workspace Links

- [[PPJ.COSTING.AGENT.PLATFORM.v1.1/00_Project_Home|Project Home]]
- [[PPJ.COSTING.AGENT.PLATFORM.v1.1/Project_Executive_Board|Project Executive Board]]
- [[PPJ.COSTING.AGENT.PLATFORM.v1.1/Tasks|Tasks]]

## Evidence and Confidence

- Date: 2026-10-30
- Source Event: PPJ-WEEKLY-20261023-20261030
- Source: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Confidence: Strong

<!-- PPJ_PROJECT_KNOWLEDGE_END -->

<!-- PPJ_WEEKLY_UPDATE_20260629_20260705_START -->
## Weekly Update - 2026-06-29 to 2026-07-05

- Project code: $(@{Code=COSTING.AGENTIC.PLATFORM.v1.1; Note=03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1.md; Phase=Analysis / Data Acquisition / Sew-first Implementation; Lane=ANALYSIS; Priority=P1; Rank=2; CreateIfMissing=False; Summary=Direction shifted from broad multi-agent concept to practical Sew-first implementation. Lam is following up business process and requesting historical and technical Sew data. Focus includes Sew costing process, similar product history, construction complexity, sewing operations, time, labor, SMV if available, and expert judgement.}.Code)
- Phase: Analysis / Data Acquisition / Sew-first Implementation
- Executive Canvas lane: ANALYSIS
- Priority: P1
- Weekly priority rank: 2

Direction shifted from broad multi-agent concept to practical Sew-first implementation. Lam is following up business process and requesting historical and technical Sew data. Focus includes Sew costing process, similar product history, construction complexity, sewing operations, time, labor, SMV if available, and expert judgement.

Related Concepts
[[Outcome Driven Thinking]]
[[System Thinking]]
[[Data Governance]]
[[Traceability]]

Methods
[[Impact Analysis]]
[[Requirement Elicitation]]
[[Data Mapping]]

Deliverables
[[Decision_Driven_BRD]]
[[ERD_Template]]
[[User_Manual_Template]]

<!-- PPJ_WEEKLY_UPDATE_20260629_20260705_END -->

<!-- PPJ_WEEKLY_20261023_20261030_START -->
## Weekly Synchronization Event: PPJ-WEEKLY-20261023-20261030

### Verified movement

COMIT Wash Image Analysis Requirement v1.1 entered structured POC definition. Scope, responsibilities, data contract, expert review and proposed targets are documented. No trained model or POC result exists yet. Sew Agent has no new confirmed movement.

### Current gate

Wash/COMIT POC data-contract approval and expert-owned dataset

### Risks / blockers

- Taxonomy, metadata, annotation rules and expert-owned dataset are not frozen.
- Proposed targets and the expert-review fallback are not approved.
- A requirement document is not evidence of model training, accuracy or a successful POC.

### Decisions required

- Approve Wash/COMIT POC scope, dataset ownership, proposed targets and mandatory expert-review fallback.

### Next actions

- Freeze the Wash/COMIT taxonomy, metadata, annotation guide and data contract.
- Assign the expert-owned POC dataset and acceptance review gate.
- Keep all model targets labelled proposed until approved and tested.

### Traceability

- Report: [[10_Reports/PPJ_WEEKLY_PORTFOLIO_STATUS_20261030]]
- Decision gate: [[07_Decision_Log/DEC-WEEKLY-20261030-PORTFOLIO-GATES]]
- Last verified: 2026-10-30
- Confidence: Strong
<!-- PPJ_WEEKLY_20261023_20261030_END -->
