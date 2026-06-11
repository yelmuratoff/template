import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Operations the [UserScope] exposes to its descendants.
abstract interface class UserController {
  /// The current user state.
  UserState get state;

  /// The loaded user, or `null` while none is available.
  UserDTO? get user;

  /// Loads the cached user then refreshes it from the backend.
  void fetch();
}

/// Exposes the [UserBloc] state and actions to the widget subtree.
///
/// Rebuilds dependents through an inherited widget whenever the user state
/// changes. The bloc is injected from the composition root, mirroring
/// `SettingsScope`; descendants reach it via [of]/[stateOf]/[userOf].
class UserScope extends StatefulWidget {
  const UserScope({required this.child, required this.userBloc, super.key});

  /// The child widget.
  final Widget child;

  /// The [UserBloc] instance.
  final UserBloc userBloc;

  /// Get the [UserController] of the closest [UserScope] ancestor.
  static UserController of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_InheritedUserScope>(listen: listen).controller;

  /// Get the current [UserState] of the closest [UserScope] ancestor.
  static UserState stateOf(BuildContext context) =>
      context.inhOf<_InheritedUserScope>().state;

  /// Get the loaded [UserDTO] of the closest [UserScope] ancestor, or `null`.
  static UserDTO? userOf(BuildContext context) {
    final state = context.inhOf<_InheritedUserScope>().state;
    return state is LoadedUserState ? state.user : null;
  }

  @override
  State<UserScope> createState() => _UserScopeState();
}

class _UserScopeState extends State<UserScope> implements UserController {
  @override
  UserState get state => widget.userBloc.state;

  @override
  UserDTO? get user {
    final state = widget.userBloc.state;
    return state is LoadedUserState ? state.user : null;
  }

  @override
  void fetch() => widget.userBloc.add(const FetchUserEvent());

  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
    bloc: widget.userBloc,
    builder: (_, state) => _InheritedUserScope(
      controller: this,
      state: state,
      child: widget.child,
    ),
  );
}

class _InheritedUserScope extends InheritedWidget {
  const _InheritedUserScope({
    required this.controller,
    required this.state,
    required super.child,
  });

  final UserController controller;
  final UserState state;

  @override
  bool updateShouldNotify(_InheritedUserScope oldWidget) =>
      state != oldWidget.state;
}
