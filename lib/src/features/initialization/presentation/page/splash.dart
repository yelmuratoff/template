import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/assets/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// Placeholder destination the navigation tree starts on.
///
/// The composition root resolves the session before the router mounts and
/// `NavigationManager` routes off the resulting auth state, so this is replaced
/// by the shell or the sign-in screen before the first frame.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.theme.colorScheme.primary,
    body: Center(child: Image.asset(Assets.images.icon.path, width: 250)),
  );
}
