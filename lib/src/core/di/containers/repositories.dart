import 'package:base_starter/src/features/auth/resource/domain/repositories/auth/remote_repository.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/user/local_repository.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/user/remote_repository.dart';

/// Repositories container
base class Repositories {
  // ignore: prefer_const_constructor_declarations
  Repositories();

  late final IAuthRepository authRepository;

  late final IRemoteUserRepository remoteUserRepository;
  late final ILocalUserRepository localUserRepository;
}
