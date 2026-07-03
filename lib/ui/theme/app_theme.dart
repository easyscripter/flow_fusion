import 'package:flow_fusion/ui/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

final class AppTheme {
  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2693F0),
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF2693F0),
      onPrimary: const Color(0xFFFFFFFF),
      secondary: const Color(0xFFEEF3F8),
      onSecondary: const Color(0xFF132033),
      surface: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFF132033),
      onSurfaceVariant: const Color(0xFF6D7A8B),
      outline: const Color(0xFFDDE5EE),
      outlineVariant: const Color(0xFFEEF3F8),
      error: const Color(0xFFD9544F),
      onError: const Color(0xFFFFFFFF),
      inverseSurface: const Color(0xFF132033),
      onInverseSurface: const Color(0xFFF5F7FA),
    ),
    extension: const FlowFusionColors(
      pageBackground: Color(0xFFEDF2F7),
      sidebarBackground: Color(0xFFF9FAFC),
      sidebarBorder: Color(0xFFDDE5EE),
      cardBackground: Color(0xFFFFFFFF),
      cardBorder: Color(0xFFDDE5EE),
      cardHover: Color(0xFFF5F7FA),
      panelSoft: Color(0xFFF5F7FA),
      panelMuted: Color(0xFFEEF3F8),
      lineStrong: Color(0xFFCCD7E3),
      accent: Color(0xFF2693F0),
      accentStrong: Color(0xFF1177D2),
      accentSoft: Color(0xFFB9DDFF),
      accentBackground: Color(0xFFEEF3F8),
      accentForeground: Color(0xFF1177D2),
      mutedForeground: Color(0xFF6D7A8B),
      success: Color(0xFF33BE6C),
      successSoft: Color(0xFFDFF7E8),
      warning: Color(0xFFA16207),
      danger: Color(0xFFD9544F),
      dangerSoft: Color(0xFFFDECEB),
    ),
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4AA8FF),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF4AA8FF),
      onPrimary: const Color(0xFF06223A),
      secondary: const Color(0xFF1E2C40),
      onSecondary: const Color(0xFFEEF5FF),
      surface: const Color(0xFF182232),
      onSurface: const Color(0xFFEEF5FF),
      onSurfaceVariant: const Color(0xFF93A2B8),
      outline: const Color(0xFF253448),
      outlineVariant: const Color(0xFF1E2C40),
      error: const Color(0xFFFF7C72),
      onError: const Color(0xFF2A0F0E),
      inverseSurface: const Color(0xFFEEF5FF),
      onInverseSurface: const Color(0xFF0F1824),
    ),
    extension: const FlowFusionColors(
      pageBackground: Color(0xFF0F1824),
      sidebarBackground: Color(0xFF111924),
      sidebarBorder: Color(0xFF253448),
      cardBackground: Color(0xFF182232),
      cardBorder: Color(0xFF253448),
      cardHover: Color(0xFF1E2C40),
      panelSoft: Color(0xFF121D2B),
      panelMuted: Color(0xFF1E2C40),
      lineStrong: Color(0xFF32465F),
      accent: Color(0xFF4AA8FF),
      accentStrong: Color(0xFF77BEFF),
      accentSoft: Color(0xFF294F73),
      accentBackground: Color(0xFF1E2C40),
      accentForeground: Color(0xFF77BEFF),
      mutedForeground: Color(0xFF93A2B8),
      success: Color(0xFF46CF7D),
      successSoft: Color(0xFF163425),
      warning: Color(0xFFFACC15),
      danger: Color(0xFFFF7C72),
      dangerSoft: Color(0xFF442221),
    ),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required FlowFusionColors extension,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: extension.pageBackground,
      canvasColor: extension.pageBackground,
      dividerColor: colorScheme.outline,
      extensions: [extension],
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: extension.cardBackground,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: extension.cardBorder),
        ),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: extension.sidebarBackground,
        surfaceTintColor: Colors.transparent,
        tileHeight: 52,
        indicatorColor: extension.panelMuted,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: extension.cardBackground,
        hintStyle: TextStyle(color: extension.mutedForeground),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: extension.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: extension.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.primary.withValues(alpha: 0.45);
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          ),
          textStyle: WidgetStatePropertyAll(
            base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return BorderSide(color: extension.lineStrong);
            }
            return BorderSide(color: extension.cardBorder);
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return extension.cardHover;
            }
            return extension.cardBackground;
          }),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          ),
          textStyle: WidgetStatePropertyAll(
            base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          ),
          textStyle: WidgetStatePropertyAll(
            base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return extension.cardBackground;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.onPrimary;
            }
            return colorScheme.onSurface;
          }),
          side: WidgetStatePropertyAll(BorderSide(color: extension.cardBorder)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ),
    );
  }
}
