import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/widgets/update/update_banner_layout.dart';
import 'package:flutter/material.dart';

/// Banner shown while the native install/restart helper is running.
class UpdateInstallingBanner extends StatelessWidget {
  const UpdateInstallingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return UpdateBannerLayout(
      icon: Icons.downloading,
      message: context.l10n.updateInstalling,
      trailing: const [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ],
    );
  }
}
