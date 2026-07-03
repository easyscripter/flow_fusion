import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/session_editor_view_model.dart';
import 'package:flow_fusion/ui/widgets/session_icon_picker.dart';
import 'package:flow_fusion/ui/widgets/app_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


class SessionDetailsPanel extends StatefulWidget {
  final SessionEditorViewModel viewModel;

  const SessionDetailsPanel({super.key, required this.viewModel});

  @override
  State<SessionDetailsPanel> createState() => _SessionDetailsPanelState();
}

class _SessionDetailsPanelState extends State<SessionDetailsPanel> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.viewModel.title);
    _descriptionController = TextEditingController(
      text: widget.viewModel.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.sessionEditorIconLabel,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          Observer(
            builder: (_) => SessionIconPicker(
              selected: viewModel.icon,
              onSelected: viewModel.setIcon,
            ),
          ),
          const SizedBox(height: AppSizes.paddingLarge),
          TextField(
            controller: _titleController,
            onChanged: viewModel.setTitle,
            textCapitalization: TextCapitalization.sentences,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              labelText: context.l10n.sessionEditorTitleLabel,
              hintText: context.l10n.sessionEditorTitleHint,
            ),
          ),
          Observer(
            builder: (_) {
              if (!viewModel.showErrors || viewModel.hasTitle) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: AppSizes.paddingSmall),
                child: Text(
                  context.l10n.sessionEditorTitleRequired,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.fusionColors.danger,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          TextField(
            controller: _descriptionController,
            onChanged: viewModel.setDescription,
            textCapitalization: TextCapitalization.sentences,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: context.l10n.sessionEditorDescriptionLabel,
              hintText: context.l10n.sessionEditorDescriptionHint,
            ),
          ),
        ],
      ),
    );
  }
}
