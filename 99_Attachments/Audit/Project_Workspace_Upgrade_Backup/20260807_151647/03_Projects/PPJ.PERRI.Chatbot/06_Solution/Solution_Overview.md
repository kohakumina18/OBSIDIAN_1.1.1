---
type: "solution_overview"
project: "PPJ.PERRI.Chatbot.v3.2"
source_project: "PPJ.PERRI.Chatbot.md"
source_event: "Canonical naming populated"
last_verified: "2026-07-13"
confidence: "Strong"
documentation_status: "Current Working Document"
generated_by: "upgrade_ppj_project_workspaces.py"
---
# Solution Overview

## Purpose

Production chatbot with department-level agents, permissions, logging, and controlled tool/API calling.

## Current Solution Boundary

- Project type: AI / Chatbot / Agent, Transaction Automation
- Known systems: Knowledge base, APIs, automation tools, Invoice Downloader, Sourcing Chatbot, Costing Platform, department agents.
- Current gate: Permission Enhancement

## Logical Flow

Approved Input -> Validation -> Approved Service / Data Processing -> Business Review -> Output -> Logging and Evidence

## Non-Assumptions

- No direct transactional database write is assumed.
- No unconfirmed API, table, model, device or vendor capability is treated as implemented.
- WFX, Databricks and Data Warehouse responsibilities remain separate.

## Evidence Basis

- Root project note: [[../PPJ.PERRI.Chatbot]]
- Project memory: [[03_Projects/_Registry/Project_Memory/PPJ.PERRI.Chatbot.v3.2.memory]]
- Source event: Canonical naming populated
- Last verified: 2026-07-13
- Confidence: Strong
