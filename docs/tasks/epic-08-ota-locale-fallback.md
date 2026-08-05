# Epic 08 — OTA release-notes locale fallback

**Priority:** P0 · **Status:** Done (2026-08-03) — kept here for the record,
no further action needed.

## What was wrong

[`lib/model/datasources/update/release_notes_loader.dart`](../../lib/model/datasources/update/release_notes_loader.dart)'s
`LocalizedReleaseNotesLoader._resolveLanguage()` fell back straight to
`'en'` whenever the user had never explicitly set a language in Settings
(`prefs.language == null`), instead of resolving the system locale first —
so RU users who never touched the language setting saw OTA update release
notes in English. The correct pattern already existed elsewhere in the
codebase, in
[`lib/ui/app/tray_service.dart`](../../lib/ui/app/tray_service.dart)'s
`_loadL10n()`, which does resolve
`WidgetsBinding.instance.platformDispatcher.locale` correctly — this loader
just didn't follow it. The GitHub Pages OTA feed itself (`release.yml`) was
already publishing both `release-notes.en.json` and `release-notes.ru.json`
correctly, so it wasn't a publishing/deployment gap.

## Fix applied

`_resolveLanguage()` now falls back to
`WidgetsBinding.instance.platformDispatcher.locale.languageCode` before
defaulting to `'en'`, matching `tray_service.dart`'s pattern. Confirmed with
the user that the rest of the app's UI locale already resolves correctly
through a different path not traced during this investigation — so this fix
was intentionally scoped to just the release-notes loader, not
`AppViewModel.init()`'s language fallback. If `AppViewModel.init()`'s
fallback is ever revisited, re-verify that claim first rather than assuming
it's also broken.

## Acceptance criteria (met)

- [x] New installs / users who never touched language settings see OTA
      release notes in their system language (RU or EN) instead of always
      English.
- [x] Unsupported system locales still fall back to English.
