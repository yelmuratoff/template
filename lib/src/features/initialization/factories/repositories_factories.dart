import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/core/data/data_source/auth/remote_data_source.dart';
import 'package:base_starter/src/features/auth/core/data/repositories/auth/auth_repository.dart';
import 'package:base_starter/src/features/initialization/containers/repositories.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';

/// Factory that creates an instance of [RepositoriesContainer].
class RepositoriesFactory extends AsyncFactory<RepositoriesContainer> {
  const RepositoriesFactory({
    required this.restClient,
  });

  final RestClientBase restClient;

  @override
  Future<RepositoriesContainer> create() async {
    // <--- Data sources initialization --->

    final authRemoteDS = AuthRemoteDataSource(
      restClient: restClient,
    );

    // <--- Repositories initialization --->

    final authRepository = AuthRepository(
      dataSource: authRemoteDS,
    );

    return RepositoriesContainer(
      authRepository: authRepository,
    );
  }
}
