import 'dart:async';

class SessionTicker {
  SessionTicker({Duration interval = const Duration(seconds: 1)})
    : _interval = interval;

  final Duration _interval;
  Timer? _timer;

  bool get isRunning => _timer != null;

  void start(void Function() onTick) {
    stop();
    _timer = Timer.periodic(_interval, (_) => onTick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
