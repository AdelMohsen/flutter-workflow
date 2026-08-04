# Flutter Engine

Spec-driven Flutter delivery for OpenAI Codex, owned by **INNOVA DIGITS**.

```text
╭────────────────────────────────────────────────╮
│ INNOVA DIGITS ENGINEERING                      │
│ Flutter Engine · v2.1.0                        │
│ Automation: OpenAI Codex                       │
╰────────────────────────────────────────────────╯
```

Flutter Engine is installed inside one Flutter project. It combines GitHub
Spec Kit artifacts and gates with project-local Codex skills, Flutter-specific
architecture/reuse rules, reusable component blueprints, Figma-aware design
sync, OWASP guidance, and focused unit testing.

It is not a Dart package, runtime framework, or terminal CLI. The public
`flutter run flow:*` tokens below are messages sent to Codex. Terminal commands
are used only to install the Engine, run project tools, or maintain releases.

## Requirements

- An existing Flutter project with `pubspec.yaml` and `lib/`.
- Flutter/Dart and Git on `PATH`.
- OpenAI Codex with project-local skill support.
- [GitHub Spec Kit](https://github.com/github/spec-kit). If already installed,
  the installer initializes its Codex integration. Otherwise `flow:setup`
  installs/initializes a compatible release automatically before delivery work.

The installer uses only the Dart standard library and this repository has no
`pubspec.yaml` of its own.

## One-command install

Open a terminal in the root of the target Flutter project.

### macOS, Linux, WSL, or Git Bash

```bash
curl -fsSL https://raw.githubusercontent.com/AdelMohsen/flutter-workflow/main/install.sh | bash
```

Install into another explicit target:

```bash
curl -fsSL https://raw.githubusercontent.com/AdelMohsen/flutter-workflow/main/install.sh \
  | bash -s -- --target /absolute/path/to/flutter-project
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/AdelMohsen/flutter-workflow/main/install.ps1 | iex
```

### Local clone

```bash
git clone https://github.com/AdelMohsen/flutter-workflow.git
dart run flutter-workflow/install.dart --target /absolute/path/to/flutter-project
```

The download scripts clone into a temporary directory, install into the target,
then remove the temporary clone. They never create a nested Git repository.

After installation, open the Flutter project as a Codex task and send:

```text
flutter run flow:setup
```

Do not paste that line into a shell.

## Installed layout

Engine metadata is collected under `.specify` wherever Spec Kit permits. Codex
skills are the necessary `.agents/skills` exception.

```text
flutter-project/
├── .agents/skills/
│   ├── flutter-engine/
│   ├── ponytail/
│   ├── flutter-owasp-security/
│   ├── flutter-unit-tests/
│   └── speckit-*/
├── .specify/
│   ├── integration.json
│   ├── extensions/flutter-engine/
│   │   ├── components/
│   │   ├── commands/
│   │   ├── references/
│   │   ├── templates/
│   │   └── third-party/ponytail/
│   ├── templates/flutter-engine/
│   ├── workflows/flutter-engine-delivery/
│   ├── workflows/flutter-engine-operations/
│   ├── memory/constitution.md
│   ├── specs/<date>-<slug>-<short-id>/
│   │   ├── context.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   ├── decisions.md
│   │   └── result.md
│   └── flutter-engine/
│       ├── engine.lock.json
│       ├── design/design-contract.json
│       ├── installed/
│       ├── legacy/
│       └── cache/
└── .gitignore
```

Specs, plans, decisions, results, the Design Contract, component locks, and the
Engine lock should be committed. Session/cache files are ignored. Production
code remains in normal Flutter paths such as `lib/app`, `lib/core`, and
`lib/features`; Engine documents are never scattered through production code.

## Gate and Work Item rules

Mutating flows discover and write `spec.md`, then produce a decision-complete
`plan.md`. There is **no Playback approval**. There is one mandatory explicit
Plan Approval before production or Engine-version changes.

Suggested response:

```text
Approve Plan
```

Any clear explicit approval is accepted. Comments, questions, or requested
edits are not approvals. Approval is bound to the plan's SHA-256; a material
scope, interface, dependency, security, or file-impact change invalidates it.

One working copy permits one active Flow. The lock remains active while waiting
for approval. The same work redirects to resume; another flow returns
`ACTIVE_SESSION_EXISTS`. Crash recovery uses `flow:resume`—the Engine never
expires the lock by age and never opens subagents, nested Codex tasks, forks, or
parallel sessions.

Every Work Item also keeps `context.md`: material free-text answers, sanitized
evidence, discovered facts, missing inputs, declared fallbacks, deferred scope,
and later resolutions. Active work updates the same ledger. A completed item is
immutable; later input creates a linked Change Work Item that imports its full
context.

## Command reference

### `flutter run flow:setup`

Use immediately after installation or when managed files are missing.

- Validates the Flutter target, installed Engine lock, Spec Kit, Codex
  integration, skills, workflows, templates, and managed checksums.
- Installs/initializes missing compatible Spec Kit files and repairs the current
  pinned Engine version automatically.
- Does not create a Work Item or require Plan Approval.
- Does not modify Flutter production code, dependencies, SDK, Git branches,
  commits, or remotes.
- Never upgrades to another Engine version silently. Finish with `READY` or an
  exact `ATTENTION` action.

### `flutter run flow:chat`

Read-only project and Engine chat. It creates no Work Item, plan, lock, or file,
and may run while another mutating Work Item is active.

```text
flutter run flow:chat
اشرحلي Network flow في المشروع
```

```text
flutter run flow:chat
قارن أفضل offline approach للمشروع وابحث عن أحدث التوصيات
```

Chat searches only relevant Constitution/Profile/Design/Work Item/code/Git and
Engine sources, plus Figma MCP context when the question is design-related and
the connection is available. When research is requested or facts may have
changed, it uses current primary sources and provides links. Answers distinguish
project facts, Engine rules, external evidence, inference, and recommendation.

Chat never implements. A request for new behavior moves to `flow:feature`, an
existing behavior delta to `flow:change`, a defect to `flow:bug`, and Foundation
or catalog work to `flow:component`. The discovered context is copied into the
new Work Item so the user does not repeat it.

### `flutter run flow:onboard`

Use when the project already exists and the Engine must understand it.

- Discovers entrypoints, architecture and feature paths, BLoC/state management,
  network/repositories/models/errors, routing, storage, localization/RTL, theme,
  assets, shared widgets/form fields, platforms, packages, code generation,
  tests, and verified project commands.
- Writes project facts and constitution rules, not guesses: dependency
  direction, routing/deep links, network/error contracts, storage/log security,
  localization/theme/assets, adaptive/responsive behavior, reusable UI/form
  fields, platforms, code generation, tests, debt, and missing inputs.
- Records architecture differences without stopping or forcing migration.
- Does not change production code, create a Work Item, or require a plan.

Run onboarding before modifying an established project. Successful Foundation
verification performs the same finalization for a clean project.

### `flutter run flow:component`

Lists independently versioned components and their status:

```text
AVAILABLE · INSTALLED · UPDATE_AVAILABLE · CUSTOMIZED · NEEDS_REPAIR · CONFLICT
```

The user selects a component and `add`, `update`, or `repair`. The Engine runs
component-specific discovery, groups independent material questions, accepts
free text, and uses the installed baseline, project modifications, and new
component version for three-way reasoning. It never overwrites customized code
silently.

V2 includes:

1. **Project Foundation · v2.1.0** — sanitized clean-project `app/core`
   blueprint without
   DI/service locator. It asks for app identity, bundle/application ID, package
   name, platforms, design/palette, locales, build API configuration, starter,
   and optional modules. It includes adaptive Android/iOS UI, 720px iPad/Web
   content, Web routing/metadata, secure storage, generated localization, safe
   debug tracing, central feedback/form fields, and image/file picking. It
   copies no reference branding, URLs, keys, features, images, icons, or strings.
2. **Authentication & Account Management · v2.0.0** — configurable email/phone,
   password/OTP, auth/account flows, custom fields, guest/post-registration
   behavior, UI + Logic or Logic Only, Arabic/English and RTL/LTR. It refuses
   replacement when an Auth/Account domain already exists.

Component definitions update with the Engine, but production components change
only through this flow and an approved plan.

### `flutter run flow:design-sync`

Normalizes a design source into
`.specify/flutter-engine/design/design-contract.json`.

Supported inputs are Figma MCP, Figma URL/node, token JSON, exported assets and
styles, manual values, or `Not available yet`. A write lists changed tokens,
components, consumers, theme/localization impact, and rollback in a plan.

If Figma MCP is disconnected, expired, or inaccessible, Codex explains the
connection problem and offers reconnect/another URL, JSON, exports, manual
values, or skip. Credentials are never stored. Missing design does not block a
feature: explicit flow design wins, then the Design Contract, existing theme,
and finally generic Foundation defaults for a clean project.

### `flutter run flow:feature`

Discovery searches the project before asking. A question is allowed only when
its answer changes behavior, scope, business rules, UI states, navigation,
API/data, security, persistence, compatibility, acceptance, or verification.
Every independent material question is grouped in one sectioned batch without a
numeric limit; dependent follow-ups wait for the triggering answer. Suggested
answers are examples only—every question accepts unrestricted free text and
partial replies.

Feature discovery closes:

- actors, triggers, business goal/rules, success outcome, and out of scope;
- happy, negative, edge, loading, empty, error, retry, cancel,
  duplicate-action, and partial-failure scenarios when applicable;
- designs/screens/navigation/platform/responsive/accessibility behavior;
- API documentation, request/response/errors/auth and missing-contract choices;
- cache/storage/offline, localization, reusable components/form fields;
- sensitive data/security, acceptance, and verification.

Feature name and basic functional goal are required. `Not available yet` is a
valid design or API answer. Missing design uses Design Contract, project theme,
then Foundation defaults. Missing API never causes invented endpoints/schemas:
use a typed static repository or defer Network integration. Auth, payment,
account deletion, and other sensitive side effects never show fake success.

API inputs may be Swagger/OpenAPI URL, Postman, docs, request/response samples,
or a written contract. The Engine reads only relevant endpoints, auth, params,
status codes, and error schemas. Protected sources require a sanitized export;
credentials are never stored.

New features follow the project-adapted Engine direction:

```text
Widget → Cubit → Repository → Network
```

This remains the standard even when older features use another architecture;
missing prerequisites appear in the plan. The flow reuses current project
capabilities first, then Flutter/Dart native behavior, installed dependencies,
minimum owned code, and only then a new compatible dependency.

### `flutter run flow:change`

The first question is the feature/module name. Codex baselines current behavior,
desired delta, structure, callers, consumers, compatibility, migrations, tests,
design/API contracts, updated scenarios, and regression checks.
It preserves the current feature architecture and applies the smallest approved
change. Migration to the Engine feature standard is compared separately and is
never automatic.

### `flutter run flow:bug`

The first question is the feature/module name, followed by observed behavior,
expected behavior, reproduction, environment, and sanitized evidence. Codex
traces callers and layers until the root cause is demonstrated. Without enough
evidence the Work Item becomes `NEEDS_EVIDENCE`; no guessed fix or plan is
produced. Once proven, the smallest root-cause fix requires Plan Approval.

## Specification readiness and missing inputs

Every mutating flow writes `context.md` and a specification containing Business
Context, Actors/Triggers, Business Rules, Happy/Negative/Edge Scenarios, UI
States, Data Source, API/Error Contract, Security, Asset/Localization Impact,
Acceptance, Out of Scope, Missing Inputs, Open Decisions, and Readiness.

`SPEC_READY` requires closed applicable scenarios, an explicit data source, no
hidden assumption, and either a fallback or deferred scope for every missing
input. `Open Decisions` must be `none`. Missing-input states are:

```text
MISSING · FALLBACK_SELECTED · DEFERRED · RESOLVED · NO_LONGER_NEEDED
```

The ledger records ID, impact, fallback, deferred behavior, requested source,
and resolution. Later API/design/copy/assets update an active Work Item or create
a linked Change Work Item from an immutable completed predecessor.

### `flutter run flow:unit-test`

Backfills focused unit tests for existing code without changing behavior. It
identifies observable cases, existing test conventions, minimal fakes, files,
and any compatible dev dependency in a plan. If testability requires a
production seam, that exact minimal change must be approved too.

Current scope covers validators/formatters/normalizers, models/JSON, params,
pure logic, Cubit transitions, repository mapping/errors, and cache/session
helpers. Widget, golden, and integration tests are outside V2 unless explicitly
added later.

### `flutter run flow:test`

Runs existing focused tests and relevant verified project commands. It may run
existing code generation, formatting checks, and `flutter analyze`, but it is
read-only with respect to source/tests and has no Plan gate. It reports changed
failures separately from pre-existing failures.

### `flutter run flow:resume`

Resumes the single durable Work Item; it never creates a duplicate. It restores
the original skill/component, `context.md`, missing-input ledger, spec, plan,
tasks, decisions, result, state, and valid approvals. Before continuing from `PLAN_APPROVED`,
`IMPLEMENTING`, or `BLOCKED`, it rechecks Git/code drift. Completed `VERIFIED`
and `CANCELLED` items are immutable.

### `flutter run flow:check`

Read-only health/status. It does not run analyze or create a Work Item. It shows:

- Flutter validity, Spec Kit and Engine versions, installation and onboarding;
- managed files/checksums and V1 migration state;
- component availability/install/customization/conflicts;
- active and resumable Work Items, last gate, drift, and next action.

The final result is `READY` or `ATTENTION`.

### `flutter run flow:engine-update`

Checks the installed lock against a requested/released Engine version, reads its
release notes and component changes, and writes a migration/rollback plan. After
approval it downloads to a temporary staging directory, validates manifests,
skills and checksums, runs the installer with explicit version-update authority,
then verifies atomically. It preserves project profiles, specs, approvals,
design contracts, component customizations, and production code.

Re-running the one-line installer repairs the **same pinned version**. It refuses
a version change and directs the developer to this flow.

## Cross-cutting skills

### Ponytail

Every delivery flow searches before writing: existing project capability,
Flutter/Dart native behavior, installed dependency, minimum feature code, then
a justified new dependency. It rejects speculative abstractions and fixes bugs
at the shared root cause. Engine gates, security, tests, and accessibility take
precedence over minimality.

### OWASP security

OWASP impact runs inside onboarding, components, design sync, features, changes,
and bugs—not as a separate audit. Discovery classifies auth/tokens, PII,
storage, TLS/network, crypto, links/WebViews, permissions/biometrics, files,
sensors, logs, payments, API and dependency surfaces. The same plan contains
controls and verification. An introduced critical regression blocks
`VERIFIED`; pre-existing findings are recorded without silently expanding scope.
The Engine never claims OWASP certification or treats client checks as server
authorization.

### Unit tests

Feature/change/bug/component flows automatically assess changed logic and add
the smallest meaningful unit tests to the same plan. Trivial UI wiring records
`UNIT_TEST_NOT_APPLICABLE`. Direct instances and simple fakes come before mocks;
`bloc_test` is added only when Cubit state sequences justify it.

### Reusable semantic form fields

Any semantic field becomes central on first use under:

```text
lib/core/ui/form_fields/
├── default_form_field.dart
├── default_phone_form_field.dart
├── default_email_form_field.dart
├── default_password_form_field.dart
├── default_image_form_field.dart
└── default_file_form_field.dart
```

One field per file; no barrel. A phone field owns input/autofill, calling-code
selection, formatting, local/E.164 normalization, validation, required/read-only
states, localization, theme and accessibility. It does not own API calls, Cubit
events, navigation, or business side effects. Future phone inputs reuse or
extend it and verify existing consumers.

## Foundation platform, assets, and dependencies

Foundation uses Material 3 on Android/Web and Cupertino behavior on iOS/iPad for
shared scaffold, app bar, buttons, dialogs, loader, switch, icons, and page
transitions. `AppContent(maxContentWidth: 720)` keeps phone width natural and
centers iPad/Web content without a responsive package.

When Web exists, Foundation updates sanitized `index.html`/manifest metadata,
uses clean `go_router` paths, preserves back/forward and deep-link refresh, and
documents deployment rewrites, HTTPS/HSTS, WebCrypto, and backend-owned CORS.
It does not add full PWA/offline behavior or store long-lived Web auth secrets.

Foundation copies no reference-project assets or translations. Prefer Material/
Cupertino icons; every custom asset needs one used typed reference and every ARB
key must be used by generated localization. Existing-project orphan candidates
are reported, never deleted silently because dynamic lookup may exist.

Verification is asset/ARB audit, `flutter gen-l10n`, formatting,
`flutter analyze`, focused tests, and platform build smoke. Analyze alone cannot
prove that an asset or translation key is used.

Baseline packages are compatible-current `flutter_bloc`, `dio`, `go_router`,
`flutter_secure_storage`, `google_fonts`, `hexcolor`, `image_picker`,
`file_picker`, one loading solution, one toast solution, Flutter localization,
`intl`, and `cupertino_icons`. `pdf`, `printing`, `open_filex`, and `photo_view`
are optional modules.

## Dependencies and Flutter versions

Component/feature work resolves the latest package versions compatible with the
project's current Flutter/Dart SDK at apply time. A clean Foundation can select
current compatible packages. An existing project receives only required
dependencies—no mass upgrade, `dependency_overrides`, automatic Flutter SDK
upgrade, or stale fixed version copied from a template. Keep `pubspec.lock`
tracked and name code-generation commands in the approved plan.

## V1 migration

Installing V2 beside a V1 `.flutter-workflow` marks `pending_plan` and does not
delete anything. `flow:engine-update` then:

1. inventories V1 constitution, profile, packs, and Work Items;
2. writes a migration/rollback plan and waits for approval;
3. archives source artifacts under `.specify/flutter-engine/legacy/v1`;
4. imports facts/history, preserving previous plan approvals and recording old
   Playback approval as history only;
5. verifies imported data before removing `.flutter-workflow`;
6. rolls back if verification fails.

## Git and teams

The Engine never changes branches, commits, pushes, or opens PRs without an
explicit request. Commit durable Engine artifacts with production changes.
Non-sequential Work Item IDs reduce collisions, but the active-session lock is
local to one working copy and intentionally gitignored. Separate clones require
normal Git/team coordination; no local file can enforce a global team lock.

## Maintainer validation and release

Before publishing an Engine release:

```bash
dart format --output=none --set-exit-if-changed install.dart tool
dart format --output=none --set-exit-if-changed \
  template/.specify/extensions/flutter-engine/components/project-foundation-v2/assets/lib \
  template/.specify/extensions/flutter-engine/components/project-foundation-v2/assets/test
dart run tool/smoke.dart
dart run tool/foundation_smoke.dart
```

Validate all four skills with the official `quick_validate.py`, and validate
the extension/workflow manifests with a compatible Spec Kit CLI. Update the
central version in `engine.json`, `extension.yml`, both workflow manifests, and
release notes together. Component versions remain independent. Tag the release;
do not move an existing version tag.

## Boundaries

V2 does not run parallel agent sessions, create Git branches/commits/pushes,
invent API/design contracts, store Figma credentials/secrets, automatically
upgrade Flutter, or generate widget/golden/integration tests. Project creation
remains `flutter create`; Engine setup begins inside the created or existing
project.
