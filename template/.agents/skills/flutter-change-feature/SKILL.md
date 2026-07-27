---
name: flutter-change-feature
description: Understand, plan, implement, and verify the smallest compatible change to an existing Flutter feature while preserving its architecture and consumers. Use when the developer sends "flutter flow:change", invokes $flutter-change-feature, or requests changed behavior in an existing capability.
---

# Flutter Change Feature

Change existing behavior without silently migrating architecture or breaking
consumers.

## Run the flow

1. Render the standard startup banner from
   `.flutter-workflow/workflow.json` with flow `Change Feature` and the current
   workspace name. Render it once. Do not execute the chat token or start
   another coding agent.
2. Read `FLUTTER-WORKFLOW.md`, constitution/profile, repository guidance, and
   the complete affected feature. Require completed initialization.
3. Identify the feature and change slug. Create the next work item with type
   `change` and state `DISCOVERY`.
4. Baseline current behavior before proposing a delta:
   - inspect UI, state, repositories, models, routes, localization, platforms,
     integrations, callers, consumers, and documentation;
   - run existing relevant non-unit verification when available;
   - record pre-existing failures and stop when they prevent a safe baseline.
5. Ask one material question at a time about current, requested final,
   unchanged, compatibility, migration, and out-of-scope behavior.
6. Search for reusable code, widgets, helpers, and installed packages.
7. Create `spec.md` and present one combined Playback covering behavior,
   positive/negative/edge and UI states, the minimal delta, consumers,
   compatibility, preserved architecture, packages/platforms, and verification.
8. Set `PLAYBACK_READY`; wait for explicit approval and then record
   `PLAYBACK_APPROVED`.
9. Create a decision-complete minimal `plan.md`. Set `PLAN_READY`; wait for
   explicit approval and then record `PLAN_APPROVED`.
10. Implement the approved delta. Preserve the affected feature's architecture,
    even when it differs from the new-feature BLoC contract. Migrate architecture
    only when explicitly requested and approved.
11. Return to playback/plan approval if an undeclared consumer, platform,
    package, data, security, or cross-feature impact appears.
12. Format changed Dart files, run affected code generation, run
    `flutter analyze`, and exercise the changed scenario when available.
13. Write `result.md` and set `VERIFIED` only when required checks pass;
    otherwise set `BLOCKED` with exact evidence.

## Boundaries

- Do not create or request unit/widget tests in V1.
- Do not turn a requested behavior delta into an architecture refactor.
- Do not change unrelated consumers or dependencies.
- Do not commit, push, or change branches without an explicit request.
