import 'package:core/core.dart';
import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:base_starter/src/features/auth/data/data_source/interface/auth/auth_data_source.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';

final class AuthRemoteDataSource implements IAuthDataSource {
  const AuthRemoteDataSource({required this.restClient});
  final RestClientBase restClient;

  @override
  Future<UserDTO> getCurrentUser() async {
    final response = await restClient.get('api/v1/auth/profile');
    try {
      return UserDTO.fromMap(response);
    } on Object catch (e, st) {
      Error.throwWithStackTrace(
        ParseException(message: 'Failed to parse user profile.', cause: e),
        st,
      );
    }
  }

  @override
  Future<TokenPair?> login({
    required String email,
    required String password,
  }) async {
    final response = await restClient.post(
      'api/v1/auth/login',
      body: {'email': email, 'password': password},
    );
    try {
      return TokenPair.fromJson(response);
    } on Object catch (e, st) {
      Error.throwWithStackTrace(
        ParseException(message: 'Failed to parse login response.', cause: e),
        st,
      );
    }
  }
}
