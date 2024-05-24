import 'package:base_starter/src/core/resource/domain/token/token_pair.dart';
import 'package:base_starter/src/features/auth/resource/domain/models/user_model.dart';

abstract interface class AuthRepository {
  Future<TokenPair?> login({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUser();
}
