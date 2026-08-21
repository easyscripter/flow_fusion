# Release 1.1.0 — task index

Each file in this folder is self-contained: an AI coding agent should be able
to open just that one file (plus the repo) and implement it correctly,
without needing the rest of this conversation or the ADR. Full background and
rationale for all decisions lives in
[docs/adr/2026-07-30-release-1.1-scope.md](../adr/2026-07-30-release-1.1-scope.md)
if an agent wants more context than the "Why" section here gives.

| # | Epic | Priority | Status |
|---|------|----------|--------|
| 01 | [macOS app blocking reliability](epic-01-macos-app-blocking.md) | P0 | **Done** |
| 02 | [Instant end-session button](epic-02-instant-end-session.md) | P1 | **Done** |
| 03 | [Live menubar timer](epic-03-menubar-timer.md) | P1 | **Done** |
| 04 | [Task time-tracking](epic-04-task-time-tracking.md) | P1 | To do |
| 05 | [Usage analytics (self-hosted, opt-in)](epic-05-usage-analytics.md) | P1 | To do |
| 06 | [Timer visual polish](epic-06-timer-visual-polish.md) | P2 | **Done** |
| 07 | [Sidebar social links](epic-07-sidebar-social-links.md) | P2 | **Done** |
| 08 | [OTA release-notes locale fallback](epic-08-ota-locale-fallback.md) | P0 | **Done** |

**Priority key:** P0 blocks the release, P1 is expected in it, P2 is
nice-to-have if time allows.

**Suggested implementation order:** 01 is the highest-value fix (the app's
core feature doesn't actually work) and is independent of everything else —
good first pick for an agent. 02–05 are independent of each other and of 01,
so they can run in parallel across multiple agents. 06 touches two widgets
that share one new progress-value source — do both halves in the same pass,
not as two separate agent runs, or the second will redo the first's plumbing.
07 is fully independent and trivial. 08 is already shipped, kept here only
for the record.
