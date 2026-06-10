import 'package:base_starter/src/common/presentation/widgets/buttons/app_button.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/auth/presentation/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => L10n.load(const Locale('en')));

  group('AuthView', () {
    testWidgets('tapping the login button fires the callback', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(home: AuthView(onLoginPressed: () => pressed = true)),
      );

      await tester.tap(find.byType(AppButton));

      expect(pressed, isTrue);
    });
  });
}
