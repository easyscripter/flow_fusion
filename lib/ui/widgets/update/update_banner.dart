import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/ui/widgets/update/update_available_banner.dart';
import 'package:flow_fusion/ui/widgets/update/update_downloading_banner.dart';
import 'package:flow_fusion/ui/widgets/update/update_installing_banner.dart';
import 'package:flow_fusion/ui/widgets/update/update_ready_banner.dart';
import 'package:flutter/material.dart';

/// Reacts to [DesktopUpdaterController] state and shows the matching themed
/// banner. Selects a widget class per state (no widget-returning helpers) and
/// collapses to zero height when idle/checking.
///
/// [UpdateFailed] is intentionally NOT shown here: the startup check is
/// automatic, so a passive banner should stay quiet on offline / no-release
/// failures. Surface failures from an explicit "Check for updates" action.
class UpdateBanner extends StatelessWidget {
  const UpdateBanner({super.key, required this.controller});

  final DesktopUpdaterController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => switch (controller.state) {
        UpdateAvailable(:final descriptor) => UpdateAvailableBanner(
          controller: controller,
          version: descriptor.version,
        ),
        UpdateDownloading(:final receivedBytes, :final totalBytes) =>
          UpdateDownloadingBanner(
            receivedBytes: receivedBytes,
            totalBytes: totalBytes,
          ),
        UpdateReadyToInstall() => UpdateReadyBanner(controller: controller),
        UpdateInstalling() => const UpdateInstallingBanner(),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
