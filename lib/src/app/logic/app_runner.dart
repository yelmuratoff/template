import 'dart:async';

import 'package:base_starter/src/app/presentation/widget/app.dart';
import 'package:base_starter/src/common/presentation/pages/restart_wrapper.dart';
import 'package:base_starter/src/features/initialization/logic/initialization_processor.dart';
import 'package:base_starter/src/features/initialization/logic/initialization_steps.dart';
import 'package:base_starter/src/features/initialization/models/initialization_hook.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ispect/ispect.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

/// A class which is responsible for initialization and running the app.
final class AppRunner
    with
        InitializationSteps,
        InitializationProcessor,
        InitializationFactoryImpl {
  /// Start the initialization and in case of success run application
  Future<void> initializeAndRun(
    InitializationHook hook,
  ) async {
    final binding = WidgetsFlutterBinding.ensureInitialized()
      ..deferFirstFrame();

    // Preserve splash screen
    FlutterNativeSplash.preserve(widgetsBinding: binding);

    // Setup bloc observer and transformer
    Bloc.transformer = bloc_concurrency.sequential();
    Future<void> initializeAndRun(InitializationHook hook) async {
      try {
        final result = await processInitialization(
          steps: initializationSteps,
          hook: hook,
          factory: this,
        );

        FlutterNativeSplash.remove();

        runApp(
          ProviderScope(
            observers: [
              TalkerRiverpodObserver(
                talker: ISpect.talker,
              ),
            ],
            child: RestartWrapper(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: result.dependencies.authBloc,
                  ),
                  BlocProvider.value(
                    value: result.dependencies.userCubit,
                  ),
                ],
                child: App(
                  result: result,
                ),
              ),
            ),
          ),
        );
      } catch (e) {
        rethrow;
      } finally {
        binding.allowFirstFrame();
      }
    }

    await initializeAndRun(hook);
  }
}
