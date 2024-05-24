import 'package:base_starter/src/common/configs/constants.dart';
import 'package:base_starter/src/common/utils/preferences_dao.dart';

abstract interface class AppConfigsDataSource {
  /// `Getters`

  bool get isPerformanceTrackingEnabled;
  bool get isFirstRun;

  /// `Setters`

  Future<void> setPerformanceTracking({required bool value});
  Future<void> setFirstRun({required bool value});
}

final class AppConfigsDataSourceLocal extends PreferencesDao
    implements AppConfigsDataSource {
  const AppConfigsDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<bool> get _performanceTracking =>
      boolEntry(Preferences.performanceTracking);

  PreferencesEntry<bool> get _firstRun => boolEntry(Preferences.firstRun);

  @override
  bool get isPerformanceTrackingEnabled => _performanceTracking.read() ?? false;

  @override
  bool get isFirstRun => _firstRun.read() ?? true;

  @override
  Future<void> setPerformanceTracking({required bool value}) async {
    await _performanceTracking.set(value);
  }

  @override
  Future<void> setFirstRun({required bool value}) async {
    await _firstRun.set(value);
  }
}
