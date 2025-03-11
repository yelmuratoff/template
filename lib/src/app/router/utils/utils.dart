import 'package:base_starter/src/app/router/enums/root_tabs_enum.dart';
import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:octopus/octopus.dart';

extension OctopusExtensionX on Octopus {
  Future<void> tabNavigate({
    required RootTabsEnum tab,
  }) async =>
      setState((state) {
        final node = state.find((n) => n.name == tab.bucket);

        if (node == null) {
          return state..arguments['tab'] = tab.value;
        }

        node.children.clear();

        return state..arguments['tab'] = tab.value;
      });

  Future<void> addNestedRoute({
    required OctopusRoute route,
    RootTabsEnum? tab,
    Map<String, String>? arguments,
  }) async {
    final currentTab = tab ??
        RootTabsEnum.tryParse(
          state.arguments['tab'],
        );
    if (currentTab == null) {
      return push(
        route,
        arguments: arguments,
      );
    } else {
      return setState(
        (state) => state
          ..findByName(currentTab.bucket)?.add(
            route.node(
              arguments: arguments,
            ),
          ),
      );
    }
  }

  Future<void> toRoot({
    RootTabsEnum? tab,
    List<OctopusNode>? children,
  }) async {
    final currentTab = tab ?? RootTabsEnum.home;
    return setState(
      (state) => state
        ..clear()
        ..add(
          Routes.root.node(
            arguments: {
              'tab': currentTab.value,
            },
            children: children,
          ),
        ),
    );
  }

  Future<void> nestedClearAndPush({
    required OctopusRoute route,
    RootTabsEnum? tab,
    Map<String, String>? arguments,
  }) async {
    final currentTab = RootTabsEnum.tryParse(
      state.arguments['tab'],
    );

    await setState((state) {
      if (currentTab == null) {
        return state
          ..add(
            route.node(
              arguments: arguments,
            ),
          );
      }

      final node = state.find((n) => n.name == currentTab.bucket);

      if (node == null) {
        return state..arguments['tab'] = currentTab.value;
      }

      node.children.clear();
      node.add(
        route.node(
          arguments: arguments,
        ),
      );

      return state;
    });
  }

  Future<void> replace({
    required OctopusRoute route,
    RootTabsEnum? tab,
    Map<String, String>? arguments,
  }) async {
    await setState(
      (state) => state
        ..removeLast()
        ..add(
          route.node(
            arguments: arguments,
          ),
        ),
    );
  }

  Future<void> nestedReplace({
    required OctopusRoute route,
    RootTabsEnum? tab,
    Map<String, String>? arguments,
  }) async {
    final currentTab = RootTabsEnum.tryParse(
      state.arguments['tab'],
    );

    await setState((state) {
      if (currentTab == null) {
        return state
          ..removeLast()
          ..add(
            route.node(
              arguments: arguments,
            ),
          );
      }

      final node = state.find((n) => n.name == currentTab.bucket);

      if (node == null) {
        return state..arguments['tab'] = currentTab.value;
      }

      node
        ..removeLast()
        ..add(
          route.node(
            arguments: arguments,
          ),
        );

      return state;
    });
  }
}
