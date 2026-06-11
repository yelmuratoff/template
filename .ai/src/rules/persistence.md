# Persistence Rules

## Pick the Backend by Data Shape

- Queryable/relational/offline data → Drift; the schema (`AppDatabase`, tables) lives in `lib/src/core/database/`, the executor comes from `packages/database`.
- Small flags and user settings → `PreferencesDao` subclasses over SharedPreferences; key constants live in `lib/src/common/constants/preferences.dart`. Skip direct `SharedPreferences.getInstance()` calls in features — the instance is built once in `CompositionRoot` and injected.
- Tokens, credentials, secrets → `SecureStorage` (`FlutterSecureStorageWrapper`) only. The auth token pair goes through `SecureTokenStorage` in `packages/rest_client`, whose broadcast `changes` stream is the single "session changed/died" channel.

## Lifecycle

- One instance per backing store, created in `CompositionRoot.compose()` and injected — concurrent handles on the same file race.
- First run wipes secure storage (`appConfig.isFirstRun` in `CompositionRoot`) so keychain leftovers from a reinstall don't resurrect a stale session — keep that ordering ahead of any token read.
- After changing a Drift table, regenerate with `fvm dart run build_runner build --delete-conflicting-outputs` and write an explicit migration; test the upgrade path.

## Hygiene

- Persisted types are immutable; produce new instances with `copyWith` rather than mutating.
- Recover from a corrupt read by resetting that store to a default and logging via `ISpect.logger.handle` — one bad write must not brick startup (see `AuthBloc._readSession` for the pattern).
