# Command contracts

Read the shared lifecycle in `../lifecycle.md` before a mutating flow.

| Chat command | Contract | Plan approval |
| --- | --- | --- |
| `flutter run flow:setup` | Validate Flutter, install or repair Spec Kit/Codex integration and the pinned Engine files. Migrate no production code. | No |
| `flutter run flow:onboard` | Discover an existing project's architecture, commands, design system, dependencies, risks, and reusable capabilities. Write the project profile and constitution. | No |
| `flutter run flow:component` | List component status, then add, update, or repair one independently versioned component. | Yes |
| `flutter run flow:design-sync` | Normalize Figma MCP, Figma link, JSON, exports, or manual tokens into the Design Contract and plan affected consumers. | Yes when writing |
| `flutter run flow:feature` | Ask for feature name first, discover requirements, write the spec and plan, then implement a new Engine-standard feature. | Yes |
| `flutter run flow:change` | Ask for feature/module first; baseline consumers and apply the smallest approved compatible delta. | Yes |
| `flutter run flow:bug` | Ask for feature/module first; reproduce and prove root cause before proposing a fix. | Yes |
| `flutter run flow:unit-test` | Backfill focused unit tests for existing logic without changing behavior. | Yes |
| `flutter run flow:test` | Run existing focused tests, code generation when already required, formatting checks, and `flutter analyze`; report only. | No |
| `flutter run flow:resume` | Resume the locked Work Item from its last durable state and preserve valid approvals. | Existing gate |
| `flutter run flow:check` | Read-only status for project, Spec Kit, Engine, components, active Work Item, drift, and next action. | No |
| `flutter run flow:engine-update` | Compare installed and available Engine releases, plan migration, then stage and atomically update managed files. | Yes |

## Setup

1. Validate `pubspec.yaml`, `lib/`, Flutter SDK, Git working tree, and target root.
2. Read `engine.lock.json`. If files for its pinned version are missing or have
   an Engine-owned checksum mismatch, restore them without asking for a plan.
3. If Spec Kit or the Codex integration is absent, install the compatible
   current release and initialize it in-place. Prefer an existing `specify`;
   then `uv tool install`; otherwise create the project-local ignored Python
   environment `.specify/flutter-engine/cache/spec-kit-venv` and install only
   the official `github/spec-kit` source there. Verify the reported version and
   repository before initialization. Do not install a system-wide runtime,
   change Flutter SDK/packages/production code, or touch Git remote state.
4. Keep the installed version pinned. Never turn repair into a silent major
   update. Finish with `READY`, or `ATTENTION` plus the exact repair command.

## Onboard

Inspect entrypoints, `app/core/features` or existing equivalents, state
management, network, routing, storage, localization, theme, reusable widgets,
form fields, build/code generation, platforms, tests, and dependency versions.
Record facts and architecture differences; never stop because the architecture
differs. Do not create a Work Item or modify production code.

## Component

Show `AVAILABLE`, `INSTALLED`, `UPDATE_AVAILABLE`, `CUSTOMIZED`,
`NEEDS_REPAIR`, or `CONFLICT`. Ask for the component and action. Run its
discovery/questions contract and use baseline/project/new three-way reasoning.
Never overwrite customized code silently.

## Feature questions

Ask one question at a time with a dynamic count. The feature name and basic
functional goal are required. Cover only relevant unknowns:

- business goal, user story, actor, acceptance, edges, and out of scope;
- designs: Figma, URL, images/files, or `Not available yet`;
- screens, navigation, platforms, responsiveness, and accessibility;
- APIs: OpenAPI/Swagger/Postman/docs or `Not available yet`;
- request/response/errors/auth, cache/offline/storage, and localization;
- reusable components/form fields, sensitive data, and unit-testable behavior.

Missing design does not block: use the Design Contract or existing theme.
Missing API does not authorize invented endpoints or schemas: scope UI/logic or
defer network integration explicitly.

## Change and bug

For change, preserve the current feature structure unless migration is
explicitly requested; compare the minimum delta with migration in the plan.
For bug, capture observed/expected/reproduction/environment/sanitized evidence,
trace all callers and layers, and use `NEEDS_EVIDENCE` until root cause is
demonstrated. Never plan a guessed fix.

## Engine update

Read `../migration.md`. Compare release identity/changelog/component versions,
stage outside managed destinations, validate skills/manifests/workflows and
SHA-256, then present migration and rollback in one plan. Only after approval
invoke the staged `install.dart` with `--allow-version-update`. A direct
installer run without that flag must refuse any version change.
