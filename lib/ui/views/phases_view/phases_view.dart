import 'package:flow_fusion/model/entity/database/phase.dart';
import 'package:flow_fusion/ui/views/phases_view/phases_view_view_model.dart';
import 'package:flow_fusion/ui/widgets/phase_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PhasesView extends StatefulWidget {
  final int sessionId;
  const PhasesView({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  @override
  State<PhasesView> createState() => _PhasesViewState();
}

class _PhasesViewState extends State<PhasesView> {
  final _viewModel = PhasesViewViewModel();

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
    print(widget.sessionId); // Logging for debugging
    return FutureBuilder<List<Phase>>(
      future: _viewModel.getPhasesBySessionId(widget.sessionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Phase phase = snapshot.data![index];
              return PhaseWidget(phase: phase);
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return const Center(child: Text("No phases found"));
        }
      },
    );
  }
}
