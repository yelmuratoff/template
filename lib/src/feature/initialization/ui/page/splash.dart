import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/core/assets/generated/assets.gen.dart';
import 'package:base_starter/src/feature/home/ui/page/home.dart';
import 'package:flutter/material.dart';

part 'view/splash_model.dart';
part 'view/splash_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String name = "Splash";
  static const String routePath = "/splash";

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        context.pushReplacementNamed(HomePage.name);
      });
    });
  }

  @override
  Widget build(BuildContext context) => const _SplashView();
}
