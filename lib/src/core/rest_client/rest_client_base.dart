import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

@immutable
abstract base class RestClientBase implements RestClient {
  RestClientBase({required String baseUrl}) : baseUri = Uri.parse(baseUrl);

  /// The base url for the client
  final Uri baseUri;

  static final _jsonUTF8 = json.fuse(utf8);

  /// Encodes [body] to JSON and then to UTF8
  @protected
  @visibleForTesting
  List<int> encodeBody(Map<String, Object?> body) {
    try {
      return _jsonUTF8.encode(body);
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        ClientException(message: 'Error occured during encoding $e'),
        stackTrace,
      );
    }
  }

  /// Builds [Uri] from [path], [queryParams] and [baseUri]
  @protected
  @visibleForTesting
  Uri buildUri({required String path, Map<String, Object?>? queryParams}) {
    final finalPath = p.url.canonicalize(
      p.join(baseUri.path, path.startsWith('/') ? path.substring(1) : path),
    );

    return baseUri.replace(
      path: finalPath,
      queryParameters: {
        ...baseUri.queryParameters,
        if (queryParams != null) ...queryParams,
      },
    );
  }

  /// Decodes [body] from JSON \ UTF8
  @protected
  @visibleForTesting
  FutureOr<Map<String, Object?>?> decodeResponse(
    Object? body, {
    int? statusCode,
    bool returnFullData = false,
  }) async {
    if (body == null) return null;
    try {
      Map<String, Object?> result;
      if (body is String) {
        if (body.contains('DOCTYPE html')) {
          result = {
            'HTML error': body,
          };
        } else {
          if (body.length > 1000) {
            result = await Isolate.run(
              () => json.decode(body) as Map<String, Object?>,
            );
          } else {
            result = json.decode(body) as Map<String, Object?>;
          }
        }
      } else if (body is Map<String, Object?>) {
        result = body;
      } else if (body is List<int>) {
        if (body.length > 1000) {
          result = await Isolate.run(
            () => _jsonUTF8.decode(body)! as Map<String, Object?>,
          );
        } else {
          result = _jsonUTF8.decode(body)! as Map<String, Object?>;
        }
      } else {
        throw WrongResponseTypeException(
          message: 'Unexpected response body type: ${body.runtimeType}',
          statusCode: statusCode,
        );
      }

      if (result case {'error': final Map<String, Object?> error}) {
        throw CustomBackendException(
          message: 'Backend returned custom error',
          error: error,
          statusCode: statusCode,
        );
      }

      if (!returnFullData) {
        if (result case {'data': final Map<String, Object?> data}) {
          return data;
        }
      }

      /// return null if in your response you have no data key
      /// (data key is required)
      return result;
    } on RestClientException {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        ClientException(
          message: 'Error occured during decoding',
          statusCode: statusCode,
          cause: e,
        ),
        stackTrace,
      );
    }
  }
}
