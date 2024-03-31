import 'package:base_starter/src/feature/initialization/logic/initialization_steps.dart';
import 'package:base_starter/src/feature/initialization/model/dependencies.dart';
import 'package:base_starter/src/feature/initialization/model/environment_store.dart';
import 'package:base_starter/src/feature/initialization/model/initialization_hook.dart';
import 'package:base_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:flutter/foundation.dart';

part 'initialization_factory.dart';

/// A class which is responsible for processing initialization steps.
mixin InitializationProcessor {
  /// Process initialization steps.
  Future<InitializationResult> processInitialization({
    required Map<String, StepAction> steps,
    required InitializationFactory factory,
    required InitializationHook hook,
  }) async {
    final stopwatch = Stopwatch()..start();
    var stepCount = 0;
    final env = factory.getEnvironmentStore();
    final progress = InitializationProgress(
      dependencies: Dependencies(),
      environmentStore: env,
      repositories: Repositories(),
    );

    if (!kDebugMode) {}
    hook.onInit?.call();
    // talker.info(
    //   "🔉 ${config.appName} app started in ${config.flavor} mode",
    // );
    try {
      await for (final step in Stream.fromIterable(steps.entries)) {
        stepCount++;
        final stopWatch = Stopwatch()..start();
        await step.value(progress);
        hook.onInitializing?.call(
          InitializationStepInfo(
            stepName: step.key,
            step: stepCount,
            stepsCount: steps.length,
            msSpent: (stopWatch..stop()).elapsedMilliseconds,
          ),
        );
      }
    } catch (e, st) {
      hook.onError?.call(stepCount, e, st);
      rethrow;
    }
    stopwatch.stop();
    final result = InitializationResult(
      dependencies: progress.dependencies,
      repositories: progress.repositories,
      stepCount: stepCount,
      msSpent: stopwatch.elapsedMilliseconds,
    );
    hook.onInitialized?.call(result);
    return result;
  }
}

/// A class which contains information about initialization step.
class InitializationStepInfo {
  const InitializationStepInfo({
    required this.stepName,
    required this.step,
    required this.stepsCount,
    required this.msSpent,
  });

  /// The number of the step.
  final int step;

  /// The name of the step.
  final String stepName;

  /// The total number of steps.
  final int stepsCount;

  /// The number of milliseconds spent on the step.
  final int msSpent;
}
