import 'package:base_starter/src/core/database/src/preferences/secure_storage_manager.dart';
import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:dio/dio.dart';
import 'package:ispect/ispect.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class DioClient {
  factory DioClient({
    required String baseUrl,
    required Interceptor interceptor,
    Dio? initialDio,
  }) =>
      DioClient._internal(
        baseUrl: baseUrl,
        initialDio: initialDio,
        interceptor: interceptor,
      );

  DioClient._internal({
    required String baseUrl,
    required Interceptor interceptor,
    Dio? initialDio,
  }) : dio = initialDio ?? Dio(BaseOptions(baseUrl: baseUrl)) {
    _initInterceptors(
      dioInterceptor: interceptor,
    );
  }

  final Dio dio;

  void _initInterceptors({
    required Interceptor dioInterceptor,
  }) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final tokenModel = await SecureStorageManager.getToken();
          if (tokenModel != null) {
            options.headers['Authorization'] = 'Bearer ${tokenModel.access}';
          }
          return handler.next(options);
        },
        // ignore: prefer_expression_function_bodies
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            try {
              // If a 401 response is received, refresh the access token
              final oldToken = await SecureStorageManager.getToken();

              if (oldToken == null) {
                return handler.next(e);
              }

              // ignore: prefer_async_await
              final newToken = await dio.post<dynamic>(
                // TODO(Yelaman): Change this to your refresh token endpoint
                '/auth/refresh',
                options: Options(
                  sendTimeout: const Duration(milliseconds: 30000),
                  receiveTimeout: const Duration(milliseconds: 60000),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                ),
                data: {
                  'token': oldToken.refresh,
                },
              ).then(
                (value) {
                  if (value.data == null) {
                    return null;
                  }
                  return TokenPair.fromJson(value.data as Map<String, dynamic>);
                },
              );

              if (newToken != null) {
                // Update the request header with the new access token
                e.requestOptions.headers['Authorization'] =
                    'Bearer ${newToken.access}';
                await SecureStorageManager.setToken(value: newToken);

                // Repeat the request with the updated header
                return handler.resolve(await dio.fetch(e.requestOptions));
              } else {
                return handler.reject(
                  DioException(
                    requestOptions: e.requestOptions,
                    response: e.response,
                    error: 'Failed to refresh token',
                  ),
                );
              }
            } catch (refreshError) {
              // Propagate the error from the refresh token request
              return handler.reject(
                DioException(
                  requestOptions: e.requestOptions,
                  response: e.response,
                  error: refreshError,
                ),
              );
            }
          } else if (e.response == null) {
            return handler.reject(e);
          }
          return handler.next(e);
        },
      ),
    );

    /// Adds `TalkerDioLogger` to intercept Dio requests and responses and
    /// log them using Talker service.
    dio.interceptors.add(
      TalkerDioLogger(
        talker: ISpect.talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseData: false,
        ),
      ),
    );

    dio.interceptors.add(dioInterceptor);
  }
}
