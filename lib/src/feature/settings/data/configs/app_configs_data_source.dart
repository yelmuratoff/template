import 'package:base_starter/src/common/utils/preferences_dao.dart';

abstract interface class AppConfigsDataSource {
  /// `Getters`

  bool isPerformanceTrackingEnabled();

  /// `Setters`

  Future<void> setPerformanceTracking({required bool value});
}

final class AppConfigsDataSourceLocal extends PreferencesDao
    implements AppConfigsDataSource {
  const AppConfigsDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<bool> get _performanceTracking =>
      boolEntry('app_configs.performance_tracking');

  @override
  bool isPerformanceTrackingEnabled() => _performanceTracking.read() ?? false;

  @override
  Future<void> setPerformanceTracking({required bool value}) async {
    await _performanceTracking.set(value);
  }
}
