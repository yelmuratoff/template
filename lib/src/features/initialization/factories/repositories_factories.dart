import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/data/data_source/auth/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/data_source/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/data/data_source/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/repositories/auth/auth_repository.dart';
import 'package:base_starter/src/features/auth/data/repositories/user/local_repository.dart';
import 'package:base_starter/src/features/auth/data/repositories/user/remote_repository.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:base_starter/src/features/initialization/models/initialization_hook.dart';
import 'package:base_starter/src/features/initialization/models/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Factory that creates an instance of [RepositoriesContainer].
class RepositoriesFactory implements AsyncFactory<RepositoriesContainer> {
  const RepositoriesFactory({
    required this.hook,
    required this.restClient,
    required this.sharedPreferences,
  });

  @override
  final InitializationHook hook;
  final RestClientBase restClient;
  final SharedPreferences sharedPreferences;

  @override
  Future<RepositoriesContainer> create() async {
    // <--- Data sources initialization --->

    final authRemoteDS = AuthRemoteDataSource(
      restClient: restClient,
    );

    final userRemoteDS = UserRemoteDataSource(
      restClient: restClient,
    );

    final userLocalDS = UserLocalDataSource(
      sharedPreferences: sharedPreferences,
    );

    // <--- Repositories initialization --->

    final authRepository = AuthRepository(
      dataSource: authRemoteDS,
    );

    final userRemoteRepository = RemoteUserRepository(
      dataSource: userRemoteDS,
    );

    final userLocalRepository = LocalUserRepository(
      dataSource: userLocalDS,
    );

    hook.onInitializing?.call(name);

    return RepositoriesContainer(
      authRepository: authRepository,
      remoteUserRepository: userRemoteRepository,
      localUserRepository: userLocalRepository,
    );
  }

  @override
  String get name => 'Repositories';
}
