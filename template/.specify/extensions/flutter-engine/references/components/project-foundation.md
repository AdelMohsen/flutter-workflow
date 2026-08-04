# Project Foundation 2.1

Use the sanitized assets beside the component manifest as adaptable source, not
as a literal project copy. Target a clean Flutter project; if custom Dart code
or conflicting `lib/app`/`lib/core` exists, use onboarding and a Change plan.
Never copy reference-project features, identity, URLs, keys, assets, strings,
bundle IDs, signing files, Firebase files, or Git history.

## Discovery

Ask only material unknowns after inspecting the project. Group independent
questions and accept free text. Capture display name, bundle/application ID,
derived editable package name, supported platforms, design or generic palette,
default/supported locales, build-time flavors/base URLs or `Configure Later`,
starter screen, and optional document/media modules.

Resolve latest package versions compatible with the current Flutter/Dart SDK at
apply time. Do not mass-upgrade, add dependency overrides, or change Flutter.
Track `pubspec.lock`. `Configure Later` must boot and fail clearly before the
first real network request.

## Core contract

- Bootstrap, System UI, portrait orientation, and explicit initialization.
- Immutable `AppConfig` selected from code/build `FlavorEnum`; no dart-define in
  this version and no mutable global base URL.
- Central `go_router` with clean Web path URLs, browser history/refresh, deep
  links, reusable route registration, and no feature imports in core.
- Safe Dio client with typed failures, backend-adapted `ApiErrorModel`, debug
  tracing with redaction, and no TLS bypass, client CORS header, 401/403 cache,
  response-body rescue, or sensitive production logs.
- `flutter_secure_storage` for small encrypted values. Use platform defaults,
  generic key namespaces, Android SDK 23+, Apple Keychain, and HTTPS/HSTS notes
  for WebCrypto. Do not store long-lived Web auth secrets in Foundation.
- Flutter `gen_l10n`, ARB, generated `AppLocalizations`, arbitrary locale count,
  RTL/LTR, localized app title, and persisted locale.
- Material 3 semantic tokens using `google_fonts` and `hexcolor`. Bundle the
  selected font/license and disable runtime fetching for release.
- Central loading/toast initialization with one solution per responsibility.
- Validators, constants, safe debug logger, reusable UI states, and a local-only
  Component Showcase when selected.

## Adaptive and responsive UI

Use `Theme.of(context).platform`: Material behavior on Android/Web and
Cupertino behavior on iOS/iPad for scaffold, app bar, buttons, dialogs, loader,
switch, icons, and page transitions. Keep accessibility, focus, keyboard, and
hover behavior.

Use one `AppContent(maxContentWidth: 720)` constraint. Phones use available
width; iPad/Web center content with configured padding. Add no breakpoint or
responsive dependency until a real screen needs it.

## Forms and media

Keep every semantic field in its own file under `lib/core/ui/form_fields/`.
Each field owns decoration, input/autofill, formatting, validation, theme,
localization, required/read-only states, and accessibility. It never owns API,
navigation, Cubit events, or business side effects.

Base media uses one reusable `MediaPickerService` with `image_picker` and
`file_picker`, cancellation-safe results, type/size validation, and no upload
side effects. `pdf`, `printing`, `open_filex`, and `photo_view` remain optional
modules.

## Web configuration

When `web/` exists, update only sanitized identity/title/description/theme/icon
metadata, enable clean path URLs, preserve browser back/forward and deep-link
refresh, and document server rewrite, HTTPS/HSTS, and backend-owned CORS.
Do not add PWA/offline/service-worker customization without a requirement.

## Asset and localization hygiene

Prefer Material/Cupertino icons. Copy only an asset used by generated code, give
it one typed catalog reference, and verify that the reference and file both
exist. Generate only ARB keys used by Foundation. Never copy empty locales or
feature copy.

For an existing project, report apparently unused assets/keys as candidates;
never delete them automatically because dynamic lookup may exist. Every
delivery plan records Asset and Localization Impact.

`flutter analyze` does not prove asset/key usage. Verify with an explicit
asset/ARB reference audit, `flutter gen-l10n`, formatting, `flutter analyze`,
focused tests, and build smoke for present platforms.

## Baseline dependencies

Use compatible current releases only when the selected Foundation uses them:
`flutter_bloc`, `dio`, `go_router`, `flutter_secure_storage`, `google_fonts`,
`hexcolor`, `image_picker`, `file_picker`, one loading solution, one toast
solution, Flutter localization, `intl`, and `cupertino_icons`.

Do not include Firebase, FCM, maps/location, Pusher, WebView, analytics,
notifications, DI/service locators, project domains, unused icon packs, legacy
translation systems, or reference-project images/strings.

## Completion

After verification, finalize the project-specific Constitution and Project
Profile from generated facts. Production changes require the exact approved
plan. Preserve the component baseline for future three-way updates.
