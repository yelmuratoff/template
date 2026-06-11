# Testing Rules

## Stack & Layout

- Tests use `flutter_test` + `mocktail` (mocks/fakes) + `package:checks` (assertions) + `fake_async`/`clock` (time). Assert with `check(...)`, not bare `expect`.
- Mirror the source tree: `lib/src/features/auth/...` → `test/features/auth/<unit>_test.dart`. One behavior per test.
- Name tests by the behavior proved: `test('ConnectionException becomes NetworkException preserving cause and status code')`, not `test('test_fetch')`.

## What to Cover

- Repositories: every `RestClientException` → `AppException` mapping branch, per exception type (see `test/features/auth/auth_repository_test.dart` for the reference shape).
- BLoCs: success and every expected failure path, including that `guard` emits the error state and unexpected errors reach the observer.
- Guards and `NavigationManager`: pure-Dart unit tests with closure-injected state — no widget pumping needed.
- Scope widgets: widget tests with a fake bloc injected at mount (`auth_scope_test.dart` shows the pattern).
- Auth and token-refresh flows hold the highest bar: success path and every failure path covered.

## Determinism

- Mock the I/O boundary: datasource interfaces (`I*DataSource`), `TokenStorage`, `SecureStorage` — no real HTTP, database, or secure storage in unit tests.
- Control time with `clock`/`fake_async`; keep real `Duration` waits and randomness out.
- `setUp` lives inside `group(...)`; initialize mutable collaborators per test.

## Gate

- Run `fvm flutter test` (plus `fvm dart format .` and `fvm dart analyze`) before presenting a change — the same gates as `.github/workflows/code-analysis.yml`.
