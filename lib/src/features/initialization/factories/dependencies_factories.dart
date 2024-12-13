import 'package:base_starter/flavors.dart';
import 'package:base_starter/src/common/constants/app_constants.dart';
import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/core/database/src/preferences/app_config_manager.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/core/rest_client/dio_rest_client/src/rest_client_dio.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_cubit.dart';
import 'package:base_starter/src/features/initialization/factories/repositories_factories.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:base_starter/src/features/initialization/models/dependencies.dart';
import 'package:base_starter/src/features/initialization/models/initialization_hook.dart';
import 'package:base_starter/src/features/settings/data/locale/locale_datasource.dart';
import 'package:base_starter/src/features/settings/data/locale/locale_repository.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_datasource.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_mode_codec.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_repository.dart';
import 'package:base_starter/src/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:ispect/ispect.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Factory that creates an instance of [DependenciesContainer].
class DependenciesFactory implements AsyncFactory<DependenciesContainer> {
  const DependenciesFactory({
    required this.hook,
  });

  @override
  final InitializationHook hook;

  @override
  Future<DependenciesContainer> create() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    await ConfigManagerFactory(
      hook: hook,
      sharedPreferences: sharedPreferences,
    ).create();

    final restClient = await RestClientFactory(
      hook: hook,
    ).create();

    final repositories = await RepositoriesFactory(
      restClient: restClient,
      sharedPreferences: sharedPreferences,
      hook: hook,
    ).create();

    final authBloc = AuthBloc(
      repository: repositories.authRepository,
    );

    final userCubit = UserCubit(
      remoteUserRepository: repositories.remoteUserRepository,
      localUserRepository: repositories.localUserRepository,
    );

    final settingsBloc = await SettingsBlocFactory(
      sharedPreferences: sharedPreferences,
      hook: hook,
    ).create();

    return DependenciesContainer(
      packageInfo: packageInfo,
      sharedPreferences: sharedPreferences,
      restClient: restClient,
      authBloc: authBloc,
      userCubit: userCubit,
      settingsBloc: settingsBloc,
    );
  }

  @override
  String get name => 'Dependencies';
}

/// A factory that creates an instance of [RestClientBase].
class RestClientFactory implements AsyncFactory<RestClientBase> {
  const RestClientFactory({
    required this.hook,
  });

  @override
  final InitializationHook hook;

  @override
  Future<RestClientBase> create() async {
    final restClient = RestClientDio(baseUrl: AppConstants.baseUrl);

    hook.onInitializing?.call(name);

    return restClient;
  }

  @override
  String get name => 'REST Client';
}

class ConfigManagerFactory implements AsyncFactory<void> {
  const ConfigManagerFactory({
    required this.hook,
    required this.sharedPreferences,
  });

  @override
  final InitializationHook hook;

  final SharedPreferences sharedPreferences;

  @override
  Future<void> create() async {
    AppConfigManager.initialize(sharedPreferences);

    final environment = sharedPreferences.getString(Preferences.environment);

    if (environment == null) {
      await sharedPreferences.setString(
        Preferences.environment,
        Flavor.prod.name,
      );
    }

    hook.onInitializing?.call(name);

    return;
  }

  @override
  String get name => 'Config Manager';
}

class SettingsBlocFactory implements AsyncFactory<SettingsBloc> {
  const SettingsBlocFactory({
    required this.hook,
    required this.sharedPreferences,
  });

  @override
  final InitializationHook hook;

  final SharedPreferences sharedPreferences;

  @override
  Future<SettingsBloc> create() async {
    final localeRepository = LocaleRepository(
      localeDataSource: LocaleDataSourceLocal(
        sharedPreferences: sharedPreferences,
      ),
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

    ISpect.info(
      '''Settings BLoC initialized: $settingsBloc with locale: $locale and theme: $theme''',
    );

    hook.onInitializing?.call(name);

    return settingsBloc;
  }

  @override
  String get name => 'Settings BLoC';
}
