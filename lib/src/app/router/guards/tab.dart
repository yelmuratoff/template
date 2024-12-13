import 'dart:async';

import 'package:base_starter/src/app/router/enums/root_tabs_enum.dart';
import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:octopus/octopus.dart';

/// Do not allow any nested routes at `root` inderectly except of `*-tab`.
class TabGuard extends OctopusGuard {
  TabGuard();

  static final _homeTab = RootTabsEnum.home.bucket;
  static final _profileTab = RootTabsEnum.profile.bucket;

  @override
  FutureOr<OctopusState> call(
    List<OctopusHistoryEntry> history,
    OctopusState$Mutable state,
    Map<String, Object?> context,
  ) {
    final root = state.findByName(Routes.root.name);
    if (root == null) return state; // Do nothing if `root` not found.

    // Remove all nested routes except of `*-tab`.
    root.removeWhere(
      (node) => node.name != _homeTab && node.name != _profileTab,
      recursive: false,
    );
    // Upsert home tab node if not exists.
    final home =
        root.putIfAbsent(_homeTab, () => OctopusNode.mutable(_homeTab));
    if (!home.hasChildren) {
      home.add(OctopusNode.mutable(Routes.home.name));
    }

    // Upsert basket tab node if not exists.
    final profile =
        root.putIfAbsent(_profileTab, () => OctopusNode.mutable(_profileTab));
    if (!profile.hasChildren) {
      profile.add(OctopusNode.mutable(Routes.profile.name));
    }

    return state;
  }
}
