# Discovery

Inspect and record exact project capabilities before asking configuration
questions or proposing files.

## Project baseline

- Read `pubspec.yaml`, repository guidance, the approved constitution/profile,
  entrypoints, and representative complete features.
- Locate the actual feature root, naming, imports, barrel/part conventions, code
  generation, dependency injection, navigation, localization, theme, assets,
  shared widgets, validators, and form ownership.
- Locate the actual Cubit/state, repository, network client, endpoint, HTTP
  method, error, model, cache/session, logging, and callback conventions.
- Search existing auth, profile, session, logout, OTP, password, URL-launching,
  and account-deletion capabilities and their consumers.
- Record installed packages and reuse them before proposing a dependency.

Do not invent project APIs. When a backend endpoint or response mapping cannot
be discovered, declare a narrow configuration TODO in the playback and plan.

## Conflict preflight

Check both target paths immediately after creating the component work item:

```text
lib/features/auth
lib/features/account_management
```

If either exists, set the work item to `BLOCKED`, list every conflicting path,
and stop without changing production code. Do not merge, overwrite, rename, or
partially generate the pack.

An architecture difference elsewhere in the project is not a blocker. Record
the difference and include the smallest missing prerequisite required for the
new pack in the playback and plan.

## Discovery output

Before configuration, retain a reuse matrix covering:

- exact reusable symbols and paths;
- missing prerequisites;
- endpoint/mapping TODOs;
- direct dependency impact;
- affected platforms and manifests;
- target paths and verified absence of conflicts.
