// ignore_for_file: experimental_member_use
// ActiveRouteController is the documented v1.0 tab API, marked experimental
// upstream; the bottom-nav tabs depend on it.
import 'package:base_starter/src/app/router/routes/app_routes.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:yx_navigation/yx_navigation.dart';

/// Authenticated shell: a bottom-navigation bar over the tab [IndexedStack].
///
/// Rendered by the `AppRoutes.root` indexed-stack declaration; [child] is the
/// live `IndexedStack` and [controller] switches the active tab while every
/// tab retains its state.
class RootView extends StatelessWidget {
  const RootView({required this.child, required this.controller, super.key});

  final Widget child;
  final ActiveRouteController controller;

  static const _tabs = [AppRoutes.homeTab, AppRoutes.profileTab];

  @override
  Widget build(BuildContext context) {
    final active = controller.activeRoute ?? AppRoutes.homeTab;
    final currentIndex = _tabs.indexOf(active).clamp(0, _tabs.length - 1);

    return Scaffold(
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: context.theme.colorScheme.onSurface.withValues(alpha: 0.1),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(IconsaxPlusLinear.home),
              activeIcon: Icon(IconsaxPlusBold.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconsaxPlusLinear.user_square),
              activeIcon: Icon(IconsaxPlusBold.user_square),
              label: 'Profile',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: context.theme.colorScheme.primary,
          onTap: (index) => controller.setActiveRoute(_tabs[index]),
          useLegacyColorScheme: false,
        ),
      ),
    );
  }
}
