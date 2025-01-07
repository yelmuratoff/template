import 'dart:async';

import 'package:base_starter/src/app/presentation/widgets/app.dart';
import 'package:base_starter/src/common/presentation/widgets/restart_wrapper.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:base_starter/src/features/initialization/models/initialization_hook.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// A class which is responsible for initialization and running the app.
final class AppRunner {
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
        final result = await CompositionRoot(
          hook: hook,
        ).compose();

        hook.onInitialized?.call(result);

        FlutterNativeSplash.remove();

        runApp(
          RestartWrapper(
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
        );
      } catch (e, st) {
        hook.onError?.call(e, st);
        rethrow;
      } finally {
        binding.allowFirstFrame();
      }
    }

    await initializeAndRun(hook);
  }
}
