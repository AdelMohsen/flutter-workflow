# Discovery

Prove that the target is a clean Flutter project before asking configuration
questions or proposing production files.

## Fresh-project preflight

Inspect `pubspec.yaml`, `lib/`, every Dart entrypoint, repository guidance, the
approved constitution/profile, and detected platform folders.

The Pack may continue only when all conditions hold:

- `lib/app` and `lib/core` do not exist;
- `lib/main.dart` exists;
- no Dart file other than `lib/main.dart` exists under `lib/`;
- no alternate entrypoint such as `lib/main_dev.dart` exists.

On any failure, set the Work Item to `BLOCKED`, list every conflicting path, and
stop without editing production files. Do not merge, overwrite, rename, delete,
or partially generate the Pack.

## Baseline

Before configuration, record:

- the current package name and Flutter/Dart constraints;
- installed direct dependencies and dependency conflicts;
- detected Android, iOS, web, macOS, Windows, and Linux folders;
- the exact identity files used by each detected platform;
- existing localization/code-generation configuration;
- commands required for formatting, localization generation, analysis, and
  running the application.

Do not create missing platform folders. Do not use the network during discovery.

## Discovery output

Retain a preflight matrix with:

- fresh-project result and exact conflicts;
- detected platforms and identity targets;
- dependency additions or compatible existing versions;
- files to create or update after both approvals;
- code-generation commands;
- security and configuration TODOs.
