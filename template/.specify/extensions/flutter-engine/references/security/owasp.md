# OWASP security contract

Apply this contract automatically during onboarding, component, design-sync,
feature, change, and bug flows. It is part of the same Plan gate, not a separate
audit or approval.

## Discovery

Classify affected surfaces: authentication/session/tokens, PII/privacy, local
storage, network/TLS, cryptography, deep links, WebViews, platform permissions,
biometrics, uploads/downloads, camera/location/microphone, logs/analytics,
payments, API contracts, and external dependencies/assets.

Use OWASP MASVS and MASTG for mobile controls and OWASP API Security Top 10 for
client/server contracts. Do not claim certification. A Flutter client cannot
enforce server authorization; record it as a backend contract.

## Plan and implementation

- Add a `Security impact` section with trust boundaries, sensitive data,
  threats, controls, exclusions, and verification.
- Keep secrets, tokens, credentials, and raw sensitive evidence out of source,
  logs, specs, screenshots, and analytics.
- Require platform secure storage for secrets when the project has it or plan
  the smallest compatible addition. Do not put secrets in shared preferences.
- Keep TLS verification enabled; reject certificate bypasses. Do not invent
  certificate pinning unless the threat model and operations support it.
- Validate untrusted input at boundaries, minimize permissions/data retention,
  redact errors/logs, and constrain links/WebViews/file handling.
- Review dependency provenance and compatibility before adding a package.

## Verification

Run focused checks for affected surfaces and record evidence in `result.md`.
A critical regression introduced by the change blocks `VERIFIED`. Record
pre-existing findings separately without silently expanding scope.

Primary references:

- https://mas.owasp.org/MASVS/
- https://mas.owasp.org/MASTG/
- https://owasp.org/API-Security/editions/2023/en/0x03-introduction/
