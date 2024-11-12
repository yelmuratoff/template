// ignore_for_file: avoid_dynamic_calls

import 'package:base_starter/src/common/constants/exception_keys.dart';
import 'package:base_starter/src/common/utils/utils.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:dio/dio.dart';

/// `DioInterceptor` - This class is used to intercept `dio` errors.

class DioInterceptor extends Interceptor {
  const DioInterceptor();

  @override
  Future<dynamic> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response =
        err.response ?? Response(requestOptions: err.requestOptions);

    DioException errorMessage(String errorMessage, {bool isHtml = false}) {
      String computedMessage;

      if (isHtml) {
        // If the error is to be interpreted as HTML and we have a context.
        computedMessage = DioInterceptor.getErrorMessage(
          key: errorMessage,
        );
      } else if (!isHtml && err.response?.data?['msg'] != null) {
        // If the error is not to be interpreted as HTML and the response
        //message exists.
        computedMessage = err.response!.data['msg'].toString();
      } else {
        // Fallback for any other case.
        computedMessage = DioInterceptor.getErrorMessage(
          key: errorMessage,
        );
      }

      return DioException(
        error: err,
        message: computedMessage,
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
      );
    }

    if (err.response != null &&
        err.response!.data.toString().contains('html')) {
      return handler
          .reject(errorMessage(ExceptionKeys.badRequest, isHtml: true));
    } else if (err.type == DioExceptionType.connectionError) {
      return handler.reject(errorMessage(ExceptionKeys.noConnection));
    } else if (err.type == DioExceptionType.connectionTimeout) {
      return handler.reject(errorMessage(ExceptionKeys.connectionTimeout));
    } else if (err.response == null) {
      return handler.reject(err);
    } else if (err.message.toString().contains('Invalid login details')) {
      return handler.reject(errorMessage(ExceptionKeys.passwordNotCorrect));
    } else if (response.statusCode == 400) {
      return handler.reject(errorMessage(ExceptionKeys.badRequest));
    } else if (response.statusCode == 418 || response.statusCode == 401) {
      await AppUtils.exit();
      if (response.data.toString().contains('Invalid login details')) {
        return handler.reject(errorMessage(ExceptionKeys.passwordNotCorrect));
      } else {
        return handler.reject(errorMessage(ExceptionKeys.status401));
      }
    } else if (response.statusCode == 404) {
      return handler.reject(errorMessage(ExceptionKeys.status404));
    } else if (response.statusCode! >= 500) {
      if (err.message.toString().contains('Invalid login details')) {
        return handler.reject(errorMessage(ExceptionKeys.status500));
      } else {
        return handler.reject(errorMessage(ExceptionKeys.status500));
      }
    }
    return handler.reject(err);
  }

  /// `getErrorMessage` - This function is used to get error message
  /// from `ExceptionKeys`.
  static String getErrorMessage({
    required String key,
  }) {
    final appLocalizations = L10n.current;
    switch (key) {
      case ExceptionKeys.noConnection:
        return appLocalizations.noConnection;
      case ExceptionKeys.connectionTimeout:
        return appLocalizations.connectionTimeout;
      case ExceptionKeys.noData:
        return appLocalizations.noData;
      case ExceptionKeys.userNotFound:
        return appLocalizations.userNotFound;
      case ExceptionKeys.thisEmailAlreadyExist:
        return appLocalizations.thisEmailAlreadyExist;
      case ExceptionKeys.thisUsernameAlreadyExist:
        return appLocalizations.thisUsernameAlreadyExist;
      case ExceptionKeys.passwordNotCorrect:
        return appLocalizations.passwordNotCorrect;
      case ExceptionKeys.badRequest:
        return appLocalizations.badRequest;
      case ExceptionKeys.status401:
        return appLocalizations.status401;
      case ExceptionKeys.status404:
        return appLocalizations.status404;
      case ExceptionKeys.status500:
        return appLocalizations.status500;
      default:
        return appLocalizations.error;
    }
  }
}
