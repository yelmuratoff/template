import 'core/rest_client/auth_interceptor_test.dart' as auth_interceptor_test;
import 'core/rest_client/rest_client_base_test.dart' as rest_client_base_test;
import 'core/rest_client/token_storage_test.dart' as token_storage_test;
import 'core/storage/secure_storage_test.dart' as secure_storage_test;

void main() {
  rest_client_base_test.main();
  token_storage_test.main();
  auth_interceptor_test.main();
  secure_storage_test.main();
}
