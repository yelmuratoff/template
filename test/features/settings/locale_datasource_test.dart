import 'package:base_starter/src/features/settings/data/locale/locale_datasource.dart';
import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const localeKey = 'settings.locale';

  Future<(LocaleDataSourceLocal, SharedPreferences)> build(
    Map<String, Object> initial,
  ) async {
    SharedPreferences.setMockInitialValues(initial);
    final prefs = await SharedPreferences.getInstance();
    return (LocaleDataSourceLocal(sharedPreferences: prefs), prefs);
  }

  group('LocaleDataSourceLocal.getLocale', () {
    test('restores a persisted locale', () async {
      final (dataSource, _) = await build({});
      await dataSource.setLocale(const Locale('kk'));

      check(await dataSource.getLocale()).equals(const Locale('kk'));
    });

    test('resets and returns null when the stored value has the wrong '
        'type', () async {
      final (dataSource, prefs) = await build({localeKey: 42});

      check(await dataSource.getLocale()).isNull();
      check(prefs.containsKey(localeKey)).isFalse();
    });
  });
}
