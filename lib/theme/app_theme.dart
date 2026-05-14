import 'package:flutter/material.dart';

class AppTheme {
  static const _pastelViolet = Color(0xFFA78BFA);
  static const _pastelRose = Color(0xFFF7BFD9);
  static const _pastelPeach = Color(0xFFF8D5BC);
  static const _pastelMint = Color(0xFFBCEAD8);
  static const _pastelSky = Color(0xFFC5E7FF);
  static const _pastelButter = Color(0xFFF6E6B4);
  static const _beigeLight = Color(0xFFFBF3E8);

  static const _darkNight = Color(0xFF101728);
  static const _darkSurface = Color(0xFF17223B);
  static const _darkCard = Color(0xFF1E2D4A);
  static const _darkOutline = Color(0xFF31476B);

  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: _pastelViolet,
      onPrimary: Colors.white,
      secondary: _pastelRose,
      onSecondary: Color(0xFF3B2431),
      tertiary: _pastelMint,
      onTertiary: Color(0xFF173C2E),
      error: Color(0xFFB3261E),
      onError: Colors.white,
      surface: _beigeLight,
      onSurface: Color(0xFF352B42),
      primaryContainer: _pastelSky,
      onPrimaryContainer: Color(0xFF1D3452),
      secondaryContainer: _pastelPeach,
      onSecondaryContainer: Color(0xFF4A2D1E),
      tertiaryContainer: _pastelButter,
      onTertiaryContainer: Color(0xFF473E1B),
      outline: Color(0xFFD8C8E7),
      outlineVariant: Color(0xFFEDE0F6),
      shadow: Color(0x1A000000),
      scrim: Color(0x52000000),
      inverseSurface: Color(0xFF2E2A3A),
      onInverseSurface: Color(0xFFF8EEFF),
      inversePrimary: Color(0xFFD0C2FF),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFFFF9F3),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0x00000000),
        foregroundColor: Color(0xFF352B42),
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _pastelViolet,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.84),
        elevation: 0.8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _pastelSky.withValues(alpha: 0.45),
        selectedColor: _pastelRose.withValues(alpha: 0.35),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: const TextStyle(color: Color(0xFF352B42)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
    );
  }

  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFB7A1FF),
      onPrimary: Color(0xFF2E1D58),
      secondary: Color(0xFFFFC2DC),
      onSecondary: Color(0xFF4A2337),
      tertiary: Color(0xFFB4F1D7),
      onTertiary: Color(0xFF103B2C),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: _darkSurface,
      onSurface: Color(0xFFE8ECF8),
      primaryContainer: Color(0xFF40306F),
      onPrimaryContainer: Color(0xFFE7DEFF),
      secondaryContainer: Color(0xFF5D3348),
      onSecondaryContainer: Color(0xFFFFD9E8),
      tertiaryContainer: Color(0xFF295144),
      onTertiaryContainer: Color(0xFFCFFFEA),
      outline: _darkOutline,
      outlineVariant: Color(0xFF253653),
      shadow: Color(0x66000000),
      scrim: Color(0x99000000),
      inverseSurface: Color(0xFFE8ECF8),
      onInverseSurface: Color(0xFF17223B),
      inversePrimary: Color(0xFF6E59C6),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: _darkNight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0x00000000),
        foregroundColor: Color(0xFFE8ECF8),
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFB7A1FF),
        foregroundColor: Color(0xFF2E1D58),
      ),
      cardTheme: CardThemeData(
        color: _darkCard,
        elevation: 0.6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF263A5C),
        selectedColor: const Color(0xFF423661),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: const TextStyle(color: Color(0xFFE8ECF8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF22314E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
    );
  }
}
