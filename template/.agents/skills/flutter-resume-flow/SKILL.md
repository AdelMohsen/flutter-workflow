---
name: flutter-resume-flow
description: Resume a saved Flutter workflow Work Item from its current gate without duplicating work or losing approvals. Use when the developer sends "flutter flow:resume", invokes $flutter-resume-flow, opens a new Codex conversation to continue work, or asks to continue a specific FW-NNNN Work Item.
---

# Flutter Resume Flow

Continue a saved Work Item instead of creating a replacement.

## Select the Work Item

1. Render the standard startup banner from
   `.flutter-workflow/workflow.json` with flow `Resume Flow` and the current
   workspace name. Render it once.
2. Read `FLUTTER-WORKFLOW.md`, `.flutter-workflow/output-templates.md`,
   constitution/profile, and repository guidance. Require completed
   initialization.
3. Read every `work-item.yaml`. Exclude terminal `VERIFIED` and `CANCELLED`
   items.
4. If no resumable item exists, report that result and stop without writing.
5. If the developer named an ID, select its exact resumable match. Otherwise:
   - select the only resumable item automatically;
   - when several exist, list ID, type, slug, status, and `updated_at`, then ask
     one selection question.
6. Read the selected `work-item.yaml`, `spec.md`, `plan.md`, and `result.md`
   completely. Stop `ATTENTION` if any required file or metadata is malformed.

## Resolve the source

- Prefer `source_skill` from metadata.
- For legacy items without it, map `new` → `flutter-new-feature`, `change` →
  `flutter-change-feature`, `bug` → `flutter-fix-bug`, and `component` →
  `flutter-add-component`.
- For component items, prefer `pack_id`. When absent, use the only installed
  Pack if there is exactly one; otherwise ask one Pack-selection question.
- Read the resolved source Skill and referenced Pack files completely. Do not
  start another agent or invoke a nested flow.

## Resume from status

- `DISCOVERY` / `NEEDS_INPUT`: continue only unresolved discovery or the next
  material question.
- `NEEDS_EVIDENCE`: restate the exact missing evidence and wait.
- `PLAYBACK_READY`: show the saved Playback and request feedback or clear
  approval.
- `PLAYBACK_APPROVED`: preserve approval and create/complete the Plan.
- `PLAN_READY`: show the saved Plan and request feedback or clear approval.
- `PLAN_APPROVED` / `IMPLEMENTING`: inspect current Git state, planned files,
  consumers, and relevant code for material drift before continuing. If drift
  changes approved scope, return to Playback and Plan approval.
- `BLOCKED`: recheck the recorded blocker. If cleared, infer the next step from
  saved approvals and artifacts; if ambiguous, ask one question.

Never reset an approval or repeat an approved question. Accept any unmistakable
approval in the developer's language; comments or requested changes are not
approval.

## Persist progress

- Continue in the same Work Item directory; never allocate another ID.
- Update `updated_at`, status, and artifacts only when progress occurs.
- Follow `.flutter-workflow/output-templates.md` for Playback, Plan, and Result.
- Return to the source Skill's verification and safety rules.

## Boundaries

- Do not resume `VERIFIED` or `CANCELLED`.
- Do not change branches, commit, or push without explicit request.
- Do not discard saved decisions to simplify resumption.
- Do not change production code before both approvals remain valid.
