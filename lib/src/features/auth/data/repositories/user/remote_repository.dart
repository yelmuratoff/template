import 'package:base_starter/src/features/auth/data/data_source/interface/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/domain/repositories/user/remote_repository.dart';

class RemoteUserRepository implements IRemoteUserRepository {
  const RemoteUserRepository({
    required this.dataSource,
  });
  final IRemoteUserDataSource dataSource;

  @override
  Future<UserDTO?> get() async {
    try {
      final remoteUser = await dataSource.get();
      return remoteUser;
    } catch (e) {
      rethrow;
    }
  }
}
