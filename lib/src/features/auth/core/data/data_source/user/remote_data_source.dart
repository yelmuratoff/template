import 'package:base_starter/src/core/data/dio_rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/core/data/data_source/interface/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/core/data/models/user.dart';
import 'package:ispect/ispect.dart';

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
    } catch (e, st) {
      ISpectTalker.handle(
        exception: e,
        stackTrace: st,
        message: 'Get current user failed.',
      );
      rethrow;
    }
  }
}
