import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Operations the [AuthScope] exposes to its descendants.
abstract interface class AuthController {
  /// The current authentication state.
  AuthState get state;

  /// Dispatches a login attempt for [email]/[password].
  void login({required String email, required String password});

  /// Signs the current session out.
  void logout();
}

/// Exposes the [AuthBloc] state and actions to the widget subtree.
///
/// Rebuilds dependents through an inherited widget whenever the auth state
/// changes. The bloc is injected from the composition root, mirroring
/// `SettingsScope`; descendants reach it via [of]/[stateOf] instead of the
/// raw bloc.
class AuthScope extends StatefulWidget {
  const AuthScope({required this.child, required this.authBloc, super.key});

  /// The child widget.
  final Widget child;

  /// The [AuthBloc] instance.
  final AuthBloc authBloc;

  /// Get the [AuthController] of the closest [AuthScope] ancestor.
  static AuthController of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_InheritedAuthScope>(listen: listen).controller;

  /// Get the current [AuthState] of the closest [AuthScope] ancestor.
  static AuthState stateOf(BuildContext context) =>
      context.inhOf<_InheritedAuthScope>().state;

  @override
  State<AuthScope> createState() => _AuthScopeState();
}

class _AuthScopeState extends State<AuthScope> implements AuthController {
  @override
  AuthState get state => widget.authBloc.state;

  @override
  void login({required String email, required String password}) =>
      widget.authBloc.add(LoginAuthEvent(email: email, password: password));

  @override
  void logout() => widget.authBloc.add(const LogoutAuthEvent());

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
    bloc: widget.authBloc,
    builder: (_, state) => _InheritedAuthScope(
      controller: this,
      state: state,
      child: widget.child,
    ),
  );
}

class _InheritedAuthScope extends InheritedWidget {
  const _InheritedAuthScope({
    required this.controller,
    required this.state,
    required super.child,
  });

  final AuthController controller;
  final AuthState state;

  @override
  bool updateShouldNotify(_InheritedAuthScope oldWidget) =>
      state != oldWidget.state;
}
