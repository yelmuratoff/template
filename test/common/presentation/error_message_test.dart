import 'package:base_starter/src/common/presentation/error_message.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:checks/checks.dart';
import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => L10n.load(const Locale('en')));

  group('localizedErrorMessage', () {
    test('a network failure asks the user to check the connection', () {
      check(
        localizedErrorMessage(
          const NetworkException(message: 'SocketException'),
        ),
      ).equals(L10n.current.errorNoConnection);
    });

    test('a timeout says the server took too long', () {
      check(
        localizedErrorMessage(const TimeoutAppException(message: 'receive')),
      ).equals(L10n.current.errorTimeout);
    });

    test('a revoked session asks the user to sign in again', () {
      check(
        localizedErrorMessage(const RevokedTokenException()),
      ).equals(L10n.current.errorSessionExpired);
    });

    test('any other failure falls back to a generic message without '
        'leaking its technical text', () {
      const backend = BackendException(
        message: 'Backend returned custom error',
        error: {'trace': 'at Controller.login'},
        statusCode: 500,
      );

      check(localizedErrorMessage(backend)).equals(L10n.current.errorUnknown);
      check(
        localizedErrorMessage(StateError('bug')),
      ).equals(L10n.current.errorUnknown);
    });
  });
}
