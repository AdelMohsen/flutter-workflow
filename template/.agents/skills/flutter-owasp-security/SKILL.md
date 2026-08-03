---
name: flutter-owasp-security
description: Apply risk-based OWASP MASVS, MASTG, and API Security guidance throughout normal Flutter implementation rather than as a separate audit. Use automatically for Flutter Engine onboarding, components, design sync, new features, changes, and bug fixes, especially when work touches authentication, tokens, PII, storage, networking, deep links, WebViews, permissions, biometrics, files, sensors, logs, payments, APIs, or dependencies.
---

# Flutter OWASP Security

Read `.specify/extensions/flutter-engine/references/security/owasp.md`.

During discovery, classify affected security surfaces and trust boundaries.
During planning, add concrete controls and focused verification to the same
Flutter Engine plan; do not create another approval gate. During implementation,
apply only approved controls. During verification, record evidence and block
`VERIFIED` for a critical regression introduced by the change.

Keep pre-existing findings separate and do not expand scope silently. Never
store credentials or sensitive evidence, disable TLS validation, claim OWASP
certification, or represent client checks as server authorization.
