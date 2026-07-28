# Acceptance

The Pack is acceptable when all applicable conditions are evidenced:

1. The Work Item contains all four required artifacts and records
   `source_skill: flutter-add-component` and `pack_id: project-foundation-v1`.
2. Any existing `lib/app`, `lib/core`, alternate entrypoint, or additional Dart
   file under `lib/` causes `BLOCKED` before production changes.
3. All seven questions appear one at a time with an accurate fixed counter.
4. Display name, bundle/application ID, and Dart package name are applied to
   every detected platform without creating absent platforms.
5. Arabic/English, RTL/LTR, light/dark themes, and the chosen palette work
   through central localization/theme configuration.
6. All declared reusable widgets exist, use theme tokens, and expose
   data/callback APIs without business or network logic.
7. The fixed dependency set is visible in Playback/Plan and no undeclared
   package is added.
8. `Configure Later` starts without a real API URL and fails clearly only when
   networking is used.
9. Component Showcase uses local data and demonstrates both locale/theme state
   and reusable component states; Empty App Shell remains minimal.
10. No production files are changed before separate Playback and Plan
    approvals.
11. Changed Dart is formatted, localization/code generation is run,
    `flutter analyze` is recorded, and the application scenario is exercised
    when available.

V1 does not require or generate unit tests or widget tests.
