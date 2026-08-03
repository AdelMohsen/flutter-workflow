---
name: flutter-engine
description: Operate the INNOVA DIGITS Flutter Engine and dispatch all `flutter run flow:*` chat commands for setup, onboarding, reusable components, Figma/design synchronization, new features, changes, bug fixes, unit tests, verification, resume, health checks, and Engine updates. Use whenever a developer types an Engine command, asks to build or modify Flutter code in an Engine-installed project, or needs to continue an Engine Work Item.
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

   created by Adel Mohsen
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

- Ask one material question at a time in the user's language; keep identifiers
  in English. Show dynamic progress when a questionnaire has multiple steps.
- Discover before planning. Use repository evidence, never guessed API/design
  contracts. Read relevant Work Item history and all consumers of changed shared
  behavior.
- Write the spec and decision-complete plan. There is no Playback approval.
  Stop at `PLAN_READY` until the user explicitly approves the exact plan hash.
- After approval, implement only the plan, verify proportionately, write
  tasks/decisions/result, refresh the profile/component lock, and release the
  session lock at `VERIFIED` or `CANCELLED`.
- Never create branches, commits, pushes, remote changes, or additional Codex
  sessions unless the user explicitly asks. Never spawn subagents for a Flow.

## Recover

`flow:resume` reads the active lock and durable Work Item. Preserve approvals
whose plan hash still matches. Recheck Git/code drift before continuing from
`PLAN_APPROVED`, `IMPLEMENTING`, or `BLOCKED`. Never duplicate the Work Item.

`flow:check` is read-only and returns `READY` or `ATTENTION` with installed
versions, initialization, component status, active/incomplete Work Items, last
gate, drift, and one next action. It does not run analyze or create files.
