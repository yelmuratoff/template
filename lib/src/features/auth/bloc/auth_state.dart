part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState._();
}

final class InitialAuthState extends AuthState {
  const InitialAuthState() : super._();

  @override
  List<Object> get props => [];
}

final class LoadingAuthState extends AuthState {
  const LoadingAuthState() : super._();

  @override
  List<Object> get props => [];
}

final class AuthenticatedAuthState extends AuthState {
  const AuthenticatedAuthState() : super._();

  @override
  List<Object> get props => [];
}

final class ErrorAuthState extends AuthState {
  final String message;
  final Object cause;
  const ErrorAuthState({
    required this.message,
    required this.cause,
  }) : super._();

  @override
  List<Object> get props => [message, cause];
}
