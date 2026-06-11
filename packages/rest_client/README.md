# rest_client

All HTTP details of the app behind one wrapper: a Dio-backed `RestClient`, the
auth interceptor that owns the token-refresh invariants, secure token storage,
and a transport exception family mapped into `core`'s `AppException` at the
package boundary.

## What's inside

### `RestClient` / `RestClientDio`

The single HTTP wrapper datasources depend on — never on a raw `Dio`:

```dart
abstract class RestClient {
  Future<Map<String, Object?>> get(String path, {...});
  Future<Map<String, Object?>> post(String path, {required Object? body, ...});
  // put / delete / patch
}
```

`RestClientDio` (built on `RestClientBase`) decodes responses, parses
backend-error payloads, and offloads large JSON via `Isolate.run` so the UI
isolate keeps rendering.

### `DioClient`

Configures the one `Dio` instance requests go through: base URL, explicit
timeouts (connect 15s, send/receive 30s in `RestClientTimeouts`), the caller's
interceptors, and `ISpectDioInterceptor` logging.

### `TokenStorage` / `SecureTokenStorage` / `TokenPair`

Tokens live **only** in `flutter_secure_storage` (via the `database` package's
`SecureStorage`). `TokenStorage` exposes a broadcast `Stream<TokenPair?>
changes` — the single "session changed / died" channel: `clear()` emits `null`,
the app's `AuthBloc` reacts, navigation follows. No navigation happens from
this package.

### `AuthInterceptor` — the refresh invariants

`AuthInterceptor extends QueuedInterceptor`, so error handling is serialized
and the guarantees hold structurally:

- N concurrent `401`s trigger **exactly one** refresh call. Dedup compares the
  failed request's stale access token against current storage — "already
  rotated" → reuse the fresh pair without refreshing again.
- Exactly **one** retry per original request, replayed through a bare `Dio`
  (`plainDio`) so interceptor recursion is impossible.
- `401/403` from the refresh endpoint, or a `401` on the retry →
  `tokenStorage.clear()` + `RevokedTokenException` (session is dead).
- A transport error during refresh is rethrown **without** revoking — a flaky
  network must not sign the user out.

### Exceptions

A sealed transport family — `ClientException`, `CustomBackendException`,
`WrongResponseTypeException`, `RequestTimeoutException`,
`ConnectionException` — that never leaks past the package: repositories call
the total mapper `toAppException()` (`RestClientExceptionMapper`) and the rest
of the app sees only `core`'s `AppException`.

## Usage

```yaml
dependencies:
  rest_client:
    path: ../rest_client
```

```dart
import 'package:rest_client/rest_client.dart';
```

## Dependencies

`dio`, `core` (target exception family), `database` (`SecureStorage`),
`ispect`/`ispectify_dio` (logging).
