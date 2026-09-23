---
type: "ai_behavior_and_guardrails"
project: "PPJ.PERRI.Chatbot.v3.2"
source_project: "PPJ.PERRI.Chatbot.md"
source_event: "Canonical naming populated"
last_verified: "2026-07-13"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# AI Behavior and Guardrails

## AI Scope

Internal chatbot/orchestrator connecting users to knowledge base, APIs, tools, agents, and workflows.

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

- Root project note: [[../PPJ.PERRI.Chatbot]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PPJ.PERRI.Chatbot.v3.2.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-07-13
- Confidence: Strong
