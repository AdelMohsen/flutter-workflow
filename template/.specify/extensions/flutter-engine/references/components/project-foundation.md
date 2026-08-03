# Project Foundation component

This is a blueprint derived from the cleaned reference template, not a literal
copy. It targets a clean Flutter project and adapts to supplied design and app
identity. Discovery must block production changes when custom Dart code or
conflicting `lib/app`/`lib/core` already exists; use onboarding instead.

Ask one question at a time for display name, reverse-domain bundle/application
ID, derived editable Dart package name, design source or generic palette,
default locale (always support Arabic/English and RTL/LTR), API base URL or
`Configure Later`, and starter screen/showcase.

Create only approved `lib/app` and `lib/core` capabilities used by the selected
starter: bootstrap, routing without DI/service locator, configuration, network,
errors/results, local storage, localization, theme/design tokens, constants,
validators, semantic form fields, reusable UI states/components, and the
starter screen. Remove legacy branding, URLs, package imports, SSL bypasses,
sample domain features, and GetIt from the source concept.

Resolve latest packages compatible with the project's current Flutter/Dart SDK
at apply time. For an existing project, add only required dependencies; never
mass-upgrade, add `dependency_overrides`, or upgrade Flutter automatically.
Track `pubspec.lock`. `Configure Later` must boot safely and fail with an
explicit configuration error before the first network request.

Generic palettes when no design is available:

- Corporate Blue: `#1D4ED8`, `#06B6D4`
- Emerald Teal: `#047857`, `#0D9488`
- Indigo Violet: `#4F46E5`, `#9333EA`
- Charcoal Orange: `#111827`, `#F97316`

Generate no Firebase, flavors, notifications, analytics, crash reporting,
icons, splash automation, secrets, or sample login/home domains.

## Reference-template adaptation map

Treat these as capability groups, not files to copy blindly:

| Reference group | V2 decision |
| --- | --- |
| `app/my_app.dart` | Keep the bootstrap responsibility; rebuild with current package name, identity, localization, responsive policy, theme, and starter route. |
| `app/providers_list.dart` | Keep only real root Bloc providers. Do not introduce GetIt or a service locator. |
| `core/route` | Keep centralized route names/generation when the project selects it; remove domain-specific splash imports and reuse the project's routing package if present. |
| `core/assets` | Generate typed path constants only for assets that actually exist. Do not create speculative empty catalogs. |
| `core/services/network` | Keep one configured Dio client only when networking is enabled. Remove global mutable headers, client-side CORS headers, verbose sensitive logging, hardcoded URL/language/token, and SSL bypasses. |
| `core/services/api_handler` and `core/shared/entity/models` | Consolidate into the minimum typed failure/result and response mapping used by real consumers; fix legacy names/typos instead of preserving them. |
| `core/services/cache` | Keep a small shared-preferences wrapper for non-secret settings. Use secure storage only when an approved feature needs secrets. |
| `core/services/servies_locator` | Drop completely; V2 Foundation uses explicit construction/providers and no DI container. |
| `core/theme` | Rebuild as Material 3 semantic tokens and light/dark themes from the Design Contract or selected palette. No project-specific colors or hardcoded widget styling. |
| `core/utils/constant` | Keep only selected identity/config/localization/storage keys. Replace `ABWAB`, `Yelzamni`, old URLs, and duplicated string/color constants. |
| `core/utils/extensions` and enums | Copy only extensions/enums used by generated code after verifying names and behavior. |
| `core/shared` and `core/utils/widgets` | Adapt reusable buttons, dialogs, empty/error/loading, spacing, navigation, responsive, text, image, and animation helpers only when selected by the starter/component. Bind them to theme/localization/accessibility. |
| `core/utils/widgets/form_fields` | Keep a small low-level `default_form_field.dart`; add semantic fields centrally on first real use. |
| shimmer/animation/network-image packages | Reuse only when already installed or the selected showcase needs them and the approved plan proves the dependency. |

Do not preserve `modules/`, sample splash/login/home behavior, `.DS_Store`, stale
TODOs, duplicate constants, misspelled public APIs, or imports from
`abwab_templet`. Run `flutter pub get`, applicable generation, formatting,
focused tests, and `flutter analyze` before marking the component verified.
