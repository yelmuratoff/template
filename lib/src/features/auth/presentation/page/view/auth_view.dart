part of '../auth.dart';

class _AuthView extends StatelessWidget {
  const _AuthView();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Auth Page'),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) => switch (state) {
            InitialAuthState() => null,
            AuthenticatedAuthState() => {
                AppDialogs.dismiss(),
                context.goNamed(HomePage.name),
              },
            ErrorAuthState() => {
                AppDialogs.dismiss(),
                Toaster.showErrorToast(context, title: state.message),
              },
            LoadingAuthState() =>
              AppDialogs.showLoader(context, title: context.l10n.loading),
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppButton(
                  onPressed: () {
                    context.dependencies.authBloc.add(
                      const LoginAuthEvent(
                        email: 'john@mail.com',
                        password: 'changeme',
                      ),
                    );
                  },
                  text: context.l10n.login,
                ),
              ],
            ),
          ),
        ),
      );
}
