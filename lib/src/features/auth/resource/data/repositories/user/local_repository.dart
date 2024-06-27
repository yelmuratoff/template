import 'package:base_starter/src/features/auth/resource/domain/data_source/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/user/local_repository.dart';

class LocalUserRepository implements ILocalUserRepository {
  final ILocalUserDataSource dataSource;

  LocalUserRepository({
    required this.dataSource,
  });

  @override
  UserDTO? get() {
    try {
      final UserDTO? localUser = dataSource.get();
      return localUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void write({required UserDTO user}) {
    try {
      return dataSource.write(user: user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void clear() {
    try {
      return dataSource.clear();
    } catch (e) {
      rethrow;
    }
  }
}
