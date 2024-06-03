import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'view/root_view.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _RootView(
        widget.navigationShell,
      );
}
