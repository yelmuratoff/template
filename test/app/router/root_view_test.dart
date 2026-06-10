// ignore_for_file: experimental_member_use

import 'package:base_starter/src/app/presentation/screens/root_screen.dart';
import 'package:base_starter/src/app/router/routes/app_routes.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yx_navigation/yx_navigation.dart';

class _FakeActiveRouteController implements ActiveRouteController {
  YxRoute? active = AppRoutes.homeTab;
  final tapped = <YxRoute>[];

  @override
  YxRoute? get activeRoute => active;

  @override
  Stream<YxRoute?> get activeRouteStream => const Stream.empty();

  @override
  bool isRouteActive(YxRoute route) => route == active;

  @override
  void setActiveRoute(YxRoute route) {
    tapped.add(route);
    active = route;
  }
}

void main() {
  setUpAll(() => L10n.load(const Locale('en')));

  group('RootView', () {
    testWidgets('renders the home and profile tabs', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RootView(
            controller: _FakeActiveRouteController(),
            child: const SizedBox(),
          ),
        ),
      );

      expect(find.text(L10n.current.home), findsOneWidget);
      expect(find.text(L10n.current.profile), findsOneWidget);
    });

    testWidgets('tapping a tab switches the active route', (tester) async {
      final controller = _FakeActiveRouteController();

      await tester.pumpWidget(
        MaterialApp(
          home: RootView(controller: controller, child: const SizedBox()),
        ),
      );

      await tester.tap(find.text('Profile'));
      await tester.pump();

      check(controller.tapped).deepEquals([AppRoutes.profileTab]);
    });
  });
}
