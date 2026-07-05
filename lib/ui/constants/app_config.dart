/// Конфигурация приложения, зависящая от окружения/релиза.
class AppConfig {
  static const String updateArchiveUrl =
      'https://easyscripter.github.io/flow_fusion/app-archive.json';

  static const String releaseNotesBaseUrl =
      'https://easyscripter.github.io/flow_fusion/';

  static String releaseNotesUrlForLanguage(String languageCode) =>
      '${releaseNotesBaseUrl}release-notes.$languageCode.json';
}
