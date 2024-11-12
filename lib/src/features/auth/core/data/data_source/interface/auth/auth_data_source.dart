import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:base_starter/src/features/auth/core/data/models/user.dart';

abstract interface class IAuthDataSource {
  Future<TokenPair?> login({
    required String email,
    required String password,
  });
  Future<UserDTO> getCurrentUser();
}
