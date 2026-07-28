# Implementation Flow

1. Require completed workflow initialization and read every file listed by
   `pack.yaml`.
2. Create the next `FW-NNNN-project-foundation` Work Item with all four required
   artifact files, type `component`, source skill `flutter-add-component`,
   `pack_id: project-foundation-v1`, and state `DISCOVERY`.
3. Run the fresh-project preflight. On failure, record exact conflicts in the
   Work Item artifacts and stop `BLOCKED` before configuration.
4. Ask the seven questions with the fixed progress counter.
5. Save the final review and Playback in `spec.md` using the shared template.
   Include identity, platforms, UI states, dependencies, security,
   configuration TODOs, files, code generation, verification, and exclusions.
6. Set `PLAYBACK_READY`, wait for explicit approval, record it, and set
   `PLAYBACK_APPROVED`.
7. Write `plan.md` using the shared Plan template. Include exact dependency
   commands, identity files, generated structure, interfaces/data flow,
   failure behavior, localization generation, formatting, analysis, and run
   commands.
8. Set `PLAN_READY`, wait for explicit approval, record it, and set
   `PLAN_APPROVED`.
9. Recheck the clean-project preflight and Git/code drift immediately before
   implementation. Return to approval if the scope changed.
10. Implement in this order:
    - rename package/display/platform identity;
    - add only the fixed approved dependencies to the root `pubspec.yaml`;
    - configure localization and generation;
    - generate app shell, core, reusable UI, and selected starter screen;
    - update `lib/main.dart` to invoke the approved bootstrap.
11. Format changed Dart files, run localization/code generation, run
    `flutter analyze`, and run the application on an available target when
    possible.
12. Write `result.md` using the shared Result template and set `VERIFIED` only
    when required checks pass. Otherwise set `BLOCKED` with exact evidence.

## Fixed stack

Use compatible versions of:

```text
flutter_bloc
dio
get_it
go_router
shared_preferences
flutter_localizations (Flutter SDK)
intl
```

Add the Flutter SDK `flutter_localizations` dependency before resolving `intl`
so the installed Flutter SDK's `intl` pin controls compatibility.

Reuse a compatible direct dependency already present. Never hide a dependency
addition outside Playback and Plan.

## Boundaries

- Generate no feature, backend contract, fake session, or network demo.
- Commit no URL, token, secret, signing value, or production credential.
- Do not add Firebase, flavors, notifications, analytics, crash reporting,
  launcher icons, splash generation, or remote config.
- Do not create unit/widget tests or testing packages in V1.
- Do not commit, push, or change branches without explicit developer request.
