import 'dart:async';

import 'package:base_starter/flavors.dart';
import 'package:base_starter/src/common/configs/preferences/app_config_manager.dart';
import 'package:base_starter/src/common/constants/app_constants.dart';
import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/core/localization/generated/l10n.dart';
import 'package:base_starter/src/core/localization/localization.dart';
import 'package:base_starter/src/core/resource/data/dio_rest_client/src/rest_client_dio.dart';
import 'package:base_starter/src/features/auth/bloc/auth_bloc.dart';
import 'package:base_starter/src/features/auth/resource/data/data_auth_repository.dart';
import 'package:base_starter/src/features/auth/resource/data/user_manager.dart';
import 'package:base_starter/src/features/initialization/models/initialization_progress.dart';
import 'package:base_starter/src/features/settings/bloc/settings_bloc.dart';
import 'package:base_starter/src/features/settings/resource/data/locale/locale_datasource.dart';
import 'package:base_starter/src/features/settings/resource/data/locale/locale_repository.dart';
import 'package:base_starter/src/features/settings/resource/data/theme/theme_datasource.dart';
import 'package:base_starter/src/features/settings/resource/data/theme/theme_mode_codec.dart';
import 'package:base_starter/src/features/settings/resource/data/theme/theme_repository.dart';
import 'package:dio/dio.dart';
import 'package:ispect/ispect.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A function which represents a single initialization step.
typedef StepAction = FutureOr<void>? Function(InitializationProgress progress);

/// The initialization steps, which are executed in the order they are defined.
///
/// The `Dependencies` object is passed to each step, which allows the step to
/// set the dependency, and the next step to use it.
mixin InitializationSteps {
  /// The initialization steps,
  /// which are executed in the order they are defined.
  final initializationSteps = <String, StepAction>{
    'Package Info': (progress) async {
      final packageInfo = await PackageInfo.fromPlatform();
      progress.dependencies.packageInfo = packageInfo;
    },
    'Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      progress.dependencies.sharedPreferences = sharedPreferences;
    },
    'App Configs, User manager': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      AppConfigManager.initialize(sharedPreferences);
      UserManager.initialize(sharedPreferences);
    },
    'Environment': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final String? environment =
          sharedPreferences.getString(Preferences.environment);

      if (environment == null) {
        await sharedPreferences.setString(
          Preferences.environment,
          Flavor.prod.name,
        );
      }
      F.appFlavor = Flavor.from(environment);
      talkerWrapper.good('Environment: $environment');
    },
    'Settings BLoC': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final localeRepository = LocaleRepository(
        localeDataSource:
            LocaleDataSourceLocal(sharedPreferences: sharedPreferences),
      );

      final themeRepository = ThemeRepository(
        themeDataSource: ThemeDataSourceLocal(
          sharedPreferences: sharedPreferences,
          codec: const ThemeModeCodec(),
        ),
      );

      final localeFuture = localeRepository.getLocale();
      final theme = await themeRepository.getTheme();
      final locale = await localeFuture ?? Localization.computeDefaultLocale;

      await L10n.load(locale);

      final initialState = IdleSettingsState(appTheme: theme, locale: locale);

      final settingsBloc = SettingsBloc(
        localeRepository: localeRepository,
        themeRepository: themeRepository,
        initialState: initialState,
      );

      progress.dependencies.settingsBloc = settingsBloc;
    },
    'Rest Client': (progress) async {
      final dio = Dio();
      final restClient = RestClientDio(baseUrl: AppConstants.baseUrl, dio: dio);
      progress.dependencies.restClient = restClient;
    },
    'Auth Repository, BLoC': (progress) async {
      final authRepository =
          AuthRepository(restClient: progress.dependencies.restClient);

      final authBloc = AuthBloc(
        repository: authRepository,
      );

      progress.dependencies.authBloc = authBloc;
      progress.repositories.authRepository = authRepository;
    },
  };
}
