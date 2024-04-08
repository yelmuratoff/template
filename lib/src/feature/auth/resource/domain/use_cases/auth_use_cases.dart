import 'package:base_starter/src/core/resource/domain/token/token_pair.dart';
import 'package:base_starter/src/feature/auth/resource/domain/models/user_model.dart';
import 'package:base_starter/src/feature/auth/resource/domain/repositories/auth_repository.dart';
import 'package:ispect/ispect.dart';

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
      return await _authRepository.login(email: email, password: password);
    } catch (e, st) {
      talkerWrapper.handle(
        exception: e,
        stackTrace: st,
        message: 'Login failed',
      );
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      return _authRepository.getCurrentUser();
    } catch (e, st) {
      talkerWrapper.handle(
        exception: e,
        stackTrace: st,
        message: 'Get current user failed',
      );
      rethrow;
    }
  }
}
