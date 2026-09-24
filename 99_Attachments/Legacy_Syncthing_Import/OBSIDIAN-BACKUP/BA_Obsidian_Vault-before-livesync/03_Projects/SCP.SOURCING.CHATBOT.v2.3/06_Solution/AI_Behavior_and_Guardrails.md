---
type: "ai_behavior_and_guardrails"
project: "SCP.SOURCING.CHATBOT.v2.3"
source_project: "SCP.SOURCING.CHATBOT.v2.3.md"
source_event: "PPJ-WEEKLY-20260727-20260801"
last_verified: "2026-08-01"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# AI Behavior and Guardrails

## AI Scope

Consolidated Sourcing data platform and chatbot for supplier, material, fabric, trims, and sample lookup.

## Required Controls

- Prompt / input contract: Needs Confirmation
- Output contract: Needs Confirmation
- Confidence representation: Required where model output is uncertain
- Human validation: Mandatory for decisions, transactions and sensitive outputs
- Fallback: Approved non-AI or human-review path
- Tool execution: Explicit permission, parameter validation and audit logging
- Permissions: Least privilege and project/domain access boundaries
- Auditability: Input, output, tool call, actor, timestamp and result status
- Hallucination control: Ground answers in approved knowledge and return Needs Confirmation when evidence is absent

## Prohibited Behavior

- Inventing business rules, owners, data or implementation status
- Executing unapproved transactions
- Bypassing permissions or human validation
- Presenting uncertain output as confirmed fact

## Evidence Basis

- Root project note: [[../SCP.SOURCING.CHATBOT.v2.3]]
- Project memory: [[03_Projects/_Registry/Project_Memory/SCP.SOURCING.CHATBOT.v2.3.memory]]
- Source event: PPJ-WEEKLY-20260727-20260801
- Last verified: 2026-08-01
- Confidence: Strong
