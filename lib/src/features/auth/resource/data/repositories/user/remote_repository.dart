import 'package:base_starter/src/features/auth/resource/domain/data_source/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/user/remote_repository.dart';

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
