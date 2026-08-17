import 'dart:async';
import 'dart:io';

import 'package:flow_fusion/controllers/site_blocking/local_blocking_proxy.dart';
import 'package:flow_fusion/controllers/site_blocking/macos_proxy_configurator.dart';
import 'package:flow_fusion/controllers/site_blocking/system_proxy_configurator.dart';
import 'package:flow_fusion/controllers/site_blocking/windows_proxy_configurator.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SiteBlockerService {
  SiteBlockerService() : _configurator = _createConfigurator();

  final LocalBlockingProxy _proxy = LocalBlockingProxy();
  final SystemProxyConfigurator? _configurator;

  List<String>? _activeDomains;
  bool _proxyConfigured = false;

  Future<void> _lock = Future<void>.value();

  bool get _isSupported => _configurator != null;

  static SystemProxyConfigurator? _createConfigurator() {
    if (Platform.isWindows) return WindowsProxyConfigurator();
    if (Platform.isMacOS) return MacosProxyConfigurator();
    return null;
  }

  Future<void> startBlocking(List<String> domains) {
    if (!_isSupported) return Future<void>.value();

    final List<String> normalized = _normalizeAll(domains);
    if (normalized.isEmpty) return stopBlocking();
    if (_activeDomains != null && listEquals(_activeDomains, normalized)) {
      return Future<void>.value();
    }
    return _run(() async {
      if (!await _ensureProxyConfigured()) return;
      _proxy.updateBlockedDomains(normalized);
      _activeDomains = normalized;
    });
  }

  Future<void> stopBlocking() {
    if (!_isSupported) return Future<void>.value();
    return _run(() async {
      if (_activeDomains == null) return;
      _proxy.updateBlockedDomains(const <String>[]);
      _activeDomains = null;
    });
  }

  /// Cleans up after a previous run that crashed while blocking was active.
  /// Safe and cheap to call unconditionally on every app start.
  Future<void> selfHeal() {
    if (!_isSupported) return Future<void>.value();
    return _run(() => _configurator!.selfHeal());
  }

  /// Hands the system proxy pointer back to whatever it was before this app
  /// run touched it. Must be called before the process exits.
  Future<void> shutdown() {
    if (!_isSupported) return Future<void>.value();
    return _run(() async {
      _proxy.updateBlockedDomains(const <String>[]);
      _activeDomains = null;
      if (_proxyConfigured) {
        await _configurator?.disable();
        _proxyConfigured = false;
      }
      await _proxy.stop();
    });
  }

  Future<bool> _ensureProxyConfigured() async {
    if (_proxyConfigured) return true;
    try {
      final int port = await _proxy.start();
      final bool ok = await _configurator?.enable(port) ?? false;
      if (!ok) {
        await _proxy.stop();
      }
      _proxyConfigured = ok;
      return ok;
    } catch (e, s) {
      AppLogger.error('SiteBlockerService._ensureProxyConfigured', e, s);
      return false;
    }
  }

  Future<void> _run(Future<void> Function() action) {
    final Future<void> next = _lock.then((_) => action());
    _lock = next.catchError((Object _) {});
    return next;
  }

  List<String> _normalizeAll(List<String> domains) {
    final List<String> result = <String>[];
    for (final String raw in domains) {
      final String? domain = normalizeDomain(raw);
      if (domain != null && !result.contains(domain)) result.add(domain);
    }
    return result;
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
