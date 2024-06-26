import 'package:base_starter/src/core/resource/data/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/core/resource/domain/token/token_pair.dart';
import 'package:base_starter/src/features/auth/resource/domain/models/user_model.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/auth_repository.dart';
import 'package:ispect/ispect.dart';

final class AuthRepository implements IAuthRepository {
  final RestClientBase restClient;

  AuthRepository({
    required this.restClient,
  });

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await restClient.get("api/v1/auth/profile");
      return UserModel.fromJson(response);
    } catch (e, st) {
      talkerWrapper.handle(
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
        "api/v1/auth/login",
        body: {
          "email": email,
          "password": password,
        },
      );
      return TokenPair.fromJson(response);
    } catch (e, st) {
      talkerWrapper.handle(
        exception: e,
        stackTrace: st,
        message: 'Login failed.',
      );
      rethrow;
    }
  }
}
