import 'dart:async';

import 'package:base_starter/src/app/logic/app_runner.dart';
import 'package:base_starter/src/common/utils/extensions/talker.dart';
import 'package:base_starter/src/features/initialization/logic/initialization_processor.dart';
import 'package:base_starter/src/features/initialization/models/dependencies.dart';
import 'package:base_starter/src/features/initialization/models/initialization_hook.dart';
import 'package:base_starter/src/features/initialization/presentation/widget/initialization_failed_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ispect/ispect.dart';

// ==================== Entry fields ====================

///  It is used to handle errors and log messages in the app.
final talker = TalkerFlutter.init();

// ==================== Bootstrap ====================

/// `bootstrap` function is the entry point of the application.
Future<void> bootstrap() async {
  InitializationHook? hook;
  hook = InitializationHook.setup(
    onInitializing: _onInitializing,
    onInitialized: _onInitialized,
    onError: (step, error, stackTrace) {
      _onErrorFactory(
        step,
        error,
        stackTrace,
        hook!,
      );
    },
    onInit: _onInit,
  );

  ISpect.run(
    () => AppRunner().initializeAndRun(
      hook!,
    ),
    talker: talker,
    onZonedError: (_, __) {
      debugPrint('Zoned error');
      //     if (kReleaseMode && envType == EnvType.prod) {
      // FirebaseCrashlytics.instance
      //     .recordError(
      //       error,
      //       stack,
      //       reason: 'runZonedGuarded',
      //     )
      //     .whenComplete(
      //       () => FirebaseCrashlytics.instance.sendUnsentReports(),
      //     );
      // }
    },
  );
}

// ==================== Initialization Callbacks ====================

/// `_onInitializing` is a callback function that is
/// called when the initialization process is started.
void _onInitializing(InitializationStepInfo info) {
  final percentage = ((info.step / info.stepsCount) * 100).toInt();
  ISpect.info(
    '🌀 Inited ${info.stepName} in ${info.msSpent} ms | '
    'Progress: $percentage%',
  );
}

/// `_onInitialized` is a callback function that is called when
/// the initialization process is completed.
void _onInitialized(InitializationResult result) {
  ISpect.good(
    '🎉 Initialization completed in ${result.msSpent} ms',
  );
}

/// `_onErrorFactory` is a factory function that creates an error
/// handling function.
void _onErrorFactory(
  int step,
  Object error,
  StackTrace stackTrace,
  InitializationHook hook,
) {
  ISpect.error(
    message: '❗️ Initialization failed on step $step with error: $error',
  );
  FlutterNativeSplash.remove();
  runApp(
    InitializationFailedApp(
      error: error,
      stackTrace: stackTrace,
      retryInitialization: () => AppRunner().initializeAndRun(hook),
    ),
  );
}

/// `_onInit` is a callback function that is called when the
/// initialization process is started.
void _onInit() {
  talker.info('📱 App started');
}
