import 'package:base_starter/src/features/auth/core/domain/repositories/auth/remote_repository.dart';

final class RepositoriesContainer {
  const RepositoriesContainer({
    required this.authRepository,
  });

  // <--- Repositories --->

  final IAuthRepository authRepository;

  @override
  String toString() => '''RepositoriesContainer(
      authRepository: $authRepository,
    );''';
}
