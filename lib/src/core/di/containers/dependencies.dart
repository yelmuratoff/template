import 'package:base_starter/src/core/resource/data/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/bloc/auth_bloc.dart';
import 'package:base_starter/src/features/settings/bloc/settings_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dependencies container
base class Dependencies {
  Dependencies();

  /// Shared preferences
  late final SharedPreferences sharedPreferences;

  late final RestClientBase restClient;

  /// Settings bloc
  late final SettingsBloc settingsBloc;

  /// Auth bloc
  late final AuthBloc authBloc;

  /// Package info
  late final PackageInfo packageInfo;
}
