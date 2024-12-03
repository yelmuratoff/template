// ignore_for_file: use_build_context_synchronously

import 'package:base_starter/src/common/presentation/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/core/assets/generated/assets.gen.dart';
import 'package:base_starter/src/core/database/src/preferences/app_config_manager.dart';
import 'package:base_starter/src/core/database/src/preferences/secure_storage_manager.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize(context);
  }

  Future<void> _initialize(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (AppConfigManager.instance.isFirstRun) {
        await SecureStorageManager.storage.deleteAll();
        await AppConfigManager.instance.setFirstRun(value: false);
      }
      fToast.init(context);
      final tokenPair = await SecureStorageManager.getToken();
      if (tokenPair != null && context.mounted) {
        // const HomeRoute().go(context);
      } else {
        // const AuthRoute().go(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Image.asset(
        Assets.images.splash.path,
        fit: BoxFit.cover,
      );
}
