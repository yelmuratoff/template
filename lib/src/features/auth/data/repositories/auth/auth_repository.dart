import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception_mapper.dart';
import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:base_starter/src/features/auth/data/data_source/interface/auth/auth_data_source.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';

final class AuthRepository implements IAuthRepository {
  const AuthRepository({required this.dataSource});
  final IAuthDataSource dataSource;

  @override
  Future<UserDTO> getCurrentUser() => mapRestErrors(dataSource.getCurrentUser);

  @override
  Future<TokenPair?> login({required String email, required String password}) =>
      mapRestErrors(() => dataSource.login(email: email, password: password));
}
