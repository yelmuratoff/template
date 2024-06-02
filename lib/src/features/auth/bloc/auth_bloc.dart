import 'package:base_starter/src/common/configs/preferences/secure_storage_manager.dart';
import 'package:base_starter/src/common/utils/utils.dart';
import 'package:base_starter/src/core/resource/data/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/resource/domain/use_cases/auth_use_cases.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:ispect/ispect.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases authUseCases;
  AuthBloc({required this.authUseCases}) : super(const InitialAuthState()) {
    on<LoginAuthEvent>(_onLogin);
    on<GetCurrentUserAuthEvent>(_onGetCurrentUser);
    on<LogoutAuthEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginAuthEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const LoadingAuthState());
      final tokenPair = await authUseCases.login(
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

  Future<void> _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) async {
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
    GetCurrentUserAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const LoadingAuthState());
      final user = await authUseCases.getCurrentUser();
      if (user != null) {
        emit(const AuthenticatedAuthState());
      } else {
        talkerWrapper.error(message: "Get current user failed: user is null");
        emit(
          const ErrorAuthState(
            cause: "Get current user failed: user is null",
            message: "Get current user failed: user is null",
          ),
        );
      }
    } on DioException catch (e, st) {
      talkerWrapper.handle(exception: e, stackTrace: st, message: "Dio error");
      emit(ErrorAuthState(cause: e, message: e.message ?? e.toString()));
    } on Object catch (e, st) {
      talkerWrapper.handle(exception: e, stackTrace: st, message: "Error");
      emit(ErrorAuthState(cause: e, message: e.toString()));
    }
  }
}
