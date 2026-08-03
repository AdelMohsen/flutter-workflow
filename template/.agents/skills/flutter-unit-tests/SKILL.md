---
name: flutter-unit-tests
description: Assess and add focused Flutter/Dart unit tests for changed logic, or backfill unit tests through `flutter run flow:unit-test`. Use automatically during Flutter Engine feature, change, bug, and component flows when validators, formatters, models, Cubits, repositories, mapping, caching, session, or other testable behavior changes; also use when running or diagnosing existing unit tests.
---

# Flutter Unit Tests

Read `.specify/extensions/flutter-engine/references/unit-testing/unit-tests.md`.

During ordinary delivery, identify changed observable logic and place the
smallest meaningful tests in the same plan. Prefer direct instances and simple
fakes. Reuse the project's test stack; add `bloc_test` only when state-sequence
assertions justify it. Record `UNIT_TEST_NOT_APPLICABLE` for trivial UI wiring.

Run focused tests first and record commands/results. Do not force broad
production refactoring, generate widget/golden/integration tests, or modify
behavior during standalone test backfill without returning to the Plan gate.
