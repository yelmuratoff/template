---
name: "add-translation"
description: >-
  Use this skill when adding or changing a user-visible string — including
  requests like "change this label", "add a message for X", "translate the
  button", "добавь строку", "поменяй текст на экране". The project localizes
  through gen-l10n with three ARB locales (en/ru/kk); a hardcoded string literal
  in a widget is a defect. Covers ARB key placement, ICU plurals/placeholders,
  regeneration, and the untranslated-messages check.
---

# Add a Localized String

Every user-visible string lives in the ARB files and is read via `L10n.current.<key>`. Dev-only labels are the single exception.

## Steps

1. Add the key to the template file `lib/src/core/l10n/translations/intl_en.arb`, then mirror it in `intl_ru.arb` and `intl_kk.arb`. Keys are `camelCase` and describe meaning (`changeTheme`), not presentation.
2. For dynamic content use placeholders with `@key` metadata; for plurals use ICU select/plural syntax in the ARB — branching on count in Dart is a bug.
3. Regenerate: `fvm flutter gen-l10n` (a full `build_runner` build also triggers it). Output lands in `lib/src/core/l10n/generated/app_localizations.g.dart`.
4. Read the string in widgets as `L10n.current.<key>` (see `settings` feature for usage).
5. Confirm `untranslated_messages.txt` is empty — a non-empty file means a locale is missing the key.

## Gotchas

- English (`intl_en.arb`) is the template — a key added only to ru/kk does not generate a getter.
- `nullable-getter: false` is set, so a key missing from the template breaks the build rather than returning null; treat generator errors as a missing-key signal.
- Kazakh (`kk`) is easy to forget; the missing translation only surfaces in `untranslated_messages.txt`, not as a compile error.
- Compose dynamic text via placeholders, never by concatenating localized fragments — word order differs across en/ru/kk.
