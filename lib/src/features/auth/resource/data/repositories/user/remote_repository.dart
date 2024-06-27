import 'package:base_starter/src/features/auth/resource/domain/data_source/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/user/remote_repository.dart';

class RemoteUserRepository implements IRemoteUserRepository {
  final IRemoteUserDataSource dataSource;

  RemoteUserRepository({
    required this.dataSource,
  });

  @override
  Future<UserDTO?> get() async {
    try {
      final UserDTO? remoteUser = await dataSource.get();
      return remoteUser;
    } catch (e) {
      rethrow;
    }
  }
}
