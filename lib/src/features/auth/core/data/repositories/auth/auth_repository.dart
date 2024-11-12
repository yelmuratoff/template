import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:base_starter/src/features/auth/core/data/data_source/interface/auth/auth_data_source.dart';
import 'package:base_starter/src/features/auth/core/data/models/user.dart';
import 'package:base_starter/src/features/auth/core/domain/repositories/auth/remote_repository.dart';

final class AuthRepository implements IAuthRepository {
  const AuthRepository({
    required this.dataSource,
  });
  final IAuthDataSource dataSource;

  @override
  Future<UserDTO> getCurrentUser() async {
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
