import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/sessions_view/sessions_view_view_model.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flow_fusion/ui/widgets/sessions_empty_state.dart';
import 'package:flow_fusion/ui/widgets/sessions_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SessionsView extends StatefulWidget {
  const SessionsView({super.key});

  @override
  State<SessionsView> createState() => _SessionsViewState();
}

class _SessionsViewState extends State<SessionsView> {
  final _viewModel = SessionsViewViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init();
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

          if (_viewModel.sessions.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: SessionsEmptyState(onCreate: _createNewSession),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPageHeader(
                  title: context.l10n.sessionsTitle,
                  subtitle: context.l10n.sessionsSubtitle,
                  trailing: AppButton(
                    label: context.l10n.sessionsNew,
                    icon: Icons.add,
                    onPressed: _createNewSession,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingLarge),
                Expanded(
                  child: SessionsGrid(
                    sessions: _viewModel.sessions,
                    onOpen: _openSession,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _createNewSession() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.sessionsCreateNotConnected)),
    );
  }

  void _openSession(Session session) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.sessionsOpening(session.name))),
    );
  }
}
