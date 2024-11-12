import 'dart:async';

import 'package:base_starter/flavors.dart';
import 'package:base_starter/src/common/constants/app_constants.dart';
import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/core/database/src/preferences/app_config_manager.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/core/rest_client/dio_rest_client/src/rest_client_dio.dart';
import 'package:base_starter/src/features/auth/bloc/auth/auth_bloc.dart';
import 'package:base_starter/src/features/auth/bloc/user/user_cubit.dart';
import 'package:base_starter/src/features/auth/core/data/data_source/auth/remote_data_source.dart';
import 'package:base_starter/src/features/auth/core/data/data_source/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/core/data/data_source/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/core/data/repositories/auth/auth_repository.dart';
import 'package:base_starter/src/features/auth/core/data/repositories/user/local_repository.dart';
import 'package:base_starter/src/features/auth/core/data/repositories/user/remote_repository.dart';
import 'package:base_starter/src/features/initialization/models/initialization_progress.dart';
import 'package:base_starter/src/features/settings/bloc/settings_bloc.dart';
import 'package:base_starter/src/features/settings/core/data/locale/locale_datasource.dart';
import 'package:base_starter/src/features/settings/core/data/locale/locale_repository.dart';
import 'package:base_starter/src/features/settings/core/data/theme/theme_datasource.dart';
import 'package:base_starter/src/features/settings/core/data/theme/theme_mode_codec.dart';
import 'package:base_starter/src/features/settings/core/data/theme/theme_repository.dart';
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
      // TODO(Yelaman): Remove this line
      // UserManager.initialize(sharedPreferences);
    },
    'Environment': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final environment = sharedPreferences.getString(Preferences.environment);

      if (environment == null) {
        await sharedPreferences.setString(
          Preferences.environment,
          Flavor.prod.name,
        );
      }
      ISpect.good('Environment: $environment');
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
      final locale = await localeFuture ?? L10n.computeDefaultLocale;

      L10n.load(locale);

      final initialState = IdleSettingsState(appTheme: theme, locale: locale);

      final settingsBloc = SettingsBloc(
        localeRepository: localeRepository,
        themeRepository: themeRepository,
        initialState: initialState,
      );

      progress.dependencies.settingsBloc = settingsBloc;
    },
    'Rest Client': (progress) async {
      final restClient = RestClientDio(baseUrl: AppConstants.baseUrl);

      progress.dependencies.restClient = restClient;
    },
    'Auth resources': (progress) async {
      final dataSource =
          AuthRemoteDataSource(restClient: progress.dependencies.restClient);

      final authRepository = AuthRepository(dataSource: dataSource);

      final authBloc = AuthBloc(repository: authRepository);

      progress.dependencies.authBloc = authBloc;
      progress.repositories.authRepository = authRepository;
    },
    'User resources': (progress) async {
      final localDataSource = UserLocalDataSource(
        sharedPreferences: progress.dependencies.sharedPreferences,
      );

      final remoteDataSource = UserRemoteDataSource(
        restClient: progress.dependencies.restClient,
      );

      final remoteUserRepository = RemoteUserRepository(
        dataSource: remoteDataSource,
      );

      final localUserRepisotory = LocalUserRepository(
        dataSource: localDataSource,
      );

      final userCubit = UserCubit(
        remoteUserRepository: remoteUserRepository,
        localUserRepository: localUserRepisotory,
      );

      progress.repositories.remoteUserRepository = remoteUserRepository;
      progress.repositories.localUserRepository = localUserRepisotory;
      progress.dependencies.userCubit = userCubit;
    },
  };
}
