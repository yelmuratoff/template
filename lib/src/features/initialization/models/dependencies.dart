import 'package:base_starter/src/core/database/src/preferences/app_config_manager.dart';
import 'package:base_starter/src/core/database/src/preferences/secure_storage.dart';
import 'package:base_starter/src/core/rest_client/auth/token_storage.dart';
import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:base_starter/src/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DependenciesContainer {
  const DependenciesContainer({
    required this.sharedPreferences,
    required this.secureStorage,
    required this.tokenStorage,
    required this.appConfig,
    required this.packageInfo,
    required this.restClient,
    required this.authBloc,
    required this.userBloc,
    required this.settingsBloc,
  });

  // <--- External dependencies --->
  final SharedPreferences sharedPreferences;
  final SecureStorage secureStorage;
  final TokenStorage tokenStorage;
  final AppConfigManager appConfig;
  final PackageInfo packageInfo;

  // <--- Internal dependencies --->
  final AuthBloc authBloc;
  final UserBloc userBloc;
  final SettingsBloc settingsBloc;

  // <--- Network dependencies --->
  final RestClientBase restClient;

  @override
  String toString() =>
      '''DependenciesContainer(
      sharedPreferences:$sharedPreferences,
      secureStorage: $secureStorage,
      appConfig: $appConfig,
      packageInfo: $packageInfo,
      restClient: $restClient,
      authBloc: $authBloc,
      userBloc: $userBloc,
      settingsBloc: $settingsBloc,
    )''';
}
