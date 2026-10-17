---
name: business-analysis
description: Draft or review concise business requirements documents, use cases, stakeholder questionnaires, AS-IS and TO-BE workflows, SOPs, or acceptance criteria from project notes.
---
# Business analysis

## Select only the relevant artifact
- **BRD:** context, problem, objective, stakeholders, scope/out-of-scope, AS-IS, pain points, TO-BE, requirements, business rules, human review, exception/fallback, outcomes, risks, dependencies and next steps. Keep system field/schema details out of the BRD.
- **Use Case:** ID/title, actor, trigger, preconditions/postconditions, user action vs. system response, main/alternative/exception paths, required data, business rules, AI behavior (if any), human review, fallback, acceptance criteria.
- **Questionnaire:** targeted questions that each resolve a business rule, data requirement, exception, KPI, owner, priority, or test case; avoid vague questions.
- **SOP/Manual:** user, starting conditions, one action per step with system response and expected result, common problems, do/don't, support; short enough for operational users.

## Procedure
1. Identify the audience and desired artifact; read supporting project notes.
2. Separate explicitly confirmed facts from assumptions and gaps.
3. Map AS-IS → pain points → TO-BE when useful, using Mermaid flowcharts for flows with decision points.
4. Make requirements testable and actions attributable to the right role/system.
5. Flag contradictions and avoid invented fields, deadlines, approvals, and integrations.
6. Provide a lean draft and an actionable validation list, not an encyclopedic report.
