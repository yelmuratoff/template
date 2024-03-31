import 'package:flutter/material.dart';

/// `ThemeExtension` template for custom colors.
///
/// For example purposes, it has all required fields from the default Material `ColorScheme`.
/// But you can add, rename and delete any fields your need.
///
/// ### Motivation
///
/// At the beginning, you may not know if your colors will fit into the Material `ColorScheme`,
/// but you still decided to start using `ColorScheme`, and only then realize that you need additional fields.
/// You will create `ThemeExtension` for only the additional fields, and as the result, you will have your colors
/// scattered between the `ColorScheme` and `ThemeExtension` with a few extra colors.
///
/// With this template, you can collect all fields in one place,
/// and don't worry about future changes to the Material or your design.
///
/// Or you can just quickly copy-paste this file and rename fields to your needs.
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.card,
    required this.divider,
    required this.text,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.error,
    required this.onError,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.border,
    required this.shadow,
    required this.success,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Color card;
  final Color divider;
  final Color text;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color error;
  final Color onError;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color border;
  final Color shadow;
  final Color success;
  final Color shimmerBase;
  final Color shimmerHighlight;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? card,
    Color? divider,
    Color? text,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? error,
    Color? onError,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? border,
    Color? shadow,
    Color? success,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) =>
      AppColorsExtension(
        card: card ?? this.card,
        divider: divider ?? this.divider,
        text: text ?? this.text,
        primary: primary ?? this.primary,
        onPrimary: onPrimary ?? this.onPrimary,
        secondary: secondary ?? this.secondary,
        onSecondary: onSecondary ?? this.onSecondary,
        error: error ?? this.error,
        onError: onError ?? this.onError,
        background: background ?? this.background,
        onBackground: onBackground ?? this.onBackground,
        surface: surface ?? this.surface,
        onSurface: onSurface ?? this.onSurface,
        border: border ?? this.border,
        shadow: shadow ?? this.shadow,
        success: success ?? this.success,
        shimmerBase: shimmerBase ?? this.shimmerBase,
        shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      );

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      card: Color.lerp(card, other.card, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      text: Color.lerp(text, other.text, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      success: Color.lerp(success, other.success, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }
}

/// Optional. If you also want to assign colors in the `ColorScheme`.
extension ColorSchemeBuilder on AppColorsExtension {
  ColorScheme toColorScheme(Brightness brightness) => ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onError,
        background: background,
        onBackground: onBackground,
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
