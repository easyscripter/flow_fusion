#!/usr/bin/env bash
#
# Packages the release .app bundle into a .dmg for manual first-time install.
# This is separate from the OTA feed (which ships a .zip via desktop_updater):
# the .dmg is only the friendly "drag to Applications" installer attached to the
# GitHub Release. The build is UNSIGNED, so Gatekeeper still requires the
# right-click -> Open bypass documented in INSTALL.md.
#
# Run from the repo root, after `flutter build macos --release` (which
# `desktop_updater:release publish --platform macos` performs internally).

set -euo pipefail

APP_NAME="Flow Fusion"
APP_PATH="build/macos/Build/Products/Release/${APP_NAME}.app"

# Read the marketing version from pubspec (strip the "+build" suffix).
VERSION="$(grep -m1 '^version:' pubspec.yaml \
  | sed -E 's/^version:[[:space:]]*//' \
  | sed -E 's/\+.*$//')"

if [[ ! -d "$APP_PATH" ]]; then
  echo "error: app bundle not found at $APP_PATH" >&2
  echo "       run 'flutter build macos --release' first." >&2
  exit 1
fi

OUT_DIR="dist/installers"
mkdir -p "$OUT_DIR"
DMG_PATH="${OUT_DIR}/${APP_NAME}-${VERSION}-macos.dmg"

# Stage the .app next to an /Applications symlink so the mounted volume shows
# the familiar "drag the app into Applications" layout.
STAGING="$(mktemp -d)"
cp -R "$APP_PATH" "$STAGING/"
ln -s /Applications "$STAGING/Applications"

rm -f "$DMG_PATH"
hdiutil create \
  -volname "$APP_NAME" \
  -srcfolder "$STAGING" \
  -fs HFS+ \
  -format UDZO \
  -ov \
  "$DMG_PATH"

rm -rf "$STAGING"
echo "created $DMG_PATH"
