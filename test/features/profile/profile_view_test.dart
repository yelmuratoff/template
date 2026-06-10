import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

void main() {
  const user = UserDTO(
    id: 1,
    email: 'ann@mail.com',
    name: 'Ann',
    role: 'admin',
    avatar: 'url',
    creationAt: '2024',
    updatedAt: '2024',
  );

  setUpAll(() => L10n.load(const Locale('en')));

  Widget host({
    required VoidCallback onSettings,
    required VoidCallback onLogout,
    UserDTO? userData,
  }) => MaterialApp(
    home: ProfileView(
      user: userData,
      onSettingsPressed: onSettings,
      onLogoutPressed: onLogout,
    ),
  );

  group('ProfileView', () {
    testWidgets('renders the loaded user name and email', (tester) async {
      await tester.pumpWidget(
        host(userData: user, onSettings: () {}, onLogout: () {}),
      );

      expect(find.text('Ann'), findsOneWidget);
      expect(find.text('ann@mail.com'), findsOneWidget);
    });

    testWidgets('tapping the settings action fires the callback', (
      tester,
    ) async {
      var opened = false;
      await tester.pumpWidget(
        host(userData: user, onSettings: () => opened = true, onLogout: () {}),
      );

      await tester.tap(find.byIcon(IconsaxPlusLinear.setting_2));

      expect(opened, isTrue);
    });

    testWidgets('tapping logout fires the callback', (tester) async {
      var loggedOut = false;
      await tester.pumpWidget(
        host(
          userData: user,
          onSettings: () {},
          onLogout: () => loggedOut = true,
        ),
      );

      await tester.tap(find.text(L10n.current.logout));

      expect(loggedOut, isTrue);
    });
  });
}
