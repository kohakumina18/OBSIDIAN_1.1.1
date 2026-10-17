---
name: canvas-system-map
description: Build or improve Obsidian Canvas mind maps and system/process maps from project notes, including flows, business actors, data sources, decisions, dependencies, and grouped workstreams.
---
# Obsidian Canvas architecture and mind maps

## Procedure
1. Extract entities, relationships and provenance from the selected notes.
2. Choose diagram structure appropriate to the goal: high-level mind map, AS-IS/TO-BE flow, layered system integration, stakeholder map or decision tree.
3. Prefer logical groups and readable spatial layout, with a center/root node, named clusters, short titles and unambiguous arrow directions.
4. On system maps, separate **Business Source → DWH → Target** into labeled layers; distinguish data transfer from user actions and AI recommendations.
5. If modifying an existing canvas, read it first and preserve existing useful cards and edges. Use the plugin's canvas tools if available; never claim success if editing fails.
6. Check for overlapping cards, orphan nodes, crossing dependencies and missing labels; include relevant note/file cards where possible.
7. For large maps, create an overview plus subflows instead of one unreadable mass of nodes.

## Output
Brief map legend, assumptions, unresolved relations and canvas change list. No fabricated integrations, owners or metrics.
