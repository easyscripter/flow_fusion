import 'package:flow_fusion/ui/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

final class AppTheme {
  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF5B7C77),
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF18181B),
      onPrimary: const Color(0xFFFAFAFA),
      secondary: const Color(0xFFF4F4F5),
      onSecondary: const Color(0xFF18181B),
      surface: const Color(0xFFFAFAFA),
      onSurface: const Color(0xFF18181B),
      onSurfaceVariant: const Color(0xFF71717A),
      outline: const Color(0xFFE4E4E7),
      outlineVariant: const Color(0xFFF0F0F2),
      error: const Color(0xFFB91C1C),
      onError: const Color(0xFFFAFAFA),
      inverseSurface: const Color(0xFF18181B),
      onInverseSurface: const Color(0xFFFAFAFA),
    ),
    extension: const FlowFusionColors(
      pageBackground: Color(0xFFFAFAFA),
      sidebarBackground: Color(0xFFF7F7F8),
      sidebarBorder: Color(0xFFE4E4E7),
      cardBackground: Color(0xFFFFFFFF),
      cardBorder: Color(0xFFE4E4E7),
      cardHover: Color(0xFFF4F4F5),
      accentBackground: Color(0xFFF4F4F5),
      accentForeground: Color(0xFF18181B),
      mutedForeground: Color(0xFF71717A),
      success: Color(0xFF166534),
      warning: Color(0xFFA16207),
    ),
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8CA7A2),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFFF4F4F5),
      onPrimary: const Color(0xFF09090B),
      secondary: const Color(0xFF18181B),
      onSecondary: const Color(0xFFF4F4F5),
      surface: const Color(0xFF09090B),
      onSurface: const Color(0xFFFAFAFA),
      onSurfaceVariant: const Color(0xFFA1A1AA),
      outline: const Color(0xFF27272A),
      outlineVariant: const Color(0xFF18181B),
      error: const Color(0xFFEF4444),
      onError: const Color(0xFFFAFAFA),
      inverseSurface: const Color(0xFFFAFAFA),
      onInverseSurface: const Color(0xFF09090B),
    ),
    extension: const FlowFusionColors(
      pageBackground: Color(0xFF09090B),
      sidebarBackground: Color(0xFF09090B),
      sidebarBorder: Color(0xFF27272A),
      cardBackground: Color(0xFF111113),
      cardBorder: Color(0xFF27272A),
      cardHover: Color(0xFF18181B),
      accentBackground: Color(0xFF18181B),
      accentForeground: Color(0xFFFAFAFA),
      mutedForeground: Color(0xFFA1A1AA),
      success: Color(0xFF4ADE80),
      warning: Color(0xFFFACC15),
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
      scaffoldBackgroundColor: extension.pageBackground,
      canvasColor: extension.pageBackground,
      dividerColor: colorScheme.outlineVariant,
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
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: extension.cardBorder),
        ),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: extension.sidebarBackground,
        surfaceTintColor: Colors.transparent,
        tileHeight: 52,
        indicatorColor: extension.accentBackground,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: extension.cardBackground,
        hintStyle: TextStyle(color: extension.mutedForeground),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: extension.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: extension.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              return BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.32));
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ),
    );
  }
}
