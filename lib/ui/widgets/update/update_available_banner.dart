import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/widgets/update/update_banner_layout.dart';
import 'package:flow_fusion/ui/widgets/update/update_release_notes_dialog.dart';
import 'package:flutter/material.dart';

class UpdateAvailableBanner extends StatelessWidget {
  const UpdateAvailableBanner({
    super.key,
    required this.controller,
    required this.version,
  });

  final DesktopUpdaterController controller;
  final String version;

  @override
  Widget build(BuildContext context) {
    return UpdateBannerLayout(
      icon: Icons.system_update_alt,
      message: context.l10n.updateAvailable(version),
      trailing: [
        TextButton(
          onPressed: () => _showWhatsNew(context),
          child: Text(context.l10n.updateWhatsNew),
        ),
        TextButton(
          onPressed: () => runUpdateAction('skip', controller.makeSkipUpdate),
          child: Text(context.l10n.updateActionLater),
        ),
        FilledButton(
          onPressed: () =>
              runUpdateAction('download', controller.downloadUpdate),
          child: Text(context.l10n.updateActionUpdate),
        ),
      ],
    );
  }

  void _showWhatsNew(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) =>
          UpdateReleaseNotesDialog(controller: controller, version: version),
    );
  }
}
