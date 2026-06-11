# Architecture & Project Structure

`base_starter` is a single-module Flutter starter built on **feature-first
Clean Architecture**. Each feature owns its layers and the dependency direction
is strict:

```
presentation  →  (domain)  →  data
```

- **presentation** — widgets, BLoCs/Cubits, scopes. Depends on domain contracts
  (when present) or directly on data repositories.
- **domain** *(optional)* — pure repository interfaces / models, zero Flutter
  imports. Added only where a real contract earns the boundary.
- **data** — DTOs, datasources, repositories; all I/O lives here.

State management is **BLoC** (async/business flows) with `Cubit`/`ValueNotifier`
reserved for ephemeral UI state. Dependency injection is **Pure DI** — a single
hand-rolled composition root, no service locator.

---

## 🚀 Startup flow

```
main.dart / main_dev.dart
  └─ bootstrap.dart            ISpect.run + _installRootErrorHandlers
       └─ AppRunner.initializeAndRun        lib/src/app/logic/app_runner.dart
            └─ CompositionRoot.compose()     builds the whole object graph once
                 └─ runApp(App(result))
                      └─ DependenciesScope    context.dependencies
                           └─ SettingsScope   theme + locale
                                └─ AuthScope        auth state + actions
                                     └─ UserScope    user state + actions
                                          └─ MaterialContext  MaterialApp.router
```

Root error handlers (`FlutterError.onError`, `PlatformDispatcher.onError`,
`runZonedGuarded`) all funnel to `ISpect.logger.handle`, so nothing uncaught is
lost — even in a release build where ISpect itself is compiled out.

---

## 📂 `lib/src` layout

```
app/                         app shell — wiring, no feature logic
  logic/app_runner.dart      defer first frame, compose, runApp
  model/app_theme.dart       AppTheme (seed + mode → light/dark ThemeData)
  presentation/
    screens/root_screen.dart RootView: bottom-nav over the tab IndexedStack
    widgets/app.dart          mounts the scope stack
    widgets/material_context.dart  MaterialApp.router + theme/locale/observers
  router/                    yx_navigation (see Routing below)
    app_router_schema.dart   route → widget map
    navigation_manager.dart  owns RouteNodeStateManager + guard pipeline
    routes/app_routes.dart   YxRoute constants
    guards/                  auth_guard.dart, tab_init_guard.dart

common/                      cross-feature, non-platform helpers
  constants/                 app constants, preference keys
  presentation/              app-specific shared UI (change-environment dialog,
                             error router screen) — reusable widgets live in
                             the `ui` package
  utils/extensions/          context_extension, bloc_extension, …
  utils/mixins/              scope_mixin

core/                        app-specific platform glue
  assets/                    flutter_gen output
  database/                  concrete AppDatabase + TodosTable + AppConfigManager
                             (generic infra lives in the `database` package)
  env/                       envied-generated environment config
  l10n/                      gen-l10n setup + ARB (en/ru/kk)

features/<feature>/          presentation / (domain) / data per feature
  auth/                      login, session restore, user, scopes
  home/                      counter demo (Cubit)
  initialization/            CompositionRoot, containers, splash
  profile/                   profile screen (consumes Auth/User scopes)
  settings/                  theme + locale (SettingsScope / SettingsBloc)
```

Shared, app-agnostic code lives in Pub Workspace packages under `packages/`
(`resolution: workspace`, one root lockfile). Dependencies flow one way and a
package never imports app code:

```
core  ◄── database  ◄── rest_client          ui
  ▲          ▲              ▲                  ▲
  └──────────┴──────────────┴──────────────────┴──── base_starter (app)

packages/
  core/         sealed AppException family + platform FileService
  database/     Drift QueryExecutor, PreferencesDao, SecureStorage
  rest_client/  RestClient wrapper, Dio stack, SecureTokenStorage, token refresh
  ui/           theme (IColors/ITextStyles) + reusable widgets
```

---

## 🧩 Dependency Injection

Everything is created **once** in `CompositionRoot.compose()`
(`features/initialization/logic/composition_root.dart`) and returned as a
`CompositionResult` (`dependencies` + `repositories` + build time). No factory
hierarchy — the graph is small and built linearly by private async methods
(`_createConfig` / `_createRestClient` / `_createRepositories` /
`_createSettingsBloc`).

| Container | Holds |
|---|---|
| `DependenciesContainer` | `sharedPreferences`, `secureStorage`, `tokenStorage`, `appConfig`, `appDatabase`, `packageInfo`, `restClient`, `authBloc`, `userBloc`, `settingsBloc`, `navigationManager` |
| `RepositoriesContainer` | `authRepository`, `userRepository` |

The result is exposed through `InheritedWidget`s, not static accessors:

- `context.dependencies` → `DependenciesContainer` (via `DependenciesScope`).
- Feature **scopes** wrap a single bloc and expose reactive reads + actions
  through a typed controller, so screens never touch the bloc directly:
  - `SettingsScope.of/themeOf/localeOf` — theme & locale.
  - `AuthScope.of(context)` → `AuthController {state, login, logout}`;
    `AuthScope.stateOf(context)` for reactive state.
  - `UserScope.of(context)` → `UserController {state, user, fetch}`;
    `UserScope.userOf(context)` for the loaded `UserDTO?`.

Each scope is injected its bloc from `result.dependencies` at mount time
(mirroring `SettingsScope`), which keeps it unit-testable with a fake bloc.

> **No service locator.** `GetIt`/`riverpod`/`getx` are intentionally absent —
> dependencies are explicit, compile-time-checked, and constructor-injected.

---

## 🗺️ Routing — `yx_navigation`

Navigation uses `yx_navigation` + `yx_navigation_flutter` (Pure-Dart routing
core with a Flutter binding), following a **business-logic-first** approach: the
`RouteNodeStateManager` is injected and the guard pipeline is built from routes,
so navigation runs without a `BuildContext`.

- `app_router_schema.dart` — `AppRouterSchema` maps each `AppRoutes` entry to its
  widget: `splash`, `auth`, and an `indexedStack(root)` with `homeTab`/
  `profileTab` outlets. Declaration-level guards are ignored when a state manager
  is injected — guards live in the manager.
- `navigation_manager.dart` — `NavigationManager` owns the root
  `RouteNodeStateManager` and its guards (`RedirectRouteNodeGuard` + `AuthGuard`
  + `NavigateToIndexedStackNodeGuard` + two `TabInitGuard`s). It subscribes to
  `AuthBloc.stream`:
  - `Authenticated` → `openRoot()` + dispatch `FetchUserEvent`.
  - `Unauthenticated` → `openAuth()`.
  - `openSettings()` pushes settings onto the profile tab.
- `auth_guard.dart` — redirects unauthenticated users to `auth` and keeps
  authenticated users off `auth`; `isAuthenticated` is a closure over
  `AuthBloc.state`, so the guard is a pure-Dart unit.

`MaterialContext` builds the schema with the injected state manager and wires
`ISpectNavigatorObserver`. `NavigatorCompatibilityOverrides` is layered over
`MaterialApp.router` so imperative `showDialog`/picker `push`/`pop` pairs work.

---

## ⚠️ Exception scheme

A single sealed family in the `core` package is the app-wide error vocabulary:

```
sealed AppException implements Exception
 ├─ NetworkException        (message, cause, statusCode)
 ├─ TimeoutAppException
 ├─ ParseException
 ├─ CacheException          storage/secure-storage/db failure
 ├─ BackendException        (message, error payload, statusCode)
 ├─ RevokedTokenException   session died
 ├─ InvalidDataException
 └─ NoDataException
```

**Where errors are mapped:**

- Datasources throw typed exceptions (parse failures →
  `Error.throwWithStackTrace(ParseException)`); transport exceptions pass
  through.
- The transport layer has its own `RestClientException` family (in the
  `rest_client` package). Repositories translate it to an `AppException` at their
  boundary via the total `RestClientExceptionMapper` (`toAppException()`), so
  transport types never leak past the `rest_client` package.
- BLoCs handle errors through one helper, `guard`
  (`common/utils/extensions/bloc_extension.dart`), with two tiers:
  - `on AppException` → emit an error state (the repository mapper is total, so
    this is one family).
  - `on Object` → emit an error state **and** report to the bloc observer (it is
    a programming bug). `handleException` normalizes `(message, cause,
    statusCode)` and logs each failure exactly once via `ISpect.logger.handle`.

> Session restore is the deliberate exception: `_onCheckStatus` does **not** go
> through `guard`. An unreadable token store recovers to `Unauthenticated`
> (logged) rather than an error state the splash router would ignore — so a
> corrupt secure store never strands the user on the splash screen.

---

## 🔐 Networking & token refresh

The `rest_client` package owns all HTTP details behind one wrapper.

- A single `RestClientBase` (`RestClientDio`) wraps a ready-made `Dio` (base URL,
  headers, decoding, backend-error parsing, `Isolate.run` for large JSON).
  Datasources depend on the wrapper, never on raw `Dio`. Explicit timeouts live
  in `BaseOptions` (connect 15s, send/receive 30s).
- Tokens live **only** in `flutter_secure_storage`, behind `SecureTokenStorage`
  (`auth/token_storage.dart`), which exposes a broadcast `Stream<TokenPair?>
  changes` — the single "session changed / died" channel.
- `AuthInterceptor extends QueuedInterceptor` (`auth/auth_interceptor.dart`)
  holds the refresh invariants:
  - N concurrent `401`s trigger **exactly one** refresh (the queue serializes
    error handling; dedup compares the stale access token from the failed
    request's header against current storage — "already rotated" → reuse).
  - Exactly **one** retry per original request, replayed through a bare `Dio`
    (`plainDio`) so there is structurally no interceptor recursion.
  - `401/403` from the refresh endpoint, or a `401` on the retry, →
    `tokenStorage.clear()` (stream emits `null`) + `RevokedTokenException`.
  - A transport error during refresh is rethrown **without** revoking — flaky
    networks must not sign the user out.

**Revoke loop (no navigation from the data layer):** interceptor clears the
store → `changes` emits `null` → `AuthBloc` (subscribed in its constructor)
emits `Unauthenticated` → `NavigationManager` routes to `auth`.

---

## 🧱 Conventions worth knowing

- **Models & BLoCs are hand-written** (no `freezed`). DTOs use the Dart Data
  Class Generator (`fromMap`/`toMap`); states/events are sealed hierarchies with
  exhaustive `switch`.
- **Constructors use private named parameters** (Dart 3.10+):
  `AuthBloc({required this.repository, required this._tokenStorage})`.
- **Persistence:** Drift (queryable/offline), `TypedPreferencesDao` over
  SharedPreferences (small flags), `flutter_secure_storage` (secrets only).
- **Localization:** gen-l10n; ARB files in `core/l10n/translations` (en/ru/kk).
  All user-visible strings come from `L10n.current`.
- **Theming:** centralized `ThemeData` via `ColorScheme.fromSeed`; design tokens
  through the `packages/ui` `ThemeExtension`s (`IColors`, `ITextStyles`).
- **Logging:** everything through `ISpect.logger`; caught exceptions via
  `ISpect.logger.handle(exception, stackTrace, message)`.
- **Flavors:** `prod` (`lib/main.dart`) and `dev` (`lib/main_dev.dart`).
