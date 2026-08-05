# Epic 07 — Configurable social links in the sidebar

**Priority:** P2 · **Status:** To do

## Context

The sidebar shows the app version somewhere near the bottom (find the
relevant widget under `lib/ui/` — likely near wherever `package_info_plus`'s
version string is already displayed). The ask is a small row of social/link
icons below it. Today there's only a GitHub link planned, but a Discord link
is a known near-term addition — so this must be built as a small
**configurable list** (icon + URL pairs), not a single hardcoded GitHub
widget, so adding Discord later is a one-line data change, not new layout
code.

## Task

1. Add a small config list (e.g. a `const List<SocialLink>` or similar, with
   an icon reference and a URL) seeded with one entry: GitHub, pointing at
   this project's repo URL.
2. Render it as a row of icon buttons under the version number in the
   sidebar. Tapping one opens the URL in the system's default browser (check
   if `url_launcher` or an equivalent is already a dependency in
   `pubspec.yaml`; if not, that's the standard package for this in Flutter).
3. Keep the widget itself icon-agnostic — it should render whatever's in the
   config list without caring how many entries there are, so adding Discord
   later really is just appending one entry.

## Acceptance criteria

- [ ] Sidebar shows a GitHub icon link under the version number.
- [ ] Clicking it opens the repository URL in the user's default system
      browser.
- [ ] The list of social links is driven by a simple config
      structure — adding a second entry (e.g. Discord) requires only adding
      a data entry, not touching layout/widget code.
- [ ] Works on both macOS and Windows.

## Out of scope

- Actually adding the Discord link/icon now — just make sure adding it later
  is trivial. Don't add a placeholder Discord entry unless a real URL is
  provided.
- Any analytics/tracking on link clicks.
