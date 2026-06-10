import 'package:base_starter/src/app/router/navigation_manager.dart';
import 'package:base_starter/src/core/database/src/preferences/app_config_manager.dart';
import 'package:database/database.dart';
import 'package:rest_client/rest_client.dart';
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
    required this.navigationManager,
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
  final NavigationManager navigationManager;

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
      navigationManager: $navigationManager,
    )''';
}
