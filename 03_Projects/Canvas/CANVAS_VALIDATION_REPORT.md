---
type: validation_report
canvas: "[[03_Projects/Canvas/PPJ_Digital_Application_AI_Automation_Ecosystem.canvas]]"
date: 2026-09-25
---

# Canvas validation report - PPJ Digital Application AI & Automation Ecosystem

Edition of 25/09/2026 (BOD review of 24/09). Connection changes: [[03_Projects/Canvas/CONNECTION_CHANGELOG|CONNECTION_CHANGELOG]].
Backup of the previous file: `99_Attachments/Canvas_Backup/PPJ_Digital_Application_AI_Automation_Ecosystem.backup-20260925-0922.canvas`.

## Totals

| | Before | After |
| --- | --- | --- |
| Nodes | 146 | 147 |
| Edges | 33 | 81 |
| Project cards | 36 | 36 (one per registered record) |
| Modules with a coverage badge | 0 | 18 WFX / GTAS + Reporting & Analysis |

- **Changed nodes:** 142 - text 102 (concise executive cards, badges, legend, guide, gap notes), geometry 141 (cards re-sized to fit the larger type; Fabric / Technical moved directly under Merchandising). Added: `legend-coverage`. Removed: none. No project note or canonical link was removed; all 36 links resolve.
- **Changed edges:** 51 added, 18 relabelled (PRIMARY / qualifiers / type), 3 removed as incorrect: Sourcing -> MMSx, Expense Invoice -> whole WFX group, QSee -> WFX QC.
- **Line types after:** INTEGRATION 2, PLANNED 3, DATA 47, KNOWLEDGE 6, AFFINITY 23.

## JSON / structure validation

`python scripts/validate_ppj_ecosystem_canvas.py` - 43 checks, all PASS:

- PASS  JSON parses; only nodes/edges/metadata keys
- PASS  unique node ids
- PASS  unique edge ids
- PASS  no orphan edges
- PASS  node keys are spec keys
- PASS  edge keys are spec keys
- PASS  sides valid
- PASS  all coordinates integers
- PASS  every edge label starts with its category
- PASS  edge labels stay short (<= 40 chars)
- PASS  no line attaches to a whole group
- PASS  ASCII only apart from coverage badges (vault canvas-label rule)
- PASS  group labels and edge labels are pure ASCII
- PASS  one project node per registered record
- PASS  file nodes point at real files
- PASS  LF line endings only (same bytes on every OS)
- PASS  project name and code are headings (legible zoomed out)
- PASS  each canonical code appears exactly once
- PASS  all 35 baseline names findable on a project card
- PASS  Invoice recheck shown by canonical code, not as a Chico's project
- PASS  Finance AI is v1.2
- PASS  GRN bot uses the vault canonical code
- PASS  Purchasing inventory report is v2.1
- PASS  no misleading relationships from the old infographic
- PASS  no 'INTEGRATION' edge unless validated / confirmed
- PASS  Closed items are grey
- PASS  PoC / evaluation items are not green
- PASS  On Hold items are orange
- PASS  16 WFX modules
- PASS  16 GTAS applications
- PASS  10 third-party nodes (+1 note)
- PASS  all domain zones labelled
- PASS  every wikilink resolves to a real file
- PASS  project links resolved
- PASS  every matrix entry resolves to a node
- PASS  no connection outside the BOD matrix
- PASS  every BOD matrix connection is drawn
- PASS  PERRI and AI Hub are not attached to modules
- PASS  GDI's primary line is Logistics Out-bound, not Purchase Order Management
- PASS  Market Intelligence has DATA lines only
- PASS  coverage badge on every module with a project relationship
- PASS  no badge on QC / QA / BrandPLM / Production modules / GTAS Transportation
- PASS  GTAS Transportation has no line

`nodes=147 edges=81 project_nodes=36 links_resolved=36 kinds={'AFFINITY': 23, 'DATA': 47, 'PLANNED': 3, 'KNOWLEDGE': 6, 'INTEGRATION': 2} badges=18`

The builder also refuses to write on duplicate ids, orphan edges, a line to a whole group, overlapping cards or a
missing project, and a second run reports "up to date" (deterministic, so every device's watcher writes the same bytes).

## Hover / click test

Automated, outside Obsidian: the plugin's `FocusSession` driven against a mock canvas built from the real generated
nodes and edges (VS Code's Electron in Node mode). All passed:

- node roles and edge types classified; 80 project lines hidden at rest, 1 foundation line (WFX core -> DWH) faint;
- hover Agentic Costing -> Budgeting & Costing, Style Library, Bill of Material, GTAS Costing, GTAS IED, GTAS Consumption, Technical Knowledge Platform (+ Pattern Generation PoC);
- hover WFX Inventory Control -> Purchasing Inventory Report, Material Allocation, GDI, GRN Supplier Invoice Bot, Sourcing AI Chatbot, Finance AI (+ Adhoc Indent);
- click pins (hovering elsewhere keeps the pin), a drag of more than 5px does not pin, a background click and Esc reset;
- 5,000 consecutive hover events: no growth in marked elements, no exceptions;
- canvas reload (new node objects) is picked up; unloading removes every class; editing mode switches styles;
- coverage classes: Finance live, Logistics Out-bound in development, QC / Production Management / GTAS Transportation none.

**Still to confirm by hand in Obsidian** (needs the plugin loaded - reload Obsidian once):
checks 6, 9-13 of the brief - the canvas opens without errors, hover affects only this canvas, dragging / editing
nodes still works, click pins, Esc resets, and the developer console (Ctrl+Shift+I) shows no errors after repeated hovering.
The plugin reads Obsidian's internal canvas objects (not a public API); if an Obsidian update changes them, it stops
reacting but never touches the file - the canvas then shows every line, as before.

## Zoom readability test

Rendered in headless Chrome at 40% zoom on a 1920 x 1080 viewport with the plugin's stylesheet:

| Text | Canvas px | On screen at 40% |
| --- | --- | --- |
| Group titles | 80 | 32 px |
| Project name | 75 | 30 px |
| WFX module | 70 | 28 px |
| GTAS application | 64 | 26 px |
| Third-party / data node | 56 | 22 px |
| Project status | 52 | 21 px |
| Type / capability | 46 | 18 px |

Overflow: all 110 enlarged nodes measured in DejaVu Sans (wide) and Noto Sans - no overflow, no wrapped module or
group title. Project cards carry 6-8 short lines (was up to 10). Without the plugin the same Markdown headings render
at Obsidian's default sizes (smaller, never overflowing).

## Remaining uncertain relationships

| Item | Shown as | Why uncertain |
| --- | --- | --- |
| GLPI chatbot as merchandising helpdesk | KNOWLEDGE to 4 merchandising modules | Owner's description; not in the part of the 24/09 recording received [A] |
| Pattern Generation PoC (Stratova) | one active PoC, AFFINITY only | Registry status "DAF / Commercial / Technical Scope Negotiation"; the brief's "Scope & Data Definition" is not in the registry |
| Costing -> GTAS IED | PLANNED (GTAS/IED contract) | The brief's example shows DATA; kept PLANNED because the vault documents an in-scope contract |
| GRN bot -> Logistics In-bound / Finance | AFFINITY, PRIMARY | Transaction bot, but no document confirms a WFX integration |
| PO Commit -> Buyer Order / PO Management | AFFINITY, historical | May have been a real integration; no document says so |
| Admin Expense -> WFX Finance | AFFINITY, downstream | The brief says "-> Finance"; the WFX Finance module is assumed |
| Hanging Line IoT -> Production Planning / Management | DATA | Follows from the owner's Reporting & Analysis decision; exact data flow unconfirmed |
| Adhoc Indent -> Raw Material Planning / Inventory Control | AFFINITY | "Secondary" in the brief, type not stated |
| Expense invoices merged | one card | Registry still lists the mapping decision as open |
| GTAS Compliance | shown, no line | BOD suggested dropping it from the BOD view [T 22:18-22:42]; not removed |
| Capability cluster "smart mining" | not used | Probably "Smart Merchandising"; name unconfirmed |
