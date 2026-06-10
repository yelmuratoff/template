import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/assets/generated/assets.gen.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';

/// Session-restore screen.
///
/// Dispatches [CheckStatusAuthEvent] once; `NavigationManager` reacts to the
/// resulting auth state and routes away from the splash. The first-run secure
/// storage wipe happens earlier, in the composition root.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.dependencies.authBloc.add(const CheckStatusAuthEvent());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff1468AD),
    body: Center(child: Image.asset(Assets.images.icon.path, width: 250)),
  );
}
