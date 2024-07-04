import 'dart:ui';

import 'package:base_starter/src/features/initialization/logic/initialization_processor.dart';
import 'package:base_starter/src/features/initialization/models/dependencies.dart';

/// A hook for the initialization process.
///
/// The `onInit` is called before the initialization process starts.
///
/// The `onInitializing` is called when the
/// initialization process is in progress.
///
/// The `onInitialized` is called when the initialization process is finished.
///
/// The `onError` is called when the initialization process is failed.
abstract interface class InitializationHook {
  const InitializationHook({
    this.onInit,
    this.onInitializing,
    this.onInitialized,
    this.onError,
  });

  /// Setup the initialization hook.
  factory InitializationHook.setup({
    VoidCallback? onInit,
    void Function(InitializationStepInfo info)? onInitializing,
    void Function(InitializationResult result)? onInitialized,
    void Function(int percent, Object error, StackTrace stackTrace)? onError,
  }) = _Hook;

  /// Called before the initialization process starts.
  final VoidCallback? onInit;

  /// Called when the initialization process is in progress.
  final void Function(InitializationStepInfo info)? onInitializing;

  /// Called when the initialization process is finished.
  final void Function(InitializationResult result)? onInitialized;

  /// Called when the initialization process is failed.
  final void Function(int percent, Object error, StackTrace stackTrace)?
      onError;
}

final class _Hook extends InitializationHook {
  const _Hook({
    super.onInit,
    super.onInitializing,
    super.onInitialized,
    super.onError,
  });
}
