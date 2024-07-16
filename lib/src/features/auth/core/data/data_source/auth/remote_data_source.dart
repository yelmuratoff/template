import 'package:base_starter/src/core/data/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/core/domain/token/token_pair.dart';
import 'package:base_starter/src/features/auth/core/data/data_source/interface/auth/auth_data_source.dart';
import 'package:base_starter/src/features/auth/core/data/models/user.dart';
import 'package:ispect/ispect.dart';

final class AuthRemoteDataSource implements IAuthDataSource {

  const AuthRemoteDataSource({
    required this.restClient,
  });
  final RestClientBase restClient;

  @override
  Future<UserDTO?> getCurrentUser() async {
    try {
      final response = await restClient.get('api/v1/auth/profile');
      return UserDTO.fromJson(response);
    } catch (e, st) {
      ISpectTalker.handle(
        exception: e,
        stackTrace: st,
        message: 'Get current user failed.',
      );
      rethrow;
    }
  }

  @override
  Future<TokenPair?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await restClient.post(
        'api/v1/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );
      return TokenPair.fromJson(response);
    } catch (e, st) {
      ISpectTalker.handle(
        exception: e,
        stackTrace: st,
        message: 'Login failed.',
      );
      rethrow;
    }
  }
}
