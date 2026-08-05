# Epic 01 — macOS app blocking reliability

**Priority:** P0 (blocks release — this is the app's core feature, and it
currently doesn't work) · **Status:** Done (2026-08-05)

## Context

Flow Fusion is a Flutter desktop (macOS + Windows) focus-timer app. During a
work session it's supposed to quit/hide apps the user picked as
distracting. On macOS this is implemented in
`AppBlocker.blockApps(bundleIds:)` in
[`macos/Runner/MainFlutterWindow.swift`](../../macos/Runner/MainFlutterWindow.swift),
called every 2 seconds from
[`lib/controllers/app_blocker_service.dart`](../../lib/controllers/app_blocker_service.dart)
while a session with blocked apps is active.

Two bugs were reported ("doesn't block a fullscreen app in its own Space",
"doesn't block anything while Flow Fusion itself is minimized to tray") and
were diagnosed with temporary logging on 2026-08-03. **They turned out to be
one root cause, not two:**

`AppBlocker.blockApps` currently calls `NSRunningApplication.hide()` and
`.terminate()` directly (plain Cocoa API, not AppleScript). A live diagnostic
run — logging every tick's timestamp plus each attempt's `hide()`/`terminate()`
return value and the target's `isTerminated` state before/after — showed,
across ~4 minutes of continuously trying to block a running Telegram:

- The polling timer itself fires reliably every 2s the whole time, including
  while `NSApp.activationPolicy() == .accessory` (i.e. Flow Fusion in tray).
  **The timer/polling is not the problem.**
- `hide()` and `terminate()` **returned `false` on every single attempt**, and
  the target's `isTerminated` **never once became `true`** in the entire run.
  The target app was never actually closed — not once, in any window state.
- A follow-up check of the macOS unified TCC log for that time window showed
  **no Automation/Apple-Events permission request from Flow Fusion targeting
  Telegram at all** — the OS isn't even being asked.

**Conclusion:** `NSRunningApplication.hide()/.terminate()` targeting an
unrelated third-party process is a silent no-op under App Sandbox
(`com.apple.security.app-sandbox = true` in
[`macos/Runner/DebugProfile.entitlements`](../../macos/Runner/DebugProfile.entitlements)
/ `Release.entitlements`) — sandboxed apps don't have this capability via the
raw Cocoa API at all, and it doesn't go through any consent prompt the user
could grant. What looked like "blocking working" before this diagnosis was
actually `NSRunningApplication.current.activate()` (already in the code)
stealing focus and visually covering the target's window with our own — a
side effect, not a real hide/quit. Fullscreen (target has its own Space) and
tray mode (Flow Fusion has no window to raise) each independently defeat that
focus-stealing illusion, which is why both were reported as failures.

**Prior art already in this codebase for the identical problem:**
site-blocking (blocking distracting *websites* during a session, in
[`lib/controllers/site_blocker_service.dart`](../../lib/controllers/site_blocker_service.dart))
hit the same sandbox wall for a different target (browser tabs) and solved it
by using **AppleScript / Apple Events** (`tell application ... to ...`)
instead of a direct API — which *does* work under sandbox, via the
`com.apple.security.automation.apple-events` entitlement (already present in
both entitlements files) plus a per-target-app Automation permission prompt
macOS shows the user on first use.

## Resolution (2026-08-05)

The Apple Events approach this doc originally specced turned out **not to
work either**: live testing showed `appleeventsd` hard-denies the event at
process-lookup time (`-600`, before any Automation permission prompt) —
sandboxed Apple Events to another app require a stable code-signing Team
Identifier, which this project's ad-hoc-signed builds (no paid Developer ID)
don't have. That's the same underlying blocker as the original bug, just one
layer deeper.

**Actual fix:** dropped `com.apple.security.app-sandbox` from both
entitlements files entirely. Flow Fusion isn't distributed through the Mac
App Store, so sandboxing was buying nothing and was the real root cause of
both this epic's bug *and* the Apple Events dead end — not a hurdle to route
around with a fancier API. Outside the sandbox, the plain Cocoa API works
immediately, no Apple Events needed.

Also switched from `hide()` back to `NSRunningApplication.terminate()` (a
full quit, not minimize-to-resume-later) after `hide()` turned out to leave
a fullscreen-in-its-own-Space app fully visible on screen despite reporting
`isHidden == true` — macOS doesn't reliably navigate away from that Space on
a background `hide()` call. A same-day attempt to fix that via the
Accessibility API (`AXFullScreen`) technically succeeded per the API but
didn't visually work either (reproduced on both Telegram and Safari) and was
abandoned. `terminate()` sidesteps the whole problem: quitting destroys the
window outright, so there's no leftover Space for macOS to get stuck in.

**Deviations from the acceptance criteria below:** no Automation permission
prompt exists anymore (nothing to prompt for — no Apple Events, no
sandbox), so that criterion is moot rather than met. Blocked apps are now
fully quit rather than hidden, so there's no "resume where you left off on
break" — a real UX trade-off accepted in favor of reliability.

Full diagnosis trail (appleeventsd logs, ad-hoc signing findings, all the
things that didn't work and why) is kept in project memory outside this
repo, not duplicated here.

## Task

Rewrite `AppBlocker.blockApps` in
[`macos/Runner/MainFlutterWindow.swift`](../../macos/Runner/MainFlutterWindow.swift)
to quit each target app via an Apple Event instead of the Cocoa API — e.g.
`NSAppleScript` running `tell application id "<bundleId>" to quit`, or an
equivalent Apple Events call (`NSAppleEventDescriptor` sending
`kAEQuitApplication` to the target's process, similar in spirit to
`site_blocker_service.dart`'s approach) — pick whichever pattern that file
already establishes, don't invent a third convention.

Things to get right:

1. **Automation permission UX.** The first time Flow Fusion tries to quit a
   given target app, macOS will prompt the user to allow Automation access to
   that specific app. If the user denies it, `AppBlocker.blockApps` should be
   able to report that back to Dart (e.g. include per-app success/failure in
   the returned payload, not just a flat name list) so the UI can show that
   app as "not blocked" rather than silently pretending it worked. Check how
   `site_blocker_service.dart` / its Swift counterpart already surfaces (or
   doesn't surface) permission failures, and be consistent.
2. **Non-cooperative quit.** `tell application to quit` is a polite request,
   same as `.terminate()` was — an app with an unsaved-changes dialog can
   still refuse. Don't let one stuck app break the blocking loop for the
   others; the existing 2-second retry loop already re-attempts naturally,
   just make sure a single failed/slow Apple Event doesn't block or crash the
   method call for the rest of the bundle IDs in that tick.
3. **Fullscreen should now "just work".** An Apple Event `quit` isn't tied to
   window-server focus the way `hide()` was, so the existing
   `NSRunningApplication.current.activate()` focus-stealing workaround for
   fullscreen apps (currently in `blockApps`, with the comment about "own
   Space") should no longer be necessary — remove it if the new mechanism
   makes it redundant, but verify with a real fullscreen app before deleting
   it.
4. **Self-protection stays.** Keep the existing guard that never targets
   Flow Fusion's own bundle id / pid, even if it somehow ends up in the
   blocklist.
5. Windows blocking (a separate, unrelated code path — check
   `app_blocker_service.dart`'s `Platform.isWindows` branch and whatever
   native Windows implementation backs it) is **out of scope** for this task.
   This epic is macOS-only.

## Acceptance criteria

- [x] Blocking a running app during an active work session actually quits
      it — verified via the app disappearing from the running-apps list
      (not just losing focus) — in **every** window state: normal window,
      fullscreen in its own Space, and while Flow Fusion itself is minimized
      to the tray (`activationPolicy == .accessory`). Confirmed live by the
      user with Telegram and Safari, both window states, both app states.
- [ ] ~~macOS shows the per-target-app Automation permission prompt...~~ —
      moot: the final fix uses no Apple Events and no sandbox, so there's no
      Automation permission to prompt for or deny. See Resolution above.
- [x] An app that responds to the quit request with an unsaved-changes
      dialog (or otherwise ignores it) does not crash or hang the blocking
      loop — other blocked apps in the same tick are still processed, and the
      stuck app is retried on the next 2-second tick. Also fixed a false
      "failed to quit" report for apps (e.g. Telegram) that quit correctly
      but slower than the original 0.2s grace window — bumped to 1.5s.
- [x] Apps *not* in the current session's blocklist are never touched.
- [x] `AppBlockerService.stopBlocking()` (Dart side, unchanged) still cleanly
      halts the native polling — no regression there.
- [x] Windows blocking behavior is unchanged by this work.

## Out of scope

- Any UI for showing per-app block failures beyond what's minimally needed to
  make the "denied permission" case visible — a full settings/diagnostics
  screen is not part of this task.
- Windows-side app blocking.
- Site/browser-tab blocking (`site_blocker_service.dart`) — already works,
  don't touch it except to read it as a reference pattern.
