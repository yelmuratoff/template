part of '../auth.dart';

class _AuthView extends StatelessWidget {
  final void Function() onAuthenticate;
  final void Function(String) onAuthError;
  final void Function() onAuthLoading;
  final void Function() onSignInPressed;
  const _AuthView({
    required this.onAuthenticate,
    required this.onAuthError,
    required this.onAuthLoading,
    required this.onSignInPressed,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Auth Page'),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) => switch (state) {
            InitialAuthState() => null,
            AuthenticatedAuthState() => {
                onAuthenticate.call(),
              },
            ErrorAuthState() => {
                onAuthError.call(state.message),
              },
            LoadingAuthState() => {
                onAuthLoading.call(),
              },
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppButton(
                  onPressed: () {
                    onSignInPressed.call();
                  },
                  text: context.l10n.login,
                ),
              ],
            ),
          ),
        ),
      );
}
