import 'package:ui/ui.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/auth/presentation/auth_scope.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static void _onState(BuildContext context, AuthState state) {
    switch (state) {
      case InitialAuthState():
      case UnauthenticatedAuthState():
        break;
      case LoadingAuthState():
        AppDialogs.showLoader(context, title: L10n.current.loading);
      case AuthenticatedAuthState():
        AppDialogs.dismiss();
      case ErrorAuthState():
        AppDialogs.dismiss();
        Toaster.showErrorToast(context, title: state.message);
    }
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthState>(
    bloc: context.dependencies.authBloc,
    listener: _onState,
    child: AuthView(
      onLoginPressed: () => AuthScope.of(
        context,
        listen: false,
      ).login(email: 'john@mail.com', password: 'changeme'),
    ),
  );
}

class AuthView extends StatelessWidget {
  const AuthView({required this.onLoginPressed, super.key});

  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(L10n.current.login)),
    body: Center(
      child: AppButton(onPressed: onLoginPressed, text: L10n.current.login),
    ),
  );
}
