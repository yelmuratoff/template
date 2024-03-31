final class AppConstants {
  /// TODO: Change this to your app name
  static const String appName = 'Base';

  /// TODO: Change this to your app identifier
  static const String appIdentifier = 'kz.app.dummy_example';

  /// TODO: Change this to your API base url
  static const String baseUrl = 'https://dummyjson.com/';
}

final class Preferences {
  static const String theme = '${AppConstants.appIdentifier}.theme';
  static const String language = '${AppConstants.appIdentifier}.language';
  static const String environment = '${AppConstants.appIdentifier}.environment';
  static const String tokenPair = '${AppConstants.appIdentifier}.tokenPair';
}
