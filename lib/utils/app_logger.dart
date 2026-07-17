import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class AppLogger {
  AppLogger._();

  static File? _logFile;
  static bool _initialized = false;

  static const int _maxBytes = 5 * 1024 * 1024; // ~5 MB

  static Directory? _logDir;

  static Directory? get logDirectory => _logDir;
  static File? get logFile => _logFile;

  static Future<void> init() async {
    if (_initialized) return;
    String version = 'unknown';
    try {
      final info = await PackageInfo.fromPlatform();
      version = '${info.version}+${info.buildNumber}';
    } catch (_) {}
    try {
      final supportDir = await getApplicationSupportDirectory();
      final dir = Directory('${supportDir.path}${Platform.pathSeparator}logs');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      _logDir = dir;
      _logFile = File('${dir.path}${Platform.pathSeparator}flow_fusion.log');
      _rotateIfNeeded();
    } catch (e) {
      debugPrint('AppLogger init failed: $e');
      _logFile = null;
    } finally {
      _initialized = true;
    }
    info(
      'AppLogger',
      'Logging started (version: $version, file: ${_logFile?.path ?? 'none'})',
    );
  }

  static void debug(String context, Object? message) =>
      _write('DEBUG', context, message);

  static void info(String context, Object? message) =>
      _write('INFO', context, message);

  static void warn(String context, Object? message) =>
      _write('WARN', context, message);

  static void error(String context, Object? error, [StackTrace? stack]) {
    final buffer = StringBuffer(error?.toString() ?? 'null');
    if (stack != null) {
      buffer
        ..write('\n')
        ..write(stack);
    }
    _write('ERROR', context, buffer.toString());
  }

  static void _write(String level, String context, Object? message) {
    final line =
        '${DateTime.now().toIso8601String()} '
        '[$level] $context: $message';
    if (kDebugMode) {
      debugPrint(line);
    }
    final file = _logFile;
    if (file == null) return;
    try {
      file.writeAsStringSync('$line\n', mode: FileMode.append, flush: false);
    } catch (_) {}
  }

  static void _rotateIfNeeded() {
    final file = _logFile;
    if (file == null || !file.existsSync()) return;
    try {
      if (file.lengthSync() < _maxBytes) return;
      final rotated = File('${file.path}.1');
      if (rotated.existsSync()) {
        rotated.deleteSync();
      }
      file.renameSync(rotated.path);
    } catch (_) {}
  }
}
