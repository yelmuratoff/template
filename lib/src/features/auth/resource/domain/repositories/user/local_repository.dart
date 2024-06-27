import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';

abstract interface class ILocalUserRepository {
  UserDTO? get();
  void write({required UserDTO user});
  void clear();
}
