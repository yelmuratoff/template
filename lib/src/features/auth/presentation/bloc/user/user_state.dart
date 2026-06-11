part of 'user_bloc.dart';

sealed class UserState {
  const UserState._();
}

final class InitialUserState extends UserState {
  const InitialUserState() : super._();
}

final class LoadingUserState extends UserState {
  const LoadingUserState() : super._();
}

final class LoadedUserState extends UserState with EquatableMixin {
  const LoadedUserState({required this.user}) : super._();
  final UserDTO user;

  @override
  List<Object?> get props => [user];
}

final class ErrorUserState extends UserState with EquatableMixin {
  const ErrorUserState({required this.message, this.cause}) : super._();
  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];
}
