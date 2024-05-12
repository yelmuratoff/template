import 'package:base_starter/src/common/configs/env/env.dart';

final class AppConstants {
  /// TODO: Change this to your app name
  static const String appName = 'Base';

  /// TODO: Change this to your app identifier
  static const String appIdentifier = 'kz.app.template';

  static const String baseUrl = Env.apiUrl;
}

final class Preferences {
  static const String theme = '${AppConstants.appIdentifier}.theme';
  static const String language = '${AppConstants.appIdentifier}.language';
  static const String environment = '${AppConstants.appIdentifier}.environment';
  static const String tokenPair = '${AppConstants.appIdentifier}.tokenPair';
  static const String performanceTracking =
      '${AppConstants.appIdentifier}.performanceTracking';
  static const String firstRun = '${AppConstants.appIdentifier}.firstRun';
}
