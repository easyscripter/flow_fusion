# Installing Flow Fusion (Beta)

Flow Fusion beta builds are **not code-signed**, so Windows and macOS show a
warning the first time you run the app. This is expected — follow the steps
below to launch it. After the first launch, the app updates itself
automatically (OTA), so you only do this once.

## Windows 10 / 11

1. Download the Windows ZIP (`Flow Fusion-<version>-windows.zip`) from the latest
   [GitHub Release](https://github.com/easyscripter/flow_fusion/releases/latest).
2. Right-click the ZIP → **Extract All…** to a folder you like
   (e.g. `Documents\Flow Fusion`). Do not run it from inside the ZIP.
3. Open the folder and double-click **`Flow Fusion.exe`**.
4. If Windows shows **"Windows protected your PC" (SmartScreen)**:
   click **More info** → **Run anyway**.

> Keep all files together in the extracted folder — the app needs the DLLs and
> the `data` folder next to the `.exe`. Auto-updates replace these in place.

## macOS 10.14+ (Mojave and newer)

1. Download the macOS ZIP (`Flow Fusion-<version>-macos.zip`) from the latest
   [GitHub Release](https://github.com/easyscripter/flow_fusion/releases/latest).
2. Move **Flow Fusion.app** to your `Applications` folder.
3. The first launch is blocked by Gatekeeper. Use **one** of these:
   - **Right-click** (or Control-click) the app → **Open** → **Open** in the
     dialog; **or**
   - Open Terminal and run:
     ```bash
     xattr -cr "/Applications/Flow Fusion.app"
     ```
     then open the app normally.

> Because the beta is unsigned, macOS re-checks the app after each OTA update —
> if it gets blocked again, repeat the right-click → Open step.

## Updating

You don't need to reinstall. When a new beta is published, Flow Fusion detects
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
