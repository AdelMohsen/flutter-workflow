# Configuration Questions

Ask one material question at a time in the developer's language. Keep technical
identifiers in English.

## Progress contract

Start with nine possible core questions. After each answer, remove inapplicable
conditional questions and recalculate the queue. Show this header before every
core question:

```text
Authentication & Account Management
Question X of Y · Z questions remaining
```

`Z` excludes the current question. When an answer adds or removes conditional
questions, announce the delta once before the next question:

```text
Configuration updated · 2 conditional questions removed
```

Custom-field steps use their own counter and do not change the core counter:

```text
Custom Field 1 · Step 2 of 5
Core configuration · 4 questions remaining
```

Dropdown options are an open repeatable list. Show the option number and the
remaining core count instead of claiming a fixed option total.

## Core questions

1. **Authentication method** — choose exactly one:
   - Email + Password
   - Email + OTP
   - Phone + Password
   - Phone + OTP
2. **Registration** — enabled or disabled.
3. **Registration verification** — ask only when registration is enabled and
   the authentication method uses Password. OTP methods already verify.
4. **Registration/profile fields** — select from Full Name, First Name, Last
   Name, Username, Date of Birth, Gender, Country, City, Address, Terms &
   Conditions acceptance, and Custom Field. When registration is disabled,
   configure Update Profile fields and omit Terms acceptance.
5. **Required standard fields** — show only selected standard fields.
   Authentication identifiers, password/confirmation, and selected Terms
   acceptance are automatically required.
6. **Terms & Conditions URL** — always ask because Account Management always
   includes Terms & Conditions.
7. **Post-registration behavior** — ask only when registration is enabled:
   authenticate and invoke the host callback, or return to Login. Apply it after
   OTP verification when verification is required.
8. **Guest Mode** — disabled or enabled. When enabled, expose
   `onGuestModeRequested`; never create a fake session.
9. **Generation mode** — UI + Logic or Logic Only.

For Gender, use API values `male`, `female`, and `prefer_not_to_say` with Arabic
and English labels.

## Custom fields

For each field collect:

1. field key;
2. English label;
3. Arabic label;
4. type: Text, Number, Date, or Dropdown;
5. required or optional.

For Dropdown, collect English label, Arabic label, and API value for each
option. Then offer Add, Edit, Delete, or Continue while preserving unrelated
answers.

## Final configuration review

Before Playback, show authentication method, registration/verification,
selected and required fields, custom fields, generated flows, Guest Mode,
Account Management entries, generation mode, Terms URL, Arabic/English, and
known project TODOs. Allow editing one section without discarding other
answers, or cancellation without production changes.
