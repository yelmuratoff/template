// ignore_for_file: use_build_context_synchronously

import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/configs/preferences/app_config_manager.dart';
import 'package:base_starter/src/common/configs/preferences/secure_storage_manager.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/core/assets/generated/assets.gen.dart';
import 'package:base_starter/src/features/auth/presentation/page/auth.dart';
import 'package:base_starter/src/features/home/presentation/page/home.dart';
import 'package:flutter/material.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (AppConfigManager.instance.isFirstRun) {
        await SecureStorageManager.storage.deleteAll();
        await AppConfigManager.instance.setFirstRun(value: false);
      }
      fToast.init(navigatorKey.currentContext!);
      final tokenPair = await SecureStorageManager.getToken();
      if (tokenPair != null && context.mounted) {
        context.goNamed(HomePage.name);
      } else {
        context.goNamed(AuthPage.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Image.asset(
        Assets.images.splash.path,
        fit: BoxFit.cover,
      );
}
