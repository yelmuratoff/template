part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState._();
}

final class InitialAuthState extends AuthState {
  const InitialAuthState() : super._();
}

final class LoadingAuthState extends AuthState {
  const LoadingAuthState() : super._();
}

final class AuthenticatedAuthState extends AuthState {
  const AuthenticatedAuthState() : super._();
}

final class ErrorAuthState extends AuthState with EquatableMixin {
  final String message;
  final Object cause;
  const ErrorAuthState({
    required this.message,
    required this.cause,
  }) : super._();

  @override
  List<Object> get props => [message, cause];
}
