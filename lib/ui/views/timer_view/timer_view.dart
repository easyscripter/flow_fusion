import 'package:flow_fusion/enums/phase_type.dart';
import 'package:flow_fusion/ui/views/timer_view/timer_view_view_model.dart';
import 'package:flow_fusion/ui/widgets/timer_progress_bar/timer_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TimerView extends StatefulWidget {
  final int sessionId;

  const TimerView({
    super.key,
    required this.sessionId,
  });

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  final TimerViewViewModel _viewModel = TimerViewViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init(widget.sessionId);
  }

  Widget _buildButtons(BuildContext context) {
    return Wrap(
      runAlignment: WrapAlignment.center,
      spacing: 10,
      children: [
        if (_viewModel.isRunning || _viewModel.isPaused)
          FilledButton.tonalIcon(
            onPressed: () => _viewModel.onTogglePause(),
            label: Text(
              _viewModel.isNotStarted
                  ? 'Start'
                  : _viewModel.isRunning
                      ? 'Pause'
                      : 'Resume',
            ),
            icon: _viewModel.isNotStarted || _viewModel.isPaused
                ? const Icon(Icons.play_arrow)
                : const Icon(Icons.pause),
          ),
        if ((_viewModel.isRunning || _viewModel.isPaused) &&
            !_viewModel.isNotStarted)
          FilledButton.tonalIcon(
            label: const Text('Stop'),
            icon: const Icon(Icons.stop),
            onPressed: () => _viewModel.onStop(),
          ),
        if (_viewModel.isEnded)
          FilledButton.tonalIcon(
            label: const Text('Reset'),
            icon: const Icon(Icons.restart_alt),
            onPressed: () => _viewModel.onReset(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    children: [
                      if (_viewModel.currentPhase != null)
                        if (_viewModel.currentPhase!.type == PhaseType.work)
                          TimerProgressBar.work(
                            value: _viewModel.progress,
                          )
                        else
                          TimerProgressBar.chill(
                            value: _viewModel.progress,
                          ),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _viewModel.timeRemainingString,
                              style: const TextStyle(
                                fontSize: 48.0,
                              ),
                            ),
                            Text(
                              _viewModel.timeRemainingMilliseconds,
                              style: const TextStyle(
                                  fontSize: 24.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            _buildButtons(context),
          ],
        ),
      );
    });
    // return Observer(
    //   builder: (context) {
    //     return Column(
    //       mainAxisSize: MainAxisSize.max,
    //       children: [
    //         Expanded(
    //           child: Center(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 if (_viewModel.isEnded)
    //                   const Text(
    //                     'Done!',
    //                     style: TextStyle(fontSize: 48.0),
    //                   ),
    //                 if (!_viewModel.isEnded)
    //                   Text(
    //                     ' ${_viewModel.timerString}',
    //                     style: const TextStyle(fontSize: 48.0),
    //                   ),
    //                 if (!_viewModel.isEnded)
    //                   CircularProgressIndicator(
    //                     value: _viewModel.progress,
    //                   ),
    //                 if (!_viewModel.isEnded)
    //                   Text(
    //                     'Phase: ${_viewModel.phase + 1}/${_viewModel.phases.length}',
    //                   ),
    //                 if (_viewModel.isEnded)
    //                   Text(
    //                     'Phase: ${_viewModel.phases.length}/${_viewModel.phases.length}',
    //                   ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         Row(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             if (_viewModel.isRunning || _viewModel.isPaused)
    //               MaterialButton(
    //                 child: Text(
    //                     _viewModel.isNotStarted ? 'Start' : 'Pause/Resume'),
    //                 onPressed: () {
    //                   _viewModel.onTogglePause();
    //                 },
    //               ),
    //             if (_viewModel.isRunning || _viewModel.isPaused)
    //               MaterialButton(
    //                 child: const Text('Stop'),
    //                 onPressed: () {
    //                   _viewModel.onStop();
    //                 },
    //               ),
    //             if (_viewModel.isEnded)
    //               MaterialButton(
    //                 child: const Text('Reset'),
    //                 onPressed: () {
    //                   _viewModel.onReset();
    //                 },
    //               ),
    //           ],
    //         )
    //       ],
    //     );
    //   },
    // );
  }
}
