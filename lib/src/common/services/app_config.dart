import 'package:base_starter/src/feature/settings/data/configs/app_configs_data_source.dart';
import 'package:base_starter/src/feature/settings/data/configs/app_configs_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigsService {
  static AppConfigsService? _instance;
  late final AppConfigsRepository _appConfigsRepository;

  AppConfigsService._(this._appConfigsRepository);

  factory AppConfigsService.initialize(SharedPreferences sharedPreferences) {
    if (_instance == null) {
      final appConfigsDataSource =
          AppConfigsDataSourceLocal(sharedPreferences: sharedPreferences);
      final appConfigsRepository =
          AppConfigsRepositoryImpl(appConfigs: appConfigsDataSource);
      _instance = AppConfigsService._(appConfigsRepository);
    }
    return _instance!;
  }

  static AppConfigsService get instance {
    if (_instance == null) {
      throw Exception(
        'AppConfigsService not initialized. Call AppConfigsService.initialize() before use.',
      );
    }
    return _instance!;
  }

  static bool get isPerformanceTrackingEnabled =>
      instance._appConfigsRepository.isPerformanceTrackingEnabled();

  static Future<void> setPerformanceTracking({required bool value}) =>
      instance._appConfigsRepository.setPerformanceTracking(value: value);
}
