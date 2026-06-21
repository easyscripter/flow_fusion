import 'package:flutter/material.dart';

@immutable
class FlowFusionColors extends ThemeExtension<FlowFusionColors> {
  // Поверхности и линии
  final Color pageBackground;
  final Color sidebarBackground;
  final Color sidebarBorder;
  final Color cardBackground;
  final Color cardBorder;
  final Color cardHover;
  final Color panelSoft;
  final Color panelMuted;
  final Color lineStrong;

  // Акценты
  final Color accent;
  final Color accentStrong;
  final Color accentSoft;
  final Color accentBackground;
  final Color accentForeground;
  final Color mutedForeground;

  // Семантика
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color danger;
  final Color dangerSoft;

  const FlowFusionColors({
    required this.pageBackground,
    required this.sidebarBackground,
    required this.sidebarBorder,
    required this.cardBackground,
    required this.cardBorder,
    required this.cardHover,
    required this.panelSoft,
    required this.panelMuted,
    required this.lineStrong,
    required this.accent,
    required this.accentStrong,
    required this.accentSoft,
    required this.accentBackground,
    required this.accentForeground,
    required this.mutedForeground,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.danger,
    required this.dangerSoft,
  });

  /// Цвет фазы по её типу: work — красный, chill — зелёный.
  Color get workColor => danger;
  Color get chillColor => success;

  /// Мягкий фон фазы (карточка таймера и её поля).
  Color get workSurface => dangerSoft;
  Color get chillSurface => successSoft;

  /// Градиент логотипа: 135°, синий → зелёный (см. `.logo` в мокапе).
  Gradient get logoGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, success],
  );

  /// Градиент primary-кнопки: вертикальный, акцент → насыщенный акцент.
  Gradient get primaryButtonGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accent, accentStrong],
  );

  @override
  FlowFusionColors copyWith({
    Color? pageBackground,
    Color? sidebarBackground,
    Color? sidebarBorder,
    Color? cardBackground,
    Color? cardBorder,
    Color? cardHover,
    Color? panelSoft,
    Color? panelMuted,
    Color? lineStrong,
    Color? accent,
    Color? accentStrong,
    Color? accentSoft,
    Color? accentBackground,
    Color? accentForeground,
    Color? mutedForeground,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? danger,
    Color? dangerSoft,
  }) {
    return FlowFusionColors(
      pageBackground: pageBackground ?? this.pageBackground,
      sidebarBackground: sidebarBackground ?? this.sidebarBackground,
      sidebarBorder: sidebarBorder ?? this.sidebarBorder,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      cardHover: cardHover ?? this.cardHover,
      panelSoft: panelSoft ?? this.panelSoft,
      panelMuted: panelMuted ?? this.panelMuted,
      lineStrong: lineStrong ?? this.lineStrong,
      accent: accent ?? this.accent,
      accentStrong: accentStrong ?? this.accentStrong,
      accentSoft: accentSoft ?? this.accentSoft,
      accentBackground: accentBackground ?? this.accentBackground,
      accentForeground: accentForeground ?? this.accentForeground,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
    );
  }

  @override
  FlowFusionColors lerp(
    covariant ThemeExtension<FlowFusionColors>? other,
    double t,
  ) {
    if (other is! FlowFusionColors) {
      return this;
    }

    return FlowFusionColors(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      sidebarBackground: Color.lerp(sidebarBackground, other.sidebarBackground, t)!,
      sidebarBorder: Color.lerp(sidebarBorder, other.sidebarBorder, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardHover: Color.lerp(cardHover, other.cardHover, t)!,
      panelSoft: Color.lerp(panelSoft, other.panelSoft, t)!,
      panelMuted: Color.lerp(panelMuted, other.panelMuted, t)!,
      lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentStrong: Color.lerp(accentStrong, other.accentStrong, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      accentBackground: Color.lerp(accentBackground, other.accentBackground, t)!,
      accentForeground: Color.lerp(accentForeground, other.accentForeground, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
    );
  }
}
