import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

part '../widget/bottom_navigation_bar.dart';

/// The root page of the application.
class RootPage extends ConsumerStatefulWidget {
  const RootPage({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey<String>('RootPage'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: _BottomNavigationBar(
          navigationShell: widget.navigationShell,
        ),
      );
}
