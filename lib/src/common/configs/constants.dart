import 'package:base_starter/src/common/configs/env/env.dart';

final class AppConstants {
  /// TODO: Change this to your app name
  static const String appName = 'Base';

  /// TODO: Change this to your app identifier
  static const String appIdentifier = 'kz.app.template';

  static const String baseUrl = Env.apiUrl;
}

/// `ErrorsKeys` - This class contains error keys.
final class ErrorsKeys {
  static const String noConnection = 'no_connection';
  static const String connectionTimeout = 'connection_timeout';
  static const String noData = 'no_data';
  static const String userNotFound = 'user_not_found';
  static const String thisEmailAlreadyExist = 'this_email_already_exist';
  static const String thisUsernameAlreadyExist = 'this_username_already_exist';
  static const String passwordNotCorrect = 'password_not_correct';
  static const String badRequest = 'bad_request';
  static const String status401 = 'status401';
  static const String status404 = 'status404';
  static const String status500 = 'status500';
}
