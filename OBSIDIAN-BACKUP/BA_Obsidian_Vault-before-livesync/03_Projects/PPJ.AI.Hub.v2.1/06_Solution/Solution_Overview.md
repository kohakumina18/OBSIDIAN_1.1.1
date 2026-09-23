---
type: "solution_overview"
project: "PPJ.AI.Hub.v2.1"
source_project: "PPJ.AI.Hub.v2.1.md"
source_event: "Canonical naming populated"
last_verified: "2026-07-13"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Solution Overview

## Purpose

Provide one place for users to find and open the correct AI/automation tool by department or business need.

## Current Solution Boundary

- Project type: AI / Chatbot / Agent
- Known systems: PERRI, Invoice Downloader, Sourcing Chatbot, FD Hanger, portal tools, department assistants.
- Current gate: Platform / Internal Hub

## Logical Flow

Approved Input -> Validation -> Approved Service / Data Processing -> Business Review -> Output -> Logging and Evidence

## Non-Assumptions

- No direct transactional database write is assumed.
- No unconfirmed API, table, model, device or vendor capability is treated as implemented.
- WFX, Databricks and Data Warehouse responsibilities remain separate.

## Evidence Basis

- Root project note: [[../PPJ.AI.Hub.v2.1]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PPJ.AI.Hub.v2.1.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-07-13
- Confidence: Strong
