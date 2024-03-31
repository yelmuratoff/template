import 'package:base_starter/src/common/utils/extensions/colors_extension.dart';
import 'package:flutter/material.dart';

/// `getBaseLightTheme` is a function that returns a Light `ThemeData` for the app.
ThemeData getBaseLightTheme({required Color seed}) {
  final ThemeData baseTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
    ),
  ).copyWith(
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
    ),
  );
  return baseTheme.copyWith(
    extensions: [
      AppColorsExtension(
        primary: baseTheme.colorScheme.primary,
        onPrimary: baseTheme.colorScheme.onPrimary,
        secondary: baseTheme.colorScheme.secondary,
        onSecondary: baseTheme.colorScheme.onSecondary,
        error: baseTheme.colorScheme.error,
        onError: baseTheme.colorScheme.onError,
        background: baseTheme.colorScheme.background,
        onBackground: baseTheme.colorScheme.onBackground,
        surface: baseTheme.colorScheme.surface,
        onSurface: baseTheme.colorScheme.onSurface,
        divider: Colors.grey[300]!,
        text: Colors.black,
        border: Colors.grey[400]!,
        card: Colors.grey.withOpacity(0.05),
        shadow: const Color.fromARGB(255, 211, 211, 211),
        success: const Color(0xff4CAF50),
        shimmerBase: const Color(0xffB4B4B4),
        shimmerHighlight: Colors.white,
      ),
    ],
  );
}
