import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_cubit.dart';
import 'package:base_starter/src/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DependenciesContainer {
  const DependenciesContainer({
    required this.sharedPreferences,
    required this.packageInfo,
    required this.restClient,
    required this.authBloc,
    required this.userCubit,
    required this.settingsBloc,
  });

  // <--- External dependencies --->
  final SharedPreferences sharedPreferences;
  final PackageInfo packageInfo;

  // <--- Internal dependencies --->
  final AuthBloc authBloc;
  final UserCubit userCubit;
  final SettingsBloc settingsBloc;

  // <--- Network dependencies --->
  final RestClientBase restClient;

  @override
  String toString() => '''DependenciesContainer(
      sharedPreferences:$sharedPreferences,
      packageInfo: $packageInfo,
      restClient: $restClient,
      authBloc: $authBloc,
      userCubit: $userCubit,
      settingsBloc: $settingsBloc,
    )''';
}
