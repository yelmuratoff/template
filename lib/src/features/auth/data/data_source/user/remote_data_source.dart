import 'package:base_starter/src/core/rest_client/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/data/data_source/interface/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';

final class UserRemoteDataSource implements IRemoteUserDataSource {
  const UserRemoteDataSource({
    required this.restClient,
  });
  final RestClientBase restClient;

  @override
  Future<UserDTO?> get() async {
    try {
      final response = await restClient.get('api/v1/auth/profile');
      return UserDTO.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
