# Epic 05 — Usage analytics (self-hosted, opt-in, anonymous)

**Priority:** P1 · **Status:** To do

## Context

The product owner wants to know how many people actually use the app. Two
hard constraints, decided after ruling out the obvious mobile-first vendors:

- **Flow Fusion is desktop-only** (macOS + Windows — see `window_manager`,
  `tray_manager`, native app blocking throughout this codebase; there is no
  mobile target). Firebase Analytics has no desktop Flutter support at all.
  Yandex AppMetrica's official Flutter plugin is mobile-only (iOS/Android).
  Neither is viable here.
- **Must stay reachable from Russia** without depending on a foreign SaaS
  domain that could be geo-blocked.

**Decision:** self-host an analytics backend the product owner controls
(PostHog or Umami are reasonable open-source choices, already
decided by the user to self-host — this is not this task's decision to
make), and send events via a **plain `http.post`** to that self-hosted
`/capture`-style endpoint. **Do not add any analytics SDK as a dependency**
(no `posthog_flutter`, no `firebase_analytics`, nothing) — a raw HTTP POST
works identically on every platform the `http` package supports, which is the
whole reason this approach was chosen over an SDK.

The app's own positioning is "protect the user from their own distractions"
— a privacy-sensitive audience. Analytics must be **opt-in, unchecked by
default**, not silently enabled, or it directly contradicts what the app
sells itself as.

## Task

1. **Onboarding consent screen/step:** add a toggle (default OFF/unchecked)
   somewhere in the existing onboarding flow — check
   [`lib/controllers/onboarding_controller.dart`](../../lib/controllers/onboarding_controller.dart)
   for where to hook in — with plain-language copy explaining what is and
   isn't collected (anonymous usage counts; no personal data). Persist the
   choice (add a new pref via
   [`lib/model/datasources/local/prefs.dart`](../../lib/model/datasources/local/prefs.dart),
   following the existing getter/setter pattern used for `language`,
   `themeMode`, etc.). Also expose a way to change this choice later from
   Settings — check
   [`lib/ui/views/settings_view/`](../../lib/ui/views/settings_view/) for
   where toggles like notifications live and match that pattern.
2. **Event sender:** a small service (new file, e.g.
   `lib/controllers/analytics_service.dart`, following the
   `@lazySingleton` + constructor-injection convention used throughout this
   codebase — see `app_blocker_service.dart` for the pattern) that, only
   when the opt-in pref is true, POSTs a minimal anonymous JSON event via the
   `http` package to a configurable endpoint URL (add it to
   [`lib/ui/constants/app_config.dart`](../../lib/ui/constants/app_config.dart)
   alongside the existing `releaseNotesBaseUrl` constant, so the actual
   self-hosted URL is a config value the product owner sets, not hardcoded
   deep in the service).
3. Fire a minimal "app launched" event on startup, gated by the opt-in pref.
   Don't over-build the event taxonomy here — the ask is knowing how many
   people use the app, not a full analytics pipeline; a single launch/session
   event is enough for this release. If a natural place already exists to add
   more events cheaply later (e.g. session-completed), leave a clear
   extension point but don't build out a large event catalog now.
4. Events must be anonymous: no name, email, or other PII; if any kind of
   install identifier is needed to de-duplicate, it should be a random UUID
   generated once and stored locally — never a hardware/hardware-derived ID.

## Acceptance criteria

- [ ] Onboarding shows an analytics opt-in toggle, unchecked by default, with
      copy that plainly states what is/isn't collected.
- [ ] No network request to the analytics endpoint happens before the user
      opts in.
- [ ] Declining (or leaving it unchecked) means zero events are ever sent
      until the user later changes the setting.
- [ ] The setting is changeable later from Settings, not just at onboarding.
- [ ] Events sent contain no PII and no stable hardware-derived identifier —
      at most a locally-generated random UUID for de-duplication.
- [ ] A failed or slow network request to the analytics endpoint never
      blocks, delays, or crashes any app UI — it's fire-and-forget with
      errors caught and logged via `AppLogger`, same as other network calls
      in this codebase (see `release_notes_loader.dart` for the pattern).
- [ ] No analytics SDK package is added to `pubspec.yaml` — only the
      already-present `http` package is used for this.

## Out of scope

- Choosing/standing up the actual self-hosted PostHog/Umami instance — that's
  infrastructure the product owner handles themselves, not app code.
- A full event taxonomy (session started/completed, feature usage, etc.) —
  ship the minimal launch event; expand later if requested.
- Any analytics dashboard or in-app reporting of these events back to the
  user.
