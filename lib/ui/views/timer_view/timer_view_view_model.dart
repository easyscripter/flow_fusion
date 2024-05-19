import 'dart:async';

import 'package:flow_fusion/model/datasources/database/dao/phase_dao.dart';
import 'package:flow_fusion/model/entity/database/phase.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'timer_view_view_model.g.dart';

class TimerViewViewModel = _TimerViewViewModelBase with _$TimerViewViewModel;

abstract class _TimerViewViewModelBase with Store {
  final PhaseDao phaseDao = GetIt.I.get<PhaseDao>();
  @observable
  late int sessionId;

  @observable
  int phase = 0;
  @computed
  Phase get currentPhase => phases[phase];
  @observable
  List<Phase> phases = [];

  @observable
  DateTime? end;
  @observable
  Duration? timeLeft;

  @computed
  bool get isRunning => end != null && timeLeft != null && !isEnded;
  @computed
  bool get isPaused => end == null && timeLeft != null && !isEnded;
  @computed
  bool get isEnded => phase >= phases.length;
  @computed
  bool get isNotStarted =>
      isPaused &&
      timeLeft?.inMilliseconds == currentPhase.duration.inMilliseconds;

  @computed
  String get timerString {
    if (timeLeft != null) {
      final mins = timeLeft!.inMinutes.toString().padLeft(2, '0');
      final seconds = (timeLeft!.inSeconds % 60).toString().padLeft(2, '0');
      final milliseconds = (timeLeft!.inMilliseconds % 1000 ~/ 100).toString();
      return "$mins:$seconds.$milliseconds";
    } else {
      return '--:--.-';
    }
  }

  @computed
  double get progress {
    if (timeLeft != null) {
      return timeLeft!.inMilliseconds / currentPhase.duration.inMilliseconds;
    } else {
      return 0.0;
    }
  }

  Timer? tickTimer;
  Timer? endTimer;

  @action
  Future<void> init(int sessionId) async {
    this.sessionId = sessionId;
    phases = await phaseDao.findPhasesBySessionId(sessionId);
    onReset();
  }

  @action
  void _startTimer() {
    if (timeLeft != null) {
      endTimer = Timer(timeLeft!, () {
        timeLeft = null;
        end = null;
        _stopTimer();
        phase++;
        if (phase < phases.length) {
          timeLeft = currentPhase.duration;
          end = DateTime.now().add(currentPhase.duration);
          _startTimer();
        }
      });

      tickTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (end != null) {
          timeLeft = end!.difference(DateTime.now());
        }
      });
    }
  }

  @action
  void _stopTimer() {
    if (tickTimer != null) {
      tickTimer?.cancel();
      tickTimer = null;
    }

    if (endTimer != null) {
      endTimer!.cancel();
      endTimer = null;
    }
  }
  @action
  void onTogglePause() {
    if (end == null) {
      end = DateTime.now().add(timeLeft ?? currentPhase.duration);
      _startTimer();
    } else {
      end = null;
      _stopTimer();
    }
  }

  @action
  void onStop() {
    end = null;
    timeLeft = null;
    _stopTimer();
    phase = phases.length;
  }

  @action
  void onReset() {
    phase = 0;
    timeLeft = phases.first.duration;
    end = null;
  }
}
