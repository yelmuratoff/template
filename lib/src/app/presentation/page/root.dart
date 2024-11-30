import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/home/presentation/home.dart';
import 'package:base_starter/src/features/profile/presentation/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:octopus/octopus.dart';

part '../widget/bottom_navigation_bar.dart';

/// RootTabsEnum enumeration
enum RootTabsEnum implements Comparable<RootTabsEnum> {
  /// Home
  home('home'),

  /// Profile
  profile('profile');

  const RootTabsEnum(this.name);

  /// Creates a new instance of [RootTabsEnum] from a given string.
  static RootTabsEnum fromValue(String? value, {RootTabsEnum? fallback}) =>
      switch (value?.trim().toLowerCase()) {
        'home' => home,
        'profile' => profile,
        _ => fallback ?? (throw ArgumentError.value(value)),
      };

  /// Value of the enum
  final String name;

  /// Pattern matching
  T map<T>({
    required T Function() home,
    required T Function() profile,
  }) =>
      switch (this) {
        RootTabsEnum.home => home(),
        RootTabsEnum.profile => profile(),
      };

  /// Pattern matching
  T maybeMap<T>({
    required T Function() orElse,
    T Function()? home,
    T Function()? profile,
  }) =>
      map<T>(
        home: home ?? orElse,
        profile: profile ?? orElse,
      );

  /// Pattern matching
  T? maybeMapOrNull<T>({
    T Function()? home,
    T Function()? profile,
  }) =>
      maybeMap<T?>(
        orElse: () => null,
        home: home,
        profile: profile,
      );

  @override
  int compareTo(RootTabsEnum other) => index.compareTo(other.index);

  @override
  String toString() => name;
}

/// The root page of the application.
class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({Key? key})
      : super(key: key ?? const ValueKey<String>('RootScreen'));

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
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
        appBar: AppBar(
          title: Text(context.octopus.state.location),
        ),
        body: NoAnimationScope(
          child: IndexedStack(
            index: _tab.index,
            children: const [
              HomeTab(),
              ProfileTab(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.blue,
            ),
          ],
          currentIndex: _tab.index,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        // bottomNavigationBar: _BottomNavigationBar(
        //   navigationShell: widget.navigationShell,
        // ),
      );

  // <--- Methods --->

  // Bottom navigation bar item tapped
  void _onItemTapped(int index) {
    final newTab = RootTabsEnum.values[index];
    if (_tab == newTab) {
      // The same tab tapped twice
      if (newTab == RootTabsEnum.home) _clearCatalogNavigationStack();
    } else {
      // Switch tab to new one
      _switchTab(newTab);
    }
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

  // Pop to catalog at double tap on catalog tab
  void _clearCatalogNavigationStack() {
    // context.octopus.setState((state) {
    //   final catalog = state.findByName('catalog-tab');
    //   if (catalog == null || catalog.children.length < 2) return state;
    //   catalog.children.length = 1;
    //   if (mounted) {
    //     ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    //       const SnackBar(
    //         content: Text('Poped to catalog tab at double tap'),
    //         backgroundColor: Colors.green,
    //       ),
    //     );
    //   }
    //   return state;
    // });
  }
}
