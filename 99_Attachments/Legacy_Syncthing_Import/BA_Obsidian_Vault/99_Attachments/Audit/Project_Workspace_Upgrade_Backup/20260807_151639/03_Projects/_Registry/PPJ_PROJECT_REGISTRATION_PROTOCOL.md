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
