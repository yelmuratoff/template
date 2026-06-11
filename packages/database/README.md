# database

Persistence **infrastructure** shared across the workspace: a platform-aware
Drift executor, a typed wrapper over `SharedPreferences`, and a mockable
secure-storage interface. The concrete schema (`AppDatabase`, tables) and
app-specific managers stay in the app — this package knows nothing about them.

## What's inside

### `createExecutor()` — platform-aware Drift `QueryExecutor`

Conditional exports pick the right backing store at compile time:

- **native** (`db_executor_native.dart`) — `NativeDatabase.createInBackground`
  over `db.sqlite` in the app documents directory (SQLite runs off the UI
  isolate).
- **web** (`db_executor_web.dart`) — the Drift web backend.
- **stub** — throws `UnsupportedError` on anything else.

```dart
final class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? createExecutor());
}
```

The app constructs **one** `AppDatabase` in the composition root and injects it
for the app's lifetime; Drift opens the connection lazily on first use.

### `PreferencesDao` — typed access to `SharedPreferences`

An `abstract base class` that turns stringly-typed preferences into declared,
typed entries. A feature DAO extends it and exposes `PreferencesEntry<T>`
fields:

```dart
final class SettingsDao extends PreferencesDao {
  SettingsDao({required super.sharedPreferences});

  PreferencesEntry<int> get seedColor => intEntry('settings.seed_color');
}

await dao.seedColor.setIfNullRemove(value); // atomic set-or-remove
final color = dao.seedColor.read();
```

No feature touches `SharedPreferences.getInstance()` directly — the single
instance is created in the composition root and passed down.

### `SecureStorage`

An `abstract interface class` over `flutter_secure_storage`
(`FlutterSecureStorageWrapper` is the production implementation). Secrets,
tokens, and credentials go **only** through this interface — never into
SharedPreferences or Drift — and tests fake the interface instead of the
plugin.

## Usage

```yaml
dependencies:
  database:
    path: ../database
```

```dart
import 'package:database/database.dart';
```

## Dependencies

`drift` + `sqlite3_flutter_libs` (SQLite), `shared_preferences`,
`flutter_secure_storage`, `core` (typed exceptions), `ispect` (logging).
