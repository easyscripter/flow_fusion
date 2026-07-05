import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/widgets/update/update_banner_layout.dart';
import 'package:flutter/material.dart';

/// Banner shown while the update artifact is downloading, with a progress bar.
class UpdateDownloadingBanner extends StatelessWidget {
  const UpdateDownloadingBanner({
    super.key,
    required this.receivedBytes,
    required this.totalBytes,
  });

  final int receivedBytes;
  final int totalBytes;

  @override
  Widget build(BuildContext context) {
    return UpdateBannerLayout(
      icon: Icons.downloading,
      message: context.l10n.updateDownloading,
      trailing: [
        SizedBox(
          width: 160,
          child: LinearProgressIndicator(
            value: totalBytes > 0 ? receivedBytes / totalBytes : null,
          ),
        ),
      ],
    );
  }
}
