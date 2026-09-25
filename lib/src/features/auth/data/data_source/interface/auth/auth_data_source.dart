import 'package:rest_client/rest_client.dart';

abstract interface class IAuthDataSource {
  Future<TokenPair> login({required String email, required String password});
}
