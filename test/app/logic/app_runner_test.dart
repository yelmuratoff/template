import 'package:base_starter/src/app/logic/app_runner.dart';
import 'package:base_starter/src/features/initialization/models/initialization_hook.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRunner.initializeAndRun', () {
    testWidgets('hands a failed composition to the hook without rethrowing', (
      tester,
    ) async {
      final reported = <Object?>[];
      final hook = InitializationHook.setup(
        onError: (error, _) => reported.add(error),
      );

      await AppRunner().initializeAndRun(hook);

      check(reported).single.isA<StateError>();
    });
  });
}
