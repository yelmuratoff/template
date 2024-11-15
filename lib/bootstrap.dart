import 'dart:async';

import 'package:base_starter/src/app/logic/app_runner.dart';
import 'package:base_starter/src/common/utils/extensions/talker.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
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
    onError: (error, stackTrace) {
      _onErrorFactory(
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
void _onInitializing(String stepName) {
  ISpect.info('🌀 Inited $stepName');
}

/// `_onInitialized` is a callback function that is called when
/// the initialization process is completed.
void _onInitialized(CompositionResult result) {
  ISpect.good(
    '''🎉 Initialization completed in ${result.millisecondsSpent} ms\nResult: $result''',
  );
}

/// `_onErrorFactory` is a factory function that creates an error
/// handling function.
void _onErrorFactory(
  Object? error,
  StackTrace stackTrace,
  InitializationHook hook,
) {
  ISpect.error(
    message: '❗️ Initialization failed with error: $error',
  );
  FlutterNativeSplash.remove();
  runApp(
    InitializationFailedApp(
      error: error ?? Exception('Unknown error'),
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
