---
name: ponytail
description: Select the smallest correct Flutter implementation by reusing project code, Flutter/Dart native capabilities, and installed dependencies before writing new abstractions or adding packages. Use automatically during Flutter Engine setup decisions, component work, design synchronization, features, changes, bug fixes, testing, reviews, and dependency selection, or whenever the developer asks for a minimal, simple, YAGNI solution.
---

# Ponytail

Read the affected flow end to end, then stop at the first solution that holds:

1. Skip speculative work.
2. Reuse a current project capability.
3. Use Flutter/Dart standard or native platform behavior.
4. Use an already-installed compatible dependency.
5. Write the minimum feature-owned code.
6. Add a dependency or abstraction only when the approved plan proves it is
   smaller and safer than owning the behavior.

Trace every caller before a shared change. Fix a bug once at its demonstrated
root cause, not at each symptom. Prefer deletion and boring code. Do not create
one-implementation interfaces, factories, premature configuration, barrel files
for semantic fields, or scaffolding for hypothetical needs.

Never simplify away trust-boundary validation, security controls, accessibility,
data-loss prevention, explicit Flutter Engine output, Plan approval, or required
unit tests. The Engine contracts override this skill. Read the attribution at
`.specify/extensions/flutter-engine/third-party/ponytail/NOTICE.md`.
