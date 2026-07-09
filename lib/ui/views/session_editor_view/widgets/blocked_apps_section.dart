import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flow_fusion/controllers/app_blocker_service.dart';
import 'package:flow_fusion/model/entity/blocked_app.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/session_editor_view_model.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/blocked_app_tile.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/blocked_apps_picker.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class BlockedAppsSection extends StatelessWidget {
  const BlockedAppsSection({super.key, required this.viewModel});

  final SessionEditorViewModel viewModel;

  Future<void> _handleAdd(BuildContext context) async {
    if (Platform.isMacOS) {
      final BlockedApp? app = await showBlockedAppsPicker(
        context,
        GetIt.I.get<AppBlockerService>(),
      );
      if (app != null) viewModel.addBlockedApp(app);
      return;
    }

    const XTypeGroup group = XTypeGroup(
      label: 'Executables',
      extensions: <String>['exe'],
    );
    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[group],
    );
    if (file == null) return;

    final String fileName = file.name;
    final String selfExe =
        Platform.resolvedExecutable.split(Platform.pathSeparator).last;
    if (fileName.toLowerCase() == selfExe.toLowerCase()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.sessionEditorCannotBlockSelf)),
        );
      }
      return;
    }

    final String display = fileName.toLowerCase().endsWith('.exe')
        ? fileName.substring(0, fileName.length - 4)
        : fileName;
    viewModel.addBlockedApp(
      BlockedApp(name: display, executable: fileName),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isWindows && !Platform.isMacOS) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.sessionEditorBlockedAppsTitle,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSizes.paddingSmall / 2),
        Text(
          context.l10n.sessionEditorBlockedAppsSubtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.fusionColors.mutedForeground,
              ),
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        AppButton(
          label: context.l10n.sessionEditorAddBlockedApp,
          icon: Icons.block_rounded,
          variant: AppButtonVariant.secondary,
          onPressed: () => _handleAdd(context),
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        Observer(
          builder: (_) {
            if (viewModel.blockedApps.isEmpty) {
              return Text(
                context.l10n.sessionEditorNoBlockedApps,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.fusionColors.mutedForeground,
                    ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.blockedApps.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSizes.paddingSmall),
              itemBuilder: (BuildContext context, int index) {
                final BlockedApp app = viewModel.blockedApps[index];
                return BlockedAppTile(
                  app: app,
                  onRemove: () => viewModel.removeBlockedApp(app),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
