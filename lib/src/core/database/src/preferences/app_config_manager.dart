import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/core/database/src/preferences/preferences_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// `AppConfigManager` - A class to manage the app configurations.
/// This class is used to manage the app configurations like performance
/// tracking, first run, etc.
final class AppConfigManager extends PreferencesDao {
  AppConfigManager._(SharedPreferences sharedPreferences)
      : super(sharedPreferences: sharedPreferences);

  factory AppConfigManager.initialize(SharedPreferences sharedPreferences) {
    _instance ??= AppConfigManager._(sharedPreferences);
    return _instance!;
  }
  static AppConfigManager? _instance;

  static AppConfigManager get instance {
    if (_instance == null) {
      throw Exception(
        'AppConfigManager not initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  PreferencesEntry<bool> get _performanceTracking =>
      boolEntry(Preferences.performanceTracking);
  PreferencesEntry<bool> get _firstRun => boolEntry(Preferences.firstRun);

  bool get isPerformanceTrackingEnabled => _performanceTracking.read() ?? false;
  bool get isFirstRun => _firstRun.read() ?? true;

  Future<void> setPerformanceTracking({
    required bool value,
  }) async {
    await _performanceTracking.set(value);
  }

  Future<void> setFirstRun({
    required bool value,
  }) async {
    await _firstRun.set(value);
  }
}
