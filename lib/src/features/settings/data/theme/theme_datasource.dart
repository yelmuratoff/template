import 'dart:async';
import 'dart:convert';

import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart' show Color, ThemeMode;
import 'package:ispect/ispect.dart';

/// `ThemeDataSource` is a data source that provides theme data.
/// This is used to set and get theme.
abstract interface class IThemeDataSource {
  /// Set theme
  Future<void> setTheme(AppTheme theme);

  /// Get current theme from cache
  Future<AppTheme?> getTheme();
}

final class ThemeDataSourceLocal extends PreferencesDao
    implements IThemeDataSource {
  const ThemeDataSourceLocal({
    required super.sharedPreferences,
    required this.codec,
  });

  /// Codec for [ThemeMode]
  final Codec<ThemeMode, String> codec;

  PreferencesEntry<int> get _seedColor => intEntry('theme.seed_color');

  PreferencesEntry<String> get _themeMode => stringEntry('theme.mode');

  @override
  Future<void> setTheme(AppTheme theme) async {
    await _seedColor.setIfNullRemove(theme.seed.toARGB32());
    await _themeMode.setIfNullRemove(codec.encode(theme.mode));
  }

  /// Returns the persisted theme, or `null` when none is stored.
  ///
  /// A corrupt entry is reset and reported as `null`, so it cannot fail
  /// startup.
  @override
  Future<AppTheme?> getTheme() async {
    try {
      final seedColor = _seedColor.read();

      final type = _themeMode.read();

      if (type == null || seedColor == null) return null;

      return AppTheme(seed: Color(seedColor), mode: codec.decode(type));
    } on Exception catch (e, st) {
      ISpect.logger.handle(
        exception: e,
        stackTrace: st,
        message: 'Stored theme is corrupt, resetting',
      );
      await _seedColor.remove();
      await _themeMode.remove();
      return null;
    }
  }
}
