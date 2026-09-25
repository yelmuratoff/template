import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:database/database.dart';

/// `AppConfigManager` - A class to manage the app configurations.
/// This class is used to manage app-level flags such as the first run.
final class AppConfigManager extends PreferencesDao {
  const AppConfigManager({required super.sharedPreferences});

  PreferencesEntry<bool> get _firstRun => boolEntry(Preferences.firstRun);

  bool get isFirstRun => _firstRun.read() ?? true;

  Future<void> setFirstRun({required bool value}) async {
    await _firstRun.set(value);
  }
}
