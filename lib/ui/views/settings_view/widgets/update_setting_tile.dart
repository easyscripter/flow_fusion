import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Settings tile with a manual "Check for updates" button.
///
/// Uses the app's themed [AppButton] stretched to full width so the label fits
/// on one line. Unlike the passive top banner, this surfaces the outcome
/// explicitly via a snackbar (including failures); when an update is found the
/// shared controller also moves to [UpdateAvailable] so the top banner offers
/// the actual install.
class UpdateSettingTile extends StatefulWidget {
  const UpdateSettingTile({super.key});

  @override
  State<UpdateSettingTile> createState() => _UpdateSettingTileState();
}

class _UpdateSettingTileState extends State<UpdateSettingTile> {
  final _controller = GetIt.I.get<DesktopUpdaterController>();
  bool _checking = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.settingsCheckUpdatesDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: _checking
                ? context.l10n.updateChecking
                : context.l10n.settingsCheckUpdates,
            icon: Icons.system_update_alt,
            onPressed: _checking ? null : _check,
          ),
        ),
      ],
    );
  }

  Future<void> _check() async {
    setState(() => _checking = true);
    final result = await _controller.checkForUpdates();
    if (result is ManualUpdateCheckFailed) {
      AppLogger.error('UpdateSettingTile.check', result.error, result.stackTrace);
    }
    if (!mounted) return;

    final message = switch (result) {
      ManualUpdateCheckUpToDate() => context.l10n.updateUpToDate,
      ManualUpdateCheckAvailable(:final descriptor) =>
        context.l10n.updateAvailable(descriptor.version),
      ManualUpdateCheckFreshInstallRequired(:final descriptor) =>
        context.l10n.updateAvailable(descriptor.version),
      ManualUpdateCheckBlockedBySupportPolicy(:final descriptor) =>
        context.l10n.updateAvailable(descriptor.version),
      ManualUpdateCheckFailed() => context.l10n.updateCheckFailed,
    };

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    setState(() => _checking = false);
  }
}
