import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/ui/views/phases_view/phases_view.dart';
import 'package:flow_fusion/ui/views/session_view/session_view_view_model.dart';
import 'package:flow_fusion/ui/views/timer_view/timer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SessionView extends StatefulWidget {
  final Session currentSession;
  const SessionView({
    super.key,
    required this.currentSession,
  });
  @override
  State<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final _viewModel = SessionViewViewModel();
  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Center(
        child: switch (_viewModel.currentView) {
          0 => TimerView(sessionId: widget.currentSession.id ?? 1),
          _ => PhasesView(
              sessionId: widget.currentSession.id ?? 1,
              onStartTimer: () {
                _viewModel.setCurrentView(0);
              },
            ),
        },
      ),
    );
  }
}
