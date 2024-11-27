import 'package:base_starter/src/features/auth/presentation/auth_screen.dart';
import 'package:base_starter/src/features/home/presentation/home.dart';
import 'package:base_starter/src/features/initialization/presentation/page/splash.dart';
import 'package:base_starter/src/features/profile/presentation/profile.dart';
import 'package:base_starter/src/features/settings/presentation/settings.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

enum Routes with OctopusRoute {
  splash('splash', title: 'Splash'),
  auth('auth', title: 'Auth'),
  home('home', title: 'Home'),
  profile('profile', title: 'Profile'),
  settings('settings', title: 'Settings');

  const Routes(this.name, {this.title});

  @override
  final String name;

  @override
  final String? title;

  @override
  Widget builder(BuildContext context, OctopusState state, OctopusNode node) =>
      switch (this) {
        Routes.splash => const SplashScreen(),
        Routes.auth => const AuthScreen(),
        Routes.home => const HomeScreen(),
        Routes.profile => const ProfileScreen(),
        Routes.settings => SettingsScreen(
            title: node.arguments['title'],
          ),
        // Routes.product => _ShopLoader(
        //     builder: (context) =>
        //         shop_screens.ProductScreen(id: node.arguments['id']),
        //   ),
        // Routes.productImageDialog => _ShopLoader(
        //     builder: (context) => shop_screens.ProductImageDialog(
        //       id: node.arguments['id'],
        //       idx: node.arguments['idx'],
        //     ),
        //   ),
        // Routes.gallery => const GalleryScreen(),
        // Routes.picture => PictureScreen(id: node.arguments['id']),
      };
}
