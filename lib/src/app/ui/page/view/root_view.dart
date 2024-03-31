part of '../root.dart';

class _RootView extends StatelessWidget {
  const _RootView(this.navigationShell);

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: navigationShell,
      );
}
