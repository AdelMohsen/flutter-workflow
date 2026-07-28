# Configuration Questions

Ask one question at a time in the developer's language. Keep identifiers,
package names, color values, and paths in English.

## Progress contract

There are exactly seven questions. Show this header before every question:

```text
Project Foundation & UI Kit
Question X of 7 · Z questions remaining
```

`Z` excludes the current question. Editing an earlier answer does not discard
unrelated answers.

## Questions

1. **App Display Name** — require a non-empty user-facing name.
2. **Bundle/Application ID** — require a lowercase reverse-domain identifier
   with at least two dot-separated segments. Each segment must start with a
   letter and contain letters or digits only, for example
   `com.innovadigits.demoapp`.
3. **Dart package name** — suggest a lowercase `snake_case` value derived from
   the display name. Allow editing, then validate it as a legal non-reserved
   Dart package identifier.
4. **Brand palette** — choose exactly one:
   - Corporate Blue — primary `#1D4ED8`, secondary `#06B6D4`
   - Emerald Teal — primary `#047857`, secondary `#0D9488`
   - Indigo Violet — primary `#4F46E5`, secondary `#9333EA`
   - Charcoal Orange — primary `#111827`, secondary `#F97316`
5. **Default locale** — Arabic or English. Always generate both languages and
   RTL/LTR support.
6. **API Base URL** — provide an absolute HTTP(S) URL or choose
   `Configure Later`. Always read it through `API_BASE_URL`; never hardcode a
   secret or production credential.
7. **Starter screen** — Component Showcase or Empty App Shell.

`Configure Later` keeps `API_BASE_URL` empty, lets the application start, and
adds a narrow TODO that fails only when a network request is attempted.

## Final configuration review

Before Playback, show:

- display name, bundle/application ID, and Dart package name;
- detected platforms and exact identity updates;
- selected palette and default locale;
- API configuration choice without exposing secrets;
- starter screen;
- fixed dependencies and code-generation commands;
- every file group to create/update and all out-of-scope items.

Allow editing one answer or cancelling without production changes.
