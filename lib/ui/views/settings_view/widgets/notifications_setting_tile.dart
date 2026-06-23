import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
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
            value: appViewModel.notificationsEnabled,
            onChanged: appViewModel.setNotificationsEnabled,
          ),
        ),
      ),
    );
  }
}
