import 'package:base_starter/src/features/auth/data/models/user.dart';

abstract interface class ILocalUserDataSource {
  UserDTO? get();
  Future<void> write({required UserDTO? user});
  Future<void> clear();
}
