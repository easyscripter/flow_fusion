import 'package:flutter/widgets.dart';

class SessionLifecycleObserver with WidgetsBindingObserver {
  SessionLifecycleObserver(this._onChange);

  final void Function() _onChange;
  bool _observing = false;

  void start() {
    if (_observing) return;
    _observing = true;
    WidgetsBinding.instance.addObserver(this);
  }

  void stop() {
    if (!_observing) return;
    _observing = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _onChange();
      case AppLifecycleState.detached:
        break;
    }
  }
}
