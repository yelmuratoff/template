import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';

abstract interface class ILocalUserDataSource {
  UserDTO? get();
  void write({
    required UserDTO? user,
  });
  void clear();
}
