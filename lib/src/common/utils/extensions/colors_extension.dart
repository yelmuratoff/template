import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// Optional. If you also want to assign colors in the `ColorScheme`.
extension ColorSchemeBuilder on ThemeColors {
  ColorScheme toColorScheme(Brightness brightness) => ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onError,
        surface: surface,
        onSurface: onSurface,
      );
}

/// `ColorTranslation` extension for converting `Color` to `MaterialColor`.
extension ColorTranslation on Color {
  /// Converts `Color` to `MaterialColor`.
  MaterialColor toMaterialColor() {
    final swatch = {
      50: Color.fromRGBO(
        (r + (255 - r) * 0.95).toInt(),
        (g + (255 - g) * 0.95).toInt(),
        (b + (255 - b) * 0.95).toInt(),
        1,
      ),
      100: Color.fromRGBO(
        (r + (255 - r) * 0.9).toInt(),
        (g + (255 - g) * 0.9).toInt(),
        (b + (255 - b) * 0.9).toInt(),
        1,
      ),
      200: Color.fromRGBO(
        (r + (255 - r) * 0.8).toInt(),
        (g + (255 - g) * 0.8).toInt(),
        (b + (255 - b) * 0.8).toInt(),
        1,
      ),
      300: Color.fromRGBO(
        (r + (255 - r) * 0.7).toInt(),
        (g + (255 - g) * 0.7).toInt(),
        (b + (255 - b) * 0.7).toInt(),
        1,
      ),
      400: Color.fromRGBO(
        (r + (255 - r) * 0.6).toInt(),
        (g + (255 - g) * 0.6).toInt(),
        (b + (255 - b) * 0.6).toInt(),
        1,
      ),
      500: Color.fromRGBO(
        (r + (255 - r) * 0.5).toInt(),
        (g + (255 - g) * 0.5).toInt(),
        (b + (255 - b) * 0.5).toInt(),
        1,
      ),
      600: Color.fromRGBO(
        (r + (255 - r) * 0.4).toInt(),
        (g + (255 - g) * 0.4).toInt(),
        (b + (255 - b) * 0.4).toInt(),
        1,
      ),
      700: Color.fromRGBO(
        (r + (255 - r) * 0.3).toInt(),
        (g + (255 - g) * 0.3).toInt(),
        (b + (255 - b) * 0.3).toInt(),
        1,
      ),
      800: Color.fromRGBO(
        (r + (255 - r) * 0.2).toInt(),
        (g + (255 - g) * 0.2).toInt(),
        (b + (255 - b) * 0.2).toInt(),
        1,
      ),
      900: Color.fromRGBO(
        (r + (255 - r) * 0.1).toInt(),
        (g + (255 - g) * 0.1).toInt(),
        (b + (255 - b) * 0.1).toInt(),
        1,
      ),
    };
    // ignore: deprecated_member_use
    return MaterialColor(value, swatch);
  }
}
