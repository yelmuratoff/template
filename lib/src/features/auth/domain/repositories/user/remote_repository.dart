import 'package:base_starter/src/features/auth/data/models/user.dart';

abstract interface class IRemoteUserRepository {
  Future<UserDTO?> get();
}
