// ignore_for_file: inference_failure_on_function_invocation

import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

/// Rest client that uses `Dio` as HTTP library.
///
/// Operates on a single externally configured [Dio] instance (see
/// `DioClient`); constructing transports per request is forbidden — it
/// re-creates interceptors and breaks the shared auth/refresh state.
final class RestClientDio extends RestClientBase {
  RestClientDio({required this.baseUrl, required this._dio})
    : super(baseUrl: baseUrl);

  final Dio _dio;
  final String baseUrl;

  /// Send [Dio] request
  @protected
  @visibleForTesting
  Future<Map<String, Object?>> sendRequest<T extends Object>({
    required String path,
    required String method,
    Object? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) async {
    try {
      final uri = buildUri(path: path, queryParams: queryParams);

      final options = Options(
        headers: headers,
        method: method,
        contentType: 'application/json',
        responseType: ResponseType.json,
      );

      final response = await _dio.request<T>(
        uri.toString(),
        data: body,
        options: options,
      );

      final resp = await decodeResponse(
        response.data,
        statusCode: response.statusCode,
        returnFullData: returnFullData,
      );

      if (resp == null) {
        throw WrongResponseTypeException(
          message: 'Unexpected response body type: ${body.runtimeType}',
          statusCode: response.statusCode,
        );
      }
      return resp;
    } on RestClientException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        Error.throwWithStackTrace(
          RequestTimeoutException(
            message: e.message ?? 'Request timed out',
            statusCode: e.response?.statusCode,
            cause: e,
          ),
          e.stackTrace,
        );
      }
      if (e.type == DioExceptionType.connectionError) {
        Error.throwWithStackTrace(
          ConnectionException(
            message: e.message ?? 'Connection exception',
            statusCode: e.response?.statusCode,
            cause: e,
          ),
          e.stackTrace,
        );
      }
      if (e.response != null) {
        final result = await decodeResponse(
          e.response?.data,
          statusCode: e.response?.statusCode,
          returnFullData: returnFullData,
        );

        throw CustomBackendException(
          message: e.response?.statusMessage ?? 'Backend returned custom error',
          error: result ?? {},
          statusCode: e.response?.statusCode,
        );
      }
      Error.throwWithStackTrace(
        ClientException(
          message: e.message ?? 'Client exception',
          statusCode: e.response?.statusCode,
          cause: e,
        ),
        e.stackTrace,
      );
    } on Object catch (e, stack) {
      Error.throwWithStackTrace(
        ClientException(message: e.toString(), cause: e),
        stack,
      );
    }
  }

  @override
  Future<Map<String, Object?>> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) => sendRequest(
    path: path,
    method: 'DELETE',
    headers: headers,
    queryParams: queryParams,
    returnFullData: returnFullData,
  );

  @override
  Future<Map<String, Object?>> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) => sendRequest(
    path: path,
    method: 'GET',
    headers: headers,
    queryParams: queryParams,
    returnFullData: returnFullData,
  );

  @override
  Future<Map<String, Object?>> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) => sendRequest(
    path: path,
    method: 'PATCH',
    body: body,
    headers: headers,
    queryParams: queryParams,
    returnFullData: returnFullData,
  );

  @override
  Future<Map<String, Object?>> post(
    String path, {
    required Object? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) => sendRequest(
    path: path,
    method: 'POST',
    body: body,
    headers: headers,
    queryParams: queryParams,
    returnFullData: returnFullData,
  );

  @override
  Future<Map<String, Object?>> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  }) => sendRequest(
    path: path,
    method: 'PUT',
    body: body,
    headers: headers,
    queryParams: queryParams,
    returnFullData: returnFullData,
  );
}
