import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ThemeDataX on ThemeData {
  /// Usage
  /// ```dart
  ///  context.theme.when(
  ///   dark: () => AppDarkColors.main,
  ///   light: () => AppLightColors.main,
  ///  )
  /// ```
  T when<T>({
    required T Function() light,
    required T Function() dark,
  }) {
    switch (brightness) {
      case Brightness.light:
        return light();
      case Brightness.dark:
        return dark();
    }
  }

  T whenByValue<T extends Object?>({
    required T light,
    required T dark,
  }) {
    switch (brightness) {
      case Brightness.light:
        return light;
      case Brightness.dark:
        return dark;
    }
  }

  T maybeWhenByValue<T extends Object?>({
    required T orElse,
    T? light,
    T? dark,
  }) =>
      whenByValue<T>(
        light: light ?? orElse,
        dark: dark ?? orElse,
      );

  void setSystemUiOverlayStyle() {
    final style = whenByValue(
      light: SystemUiOverlayStyle.dark,
      dark: SystemUiOverlayStyle.light,
    );

    SystemChrome.setSystemUIOverlayStyle(style);
  }

  SystemUiOverlayStyle get systemUiOverlayStyle => when(
        light: () => SystemUiOverlayStyle.dark,
        dark: () => SystemUiOverlayStyle.light,
      );

  bool get isDark => brightness == Brightness.dark;
}
