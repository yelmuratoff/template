import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';

abstract interface class IRemoteUserDataSource {
  Future<UserDTO?> get();
}
