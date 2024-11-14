import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DependenciesContainer {
  const DependenciesContainer({
    required this.sharedPreferences,
    required this.packageInfo,
    required this.restClient,
  });

  // <--- External dependencies --->
  final SharedPreferences sharedPreferences;
  final PackageInfo packageInfo;

  // <--- Internal dependencies --->

  // <--- Network dependencies --->
  final RestClientBase restClient;

  @override
  String toString() => '''DependenciesContainer(
      sharedPreferences:$sharedPreferences,
      packageInfo: $packageInfo,
      restClient: $restClient,
    )''';
}
