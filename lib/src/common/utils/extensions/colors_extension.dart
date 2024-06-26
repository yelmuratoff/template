import 'package:base_starter/src/core/theme/presentation/theme_colors.dart';
import 'package:flutter/material.dart';

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
        (red + (255 - red) * 0.95).toInt(),
        (green + (255 - green) * 0.95).toInt(),
        (blue + (255 - blue) * 0.95).toInt(),
        1,
      ),
      100: Color.fromRGBO(
        (red + (255 - red) * 0.9).toInt(),
        (green + (255 - green) * 0.9).toInt(),
        (blue + (255 - blue) * 0.9).toInt(),
        1,
      ),
      200: Color.fromRGBO(
        (red + (255 - red) * 0.8).toInt(),
        (green + (255 - green) * 0.8).toInt(),
        (blue + (255 - blue) * 0.8).toInt(),
        1,
      ),
      300: Color.fromRGBO(
        (red + (255 - red) * 0.7).toInt(),
        (green + (255 - green) * 0.7).toInt(),
        (blue + (255 - blue) * 0.7).toInt(),
        1,
      ),
      400: Color.fromRGBO(
        (red + (255 - red) * 0.6).toInt(),
        (green + (255 - green) * 0.6).toInt(),
        (blue + (255 - blue) * 0.6).toInt(),
        1,
      ),
      500: Color.fromRGBO(
        (red + (255 - red) * 0.5).toInt(),
        (green + (255 - green) * 0.5).toInt(),
        (blue + (255 - blue) * 0.5).toInt(),
        1,
      ),
      600: Color.fromRGBO(
        (red + (255 - red) * 0.4).toInt(),
        (green + (255 - green) * 0.4).toInt(),
        (blue + (255 - blue) * 0.4).toInt(),
        1,
      ),
      700: Color.fromRGBO(
        (red + (255 - red) * 0.3).toInt(),
        (green + (255 - green) * 0.3).toInt(),
        (blue + (255 - blue) * 0.3).toInt(),
        1,
      ),
      800: Color.fromRGBO(
        (red + (255 - red) * 0.2).toInt(),
        (green + (255 - green) * 0.2).toInt(),
        (blue + (255 - blue) * 0.2).toInt(),
        1,
      ),
      900: Color.fromRGBO(
        (red + (255 - red) * 0.1).toInt(),
        (green + (255 - green) * 0.1).toInt(),
        (blue + (255 - blue) * 0.1).toInt(),
        1,
      ),
    };
    return MaterialColor(value, swatch);
  }
}
