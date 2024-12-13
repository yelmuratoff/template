import 'package:base_starter/src/features/auth/data/models/user.dart';

abstract interface class IRemoteUserDataSource {
  Future<UserDTO?> get();
}
