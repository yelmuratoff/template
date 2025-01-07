import 'package:base_starter/src/app/router/enums/root_tabs_enum.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/features/home/presentation/home_screen.dart';
import 'package:base_starter/src/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';

import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:octopus/octopus.dart';

/// The root page of the application.
class RootScreen extends StatefulWidget {
  const RootScreen({Key? key})
      : super(key: key ?? const ValueKey<String>('RootScreen'));

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  // Octopus state observer
  late final OctopusStateObserver _octopusStateObserver;

  // Current tab
  RootTabsEnum _tab = RootTabsEnum.home;

  @override
  void initState() {
    super.initState();
    _octopusStateObserver = context.octopus.observer;

    // Restore tab from router arguments
    _tab = RootTabsEnum.fromValue(
      _octopusStateObserver.value.arguments['tab'],
      fallback: RootTabsEnum.home,
    );
    _octopusStateObserver.addListener(_onOctopusStateChanged);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: NoAnimationScope(
          child: IndexedStack(
            index: _tab.index,
            children: const [
              HomeTab(),
              ProfileTab(),
            ],
          ),
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: context.theme.colorScheme.onSurface.withValues(
                  alpha: 0.1,
                ),
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
            currentIndex: _tab.index,
            selectedItemColor: context.theme.colorScheme.primary,
            onTap: _onItemTapped,
            useLegacyColorScheme: false,
          ),
        ),
      );

  // <--- Methods --->

  // Bottom navigation bar item tapped
  void _onItemTapped(int index) {
    final newTab = RootTabsEnum.values[index];
    // Switch tab to new one
    _switchTab(newTab);
  }

  // Change tab
  void _switchTab(RootTabsEnum tab) {
    if (!mounted) return;
    if (_tab == tab) return;
    context.octopus.setArguments((args) => args['tab'] = tab.name);
    setState(() => _tab = tab);
  }

  // Router state changed
  void _onOctopusStateChanged() {
    final newTab = RootTabsEnum.fromValue(
      _octopusStateObserver.value.arguments['tab'],
      fallback: RootTabsEnum.home,
    );
    _switchTab(newTab);
  }
}
