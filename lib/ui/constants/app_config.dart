/// Конфигурация приложения, зависящая от окружения/релиза.
class AppConfig {
  // OTA-обновления (desktop_updater).
  // Путь `latest/download/...` на GitHub Releases — стабильный URL,
  // который всегда указывает на ассеты самого свежего релиза.
  static const String updateArchiveUrl =
      'https://github.com/easyscripter/flow_fusion/releases/latest/download/app-archive.json';
}
