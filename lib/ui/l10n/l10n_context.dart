import 'package:flow_fusion/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Короткий доступ к локализованным строкам: `context.l10n.navOverview`.
/// По аналогии с `context.fusionColors` (см. `theme_context.dart`).
extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
