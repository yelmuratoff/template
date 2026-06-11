import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';
import 'package:base_starter/src/features/auth/domain/repositories/user/user_repository.dart';

final class RepositoriesContainer {
  const RepositoriesContainer({
    required this.authRepository,
    required this.userRepository,
  });

  // <--- Repositories --->

  final IAuthRepository authRepository;

  final IUserRepository userRepository;

  @override
  String toString() =>
      '''RepositoriesContainer(
      authRepository: $authRepository,
      userRepository: $userRepository,
    );''';
}
