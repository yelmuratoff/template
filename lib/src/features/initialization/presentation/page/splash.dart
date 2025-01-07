// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/core/assets/generated/assets.gen.dart';
import 'package:base_starter/src/core/database/src/preferences/app_config_manager.dart';
import 'package:base_starter/src/core/database/src/preferences/secure_storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

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

      final tokenPair = await SecureStorageManager.getToken();
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;

      if (tokenPair != null) {
        unawaited(
          context.octopus.setState(
            (state) => state
              ..clear()
              ..add(
                Routes.root.node(),
              ),
          ),
        );
      } else {
        unawaited(
          context.octopus.setState(
            (state) => state
              ..clear()
              ..add(
                Routes.auth.node(),
              ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xff1468AD),
        body: Center(
          child: Image.asset(
            Assets.images.icon.path,
            width: 250,
          ),
        ),
      );
}
