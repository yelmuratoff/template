part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent._();
}

final class LoginAuthEvent extends AuthEvent with EquatableMixin {
  const LoginAuthEvent({required this.email, required this.password})
    : super._();
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

final class LogoutAuthEvent extends AuthEvent {
  const LogoutAuthEvent() : super._();
}

/// Restores the session on startup: reports [AuthenticatedAuthState] when a
/// token pair is present and [UnauthenticatedAuthState] otherwise.
final class CheckStatusAuthEvent extends AuthEvent {
  const CheckStatusAuthEvent() : super._();
}

/// Raised internally when [TokenStorage.changes] emits `null` while the user is
/// authenticated, i.e. the session was revoked out from under the BLoC.
final class _TokenRevokedAuthEvent extends AuthEvent {
  const _TokenRevokedAuthEvent() : super._();
}
