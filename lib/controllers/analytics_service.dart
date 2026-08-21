import 'package:aptabase_flutter/aptabase_flutter.dart';
import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AnalyticsService {
  final Prefs _prefs;
  bool _initialized = false;
  String _appKey = '';
  String? _host;

  AnalyticsService(this._prefs);

  Future<void> init(String appKey, {String? host}) async {
    _appKey = appKey;
    _host = host;
    if (_initialized || _appKey.isEmpty) return;

    if (_prefs.analyticsOptIn) {
      await Aptabase.init(appKey,
          InitOptions(host: host != null && host.isNotEmpty ? host : null));
      _initialized = true;
    }
  }

  Future<void> updateOptIn(bool optIn) async {
    if (optIn && !_initialized && _appKey.isNotEmpty) {
      await Aptabase.init(_appKey,
          InitOptions(host: _host != null && _host!.isNotEmpty ? _host : null));
      _initialized = true;
      trackEvent('analytics_enabled');
    }
  }

  void trackEvent(String eventName, [Map<String, dynamic>? props]) {
    if (_prefs.analyticsOptIn && _initialized) {
      Aptabase.instance.trackEvent(eventName, props);
    }
  }

  void trackException(Object error, [StackTrace? stackTrace]) {
    if (_prefs.analyticsOptIn && _initialized) {
      final props = <String, dynamic>{
        'error': error.toString(),
      };
      if (stackTrace != null) {
        // limit stacktrace length so it doesn't exceed aptabase limits
        final st = stackTrace.toString();
        props['stackTrace'] = st.length > 500 ? '${st.substring(0, 500)}...' : st;
      }
      Aptabase.instance.trackEvent('exception', props);
    }
  }
}

