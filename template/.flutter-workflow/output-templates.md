# Workflow Output Templates

Use these sections in order for every delivery Work Item. Keep irrelevant
sections with `Not applicable` only when omitting them could hide a material
decision.

## Playback (`spec.md`)

```text
# Playback — FW-NNNN: Title

## Goal
## Expected Behavior
## Positive / Negative / Edge Cases
## UI States
## Reuse Decisions
## Affected Layers / Platforms
## Dependencies / Security
## Out of Scope
## Verification
## Approval
```

End a ready Playback with:

```text
Suggested response: Approve Playback
```

Accept any unmistakable approval in the developer's language. Comments,
questions, partial agreement, and requested changes are not approval.

## Plan (`plan.md`)

```text
# Plan — FW-NNNN: Title

## Outcome
## Implementation Changes
## Interfaces and Data Flow
## Failure Behavior
## Files and Layers
## Dependencies / Code Generation
## Verification
## Approval
```

End a ready Plan with:

```text
Suggested response: Approve Plan
```

Accept any unmistakable approval in the developer's language. Comments,
questions, partial agreement, and requested changes are not approval.

## Result (`result.md`)

```text
# Result — FW-NNNN: Title

## Summary
## Changed Files
## Verification Evidence
## Remaining TODOs
## Pre-existing Failures
## Final Status
```

Record commands and observed results exactly. Do not claim a check passed when
it did not run.
