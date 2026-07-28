---
name: flutter-fix-bug
description: Reproduce, trace, plan, fix, and verify a Flutter defect with the smallest root-cause correction while preserving the affected feature's architecture. Use when the developer sends "flutter flow:bug", invokes $flutter-fix-bug, or reports observed behavior that differs from expected behavior.
---

# Flutter Fix Bug

Fix the proven cause, not the reported symptom.

## Run the flow

1. Render the standard startup banner from
   `.flutter-workflow/workflow.json` with flow `Bug Fix` and the current
   workspace name. Render it once. Do not execute the chat token or start
   another coding agent.
2. Read `FLUTTER-WORKFLOW.md`, `.flutter-workflow/output-templates.md`,
   constitution/profile, repository guidance, and the complete affected
   feature. Require completed initialization.
3. Collect the feature, observed behavior, expected behavior, minimal
   reproduction, environment, frequency, and sanitized evidence. Never request
   credentials, tokens, OTPs, private keys, or raw production data.
4. Create the next work item with type `bug`, source skill `flutter-fix-bug`,
   and state `DISCOVERY`.
5. Inspect every relevant caller and trace the path through UI, Cubit/state,
   repository, network/cache/persistence, navigation, platform integration,
   localization, and error handling.
6. Reproduce the defect before planning a fix. If reproduction or evidence is
   insufficient, record exactly what is missing in `spec.md`, set
   `NEEDS_EVIDENCE`, and stop without changing production code.
7. Prove the root cause and identify the smallest shared repair boundary.
8. Ask one material question at a time about expected behavior, user impact,
   unchanged behavior, security/data risk, and edge cases.
9. Create `spec.md` from the shared Playback template, covering expected and
   observed behavior, reproduction evidence, root cause, minimal repair,
   neighboring callers, regression scenario, preserved architecture,
   packages/platforms, and verification.
10. Set `PLAYBACK_READY`; wait for explicit approval and record
    `PLAYBACK_APPROVED`.
11. Create a decision-complete minimal `plan.md` from the shared Plan template.
    Set `PLAN_READY`; wait for explicit approval and record `PLAN_APPROVED`.
12. Fix only the approved root cause. Do not suppress errors, weaken validation,
    broaden permissions, or refactor unrelated code.
13. Return to playback/plan approval for any undeclared material impact.
14. Format changed Dart files, run affected code generation, run
    `flutter analyze`, and reproduce the scenario again when available.
15. Write `result.md` from the shared Result template with before/after
    evidence and set `VERIFIED` only when required checks pass; otherwise set
    `BLOCKED`.

## Boundaries

- Do not create or request unit/widget tests in V1.
- Do not patch only one caller when the defect lives in shared code.
- Do not add a package to avoid root-cause analysis.
- Do not commit, push, or change branches without an explicit request.
