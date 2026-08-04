# Command contracts

Read the shared lifecycle in `../lifecycle.md` before a mutating flow.

| Chat command | Contract | Plan approval |
| --- | --- | --- |
| `flutter run flow:chat` | Read-only project/Engine Q&A, architecture explanation, brainstorming, comparison, and current research with evidence. | No |
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

## Chat

Read only the relevant Constitution, project profile, Design Contract,
component locks, active/history Work Items, repository files, local Git history,
Engine references, and relevant Figma MCP context when connected. Search
progressively instead of loading the repository.
For current or requested research, prefer primary/official sources and provide
links. Format material claims as `Project Fact`, `Engine Rule`,
`External Evidence`, `Inference`, or `Recommendation`.

Chat creates no Work Item, lock, plan, or files. It may coexist with an active
mutating Work Item but never changes it. When the user requests implementation,
route new behavior to `feature`, existing behavior to `change`, defects to
`bug`, and Foundation/catalog work to `component`; carry the sanitized chat
context into the new Work Item.

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

## Delivery discovery

Discover project facts before asking. A question is material only when its
answer changes behavior, scope, a business rule, UI state, navigation, API/data
contract, security, persistence, compatibility, acceptance, or verification.
Group every independent material question in one batch without a numeric cap;
organize by Business, Scenarios, UI, Data, and Security. Ask dependent questions
after the triggering answer. Always accept free text and partial replies; never
repeat answered/discoverable questions.

The feature name and basic functional goal are required. Cover relevant gaps:

- actors, triggers, business goal/rules, success outcome, and out of scope;
- happy, negative, edge, loading, empty, error, retry, cancel, duplicate-action,
  and partial-failure behavior when applicable;
- designs: Figma, URL, images/files, or `Not available yet`;
- screens, navigation, platforms, responsiveness, and accessibility;
- APIs: OpenAPI/Swagger/Postman/docs or `Not available yet`;
- request/response/errors/auth, cache/offline/storage, and localization;
- reusable components/form fields, sensitive data, and unit-testable behavior.

Ask whether an API exists and accept Swagger/OpenAPI/Postman/docs, request and
response samples, a written contract, or `Not available`. Read only relevant
operations, authentication, parameters, status codes, and error schemas. If a
protected URL cannot be read, request a sanitized export; never store
credentials.

Missing design uses the Design Contract, project theme, then Foundation
defaults. Missing ordinary API input uses a typed static repository or deferred
network implementation and is recorded in `context.md`. Never invent endpoints
or schemas. Sensitive side effects never return fake success.

Do not reach `SPEC_READY` before actors/triggers, business rules, happy/negative/
edge scenarios, applicable UI states, navigation/exit behavior, data source,
security/privacy, acceptance, out of scope, and missing-input fallbacks are
explicit. `Open decisions` must be `none`.

## Change and bug

For change, discover current behavior, desired delta, consumers, compatibility,
data migration, updated scenarios, and regression checks. Preserve the current
feature structure unless migration is explicitly requested; compare the minimum
delta with migration in the plan.
For bug, capture observed/expected/reproduction/environment/sanitized evidence,
trace all callers and layers, and use `NEEDS_EVIDENCE` until root cause is
demonstrated. Never plan a guessed fix.

## Engine update

Read `../migration.md`. Compare release identity/changelog/component versions,
stage outside managed destinations, validate skills/manifests/workflows and
SHA-256, then present migration and rollback in one plan. Only after approval
invoke the staged `install.dart` with `--allow-version-update`. A direct
installer run without that flag must refuse any version change.
