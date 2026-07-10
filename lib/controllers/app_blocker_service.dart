import 'dart:async';
import 'dart:io';

import 'package:flow_fusion/model/entity/blocked_app.dart';
import 'package:flow_fusion/model/entity/installed_app.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppBlockerService {
  static const MethodChannel _channel = MethodChannel('flow_fusion/app_blocker');

  static const Duration _interval = Duration(seconds: 2);

  Timer? _timer;
  List<String> _activeTokens = const <String>[];

  bool get _isSupported => Platform.isWindows || Platform.isMacOS;

  Future<List<InstalledApp>> listInstalledApps() async {
    if (!Platform.isMacOS) return const <InstalledApp>[];
    try {
      final List<dynamic>? result =
          await _channel.invokeMethod<List<dynamic>>('listInstalledApps');
      if (result == null) return const <InstalledApp>[];
      return result.map<InstalledApp>((dynamic e) {
        final Map<String, dynamic> map = (e as Map).cast<String, dynamic>();
        return InstalledApp(
          name: map['name'] as String,
          bundleId: map['bundleId'] as String,
          iconBase64: map['iconBase64'] as String?,
        );
      }).toList();
    } catch (e, s) {
      AppLogger.error('AppBlockerService.listInstalledApps', e, s);
      return const <InstalledApp>[];
    }
  }

  void startBlocking(List<BlockedApp> apps) {
    if (!_isSupported) return;

    final List<String> tokens = _tokensFor(apps);
    if (tokens.isEmpty) {
      stopBlocking();
      return;
    }
    if (_timer != null && listEquals(_activeTokens, tokens)) return;

    final bool wasRunning = _timer != null;
    _activeTokens = tokens;
    _timer?.cancel();
    unawaited(_enforce());
    _timer = Timer.periodic(_interval, (_) => unawaited(_enforce()));
    if (!wasRunning) {
      unawaited(_setBackgroundExecution(enabled: true));
    }
  }

  void stopBlocking() {
    final bool wasRunning = _timer != null;
    _timer?.cancel();
    _timer = null;
    _activeTokens = const <String>[];
    if (wasRunning) {
      unawaited(_setBackgroundExecution(enabled: false));
    }
  }

  Future<void> _setBackgroundExecution({required bool enabled}) async {
    if (!_isSupported) return;
    try {
      await _channel.invokeMethod<dynamic>(
        enabled ? 'beginBackgroundExecution' : 'endBackgroundExecution',
      );
    } catch (e, s) {
      AppLogger.error('AppBlockerService.setBackgroundExecution', e, s);
    }
  }

  List<String> _tokensFor(List<BlockedApp> apps) {
    final List<String> tokens = <String>[];
    for (final BlockedApp app in apps) {
      final String? token = Platform.isMacOS ? app.bundleId : app.executable;
      if (token != null && token.isNotEmpty) tokens.add(token);
    }
    return tokens;
  }

  Future<void> _enforce() async {
    try {
      await _channel.invokeMethod<dynamic>(
        'blockApps',
        <String, dynamic>{'tokens': _activeTokens},
      );
    } catch (e, s) {
      AppLogger.error('AppBlockerService.blockApps', e, s);
    }
  }
}
