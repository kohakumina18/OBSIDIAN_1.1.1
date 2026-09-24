# Project Knowledge Auto-Update System Plan - 20260628

## Executive Summary

This plan defines a memory-first, DryRun-first project knowledge update system for the PPJ Obsidian vault.

## Problem: Project Knowledge Drift

Project status, blockers, decisions, scope, and ownership change during meetings and daily updates. If those updates stay only in chat or notes, future sessions may read stale project state.

## Target Architecture

1. Compact AGENTS.md operating rules.
2. Project Memory Cards for compact project grounding.
3. Append-only Project Update Ledger.
4. Project Update Intake notes for structured deltas.
5. DryRun-first update scripts.
6. Project registration workflow for unknown projects.

## Auto-Update Workflow

1. Read memory index.
2. Match project.
3. Read memory card.
4. Extract update deltas.
5. Create proposal.
6. Apply only after approval.
7. Update memory first, then project note/registry/ledger.

## Memory-First Design

Future sessions should read the project memory card before reading long project notes. Memory cards preserve compact understanding, latest update, risks, decisions, and do-not-drift rules.

## Intake Template

`03_Projects/_Templates/PPJ_PROJECT_UPDATE_INTAKE_TEMPLATE.md` captures raw updates, detected projects, extracted update events, tasks, decisions, risks, blockers, and registration candidates.

## Update Ledger

`03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md` is append-only and records applied/proposed project deltas.

## Registration Protocol

`03_Projects/_Registry/PPJ_PROJECT_REGISTRATION_PROTOCOL.md` prevents duplicate project creation and requires DryRun/approval before registering new projects.

## Scripts Created

- `scripts/Update-PPJProjectKnowledgeFromIntake.ps1`
- `scripts/Register-PPJProject.ps1`
- `scripts/Create-PPJProjectUpdateIntake.ps1`

## Safety Rules

- DryRun by default.
- Backup before Apply.
- Do not rename files.
- Do not delete files.
- Do not archive files.
- Do not update Canvas unless explicitly approved.
- Do not rewrite full project notes.
- Do not invent facts.

## Token Usage Benefit

The agent can read the memory index and relevant memory card instead of loading long project notes for every session.

## Apply Plan

Run scripts with `-Apply` only after reviewing DryRun output.

## Approval Checklist

- Confirm affected project.
- Confirm extracted update events.
- Confirm memory card update.
- Confirm ledger entry.
- Confirm project note update if requested.
- Confirm registry update if requested.
- Confirm no Canvas update unless explicitly approved.
