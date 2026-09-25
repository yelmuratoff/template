import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';

/// Asks [authBloc] to restore the persisted session and completes once it has
/// settled on signed-in or signed-out.
///
/// Startup must not build the navigation tree before this resolves: on web the
/// router restores the previous URL on reload, so `AuthGuard` runs before any
/// screen can dispatch the check and would send a signed-in user back to
/// sign-in.
Future<void> restoreSession(AuthBloc authBloc) async {
  authBloc.add(const CheckStatusAuthEvent());
  await authBloc.stream.firstWhere(
    (state) => switch (state) {
      AuthenticatedAuthState() || UnauthenticatedAuthState() => true,
      InitialAuthState() || LoadingAuthState() || ErrorAuthState() => false,
    },
  );
}
