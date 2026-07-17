import 'package:flow_fusion/controllers/app_blocker_service.dart';
import 'package:flow_fusion/model/entity/blocked_app.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/blocked_apps_picker_dialog.dart';
import 'package:flutter/material.dart';

Future<BlockedApp?> showBlockedAppsPicker(
  BuildContext context,
  AppBlockerService service,
) {
  return showDialog<BlockedApp>(
    context: context,
    builder: (BuildContext context) =>
        BlockedAppsPickerDialog(service: service),
  );
}
