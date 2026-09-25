import 'dart:convert';

import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:checks/checks.dart';
import 'package:core/core.dart';
import 'package:database/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rest_client/rest_client.dart';

class _MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group('SecureTokenStorage', () {
    const pair = TokenPair(access: 'a1', refresh: 'r1');
    final encodedPair = json.encode(pair.toJson());

    late _MockSecureStorage secureStorage;
    late SecureTokenStorage storage;

    setUp(() {
      secureStorage = _MockSecureStorage();
      storage = SecureTokenStorage(storage: secureStorage);
    });

    tearDown(() async {
      await storage.dispose();
    });

    test('returns the stored pair when the persisted JSON is valid', () async {
      when(
        () => secureStorage.read(key: Preferences.tokenPair),
      ).thenAnswer((_) async => encodedPair);

      check(await storage.read()).equals(pair);
    });

    test('returns null when nothing is stored', () async {
      when(
        () => secureStorage.read(key: Preferences.tokenPair),
      ).thenAnswer((_) async => null);

      check(await storage.read()).isNull();
    });

    test('resets the entry and reports signed-out '
        'when the persisted value is corrupt', () async {
      when(
        () => secureStorage.read(key: Preferences.tokenPair),
      ).thenAnswer((_) async => 'not-json');
      when(
        () => secureStorage.delete(key: Preferences.tokenPair),
      ).thenAnswer((_) async {});

      final emitted = <TokenPair?>[];
      final subscription = storage.changes.listen(emitted.add);

      check(await storage.read()).isNull();
      verify(() => secureStorage.delete(key: Preferences.tokenPair)).called(1);

      await pumpEventQueue();
      check(emitted).deepEquals([null]);
      await subscription.cancel();
    });

    test('persists the encoded pair and emits it on save', () async {
      when(
        () =>
            secureStorage.write(key: Preferences.tokenPair, value: encodedPair),
      ).thenAnswer((_) async {});

      final emitted = <TokenPair?>[];
      final subscription = storage.changes.listen(emitted.add);

      await storage.save(pair);

      verify(
        () =>
            secureStorage.write(key: Preferences.tokenPair, value: encodedPair),
      ).called(1);
      await pumpEventQueue();
      check(emitted).deepEquals([pair]);
      await subscription.cancel();
    });

    test('reads secure storage once across repeated reads', () async {
      when(
        () => secureStorage.read(key: Preferences.tokenPair),
      ).thenAnswer((_) async => encodedPair);

      await storage.read();
      check(await storage.read()).equals(pair);

      verify(() => secureStorage.read(key: Preferences.tokenPair)).called(1);
    });

    test('serves a saved pair without reading secure storage', () async {
      when(
        () =>
            secureStorage.write(key: Preferences.tokenPair, value: encodedPair),
      ).thenAnswer((_) async {});

      await storage.save(pair);

      check(await storage.read()).equals(pair);
      verifyNever(() => secureStorage.read(key: Preferences.tokenPair));
    });

    test('reports signed-out after clear without reading secure '
        'storage', () async {
      when(
        () => secureStorage.read(key: Preferences.tokenPair),
      ).thenAnswer((_) async => encodedPair);
      when(
        () => secureStorage.delete(key: Preferences.tokenPair),
      ).thenAnswer((_) async {});
      await storage.read();

      await storage.clear();

      check(await storage.read()).isNull();
      verify(() => secureStorage.read(key: Preferences.tokenPair)).called(1);
    });

    test('retries secure storage after a failed read', () async {
      var calls = 0;
      when(() => secureStorage.read(key: Preferences.tokenPair)).thenAnswer((
        _,
      ) async {
        if (calls++ == 0) throw const CacheException(message: 'locked');
        return encodedPair;
      });

      await check(storage.read()).throws<CacheException>();

      check(await storage.read()).equals(pair);
    });

    test('deletes the entry and emits null on clear', () async {
      when(
        () => secureStorage.delete(key: Preferences.tokenPair),
      ).thenAnswer((_) async {});

      final emitted = <TokenPair?>[];
      final subscription = storage.changes.listen(emitted.add);

      await storage.clear();

      verify(() => secureStorage.delete(key: Preferences.tokenPair)).called(1);
      await pumpEventQueue();
      check(emitted).deepEquals([null]);
      await subscription.cancel();
    });
  });
}
