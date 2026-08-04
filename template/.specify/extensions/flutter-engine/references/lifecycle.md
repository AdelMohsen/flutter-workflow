# Delivery lifecycle

For `component`, `design-sync`, `feature`, `change`, `bug`, `unit-test`, and
`engine-update`:

1. Render the banner once and acquire the session lock.
2. Read Engine identity, constitution, project profile, Design Contract,
   component locks, relevant history, and Git/code drift.
3. Discover the current behavior before asking. Group all independent material
   questions; accept free text and ask dependent follow-ups later.
4. Apply Ponytail reuse/minimality, OWASP impact, and unit-test impact.
5. Create `.specify/specs/<date>-<slug>-<short-id>/`, write `context.md`, and
   preserve material answers, evidence, discovered facts, missing inputs,
   fallbacks, and deferred scope.
6. Write `spec.md`. Set `SPEC_READY` only when happy/negative/edge scenarios,
   UI states, data source, security, acceptance, and out-of-scope are explicit;
   every missing input has a safe fallback or deferred scope; and no blocking
   decision remains.
7. Write a decision-complete `plan.md`, set `PLAN_READY`, include its SHA-256,
   and stop for explicit approval.
8. Accept only an unambiguous approval. A comment or requested edit is not an
   approval. Bind approval to the exact plan hash; material drift invalidates it.
9. After approval, write `tasks.md`, implement only the approved scope, verify,
   then write `decisions.md` and `result.md`.
10. Set `VERIFIED` only when required checks pass, refresh project intelligence,
   and release the lock. Otherwise record exact evidence and `BLOCKED`.

There is no Playback gate. `spec.md` is reviewable input to the one Plan gate.
Do not branch, commit, push, or alter remote state unless explicitly requested.

## Single active session

Use the gitignored `.specify/flutter-engine/cache/active-session.json`. Create
it atomically before work. One working copy permits one active Flow. The same
Work Item redirects to resume; another flow returns `ACTIVE_SESSION_EXISTS`.
Keep the lock while awaiting approval. Clear it only at `VERIFIED` or
`CANCELLED`. After a crash, recover only through `flow:resume`; never expire a
lock by age. Do not spawn subagents, nested Codex tasks, forks, or threads.

## Work Item states

`DISCOVERY`, `NEEDS_INPUT`, `NEEDS_EVIDENCE`, `SPEC_READY`, `PLAN_READY`,
`PLAN_APPROVED`, `IMPLEMENTING`, `BLOCKED`, `VERIFIED`, `CANCELLED`.

Completed Work Items are immutable. Create a linked Work Item for later changes.
IDs use `<YYYYMMDD>-<slug>-<short-id>` and are never sequential.

## Missing inputs

Use `MISSING`, `FALLBACK_SELECTED`, `DEFERRED`, `RESOLVED`, or
`NO_LONGER_NEEDED`. Missing design falls back to the Design Contract, project
theme, then Foundation defaults. Missing ordinary API input uses an explicitly
selected typed static repository or deferred integration; never invent an
endpoint/schema. Auth, payment, account deletion, and other sensitive side
effects never report fake success. Missing root-cause evidence keeps a bug in
`NEEDS_EVIDENCE`.

Update an active ledger in place. For a completed predecessor, create a linked
Change Work Item, import its context, and record the later resolution.
