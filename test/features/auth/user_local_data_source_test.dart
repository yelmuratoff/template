import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/features/auth/data/data_source/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const user = UserDTO(
    id: 1,
    email: 'a@b.c',
    name: 'Ann',
    role: 'admin',
    avatar: 'url',
    creationAt: '2024',
    updatedAt: '2024',
  );

  Future<UserLocalDataSource> build([
    Map<String, Object> initial = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(initial);
    final prefs = await SharedPreferences.getInstance();
    return UserLocalDataSource(sharedPreferences: prefs);
  }

  group('UserLocalDataSource', () {
    test('round-trips a written user', () async {
      final dataSource = await build();

      await dataSource.write(user: user);

      check(dataSource.get()).equals(user);
    });

    test('returns null when nothing is cached', () async {
      final dataSource = await build();

      check(dataSource.get()).isNull();
    });

    test('write(null) removes the cached entry', () async {
      final dataSource = await build();
      await dataSource.write(user: user);

      await dataSource.write(user: null);

      check(dataSource.get()).isNull();
    });

    test(
      'resets the entry and returns null when the cache is corrupt',
      () async {
        final dataSource = await build({Preferences.currentUser: 'not-json{'});

        check(dataSource.get()).isNull();

        final prefs = await SharedPreferences.getInstance();
        check(prefs.getString(Preferences.currentUser)).isNull();
      },
    );
  });
}
