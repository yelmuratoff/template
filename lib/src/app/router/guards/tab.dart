import 'dart:async';

import 'package:base_starter/src/app/presentation/page/root.dart';
import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:octopus/octopus.dart';

/// Do not allow any nested routes at `root` inderectly except of `*-tab`.
class TabGuard extends OctopusGuard {
  TabGuard();

  static final String _homeTab = '${RootTabsEnum.home.name}-tab';
  static final String _profileTab = '${RootTabsEnum.profile.name}-tab';

  @override
  FutureOr<OctopusState> call(
    List<OctopusHistoryEntry> history,
    OctopusState$Mutable state,
    Map<String, Object?> context,
  ) {
    final shop = state.findByName(Routes.root.name);
    if (shop == null) return state; // Do nothing if `shop` not found.

    // Remove all nested routes except of `*-tab`.
    shop.removeWhere(
      (node) => node.name != _homeTab && node.name != _profileTab,
      recursive: false,
    );
    // Upsert catalog tab node if not exists.
    final catalog =
        shop.putIfAbsent(_homeTab, () => OctopusNode.mutable(_homeTab));
    if (!catalog.hasChildren) {
      catalog.add(OctopusNode.mutable(Routes.home.name));
    }
    // Upsert basket tab node if not exists.
    final basket =
        shop.putIfAbsent(_profileTab, () => OctopusNode.mutable(_profileTab));
    if (!basket.hasChildren) {
      basket.add(OctopusNode.mutable(Routes.profile.name));
    }

    return state;
  }
}
