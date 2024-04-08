import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ispect/ispect.dart';

class ProviderLoggerObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    talkerWrapper.provider(
      message: 'Provider ${provider.name} was initialized with $value',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    talkerWrapper.provider(
      message: 'Provider ${provider.name} was disposed',
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    talkerWrapper.provider(
      message:
          'Provider ${provider.name} was updated from $previousValue to $newValue',
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    talkerWrapper.handle(
      exception: error,
      stackTrace: stackTrace,
      message: 'Provider ${provider.name} failed with error $error',
    );
  }
}
