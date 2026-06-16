import 'package:flutter/material.dart';

@immutable
class FlowFusionColors extends ThemeExtension<FlowFusionColors> {
  final Color pageBackground;
  final Color sidebarBackground;
  final Color sidebarBorder;
  final Color cardBackground;
  final Color cardBorder;
  final Color cardHover;
  final Color accentBackground;
  final Color accentForeground;
  final Color mutedForeground;
  final Color success;
  final Color warning;

  const FlowFusionColors({
    required this.pageBackground,
    required this.sidebarBackground,
    required this.sidebarBorder,
    required this.cardBackground,
    required this.cardBorder,
    required this.cardHover,
    required this.accentBackground,
    required this.accentForeground,
    required this.mutedForeground,
    required this.success,
    required this.warning,
  });

  @override
  FlowFusionColors copyWith({
    Color? pageBackground,
    Color? sidebarBackground,
    Color? sidebarBorder,
    Color? cardBackground,
    Color? cardBorder,
    Color? cardHover,
    Color? accentBackground,
    Color? accentForeground,
    Color? mutedForeground,
    Color? success,
    Color? warning,
  }) {
    return FlowFusionColors(
      pageBackground: pageBackground ?? this.pageBackground,
      sidebarBackground: sidebarBackground ?? this.sidebarBackground,
      sidebarBorder: sidebarBorder ?? this.sidebarBorder,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      cardHover: cardHover ?? this.cardHover,
      accentBackground: accentBackground ?? this.accentBackground,
      accentForeground: accentForeground ?? this.accentForeground,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      success: success ?? this.success,
      warning: warning ?? this.warning,
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
      accentBackground: Color.lerp(accentBackground, other.accentBackground, t)!,
      accentForeground: Color.lerp(accentForeground, other.accentForeground, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}
