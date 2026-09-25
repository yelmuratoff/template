import 'dart:async';

import 'package:base_starter/src/app/presentation/widgets/app.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:base_starter/src/features/initialization/models/initialization_hook.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ui/ui.dart';

/// A class which is responsible for initialization and running the app.
final class AppRunner {
  /// Start the initialization and in case of success run application.
  ///
  /// A failure is reported to [InitializationHook.onError] only, so a retry
  /// can call this again.
  Future<void> initializeAndRun(InitializationHook hook) async {
    final binding = WidgetsFlutterBinding.ensureInitialized()
      ..deferFirstFrame();

    // Preserve splash screen
    FlutterNativeSplash.preserve(widgetsBinding: binding);

    // Setup bloc observer and transformer
    Bloc.transformer = bloc_concurrency.sequential();

    try {
      final result = await const CompositionRoot().compose();

      hook.onInitialized?.call(result);

      FlutterNativeSplash.remove();

      runApp(RestartWrapper(child: App(result: result)));
    } on Object catch (e, st) {
      hook.onError?.call(e, st);
    } finally {
      binding.allowFirstFrame();
    }
  }
}
