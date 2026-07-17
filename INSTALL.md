# Installing Flow Fusion

## What's new in 1.0.1

- Fixed a crash when saving a session caused by duplicate timer positions.
- "What's new" in the update banner now opens correctly.
- Fixed onboarding showing a duplicated, overlapping window.
- Starter example sessions now appear reliably on first launch.
- The update banner no longer overflows on narrow windows.
- The app version is now recorded in the log file for easier diagnostics.

---

Flow Fusion builds are **not code-signed**, so Windows and macOS show a
warning the first time you run the app. This is expected — follow the steps
below to launch it. After the first launch, the app updates itself
automatically (OTA), so you only do this once.

## Windows 10 / 11

1. Download the Windows installer (`Flow Fusion-<version>-windows-setup.exe`) from
   the [Releases page](https://github.com/easyscripter/flow_fusion/releases) (newest is at the top).
2. Double-click it. If Windows shows **"Windows protected your PC" (SmartScreen)**:
   click **More info** → **Run anyway**.
3. Follow the wizard. It installs just for you (no admin password needed) and
   adds a **Start menu** shortcut. Launch Flow Fusion from there.
4. On **every launch** Windows shows a **User Account Control (UAC)** prompt
   asking to allow changes — click **Yes**. Flow Fusion needs administrator
   rights to block websites (it edits the system `hosts` file); see
   *[Focus blocking](#focus-blocking)* below. On a standard (non-admin) account
   you'll be asked for an administrator's credentials.

> Prefer no installer? A portable `Flow Fusion-<version>-windows.zip` is also
> attached to the release — extract it and run `flow_fusion.exe`, keeping all the
> DLLs and the `data` folder next to it. It shows the same UAC prompt on launch.

## macOS 10.14+ (Mojave and newer)

1. Download the macOS disk image (`Flow Fusion-<version>-macos.dmg`) from the
   [Releases page](https://github.com/easyscripter/flow_fusion/releases) (newest is at the top).
2. Double-click the `.dmg` and **drag Flow Fusion into the Applications** folder,
   then eject the disk image.
3. The first launch is blocked by Gatekeeper. Use **one** of these:
   - **Right-click** (or Control-click) the app → **Open** → **Open** in the
     dialog; **or**
   - Open Terminal and run:
     ```bash
     xattr -cr "/Applications/Flow Fusion.app"
     ```
     then open the app normally.

> Because the app is unsigned, macOS re-checks it after each OTA update —
> if it gets blocked again, repeat the right-click → Open step.

## Focus blocking

Each session can automatically remove distractions while a **Work** timer is
running. Open a session in the editor to set these up. They apply **only** during
an active Work phase — not during Chill, while paused, or on a manual hold — and
are released as soon as the phase ends.

- **Blocked apps** (Windows & macOS) — the apps you list are asked to close
  gracefully when a Work phase starts, and are closed again if you reopen them
  mid-phase. Unsaved work isn't lost by force: on Windows the app gets a normal
  close request (an app may ask you to save); nothing is force-killed. Flow
  Fusion never blocks itself.
- **Blocked websites** (Windows only) — the domains you list are redirected to a
  dead end in **every browser** for the duration of the Work phase. This works by
  editing the system `hosts` file, which is why the Windows app requests
  administrator rights (the UAC prompt) at launch. If you close the app during a
  Work phase, the block is cleaned up automatically the next time it starts.

> Website blocking isn't available on macOS yet.

## Updating

You don't need to reinstall. When a new version is published, Flow Fusion detects
it on launch and shows an **update banner** — click **Update**, then
**Restart & install**. You can also trigger a check from **Settings → Updates →
Check for updates**.

## Reporting problems

Found a bug? Please open a **GitHub issue**:
[github.com/easyscripter/flow_fusion/issues/new](https://github.com/easyscripter/flow_fusion/issues/new)

In the issue description, include:

- What you did and what happened (steps to reproduce, expected vs. actual).
- Your **log file** — get it from **Settings → Diagnostics → Open logs folder**,
  then attach `flow_fusion.log` (drag it into the issue).
- Your **diagnostics info** — click **Settings → Diagnostics → Copy info** and
  paste it (it contains the app version and your OS).

The more of the above you attach, the faster the bug can be fixed.
