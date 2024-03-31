import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/common/utils/talker_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderLoggerObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    talker.logTyped(
      ProviderLog('Provider ${provider.name} was initialized with $value'),
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    talker.logTyped(
      ProviderLog('Provider ${provider.name} was disposed'),
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    talker.logTyped(
      ProviderLog(
        'Provider ${provider.name} was updated from $previousValue to $newValue',
      ),
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    talker.handle(
      error,
      stackTrace,
      'Provider ${provider.name} failed with error $error',
    );
  }
}
