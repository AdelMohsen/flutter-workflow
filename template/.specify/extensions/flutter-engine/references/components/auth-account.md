# Authentication & Account Management component

Refuse replacement or merge when Auth or Account production paths already
exist. Offer onboarding/change instead and record exact conflicts.

Adapt the blueprint to the current network, errors, storage/session, routing,
localization, theme, semantic form fields, and code-generation conventions.
Support the selected subset of email/phone, password/OTP, login, registration,
verification, forgot/reset/change password, logout, profile/update/change
identifier, terms, delete account, guest mode, post-registration behavior,
custom fields, UI + Logic or Logic Only, Arabic/English and RTL/LTR.

Ask one question at a time with a dynamic count. When conditional answers add
questions, announce the new total. Repeated custom fields have their own step
counter. Summarize all answers before writing the spec and plan. Do not invent
API paths, schemas, OTP rules, password policy, token storage, or destructive
account behavior.

Implement new code as Widget → Cubit → Repository → Network, reusing the Design
Contract and centralized semantic form fields. Apply the OWASP and unit-test
contracts automatically.
