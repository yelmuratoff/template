import 'package:base_starter/src/features/auth/core/data/data_source/interface/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/core/data/models/user.dart';
import 'package:base_starter/src/features/auth/core/domain/repositories/user/local_repository.dart';

class LocalUserRepository implements ILocalUserRepository {
  const LocalUserRepository({
    required this.dataSource,
  });
  final ILocalUserDataSource dataSource;

  @override
  UserDTO? get() {
    try {
      final localUser = dataSource.get();
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
