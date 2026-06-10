import 'package:yx_navigation/yx_navigation.dart';

/// Seeds an outlet tab with its landing page the first time it appears.
///
/// `NavigateToIndexedStackNodeGuard` creates the tab container nodes but leaves
/// them empty; an empty outlet renders a blank navigator. This guard adds
/// [childRoute] under [tabRoute] whenever that tab has no children, so the tab
/// always opens on a real page.
final class TabInitGuard implements RouteNodeGuard {
  const TabInitGuard({required this.tabRoute, required this.childRoute});

  /// Tab container route to seed.
  final YxRoute tabRoute;

  /// Landing page added when the tab is empty.
  final YxRoute childRoute;

  @override
  GuardResult call(RouteNode origin, RouteNode target, GuardContext context) {
    final mutableTarget = target.toMutable();
    final tabNode = mutableTarget.findByRoute(tabRoute);

    if (tabNode != null && tabNode.children.isEmpty) {
      tabNode.setChildren([childRoute.toNode()]);
      return GuardResult.redirect(target: mutableTarget);
    }

    return const GuardResult.next();
  }
}
