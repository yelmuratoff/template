part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent._();
}

final class LoginAuthEvent extends AuthEvent with EquatableMixin {
  final String email;
  final String password;
  const LoginAuthEvent({
    required this.email,
    required this.password,
  }) : super._();

  @override
  List<Object> get props => [email, password];
}

final class GetCurrentUserAuthEvent extends AuthEvent {
  const GetCurrentUserAuthEvent() : super._();
}

final class LogoutAuthEvent extends AuthEvent {
  const LogoutAuthEvent() : super._();
}
