import 'package:base_starter/src/app/router/navigation_manager.dart';
import 'package:base_starter/src/common/constants/app_constants.dart';
import 'package:base_starter/src/core/database/database.dart';
import 'package:base_starter/src/core/database/src/preferences/app_config_manager.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/auth/data/data_source/auth/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/data_source/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/data/data_source/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/repositories/auth/auth_repository.dart';
import 'package:base_starter/src/features/auth/data/repositories/user/user_repository.dart';
import 'package:base_starter/src/features/auth/logic/session_restore.dart';
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
import 'package:database/database.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ispect/ispect.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rest_client/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The single composition root: every app-wide dependency is created and wired
/// here, exactly once, so the whole object graph lives in one place.
///
/// Composition is plain async functions rather than a factory hierarchy — the
/// graph is small and built linearly, so the indirection earned nothing.
final class CompositionRoot {
  const CompositionRoot();

  /// Builds the dependency graph and reports how long it took.
  ///
  /// Throws a [StateError] when `API_URL` was not compiled in.
  Future<CompositionResult> compose() async {
    if (AppConstants.baseUrl.isEmpty) {
      throw StateError(
        'API_URL is empty: run with '
        '--dart-define-from-file=env/config_<flavor>.json',
      );
    }
    final stopwatch = clock.stopwatch()..start();
    ISpect.logger.info('🌀 Initializing dependencies...');

    final sharedPreferences = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    const secureStorage = FlutterSecureStorageWrapper(
      storage: FlutterSecureStorage(
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      ),
    );

    final appConfig = AppConfigManager(sharedPreferences: sharedPreferences);

    if (appConfig.isFirstRun) {
      await secureStorage.deleteAll();
      await appConfig.setFirstRun(value: false);
    }

    final appDatabase = AppDatabase();

    final network = _createRestClient(secureStorage);
    final repositories = _createRepositories(
      restClient: network.restClient,
      sharedPreferences: sharedPreferences,
    );
    final settingsBloc = await _createSettingsBloc(sharedPreferences);

    final authBloc = AuthBloc(
      repository: repositories.authRepository,
      tokenStorage: network.tokenStorage,
    );
    final userBloc = UserBloc(userRepository: repositories.userRepository);
    final navigationManager = NavigationManager(
      authBloc: authBloc,
      userBloc: userBloc,
    );

    await restoreSession(authBloc);

    final dependencies = DependenciesContainer(
      packageInfo: packageInfo,
      sharedPreferences: sharedPreferences,
      secureStorage: secureStorage,
      tokenStorage: network.tokenStorage,
      appConfig: appConfig,
      appDatabase: appDatabase,
      restClient: network.restClient,
      authBloc: authBloc,
      userBloc: userBloc,
      settingsBloc: settingsBloc,
      navigationManager: navigationManager,
    );

    stopwatch.stop();
    return CompositionResult(
      dependencies: dependencies,
      repositories: repositories,
      millisecondsSpent: stopwatch.elapsedMilliseconds,
    );
  }

  /// Builds the networking stack exactly once: token storage, the bare
  /// refresh/retry [Dio], the authorized [Dio] and the [RestClientBase] on top.
  ({RestClientBase restClient, TokenStorage tokenStorage}) _createRestClient(
    SecureStorage secureStorage,
  ) {
    final tokenStorage = SecureTokenStorage(storage: secureStorage);

    final plainDio = Dio(
      BaseOptions(
        // ignore: avoid_redundant_argument_values
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
