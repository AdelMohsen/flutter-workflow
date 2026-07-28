---
name: flutter-add-component
description: Configure, plan, implement, and verify a reusable Flutter Component Pack that adapts to the current project's architecture and capabilities. Use when the developer sends "flutter component:add", invokes $flutter-add-component, asks to list reusable Flutter packs, requests Project Foundation & UI Kit, or requests Authentication & Account Management.
---

# Flutter Add Component

Add an approved Feature Pack without copying incompatible project-agnostic
application code.

## Run the flow

1. Render the standard startup banner from
   `.flutter-workflow/workflow.json` with flow `Add Component` and the current
   workspace name. Render it once. Treat the chat token as intent; do not execute
   it in a shell or start another coding agent.
2. Read `FLUTTER-WORKFLOW.md`, `.flutter-workflow/output-templates.md`, the
   approved constitution/profile, repository guidance, and the component-pack
   catalog. Require completed initialization.
3. List directories under `.flutter-workflow/component-packs/` whose
   `pack.yaml` status is `available`. Show foundation Packs before feature Packs,
   then sort by name. If the developer did not identify a Pack, show the catalog
   and ask for one selection.
4. Read the selected `pack.yaml` and every referenced Pack file completely.
5. Create the next Work Item directory with `work-item.yaml`, `spec.md`,
   `plan.md`, and `result.md` initialized from the shared templates. Set type
   `component`, source skill `flutter-add-component`, the Pack slug and
   `pack_id`, and state `DISCOVERY`.
6. Run Pack discovery and its declared `conflict_policy` before configuration.
   On a refused conflict, record `BLOCKED` with exact paths and stop without
   changing production code. Never assume all Packs share target or freshness
   rules.
7. Ask one material configuration question at a time using the Pack's progress
   and conditional-count contract. Preserve unrelated answers when editing a
   section.
8. Present the final configuration review, then write `spec.md` from the shared
   Playback template. Set `PLAYBACK_READY` and wait for explicit approval before
   recording `PLAYBACK_APPROVED`.
9. Write a decision-complete `plan.md` from the shared Plan template. Set
   `PLAN_READY` and wait for explicit approval before recording
   `PLAN_APPROVED`.
10. Implement only approved Pack behavior using its declared architecture and
    exact project capabilities. Do not add undeclared dependencies or invent
    backend contracts.
11. Return to both approval gates for undeclared material impact.
12. Verify according to the Pack and shared workflow contract, write
    `result.md` from the shared Result template, and set `VERIFIED` only when
    required checks pass. Otherwise set `BLOCKED` with exact evidence.

## Boundaries

- Follow the selected Pack's conflict policy. Never merge, overwrite, rename,
  delete, or partially generate a Pack whose policy refused the conflict.
- Do not create a package, another `pubspec.yaml`, or a runtime form engine.
- Do not create or request unit/widget tests in V1.
- Do not commit, push, or change branches without explicit request.
