import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.notificationPermissionTitle),
      content: Text(context.l10n.notificationPermissionMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.notificationPermissionCancel),
        ),
        FilledButton(
          onPressed: () {
            GetIt.I.get<AppViewModel>().openSystemNotificationSettings();
            Navigator.of(context).pop();
          },
          child: Text(context.l10n.notificationPermissionOpenSettings),
        ),
      ],
    );
  }
}
