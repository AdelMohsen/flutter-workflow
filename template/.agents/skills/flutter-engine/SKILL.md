---
name: flutter-engine
description: Operate the INNOVA DIGITS Flutter Engine and dispatch all `flutter run flow:*` commands for read-only project/Engine chat and research, setup, onboarding, reusable components, Figma/design synchronization, new features, changes, bug fixes, unit tests, verification, resume, health checks, and Engine updates. Use whenever a developer asks about, brainstorms, researches, builds, or modifies an Engine-installed Flutter project, invokes an Engine command, or continues an Engine Work Item.
---

# Flutter Engine

Treat `flutter run flow:*` as conversation intent, never a shell command.

## Start

1. Read `.specify/extensions/flutter-engine/engine.json`, then render once:

   ```text
   ╭────────────────────────────────────────────────╮
   │ INNOVA DIGITS ENGINEERING                      │
   │ Flutter Engine · v<version>                    │
   │ Automation: OpenAI Codex                       │
   ╰────────────────────────────────────────────────╯

   Flow        <flow label>
   Workspace   <project folder>
   ```

2. Read the command table in
   `.specify/extensions/flutter-engine/references/commands/commands.md` and only
   the references it routes to.
3. For a mutating flow, read `references/lifecycle.md`, acquire its single
   active-session lock, and create or resume one Work Item.
4. Apply `$ponytail`, `$flutter-owasp-security`, and `$flutter-unit-tests` during
   ordinary delivery. Flutter Engine approval, security, testing, documentation,
   and session rules take precedence over supporting skills.

## Execute

- Discover before asking. Ask only questions whose answers change behavior,
  scope, business rules, UI states, navigation, data/API contracts, security,
  persistence, compatibility, acceptance, or verification.
- Group every independent material question in one clearly sectioned batch,
  without an arbitrary count. Ask dependent follow-ups only after the answer.
  Accept unrestricted free text; suggestions are examples, not answer limits.
- Discover before planning. Use repository evidence, never guessed API/design
  contracts. Read relevant Work Item history and all consumers of changed shared
  behavior.
- Create `context.md` with material answers, sanitized evidence, project facts,
  missing inputs, declared fallbacks, and later resolutions. Do not reach
  `SPEC_READY` until scenarios close and every missing input has a safe fallback
  or deferred scope.
- Write the spec and decision-complete plan. There is no Playback approval.
  Stop at `PLAN_READY` until the user explicitly approves the exact plan hash.
- After approval, implement only the plan, verify proportionately, write
  tasks/decisions/result, refresh the profile/component lock, and release the
  session lock at `VERIFIED` or `CANCELLED`.
- Never create branches, commits, pushes, remote changes, or additional Codex
  sessions unless the user explicitly asks. Never spawn subagents for a Flow.

## Recover

`flow:resume` reads the active lock, `context.md`, and every durable Work Item
artifact. Preserve approvals whose plan hash still matches. Recheck Git/code drift before continuing from
`PLAN_APPROVED`, `IMPLEMENTING`, or `BLOCKED`. Never duplicate the Work Item.

`flow:check` is read-only and returns `READY` or `ATTENTION` with installed
versions, initialization, component status, active/incomplete Work Items, last
gate, drift, and one next action. It does not run analyze or create files.

## Chat

`flow:chat` is read-only and takes no session lock, Work Item, or approval. Read
only the relevant Constitution, profile, design/component state, Work Item
history, code, Git history, Engine references, and Figma MCP context when the
question is design-related and the connection is available. Search locally before
answering; use current primary sources when the user requests research or facts
may have changed. Separate project facts, Engine rules, external evidence,
inference, and recommendation. Cite local files and external links.

Never mutate from chat. Carry the discussion into `context.md` when the user
switches to `feature`, `change`, `bug`, or `component`, so they do not repeat
answers. Chat may run while a mutating Work Item exists but must not alter it.
