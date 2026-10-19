

The project is now in a good position to move fast because the WFX GET API is already returning FPO, OC, material, quantity, stock and site-related data, while the POST API accepts the header/material payload required to create the Stock FPO Material Allocation transaction. PPJ Stock FPO Material Allocati… WFX’s documented POST behavior also includes validating stock/site/article/indent and returning transaction status/GDI information. WFX ERP - Stock FPO Material Al…

# 1. Delivery target

**Start:** 19 Oct 2026  
**Target release:** 30 Nov 2026  
**Delivery model:** 3 sprints × 2 weeks

|Sprint|Dates|Main Goal|Exit Gate|
|---|---|---|---|
|Sprint 1|19 Oct – 1 Nov|Prove API contract + freeze mapping|API contract approved|
|Sprint 2|2 Nov – 15 Nov|Build working MVP|Feature complete|
|Sprint 3|16 Nov – 29 Nov|UAT, hardening, release|Business sign-off|
|Release|30 Nov|Production rollout|Go-live|

## Assumption

This timeline is viable if PPJ has at minimum:

|Role|Suggested Capacity|
|---|---|
|BA / Project Lead|0.5–1 FTE|
|Backend / Integration Dev|1 FTE|
|Frontend / Full-stack Dev|1 FTE|
|QA|0.5 FTE|
|Infra|Part-time|
|Purchasing / Mer UAT|2 key users|
|WFX support|On-demand, preferably <1 business day response|

If only one developer handles both backend and frontend, the timeline is still possible, but **P1 items must move after release**.

# 2. Release scope

The release must stay focused on one business outcome:

> User searches OC/FPO → retrieves Material Allocation → reviews materials → Auto Fills / edits Issue Qty → submits → WFX creates transaction → PPJ shows GDI result.

## Phase 1 – Must Have

|Module|Scope|
|---|---|
|Search|OC No. / FPO No.|
|FPO Context|OC, FPO, Style, Factory, Status|
|Material Grid|Article, Indent, Color, Size, UOM, Open Qty, Stock|
|Sites|From Site / Linked Site|
|Auto Fill|`IssueQty = OpenQty`|
|Manual Qty|Partial issue|
|Review|Confirmation before POST|
|Create|WFX POST API|
|Result|Success / Failure / GDI No.|
|Security|Backend-only API credentials|
|Audit|Basic transaction log|

## Defer after release

|Item|Reason|
|---|---|
|Batch processing|Adds concurrency complexity|
|Multi-OC mass processing|Not needed for MVP|
|Analytics dashboard|Non-critical|
|All GDI types|Current scope is FPO Material Allocation|
|Scheduled automation|Future enhancement|
|Advanced BI integration|Not release-blocking|

# 3. Delivery strategy

The critical design principle is:

```
WFX GET
  ↓
PPJ Normalization Layer
  ↓
PPJ UI
  ↓
User Review
  ↓
PPJ POST Mapper
  ↓
WFX POST
  ↓
GDI Result
```

Do not let the frontend call WFX directly.

# 4. Sprint 1 – API Contract Validation & Foundation

**Goal:** remove all uncertainty before UI development accelerates.

## Sprint 1 deliverables

|Workstream|Requirement|Output|Owner|Priority|
|---|---|---|---|---|
|API|Test GET by FPO|Verified real response|Backend + QA|P0|
|API|Test GET by OC|Multi-FPO behavior confirmed|Backend + QA|P0|
|API|Validate FPO/material mapping|Correct line-to-FPO relation|BA + QA|P0|
|API|Validate OpenQty / StockQty|Compare with WFX UI|QA + Business|P0|
|API|Test POST success|Valid transaction created|Backend + WFX|P0|
|API|Confirm GDI response|GDI No./status captured|Backend + QA|P0|
|Mapping|Freeze GET→POST mapping|Mapping spec v1.0|BA + Dev|P0|
|Security|Move secrets server-side|Secure config|Infra + Dev|P0|
|Backend|Create WFX GET wrapper|Internal service|Backend|P0|
|Backend|Create WFX POST wrapper|Internal service|Backend|P0|
|Backend|Normalize WFX response|Stable PPJ model|Backend|P0|
|QA|Build UAT dataset|Real FPO test pack|QA + Business|P0|

## Sprint 1 must answer

|Question|Must be resolved by end of Sprint 1|
|---|---|
|Does OC search return multiple FPO correctly?|Yes|
|Do material lines map to correct FPO?|Yes|
|Are From Site / Linked Site values usable?|Yes|
|Does Auto Fill use OpenQty?|Yes|
|Does partial issue work?|Yes|
|Does POST return GDI No.?|Yes|
|What happens when stock is insufficient?|Confirmed|
|What happens when stock is null?|Confirmed|
|Can PPJ retry safely after timeout?|Defined|
|Are credentials secured?|Yes|

## Sprint 1 exit criteria

```
API contract frozen
+ GET/POST happy path works
+ core error cases understood
+ mapping signed off
```

If this gate fails, do **not** proceed blindly with full UI.

# 5. Sprint 2 – MVP Build

**Goal:** working end-to-end application.

## Sprint 2 functional build

|Module|Feature|Acceptance|
|---|---|---|
|Search|Search by OC / FPO|GET called successfully|
|FPO Selection|Select FPO if multiple|Correct FPO context loaded|
|Header|Show OC/FPO/Style/Factory/Status|Read-only|
|Sites|Select From Site / Linked Site|Only valid values|
|Material Grid|Display material lines|Matches WFX|
|Material Selection|Select one/multiple lines|Selected only|
|Auto Fill|IssueQty = OpenQty|Works per WFX rule|
|Manual Qty|Edit IssueQty|Positive decimal validation|
|Review|Preview transaction|No POST yet|
|Confirm|User confirms|POST starts|
|Result|Show GDI No. / status|Clear success screen|
|Error|Show meaningful errors|No raw JSON|
|Audit|Save basic transaction log|Searchable internally|

## Sprint 2 UI state flow

```
[Search]
   ↓
[Loading]
   ↓
[FPO Selected]
   ↓
[Materials Loaded]
   ↓
[User Selects Lines]
   ↓
[Auto Fill / Edit Qty]
   ↓
[Review]
   ↓
[Confirm]
   ↓
[Submitting]
   ↓
[Success / Error]
```

## Backend requirements in Sprint 2

|Capability|Requirement|
|---|---|
|API Wrapper|Centralized GET/POST clients|
|Mapper|WFX → PPJ → WFX|
|Validation|UI/business-input only|
|Error Mapping|WFX error → readable UI message|
|Logging|Request metadata, no secrets|
|Timeout|Defined behavior|
|Retry|No blind POST retry|
|Correlation|Trace OC/FPO → request → GDI|

## Sprint 2 exit criteria

> A PPJ tester can complete the entire GDI flow without manually navigating WFX.

# 6. Sprint 3 – UAT, Hardening & Release

**Goal:** prove reliability, fix defects, prepare production.

## Sprint 3 work

|Area|Test / Work|Priority|
|---|---|---|
|Business UAT|Real OC/FPO scenarios|P0|
|Full Issue|IssueQty = OpenQty|P0|
|Partial Issue|IssueQty < OpenQty|P0|
|No Stock|Null / insufficient stock|P0|
|Multi-Line|Multiple materials|P0|
|Multi-FPO|OC with multiple FPO|P0|
|Site Scenario|Same site / different site|P0|
|Equivalent Article|Validate original article submission|P1|
|Error Handling|Invalid indent/article/site|P0|
|Regression|Compare API vs WFX UI|P0|
|Security|Credential review|P0|
|Performance|Normal user load|P1|
|Logging|Validate traceability|P1|
|SOP|User guide 1–2 pages|P0|
|Training|Key-user session|P0|
|Release|Prod config & deployment|P0|

# 7. Recommended Jira Epic structure

|Epic|Scope|Sprint|
|---|---|---|
|EPIC-01 WFX API Validation|GET / POST / mapping|S1|
|EPIC-02 Integration Backend|API wrapper / normalization|S1–S2|
|EPIC-03 GDI Automation UI|Search / grid / issue|S2|
|EPIC-04 Security & Audit|secrets / logs / retry|S1–S3|
|EPIC-05 QA & UAT|API + end-to-end validation|S1–S3|
|EPIC-06 Release & Adoption|SOP / training / deploy|S3|

# 8. Suggested sprint allocation by backlog

|Requirement Group|Sprint 1|Sprint 2|Sprint 3|
|---|---|---|---|
|API Validation|80%|20%|Regression|
|Backend Integration|50%|50%|Hardening|
|UI|10%|80%|10%|
|QA|30%|30%|40%|
|Security|40%|30%|30%|
|Business UAT|10%|20%|70%|
|Release|0%|10%|90%|

# 9. Critical path

```
API Validated
    ↓
GET/POST Mapping Frozen
    ↓
Integration Backend Ready
    ↓
UI End-to-End Ready
    ↓
Business UAT
    ↓
Critical Bugs Closed
    ↓
Production Sign-off
    ↓
Release
```

Anything blocking the first three nodes threatens the 6-week target.

# 10. UAT test matrix

Minimum release UAT should cover:

|Test ID|Scenario|Expected|
|---|---|---|
|UAT-01|Search valid FPO|Correct FPO loaded|
|UAT-02|Search valid OC|All related FPOs|
|UAT-03|Multiple FPO|Material mapped correctly|
|UAT-04|Full Auto Fill|IssueQty = OpenQty|
|UAT-05|Partial issue|Valid partial transaction|
|UAT-06|Insufficient stock|WFX rejects correctly|
|UAT-07|Null stock|Safe handling|
|UAT-08|Multiple lines|Correct creation|
|UAT-09|Same site|Correct transaction|
|UAT-10|Different sites|Transfer/GDI correct|
|UAT-11|Invalid Indent|Meaningful error|
|UAT-12|Invalid Article|Meaningful error|
|UAT-13|POST success|GDI No. returned|
|UAT-14|Timeout|No duplicate creation|
|UAT-15|Regression|Matches WFX UI|

# 11. Release gates

## Gate 1 – API Ready

Must have:

|Criterion|Required|
|---|---|
|GET validated|Yes|
|POST validated|Yes|
|Mapping frozen|Yes|
|GDI response confirmed|Yes|
|Critical API gaps|0|

## Gate 2 – Feature Complete

|Criterion|Required|
|---|---|
|Search|Pass|
|Material grid|Pass|
|Auto Fill|Pass|
|Manual Qty|Pass|
|Review|Pass|
|POST|Pass|
|Error handling|Pass|

## Gate 3 – Production Ready

|Criterion|Threshold|
|---|---|
|P0 UAT pass rate|100%|
|Open critical bugs|0|
|Open high bugs|0 or accepted workaround|
|Business sign-off|Required|
|Infra sign-off|Required|
|Production credentials|Ready|
|SOP|Ready|
|Rollback plan|Ready|

# 12. Release strategy

Do not release to all users immediately.

Recommended rollout:

```
Day 1–2
2–3 Purchasing/Mer key users

        ↓

Day 3–5
Expand to one business team

        ↓

Week 2 after Go-Live
Expand to broader user base
```

Keep WFX manual flow available as fallback during the first production week.

# 13. Risk assessment

|Risk|Impact|Mitigation|Owner|
|---|---|---|---|
|WFX API behavior differs from docs|High|Test Sprint 1|WFX + PPJ|
|Missing GET→POST codes|High|Freeze mapping before UI|BA + WFX|
|WFX support delay|High|Daily escalation during UAT|PM|
|POST duplicate after timeout|High|No blind retry|Backend|
|Stock changes between GET and POST|Medium|WFX final validation|WFX|
|Business rules unclear|Medium|Business sign-off|BA|
|UI scope creep|High|Freeze MVP|PM|
|Shared secrets exposed|High|Server-side secret management|Infra|
|Too many P1 features|Medium|Push after release|PM|
|Limited UAT users|High|Nominate users in Sprint 1|Business|

# 14. Team governance

Keep the management lightweight.

|Ceremony|Frequency|Duration|Purpose|
|---|---|---|---|
|Sprint Planning|Every 2 weeks|60 min|Commit scope|
|Daily Dev Sync|Daily|15 min|Blockers|
|WFX Technical Sync|As needed / 2× weekly in S1|30 min|API issues|
|Business Review|Weekly|30 min|UX / rules|
|Sprint Demo|End sprint|45 min|Acceptance|
|UAT War Room|Sprint 3|Daily if needed|Fast issue closure|

# 15. Success metrics

Recommended release targets:

|KPI|Target|
|---|---|
|P0 UAT cases passed|100%|
|GDI successful creation for valid requests|≥ 95%|
|Duplicate GDI caused by PPJ|0|
|Manual WFX navigation for standard flow|Eliminated|
|GDI No. captured automatically|100%|
|Technical errors with traceable logs|100%|
|Critical production defects in first week|0|

Time-saving KPI should be measured during UAT rather than guessed.

# 16. Definition of Done

The project is ready for release when:

> A Purchasing/Mer user can search an OC or FPO, review the correct FPO/material allocation data, select materials, Auto Fill or manually adjust Issue Qty, submit the transaction, receive the WFX GDI result, and understand any validation error without manually repeating the standard GDI flow inside WFX.

# 17. What I would do this week

|Day|Action|
|---|---|
|Day 1|Create Jira epics / Sprint 1 backlog|
|Day 1|Nominate Dev, QA, Business UAT owners|
|Day 1–2|Validate GET by FPO and OC|
|Day 2|Test successful POST|
|Day 2–3|Compare API data with WFX UI|
|Day 3|Close GET→POST mapping gaps|
|Day 3–4|Finalize internal PPJ API model|
|Day 4|Begin backend wrapper|
|Day 5|Review Sprint 1 status with WFX|
|End Week 1|Lock MVP scope and field mapping|

## Recommended project rule

For this 6-week delivery:

> **Do not spend Sprint 1 designing a beautiful UI. Spend Sprint 1 proving the transaction.**

Once GET → POST → GDI works reliably, the UI is relatively straightforward. If the API contract remains unstable into Sprint 2, the release date becomes significantly riskier.

