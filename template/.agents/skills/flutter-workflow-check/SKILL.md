---
name: flutter-workflow-check
description: Inspect an installed Flutter project workflow without changing files, running analysis, or using the network. Use when the developer sends "flutter workflow:check", invokes $flutter-workflow-check, asks whether initialization or Feature Packs are ready, or asks for active Work Items and their next actions.
---

# Flutter Workflow Check

Report workflow health and progress without changing project state.

## Run the check

1. Read `.flutter-workflow/workflow.json` and `FLUTTER-WORKFLOW.md`. Render the
   standard startup banner once with flow `Workflow Check` and the workspace
   name.
2. Read, but never edit:
   - `pubspec.yaml`, `lib/`, and `.flutter-workflow/installation.json`;
   - constitution/profile when present;
   - available Pack manifests and their target paths;
   - every Work Item metadata file and the existence of its four required files.
3. Determine:
   - **Project**: `READY` only when `pubspec.yaml`, `lib/`, and the Flutter SDK
     dependency are present; otherwise `INVALID`.
   - **Installation**: `READY` when identity and installation versions match,
     `VERSION_MISMATCH` when they differ, otherwise `INCOMPLETE`.
   - **Initialization**: `READY` when constitution and profile both exist,
     `NOT_INITIALIZED` when neither exists, otherwise `INCOMPLETE`.
   - **Pack target**: `AVAILABLE` when every declared target path is absent,
     otherwise `OCCUPIED` with exact paths. Occupancy is informational, not a
     project-health failure.
   - **Work Items**: treat `VERIFIED` and `CANCELLED` as terminal. List every
     other state as resumable. Mark missing/malformed required files.
4. Resolve each resumable item's next action using the canonical status table
   in `FLUTTER-WORKFLOW.md`.
5. Set overall `ATTENTION` for invalid/incomplete/mismatched workflow health,
   malformed Work Items, or items in `NEEDS_EVIDENCE`/`BLOCKED`. Otherwise use
   `READY`.
6. Render exactly this compact shape in the developer's language:

```text
Workflow Check
Workflow        v1.0.0
Project         READY
Installation    READY
Initialization  READY
Packs           1 available
Pack Targets    auth-account-v1: AVAILABLE
Work Items      1 resumable
- FW-0001 · component · Last Gate: PLAN_READY · Next Action: Review or approve Plan
Overall         READY
```

## Boundaries

- Do not write or repair files.
- Do not create a Work Item.
- Do not run format, code generation, analyze, tests, builds, or the app.
- Do not use the network or compare against a remote repository.
- Report uncertainty as `ATTENTION`; never infer missing state.
