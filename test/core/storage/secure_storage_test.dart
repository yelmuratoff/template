import 'package:base_starter/src/core/database/src/preferences/secure_storage.dart';
import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:checks/checks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('FlutterSecureStorageWrapper', () {
    late _MockFlutterSecureStorage platformStorage;
    late SecureStorage storage;

    setUp(() {
      platformStorage = _MockFlutterSecureStorage();
      storage = FlutterSecureStorageWrapper(storage: platformStorage);
    });

    test('returns the stored value when the platform read succeeds', () async {
      when(
        () => platformStorage.read(key: 'token'),
      ).thenAnswer((_) async => 'secret');

      check(await storage.read(key: 'token')).equals('secret');
    });

    test('throws CacheException with the original cause '
        'when the platform read fails', () async {
      final failure = Exception('keychain unavailable');
      when(() => platformStorage.read(key: 'token')).thenThrow(failure);

      try {
        await storage.read(key: 'token');
        fail('Expected a CacheException');
      } on CacheException catch (e, st) {
        check(e.cause).equals(failure);
        check(st.toString()).isNotEmpty();
      }
    });

    test('throws CacheException when the platform write fails', () async {
      when(
        () => platformStorage.write(key: 'token', value: 'v'),
      ).thenThrow(Exception('disk full'));

      await expectLater(
        () => storage.write(key: 'token', value: 'v'),
        throwsA(isA<CacheException>()),
      );
    });

    test('delegates delete and deleteAll to the platform storage', () async {
      when(() => platformStorage.delete(key: 'token')).thenAnswer((_) async {});
      when(() => platformStorage.deleteAll()).thenAnswer((_) async {});

      await storage.delete(key: 'token');
      await storage.deleteAll();

      verify(() => platformStorage.delete(key: 'token')).called(1);
      verify(() => platformStorage.deleteAll()).called(1);
    });
  });
}
