import 'package:base_starter/src/common/configs/preferences/secure_storage_manager.dart';
import 'package:base_starter/src/common/utils/utils.dart';
import 'package:base_starter/src/core/resource/data/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/auth/remote_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ispect/ispect.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository repository;
  AuthBloc({required this.repository}) : super(const InitialAuthState()) {
    on<LoginAuthEvent>(_onLogin);
    on<GetCurrentUserAuthEvent>((_, state) => _onGetCurrentUser(state));
    on<LogoutAuthEvent>((_, state) => _onLogout(state));
  }

  Future<void> _onLogin(LoginAuthEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const LoadingAuthState());
      final tokenPair = await repository.login(
        email: event.email,
        password: event.password,
      );
      if (tokenPair != null) {
        await SecureStorageManager.setToken(value: tokenPair);

        emit(const AuthenticatedAuthState());
      }
    } on RestClientException catch (e) {
      emit(ErrorAuthState(cause: e, message: e.message));
    } catch (e) {
      emit(ErrorAuthState(cause: e, message: e.toString()));
    }
  }

  Future<void> _onLogout(Emitter<AuthState> emit) async {
    try {
      emit(const LoadingAuthState());
      await AppUtils.removeToken();
      emit(const InitialAuthState());
    } on RestClientException catch (e) {
      emit(ErrorAuthState(cause: e, message: e.message));
    } on Object catch (e) {
      emit(ErrorAuthState(cause: e, message: e.toString()));
    }
  }

  Future<void> _onGetCurrentUser(
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const LoadingAuthState());
      final user = await repository.getCurrentUser();
      if (user != null) {
        emit(const AuthenticatedAuthState());
      } else {
        ISpectTalker.error(message: "Get current user failed: user is null");
        emit(
          const ErrorAuthState(
            cause: "Get current user failed: user is null",
            message: "Get current user failed: user is null",
          ),
        );
      }
    } on RestClientException catch (e) {
      emit(ErrorAuthState(cause: e, message: e.message));
    } on Object catch (e) {
      emit(ErrorAuthState(cause: e, message: e.toString()));
    }
  }
}
