import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/core/resource/data/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/core/resource/domain/token/token_pair.dart';
import 'package:base_starter/src/feature/auth/resource/domain/models/user_model.dart';
import 'package:base_starter/src/feature/auth/resource/domain/repositories/auth_repository.dart';

final class DataAuthRepository implements AuthRepository {
  final RestClientBase restClient;

  DataAuthRepository({
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
    } catch (e, st) {
      talker.handle(e, st);
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
    } catch (e, st) {
      talker.handle(e, st);
      rethrow;
    }
  }
}
