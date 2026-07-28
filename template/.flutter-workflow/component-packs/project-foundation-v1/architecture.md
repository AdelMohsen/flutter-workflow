# Architecture

Generate a static, generic foundation using the target project's root
`pubspec.yaml`. Do not create a package or copy another project's source.

## App shell

Create the equivalent of:

```text
lib/app/
├── app.dart
├── bootstrap.dart
├── localization/
├── router/
├── state/
├── theme/
└── ui/
```

- Bootstrap Flutter bindings, configuration, storage, dependency injection,
  theme/locale state, router, then `runApp`.
- Use `GoRouter` for the root route without feature-specific routes.
- Use Cubits for persisted `ThemeMode` and locale selection. Never place
  `BuildContext` in Cubits.
- Generate Arabic and English localization using the Flutter version's
  supported `gen-l10n` convention, including RTL/LTR.
- Use Material 3 light/dark `ColorScheme`s derived from the selected primary
  color and apply the selected secondary color through central theme tokens.
- Keep all widgets free of hardcoded brand colors.

Component Showcase displays local demo data for the palette, typography,
buttons, form controls, feedback states, dialogs, and locale/theme switching.
Empty App Shell renders a minimal localized page using the same foundation.
Neither screen performs a network request.

## Core

Create the equivalent of:

```text
lib/core/
├── config/
├── di/
├── errors/
├── network/
├── storage/
├── validation/
└── widgets/
```

- `AppConfig` reads `API_BASE_URL` from compile-time environment configuration.
- `ApiClient` wraps the configured `Dio` instance, uses finite connect/receive
  timeouts, and maps failures to typed application errors. Do not log headers,
  bodies, credentials, or tokens.
- A small `Result` type represents success/failure without UI dependencies.
- `GetIt` owns registrations for configuration, networking, and storage.
- A `SharedPreferences` wrapper persists only theme and locale in V1.
- Validators cover required values, email, phone, and password without knowing
  about widgets.

## Reusable UI

Generate all of these reusable components:

- `AppButton`: primary, secondary, outline, text, and destructive variants with
  loading/disabled behavior.
- `AppTextField`: label, hint, prefix/suffix, validation, and obscured text.
- `AppDropdown` and `AppCheckbox`.
- `AppScaffold`, `AppAppBar`, and `AppCard`.
- loading indicator, empty state, and error state with optional retry.
- dialog and snackbar helpers.

Use project localization, theme, semantics, safe areas, keyboard behavior, and
RTL direction. Public widgets accept data/callbacks and contain no business or
network logic.

## Identity and platforms

Rename `pubspec.yaml` before generating package imports, then update all
existing package imports under the clean `lib/`.

Update only detected platforms:

- Android namespace, application ID, and display label;
- Apple bundle identifiers and display names while preserving required child
  target suffixes;
- web title, manifest name, and short name;
- desktop product, bundle, and executable metadata supported by the detected
  runner.

Do not create absent platforms, change signing credentials, or generate
launcher icons/splash assets.
