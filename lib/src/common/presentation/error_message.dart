import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:core/core.dart';

/// Returns the localized text to show a user for [error].
///
/// Technical details (exception messages, backend payloads) never reach the
/// UI; they stay in the logs written at the BLoC boundary.
String localizedErrorMessage(Object error) => switch (error) {
  NetworkException() => L10n.current.errorNoConnection,
  TimeoutAppException() => L10n.current.errorTimeout,
  RevokedTokenException() => L10n.current.errorSessionExpired,
  _ => L10n.current.errorUnknown,
};
