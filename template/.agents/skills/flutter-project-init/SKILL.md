---
name: flutter-project-init
description: Inspect an existing Flutter project and establish its project-local Codex workflow constitution and profile. Use when the developer sends "flutter workflow:init", invokes $flutter-project-init, installs the workflow for the first time, or asks to refresh the recorded Flutter architecture and reusable project capabilities.
---

# Flutter Project Init

Initialize workflow knowledge without changing production code.

## Run the flow

1. Announce Flutter Workflow `1.0.0`, `CHAT_NATIVE` execution, and the current
   project root. Treat a chat command as intent; do not execute it in a shell.
2. Read `FLUTTER-WORKFLOW.md`, repository guidance, `pubspec.yaml`, and existing
   workflow files completely.
3. Verify `pubspec.yaml` declares Flutter and `lib/` exists. Stop only when the
   target is not a Flutter project.
4. Inspect before asking questions:
   - entrypoints, app bootstrap, environments, and platform folders;
   - feature layout and representative complete features;
   - BLoC/Cubit state conventions and controller ownership;
   - repositories, network client, endpoints, errors, cache, and models;
   - dependency injection, navigation, deep links, and callbacks;
   - localization, RTL, theme, design system, assets, and shared widgets;
   - validation, code generation, analysis options, packages, and commands.
5. Search exact symbol definitions and callers. Record real paths and APIs; do
   not invent equivalents.
6. Present one Initialization Playback containing:
   - discovered architecture and reusable capabilities;
   - deviations from `Widget → Cubit → Repository → Network`;
   - missing prerequisites for future new features;
   - proposed constitution rules and project-profile facts;
   - uncertainties that require developer input.
7. Ask one material question at a time until the playback is complete. An
   architecture difference is information, not a reason to stop.
8. Wait for explicit approval. Do not write constitution/profile files before
   approval.
9. Create or refresh `.flutter-workflow/constitution.md` with:
   - new-feature BLoC boundaries;
   - reuse and dependency rules;
   - project UI, localization, navigation, networking, data, security, and Git
     constraints;
   - playback, plan, and verification gates;
   - the V1 rule that unit/widget tests are not required or generated.
10. Create or refresh `.flutter-workflow/project-profile.md` with exact:
    - paths, imports, symbols, and representative feature references;
    - installed packages and preferred existing capabilities;
    - shared widgets, styles, validators, and helpers;
    - commands for formatting, code generation, analysis, and running.
11. Preserve project-specific approved additions when refreshing. Present any
    material removal or changed interpretation before overwriting it.
12. Report the created/updated metadata files and unresolved gaps.

## Boundaries

- Do not edit `lib/`, platform code, manifests, assets, or generated source.
- Do not force an existing feature to adopt the new-feature architecture.
- Do not create a work item for initialization.
- Do not run unit/widget tests or add testing packages.
