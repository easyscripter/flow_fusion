import 'dart:io';

import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/widgets/setting_row.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LogsSettingTile extends StatelessWidget {
  const LogsSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingRow(
      title: context.l10n.settingsLogs,
      description: context.l10n.settingsLogsDescription,
      control: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            onPressed: () => _openLogsFolder(context),
            child: Text(context.l10n.settingsLogsOpenFolder),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _copyDiagnostics(context),
            child: Text(context.l10n.settingsCopyDiagnostics),
          ),
        ],
      ),
    );
  }

  Future<void> _openLogsFolder(BuildContext context) async {
    final dir = AppLogger.logDirectory;
    if (dir == null) {
      _showSnack(context, context.l10n.settingsLogsUnavailable);
      return;
    }
    try {
      await launchUrl(Uri.file(dir.path));
    } catch (e, s) {
      AppLogger.error('LogsSettingTile.openLogsFolder', e, s);
      if (context.mounted) {
        _showSnack(context, context.l10n.settingsLogsUnavailable);
      }
    }
  }

  Future<void> _copyDiagnostics(BuildContext context) async {
    final info = GetIt.I.get<PackageInfo>();
    final text =
        'App: ${info.appName} ${info.version}+${info.buildNumber}\n'
        'OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}\n'
        'Logs: ${AppLogger.logFile?.path ?? 'n/a'}';
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      _showSnack(context, context.l10n.settingsDiagnosticsCopied);
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
