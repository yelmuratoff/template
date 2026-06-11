import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserDTO.fromMap', () {
    // Mirrors the escuelajs `/auth/profile` payload, which uses camelCase
    // `creationAt`/`updatedAt`.
    const apiPayload = <String, dynamic>{
      'id': 1,
      'email': 'john@mail.com',
      'name': 'Jhon',
      'role': 'customer',
      'avatar': 'https://example.com/a.png',
      'creationAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': '2024-02-01T00:00:00.000Z',
    };

    test('parses the camelCase API payload', () {
      final user = UserDTO.fromMap(apiPayload);

      check(user.id).equals(1);
      check(user.email).equals('john@mail.com');
      check(user.creationAt).equals('2024-01-01T00:00:00.000Z');
      check(user.updatedAt).equals('2024-02-01T00:00:00.000Z');
    });

    test('round-trips through toMap so the local cache stays consistent', () {
      final user = UserDTO.fromMap(apiPayload);

      check(UserDTO.fromMap(user.toMap())).equals(user);
    });

    test('throws when a required field is missing', () {
      final map = Map<String, dynamic>.from(apiPayload)..remove('creationAt');

      check(() => UserDTO.fromMap(map)).throws<ArgumentError>();
    });
  });
}
