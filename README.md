# Flutter Starter Template

A production-shaped Flutter starter for single-module apps: feature-first Clean
Architecture, **BLoC** state management, **Pure DI** (one composition root, no
service locator), typed exceptions end-to-end, and a small Pub Workspace of
reusable packages.

To use it, click **"Use this template"** and follow [How to run](#how-to-run).

**Remember: keep your code simple and easy to read. It should be
straightforward to test and modify. A bit more effort to achieve this goal is
always worthwhile.**

## Requirements

- **Flutter 3.44.1** via [fvm](https://fvm.app) (pinned in `.fvmrc`)
- **Dart SDK >= 3.12.0** (ships with the pinned Flutter)
- [Task](https://taskfile.dev) or `make` for the optional automation targets

## Deliberate simplifications

A Clean Architecture base with a few documented deviations:

- **No separate Entity** — the DTO carries both roles; no mapping layer until a
  concrete need splits the models.
- **No ValueObject** — only warranted for complex objects reused across the app.
- **Optional UseCase layer** — added per feature only when real business-logic
  complexity earns the boundary; otherwise BLoCs talk to repositories directly.
- **No `GetIt`/service locator** — it hides dependencies and breaks compile-time
  wiring ([why](https://lazebny.io/avoid-these-dart-libraries/#get_it)). A
  hand-rolled `DependenciesContainer` exposed via `InheritedWidget` replaces it.

## Features

- 🚀 Feature-first Clean Architecture with strict `presentation → (domain) → data` direction
- 🧩 Pure DI: single `CompositionRoot`, typed feature scopes (`AuthScope`, `UserScope`, `SettingsScope`)
- 🗺️ `yx_navigation` routing — guard pipeline driven by `AuthBloc`, no `BuildContext` in navigation logic
- ⚠️ One sealed `AppException` family; transport errors mapped at the repository boundary
- 🔐 Token refresh done right: `QueuedInterceptor`, one refresh for N concurrent 401s, bounded retry, revoke loop
- 🔥 [ISpect](https://pub.dev/packages/ispect) debug toolkit (inspector, logs for BLoC/Dio/routing, device info) — compiled out of release builds
- 💾 Drift (SQLite) + typed `PreferencesDao` + `flutter_secure_storage`, all wired through the composition root
- 🌍 gen-l10n localization: en, ru, kk
- 🎨 Theming via `ColorScheme.fromSeed` + `ThemeExtension` design tokens in the `ui` package
- 🧪 Tests on `mocktail` + `package:checks`; GitHub Actions pipeline (format, analyze, tests)

## Architecture

Feature-first Clean Architecture (`presentation → (domain) → data`) with
**BLoC** state management and **Pure DI** (a single composition root, no service
locator). The full picture — startup flow, directory layout, DI graph, routing,
the exception scheme, and token refresh — lives in
[`docs/STRUCTURE.md`](docs/STRUCTURE.md). At a glance:

- **DI** — everything is built once in `CompositionRoot.compose()` and exposed
  through `InheritedWidget` scopes; read it with `context.dependencies` and the
  feature scopes (`AuthScope`, `UserScope`, `SettingsScope`).
- **Routing** — `yx_navigation`; `NavigationManager` owns the route state and
  guard pipeline and reacts to `AuthBloc` (no navigation from the data layer).
- **Errors** — one sealed `AppException` family; the transport
  `RestClientException` is mapped to it at the repository boundary, and BLoCs
  funnel failures through a single `guard` helper.
- **Auth** — tokens live only in `flutter_secure_storage`; a `QueuedInterceptor`
  serializes refresh (one refresh for N concurrent 401s, one retry) and a
  broadcast `TokenStorage.changes` stream drives the revoke loop.

### Packages (monorepo)

App-agnostic, independently testable code lives in [Pub Workspace](https://dart.dev/tools/pub/workspaces)
members under `packages/` (single shared lockfile, `resolution: workspace`). The
app (`base_starter`) keeps only features and app-specific wiring. Dependencies
flow one way — a package never imports app code:

```
core  ◄── database  ◄── rest_client          ui
  ▲          ▲              ▲                  ▲
  └──────────┴──────────────┴──────────────────┴──── base_starter (app)
```

- [**`core`**](packages/core/README.md) — shared kernel: the sealed
  `AppException` family and the platform `FileService`. Zero app coupling;
  everything else depends on it.
- [**`database`**](packages/database/README.md) — persistence infrastructure:
  Drift `QueryExecutor` (native/web), the typed `PreferencesDao`, and
  `SecureStorage`. The concrete `AppDatabase` schema and `AppConfigManager`
  stay in the app.
- [**`rest_client`**](packages/rest_client/README.md) — Dio-backed REST client,
  auth interceptor, and `SecureTokenStorage`. Maps transport errors to `core`'s
  `AppException`.
- [**`ui`**](packages/ui/README.md) — design system: theme
  (`IColors`/`ITextStyles`), shimmer, and the reusable widgets (toaster,
  dialogs, buttons, text field, bottom sheet, builders). Widgets are
  theme-driven and take strings/images as parameters, so they hold no l10n or
  asset coupling back to the app.

Graduate a folder to a package only when it is shared across features, needs an
independent test cycle, or wants separate ownership — not by default.

## How to run

1. Click **"Use this template"** and clone your repository.
2. `fvm install` — installs the pinned Flutter SDK.
3. `cp .env.example .env` — fill in `API_URL` (see [.env config](#env-config)).
4. `fvm flutter pub get`
5. `fvm dart run build_runner build --delete-conflicting-outputs` — generates
   Drift, envied, and asset code.
6. Rebrand the template — one command rewrites the display name,
   application/bundle id, and Dart package name everywhere (Android, iOS, web,
   l10n, docs, `MainActivity` package path):

   ```bash
   dart run tool/rename_app.dart --name "My App" --id com.company.app
   # or: task tmpl:rename -- --name "My App" --id com.company.app
   ```

   Optional flags: `--package my_app` (defaults to the snake_cased name) and
   `--dry-run`. Firebase configs (`firebase/`, `ios/Runner/{dev,prod}/`) are
   bound to the bundle id — regenerate them for the new id afterwards.
7. `fvm flutter run --flavor dev --target lib/main_dev.dart` (or use the
   `[DEV]` configuration in `.vscode/launch.json`).

Entry points: `lib/main.dart` (prod flavor) and `lib/main_dev.dart` (dev
flavor).

### Commands

Day-to-day tasks are scripted twice — pick the runner you have:

- **make** (`automation/*.mk`): `make pub-get`, `make gen-build`,
  `make format`, `make dev-apk`, `make prod-appbundle`, `make splash`, …
- **Task** (`Taskfile.yaml`): `task flutter:get`, `task dart:gen`,
  `task dart:gen:watch`.
- Plain shell helpers live in `automation/bash/` (builds, Firebase init, iOS
  setup).

Verification before a PR: `dart format .`, `dart analyze`, `flutter test` —
the same gates CI runs (`.github/workflows/code-analysis.yml`).

## Debugging & observability

- **Logging** goes exclusively through `ISpect.logger`; caught exceptions are
  reported via `ISpect.logger.handle(exception, stackTrace, message)`.
- Root error handlers (`FlutterError.onError`, `PlatformDispatcher.onError`,
  `runZonedGuarded`) are installed in `bootstrap.dart` and funnel to the same
  logger — nothing uncaught is lost.
- **ISpect panel** (inspector, BLoC/Dio/route logs, feedback builder, cache
  manager, device info) is compiled out of the binary by default. Enable it
  with a build flag (already wired into the `[DEV]` launch configurations):

  ```bash
  flutter run --dart-define=ISPECT_ENABLED=true
  ```

- **DEV mode in-app**: open Settings and tap the project version 10 times — a
  toast appears with the DEV/PROD environment switch.

## Localization

Strings are generated with **gen-l10n** (configured in `l10n.yaml`):

- ARB files: `lib/src/core/l10n/translations/` (`intl_en.arb`, `intl_ru.arb`,
  `intl_kk.arb`); English is the template.
- Generated output: `lib/src/core/l10n/generated/` (regenerated on build or via
  `fvm flutter gen-l10n`).
- Missing translations are reported to `untranslated_messages.txt`.

## How to guides

### .env config

1. Keep `.env` in `.gitignore`; commit only `.env.example`.
2. Put the API url and other secrets into `.env`, mirror the keys in
   `.env.example`.
3. Declare each field in `lib/src/core/env/env.dart`:

   ```dart
   @Envied(path: '.env')
   final class Env {
     @EnviedField(varName: 'API_URL', useConstantCase: true)
     static const String apiUrl = _Env.apiUrl;
   }
   ```

4. Regenerate with `fvm dart run build_runner build --delete-conflicting-outputs`
   and read it as `Env.apiUrl`.

### How to add a new app-wide dependency

1. Add a field for it to `DependenciesContainer` in
   `lib/src/features/initialization/models/dependencies.dart` (or
   `RepositoriesContainer` in `repositories.dart` for a repository).
2. Create and wire it inside `CompositionRoot.compose()` in
   `lib/src/features/initialization/logic/composition_root.dart` — add it to
   the relevant `_create*` method and pass it into the container.
3. Read it anywhere from context: `context.dependencies.name`.

### Flavors

Two flavors are pre-configured via `flutter_flavorizr` (`flavorizr.yaml`):
`prod` → `lib/main.dart`, `dev` → `lib/main_dev.dart`. For Android, keep the
plugin-based `settings.gradle` layout:

```
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "7.3.0" apply false
    id "org.jetbrains.kotlin.android" version "1.8.22" apply false
}
```

## Documentation map

- [`docs/STRUCTURE.md`](docs/STRUCTURE.md) — architecture deep-dive: startup,
  DI graph, routing, exceptions, token refresh, conventions.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — branching and commit conventions.
- `packages/*/README.md` — per-package docs.

---

Based on the Sizzle Starter.
