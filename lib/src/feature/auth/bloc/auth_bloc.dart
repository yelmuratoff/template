import 'package:base_starter/src/common/utils/utils.dart';
import 'package:base_starter/src/core/resource/data/database/src/secure_storage.dart';
import 'package:base_starter/src/core/resource/data/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/feature/auth/resource/domain/use_cases/auth_use_cases.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ispect/ispect.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases authUseCases;
  AuthBloc({required this.authUseCases}) : super(const InitialAuthState()) {
    on<LoginAuthEvent>(_onLogin);
    on<GetCurrentUserAuthEvent>(_onGetCurrentUser);
    on<LogoutAuthEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginAuthEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthState.loading());
      final tokenPair = await authUseCases.login(
        email: event.email,
        password: event.password,
      );
      if (tokenPair != null) {
        await SecureStorageService.setToken(tokenPair);
        emit(const AuthState.authenticated());
      }
    } on RestClientException catch (e) {
      emit(AuthState.error(cause: e, message: e.message));
    } on Object catch (e) {
      emit(AuthState.error(cause: e, message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthState.loading());
      await AppUtils.removeToken();
      emit(const AuthState.initial());
    } on RestClientException catch (e) {
      emit(AuthState.error(cause: e, message: e.message));
    } on Object catch (e) {
      emit(AuthState.error(cause: e, message: e.toString()));
    }
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      final user = await authUseCases.getCurrentUser();
      if (user != null) {
        emit(const AuthState.authenticated());
      } else {
        talkerWrapper.error(message: "Get current user failed: user is null");
        emit(
          const AuthState.error(
            cause: "Get current user failed: user is null",
            message: "Get current user failed: user is null",
          ),
        );
      }
    } on DioException catch (e, st) {
      talkerWrapper.handle(exception: e, stackTrace: st, message: "Dio error");
      emit(AuthState.error(cause: e, message: e.message ?? e.toString()));
    } on Object catch (e, st) {
      talkerWrapper.handle(exception: e, stackTrace: st, message: "Error");
      emit(AuthState.error(cause: e, message: e.toString()));
    }
  }
}

@freezed
sealed class AuthEvent with _$AuthEvent {
  const AuthEvent._();

  /// Event to login.
  const factory AuthEvent.login({
    required String email,
    required String password,
  }) = LoginAuthEvent;

  const factory AuthEvent.getCurrentUser() = GetCurrentUserAuthEvent;

  const factory AuthEvent.logout() = LogoutAuthEvent;
}

@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();

  /// Initial state for the [AuthBloc].
  const factory AuthState.initial() = InitialAuthState;

  /// Loading state for the [AuthBloc].
  const factory AuthState.loading() = LoadingAuthState;

  /// Authenticated state for the [AuthBloc].
  const factory AuthState.authenticated() = AuthenticatedAuthState;

  /// Error state for the [AuthBloc].
  const factory AuthState.error({
    required String message,
    required Object cause,
  }) = ErrorAuthState;
}
