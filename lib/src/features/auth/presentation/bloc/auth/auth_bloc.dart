import 'dart:async';

import 'package:base_starter/src/common/utils/extensions/bloc_extension.dart';
import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/core/rest_client/auth/token_storage.dart';
import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repository, required this._tokenStorage})
    : super(const InitialAuthState()) {
    on<LoginAuthEvent>(_onLogin, transformer: droppable());
    on<LogoutAuthEvent>(_onLogout, transformer: droppable());
    on<CheckStatusAuthEvent>(_onCheckStatus, transformer: restartable());
    on<_TokenRevokedAuthEvent>(_onTokenRevoked);

    _revocationSubscription = _tokenStorage.changes.listen((pair) {
      if (pair == null && state is AuthenticatedAuthState) {
        add(const _TokenRevokedAuthEvent());
      }
    });
  }

  final IAuthRepository repository;
  final TokenStorage _tokenStorage;
  late final StreamSubscription<TokenPair?> _revocationSubscription;

  Future<void> _onLogin(LoginAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      final tokenPair = await repository.login(
        email: event.email,
        password: event.password,
      );
      if (tokenPair == null) {
        emit(const UnauthenticatedAuthState());
        return;
      }
      await _tokenStorage.save(tokenPair);
      emit(const AuthenticatedAuthState());
    } on AppException catch (e, st) {
      _emitError(e, st, emit);
    } on Object catch (e, st) {
      _emitError(e, st, emit);
      onError(e, st);
    }
  }

  Future<void> _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _tokenStorage.clear();
      emit(const UnauthenticatedAuthState());
    } on AppException catch (e, st) {
      _emitError(e, st, emit);
    } on Object catch (e, st) {
      _emitError(e, st, emit);
      onError(e, st);
    }
  }

  Future<void> _onCheckStatus(
    CheckStatusAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const LoadingAuthState());
    try {
      final tokenPair = await _tokenStorage.read();
      emit(
        tokenPair != null
            ? const AuthenticatedAuthState()
            : const UnauthenticatedAuthState(),
      );
    } on AppException catch (e, st) {
      _emitError(e, st, emit);
    } on Object catch (e, st) {
      _emitError(e, st, emit);
      onError(e, st);
    }
  }

  void _onTokenRevoked(_TokenRevokedAuthEvent event, Emitter<AuthState> emit) {
    emit(const UnauthenticatedAuthState());
  }

  void _emitError(Object e, StackTrace st, Emitter<AuthState> emit) {
    handleException(
      exception: e,
      stackTrace: st,
      onError: (message, cause, _) =>
          emit(ErrorAuthState(message: message, cause: cause)),
    );
  }

  @override
  Future<void> close() {
    _revocationSubscription.cancel();
    return super.close();
  }
}
