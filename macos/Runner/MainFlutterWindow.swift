import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let channel = FlutterMethodChannel(
      name: "flow_fusion/app_blocker",
      binaryMessenger: flutterViewController.engine.binaryMessenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "listInstalledApps":
        result(AppBlocker.listInstalledApps())
      case "blockApps":
        let tokens = (call.arguments as? [String: Any])?["tokens"] as? [String] ?? []
        result(AppBlocker.blockApps(bundleIds: tokens))
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    super.awakeFromNib()
  }
}

/// Soft, store-compatible app blocking for macOS: a graceful "quit" request plus
/// hide — never a forced SIGKILL. `terminate()` requires the Automation (TCC)
/// permission, prompted by the system on first use; if denied, `hide()` still
/// gets the app out of the way.
enum AppBlocker {
  /// Asks every running app whose bundle id is in [bundleIds] to quit and hides
  /// it. Returns the names acted upon.
  static func blockApps(bundleIds: [String]) -> [String] {
    guard !bundleIds.isEmpty else { return [] }
    let wanted = Set(bundleIds)
    let selfBundleId = Bundle.main.bundleIdentifier
    let selfPid = ProcessInfo.processInfo.processIdentifier
    var acted: [String] = []
    for app in NSWorkspace.shared.runningApplications {
      guard let bundleId = app.bundleIdentifier, wanted.contains(bundleId) else {
        continue
      }
      // Never close ourselves, even if our bundle id is somehow in the list.
      if bundleId == selfBundleId || app.processIdentifier == selfPid { continue }
      app.hide()
      _ = app.terminate()
      acted.append(app.localizedName ?? bundleId)
    }
    return acted
  }

  /// Installed applications, for the picker shown in the session editor.
  static func listInstalledApps() -> [[String: Any]] {
    let fileManager = FileManager.default
    var directories = ["/Applications", "/System/Applications"]
    if let userApps = fileManager.urls(for: .applicationDirectory, in: .userDomainMask).first {
      directories.append(userApps.path)
    }

    let selfBundleId = Bundle.main.bundleIdentifier
    var seen = Set<String>()
    var apps: [[String: Any]] = []
    for directory in directories {
      guard let entries = try? fileManager.contentsOfDirectory(atPath: directory) else {
        continue
      }
      for entry in entries where entry.hasSuffix(".app") {
        let path = (directory as NSString).appendingPathComponent(entry)
        guard let bundle = Bundle(path: path),
          let bundleId = bundle.bundleIdentifier,
          bundleId != selfBundleId,
          !seen.contains(bundleId)
        else { continue }
        seen.insert(bundleId)

        let info = bundle.infoDictionary
        let name =
          (info?["CFBundleDisplayName"] as? String)
          ?? (info?["CFBundleName"] as? String)
          ?? (entry as NSString).deletingPathExtension

        var app: [String: Any] = ["name": name, "bundleId": bundleId]
        if let icon = pngBase64(for: NSWorkspace.shared.icon(forFile: path), size: 48) {
          app["iconBase64"] = icon
        }
        apps.append(app)
      }
    }
    apps.sort { ($0["name"] as? String ?? "").localizedCaseInsensitiveCompare($1["name"] as? String ?? "") == .orderedAscending }
    return apps
  }

  private static func pngBase64(for image: NSImage, size: CGFloat) -> String? {
    let target = NSSize(width: size, height: size)
    let resized = NSImage(size: target)
    resized.lockFocus()
    image.draw(in: NSRect(origin: .zero, size: target))
    resized.unlockFocus()
    guard let tiff = resized.tiffRepresentation,
      let rep = NSBitmapImageRep(data: tiff),
      let png = rep.representation(using: .png, properties: [:])
    else { return nil }
    return png.base64EncodedString()
  }
}
