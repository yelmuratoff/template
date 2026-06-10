import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception.dart';
import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception_mapper.dart';
import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:base_starter/src/features/auth/data/data_source/interface/auth/auth_data_source.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';
import 'package:ispect/ispect.dart';

final class AuthRepository implements IAuthRepository {
  const AuthRepository({required this.dataSource});
  final IAuthDataSource dataSource;

  @override
  Future<UserDTO> getCurrentUser() async {
    try {
      return await dataSource.getCurrentUser();
    } on RestClientException catch (e, st) {
      ISpect.logger.handle(
        exception: e,
        stackTrace: st,
        message: 'Get current user failed.',
      );
      Error.throwWithStackTrace(e.toAppException(), st);
    }
  }

  @override
  Future<TokenPair?> login({
    required String email,
    required String password,
  }) async {
    try {
      return await dataSource.login(email: email, password: password);
    } on RestClientException catch (e, st) {
      ISpect.logger.handle(
        exception: e,
        stackTrace: st,
        message: 'Login failed.',
      );
      Error.throwWithStackTrace(e.toAppException(), st);
    }
  }
}
