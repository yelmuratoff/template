import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception_mapper.dart';
import 'package:base_starter/src/features/auth/data/data_source/interface/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/data/data_source/interface/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/domain/repositories/user/user_repository.dart';

final class UserRepository implements IUserRepository {
  const UserRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final IRemoteUserDataSource remoteDataSource;
  final ILocalUserDataSource localDataSource;

  @override
  UserDTO? getCachedUser() => localDataSource.get();

  @override
  Future<UserDTO?> getFreshUser() => mapRestErrors(() async {
    final fresh = await remoteDataSource.get();
    await localDataSource.write(user: fresh);
    return fresh;
  });

  @override
  Future<void> clearCache() => localDataSource.clear();
}
