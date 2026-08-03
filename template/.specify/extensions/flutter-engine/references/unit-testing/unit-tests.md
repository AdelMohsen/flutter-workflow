# Flutter unit-test contract

Apply automatically to feature, change, bug, and component flows when logic
changes. Add the smallest meaningful tests to the same plan and approval. For
trivial UI wiring, record `UNIT_TEST_NOT_APPLICABLE` with a reason.

Test observable behavior for validators, formatters, normalizers, models/JSON,
params, pure logic, Cubit state transitions, repository response/error mapping,
and cache/session helpers. Prefer direct instances and simple fakes. Use the
project's existing tools; add `bloc_test` only when a Cubit state sequence makes
it materially clearer, and list any new dev dependency in the plan.

Do not force a broad production refactor for tests. If testability needs a seam,
plan the smallest one. V2 excludes widget, golden, and integration tests unless
the user explicitly expands scope.

Use the existing test layout. A new Foundation defaults to:

```text
test/unit/core/
test/unit/features/
```

Run focused `flutter test` targets first, then the approved verification suite.
Standalone `flow:unit-test` backfills old code; `flow:test` only runs existing
tests and never modifies production or test files.

Primary references:

- https://docs.flutter.dev/testing/overview
- https://docs.flutter.dev/cookbook/testing/unit/introduction
- https://pub.dev/packages/bloc_test
