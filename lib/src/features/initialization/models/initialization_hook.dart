import 'package:base_starter/src/features/initialization/logic/composition_root.dart';

/// A hook for the initialization process.
///
/// The `onInitialized` is called when the initialization process is finished.
///
/// The `onError` is called when the initialization process fails.
abstract interface class InitializationHook {
  const InitializationHook({this.onInitialized, this.onError});

  /// Setup the initialization hook.
  factory InitializationHook.setup({
    void Function(CompositionResult result)? onInitialized,
    void Function(Object? error, StackTrace stackTrace)? onError,
  }) = _Hook;

  /// Called when the initialization process is finished.
  final void Function(CompositionResult result)? onInitialized;

  /// Called when the initialization process fails.
  final void Function(Object? error, StackTrace stackTrace)? onError;
}

final class _Hook extends InitializationHook {
  const _Hook({super.onInitialized, super.onError});
}
