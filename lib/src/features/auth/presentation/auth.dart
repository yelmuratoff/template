import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/app_button.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/auth/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(L10n.current.login),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async => switch (state) {
            InitialAuthState() => null,
            AuthenticatedAuthState() => {
                AppDialogs.dismiss(),
                // TODO(Yelaman): Save user to UserManager
                //context.dependencies.userCubit.write(user: state.user),
                const HomeRoute().go(context),
              },
            ErrorAuthState() => {
                AppDialogs.dismiss(),
                Toaster.showErrorToast(context, title: state.message),
              },
            LoadingAuthState() => {
                AppDialogs.showLoader(context, title: L10n.current.loading),
              },
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
