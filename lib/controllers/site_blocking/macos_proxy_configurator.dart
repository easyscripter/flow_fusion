import 'dart:io';

import 'package:flow_fusion/controllers/site_blocking/system_proxy_configurator.dart';
import 'package:flow_fusion/utils/app_logger.dart';

class MacosProxyConfigurator implements SystemProxyConfigurator {
  bool _saved = false;
  List<_ServiceProxyState> _previousStates = <_ServiceProxyState>[];

  @override
  Future<bool> enable(int port) async {
    try {
      final List<String> services = await _enabledServices();
      if (services.isEmpty) return false;

      if (!_saved) {
        _previousStates = await _readStates(services);
        _saved = true;
      }

      final List<String> commands = <String>[];
      for (final String service in services) {
        final String s = _shellQuote(service);
        commands
          ..add('networksetup -setwebproxy $s 127.0.0.1 $port')
          ..add('networksetup -setwebproxystate $s on')
          ..add('networksetup -setsecurewebproxy $s 127.0.0.1 $port')
          ..add('networksetup -setsecurewebproxystate $s on')
          ..add('networksetup -setproxybypassdomains $s localhost 127.0.0.1');
      }
      return _runElevated(commands);
    } catch (e, s) {
      AppLogger.error('MacosProxyConfigurator.enable', e, s);
      return false;
    }
  }

  @override
  Future<void> disable() async {
    if (!_saved) return;
    try {
      final List<String> commands = <String>[];
      for (final _ServiceProxyState state in _previousStates) {
        final String s = _shellQuote(state.service);

        if (state.webEnabled && (state.webServer ?? '').isNotEmpty) {
          commands
            ..add(
              'networksetup -setwebproxy $s '
              '${_shellQuote(state.webServer!)} ${state.webPort}',
            )
            ..add('networksetup -setwebproxystate $s on');
        } else {
          commands.add('networksetup -setwebproxystate $s off');
        }

        if (state.secureEnabled && (state.secureServer ?? '').isNotEmpty) {
          commands
            ..add(
              'networksetup -setsecurewebproxy $s '
              '${_shellQuote(state.secureServer!)} ${state.securePort}',
            )
            ..add('networksetup -setsecurewebproxystate $s on');
        } else {
          commands.add('networksetup -setsecurewebproxystate $s off');
        }

        final String bypassArgs = state.bypass.isEmpty
            ? 'Empty'
            : state.bypass.map(_shellQuote).join(' ');
        commands.add('networksetup -setproxybypassdomains $s $bypassArgs');
      }
      await _runElevated(commands);
    } catch (e, s) {
      AppLogger.error('MacosProxyConfigurator.disable', e, s);
    } finally {
      _saved = false;
      _previousStates = <_ServiceProxyState>[];
    }
  }

  @override
  Future<void> selfHeal() async {
    try {
      final List<String> services = await _enabledServices();
      final List<String> toReset = <String>[];
      for (final String service in services) {
        final Map<String, String> web = await _getProxyInfo(
          '-getwebproxy',
          service,
        );
        final Map<String, String> secure = await _getProxyInfo(
          '-getsecurewebproxy',
          service,
        );
        if (web['Server'] == '127.0.0.1' || secure['Server'] == '127.0.0.1') {
          toReset.add(service);
        }
      }
      if (toReset.isEmpty) return;

      final List<String> commands = <String>[];
      for (final String service in toReset) {
        final String s = _shellQuote(service);
        commands
          ..add('networksetup -setwebproxystate $s off')
          ..add('networksetup -setsecurewebproxystate $s off');
      }
      await _runElevated(commands);
    } catch (e, s) {
      AppLogger.error('MacosProxyConfigurator.selfHeal', e, s);
    }
  }

  Future<List<String>> _enabledServices() async {
    final ProcessResult result = await Process.run('networksetup', <String>[
      '-listallnetworkservices',
    ]);
    if (result.exitCode != 0) return <String>[];

    final List<String> services = <String>[];
    for (final String raw in (result.stdout as String).split('\n').skip(1)) {
      final String line = raw.trim();
      if (line.isEmpty || line.startsWith('*')) continue;
      services.add(line);
    }
    return services;
  }

  Future<List<_ServiceProxyState>> _readStates(List<String> services) async {
    final List<_ServiceProxyState> states = <_ServiceProxyState>[];
    for (final String service in services) {
      final Map<String, String> web = await _getProxyInfo(
        '-getwebproxy',
        service,
      );
      final Map<String, String> secure = await _getProxyInfo(
        '-getsecurewebproxy',
        service,
      );
      final List<String> bypass = await _getBypassDomains(service);
      states.add(
        _ServiceProxyState(
          service: service,
          webEnabled: web['Enabled'] == 'Yes',
          webServer: web['Server'],
          webPort: int.tryParse(web['Port'] ?? '') ?? 0,
          secureEnabled: secure['Enabled'] == 'Yes',
          secureServer: secure['Server'],
          securePort: int.tryParse(secure['Port'] ?? '') ?? 0,
          bypass: bypass,
        ),
      );
    }
    return states;
  }

  Future<Map<String, String>> _getProxyInfo(String flag, String service) async {
    final Map<String, String> map = <String, String>{};
    final ProcessResult result = await Process.run('networksetup', <String>[
      flag,
      service,
    ]);
    if (result.exitCode != 0) return map;
    for (final String line in (result.stdout as String).split('\n')) {
      final int idx = line.indexOf(':');
      if (idx == -1) continue;
      map[line.substring(0, idx).trim()] = line.substring(idx + 1).trim();
    }
    return map;
  }

  Future<List<String>> _getBypassDomains(String service) async {
    final ProcessResult result = await Process.run('networksetup', <String>[
      '-getproxybypassdomains',
      service,
    ]);
    if (result.exitCode != 0) return <String>[];
    return (result.stdout as String)
        .split('\n')
        .map((String e) => e.trim())
        .where((String e) => e.isNotEmpty && !e.contains('***'))
        .toList();
  }

  Future<bool> _runElevated(List<String> commands) async {
    if (commands.isEmpty) return true;
    final String shellCommand = commands.join(' && ');
    final String appleScript =
        'do shell script "${_escapeForAppleScript(shellCommand)}" '
        'with administrator privileges';
    final ProcessResult result = await Process.run('osascript', <String>[
      '-e',
      appleScript,
    ]);
    if (result.exitCode != 0) {
      AppLogger.error('MacosProxyConfigurator._runElevated', result.stderr);
      return false;
    }
    return true;
  }

  String _escapeForAppleScript(String input) =>
      input.replaceAll('\\', r'\\').replaceAll('"', r'\"');

  String _shellQuote(String value) => "'${value.replaceAll("'", r"'\''")}'";
}

class _ServiceProxyState {
  _ServiceProxyState({
    required this.service,
    required this.webEnabled,
    required this.webServer,
    required this.webPort,
    required this.secureEnabled,
    required this.secureServer,
    required this.securePort,
    required this.bypass,
  });

  final String service;
  final bool webEnabled;
  final String? webServer;
  final int webPort;
  final bool secureEnabled;
  final String? secureServer;
  final int securePort;
  final List<String> bypass;
}
