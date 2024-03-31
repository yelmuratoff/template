part of '../auth.dart';

class _AuthView extends StatelessWidget {
  const _AuthView();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Auth Page'),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedAuthState) {
              context.pushReplacementNamed(HomePage.name);
            } else if (state is ErrorAuthState) {
              Toaster.showErrorToast(context, title: state.message);
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEvent.login(
                            email: 'john@mail.com',
                            password: 'changeme',
                          ),
                        );
                  },
                  child: Text(context.l10n.login),
                ),
              ],
            ),
          ),
        ),
      );
}
