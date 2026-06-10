import 'package:base_starter/src/common/presentation/widgets/buttons/app_button.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:base_starter/src/common/presentation/widgets/toaster/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(L10n.current.login)),
    body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
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
      },
      child: Center(
        child: AppButton(
          onPressed: () {
            context.dependencies.authBloc.add(
              const LoginAuthEvent(
                email: 'john@mail.com',
                password: 'changeme',
              ),
            );
          },
          text: L10n.current.login,
        ),
      ),
    ),
  );
}
