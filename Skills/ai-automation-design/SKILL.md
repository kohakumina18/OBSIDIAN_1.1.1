---
name: ai-automation-design
description: Design pragmatic automations, RAG chatbots, OCR pipelines, rule engines, and AI agents with clear inputs, outputs, integration boundaries, human checks, exceptions, and measurable KPIs.
---
# AI and automation solution assessment

## Procedure
1. State the business trigger, user roles, problem frequency/volume and desired measurable outcome.
2. Diagram AS-IS and TO-BE. Identify what is deterministic and what requires interpretation/judgment.
3. Evaluate **simple rule/workflow first**, then OCR, matching, anomaly detection, LLM/RAG/agent only where justified.
4. Define input origin, validation, source of truth, integration path, decision rules, output, human-review checkpoints and audit trail.
5. For AI-supported steps, specify uncertainty/confidence handling, source evidence, human override and fallback. Do not invent confidence thresholds.
6. Include operational exceptions, security/permissions, observability, retries, duplicate prevention, KPI and acceptance criteria.
7. End with the smallest verifiable MVP and open decisions for business/data/dev/infra.

## Guardrails
- Never pretend to execute an API integration or to have verified an endpoint.
- Do not conflate rule-based automation with AI reasoning.
- Preserve traceability from an AI suggestion to source evidence and human confirmation.
