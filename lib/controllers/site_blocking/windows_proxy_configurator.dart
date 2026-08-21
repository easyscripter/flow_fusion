import 'dart:ffi';

import 'package:flow_fusion/controllers/site_blocking/system_proxy_configurator.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:win32_registry/win32_registry.dart';

/// Points Windows' per-user proxy setting (`HKCU\...\Internet Settings`) at
/// the local blocking proxy. Writing this key needs no elevation — it is a
/// per-user setting, unlike the system-wide `hosts` file the app used to
/// edit.
class WindowsProxyConfigurator implements SystemProxyConfigurator {
  static const String _keyPath =
      r'Software\Microsoft\Windows\CurrentVersion\Internet Settings';
  static const int _internetOptionSettingsChanged = 39;
  static const int _internetOptionRefresh = 37;

  bool _saved = false;
  int? _previousEnabled;
  String? _previousServer;
  String? _previousOverride;

  @override
  Future<bool> enable(int port) async {
    RegistryKey? key;
    try {
      key = Registry.openPath(
        RegistryHive.currentUser,
        path: _keyPath,
        desiredAccessRights: AccessRights.allAccess,
      );

      if (!_saved) {
        _previousEnabled = key.getIntValue('ProxyEnable');
        _previousServer = key.getStringValue('ProxyServer');
        _previousOverride = key.getStringValue('ProxyOverride');
        _saved = true;
      }

      key.createValue(const RegistryValue.int32('ProxyEnable', 1));
      key.createValue(
        RegistryValue.string('ProxyServer', '127.0.0.1:$port'),
      );
      key.createValue(
        const RegistryValue.string('ProxyOverride', '<local>'),
      );
      _notifySettingsChanged();
      return true;
    } catch (e, s) {
      AppLogger.error('WindowsProxyConfigurator.enable', e, s);
      return false;
    } finally {
      key?.close();
    }
  }

  @override
  Future<void> disable() async {
    if (!_saved) return;
    RegistryKey? key;
    try {
      key = Registry.openPath(
        RegistryHive.currentUser,
        path: _keyPath,
        desiredAccessRights: AccessRights.allAccess,
      );

      key.createValue(
        RegistryValue.int32('ProxyEnable', _previousEnabled ?? 0),
      );

      final String? previousServer = _previousServer;
      if (previousServer != null && previousServer.isNotEmpty) {
        key.createValue(RegistryValue.string('ProxyServer', previousServer));
      } else {
        _tryDeleteValue(key, 'ProxyServer');
      }

      final String? previousOverride = _previousOverride;
      if (previousOverride != null && previousOverride.isNotEmpty) {
        key.createValue(
          RegistryValue.string('ProxyOverride', previousOverride),
        );
      } else {
        _tryDeleteValue(key, 'ProxyOverride');
      }

      _notifySettingsChanged();
    } catch (e, s) {
      AppLogger.error('WindowsProxyConfigurator.disable', e, s);
    } finally {
      key?.close();
      _saved = false;
      _previousEnabled = null;
      _previousServer = null;
      _previousOverride = null;
    }
  }

  @override
  Future<void> selfHeal() async {
    RegistryKey? key;
    try {
      key = Registry.openPath(
        RegistryHive.currentUser,
        path: _keyPath,
        desiredAccessRights: AccessRights.allAccess,
      );
      final String? server = key.getStringValue('ProxyServer');
      if (server != null && server.startsWith('127.0.0.1:')) {
        key.createValue(const RegistryValue.int32('ProxyEnable', 0));
        _tryDeleteValue(key, 'ProxyServer');
        _tryDeleteValue(key, 'ProxyOverride');
        _notifySettingsChanged();
      }
    } catch (e, s) {
      AppLogger.error('WindowsProxyConfigurator.selfHeal', e, s);
    } finally {
      key?.close();
    }
  }

  void _tryDeleteValue(RegistryKey key, String name) {
    try {
      key.deleteValue(name);
    } catch (_) {
      // Value did not exist to begin with — nothing to restore.
    }
  }

  void _notifySettingsChanged() {
    try {
      final DynamicLibrary wininet = DynamicLibrary.open('wininet.dll');
      final int Function(int, int, Pointer<Void>, int) internetSetOption =
          wininet
              .lookup<
                NativeFunction<
                  Int32 Function(IntPtr, Uint32, Pointer<Void>, Uint32)
                >
              >('InternetSetOptionW')
              .asFunction();
      internetSetOption(0, _internetOptionSettingsChanged, nullptr, 0);
      internetSetOption(0, _internetOptionRefresh, nullptr, 0);
    } catch (e, s) {
      AppLogger.error(
        'WindowsProxyConfigurator._notifySettingsChanged',
        e,
        s,
      );
    }
  }
}
