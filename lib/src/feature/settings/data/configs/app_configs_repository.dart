import 'package:base_starter/src/feature/settings/data/configs/app_configs_data_source.dart';

abstract interface class AppConfigsRepository {
  /// Get performance tracking status
  bool isPerformanceTrackingEnabled();

  /// Set performance tracking status
  Future<void> setPerformanceTracking({required bool value});
}

final class AppConfigsRepositoryImpl implements AppConfigsRepository {
  const AppConfigsRepositoryImpl({required AppConfigsDataSource appConfigs})
      : _appConfigs = appConfigs;

  final AppConfigsDataSource _appConfigs;

  @override
  bool isPerformanceTrackingEnabled() =>
      _appConfigs.isPerformanceTrackingEnabled();

  @override
  Future<void> setPerformanceTracking({required bool value}) =>
      _appConfigs.setPerformanceTracking(value: value);
}
