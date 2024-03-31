// ignore_for_file: inference_failure_on_function_invocation

import 'package:base_starter/src/common/configs/constants.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/core/resource/data/database/src/secure_storage.dart';
import 'package:base_starter/src/core/resource/data/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/core/resource/data/dio_rest_client/src/interceptor/dio_interceptor.dart';
import 'package:base_starter/src/core/resource/domain/token/token_pair.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Rest client that uses `Dio` as HTTP library.
final class RestClientDio extends RestClientBase {
  final Dio? dio;
  final String? baseUrl;
  RestClientDio({
    this.dio,
    this.baseUrl,
  });

  /// Send [Dio] request
  @protected
  @visibleForTesting
  Future<Map<String, Object?>?> sendRequest<T extends Object>({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    try {
      final uri = buildUri(path: path, queryParams: queryParams);
      final options = Options(
        headers: headers,
        method: method,
        contentType: 'application/json',
        responseType: ResponseType.json,
      );

      final response =
          await (dio ?? DioClient(baseUrl: baseUrl).dio).request<T>(
        uri.toString(),
        data: body,
        options: options,
      );

      final resp = await decodeResponse(
        response.data,
        statusCode: response.statusCode,
      );

      return resp;
    } on RestClientException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
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
        );

        return result;
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
  Future<Map<String, Object?>?> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      sendRequest(
        path: path,
        method: 'DELETE',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      sendRequest(
        path: path,
        method: 'GET',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      sendRequest(
        path: path,
        method: 'PATCH',
        body: body,
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      sendRequest(
        path: path,
        method: 'POST',
        body: body,
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      sendRequest(
        path: path,
        method: 'PUT',
        body: body,
        headers: headers,
        queryParams: queryParams,
      );
}

class DioClient {
  static DioClient? _instance;
  final Dio dio;

  factory DioClient({String? baseUrl}) {
    _instance ??= DioClient._internal(baseUrl ?? AppConstants.baseUrl);
    return _instance!;
  }

  DioClient._internal(String baseUrl)
      : dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _initInterceptors();
  }

  void _initInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final TokenPair? tokenModel = await SecureStorageService.getToken();
          if (tokenModel != null) {
            options.headers['Authorization'] = 'Bearer ${tokenModel.access}';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // If a 401 response is received, refresh the access token
            final TokenPair? oldToken = await SecureStorageService.getToken();
            final TokenPair? newToken = await dio.post(
              /// TODO: Add the refresh token endpoint
              'api/v1/auth/refresh-token',
              options: Options(
                sendTimeout: const Duration(milliseconds: 30000),
                receiveTimeout: const Duration(milliseconds: 60000),
                headers: {
                  "Content-Type": "application/json",
                },
              ),
              data: {
                "refresh": oldToken?.refresh,
              },
            ).then(
              (value) => TokenPair.fromJson(value.data as Map<String, dynamic>),
            );

            // Update the request header with the new access token
            e.requestOptions.headers['Authorization'] =
                'Bearer ${newToken?.access}';
            await SecureStorageService.setToken(newToken);

            // Repeat the request with the updated header
            return handler.resolve(await dio.fetch(e.requestOptions));
          }
          return handler.next(e);
        },
      ),
    );

    /// Adds `TalkerDioLogger` to intercept Dio requests and responses and log them using Talker service.
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          errorPen: AnsiPen()..red(bold: true),
        ),
      ),
    );

    dio.interceptors.add(ErrorInterceptor());
  }
}
