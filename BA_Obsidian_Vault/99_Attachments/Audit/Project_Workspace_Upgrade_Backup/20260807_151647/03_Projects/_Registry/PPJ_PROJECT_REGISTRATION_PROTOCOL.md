# PPJ Project Registration Protocol

Use this protocol when the user says: new project, add project, register project, create project, track this project, or mentions a project not found in memory/index/registry.

## Required Checks

1. Check [[PPJ_PROJECT_MEMORY_INDEX]].
2. Check [[PPJ_PROJECT_REGISTRY]].
3. Check root project files under `03_Projects/`.
4. Check aliases in [[PPJ_PROJECT_ALIAS_MAP]] if it exists.
5. If project exists, update it instead of creating a duplicate.
6. If project does not exist, create a registration proposal.
7. Do not silently create random notes.
8. Create project only after DryRun/approval or explicit Apply.

## Minimum Metadata

- Project name
- Department / owner group
- Object / domain
- Characteristic / purpose
- Version
- Business problem
- Target users
- Owner
- Technical member
- Phase
- Priority
- Outcome
- Source system/data
- Next action

## Generated Assets For New Project

- Project note under `03_Projects/`
- Project memory card under `03_Projects/_Registry/Project_Memory/`
- Registry entry
- Memory index entry
- Optional task note
- Optional Canvas card after approval

## Drift Control

- Do not merge FD.Datamart.v2.2 and CPD.Datamart.v1.1.
- Sourcing remains consolidated under SCP.SOURCING.CHATBOT.v2.3 unless approved.
- PPJ.AI.Hub is a hub, not a merge of all project notes.
- Explicit user correction has higher priority than previous generated text.

<!-- PPJ_PROJECT_WORKSPACE_REGISTRATION_START -->
## Automatic Project Workspace Assets

After canonical approval and Apply authorization, registration creates:

1. Root project note.
2. Project memory card.
3. Registry and memory-index entry.
4. Project workspace folder named after the current physical project-note basename.
5. Right-sized baseline documentation pack.
6. Tasks folder and evidence-based initial tasks.
7. Project_Executive_Board.canvas.
8. Root-note and memory workspace links.
9. Optional portfolio Canvas card or project-board reference.

Do not require a separate workspace-creation request after project registration approval.

## Future Update Routing

New update -> canonical resolution -> memory/root update -> affected workspace documents -> task changes -> local board sync -> registry update -> portfolio Canvas only for lifecycle/outcome/domain change.
<!-- PPJ_PROJECT_WORKSPACE_REGISTRATION_END -->
