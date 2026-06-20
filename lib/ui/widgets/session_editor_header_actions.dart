import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/session_editor_view_model.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class SessionEditorHeaderActions extends StatelessWidget {
  final SessionEditorViewModel viewModel;

  const SessionEditorHeaderActions({super.key, required this.viewModel});

  Future<void> _save(BuildContext context) async {
    final saved = await viewModel.save();
    if (saved && context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          label: context.l10n.sessionEditorCancel,
          variant: AppButtonVariant.ghost,
          onPressed: () => context.pop(),
        ),
        const SizedBox(width: AppSizes.paddingSmall),
        Observer(
          builder: (_) => AppButton(
            label: context.l10n.sessionEditorSave,
            icon: Icons.check_rounded,
            onPressed: viewModel.canSave ? () => _save(context) : null,
          ),
        ),
      ],
    );
  }
}
