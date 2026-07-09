import 'package:flow_fusion/controllers/app_blocker_service.dart';
import 'package:flow_fusion/model/entity/blocked_app.dart';
import 'package:flow_fusion/model/entity/installed_app.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/installed_app_icon.dart';
import 'package:flutter/material.dart';

class BlockedAppsPickerDialog extends StatefulWidget {
  const BlockedAppsPickerDialog({super.key, required this.service});

  final AppBlockerService service;

  @override
  State<BlockedAppsPickerDialog> createState() =>
      _BlockedAppsPickerDialogState();
}

class _BlockedAppsPickerDialogState extends State<BlockedAppsPickerDialog> {
  bool _isLoading = true;
  List<InstalledApp> _apps = const <InstalledApp>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<InstalledApp> apps = await widget.service.listInstalledApps();
    if (!mounted) return;
    setState(() {
      _apps = apps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.blockedAppsPickerTitle),
      content: SizedBox(
        width: 360,
        height: 420,
        child: _buildContent(context),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.blockedAppsPickerCancel),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_apps.isEmpty) {
      return Center(child: Text(context.l10n.blockedAppsPickerEmpty));
    }
    return ListView.builder(
      itemCount: _apps.length,
      itemBuilder: (BuildContext context, int index) {
        final InstalledApp app = _apps[index];
        return ListTile(
          leading: InstalledAppIcon(iconBase64: app.iconBase64),
          title: Text(app.name),
          onTap: () => Navigator.of(context).pop(
            BlockedApp(name: app.name, bundleId: app.bundleId),
          ),
        );
      },
    );
  }
}
