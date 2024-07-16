// ignore_for_file: no-empty-block

import 'dart:convert';

import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _generateJsonData(int length) => {
      'data': {
        'list': List.generate(length, (_) => {'test': 'test'}),
      },
    };

void main() {
  group('RestClient >', () {
    group('encodeBody >', () {
      test('Should encode body', () {
        final restClient = _RestClientBase();
        final result = restClient.encodeBody({'test': 'test'});
        expect(
          result,
          equals([
            123,
            34,
            116,
            101,
            115,
            116,
            34,
            58,
            34,
            116,
            101,
            115,
            116,
            34,
            125,
          ]),
        );
      });
      test('Should encode empty body', () {
        final restClient = _RestClientBase();
        final result = restClient.encodeBody({});
        expect(result, equals([123, 125]));
      });

      test('Should throw error on wrong body', () {
        final restClient = _RestClientBase();
        expect(
          () => restClient.encodeBody({'wrong': Object()}),
          throwsA(isA<ClientException>()),
        );
      });
    });
    group('decodeResponse >', () {
      test('Should decode String', () {
        final restClient = _RestClientBase();
        const response = '{"data": {"test": "test"}}';
        final result = restClient.decodeResponse(response);
        expect(result, completion(equals({'test': 'test'})));
      });

      test('Should decode List<int>', () {
        final restClient = _RestClientBase();
        const response = [123, 34, 100, 97, 116, 97, 34, 58, 123, 125, 125];
        final result = restClient.decodeResponse(response);
        expectLater(result, completion(equals({})));
      });

      test('Should decode Map<String, Object?>', () {
        final restClient = _RestClientBase();
        const response = {
          'data': {'test': 'test'},
        };
        final result = restClient.decodeResponse(response);
        expect(result, completion(equals({'test': 'test'})));
      });

      test('Should throw WrongResponseTypeException', () {
        final restClient = _RestClientBase();
        const response = 123;
        final result = restClient.decodeResponse(response);
        expect(result, throwsA(isA<WrongResponseTypeException>()));
      });

      test('Is not empty', () {
        final restClient = _RestClientBase();
        const response = {'test': 'test'};
        final result = restClient.decodeResponse(response);
        expect(result, completion(isNotNull));
      });

      test('Return null when null response', () {
        final restClient = _RestClientBase();
        final result = restClient.decodeResponse(null);
        expect(result, completion(isNull));
      });

      test('Throw if error field in JSON', () {
        final restClient = _RestClientBase();
        const response = '{"error": {"message": "test"}}';
        final result = restClient.decodeResponse(response);
        expect(result, throwsA(isA<CustomBackendException>()));
      });

      test('If length is > 10000, compute in Isolate', () {
        final data = _generateJsonData(10000);
        final bytes = utf8.encode(jsonEncode(data));

        final restClient = _RestClientBase();

        final result = restClient.decodeResponse(bytes);

        expect(result, completion(data['data']));
      });
    });
  });
}

/// Class used to test RestClientBase
///
/// Other methods are just stubs
final class _RestClientBase extends RestClientBase {
  _RestClientBase() : super(baseUrl: '');

  @override
  Future<Map<String, Object?>> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> patch(
    String path, {
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> post(
    String path, {
    Object? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> put(
    String path, {
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) async {
    throw UnimplementedError();
  }
}
