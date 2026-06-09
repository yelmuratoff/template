import 'package:dio/dio.dart';
import 'package:ispect/ispect.dart';
import 'package:ispectify_dio/ispectify_dio.dart';

/// Configures the single [Dio] instance the app sends requests through:
/// base URL, explicit timeouts, auth and logging interceptors.
class DioClient {
  DioClient({
    required String baseUrl,
    List<Interceptor> interceptors = const [],
    Dio? initialDio,
  }) : dio =
           initialDio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: const Duration(seconds: 15),
               sendTimeout: const Duration(seconds: 30),
               receiveTimeout: const Duration(seconds: 30),
             ),
           ) {
    dio.interceptors.addAll([
      ...interceptors,
      ISpectDioInterceptor(
        logger: ISpect.logger,
        settings: const ISpectDioInterceptorSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseData: false,
        ),
      ),
    ]);
  }

  final Dio dio;
}
