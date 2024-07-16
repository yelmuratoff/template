import 'package:base_starter/src/features/auth/core/data/models/user.dart';

abstract interface class ILocalUserDataSource {
  UserDTO? get();
  void write({
    required UserDTO? user,
  });
  void clear();
}
