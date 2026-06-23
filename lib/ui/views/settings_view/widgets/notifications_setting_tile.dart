import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/settings_view/widgets/notification_permission_dialog.dart';
import 'package:flow_fusion/ui/widgets/setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class NotificationsSettingTile extends StatelessWidget {
  const NotificationsSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    final appViewModel = GetIt.I.get<AppViewModel>();

    return Observer(
      builder: (_) => SettingRow(
        title: context.l10n.settingsNotificationsEnabled,
        description: context.l10n.settingsNotificationsDescription,
        control: Align(
          alignment: Alignment.centerRight,
          child: Switch(
            value: appViewModel.notificationsActive,
            onChanged: (value) => _onChanged(context, appViewModel, value),
          ),
        ),
      ),
    );
  }

  Future<void> _onChanged(
    BuildContext context,
    AppViewModel appViewModel,
    bool value,
  ) async {
    final active = await appViewModel.setNotificationsEnabled(value);
    // Turning on while the OS permission is missing: guide the user to the
    // system settings instead of silently leaving the switch off.
    if (value && !active && context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (_) => const NotificationPermissionDialog(),
      );
    }
  }
}
