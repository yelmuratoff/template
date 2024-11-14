import 'package:base_starter/src/common/constants/app_constants.dart';
import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/core/rest_client/dio_rest_client/src/rest_client_dio.dart';
import 'package:base_starter/src/features/initialization/containers/dependencies.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:ispect/ispect.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Factory that creates an instance of [DependenciesContainer].
class DependenciesFactory extends AsyncFactory<DependenciesContainer> {
  const DependenciesFactory();

  @override
  Future<DependenciesContainer> create() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    final restClient = await const RestClientFactory().create();

    return DependenciesContainer(
      packageInfo: packageInfo,
      sharedPreferences: sharedPreferences,
      restClient: restClient,
    );
  }
}

/// A factory that creates an instance of [RestClientBase].
class RestClientFactory extends AsyncFactory<RestClientBase> {
  const RestClientFactory();

  @override
  Future<RestClientBase> create() async {
    final restClient = RestClientDio(baseUrl: AppConstants.baseUrl);

    ISpect.info(
      '''REST client initialized: $restClient with base URL: ${restClient.baseUrl}''',
    );

    return restClient;
  }
}
