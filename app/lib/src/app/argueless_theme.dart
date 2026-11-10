import 'package:flutter/material.dart';

/// A bright, friendly look: violet on warm cream, with rounded cards.
class ArguelessTheme {
  const ArguelessTheme._();

  static const violet = Color(0xFF5B4BDB);
  static const cream = Color(0xFFFFFBF5);
  static const sunshine = Color(0xFFFFC44D);

  /// The one left and right margin on every screen.
  static const gutter = 16.0;

  static const radius = 20.0;

  static ThemeData light() => _themed(
    ColorScheme.fromSeed(
      seedColor: violet,
      primary: violet,
      tertiary: const Color(0xFFB35C00),
      surface: cream,
    ),
  );

  static ThemeData dark() => _themed(
    ColorScheme.fromSeed(seedColor: violet, brightness: Brightness.dark),
  );

  static ThemeData _themed(ColorScheme scheme) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      cardTheme: CardThemeData(
        shape: shape,
        elevation: 0,
        color: scheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius / 2),
          borderSide: BorderSide.none,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
