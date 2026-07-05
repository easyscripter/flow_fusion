import 'dart:convert';

import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flow_fusion/ui/constants/app_config.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalizedReleaseNotesLoader {
  LocalizedReleaseNotesLoader(this._prefs);

  final Prefs _prefs;

  static const _fallbackLanguage = 'en';
  static const _supportedLanguages = {'en', 'ru'};

  /// Signature matches `desktop_updater`'s `ReleaseNotesLoader` typedef.
  Future<ReleaseNotes> load(ReleaseDescriptor descriptor) async {
    final language = _resolveLanguage();
    final notes = await _fetch(language);
    if (notes != null) return notes;

    if (language != _fallbackLanguage) {
      final fallback = await _fetch(_fallbackLanguage);
      if (fallback != null) return fallback;
    }
    throw StateError('Release notes are unavailable.');
  }

  String _resolveLanguage() {
    final language = _prefs.language ?? _fallbackLanguage;
    return _supportedLanguages.contains(language)
        ? language
        : _fallbackLanguage;
  }

  Future<ReleaseNotes?> _fetch(String language) async {
    final url = Uri.parse(AppConfig.releaseNotesUrlForLanguage(language));
    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        AppLogger.warn(
          'ReleaseNotesLoader',
          'GET $url returned ${response.statusCode}',
        );
        return null;
      }
      // Decode as UTF-8 explicitly so Cyrillic text is read correctly.
      final json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return ReleaseNotes.fromJson(json);
    } catch (e, s) {
      AppLogger.error('ReleaseNotesLoader.fetch($language)', e, s);
      return null;
    }
  }
}
