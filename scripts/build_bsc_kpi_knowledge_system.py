from __future__ import annotations

import hashlib
import json
import shutil
from datetime import datetime
from pathlib import Path


VAULT = Path(__file__).resolve().parents[1]
BASE = VAULT / "03_Projects" / "Canvas" / "BSC_KPI_Performance_Assessment"
PRESENTATION = BASE / "Presentation"
MINDMAPS = BASE / "Mindmaps"
KNOWLEDGE = BASE / "Knowledge"
PAIN_NOTES = KNOWLEDGE / "Pain_Points"
REGISTERS = BASE / "Registers"
ASSETS = BASE / "Assets"
VALIDATION = BASE / "Validation"
BACKUP_ROOT = VAULT / "99_Attachments" / "Backups" / "BSC_KPI_Performance_Assessment"
BUILD_DATE = "2026-10-13"


def rel(path: Path) -> str:
    return path.relative_to(VAULT).as_posix()


def stable_id(prefix: str, *parts: object) -> str:
    raw = "|".join(str(p) for p in parts)
    return f"{prefix}-{hashlib.sha1(raw.encode('utf-8')).hexdigest()[:12]}"


def write_text(path: Path, content: str) -> bool:
    content = content.strip() + "\n"
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        old = path.read_text(encoding="utf-8-sig")
        if old.replace("\r\n", "\n") == content:
            return False
        if path.suffix == ".canvas":
            stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup = BACKUP_ROOT / stamp / path.relative_to(BASE)
            backup.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, backup)
    path.write_text(content, encoding="utf-8", newline="\n")
    return True


def write_json(path: Path, data: dict) -> bool:
    return write_text(path, json.dumps(data, ensure_ascii=False, indent=2))


def frontmatter(doc_type: str, title: str, status: str = "Business Discovery / Pre-BRD") -> str:
    return f'''---
type: {doc_type}
title: "{title}"
status: "{status}"
evidence_status: "MIXED - SEE SOURCE ASSESSMENT"
last_updated: {BUILD_DATE}
---'''


def canvas() -> dict:
    return {"nodes": [], "edges": []}


def add_text(c: dict, key: str, text: str, x: int, y: int, w: int, h: int, color: str = "") -> str:
    node_id = stable_id("n", key)
    node = {"id": node_id, "type": "text", "text": text, "x": x, "y": y, "width": w, "height": h}
    if color:
        node["color"] = color
    c["nodes"].append(node)
    return node_id


def add_file(c: dict, key: str, file_path: str, x: int, y: int, w: int, h: int, color: str = "") -> str:
    node_id = stable_id("f", key)
    node = {"id": node_id, "type": "file", "file": file_path, "x": x, "y": y, "width": w, "height": h}
    if color:
        node["color"] = color
    c["nodes"].append(node)
    return node_id


def add_group(c: dict, key: str, label: str, x: int, y: int, w: int, h: int, color: str = "") -> str:
    node_id = stable_id("g", key)
    node = {"id": node_id, "type": "group", "label": label, "x": x, "y": y, "width": w, "height": h}
    if color:
        node["color"] = color
    c["nodes"].append(node)
    return node_id


def add_edge(c: dict, key: str, source: str, target: str, label: str = "", color: str = "", from_side: str | None = None, to_side: str | None = None) -> str:
    edge_id = stable_id("e", key)
    edge = {"id": edge_id, "fromNode": source, "toNode": target}
    if label:
        edge["label"] = label
    if color:
        edge["color"] = color
    if from_side:
        edge["fromSide"] = from_side
    if to_side:
        edge["toSide"] = to_side
    c["edges"].append(edge)
    return edge_id


INDEX_LINK = "[[03_Projects/Canvas/BSC_KPI_Performance_Assessment/00_INDEX|BSC/KPI Index]]"
MASTER_LINK = "[[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/BSC_KPI_Enterprise_Master_Mindmap_v1_0.canvas|Master Mind Map]]"


def create_markdown() -> list[Path]:
    files: dict[Path, str] = {}

    files[BASE / "00_INDEX.md"] = f'''{frontmatter("knowledge-index", "PPJ BSC/KPI Performance Assessment")}

# PPJ GROUP - BSC, KPI & WORK PERFORMANCE MANAGEMENT

Business discovery and management presentation. This workspace is not a registered canonical PPJ project. Sponsor, Primary Domain, solution scope and approval to proceed remain **TO VERIFY / NOT APPROVED**.

## Start here

- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Presentation/BSC_KPI_Executive_Assessment_v1_0.canvas|01 - Executive Presentation (12 frames)]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/BSC_KPI_Enterprise_Master_Mindmap_v1_0.canvas|02 - Enterprise Master Mind Map]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/15_Source_Assessment_2026-10-13|03 - Source Assessment and evidence boundary]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Validation/VALIDATION_REPORT|04 - Validation Report]]

## Detailed maps

1. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/01_ASIS_Current_State.canvas|AS-IS Current State]]
2. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/02_Pain_Points_Impact.canvas|Pain Points and Impact]]
3. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/03_Root_Cause_Analysis.canvas|Root Cause Analysis]]
4. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/04_TOBE_Target_Process.canvas|TO-BE Target Process]]
5. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/05_SOP_JD_KPI_Relationships.canvas|SOP-JD-KPI Relationships]]
6. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/06_Performance_Hierarchy.canvas|Performance Hierarchy]]
7. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/07_Work_Done_Measurement.canvas|Work Done Measurement]]
8. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/08_Challenges_Gap_Analysis.canvas|Challenges and Gaps]]
9. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/09_Discovery_Plan.canvas|Discovery Plan]]
10. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/10_Requirements_Traceability.canvas|Requirements Traceability]]
11. [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/11_Management_Decisions.canvas|Management Decisions]]

## Registers

- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Evidence_Register|Evidence Register]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Pain_Point_Register|Pain Point Register]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Gap_Register|Gap Register]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Requirement_Register|Requirement Register]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Business_Rule_Candidates|Business Rule Candidates]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Risk_Register|Risk Register]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Open_Question_Register|Open Question Register]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Decision_Log|Decision Log]]
- [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Stakeholder_Map|Stakeholder Map]]

## Status legend

| Label | Meaning |
| --- | --- |
| CONFIRMED | Directly verified source existence or external reference |
| REPORTED | Present in supplied assessment or source note, not independently observed in operations |
| TO VERIFY | Requires source/system/process validation |
| PROPOSED | BA design direction only |
| NOT APPROVED | Requires management or process-owner decision |
'''

    files[KNOWLEDGE / "01_Business_Context.md"] = f'''{frontmatter("business-analysis", "Business Context")}

# Business Context

ID: CTX-001  
Category: Business Objective  
Status: **REPORTED / TO VERIFY**  
Business Area: Cross-enterprise performance management  
Stakeholder / Owner: **Unknown - to identify**  
Source Reference: [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Evidence_Register#SRC-001]] and [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Evidence_Register#SRC-003]]

## Context

The initiative explores how PPJ could connect corporate strategy, organizational responsibility, KPI definition, work assignment, accepted work done, evidence, review and management reporting.

## Current boundary

- Working status: **Business Discovery / Pre-BRD**.
- Existing operational facts about TOP BSC/KPI are reported, not independently verified.
- The 09/10/2026 blueprint is a proposed architecture, not an approved solution.
- No canonical project registration, sponsor, Primary Domain or implementation scope is confirmed in the current portfolio snapshot.

## Intended management outcomes

1. Separate task completion, accepted work done, KPI achievement and competency assessment.
2. Make every reported result traceable to definition, owner, source, period and evidence.
3. Preserve organizational roll-up without averaging incompatible units or double-counting cross-functional work.
4. Decide whether to improve TOP, extend it with integration/modules, or build a new target platform.

## Required validation

- Confirm sponsor, KPI governance owner and scope.
- Observe actual TOP configuration and reporting.
- Review representative SOP, JD, KPI and evidence samples.
- Validate organizational hierarchy and data-source ownership.

Related: {INDEX_LINK} | {MASTER_LINK}
'''

    files[KNOWLEDGE / "02_Executive_Findings.md"] = f'''{frontmatter("business-analysis", "Executive Findings")}

# Executive Findings

Status: **BA ASSESSMENT - NOT APPROVED**

| Finding | Evidence status | Management meaning |
| --- | --- | --- |
| Validate AS-IS before solution choice | REPORTED / TO VERIFY | Actual TOP capability and operational use are not yet evidenced |
| Standardize business definitions | PROPOSED | SOP, JD, responsibility, KPI and work done need common ownership and semantics |
| Verify measurement feasibility | PROPOSED | Each KPI requires calculable source, period, denominator, evidence and acceptance |
| Separate execution from effectiveness | PROPOSED | Completed tasks do not automatically prove KPI or business outcome achievement |
| Decide solution only after discovery | NOT APPROVED | Improve TOP vs extend vs build new remains open |

## Priority actions

1. **P0 - Validate AS-IS:** observe materially different work groups and the real TOP workflow.
2. **P0 - Standardize definitions:** confirm SOP/JD/KPI/Work Done ownership and lifecycle.
3. **P0 - Verify measurement:** test representative metrics against data and evidence.
4. **P1 - Evaluate options:** compare TOP improvement, integrated extension and new platform.
5. **P1 - Approve scope:** only after governance gaps and feasibility are understood.

Related: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Decision_Log|Decision Log]]
'''

    files[KNOWLEDGE / "03_ASIS_Current_State.md"] = f'''{frontmatter("current-process", "AS-IS Current State")}

# AS-IS Current State

ID: ASIS-001  
Status: **REPORTED / TO VERIFY**  
Source: user-supplied assessment baseline; direct transcript and system observation are unavailable.

## Reported process baseline

1. Department / manager identifies KPI.
2. KPI tree is configured in TOP.
3. Criteria are configured for individual employees.
4. Evaluation results are updated.
5. KPI results are consolidated by hierarchy.
6. Results are reported.

## Unverified inputs and links

- Relationship from SOP/JD/actual process to KPI definition.
- Source and acceptance criteria for work-done evidence.
- Reusable templates versus repetitive employee-by-employee configuration.
- Calculation formulas, weights, periods, approval and baseline versioning.
- System integrations and source-of-truth ownership.

## BA caution

This is a **reported operating model**, not a confirmed product capability inventory. It must not be used to conclude that TOP lacks a feature until WP01 reviews configuration, usage and available modules.

Related: {INDEX_LINK} | {MASTER_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Open_Question_Register|Open Questions]]
'''

    files[KNOWLEDGE / "04_Pain_Points_and_Impact.md"] = f'''{frontmatter("business-analysis", "Pain Points and Business Impact")}

# Pain Points and Business Impact

All pain points are **REPORTED / TO VERIFY**. They are not confirmed software deficiencies.

| ID | Pain point | Potential business impact | Verification |
| --- | --- | --- | --- |
| PP-001 | KPI definition inconsistency | Incomparable results; disputed targets | Sample KPI catalogue and approval trail |
| PP-002 | Limited evidence traceability | Results cannot be audited or explained | Trace one score to evidence and reviewer |
| PP-003 | Repetitive employee KPI configuration | Manual effort and configuration drift | Observe role/template configuration in TOP |
| PP-004 | Unclear SOP/JD/KPI mapping | KPI may not reflect real responsibility | Map representative SOPs, roles and KPIs |
| PP-005 | Work Done measurement difficulty | Task activity may be confused with accepted outcome | Test work units, acceptance and rework cases |

Detailed cards: [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/Pain_Points/PP-001_KPI_Definition_Inconsistency|PP-001]], [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/Pain_Points/PP-002_Evidence_Traceability|PP-002]], [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/Pain_Points/PP-003_Repetitive_Employee_KPI_Configuration|PP-003]], [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/Pain_Points/PP-004_SOP_JD_KPI_Mapping|PP-004]], [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/Pain_Points/PP-005_Work_Done_Measurement|PP-005]]

Related: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Pain_Point_Register|Pain Point Register]]
'''

    pain_data = [
        ("PP-001", "KPI Definition Inconsistency", "Reported definitions may vary by department or manager.", "Results may not be comparable and target disputes may arise.", "RC-001, RC-002, RC-005", "OQ-006", "REQ-001"),
        ("PP-002", "Limited Evaluation Evidence Traceability", "The assessment reports unclear links from evaluation result to evidence.", "Review, audit and appeals may rely on manual explanation.", "RC-003, RC-005", "OQ-008", "REQ-004"),
        ("PP-003", "Repetitive Employee KPI Configuration", "Employee KPI criteria may be configured repeatedly rather than inherited from governed role templates.", "Manual maintenance, drift and onboarding delay.", "RC-002, RC-004", "OQ-003", "REQ-003"),
        ("PP-004", "Unclear SOP/JD/KPI Mapping", "The relationship between actual process, SOP, role responsibility and KPI is not verified.", "KPIs may measure activities that do not represent accountable deliverables.", "RC-001, RC-002", "OQ-004", "REQ-002"),
        ("PP-005", "Work Done Measurement Difficulties", "Completed, accepted, rejected, reopened and blocked work may not be distinguished consistently.", "Execution can be overstated or combined incorrectly with performance outcomes.", "RC-003, RC-005, RC-006", "OQ-007", "REQ-005, REQ-007, REQ-008"),
    ]
    pain_names = [
        "PP-001_KPI_Definition_Inconsistency.md",
        "PP-002_Evidence_Traceability.md",
        "PP-003_Repetitive_Employee_KPI_Configuration.md",
        "PP-004_SOP_JD_KPI_Mapping.md",
        "PP-005_Work_Done_Measurement.md",
    ]
    for row, name in zip(pain_data, pain_names):
        pid, title, current, impact, causes, question, req = row
        files[PAIN_NOTES / name] = f'''{frontmatter("pain-point", f"{pid} - {title}", "TO VERIFY")}

# {pid} - {title}

ID: {pid}  
Category: Pain Point  
Status: **REPORTED / TO VERIFY**  
Priority: Proposed P0 discovery  
Business Area: Cross-enterprise performance management  
Stakeholder / Owner: To identify  
Source Reference: [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Evidence_Register#SRC-003]]  
Related Nodes: {causes}; {question}; {req}

## Current Situation

{current}

## Potential Business Impact

{impact}

## Evidence

Assessment baseline only. Direct system/process evidence is not yet available.

## Required Validation

- Observe a representative real case.
- Identify definition owner, approval, source and exceptions.
- Compare reported behavior with actual TOP configuration and SOP/JD records.

## Proposed Direction

Use discovery findings to confirm, amend or retire the linked requirement candidate. Do not treat this card as a confirmed defect.

Back: [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Mindmaps/02_Pain_Points_Impact.canvas|Pain Point Map]] | {MASTER_LINK} | {INDEX_LINK}
'''

    files[KNOWLEDGE / "05_Root_Cause_Hypotheses.md"] = f'''{frontmatter("root-cause-analysis", "Root Cause Hypotheses", "TO VERIFY")}

# Root Cause Hypotheses

These are analytical hypotheses, not confirmed findings.

| ID | Dimension | Hypothesis | Related pain points | Verification |
| --- | --- | --- | --- | --- |
| RC-001 | People | KPI ownership and accountability may be unclear | PP-001, PP-004 | RACI interviews and sample approvals |
| RC-002 | Process | KPI definition/configuration lifecycle may not be standardized | PP-001, PP-003, PP-004 | Walk through create-change-retire cycle |
| RC-003 | Data | Measurement source/evidence may be incomplete or inconsistent | PP-002, PP-005 | Trace samples to source and acceptance |
| RC-004 | System | TOP template/integration capability may be unused, missing or insufficient | PP-003 | Functional review; do not assume limitation |
| RC-005 | Governance | Baseline, approval, review and roll-up rules may not be governed | PP-001, PP-002, PP-005 | Review policies and period-close evidence |
| RC-006 | Measurement | Work units or attribution may be incompatible across teams | PP-005 | Test representative units and cross-functional cases |

Related: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Gap_Register|Gap Register]]
'''

    files[KNOWLEDGE / "06_TOBE_Target_Process.md"] = f'''{frontmatter("proposed-process", "TO-BE Target Process", "PROPOSED / NOT APPROVED")}

# TO-BE Target Process

Status: **PROPOSED / NOT APPROVED**

| Stage | Purpose | Primary actor to confirm | Input | Output | Key open rule |
| --- | --- | --- | --- | --- | --- |
| 01 SOP / Process | Define repeatable work | Process owner | Approved process | Controlled SOP | Who approves and versions? |
| 02 JD / Responsibility | Assign accountable responsibility | HR + business owner | SOP activities | Role responsibilities | How are cross-functional roles handled? |
| 03 KPI Definition | Define measurable expected result | KPI governance owner | Objective + responsibility | KPI definition | Formula/source/period/threshold? |
| 04 Work Assignment | Create baseline commitments | Manager / work owner | Plan + capacity | Assigned work | What enters denominator? |
| 05 Task Execution | Perform and update work | Member / contributor | Assigned work | Work result | Status and exception rules? |
| 06 Evidence Validation | Confirm deliverable and evidence | Reviewer | Submitted result | Accepted/rejected evidence | Who can accept? |
| 07 KPI Measurement | Calculate approved measures | Measurement engine + owner | Trusted source | KPI result | Missing/late data handling? |
| 08 Performance Review | Review context and exceptions | Manager | Results + evidence | Reviewed result | Appeal/override policy? |
| 09 Organizational Consolidation | Roll up compatible measures | Governance + system | Normalized results | Level summary | Attribution and double-count rules? |
| 10 Management Reporting | Explain execution and effectiveness | Management | Auditable summary | Decision support | Access and period-close policy? |

## Design principles

- Keep **workflow status**, **acceptance status**, **credited work**, **KPI achievement** and **competency assessment** separate.
- A proposed formula is not an approved policy.
- Use organizational and metric-effective dates.
- Preserve baseline versions, evidence, approvals and audit history.

Related: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Business_Rule_Candidates|Business Rules]]
'''

    files[KNOWLEDGE / "07_SOP_JD_KPI_Conceptual_Model.md"] = f'''{frontmatter("conceptual-model", "SOP-JD-KPI Conceptual Relationship Model", "PROPOSED / NOT APPROVED")}

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

Related: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Requirement_Register#REQ-002|REQ-002]]
'''

    files[KNOWLEDGE / "08_Performance_Hierarchy.md"] = f'''{frontmatter("conceptual-model", "Organizational Performance Hierarchy", "PROPOSED / TO VERIFY")}

# Organizational Performance Hierarchy

Proposed reporting path: **Member -> Team -> Department -> Division -> Echelon / Corporate**.

| Level | Primary management question | Do not assume |
| --- | --- | --- |
| Member | What was assigned, completed and accepted? | Self-declared done equals achievement |
| Team | What comparable committed workload was accepted? | Average of member percentages is valid |
| Department | How do teams contribute to objectives and delivery? | Different work units can be summed |
| Division | Which departments meet plan or carry risk? | KPI formulas are comparable without normalization |
| Echelon / Corporate | Are strategic objectives being achieved? | Task completion equals strategic effectiveness |

## Separate dimensions

- Work Completion
- Accepted Work Done
- Schedule Performance
- Quality Acceptance
- KPI / Objective Achievement
- Competency Assessment

Cross-functional contribution requires explicit attribution; reporting by home organization and business impact must not duplicate the same credited work.

Related: {INDEX_LINK} | [[Pasted image 20261012154322.png|Source image - hierarchy]]
'''

    files[KNOWLEDGE / "09_Work_Done_Measurement.md"] = f'''{frontmatter("measurement-concept", "Work Done and Measurement", "PROPOSED / NOT APPROVED")}

# Work Done and Measurement

Status: **CANDIDATE CONCEPTS / NOT APPROVED WORKFLOW STATES**

## Candidate lifecycle concepts

Assigned Work -> Planned / Baseline -> In Progress -> Submitted Deliverable -> Accepted Deliverable / Rework Required -> Reopened (with audit)

Exception concepts: Blocked, Cancel Request, Approved Baseline Change, Rejected, Cancelled.

## Measurement concepts requiring decision

- Baseline work unit and comparability.
- Partial acceptance rules.
- Deadline compliance and approved schedule changes.
- Quality validation and supporting evidence.
- Manager review and acceptance authority.
- Multiple contributors and contribution allocation.
- Rework/reopen treatment.
- Reporting period and period close.

## Proposed weighted completion pattern

`Weighted Completion = SUM(approved weight x accepted fraction) / SUM(approved weight)`

This pattern is only usable when weights and accepted fractions are governed and comparable within scope. It is not an approved PPJ formula.

## Explicit separation

`Task Completion != Employee Performance != Strategic KPI Achievement`

Related: {INDEX_LINK} | [[Pasted image 20261012103105.png|Source image - measurement table]] | [[Pasted image 20261012103244.png|Source image - lifecycle]]
'''

    files[KNOWLEDGE / "10_Data_System_Landscape.md"] = f'''{frontmatter("system-landscape", "Data and System Landscape", "TO VERIFY")}

# Data and System Landscape

Status: **CONCEPTUAL RELATIONSHIPS - INTEGRATION NOT CONFIRMED**

| Layer | Candidate systems / information | Required validation |
| --- | --- | --- |
| Business source | TOP BSC/KPI; SOP/JD repositories; HR/employee data; task systems; Jira; WFX ERP | Actual system ownership, coverage and APIs |
| Data / DWH | Identity mapping; organizational history; standardized work events; evidence metadata; KPI result history | Existing models, latency, quality and access |
| Target system | Org/KPI/work management; rules; measurement; roll-up; approval/audit; dashboards | Improve TOP vs extend vs build new |

## Rules

- Source of truth is defined per business object, not by convenience.
- Direct operational writes may stay in the target system; DWH supports governed integration and analytics.
- Every integration line remains **TO VERIFY** until source, owner, interface, frequency, security and reconciliation are evidenced.
- No field names, APIs, tables or current connection status are assumed.

Related: {INDEX_LINK} | [[Pasted image 20261012103312.png|Source image - proposed architecture]]
'''

    files[KNOWLEDGE / "11_Challenges_and_Risks.md"] = f'''{frontmatter("risk-analysis", "Challenges and Risks", "BA ASSESSMENT / TO VERIFY")}

# Challenges and Risks

| Dimension | Challenge | Potential risk | Verification | Mitigation direction |
| --- | --- | --- | --- | --- |
| People | Ownership and review responsibility unclear | Disputed definitions/results | RACI interviews | KPI governance role and approval workflow |
| Process | SOP/JD/KPI lifecycle inconsistent | Drift and manual rework | Sample lifecycle walkthrough | Controlled catalogue and effective dates |
| Data | Evidence/source quality unclear | Non-auditable scores | Source-to-result trace | Data ownership, quality and lineage |
| System | TOP capability/integration unverified | Duplicate build or infeasible scope | Functional/technical assessment | Options analysis before design |
| Governance | Measurement and roll-up rules unapproved | Bias, gaming, double counting | Golden-case calculations | Approved rules, baseline and period close |

Priority is a proposed BA assessment, not an official PPJ risk rating.

Related: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Risk_Register|Risk Register]]
'''

    files[KNOWLEDGE / "12_Discovery_and_Validation.md"] = f'''{frontmatter("discovery-plan", "Discovery and Validation Plan", "PROPOSED / NOT APPROVED")}

# Discovery and Validation Plan

No owner or deadline is assigned because neither is verified.

| WP | Objective | Evidence required | Expected deliverable | Dependency |
| --- | --- | --- | --- | --- |
| WP01 TOP System Review | Confirm real capability and usage | Screens, config, reports, roles, module list | AS-IS capability matrix | System access and product owner |
| WP02 SOP/JD Review | Validate responsibility foundations | Representative SOPs/JDs and versions | SOP-role-responsibility map | Process and HR owners |
| WP03 KPI Definition Assessment | Test KPI definition quality | KPI catalogue, formulas, targets, approvals | KPI definition/gap report | KPI governance owner |
| WP04 Work Done & Data Discovery | Trace work and evidence | Task/evidence samples, sources, history | Measurement feasibility report | Data/task owners |
| WP05 TO-BE Validation | Validate process and exceptions | Workshops and golden cases | Approved business process candidate | WP01-WP04 |
| WP06 Solution Feasibility | Compare solution options | TOP capability, architecture, cost/security | Option assessment and recommendation | Validated requirements |

## Minimum golden cases

- Routine individual work with clear acceptance.
- Cross-functional work with multiple contributors.
- Rejected/reopened deliverable.
- Blocked work and approved baseline change.
- KPI with external source and late/missing evidence.
- Roll-up across incompatible measures to demonstrate why normalization is required.

Related: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Open_Question_Register|Open Questions]]
'''

    files[KNOWLEDGE / "13_Management_Decisions.md"] = f'''{frontmatter("decision-analysis", "Management Decisions", "PENDING")}

# Management Decisions

No management decision is marked as made in the available evidence.

| Decision topic | Status | Evidence needed before decision |
| --- | --- | --- |
| Business Sponsor | PENDING | Scope and accountable executive |
| KPI Governance Owner | PENDING | Governance operating model |
| Discovery Scope | PENDING | Functions, entities and user groups |
| Performance Measurement Scope | PENDING | Task, KPI, competency and reward boundaries |
| SOP/JD Standardization Responsibility | PENDING | HR/process/business ownership |
| Current TOP System Assessment | PENDING | WP01 capability evidence |
| Data Integration Feasibility | PENDING | Source/owner/interface/security assessment |
| Improve TOP vs Extend vs Build New | PENDING | Requirement and option assessment |
| Approval to Proceed to Solution Design | NOT APPROVED | Validated AS-IS, gaps, requirements and recommendation |

Related: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Decision_Log|Decision Log]]
'''

    files[KNOWLEDGE / "14_Traceability_Model.md"] = f'''{frontmatter("traceability-model", "Requirements Traceability Model", "ACTIVE BA CONTROL")}

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

Related: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Requirement_Register|Requirement Register]]
'''

    files[KNOWLEDGE / "15_Source_Assessment_2026-10-13.md"] = f'''{frontmatter("source-assessment", "Source Assessment 2026-10-13", "CURRENT AS OF BUILD DATE")}

# Source Assessment - 2026-10-13

## Inspected local sources

- `01_Daily_Notes/DATA/YOGA-NOTES.canvas`: contains a long node titled **Thiết kế phần mềm Enterprise Task Performance Management**, dated 09/10/2026, plus referenced images. Classification: **proposal / design artifact**.
- `Pasted image 20261012102959.png` through `Pasted image 20261012103312.png`, and related 12/10 images: framework tables and proposed diagrams. Classification: **proposal / research artifact**.
- User-supplied ULTRA MASTER PROMPT: required structure and reported assessment baseline. Classification: **implementation brief**, not independent business evidence.
- `03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT.md`: no canonical BSC/KPI performance-management project identified. Classification: **current portfolio registry baseline**.
- `03_Projects/_Registry/PPJ_PORTFOLIO_DOMAIN_MODEL.md`: no confirmed Primary Domain assignment for this cross-enterprise initiative. Classification: **governance baseline**.

## Missing or unavailable sources

- October 12, 2026 meeting transcript: **NOT FOUND / NOT INSPECTED**.
- Direct TOP BSC/KPI system access, screens, configuration or exports: **NOT AVAILABLE**.
- Approved KPI policy, SOP/JD mapping, formulas, weights, scorecards, owners and period-close policy: **NOT AVAILABLE**.

## External reference verification

- ISO 21508:2026 is published and provides EVM guidance; it does not prescribe a PPJ task-score formula: https://www.iso.org/standard/87899.html
- ISO 21511:2018 provides WBS guidance; a revision is in progress, so version applicability should be rechecked at design approval: https://www.iso.org/obp/ui#iso:std:iso:21511:ed-1:v1:en
- ISO 30414:2025 addresses human capital reporting/disclosure; it does not by itself approve the proposed task/KPI model: https://www.iso.org/standard/69338.html
- Balanced Scorecard Institute materials describe cascading/alignment to organizational units, teams and individuals: https://balancedscorecard.org/wp-content/uploads/2019/10/CascadingTheBalancedScorecard_BSI.pdf

## Evidence boundary

The Canvas distinguishes reported current state, analytical hypotheses, proposed design and pending decisions. The reported operating baseline is **not independently verified**. No missing transcript quote, timestamp, TOP feature, API, database field, formula weight, project owner or approval has been invented.

Related: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Evidence_Register|Evidence Register]]
'''

    files[REGISTERS / "Evidence_Register.md"] = f'''{frontmatter("evidence-register", "Evidence Register")}

# Evidence Register

| ID | Source | Type | Status | Supports | Limitation |
| --- | --- | --- | --- | --- | --- |
| SRC-001 | [[01_Daily_Notes/DATA/YOGA-NOTES.canvas|YOGA-NOTES Canvas]] - 09/10 blueprint node | Local design artifact | INSPECTED | Proposed architecture, metrics, lifecycle | Not approved business requirement |
| SRC-002 | [[Pasted image 20261012102959.png]] to [[Pasted image 20261012103312.png]] and related 12/10 images | Local visual artifact | INSPECTED | Proposed tables and diagrams | Does not prove current operation |
| SRC-003 | User-supplied ULTRA MASTER PROMPT and screenshots, 13/10/2026 | Implementation brief | RECEIVED | Reported AS-IS, pain points, required outputs | Not independent verification |
| SRC-004 | [[03_Projects/_Registry/PPJ_PORTFOLIO_CURRENT_SNAPSHOT|Portfolio Current Snapshot]] | Registry | INSPECTED | No canonical project found | Snapshot does not prove initiative absence outside registry |
| SRC-005 | [[03_Projects/_Registry/PPJ_PORTFOLIO_DOMAIN_MODEL|Portfolio Domain Model]] | Governance | INSPECTED | Domain assignment rules | No new domain assigned |
| SRC-006 | October 12, 2026 internal meeting transcript | Expected source | NOT FOUND | Reported AS-IS and decisions | Quotes/timestamps cannot be used |
| SRC-007 | ISO 21508:2026 official page | External standard reference | VERIFIED 2026-10-13 | EVM guidance reference | Not a PPJ scoring formula |
| SRC-008 | ISO 21511:2018 official OBP page | External standard reference | VERIFIED 2026-10-13 | WBS guidance reference | Revision in progress; check at design approval |
| SRC-009 | ISO 30414:2025 official page | External standard reference | VERIFIED 2026-10-13 | Human capital reporting context | Not task scoring approval |
| SRC-010 | Balanced Scorecard Institute cascading guide | External framework reference | VERIFIED 2026-10-13 | Alignment/cascading context | PPJ implementation remains to design |

Back: {INDEX_LINK}
'''

    files[REGISTERS / "Pain_Point_Register.md"] = f'''{frontmatter("pain-point-register", "Pain Point Register", "REPORTED / TO VERIFY")}

# Pain Point Register

| ID | Pain Point | Status | Impact | Hypothesis | Open Question | Discovery | Requirement |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PP-001 | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/Pain_Points/PP-001_KPI_Definition_Inconsistency|KPI Definition Inconsistency]] | TO VERIFY | Incomparable/disputed results | RC-001, RC-002, RC-005 | OQ-006 | WP03 | REQ-001 |
| PP-002 | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/Pain_Points/PP-002_Evidence_Traceability|Limited Evidence Traceability]] | TO VERIFY | Weak auditability | RC-003, RC-005 | OQ-008 | WP04 | REQ-004 |
| PP-003 | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/Pain_Points/PP-003_Repetitive_Employee_KPI_Configuration|Repetitive Employee KPI Configuration]] | TO VERIFY | Manual effort and drift | RC-002, RC-004 | OQ-003 | WP01 | REQ-003 |
| PP-004 | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/Pain_Points/PP-004_SOP_JD_KPI_Mapping|Unclear SOP/JD/KPI Mapping]] | TO VERIFY | Misaligned measurement | RC-001, RC-002 | OQ-004 | WP02 | REQ-002 |
| PP-005 | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/Pain_Points/PP-005_Work_Done_Measurement|Work Done Measurement Difficulty]] | TO VERIFY | Over/understated execution | RC-003, RC-005, RC-006 | OQ-007 | WP04 | REQ-005, REQ-007, REQ-008 |

Back: {INDEX_LINK}
'''

    files[REGISTERS / "Gap_Register.md"] = f'''{frontmatter("gap-register", "Gap Register", "TO VERIFY")}

# Gap Register

| ID | Gap | Status | Verification / closure |
| --- | --- | --- | --- |
| GAP-001 | Sponsor, business owner and KPI governance owner not confirmed | OPEN | DEC-001, DEC-002 |
| GAP-002 | Actual TOP functionality/configuration/use not assessed | OPEN | WP01 |
| GAP-003 | SOP/JD repository, versioning and ownership not verified | OPEN | WP02 |
| GAP-004 | KPI definition, formula, target and approval catalogue not available | OPEN | WP03 |
| GAP-005 | Evidence source, acceptance and data quality not verified | OPEN | WP04 |
| GAP-006 | Organization hierarchy/effective-date rules not verified | OPEN | WP02/WP04 |
| GAP-007 | Work unit, baseline, partial acceptance and rework policy not approved | OPEN | WP04/WP05 |
| GAP-008 | Integration/source-of-truth feasibility not assessed | OPEN | WP06 |
| GAP-009 | October 12 transcript unavailable | OPEN | Obtain source or document replacement evidence |
| GAP-010 | Improve TOP vs extend vs build new not evaluated | OPEN | WP06 and DEC-008 |

Back: {INDEX_LINK}
'''

    files[REGISTERS / "Requirement_Register.md"] = f'''{frontmatter("requirement-register", "Requirement Register", "CANDIDATE / NOT APPROVED")}

# Requirement Register

| ID | Requirement Candidate | Status | Source / rationale | Validation gate |
| --- | --- | --- | --- | --- |
| REQ-001 | Governed KPI catalogue with definition, formula, source, owner, period, target and version | CANDIDATE | PP-001 | WP03 |
| REQ-002 | Traceable process-SOP-role-JD-responsibility-KPI mapping | CANDIDATE | PP-004 | WP02/WP05 |
| REQ-003 | Reusable role/template-based KPI assignment with governed exceptions | CANDIDATE | PP-003 | WP01/WP03 |
| REQ-004 | Evidence metadata and source-to-result traceability | CANDIDATE | PP-002 | WP04 |
| REQ-005 | Submission, review, accept/reject/reopen workflow with audit | CANDIDATE | PP-005 | WP04/WP05 |
| REQ-006 | Versioned baseline scope, weight and deadline with approval | CANDIDATE | RC-005 | WP04/WP05 |
| REQ-007 | Separate workflow, acceptance, credited work, KPI and competency dimensions | CANDIDATE | PP-005 | WP05 |
| REQ-008 | Roll-up only across compatible/normalized measures | CANDIDATE | RC-006 | Golden calculation |
| REQ-009 | Contribution attribution and no double counting | CANDIDATE | RISK-002 | Cross-functional golden case |
| REQ-010 | Period close, snapshot, history and authorized adjustment | CANDIDATE | RC-005 | WP05 |
| REQ-011 | Source inventory, ownership, quality and integration controls | CANDIDATE | GAP-008 | WP06 |
| REQ-012 | Role-based dashboards with drill-down to definition, evidence and exceptions | CANDIDATE | Management need | WP05/WP06 |

Back: {INDEX_LINK} | [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Knowledge/14_Traceability_Model|Traceability Model]]
'''

    files[REGISTERS / "Business_Rule_Candidates.md"] = f'''{frontmatter("business-rule-register", "Business Rule Candidates", "PROPOSED / NOT APPROVED")}

# Business Rule Candidates

| ID | Candidate business rule | Status |
| --- | --- | --- |
| BR-001 | Each task has an accountable owner and belongs to an identified work package/backlog | PROPOSED |
| BR-002 | Completion credit is recorded only after defined acceptance | PROPOSED |
| BR-003 | Baseline scope, weight and deadline require approval | PROPOSED |
| BR-004 | Reject/reopen/change events recalculate results and preserve history | PROPOSED |
| BR-005 | The same work is not counted twice across contributors or KPIs | PROPOSED |
| BR-006 | Blocked work is not automatically removed from the baseline | PROPOSED |
| BR-007 | Baseline changes require approval and versioning | PROPOSED |
| BR-008 | Percentages are not averaged when units or denominators are incompatible | PROPOSED |
| BR-009 | Aggregated results drill down to KPI/task definition and evidence | PROPOSED |
| BR-010 | Period close stores an auditable snapshot and confirmer | PROPOSED |

Source: [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/Registers/Evidence_Register#SRC-001|SRC-001]]. These rules require WP05 validation and management approval.

Back: {INDEX_LINK}
'''

    files[REGISTERS / "Risk_Register.md"] = f'''{frontmatter("risk-register", "Risk Register", "BA ASSESSMENT / TO VERIFY")}

# Risk Register

| ID | Risk | Potential impact | Verification | Mitigation direction | Proposed priority |
| --- | --- | --- | --- | --- | --- |
| RISK-001 | Average of incompatible percentages | Misleading roll-up | Golden calculation | REQ-008 / BR-008 | P0 |
| RISK-002 | Double counting cross-functional contribution | Inflated results | Multi-contributor case | REQ-009 / BR-005 | P0 |
| RISK-003 | Self-declared Done treated as accepted result | Overstated work completion | Review sample lifecycle | REQ-005 / BR-002 | P0 |
| RISK-004 | Baseline changed without version/approval | Moving targets and non-auditable scores | Baseline history review | REQ-006 / BR-007 | P0 |
| RISK-005 | Integration assumed but unavailable | Cost/schedule failure | WP06 technical assessment | REQ-011 | P1 |
| RISK-006 | Excessive visibility of employee/performance data | Privacy and employee-relations exposure | Permission/privacy review | Role-based access and audit | P0 |
| RISK-007 | Task completion conflated with performance/KPI/competency | Unfair decisions and gaming | Policy review | REQ-007 | P0 |

Priority is a proposed BA assessment, not an official PPJ rating.

Back: {INDEX_LINK}
'''

    files[REGISTERS / "Open_Question_Register.md"] = f'''{frontmatter("open-question-register", "Open Question Register", "OPEN")}

# Open Question Register

| ID | Question | Work Package | Decision / Requirement |
| --- | --- | --- | --- |
| OQ-001 | Who is the business sponsor and accountable KPI governance owner? | WP05 | DEC-001/002 |
| OQ-002 | Which entities/functions/user groups are in discovery scope? | WP05 | DEC-003 |
| OQ-003 | Does TOP support governed KPI templates/inheritance and exceptions? | WP01 | REQ-003 |
| OQ-004 | Where are authoritative SOPs/JDs and who versions them? | WP02 | REQ-002 |
| OQ-005 | Who defines and approves KPI formulas, sources, targets and weights? | WP03 | REQ-001 |
| OQ-006 | How inconsistent are KPI definitions in representative samples? | WP03 | PP-001 |
| OQ-007 | What constitutes accepted Work Done for different work types? | WP04 | REQ-005/006 |
| OQ-008 | Can a reported score be traced to source, evidence, reviewer and period? | WP04 | REQ-004 |
| OQ-009 | How are blocked, cancelled, rejected and reopened work treated? | WP04/WP05 | BR-004/006 |
| OQ-010 | How are contributors and cross-functional impact attributed? | WP04/WP05 | REQ-009 |
| OQ-011 | Which sources feed HR, task, WFX, Jira, TOP and DWH data? | WP06 | REQ-011 |
| OQ-012 | Which metrics can be aggregated directly; which require normalization? | WP04/WP05 | REQ-008 |
| OQ-013 | How are privacy, permissions, appeal and correction controlled? | WP05/WP06 | RISK-006 |
| OQ-014 | What are TOP licensing, extension and integration constraints? | WP01/WP06 | DEC-008 |
| OQ-015 | What evidence is sufficient to approve solution design? | WP05/WP06 | DEC-009 |

Back: {INDEX_LINK}
'''

    files[REGISTERS / "Decision_Log.md"] = f'''{frontmatter("decision-log", "Decision Log", "PENDING")}

# Decision Log

No decision is recorded as confirmed in the available evidence.

| ID | Decision Topic | Status | Evidence required | Next gate |
| --- | --- | --- | --- | --- |
| DEC-001 | Business Sponsor | PENDING | Management confirmation | Name accountable sponsor |
| DEC-002 | KPI Governance Owner | PENDING | Governance model | Assign owner and deputies |
| DEC-003 | Discovery Scope | PENDING | Candidate functions/entities | Approve scope |
| DEC-004 | Performance Measurement Scope | PENDING | Task/KPI/competency/reward boundaries | Approve inclusions/exclusions |
| DEC-005 | SOP/JD Standardization Responsibility | PENDING | HR/process/business RACI | Approve responsibility |
| DEC-006 | Current TOP System Assessment | PENDING | WP01 report | Accept capability baseline |
| DEC-007 | Data Integration Feasibility | PENDING | WP06 assessment | Approve feasible integration boundary |
| DEC-008 | Improve TOP vs Extend vs Build New | PENDING | Option comparison | Select direction |
| DEC-009 | Proceed to Solution Design | NOT APPROVED | Validated AS-IS, requirements, risks and recommendation | Management approval |

Back: {INDEX_LINK}
'''

    files[REGISTERS / "Stakeholder_Map.md"] = f'''{frontmatter("stakeholder-map", "Stakeholder Map", "TO IDENTIFY")}

# Stakeholder Map

No personal owner names are inferred.

| Stakeholder group | Needed role | Evidence / decision participation | Status |
| --- | --- | --- | --- |
| Management / Executive sponsor | Sponsor, scope and investment decision | DEC-001, DEC-003, DEC-008, DEC-009 | TO IDENTIFY |
| KPI Governance / Strategy | KPI policy and cascade ownership | WP03, DEC-002 | TO IDENTIFY |
| HR / Organization Master | Org hierarchy, JD, employee data, privacy | WP02, WP06 | TO IDENTIFY |
| Department Heads / Managers | Define/approve objectives, work and results | WP03-WP05 | TO IDENTIFY |
| Members / Contributors | Execute work and submit evidence | WP04-WP05 | TO IDENTIFY |
| SOP / Process Owners | Process and responsibility source | WP02 | TO IDENTIFY |
| TOP Application Owner / Vendor | Capability/configuration/integration evidence | WP01/WP06 | TO IDENTIFY |
| IT / Architecture / Security | Technical feasibility, access and audit | WP06 | TO IDENTIFY |
| Data / DWH Owners | Source, lineage, quality, history | WP04/WP06 | TO IDENTIFY |
| Review / Audit / Employee Relations | Fairness, correction, appeal and audit | WP05 | TO IDENTIFY |

Back: {INDEX_LINK}
'''

    files[ASSETS / "Source_Asset_Index.md"] = f'''{frontmatter("asset-index", "Source Asset Index")}

# Source Asset Index

The original images remain in the vault root to preserve existing references. They are reused by file nodes; no binary copies were made.

| Asset | Content | Classification |
| --- | --- | --- |
| [[Pasted image 20261012102959.png]] | Org / Goal / Work trees | PROPOSED |
| [[Pasted image 20261012103026.png]] | Framework reference table | RESEARCH / PROPOSED APPLICATION |
| [[Pasted image 20261012103105.png]] | Measurement table and formula | PROPOSED |
| [[Pasted image 20261012103134.png]] | Initial business-rule table | PROPOSED |
| [[Pasted image 20261012103208.png]] | Functional module table | PROPOSED |
| [[Pasted image 20261012103244.png]] | Task lifecycle | PROPOSED |
| [[Pasted image 20261012103312.png]] | Business source to DWH to target architecture | PROPOSED |
| [[Pasted image 20261012154322.png]] | Organizational hierarchy | PROPOSED |

Back: {INDEX_LINK}
'''

    changed: list[Path] = []
    for path, content in files.items():
        if write_text(path, content):
            changed.append(path)
    return changed


def create_presentation() -> Path:
    c = canvas()
    frame_w, frame_h = 1800, 1080
    gap_x, gap_y = 160, 180
    cards = [
        ("01", "PROJECT CONTEXT", "# 01. Project Context\n\n**Status:** Business Discovery / Pre-BRD\n\nConnect strategy, responsibility, KPI, accepted work, evidence and reporting.\n\n**Boundary:** no registered canonical project; sponsor and Primary Domain TO VERIFY.", "5", "Knowledge/01_Business_Context.md"),
        ("02", "EXECUTIVE FINDINGS", "# 02. Executive Findings\n\n1. Validate AS-IS\n2. Standardize definitions\n3. Verify measurement feasibility\n4. Evaluate solution options\n5. Approve scope after evidence\n\n**BA assessment - NOT APPROVED**", "6", "Knowledge/02_Executive_Findings.md"),
        ("03", "AS-IS BUSINESS PROCESS", "# 03. AS-IS Business Process\n\nDepartment/Manager defines KPI\n-> TOP KPI tree\n-> Employee criteria\n-> Update evaluation result\n-> Hierarchical consolidation\n-> Report\n\n**REPORTED / TO VERIFY**", "4", "Knowledge/03_ASIS_Current_State.md"),
        ("04", "CURRENT SYSTEM LANDSCAPE", "# 04. Current System Landscape\n\nBusiness sources: TOP, SOP/JD, HR, task systems, Jira, WFX\n\nData layer: DWH / history / identity\n\nTarget: management, rules, approval, dashboard\n\nAll integrations **TO VERIFY**", "5", "Knowledge/10_Data_System_Landscape.md"),
        ("05", "PAIN POINTS AND IMPACT", "# 05. Pain Points & Impact\n\nPP-001 KPI inconsistency\nPP-002 Evidence traceability\nPP-003 Repetitive configuration\nPP-004 SOP/JD/KPI mapping\nPP-005 Work Done measurement\n\n**REPORTED / TO VERIFY**", "1", "Knowledge/04_Pain_Points_and_Impact.md"),
        ("06", "ROOT CAUSE HYPOTHESES", "# 06. Root Cause Hypotheses\n\n**People:** ownership\n**Process:** lifecycle\n**Data:** source/evidence\n**System:** capability/integration\n**Governance:** baseline/roll-up\n\nHypotheses require verification.", "2", "Knowledge/05_Root_Cause_Hypotheses.md"),
        ("07", "AS-IS VS TO-BE", "# 07. AS-IS vs TO-BE\n\n| Reported AS-IS | Proposed TO-BE |\n| --- | --- |\n| Manual configuration | Governed templates |\n| Unclear evidence | Source-to-result trace |\n| KPI tree/report | Separate execution and effectiveness |\n| Unknown integrations | Validated source ownership |", "3", "Knowledge/06_TOBE_Target_Process.md"),
        ("08", "PROPOSED TO-BE WORKFLOW", "# 08. Proposed TO-BE Workflow\n\nSOP -> JD/Responsibility -> KPI -> Work Assignment -> Execution -> Evidence -> Measurement -> Review -> Roll-up -> Reporting\n\n**PROPOSED / NOT APPROVED**", "4", "Knowledge/06_TOBE_Target_Process.md"),
        ("09", "PERFORMANCE HIERARCHY", "# 09. Organizational Performance Hierarchy\n\nMember -> Team -> Department -> Division -> Echelon / Corporate\n\nDo not average incompatible percentages. Do not double count contribution.\n\n**PROPOSED / TO VERIFY**", "6", "Knowledge/08_Performance_Hierarchy.md"),
        ("10", "CHALLENGES AND RISKS", "# 10. Challenges & Risks\n\nPeople | Process | Data | System | Governance\n\nP0 themes: incompatible roll-up, double count, unaccepted work, baseline drift, privacy.\n\nPriority is a BA assessment.", "1", "Knowledge/11_Challenges_and_Risks.md"),
        ("11", "DISCOVERY AND VALIDATION", "# 11. Discovery & Validation Plan\n\nWP01 TOP review\nWP02 SOP/JD review\nWP03 KPI assessment\nWP04 Work Done/data\nWP05 TO-BE validation\nWP06 Solution feasibility\n\nNo invented owner or deadline.", "3", "Knowledge/12_Discovery_and_Validation.md"),
        ("12", "MANAGEMENT DECISIONS", "# 12. Management Decisions\n\nSponsor | Governance owner | Discovery scope | Measurement scope | SOP/JD responsibility | TOP assessment | Integration | Improve/Extend/Build | Proceed to design\n\n**All PENDING / NOT APPROVED**", "6", "Knowledge/13_Management_Decisions.md"),
    ]
    node_by_frame: dict[str, str] = {}
    submaps = {
        "03": "Mindmaps/01_ASIS_Current_State.canvas",
        "04": "Mindmaps/10_Requirements_Traceability.canvas",
        "05": "Mindmaps/02_Pain_Points_Impact.canvas",
        "06": "Mindmaps/03_Root_Cause_Analysis.canvas",
        "07": "Mindmaps/10_Requirements_Traceability.canvas",
        "08": "Mindmaps/04_TOBE_Target_Process.canvas",
        "09": "Mindmaps/06_Performance_Hierarchy.canvas",
        "10": "Mindmaps/08_Challenges_Gap_Analysis.canvas",
        "11": "Mindmaps/09_Discovery_Plan.canvas",
        "12": "Mindmaps/11_Management_Decisions.canvas",
    }
    images = {
        "02": "Pasted image 20261012103026.png",
        "04": "Pasted image 20261012103312.png",
        "08": "Pasted image 20261012103244.png",
        "09": "Pasted image 20261012154322.png",
    }
    for idx, (num, label, text_value, color, note_suffix) in enumerate(cards):
        row, col = divmod(idx, 4)
        x = col * (frame_w + gap_x)
        y = row * (frame_h + gap_y)
        add_group(c, f"presentation-frame-{num}", f"{num} - {label}", x, y, frame_w, frame_h, color)
        body_w = 1020 if num in images else 1640
        node_by_frame[num] = add_text(c, f"presentation-body-{num}", text_value, x + 80, y + 80, body_w, 720, color)
        if num in images:
            add_file(c, f"presentation-image-{num}", images[num], x + 1160, y + 90, 560, 700)
        note_path = rel(BASE / note_suffix)
        add_file(c, f"presentation-note-{num}", note_path, x + 80, y + 850, 760, 150)
        if num in submaps:
            add_file(c, f"presentation-submap-{num}", rel(BASE / submaps[num]), x + 900, y + 850, 820, 150, color)
    master = add_file(c, "presentation-master-link", rel(MINDMAPS / "BSC_KPI_Enterprise_Master_Mindmap_v1_0.canvas"), 900, 850, 820, 150, "5")
    add_edge(c, "presentation-to-master", node_by_frame["01"], master, "open master analysis", "5", "bottom", "top")
    return PRESENTATION / "BSC_KPI_Executive_Assessment_v1_0.canvas", c


def create_master() -> tuple[Path, dict]:
    c = canvas()
    center = add_text(c, "master-center", "# PPJ GROUP\n## BSC, KPI & WORK PERFORMANCE MANAGEMENT\n\n**Business Discovery / Pre-BRD**\n\nCONFIRMED source presence | REPORTED AS-IS | TO VERIFY gaps | PROPOSED design | NOT APPROVED decisions", 0, 0, 900, 520, "5")
    branches = [
        ("A", "BUSINESS CONTEXT", -2200, -1500, "Knowledge/01_Business_Context.md", "Purpose, scope, stakeholders, evidence boundary", "5"),
        ("B", "AS-IS CURRENT STATE", -2200, -700, "Mindmaps/01_ASIS_Current_State.canvas", "TOP process, SOP/JD, configuration and missing facts", "4"),
        ("C", "PAIN POINTS", -2200, 100, "Mindmaps/02_Pain_Points_Impact.canvas", "PP-001 to PP-005 with impact and verification", "1"),
        ("D", "ROOT CAUSES", -2200, 900, "Mindmaps/03_Root_Cause_Analysis.canvas", "People, Process, Data, System, Governance hypotheses", "2"),
        ("E", "TO-BE PROCESS", 1900, -1500, "Mindmaps/04_TOBE_Target_Process.canvas", "SOP to reporting; proposed and unapproved", "4"),
        ("F", "SOP / JD / KPI", 1900, -700, "Mindmaps/05_SOP_JD_KPI_Relationships.canvas", "Conceptual many-to-many responsibility model", "4"),
        ("G", "PERFORMANCE HIERARCHY", 1900, 100, "Mindmaps/06_Performance_Hierarchy.canvas", "Member to Echelon; contribution and roll-up", "6"),
        ("H", "WORK DONE", 1900, 900, "Mindmaps/07_Work_Done_Measurement.canvas", "Lifecycle, evidence, acceptance and measurement", "3"),
        ("I", "DATA AND SYSTEMS", -1500, 1900, "Knowledge/10_Data_System_Landscape.md", "TOP, SOP/JD, HR, Jira, WFX, DWH, target system", "5"),
        ("J", "CHALLENGES AND RISKS", -500, 1900, "Mindmaps/08_Challenges_Gap_Analysis.canvas", "Impact, risk, verification and mitigation", "1"),
        ("K", "DISCOVERY", 500, 1900, "Mindmaps/09_Discovery_Plan.canvas", "WP01-WP06; no invented owners/dates", "3"),
        ("L", "MANAGEMENT DECISIONS", 1500, 1900, "Mindmaps/11_Management_Decisions.canvas", "Pending decisions and evidence gates", "6"),
    ]
    nodes = {}
    for code, title, x, y, path_suffix, summary, color in branches:
        add_group(c, f"master-group-{code}", f"BRANCH {code} - {title}", x, y, 900, 620, color)
        nodes[code] = add_text(c, f"master-{code}", f"## {code}. {title}\n\n{summary}\n\n**Open linked detail**", x + 60, y + 60, 780, 280, color)
        path = BASE / path_suffix
        add_file(c, f"master-file-{code}", rel(path), x + 60, y + 380, 780, 150, color)
        add_edge(c, f"master-center-{code}", center, nodes[code], "contains", color)
    trace = add_file(c, "master-traceability", rel(MINDMAPS / "10_Requirements_Traceability.canvas"), -450, 1020, 900, 240, "6")
    add_edge(c, "master-center-trace", center, trace, "source-to-decision trace", "6", "bottom", "top")
    legend = add_text(c, "master-legend", "## STATUS LEGEND\n\n**CONFIRMED** source/reference verified\n**REPORTED** supplied but not independently verified\n**TO VERIFY** discovery required\n**PROPOSED** BA design direction\n**NOT APPROVED** management/process-owner decision required", -450, -820, 900, 520, "3")
    return MINDMAPS / "BSC_KPI_Enterprise_Master_Mindmap_v1_0.canvas", c


def submap_header(c: dict, key: str, title: str, subtitle: str, color: str) -> str:
    add_group(c, f"{key}-group", title.upper(), -120, -160, 3320, 2100, color)
    return add_text(c, f"{key}-title", f"# {title}\n\n{subtitle}\n\n**Status labels are part of the content; color is not the only status signal.**", 0, 0, 3000, 250, color)


def add_back_links(c: dict, key: str, y: int = 1700) -> None:
    add_file(c, f"{key}-master-back", rel(MINDMAPS / "BSC_KPI_Enterprise_Master_Mindmap_v1_0.canvas"), 0, y, 850, 140, "5")
    add_file(c, f"{key}-index-back", rel(BASE / "00_INDEX.md"), 950, y, 850, 140, "5")


def create_submaps() -> list[tuple[Path, dict]]:
    result: list[tuple[Path, dict]] = []

    c = canvas()
    title = submap_header(c, "asis", "01 AS-IS Current State", "Reported workflow and explicit evidence gaps. Direct TOP observation is still required.", "4")
    steps = ["Department / Manager\nidentifies KPI", "Configure KPI tree\nin TOP", "Configure criteria\nfor each employee", "Update evaluation\nresult", "Consolidate KPI\nby hierarchy", "Report results"]
    prev = None
    for i, step in enumerate(steps):
        n = add_text(c, f"asis-step-{i}", f"## {i+1:02d}\n{step}\n\n**REPORTED / TO VERIFY**", 80 + i * 490, 430, 400, 300, "4")
        if prev:
            add_edge(c, f"asis-flow-{i}", prev, n, "reported flow", "4", "right", "left")
        prev = n
    gaps = [
        ("SOP / JD / real process link", "GAP-003 - TO VERIFY"),
        ("KPI definition, formula, target, approval", "GAP-004 - TO VERIFY"),
        ("Work Done evidence and acceptance", "GAP-005/GAP-007 - TO VERIFY"),
        ("TOP capability, template and integration", "GAP-002/GAP-008 - TO VERIFY"),
    ]
    for i, (name, status) in enumerate(gaps):
        n = add_text(c, f"asis-gap-{i}", f"### {name}\n\n**{status}**", 80 + i * 740, 920, 660, 260, "2")
        add_edge(c, f"asis-gap-edge-{i}", title, n, "requires validation", "2")
    add_file(c, "asis-note", rel(KNOWLEDGE / "03_ASIS_Current_State.md"), 80, 1320, 820, 160, "4")
    add_file(c, "asis-source", rel(KNOWLEDGE / "15_Source_Assessment_2026-10-13.md"), 1000, 1320, 820, 160, "3")
    add_file(c, "asis-questions", rel(REGISTERS / "Open_Question_Register.md"), 1920, 1320, 820, 160, "2")
    add_back_links(c, "asis")
    result.append((MINDMAPS / "01_ASIS_Current_State.canvas", c))

    c = canvas()
    submap_header(c, "pain", "02 Pain Points and Impact", "Each reported pain point links to impact, hypothesis, question, discovery and requirement candidate.", "1")
    pain_rows = [
        ("PP-001", "KPI Definition\nInconsistency", "Incomparable results", "RC-001/002/005", "OQ-006 / WP03", "REQ-001"),
        ("PP-002", "Evidence\nTraceability", "Weak auditability", "RC-003/005", "OQ-008 / WP04", "REQ-004"),
        ("PP-003", "Repetitive Employee\nKPI Configuration", "Manual effort / drift", "RC-002/004", "OQ-003 / WP01", "REQ-003"),
        ("PP-004", "SOP / JD / KPI\nMapping", "Misaligned measurement", "RC-001/002", "OQ-004 / WP02", "REQ-002"),
        ("PP-005", "Work Done\nMeasurement", "Overstated execution", "RC-003/005/006", "OQ-007 / WP04", "REQ-005/007/008"),
    ]
    note_paths = [PAIN_NOTES / n for n in ["PP-001_KPI_Definition_Inconsistency.md", "PP-002_Evidence_Traceability.md", "PP-003_Repetitive_Employee_KPI_Configuration.md", "PP-004_SOP_JD_KPI_Mapping.md", "PP-005_Work_Done_Measurement.md"]]
    for i, row in enumerate(pain_rows):
        pid, label, impact, rc, oq, req = row
        x = 60 + i * 620
        pn = add_text(c, f"pain-{pid}", f"## {pid}\n{label}\n\n**REPORTED / TO VERIFY**", x, 380, 520, 280, "1")
        inn = add_text(c, f"pain-impact-{pid}", f"**Potential impact**\n{impact}\n\n**Hypothesis** {rc}\n**Discovery** {oq}\n**Candidate** {req}", x, 750, 520, 340, "2")
        fn = add_file(c, f"pain-file-{pid}", rel(note_paths[i]), x, 1180, 520, 160, "1")
        add_edge(c, f"pain-impact-edge-{pid}", pn, inn, "may impact", "1", "bottom", "top")
        add_edge(c, f"pain-note-edge-{pid}", inn, fn, "inspect card", "5", "bottom", "top")
    add_file(c, "pain-register", rel(REGISTERS / "Pain_Point_Register.md"), 60, 1500, 850, 150, "1")
    add_file(c, "pain-risk", rel(REGISTERS / "Risk_Register.md"), 1010, 1500, 850, 150, "1")
    add_file(c, "pain-discovery", rel(MINDMAPS / "09_Discovery_Plan.canvas"), 1960, 1500, 850, 150, "3")
    add_back_links(c, "pain", 1730)
    result.append((MINDMAPS / "02_Pain_Points_Impact.canvas", c))

    c = canvas()
    core = submap_header(c, "root", "03 Root Cause Analysis", "Fishbone-style analytical map. Every cause is a hypothesis pending evidence.", "2")
    fish = [
        ("PEOPLE", "RC-001\nOwnership / accountability unclear", 80, 420),
        ("PROCESS", "RC-002\nDefinition/configuration lifecycle inconsistent", 80, 850),
        ("DATA", "RC-003\nEvidence/source incomplete or inconsistent", 1050, 420),
        ("SYSTEM", "RC-004\nTOP capability or use uncertain", 1050, 850),
        ("GOVERNANCE", "RC-005\nBaseline/review/roll-up rules ungoverned", 2020, 420),
        ("MEASUREMENT", "RC-006\nWork units / attribution incompatible", 2020, 850),
    ]
    for dim, text_value, x, y in fish:
        n = add_text(c, f"root-{dim}", f"## {dim}\n{text_value}\n\n**HYPOTHESIS / TO VERIFY**", x, y, 820, 300, "2")
        add_edge(c, f"root-edge-{dim}", n, core, "may cause PP-001..005", "2")
    add_file(c, "root-note", rel(KNOWLEDGE / "05_Root_Cause_Hypotheses.md"), 80, 1320, 820, 150, "2")
    add_file(c, "root-gap", rel(REGISTERS / "Gap_Register.md"), 1050, 1320, 820, 150, "2")
    add_file(c, "root-questions", rel(REGISTERS / "Open_Question_Register.md"), 2020, 1320, 820, 150, "3")
    add_back_links(c, "root")
    result.append((MINDMAPS / "03_Root_Cause_Analysis.canvas", c))

    c = canvas()
    submap_header(c, "tobe", "04 TO-BE Target Process", "Proposed business process; actors, inputs, rules and exceptions require validation.", "4")
    tobe_steps = ["SOP / Process", "JD / Responsibility", "KPI Definition", "Work Assignment", "Task Execution", "Evidence Validation", "KPI Measurement", "Performance Review", "Organizational Roll-up", "Management Reporting"]
    prev = None
    for i, label in enumerate(tobe_steps):
        row, col = divmod(i, 5)
        x = 50 + col * 620
        y = 390 + row * 560
        n = add_text(c, f"tobe-{i}", f"## {i+1:02d}. {label}\n\nActor / input / output / rule / exception: **TO VERIFY**\n\nStatus: **PROPOSED**", x, y, 520, 310, "4")
        if prev:
            add_edge(c, f"tobe-flow-{i}", prev, n, "proposed sequence", "4")
        prev = n
    add_file(c, "tobe-note", rel(KNOWLEDGE / "06_TOBE_Target_Process.md"), 50, 1500, 760, 150, "4")
    add_file(c, "tobe-rules", rel(REGISTERS / "Business_Rule_Candidates.md"), 910, 1500, 760, 150, "3")
    add_file(c, "tobe-decisions", rel(REGISTERS / "Decision_Log.md"), 1770, 1500, 760, 150, "6")
    add_back_links(c, "tobe", 1720)
    result.append((MINDMAPS / "04_TOBE_Target_Process.canvas", c))

    c = canvas()
    submap_header(c, "rel", "05 SOP - JD - KPI Relationships", "Conceptual relationship types only; not verified PPJ mappings.", "4")
    rel_nodes = ["Business Process", "SOP", "Business Function", "Department", "Position / Role", "Job Description", "Responsibility", "Expected Deliverable", "KPI", "Measurement Source", "Evaluation Result"]
    ids = []
    for i, label in enumerate(rel_nodes):
        row, col = divmod(i, 6)
        x = 40 + col * 520
        y = 390 + row * 560
        n = add_text(c, f"rel-{i}", f"## {label}\n\nOwner / version / effective date: **TO VERIFY**", x, y, 430, 240, "4" if i < 8 else "3")
        ids.append(n)
        if i:
            add_edge(c, f"rel-edge-{i}", ids[i-1], n, "conceptually relates to", "4")
    add_text(c, "rel-cardinality", "### Many-to-many relationships\n\nSOP <-> Role\nResponsibility <-> KPI\nKPI <-> Source\n\n**Conceptual, not actual PPJ records**", 2080, 1240, 900, 230, "2")
    add_file(c, "rel-note", rel(KNOWLEDGE / "07_SOP_JD_KPI_Conceptual_Model.md"), 40, 1500, 860, 150, "4")
    add_file(c, "rel-req", rel(REGISTERS / "Requirement_Register.md"), 1000, 1500, 860, 150, "3")
    add_back_links(c, "rel", 1720)
    result.append((MINDMAPS / "05_SOP_JD_KPI_Relationships.canvas", c))

    c = canvas()
    submap_header(c, "hier", "06 Performance Hierarchy", "Proposed organizational roll-up model with responsibility and attribution controls.", "6")
    levels = [
        ("Member", "Assigned tasks and accepted work done"),
        ("Team", "Comparable workload, delivery and quality"),
        ("Department", "Objectives and team contribution"),
        ("Division", "Consolidated department performance"),
        ("Echelon / Corporate", "Strategic performance"),
    ]
    prev = None
    for i, (level, meaning) in enumerate(levels):
        n = add_text(c, f"hier-{i}", f"## {level}\n{meaning}\n\nOwnership / units / normalization: **TO VERIFY**", 220 + i * 460, 480, 400, 340, "6")
        if prev:
            add_edge(c, f"hier-roll-{i}", prev, n, "rolls up to", "6", "right", "left")
        prev = n
    add_text(c, "hier-separate", "### Keep separate\n\nWork Completion | Accepted Work Done | KPI Achievement | Competency Assessment\n\nDo not average incompatible percentages. Do not double count cross-functional work.", 400, 1020, 2200, 330, "1")
    add_file(c, "hier-image", "Pasted image 20261012154322.png", 2600, 420, 520, 900)
    add_file(c, "hier-note", rel(KNOWLEDGE / "08_Performance_Hierarchy.md"), 60, 1500, 850, 150, "6")
    add_file(c, "hier-risk", rel(REGISTERS / "Risk_Register.md"), 1010, 1500, 850, 150, "1")
    add_back_links(c, "hier", 1720)
    result.append((MINDMAPS / "06_Performance_Hierarchy.canvas", c))

    c = canvas()
    submap_header(c, "work", "07 Work Done Measurement", "Candidate lifecycle, acceptance and measurement concepts; formulas are not approved.", "3")
    states = ["Assigned", "Planned / Baseline", "In Progress", "Submitted for Review", "Accepted / Done", "Update Metrics", "Organizational Roll-up"]
    prev = None
    for i, label in enumerate(states):
        n = add_text(c, f"work-state-{i}", f"## {label}\n\n**PROPOSED STATE / TO VALIDATE**", 60 + i * 430, 400, 360, 220, "4" if i >= 4 else "3")
        if prev:
            add_edge(c, f"work-edge-{i}", prev, n, "candidate flow", "3", "right", "left")
        prev = n
    exceptions = ["Blocked / Cancel Request", "Rework Required", "Reopened with Audit", "Approved Baseline Change"]
    for i, label in enumerate(exceptions):
        n = add_text(c, f"work-ex-{i}", f"### {label}\n\nRule: **TO VERIFY / NOT APPROVED**", 200 + i * 740, 800, 620, 230, "2")
        add_edge(c, f"work-ex-edge-{i}", n, prev, "affects credited work", "2")
    add_text(c, "work-formula", "### Proposed formula pattern\n\n`SUM(approved weight x accepted fraction) / SUM(approved weight)`\n\nUse only when denominator and work units are governed and comparable.", 300, 1160, 1800, 300, "3")
    add_file(c, "work-image", "Pasted image 20261012103244.png", 2250, 1100, 800, 430)
    add_file(c, "work-note", rel(KNOWLEDGE / "09_Work_Done_Measurement.md"), 60, 1580, 850, 150, "3")
    add_file(c, "work-rules", rel(REGISTERS / "Business_Rule_Candidates.md"), 1010, 1580, 850, 150, "3")
    add_back_links(c, "work", 1780)
    result.append((MINDMAPS / "07_Work_Done_Measurement.canvas", c))

    c = canvas()
    submap_header(c, "challenge", "08 Challenges and Gap Analysis", "Risk chain from challenge to impact, verification, mitigation and decision.", "1")
    dims = [
        ("People", "Ownership unclear", "Disputed results", "RACI interview", "Governance role"),
        ("Process", "Lifecycle inconsistent", "Drift / rework", "Walkthrough", "Controlled catalogue"),
        ("Data", "Evidence/source unclear", "Non-auditable score", "Source trace", "Ownership / lineage"),
        ("System", "TOP capability unknown", "Wrong solution choice", "WP01/WP06", "Options analysis"),
        ("Governance", "Roll-up rules unapproved", "Bias / double count", "Golden cases", "Approved controls"),
    ]
    for i, (dim, chal, impact, verify, mitigation) in enumerate(dims):
        x = 50 + i * 620
        add_text(c, f"challenge-{dim}", f"## {dim}\n\n**Challenge**\n{chal}\n\n**Potential impact**\n{impact}\n\n**Verify** {verify}\n**Mitigate** {mitigation}\n\n**BA ASSESSMENT / TO VERIFY**", x, 380, 520, 560, "1")
    add_file(c, "challenge-note", rel(KNOWLEDGE / "11_Challenges_and_Risks.md"), 50, 1080, 760, 150, "1")
    add_file(c, "challenge-gap", rel(REGISTERS / "Gap_Register.md"), 910, 1080, 760, 150, "2")
    add_file(c, "challenge-risk", rel(REGISTERS / "Risk_Register.md"), 1770, 1080, 760, 150, "1")
    add_file(c, "challenge-req", rel(REGISTERS / "Requirement_Register.md"), 50, 1350, 760, 150, "3")
    add_file(c, "challenge-dec", rel(REGISTERS / "Decision_Log.md"), 910, 1350, 760, 150, "6")
    add_back_links(c, "challenge", 1660)
    result.append((MINDMAPS / "08_Challenges_Gap_Analysis.canvas", c))

    c = canvas()
    submap_header(c, "discovery", "09 Discovery Plan", "Six work packages are PROPOSED / NOT APPROVED. Owners and dates remain unassigned until confirmed.", "3")
    wps = [
        ("WP01", "TOP System Review", "Screens, configuration, modules, reports", "AS-IS capability matrix"),
        ("WP02", "SOP / JD Review", "Representative controlled documents", "Responsibility map"),
        ("WP03", "KPI Definition Assessment", "Catalogue, formulas, sources, approvals", "KPI gap report"),
        ("WP04", "Work Done & Data Discovery", "Task/evidence/source/history samples", "Measurement feasibility"),
        ("WP05", "TO-BE Validation", "Workshops and golden cases", "Validated process/rules"),
        ("WP06", "Solution Feasibility", "TOP/architecture/cost/security evidence", "Option recommendation"),
    ]
    wp_ids = []
    for i, (wp, name, evidence, output) in enumerate(wps):
        row, col = divmod(i, 3)
        x = 80 + col * 1010
        y = 380 + row * 570
        n = add_text(c, f"discovery-{wp}", f"## {wp} - {name}\n\n**Evidence**\n{evidence}\n\n**Deliverable**\n{output}\n\nOwner/date: **TO IDENTIFY**", x, y, 900, 400, "3")
        wp_ids.append(n)
    for i in range(1, len(wp_ids)):
        if i >= 3:
            add_edge(c, f"discovery-dep-{i}", wp_ids[i-3], wp_ids[i], "informs", "3")
    add_file(c, "discovery-note", rel(KNOWLEDGE / "12_Discovery_and_Validation.md"), 80, 1480, 860, 150, "3")
    add_file(c, "discovery-oq", rel(REGISTERS / "Open_Question_Register.md"), 1040, 1480, 860, 150, "2")
    add_file(c, "discovery-stake", rel(REGISTERS / "Stakeholder_Map.md"), 2000, 1480, 860, 150, "5")
    add_back_links(c, "discovery", 1720)
    result.append((MINDMAPS / "09_Discovery_Plan.canvas", c))

    c = canvas()
    center = submap_header(c, "trace", "10 Requirements Traceability", "Evidence-to-decision graph with stable IDs and explicit hypothesis status.", "6")
    chain = [
        ("SRC", "Evidence Source", "SRC-001..010", "5"),
        ("PP", "Pain Point", "PP-001..005", "1"),
        ("RC/GAP", "Hypothesis / Gap", "RC-001..006 / GAP-001..010", "2"),
        ("OQ/WP", "Question / Discovery", "OQ-001..015 / WP01..06", "3"),
        ("REQ/BR", "Requirement / Rule", "REQ-001..012 / BR-001..010", "4"),
        ("DEC", "Decision", "DEC-001..009", "6"),
    ]
    prev = None
    for i, (code, name, ids_text, color) in enumerate(chain):
        n = add_text(c, f"trace-{code}", f"## {code}\n{name}\n\n{ids_text}", 80 + i * 500, 430, 420, 250, color)
        if prev:
            add_edge(c, f"trace-chain-{i}", prev, n, "traces to", color, "right", "left")
        prev = n
    add_text(c, "trace-example", "### Worked example: PP-003\n\nSRC-003 -> PP-003 -> RC-002/RC-004 -> OQ-003/WP01 -> REQ-003 -> DEC-008\n\nEvery link remains inspectable; PP-003 and causes stay **TO VERIFY** until system evidence exists.", 420, 900, 2200, 360, "3")
    reg_paths = ["Evidence_Register.md", "Pain_Point_Register.md", "Gap_Register.md", "Requirement_Register.md", "Decision_Log.md"]
    for i, name in enumerate(reg_paths):
        add_file(c, f"trace-reg-{i}", rel(REGISTERS / name), 80 + i * 590, 1380, 520, 150, "6")
    add_file(c, "trace-model-note", rel(KNOWLEDGE / "14_Traceability_Model.md"), 80, 1600, 850, 140, "6")
    add_back_links(c, "trace", 1790)
    result.append((MINDMAPS / "10_Requirements_Traceability.canvas", c))

    c = canvas()
    submap_header(c, "decision", "11 Management Decisions", "No decision is confirmed in the available evidence; all topics remain pending or not approved.", "6")
    decisions = [
        ("DEC-001", "Business Sponsor"), ("DEC-002", "KPI Governance Owner"), ("DEC-003", "Discovery Scope"),
        ("DEC-004", "Measurement Scope"), ("DEC-005", "SOP/JD Responsibility"), ("DEC-006", "TOP Assessment"),
        ("DEC-007", "Integration Feasibility"), ("DEC-008", "Improve vs Extend vs Build"), ("DEC-009", "Proceed to Solution Design"),
    ]
    for i, (did, label) in enumerate(decisions):
        row, col = divmod(i, 3)
        x = 80 + col * 1010
        y = 380 + row * 380
        status = "NOT APPROVED" if did == "DEC-009" else "PENDING"
        add_text(c, f"decision-{did}", f"## {did}\n{label}\n\n**{status}**\nEvidence gate required", x, y, 900, 250, "6")
    add_file(c, "decision-log", rel(REGISTERS / "Decision_Log.md"), 80, 1570, 850, 150, "6")
    add_file(c, "decision-source", rel(KNOWLEDGE / "15_Source_Assessment_2026-10-13.md"), 1030, 1570, 850, 150, "3")
    add_file(c, "decision-discovery", rel(MINDMAPS / "09_Discovery_Plan.canvas"), 1980, 1570, 850, 150, "3")
    add_back_links(c, "decision", 1790)
    result.append((MINDMAPS / "11_Management_Decisions.canvas", c))
    return result


def create_all() -> None:
    for folder in (PRESENTATION, MINDMAPS, KNOWLEDGE, PAIN_NOTES, REGISTERS, ASSETS, VALIDATION):
        folder.mkdir(parents=True, exist_ok=True)
    changed = create_markdown()
    canvases = [create_presentation(), create_master(), *create_submaps()]
    for path, data in canvases:
        if write_json(path, data):
            changed.append(path)
    print(f"Generated {len(canvases)} canvases and supporting Markdown.")
    print(f"Changed files: {len(changed)}")
    for path in changed:
        print(rel(path))


if __name__ == "__main__":
    create_all()
