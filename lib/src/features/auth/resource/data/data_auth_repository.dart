import 'package:base_starter/src/core/resource/data/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/core/resource/domain/token/token_pair.dart';
import 'package:base_starter/src/features/auth/resource/domain/models/user_model.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/auth_repository.dart';

final class AuthRepository implements IAuthRepository {
  final RestClientBase restClient;

  AuthRepository({
    required this.restClient,
  });

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await restClient.get("api/v1/auth/profile");
      if (response != null) {
        return UserModel.fromJson(response);
      } else {
        return null;
      }
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
      final response = await restClient.post(
        "api/v1/auth/login",
        body: {
          "email": email,
          "password": password,
        },
      );
      if (response != null) {
        return TokenPair.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
