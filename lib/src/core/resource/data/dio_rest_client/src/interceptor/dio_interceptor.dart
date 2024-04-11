// ignore_for_file: avoid_dynamic_calls

import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/common/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ispect/ispect.dart';

/// `ErrorInterceptor` - This class is used to intercept `dio` errors.

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();
  @override
  Future<dynamic> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final Response<dynamic> response =
        err.response ?? Response(requestOptions: err.requestOptions);

    DioException errorMessage(String errorMessage, {bool isHtml = false}) {
      String computedMessage;

      // Determine the context availability once to avoid checking it multiple times.
      final bool hasContext = navigatorKey.currentContext != null;

      if (isHtml && hasContext) {
        // If the error is to be interpreted as HTML and we have a context.
        computedMessage = ErrorInterceptor.getErrorMessage(
          context: navigatorKey.currentContext!,
          key: errorMessage.toString(),
        );
      } else if (!isHtml && err.response?.data?["msg"] != null) {
        // If the error is not to be interpreted as HTML and the response message exists.
        computedMessage = err.response!.data["msg"].toString();
      } else if (hasContext) {
        // Fallback for any other case where we have a context.
        computedMessage = ErrorInterceptor.getErrorMessage(
          context: navigatorKey.currentContext!,
          key: errorMessage.toString(),
        );
      } else {
        // Fallback when there's no context available.
        computedMessage = errorMessage.toString();
      }

      return DioException(
        error: err,
        message: computedMessage,
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
      );
    }

    talkerWrapper.error(
      message:
          "====================ERROR - START====================\nERROR_TYPE: ${err.type}\nPATH: ${err.requestOptions.path}\n${err.message}\n${err.response?.data}\n====================ERROR - END====================",
    );

    if (err.response != null &&
        err.response!.data.toString().contains("html")) {
      return handler.reject(errorMessage(ErrorsKeys.badRequest, isHtml: true));
    } else if (err.type == DioExceptionType.connectionError) {
      return handler.reject(errorMessage(ErrorsKeys.noConnection));
    } else if (err.type == DioExceptionType.connectionTimeout) {
      return handler.reject(errorMessage(ErrorsKeys.connectionTimeout));
    } else if (err.response == null) {
      return handler.reject(err);
    } else if (err.message.toString().contains("Invalid login details")) {
      return handler.reject(errorMessage(ErrorsKeys.passwordNotCorrect));
    } else if (response.statusCode == 400) {
      return handler.reject(errorMessage(ErrorsKeys.badRequest));
    } else if (response.statusCode == 418 || response.statusCode == 401) {
      await AppUtils.removeToken();
      if (response.data.toString().contains("Invalid login details")) {
        return handler.reject(errorMessage(ErrorsKeys.passwordNotCorrect));
      } else {
        return handler.reject(errorMessage(ErrorsKeys.status401));
      }
    } else if (response.statusCode == 404) {
      return handler.reject(errorMessage(ErrorsKeys.status404));
    } else if (response.statusCode! >= 500) {
      if (err.message.toString().contains("Invalid login details")) {
        return handler.reject(errorMessage(ErrorsKeys.status500));
      } else {
        return handler.reject(errorMessage(ErrorsKeys.status500));
      }
    }
    return handler.reject(err);
  }

  /// `getErrorMessage` - This function is used to get error message from `ErrorsKeys`.
  static String getErrorMessage({
    required BuildContext context,
    required String key,
  }) {
    final appLocalizations = context.l10n;
    switch (key) {
      case ErrorsKeys.noConnection:
        return appLocalizations.noConnection;
      case ErrorsKeys.connectionTimeout:
        return appLocalizations.connectionTimeout;
      case ErrorsKeys.noData:
        return appLocalizations.noData;
      case ErrorsKeys.userNotFound:
        return appLocalizations.userNotFound;
      case ErrorsKeys.thisEmailAlreadyExist:
        return appLocalizations.thisEmailAlreadyExist;
      case ErrorsKeys.thisUsernameAlreadyExist:
        return appLocalizations.thisUsernameAlreadyExist;
      case ErrorsKeys.passwordNotCorrect:
        return appLocalizations.passwordNotCorrect;
      case ErrorsKeys.badRequest:
        return appLocalizations.badRequest;
      case ErrorsKeys.status401:
        return appLocalizations.status401;
      case ErrorsKeys.status404:
        return appLocalizations.status404;
      case ErrorsKeys.status500:
        return appLocalizations.status500;
      default:
        return appLocalizations.error;
    }
  }
}

/// `ErrorsKeys` - This class contains error keys.
final class ErrorsKeys {
  static const String noConnection = 'noConnection';
  static const String connectionTimeout = 'connectionTimeout';
  static const String noData = 'noData';
  static const String userNotFound = 'userNotFound';
  static const String thisEmailAlreadyExist = 'thisEmailAlreadyExist';
  static const String thisUsernameAlreadyExist = 'thisUsernameAlreadyExist';
  static const String passwordNotCorrect = 'passwordNotCorrect';
  static const String badRequest = 'badRequest';
  static const String status401 = 'status401';
  static const String status404 = 'status404';
  static const String status500 = 'status500';
}
