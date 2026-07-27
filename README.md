# Flutter Codex Workflow

A lightweight, Codex-only delivery workflow for existing Flutter projects.

It gives Codex a repeatable process for understanding a project, planning work,
waiting for explicit approval, implementing the approved scope, and recording
the result.

## What V1 provides

| Chat command | Purpose |
| --- | --- |
| `flutter workflow:init` | Inspect the project and establish its workflow constitution and profile |
| `flutter flow:new` | Clarify, plan, and build a new Flutter feature |
| `flutter flow:change` | Safely change an existing feature |
| `flutter flow:bug` | Reproduce, trace, and fix a defect at its root cause |

V1 is intentionally small. It does not create Flutter projects, use Spec Kit,
run a whole-project audit, generate auth-specific recipes, or require
unit/widget tests.

## Requirements

- An existing Flutter project containing `pubspec.yaml` and `lib/`
- Dart available on `PATH` through a Flutter installation
- Codex with project-local skill support
- Git, if the installed workflow files will be committed with the target project

The installer uses only the Dart standard library. This repository does not
need its own `pubspec.yaml`.

## Install

### Install from inside the Flutter project

On macOS, Linux, WSL, or Git Bash, open the Flutter project directory and run:

```bash
curl -fsSL https://raw.githubusercontent.com/AdelMohsen/flutter-workflow/main/install.sh | bash
```

The current directory is used as the target. The script downloads the latest
workflow into a temporary directory, runs the Dart installer, and removes the
temporary clone.

### Install from a local clone

Clone the workflow repository:

```bash
git clone https://github.com/AdelMohsen/flutter-workflow.git
```

Then install it into a Flutter project:

```bash
dart run flutter-workflow/install.dart \
  --target /absolute/path/to/flutter-project
```

The installer verifies the target before writing and adds:

```text
flutter-project/
├── FLUTTER-WORKFLOW.md
├── .agents/
│   └── skills/
│       ├── flutter-project-init/
│       ├── flutter-new-feature/
│       ├── flutter-change-feature/
│       └── flutter-fix-bug/
└── .flutter-workflow/
    ├── installation.json
    └── work-items/
```

Re-running the installer updates only workflow-owned files. It preserves:

```text
.flutter-workflow/constitution.md
.flutter-workflow/project-profile.md
.flutter-workflow/work-items/
```

Commit the installed workflow files with the Flutter project so the whole team
uses the same delivery rules.

## Initialize the target project

Open a Codex task rooted at the Flutter project, then send this message inside
the Codex conversation:

```text
flutter workflow:init
```

This is a chat activation token, not a terminal command.

Codex inspects:

- project and feature structure;
- BLoC/Cubit conventions;
- repositories, networking, endpoints, models, errors, and cache;
- dependency injection and navigation;
- localization, RTL, theme, assets, and shared widgets;
- validators, installed packages, code generation, and project commands.

Codex presents an initialization playback and asks about material unknowns. It
does not write the workflow documents until you approve the playback.

After approval it creates:

```text
.flutter-workflow/
├── constitution.md
└── project-profile.md
```

- `constitution.md` contains the approved rules for future work.
- `project-profile.md` records exact project paths, imports, reusable widgets,
  helpers, packages, and commands.

An architecture difference does not stop initialization. It is recorded for
future decisions.

## Create a new feature

Send:

```text
flutter flow:new
```

Or invoke the skill directly:

```text
$flutter-new-feature
```

New features follow:

```text
Widget → Cubit → Repository → Network
```

Before adding code, Codex searches for existing project capabilities, Flutter
or Dart native solutions, shared widgets, validators, helpers, and installed
packages.

If the project lacks a required BLoC, repository, or network prerequisite,
Codex includes the smallest prerequisite in the playback and plan instead of
stopping.

## Change an existing feature

Send:

```text
flutter flow:change
```

Or:

```text
$flutter-change-feature
```

Codex baselines the current implementation, identifies consumers, and proposes
the smallest compatible delta. It preserves the existing feature architecture.
It does not migrate that feature to BLoC unless the migration is explicitly
requested and approved.

## Fix a bug

Send:

```text
flutter flow:bug
```

Or:

```text
$flutter-fix-bug
```

Codex collects the observed and expected behavior, reproduction steps,
environment, and sanitized evidence. It traces callers and layers until it can
prove the root cause.

If the evidence is insufficient, the flow stops with `NEEDS_EVIDENCE`. It does
not guess a fix.

## Approval flow

Every `new`, `change`, and `bug` flow uses two explicit gates:

1. **Playback approval** — confirms behavior, edge cases, UI states, reuse,
   affected layers, packages, platforms, and verification.
2. **Plan approval** — confirms the decision-complete implementation plan.

Production code is not changed before both approvals. If implementation reveals
an undeclared material impact, Codex returns to the playback and plan.

## Work items

Each delivery flow records its state under:

```text
.flutter-workflow/work-items/FW-NNNN-descriptive-slug/
├── work-item.yaml
├── spec.md
├── plan.md
└── result.md
```

These files preserve decisions and allow another Codex task to resume the work.

## Verification

After implementation, the workflow:

1. formats changed Dart files;
2. runs affected project code generation;
3. runs `flutter analyze`;
4. exercises the affected scenario when a device or suitable runtime is
   available;
5. records exact results and unresolved TODOs.

V1 does not generate or require unit tests or widget tests.

## Update

Update the local workflow clone:

```bash
cd flutter-workflow
git pull
```

Run the installer again for each target project:

```bash
dart run install.dart --target /absolute/path/to/flutter-project
```

Managed workflow files are refreshed. Project-owned constitutions, profiles,
and work items remain unchanged.

After an update, start a new Codex task in the target project so project-local
skills are discovered from the updated files.

## Maintainer check

Analyze the installer and run its framework-free smoke check:

```bash
dart analyze install.dart
dart analyze tool/smoke.dart
dart run tool/smoke.dart
```

The smoke check creates temporary fixtures, verifies valid/invalid installation,
checks reinstallation preservation, and removes its fixtures when finished.

## Safety boundaries

- No branch creation, switching, renaming, or deletion
- No commit or push without an explicit developer request
- No production credentials or unsanitized secrets in workflow inputs
- No new dependency hidden outside the approved playback and plan
- No architecture migration hidden inside a feature change or bug fix
- No unit/widget test requirement in V1
