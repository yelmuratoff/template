# core

Shared kernel of the workspace: the app-wide typed exception vocabulary and the
platform file service. It has **zero app coupling** — every other package and
the app depend on it, it depends on nothing local.

## What's inside

### `AppException` — the sealed error family

One sealed hierarchy is the error vocabulary for the whole app. Repositories
map transport/storage failures into it; BLoCs switch over it exhaustively.

```
sealed AppException implements Exception
 ├─ NetworkException        connectivity failure (message, cause, statusCode)
 ├─ TimeoutAppException     request or parse deadline exceeded
 ├─ ParseException          malformed payload
 ├─ CacheException          storage / secure-storage / db failure
 ├─ BackendException        server-side error (message, error payload, statusCode)
 ├─ RevokedTokenException   session died — refresh token rejected
 ├─ InvalidDataException    data present but semantically invalid
 └─ NoDataException         expected data is absent
```

```dart
try {
  final user = await repository.fetchUser();
} on AppException catch (e) {
  // exhaustive: switch (e) { case NetworkException(): ... }
}
```

Throwing code preserves the original stack trace with
`Error.throwWithStackTrace(ParseException(...), stackTrace)`.

### `FileService`

A small platform abstraction over `path_provider` for resolving and working
with app directories, behind the `BaseFileService` interface so it can be
faked in tests.

## Usage

```yaml
dependencies:
  core:
    path: ../core
```

```dart
import 'package:core/core.dart';
```

## Dependencies

`equatable` (value equality on exceptions), `path_provider` (file service).
No networking, persistence, or UI dependencies — keep it that way: this package
must stay importable from anywhere without dragging infrastructure in.
