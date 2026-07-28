---
name: flutter-new-feature
description: Clarify, plan, implement, and verify a new Flutter feature using the project-local workflow and Widget to Cubit to Repository to Network architecture. Use when the developer sends "flutter flow:new", invokes $flutter-new-feature, or requests a capability that does not already exist.
---

# Flutter New Feature

Build the smallest approved feature while reusing the current project's
infrastructure, packages, widgets, and conventions.

## Run the flow

1. Render the standard startup banner from
   `.flutter-workflow/workflow.json` with flow `New Feature` and the current
   workspace name. Render it once. Do not execute the chat token or start
   another coding agent.
2. Read `FLUTTER-WORKFLOW.md`, `.flutter-workflow/output-templates.md`, the
   approved constitution/profile, repository guidance, and relevant code. If
   initialization is incomplete, stop and ask for `flutter workflow:init`.
3. Identify the requested capability and a kebab-case slug. Create the next
   `FW-NNNN-slug` work item with type `new`, source skill
   `flutter-new-feature`, and state `DISCOVERY`.
4. Prove the capability does not already exist. Search for reusable features,
   Cubits, repositories, models, validators, navigation, localization, theme,
   widgets, network/cache/error helpers, and installed packages.
5. Ask one material product question at a time. Cover actors, trigger, expected
   outcome, inputs, validation, positive/negative/edge behavior, loading/error/
   empty states, navigation, permissions, persistence, and out-of-scope behavior
   only when relevant.
6. Create `spec.md` from the shared Playback template and present it:
   - functional behavior and acceptance scenarios;
   - unchanged and out-of-scope behavior;
   - reuse decisions and exact affected layers;
   - `Widget → Cubit → Repository → Network` implementation shape;
   - missing architecture prerequisites included in scope;
   - package, platform, localization, security, and verification impact.
7. Set `PLAYBACK_READY` and wait for explicit approval. Record approval and set
   `PLAYBACK_APPROVED`; comments do not approve.
8. Create a decision-complete `plan.md` from the shared Plan template with
   interfaces, data flow, files, failure behavior, code generation, validation,
   and rollout implications. Set `PLAN_READY`, wait for explicit approval, then
   set `PLAN_APPROVED`.
9. Implement only the approved scope:
   - keep API calls and repository logic out of widgets;
   - keep Cubits independent of `BuildContext` and UI classes;
   - keep repositories independent of UI;
   - use exact project imports and conventions;
   - generate only approved fields and flows;
   - add the smallest missing BLoC/core prerequisite declared in the plan;
   - do not add a package that was absent from the approved plan.
10. If a material undeclared impact appears, stop, revise the playback and
    plan, and obtain approval again.
11. Format changed Dart files, run affected code generation, run
    `flutter analyze`, and exercise the affected scenario when available.
12. Write `result.md` from the shared Result template, record exact
    evidence/TODOs, and set `VERIFIED` only when required checks pass. Otherwise
    set `BLOCKED` and name the failure.

## Boundaries

- Do not create or request unit/widget tests in V1.
- Do not hardcode external destinations when the host project must decide them.
- Do not refactor unrelated existing features.
- Do not commit, push, or change branches without an explicit request.
