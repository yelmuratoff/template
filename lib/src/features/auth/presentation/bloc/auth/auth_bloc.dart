import 'package:base_starter/src/common/utils/extensions/bloc_extension.dart';
import 'package:base_starter/src/common/utils/utils.dart';
import 'package:base_starter/src/core/database/src/preferences/secure_storage_manager.dart';
import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repository}) : super(const InitialAuthState()) {
    on<AuthEvent>(
      (event, emit) => switch (event) {
        final LoginAuthEvent e => _onLogin(e, emit),
        final GetCurrentUserAuthEvent _ => _onGetCurrentUser(emit),
        final LogoutAuthEvent _ => _onLogout(emit),
      },
    );
  }
  final IAuthRepository repository;

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
    } catch (e, st) {
      handleException(
        exception: e,
        stackTrace: st,
        onError: (message, cause, _) {
          emit(ErrorAuthState(cause: cause, message: message));
        },
      );
    }
  }

  Future<void> _onLogout(Emitter<AuthState> emit) async {
    try {
      emit(const LoadingAuthState());
      await AppUtils.exit();
      emit(const InitialAuthState());
    } catch (e, st) {
      handleException(
        exception: e,
        stackTrace: st,
        onError: (message, cause, _) {
          emit(ErrorAuthState(cause: cause, message: message));
        },
      );
    }
  }

  Future<void> _onGetCurrentUser(
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const LoadingAuthState());
      await repository.getCurrentUser();

      emit(const AuthenticatedAuthState());
    } catch (e, st) {
      handleException(
        exception: e,
        stackTrace: st,
        onError: (message, cause, _) {
          emit(ErrorAuthState(cause: cause, message: message));
        },
      );
    }
  }
}
