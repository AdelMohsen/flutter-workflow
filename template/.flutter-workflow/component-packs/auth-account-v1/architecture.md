# Architecture

Generate only approved flows and fields using:

```text
Widget → Cubit → Repository → Network
```

Use the project's exact names, imports, state style, dependency injection,
navigation, network, error, cache, localization, theme, and shared widgets.

## Feature layout

Create applicable Auth flows under `lib/features/auth/`:

```text
login
register
verify_code
forgot_password
reset_password
logout
```

Create applicable Account Management flows under
`lib/features/account_management/`:

```text
profile
update_profile
change_password
change_email_or_phone
terms_and_conditions
delete_account
```

Password methods include forgot, reset, and change password. OTP-only methods
exclude all password flows. Registration and verification folders are created
only when selected or required.

The Profile menu contains Update Profile, conditional Change Password, Change
Email or Phone according to the authentication identifier, Terms & Conditions,
Delete Account, and Logout. Logout appears in Account Management UI while its
implementation remains under Auth.

Each generated flow follows the project's feature-first equivalent of:

```text
feature/
├── data/
│   ├── config/
│   ├── model/
│   ├── params/
│   └── repository/
├── logic/
└── ui/
    ├── pages/
    └── widgets/
```

Logic Only omits `ui/`. Do not generate empty folders.

## Layer boundaries

- Widgets render state and call Cubit actions only.
- Cubits own presentation logic and never depend on `BuildContext` or widgets.
- Repositories own data access and never depend on UI.
- Params/models contain only selected fields and use project serialization.
- Validators remain isolated and reuse project rules.
- Optional fields follow project omission/null conventions.
- Missing endpoints and response mappings use narrow, approved TODOs; never
  invent a backend contract.

## Behavior

- Use host callbacks for authenticated, guest, logout, delete-account, and
  external destinations. Never hardcode a Home route.
- Reuse the real session/cache API and remote logout only when supported.
- Reuse project validation for email, phone, password policy, confirmation,
  OTP length, required values/dropdowns, numbers, dates, and Terms acceptance.
- Terms acceptance blocks registration when selected and is not included in
  Update Profile.
- Update Profile excludes password, confirmation, auth identifier, and Terms.
- Identifier change uses send OTP, verify OTP, update identifier, then success.
- Change Password uses current, new, and confirmed new password. Delete Account
  requires confirmation but does not invent a password or reason requirement.
- UI + Logic includes keyboard-safe forms, loading/error/success states,
  duplicate-submit prevention, password visibility, project styling, and
  Arabic/English localization with RTL/LTR.
