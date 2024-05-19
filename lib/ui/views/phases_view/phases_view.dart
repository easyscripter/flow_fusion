import 'package:flow_fusion/enums/phase_type.dart';
import 'package:flow_fusion/model/entity/database/phase.dart';
import 'package:flow_fusion/ui/views/phases_view/phases_view_view_model.dart';
import 'package:flow_fusion/ui/widgets/phase_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PhasesView extends StatefulWidget {
  final int sessionId;
  final Function onStartTimer;

  const PhasesView({
    super.key,
    required this.sessionId,
    required this.onStartTimer,
  });

  @override
  State<PhasesView> createState() => _PhasesViewState();
}

class _PhasesViewState extends State<PhasesView> {
  final _viewModel = PhasesViewViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init(widget.sessionId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) => Column(
          children: <Widget>[
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: ListView.separated(
                  itemCount: _viewModel.phases.length,
                  itemBuilder: (context, index) {
                    return PhaseWidget(
                      number: index + 1,
                      title: _viewModel.phases[index].name,
                      type: _viewModel.phases[index].type,
                      color: _viewModel.phases[index].type == PhaseType.work
                          ? Colors.orange
                          : Colors.green,
                      duration: _viewModel.phases[index].duration,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () => {
                        if (_viewModel.phases.length % 2 == 0)
                          {
                            _viewModel.addPhase(Phase(
                              sessionId: widget.sessionId,
                              name: 'Work',
                              type: PhaseType.work,
                              duration: const Duration(seconds: 15),
                            ))
                          }
                        else
                          {
                            _viewModel.addPhase(Phase(
                              sessionId: widget.sessionId,
                              name: 'Chill',
                              type: PhaseType.chill,
                              duration: const Duration(seconds: 10),
                            ))
                          }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Phase'),
                    ),
                    const SizedBox(width: 12.0),
                    ElevatedButton.icon(
                      onPressed: _viewModel.phases.isEmpty
                          ? null
                          : () => widget.onStartTimer(),
                      icon: const Icon(Icons.timer),
                      label: const Text('Start Timer'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
