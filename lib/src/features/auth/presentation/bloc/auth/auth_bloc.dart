import 'dart:async';

import 'package:base_starter/src/common/utils/extensions/bloc_extension.dart';
import 'package:base_starter/src/core/rest_client/auth/token_storage.dart';
import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:ispect/ispect.dart';

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

  static AuthState _error(Object _, String message, Object? cause, int? _) =>
      ErrorAuthState(message: message, cause: cause);

  Future<void> _onLogin(LoginAuthEvent event, Emitter<AuthState> emit) =>
      guard(emit: emit, errorState: _error, reportBug: onError, () async {
        emit(const LoadingAuthState());
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
      });

  Future<void> _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) =>
      guard(emit: emit, errorState: _error, reportBug: onError, () async {
        emit(const LoadingAuthState());
        await _tokenStorage.clear();
        emit(const UnauthenticatedAuthState());
      });

  Future<void> _onCheckStatus(
    CheckStatusAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const LoadingAuthState());
    emit(await _readSession());
  }

  /// Resolves the restored session state.
  ///
  /// An unreadable token store recovers to [UnauthenticatedAuthState] rather
  /// than an error state: the splash screen routes only off the authenticated/
  /// unauthenticated split, so surfacing an error here would strand the user.
  Future<AuthState> _readSession() async {
    try {
      final tokenPair = await _tokenStorage.read();
      return tokenPair != null
          ? const AuthenticatedAuthState()
          : const UnauthenticatedAuthState();
    } on Exception catch (e, st) {
      ISpect.logger.handle(
        exception: e,
        stackTrace: st,
        message: 'Session check failed; treating as signed out.',
      );
      return const UnauthenticatedAuthState();
    }
  }

  void _onTokenRevoked(_TokenRevokedAuthEvent event, Emitter<AuthState> emit) {
    emit(const UnauthenticatedAuthState());
  }

  @override
  Future<void> close() {
    _revocationSubscription.cancel();
    return super.close();
  }
}
