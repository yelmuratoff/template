import 'package:base_starter/src/common/utils/utils.dart';
import 'package:base_starter/src/core/theme/presentation/theme_colors.dart';
import 'package:base_starter/src/core/theme/presentation/theme_text_style.dart';
import 'package:flutter/material.dart';

final class LightThemeData {
  /// `getBaseLightTheme` is a function that
  /// returns a Light `ThemeData` for the app.
  static ThemeData getTheme({required Color seed}) {
    final baseTheme = ThemeData.from(
      colorScheme: ColorScheme.light(
        primary: seed,
        secondary: AppUtils.adjustColorBrightness(seed, 0.8),
      ),
    ).copyWith(
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
      ),
      dividerColor: Colors.grey[300],
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all<Color>(seed),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return seed.withOpacity(0.8);
          }
          return seed.withOpacity(0.3);
        }),
        trackOutlineColor: WidgetStateProperty.all<Color>(
          seed.withOpacity(0.1),
        ),
      ),
    );
    return baseTheme.copyWith(
      extensions: [
        ThemeColors(
          primary: baseTheme.colorScheme.primary,
          onPrimary: baseTheme.colorScheme.onPrimary,
          secondary: baseTheme.colorScheme.secondary,
          onSecondary: baseTheme.colorScheme.onSecondary,
          error: baseTheme.colorScheme.error,
          onError: baseTheme.colorScheme.onError,
          background: baseTheme.colorScheme.surface,
          onBackground: baseTheme.colorScheme.onSurface,
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
        textStyles,
      ],
    );
  }

  static ThemeTextStyle get textStyles => const ThemeTextStyle(
        error: TextStyle(
          color: Color.fromARGB(255, 239, 83, 80),
        ),
        s9w600: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
        s10w400: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
        s12w400: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        s12w500: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        s12w600: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        s12w700: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        s14w400: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        s14w500: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        s14w600: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        s14w700: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        s16w400: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        s16w500: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        s16w600: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        s16w700: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        s18w600: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        s20w400: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        s20w500: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        s20w600: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        s24w700: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        s36w400: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
      );
}
