import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_datasource.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_mode_codec.dart';
import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const modeKey = 'theme.mode';
  const seedKey = 'theme.seed_color';

  Future<(ThemeDataSourceLocal, SharedPreferences)> build(
    Map<String, Object> initial,
  ) async {
    SharedPreferences.setMockInitialValues(initial);
    final prefs = await SharedPreferences.getInstance();
    return (
      ThemeDataSourceLocal(
        sharedPreferences: prefs,
        codec: const ThemeModeCodec(),
      ),
      prefs,
    );
  }

  group('ThemeDataSourceLocal.getTheme', () {
    test('restores a persisted theme', () async {
      final (dataSource, _) = await build({});
      final theme = AppTheme(
        mode: ThemeMode.dark,
        seed: const Color(0xFF009688),
      );
      await dataSource.setTheme(theme);

      check(await dataSource.getTheme()).equals(theme);
    });

    test('resets and returns null when the stored mode is unknown', () async {
      final (dataSource, prefs) = await build({
        modeKey: 'ThemeMode.sepia',
        seedKey: 0xFF2196F3,
      });

      check(await dataSource.getTheme()).isNull();
      check(prefs.containsKey(modeKey)).isFalse();
      check(prefs.containsKey(seedKey)).isFalse();
    });

    test('resets and returns null when the stored seed has the wrong '
        'type', () async {
      final (dataSource, prefs) = await build({
        modeKey: 'ThemeMode.dark',
        seedKey: 'blue',
      });

      check(await dataSource.getTheme()).isNull();
      check(prefs.containsKey(seedKey)).isFalse();
    });
  });
}
