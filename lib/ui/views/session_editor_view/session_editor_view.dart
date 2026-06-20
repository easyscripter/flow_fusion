import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/session_editor_view_model.dart';
import 'package:flow_fusion/ui/widgets/session_details_panel.dart';
import 'package:flow_fusion/ui/widgets/session_editor_header_actions.dart';
import 'package:flow_fusion/ui/widgets/session_timers_section.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SessionEditorView extends StatefulWidget {
  final int? sessionId;

  const SessionEditorView({super.key, this.sessionId});

  @override
  State<SessionEditorView> createState() => _SessionEditorViewState();
}

class _SessionEditorViewState extends State<SessionEditorView> {
  final _viewModel = SessionEditorViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Observer(
        builder: (context) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPageHeader(
                  title: _viewModel.isEditing
                      ? context.l10n.sessionEditorEditTitle
                      : context.l10n.sessionEditorCreateTitle,
                  subtitle: _viewModel.isEditing
                      ? context.l10n.sessionEditorEditSubtitle
                      : context.l10n.sessionEditorCreateSubtitle,
                  trailing: SessionEditorHeaderActions(viewModel: _viewModel),
                ),
                const SizedBox(height: AppSizes.paddingLarge),
                Expanded(
                  child: ListView(
                    children: [
                      SessionDetailsPanel(viewModel: _viewModel),
                      const SizedBox(height: AppSizes.paddingLarge),
                      SessionTimersSection(viewModel: _viewModel),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
