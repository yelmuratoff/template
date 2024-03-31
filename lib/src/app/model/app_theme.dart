import 'package:base_starter/src/common/configs/style/themes/dark.dart';
import 'package:base_starter/src/common/configs/style/themes/light.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// An immutable class that holds properties needed
/// to build a [ThemeData] for the app.
@immutable
final class AppTheme with Diagnosticable {
  AppTheme({required this.mode, required this.seed})
      : darkTheme = getBaseDarkTheme(seed: seed),
        lightTheme = getBaseLightTheme(seed: seed);

  /// The type of theme to use.
  final ThemeMode mode;

  /// The seed color to generate the [ColorScheme] from.
  final Color seed;

  /// The dark [ThemeData] for this [AppTheme].
  final ThemeData darkTheme;

  /// The light [ThemeData] for this [AppTheme].
  final ThemeData lightTheme;

  /// The default [AppTheme].
  static final defaultTheme = AppTheme(
    mode: PlatformDispatcher.instance.platformBrightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light,
    seed: Colors.blue,
  );

  /// The [ThemeData] for this [AppTheme].
  /// This is computed based on the [mode].
  ThemeData computeTheme() => switch (mode) {
        ThemeMode.light => lightTheme,
        ThemeMode.dark => darkTheme,
        ThemeMode.system =>
          PlatformDispatcher.instance.platformBrightness == Brightness.dark
              ? darkTheme
              : lightTheme,
      };

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('seed', seed));
    properties.add(EnumProperty<ThemeMode>('type', mode));
    properties.add(DiagnosticsProperty<ThemeData>('lightTheme', lightTheme));
    properties.add(DiagnosticsProperty<ThemeData>('darkTheme', darkTheme));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppTheme &&
          runtimeType == other.runtimeType &&
          seed == other.seed &&
          mode == other.mode;

  @override
  int get hashCode => mode.hashCode ^ seed.hashCode;
}
