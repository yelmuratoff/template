import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';
import 'package:base_starter/src/features/auth/domain/repositories/user/local_repository.dart';
import 'package:base_starter/src/features/auth/domain/repositories/user/remote_repository.dart';

final class RepositoriesContainer {
  const RepositoriesContainer({
    required this.authRepository,
    required this.remoteUserRepository,
    required this.localUserRepository,
  });

  // <--- Repositories --->

  final IAuthRepository authRepository;

  final IRemoteUserRepository remoteUserRepository;

  final ILocalUserRepository localUserRepository;

  @override
  String toString() => '''RepositoriesContainer(
      authRepository: $authRepository,
      remoteUserRepository: $remoteUserRepository,
      localUserRepository: $localUserRepository,
    );''';
}
