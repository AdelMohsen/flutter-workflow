# Engine update and V1 migration

## V2 and later

1. Read `engine.lock.json`, the requested release identity and changelog.
2. Inventory project-owned profiles, specs, approvals, design contract,
   component baselines/customizations, and managed-file drift.
3. Stage the release in a temporary directory. Validate the four skills with
   `quick_validate.py`, parse the extension/workflows with Spec Kit, and verify
   release checksums before producing the plan.
4. Plan file ownership, migrations, component definition changes, rollback, and
   known incompatibilities. Wait at the exact plan hash.
5. After approval, back up only replaced managed paths, invoke the staged
   installer with `--allow-version-update`, run setup/check, and remove the
   backup only after verification. Restore it on failure.

Component definition updates never mutate installed production components.
Developers use `flow:component` for each independent add/update/repair.

## V1 to V2

1. Leave `.flutter-workflow` untouched during the initial V2 install and mark
   `migration_state: pending_plan`.
2. Inventory the V1 constitution, project profile, packs, Work Items, states,
   and approval evidence. Create one migration Work Item.
3. Plan mappings and rollback; wait for explicit Plan Approval.
4. Copy source artifacts to `.specify/flutter-engine/legacy/v1`, import the
   constitution/profile/history, preserve old Plan approvals, and record V1
   Playback approvals as historical evidence only.
5. Verify counts, content hashes, links, and resumable state before deleting the
   original `.flutter-workflow` directory.
6. On any failure, restore the original directory and previous V2 lock. Never
   partially delete or infer missing approvals.
