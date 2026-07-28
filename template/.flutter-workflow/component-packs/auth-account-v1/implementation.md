# Implementation Flow

1. Require completed workflow initialization.
2. Read every file listed by `pack.yaml`.
3. Create the next `FW-NNNN-auth-account` Work Item with all four required
   artifact files, type `component`, source skill `flutter-add-component`,
   `pack_id: auth-account-v1`, and state `DISCOVERY`.
4. Run discovery and conflict preflight. Stop `BLOCKED` on target conflicts.
5. Ask the configuration questions with the required progress counters.
6. Save the configuration review and combined Playback in `spec.md` using the
   shared Playback template. Include behavior, edge/UI states, exclusions,
   reuse, target files/layers, prerequisites, dependencies, platforms,
   security, TODOs, and verification.
7. Set `PLAYBACK_READY` and wait for explicit approval. Record it and set
   `PLAYBACK_APPROVED`; requested edits are not approval.
8. Write a decision-complete `plan.md` using the shared Plan template, covering
   interfaces, static field/flow generation, data flow, callbacks, navigation,
   failure behavior, localization, code generation, and verification. Set
   `PLAN_READY`, wait for explicit approval, then set `PLAN_APPROVED`.
9. Implement only selected fields and flows. Search again immediately before
   adding dependencies or shared helpers.
10. If implementation reveals undeclared material impact, return to Playback
    and Plan approval.
11. Format changed Dart files, run affected code generation, run
    `flutter analyze`, and exercise the affected scenario when available.
12. Write `result.md` using the shared Result template with generated files,
    configuration, API TODO locations, commands/results, and unresolved work.
    Set `VERIFIED` only when required checks pass; otherwise set `BLOCKED`.

## Generation rules

- Generate static application code; do not create a runtime form engine.
- Use the root `pubspec.yaml`; never create a package or another pubspec.
- Prefer existing capability, Flutter/Dart native, smallest feature-owned code,
  then an approved dependency.
- Do not add social login, multiple simultaneous auth methods, profile images,
  remote config, API contract importers, or design presets in V1.
- Do not create unit tests, widget tests, test packages, a CLI generator, or
  hardcoded backend schemas.
- Do not commit, push, or change branches without explicit developer request.
