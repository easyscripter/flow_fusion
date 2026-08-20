/// Конфигурация приложения, зависящая от окружения/релиза.
class AppConfig {
  static const String updateArchiveUrl =
      'https://easyscripter.github.io/flow_fusion/app-archive.json';

  static const String releaseNotesBaseUrl =
      'https://easyscripter.github.io/flow_fusion/';

  static String releaseNotesUrlForLanguage(String languageCode) =>
      '${releaseNotesBaseUrl}release-notes.$languageCode.json';

  /// Aptabase App Key. Passed via --dart-define=APTABASE_APP_KEY="A-EU-XXX"
  static const String aptabaseAppKey =
      String.fromEnvironment('APTABASE_APP_KEY');

  /// Aptabase Host (for self-hosted). Passed via --dart-define=APTABASE_HOST="https://your-domain.com"
  static const String aptabaseHost =
      String.fromEnvironment('APTABASE_HOST');
}
