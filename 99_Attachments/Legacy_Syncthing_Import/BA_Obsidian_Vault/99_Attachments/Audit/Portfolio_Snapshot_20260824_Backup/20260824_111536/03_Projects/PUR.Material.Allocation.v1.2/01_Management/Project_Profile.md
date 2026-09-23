---
type: "project_profile"
project: "PUR.Material.Allocation.v1.1"
source_project: "PUR.Material.Allocation.v1.2.md"
source_event: "PPJ-WEEKLY-20260713-20260718"
last_verified: "2026-07-18"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Project Profile

## Identity

| Field | Value |
| --- | --- |
| Canonical Code | PUR.Material.Allocation.v1.1 |
| Physical Project Note | PUR.Material.Allocation.v1.2.md |
| Primary Domain | Sourcing / Purchasing |
| Cluster | Purchasing Workflow |
| Lifecycle Class | B. UAT / Stabilization |
| Lifecycle | UAT / Stabilization |
| Current Gate | First Flow Validated / Extended Exception Testing |
| Priority | TBD |
| Business Owner | Needs Confirmation |

## One-Line Understanding

Purchasing material allocation/transfer/borrow workflow with WFX dependency and validation before save/post.

## Intended Outcome

Validated unreserve, destination-OC matching and allocation flow with controlled UAT foundation

## Users and Delivery Participants

- Primary users: Purchasing / Khoa / Uyen / Nam / Phat
- BA / Coordination: Khoa, Uyên
- Technical members: Uyen, Khoa, Nam, Phát

## Current Scope

- Semi-automation/automation for material allocation, transfer, or borrow between OC/style/order.

## Explicit Boundaries

- Not production-ready until WFX logic, user review, and test data are confirmed.

## Current Gate and Next Move

- Gate: First Flow Validated / Extended Exception Testing
- Next actions: Test many-to-one, one-to-many, partial allocation, insufficient quantity, Buyer Reference mismatch and duplicate allocation.; Test transaction failure/retry and define rollback.; Define audit log and user review before posting.; Prepare UAT with Ms. Tuyet and Precision users.

## Evidence Basis

- Root project note: [[../PUR.Material.Allocation.v1.2]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PUR.Material.Allocation.v1.1.memory]]
- Source event: PPJ-WEEKLY-20260713-20260718
- Last verified: 2026-07-18
- Confidence: Strong
