part of 'user_bloc.dart';

sealed class UserEvent {
  const UserEvent._();
}

/// Loads the cached user, then refreshes it from the backend.
final class FetchUserEvent extends UserEvent {
  const FetchUserEvent() : super._();
}

/// Drops the cached user (e.g. on sign-out).
final class ClearUserEvent extends UserEvent {
  const ClearUserEvent() : super._();
}
