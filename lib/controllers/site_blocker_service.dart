import 'dart:async';
import 'dart:io';

import 'package:flow_fusion/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SiteBlockerService {
  static const String _beginMarker = '# >>> Flow Fusion managed block >>>';
  static const String _endMarker = '# <<< Flow Fusion managed block <<<';

  List<String>? _activeDomains;

  Future<void> _lock = Future<void>.value();

  bool get _isSupported => Platform.isWindows;

  String get _hostsPath {
    final String root = Platform.environment['SystemRoot'] ?? r'C:\Windows';
    return '$root\\System32\\drivers\\etc\\hosts';
  }

  Future<void> startBlocking(List<String> domains) {
    if (!_isSupported) return Future<void>.value();

    final List<String> normalized = _normalizeAll(domains);
    if (normalized.isEmpty) return stopBlocking();
    if (_activeDomains != null && listEquals(_activeDomains, normalized)) {
      return Future<void>.value();
    }
    return _run(() async {
      await _applyBlock(normalized);
      _activeDomains = normalized;
    });
  }

  Future<void> stopBlocking() {
    if (!_isSupported) return Future<void>.value();
    return _run(() async {
      await _applyBlock(const <String>[]);
      _activeDomains = null;
    });
  }

  Future<void> _run(Future<void> Function() action) {
    final Future<void> next = _lock.then((_) => action());
    _lock = next.catchError((Object _) {});
    return next;
  }

  Future<void> _applyBlock(List<String> domains) async {
    try {
      final File file = File(_hostsPath);
      if (!await file.exists()) return;

      final String original = await file.readAsString();
      final String base = _stripManagedBlock(original);
      final String next = domains.isEmpty ? base : '$base${_buildBlock(domains)}';

      if (next == original) return;
      await file.writeAsString(next, flush: true);
      await _flushDns();
    } catch (e, s) {
      AppLogger.error('SiteBlockerService._applyBlock', e, s);
    }
  }

  String _buildBlock(List<String> domains) {
    final StringBuffer buffer = StringBuffer()
      ..write('\r\n')
      ..write(_beginMarker)
      ..write('\r\n');
    for (final String domain in domains) {
      for (final String host in _hostVariants(domain)) {
        buffer
          ..write('127.0.0.1 ')
          ..write(host)
          ..write('\r\n')
          ..write('::1 ')
          ..write(host)
          ..write('\r\n');
      }
    }
    buffer
      ..write(_endMarker)
      ..write('\r\n');
    return buffer.toString();
  }

  String _stripManagedBlock(String content) {
    final int start = content.indexOf(_beginMarker);
    if (start == -1) return content;
    final int endMarker = content.indexOf(_endMarker, start);
    if (endMarker == -1) return content;

    int from = start;
    while (from > 0 &&
        (content[from - 1] == '\n' || content[from - 1] == '\r')) {
      from--;
    }
    int to = endMarker + _endMarker.length;
    while (to < content.length &&
        (content[to] == '\n' || content[to] == '\r')) {
      to++;
    }
    return content.substring(0, from) + content.substring(to);
  }

  List<String> _normalizeAll(List<String> domains) {
    final List<String> result = <String>[];
    for (final String raw in domains) {
      final String? domain = normalizeDomain(raw);
      if (domain != null && !result.contains(domain)) result.add(domain);
    }
    return result;
  }

  List<String> _hostVariants(String domain) {
    if (domain.startsWith('www.')) {
      final String bare = domain.substring(4);
      return <String>[bare, domain];
    }
    return <String>[domain, 'www.$domain'];
  }

  Future<void> _flushDns() async {
    try {
      await Process.run('ipconfig', <String>['/flushdns']);
    } catch (e, s) {
      AppLogger.error('SiteBlockerService._flushDns', e, s);
    }
  }

  static String? normalizeDomain(String input) {
    String value = input.trim().toLowerCase();
    if (value.isEmpty) return null;

    final int scheme = value.indexOf('://');
    if (scheme != -1) value = value.substring(scheme + 3);

    value = value.split('/').first.split('?').first.split('#').first;
    final int at = value.indexOf('@');
    if (at != -1) value = value.substring(at + 1);
    value = value.split(':').first.trim();

    if (value.isEmpty || !value.contains('.')) return null;
    if (value.contains(' ')) return null;
    return value;
  }
}
