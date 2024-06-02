import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/app_button.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/features/auth/bloc/auth_bloc.dart';
import 'package:base_starter/src/features/home/presentation/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'view/auth_view.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  static const String name = "Auth";
  static const String routePath = "/auth";

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) => _AuthView(
        onSignInPressed: () {
          context.dependencies.authBloc.add(
            const LoginAuthEvent(
              email: 'john@mail.com',
              password: 'changeme',
            ),
          );
        },
        onAuthenticate: () {
          AppDialogs.dismiss();
          context.goNamed(HomePage.name);
        },
        onAuthError: (message) {
          AppDialogs.dismiss();
          Toaster.showErrorToast(context, title: message);
        },
        onAuthLoading: () {
          AppDialogs.showLoader(context, title: context.l10n.loading);
        },
      );
}
