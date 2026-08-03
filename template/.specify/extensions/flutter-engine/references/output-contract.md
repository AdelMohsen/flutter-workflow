# Work Item output contract

Every Work Item contains `spec.md`, `plan.md`, `tasks.md`, `decisions.md`, and
`result.md`. Use the templates under `.specify/templates/flutter-engine/`.

Required metadata: id, type, source skill, component ID when relevant, state,
created/updated UTC timestamps, Git base/ref, plan hash/approval timestamp, and
links to predecessor Work Items. Never store secrets or raw sensitive evidence.

Verification evidence names the command, exit status, and concise result.
Separate failures caused by the change from pre-existing failures.
