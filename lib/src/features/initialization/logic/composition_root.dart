import 'package:base_starter/flavors.dart';
import 'package:base_starter/src/common/constants/app_constants.dart';
import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/core/database/src/preferences/app_config_manager.dart';
import 'package:base_starter/src/core/database/src/preferences/secure_storage.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/core/rest_client/auth/auth_interceptor.dart';
import 'package:base_starter/src/core/rest_client/auth/token_storage.dart';
import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/core/rest_client/dio_rest_client/src/dio_client.dart';
import 'package:base_starter/src/core/rest_client/dio_rest_client/src/rest_client_dio.dart';
import 'package:base_starter/src/features/auth/data/data_source/auth/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/data_source/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/data/data_source/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/repositories/auth/auth_repository.dart';
import 'package:base_starter/src/features/auth/data/repositories/user/user_repository.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:base_starter/src/features/initialization/models/dependencies.dart';
import 'package:base_starter/src/features/initialization/models/repositories.dart';
import 'package:base_starter/src/features/settings/data/locale/locale_datasource.dart';
import 'package:base_starter/src/features/settings/data/locale/locale_repository.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_datasource.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_mode_codec.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_repository.dart';
import 'package:base_starter/src/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ispect/ispect.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The single composition root: every app-wide dependency is created and wired
/// here, exactly once, so the whole object graph lives in one place.
///
/// Composition is plain async functions rather than a factory hierarchy — the
/// graph is small and built linearly, so the indirection earned nothing.
final class CompositionRoot {
  const CompositionRoot();

  /// Builds the dependency graph and reports how long it took.
  Future<CompositionResult> compose() async {
    final stopwatch = clock.stopwatch()..start();
    ISpect.logger.info('🌀 Initializing dependencies...');

    final sharedPreferences = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    const secureStorage = FlutterSecureStorageWrapper(
      storage: FlutterSecureStorage(
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      ),
    );

    final appConfig = await _createConfig(sharedPreferences);
    final network = _createRestClient(secureStorage);
    final repositories = _createRepositories(
      restClient: network.restClient,
      sharedPreferences: sharedPreferences,
    );
    final settingsBloc = await _createSettingsBloc(sharedPreferences);

    final dependencies = DependenciesContainer(
      packageInfo: packageInfo,
      sharedPreferences: sharedPreferences,
      secureStorage: secureStorage,
      tokenStorage: network.tokenStorage,
      appConfig: appConfig,
      restClient: network.restClient,
      authBloc: AuthBloc(
        repository: repositories.authRepository,
        tokenStorage: network.tokenStorage,
      ),
      userBloc: UserBloc(userRepository: repositories.userRepository),
      settingsBloc: settingsBloc,
    );

    stopwatch.stop();
    return CompositionResult(
      dependencies: dependencies,
      repositories: repositories,
      millisecondsSpent: stopwatch.elapsedMilliseconds,
    );
  }

  Future<AppConfigManager> _createConfig(
    SharedPreferences sharedPreferences,
  ) async {
    final appConfig = AppConfigManager(sharedPreferences: sharedPreferences);

    final environment = sharedPreferences.getString(Preferences.environment);
    if (environment == null) {
      await sharedPreferences.setString(
        Preferences.environment,
        Flavor.prod.name,
      );
    }

    return appConfig;
  }

  /// Builds the networking stack exactly once: token storage, the bare
  /// refresh/retry [Dio], the authorized [Dio] and the [RestClientBase] on top.
  ({RestClientBase restClient, TokenStorage tokenStorage}) _createRestClient(
    SecureStorage secureStorage,
  ) {
    final tokenStorage = SecureTokenStorage(storage: secureStorage);

    final plainDio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: RestClientTimeouts.connect,
        sendTimeout: RestClientTimeouts.send,
        receiveTimeout: RestClientTimeouts.receive,
      ),
    );

    final dioClient = DioClient(
      baseUrl: AppConstants.baseUrl,
      interceptors: [
        AuthInterceptor(tokenStorage: tokenStorage, plainDio: plainDio),
      ],
    );

    final restClient = RestClientDio(
      baseUrl: AppConstants.baseUrl,
      dio: dioClient.dio,
    );

    return (restClient: restClient, tokenStorage: tokenStorage);
  }

  RepositoriesContainer _createRepositories({
    required RestClientBase restClient,
    required SharedPreferences sharedPreferences,
  }) {
    final authRepository = AuthRepository(
      dataSource: AuthRemoteDataSource(restClient: restClient),
    );

    final userRepository = UserRepository(
      remoteDataSource: UserRemoteDataSource(restClient: restClient),
      localDataSource: UserLocalDataSource(
        sharedPreferences: sharedPreferences,
      ),
    );

    return RepositoriesContainer(
      authRepository: authRepository,
      userRepository: userRepository,
    );
  }

  Future<SettingsBloc> _createSettingsBloc(
    SharedPreferences sharedPreferences,
  ) async {
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

    return SettingsBloc(
      localeRepository: localeRepository,
      themeRepository: themeRepository,
      initialState: IdleSettingsState(appTheme: theme, locale: locale),
    );
  }
}

/// Result of composition.
final class CompositionResult {
  const CompositionResult({
    required this.dependencies,
    required this.repositories,
    required this.millisecondsSpent,
  });

  /// The dependencies container.
  final DependenciesContainer dependencies;

  /// The repositories container.
  final RepositoriesContainer repositories;

  /// The number of milliseconds spent composing.
  final int millisecondsSpent;

  @override
  String toString() =>
      '$CompositionResult('
      '\ndependencies: $dependencies, '
      '\nrepositories: $repositories, '
      '\nmillisecondsSpent: $millisecondsSpent'
      ')';
}
