import 'package:base_starter/src/core/resource/domain/token/token_pair.dart';
import 'package:base_starter/src/features/auth/resource/domain/data_source/auth/auth_data_source.dart';
import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/auth/remote_repository.dart';

final class AuthRepository implements IAuthRepository {

  const AuthRepository({
    required this.dataSource,
  });
  final IAuthDataSource dataSource;

  @override
  Future<UserDTO?> getCurrentUser() async {
    try {
      final user = await dataSource.getCurrentUser();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TokenPair?> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokenPair = await dataSource.login(
        email: email,
        password: password,
      );
      return tokenPair;
    } catch (e) {
      rethrow;
    }
  }
}
