import 'app/router/auth_guard_test.dart' as auth_guard_test;
import 'app/router/navigation_manager_test.dart' as navigation_manager_test;
import 'app/router/root_view_test.dart' as root_view_test;
import 'core/rest_client/auth_interceptor_test.dart' as auth_interceptor_test;
import 'core/rest_client/rest_client_base_test.dart' as rest_client_base_test;
import 'core/rest_client/token_storage_test.dart' as token_storage_test;
import 'core/storage/secure_storage_test.dart' as secure_storage_test;
import 'features/auth/auth_bloc_test.dart' as auth_bloc_test;
import 'features/auth/auth_repository_test.dart' as auth_repository_test;
import 'features/auth/auth_scope_test.dart' as auth_scope_test;
import 'features/auth/auth_view_test.dart' as auth_view_test;
import 'features/auth/user_bloc_test.dart' as user_bloc_test;
import 'features/auth/user_dto_test.dart' as user_dto_test;
import 'features/auth/user_local_data_source_test.dart'
    as user_local_data_source_test;
import 'features/auth/user_repository_test.dart' as user_repository_test;
import 'features/auth/user_scope_test.dart' as user_scope_test;
import 'features/profile/profile_view_test.dart' as profile_view_test;
import 'features/settings/settings_bloc_test.dart' as settings_bloc_test;

void main() {
  auth_guard_test.main();
  navigation_manager_test.main();
  root_view_test.main();
  rest_client_base_test.main();
  token_storage_test.main();
  auth_interceptor_test.main();
  secure_storage_test.main();
  auth_repository_test.main();
  user_repository_test.main();
  user_local_data_source_test.main();
  auth_bloc_test.main();
  auth_scope_test.main();
  auth_view_test.main();
  user_bloc_test.main();
  user_scope_test.main();
  user_dto_test.main();
  profile_view_test.main();
  settings_bloc_test.main();
}
