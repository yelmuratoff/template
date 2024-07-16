import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/bloc/auth/auth_bloc.dart';
import 'package:base_starter/src/features/auth/bloc/user/user_cubit.dart';
import 'package:base_starter/src/features/settings/bloc/settings_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dependencies container
base class Dependencies {
  // ignore: prefer_const_constructor_declarations
  Dependencies();

  late final SharedPreferences sharedPreferences;

  late final RestClientBase restClient;

  late final SettingsBloc settingsBloc;

  late final AuthBloc authBloc;

  late final UserCubit userCubit;

  late final PackageInfo packageInfo;
}
