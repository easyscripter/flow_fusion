import 'dart:io';
import 'package:flow_fusion/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

@lazySingleton
class TrayService with TrayListener, WindowListener {
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final l10n = await _loadL10n();

    trayManager.addListener(this);
    windowManager.addListener(this);
    await windowManager.setPreventClose(true);
    await trayManager.setIcon(
      Platform.isWindows
          ? 'assets/images/app_icon.ico'
          : 'assets/images/app_logo.png',
    );
    trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(key: 'show_window', label: l10n.showWindow),
          MenuItem.separator(),
          MenuItem(key: 'exit_app', label: l10n.exitApp),
        ],
      ),
    );
    await trayManager.setToolTip('Flow Fusion');
  }

  @override
  void onWindowClose() async {
    if (await windowManager.isPreventClose()) {
      await windowManager.hide();
      await windowManager.setSkipTaskbar(true);
    }
  }

  @override
  void onTrayIconMouseDown() {
    _showWindow();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_window':
        _showWindow();
        break;
      case 'exit_app':
        windowManager.destroy();
        break;
    }
  }

  void _showWindow() async {
    windowManager.show();
    windowManager.focus();
    await windowManager.setSkipTaskbar(false);
  }

  Future<AppLocalizations> _loadL10n() async {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final supportedLocale = AppLocalizations.supportedLocales.firstWhere(
      (candidate) => candidate.languageCode == locale.languageCode,
      orElse: () => AppLocalizations.supportedLocales.first,
    );
    return AppLocalizations.delegate.load(supportedLocale);
  }
}
