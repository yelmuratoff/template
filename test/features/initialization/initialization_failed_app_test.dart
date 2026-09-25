import 'dart:async';

import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/initialization/presentation/widget/initialization_failed_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() => L10n.load(const Locale('en')));

  group('InitializationFailedApp', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    testWidgets('keeps the error and stack trace off screen by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        InitializationFailedApp(
          error: StateError('boom'),
          stackTrace: StackTrace.current,
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text(L10n.current.initializationFailed), findsOneWidget);
      expect(find.textContaining('StackTrace'), findsNothing);
      expect(find.textContaining('boom'), findsNothing);
    });

    testWidgets('a retry that replaces the app does not touch disposed state', (
      tester,
    ) async {
      final retry = Completer<void>();
      await tester.pumpWidget(
        InitializationFailedApp(
          error: StateError('boom'),
          stackTrace: StackTrace.current,
          retryInitialization: () => retry.future,
        ),
      );
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text(L10n.current.retry));
      await tester.pumpWidget(const SizedBox());
      retry.complete();
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('shows the error and stack trace when details are enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        InitializationFailedApp(
          error: StateError('boom'),
          stackTrace: StackTrace.current,
          showErrorDetails: true,
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('boom'), findsOneWidget);
      expect(find.textContaining('StackTrace'), findsOneWidget);
    });
  });
}
