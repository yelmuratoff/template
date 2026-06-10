import 'package:core/core.dart';
import 'package:rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/data/data_source/interface/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';

final class UserRemoteDataSource implements IRemoteUserDataSource {
  const UserRemoteDataSource({required this.restClient});
  final RestClientBase restClient;

  @override
  Future<UserDTO?> get() async {
    final response = await restClient.get('api/v1/auth/profile');
    try {
      return UserDTO.fromMap(response);
    } on Object catch (e, st) {
      Error.throwWithStackTrace(
        ParseException(message: 'Failed to parse user profile.', cause: e),
        st,
      );
    }
  }
}
