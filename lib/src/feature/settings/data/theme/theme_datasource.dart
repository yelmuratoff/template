import 'dart:async';
import 'dart:convert';

import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:base_starter/src/common/utils/preferences_dao.dart';
import 'package:flutter/material.dart' show ThemeMode, Color;

/// `ThemeDataSource` is a data source that provides theme data.
/// This is used to set and get theme.
abstract interface class ThemeDataSource {
  /// Set theme
  Future<void> setTheme(AppTheme theme);

  /// Get current theme from cache
  Future<AppTheme?> getTheme();
}

final class ThemeDataSourceLocal extends PreferencesDao
    implements ThemeDataSource {
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
    await _seedColor.setIfNullRemove(theme.seed.value);
    await _themeMode.setIfNullRemove(codec.encode(theme.mode));
  }

  @override
  Future<AppTheme?> getTheme() async {
    final seedColor = _seedColor.read();

    final type = _themeMode.read();

    if (type == null || seedColor == null) return null;

    return AppTheme(seed: Color(seedColor), mode: codec.decode(type));
  }
}
