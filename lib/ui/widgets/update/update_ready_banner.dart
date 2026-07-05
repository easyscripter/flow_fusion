import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/widgets/update/update_banner_layout.dart';
import 'package:flutter/material.dart';

/// Banner shown once the update is staged: offers "Restart & install".
class UpdateReadyBanner extends StatelessWidget {
  const UpdateReadyBanner({super.key, required this.controller});

  final DesktopUpdaterController controller;

  @override
  Widget build(BuildContext context) {
    return UpdateBannerLayout(
      icon: Icons.check_circle_outline,
      message: context.l10n.updateReady,
      trailing: [
        FilledButton(
          onPressed: () => runUpdateAction('restart', controller.restartApp),
          child: Text(context.l10n.updateActionRestart),
        ),
      ],
    );
  }
}
