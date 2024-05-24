import 'package:base_starter/src/features/settings/data/configs/app_configs_data_source.dart';

abstract interface class AppConfigsRepository {
  /// Get performance tracking status
  bool get isPerformanceTrackingEnabled;

  /// Get is first run
  bool get isFirstRun;

  /// Set performance tracking status
  Future<void> setPerformanceTracking({required bool value});

  /// Set first run status
  Future<void> setFirstRun({required bool value});
}

final class AppConfigsRepositoryImpl implements AppConfigsRepository {
  const AppConfigsRepositoryImpl({required AppConfigsDataSource appConfigs})
      : _appConfigs = appConfigs;

  final AppConfigsDataSource _appConfigs;

  @override
  bool get isPerformanceTrackingEnabled =>
      _appConfigs.isPerformanceTrackingEnabled;

  @override
  bool get isFirstRun => _appConfigs.isFirstRun;

  @override
  Future<void> setPerformanceTracking({required bool value}) =>
      _appConfigs.setPerformanceTracking(value: value);

  @override
  Future<void> setFirstRun({required bool value}) =>
      _appConfigs.setFirstRun(value: value);
}
