import 'package:rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';

abstract interface class IAuthDataSource {
  Future<TokenPair?> login({required String email, required String password});
  Future<UserDTO> getCurrentUser();
}
