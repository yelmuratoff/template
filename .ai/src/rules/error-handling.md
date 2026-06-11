# Error Handling Rules

## One Exception Vocabulary

- The app-wide error family is the sealed `AppException` in `packages/core`: `NetworkException`, `TimeoutAppException`, `ParseException`, `CacheException`, `BackendException`, `RevokedTokenException`, `InvalidDataException`, `NoDataException`. New failure modes extend this family rather than introducing parallel types.
- Use native `throw`/`on X catch` — no `Either`/`Result` wrappers; they lose the stack trace Dart attaches at the throw site.

## Mapping Boundaries

- Datasources throw typed exceptions; for parse failures use `Error.throwWithStackTrace(ParseException(...), st)` to preserve the original trace. Transport exceptions pass through untouched.
- Repositories translate the transport `RestClientException` family into `AppException` via `mapRestErrors(...)` / `toAppException()` (see `AuthRepository`). Transport types never leak past `packages/rest_client`.
- BLoCs funnel failures through the `guard` extension: `on AppException` → error state; `on Object` → error state + `reportBug` (programming bug, surfaces in the observer).

## Logging

- Log every caught exception exactly once, at the recovery boundary, via `ISpect.logger.handle(exception:, stackTrace:, message:)`. Layers that re-type and rethrow stay silent.
- Log only non-sensitive metadata — keep tokens, credentials, and PII out of messages.

## Root Handlers

- `FlutterError.onError`, `PlatformDispatcher.onError`, and `runZonedGuarded` are installed in `bootstrap.dart` and funnel to `ISpect.logger` — new entry points keep that wiring intact.
- Catch `Exception` subtypes you can recover from; let `Error` subtypes (`StateError`, `ArgumentError`) crash so they surface in reports.
