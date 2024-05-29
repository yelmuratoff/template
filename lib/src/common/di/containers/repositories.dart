import 'package:base_starter/src/features/auth/resource/domain/repositories/auth_repository.dart';

/// Repositories container
base class Repositories {
  Repositories();

  /// Auth repository
  late final IAuthRepository authRepository;
}
