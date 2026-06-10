import 'package:dio/dio.dart';
import 'package:ispect/ispect.dart';
import 'package:ispectify_dio/ispectify_dio.dart';

/// Connect/send/receive timeouts applied to every [Dio] the app builds — the
/// authorized client here and the bare refresh/retry client in composition.
abstract final class RestClientTimeouts {
  static const connect = Duration(seconds: 15);
  static const send = Duration(seconds: 30);
  static const receive = Duration(seconds: 30);
}

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
               connectTimeout: RestClientTimeouts.connect,
               sendTimeout: RestClientTimeouts.send,
               receiveTimeout: RestClientTimeouts.receive,
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
