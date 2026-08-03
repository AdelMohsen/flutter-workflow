# Flutter architecture and reuse rules

## New features

Use feature-first folders and this dependency direction:

```text
Widget → Cubit → Repository → Network
```

Adapt exact naming/imports to the project profile. New features keep this
standard even when existing features differ; differences become explicit plan
prerequisites, never a reason to stop. Changes and bug fixes preserve the
existing feature structure unless migration is requested.

Reuse in this order: current project capability, Flutter/Dart native behavior,
already-installed dependency, minimum feature-owned code, then a new compatible
dependency named in the plan.

## Semantic form fields

Keep reusable semantic fields under
`lib/core/utils/widgets/form_fields/`. Use one semantic field per file and no
barrel file. Search first; create a central field on first real use, then reuse
it everywhere. Examples: `default_phone_form_field.dart`,
`default_email_form_field.dart`, `default_password_form_field.dart`.

The field owns input configuration, autofill, formatters, validation,
normalization, required/read-only behavior, UI states, localization, theme, and
accessibility. API calls, Cubit actions, navigation, and business side effects
remain outside. For phone input, ask only unresolved country, calling-code,
local/E.164, required, and validation rules; never invent strict regional rules.

## Design priority

Use explicit flow design, then the project Design Contract, then existing theme
and components, then a generic Foundation default only for a clean project. Do
not create a parallel theme or hardcode styles when tokens exist.
