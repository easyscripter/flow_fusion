import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/settings_view/widgets/setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ManualPhaseSwitchSettingTile extends StatelessWidget {
  final AppViewModel appViewModel;

  const ManualPhaseSwitchSettingTile({super.key, required this.appViewModel});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => SettingRow(
        title: context.l10n.settingsManualPhaseSwitch,
        description: context.l10n.settingsManualPhaseSwitchDescription,
        control: Align(
          alignment: Alignment.centerRight,
          child: Switch(
            value: appViewModel.manualPhaseSwitch,
            onChanged: appViewModel.setManualPhaseSwitch,
          ),
        ),
      ),
    );
  }
}
