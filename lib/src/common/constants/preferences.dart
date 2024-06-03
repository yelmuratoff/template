import 'package:base_starter/src/common/constants/app_constants.dart';

/// Constants for the app's preferences.
/// It used for storing and retrieving data from the shared preferences.
final class Preferences {
  static const String theme = '${AppConstants.appIdentifier}.theme';
  static const String language = '${AppConstants.appIdentifier}.language';
  static const String environment = '${AppConstants.appIdentifier}.environment';
  static const String tokenPair = '${AppConstants.appIdentifier}.tokenPair';
  static const String performanceTracking =
      '${AppConstants.appIdentifier}.performanceTracking';
  static const String firstRun = '${AppConstants.appIdentifier}.firstRun';
}
