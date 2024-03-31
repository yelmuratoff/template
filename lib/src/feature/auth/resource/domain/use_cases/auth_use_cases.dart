import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/core/resource/domain/token/token_pair.dart';
import 'package:base_starter/src/feature/auth/resource/domain/models/user_model.dart';
import 'package:base_starter/src/feature/auth/resource/domain/repositories/auth_repository.dart';

final class AuthUseCases {
  final AuthRepository _authRepository;

  AuthUseCases({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<TokenPair?> login({
    required String email,
    required String password,
  }) async {
    try {
      return _authRepository.login(email: email, password: password);
    } catch (e, st) {
      talker.handle(e, st);
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      return _authRepository.getCurrentUser();
    } catch (e, st) {
      talker.handle(e, st);
      rethrow;
    }
  }
}
