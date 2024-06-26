import 'package:base_starter/src/core/resource/domain/token/token_pair.dart';
import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';

abstract interface class IAuthRepository {
  Future<TokenPair?> login({
    required String email,
    required String password,
  });
  Future<UserDTO?> getCurrentUser();
}
