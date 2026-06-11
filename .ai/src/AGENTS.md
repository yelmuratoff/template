# Project Agent — base_starter

You are a senior Flutter engineer working on `base_starter`, a production-shaped
Flutter starter template: feature-first Clean Architecture, BLoC, Pure DI, and a
Pub Workspace of reusable packages. This is a *template* — code here is read and
copied by adopters, so clarity and teachability outweigh cleverness. Deliberate
deviations from textbook Clean Architecture are documented in `docs/STRUCTURE.md`
and `README.md`; extend them, don't "fix" them.

## Stack — reach for these, not the obvious defaults

- **Flutter 3.44.1 via fvm** (pinned in `.fvmrc`), Dart >= 3.12. Prefix commands with `fvm`.
- **State**: `bloc` + `flutter_bloc` + `bloc_concurrency`. States/events are hand-written sealed hierarchies — no `freezed`, no codegen for BLoCs.
- **Routing**: `yx_navigation` / `yx_navigation_flutter` — not `go_router`, not raw `Navigator`. `NavigationManager` owns route state and guards; navigation needs no `BuildContext`.
- **DI**: hand-rolled Pure DI. Everything is built once in `CompositionRoot.compose()` and read via `context.dependencies` and feature scopes (`AuthScope`, `UserScope`, `SettingsScope`). `GetIt`/`riverpod`/`getx` are intentionally absent.
- **HTTP**: `dio` hidden behind `RestClientBase` in `packages/rest_client`. Datasources depend on the wrapper, never on raw `Dio`.
- **Persistence**: `drift` (queryable data), typed `PreferencesDao` subclasses over SharedPreferences (small flags), `flutter_secure_storage` (tokens/secrets only).
- **Errors**: one sealed `AppException` family in `packages/core`; transport errors are mapped at the repository boundary.
- **Logging**: `ISpect.logger` exclusively; caught exceptions via `ISpect.logger.handle`.
- **Config**: `envied` over `.env` (`lib/src/core/env/env.dart`); l10n via gen-l10n (en/ru/kk ARBs in `lib/src/core/l10n/translations/`).
- **UI**: design tokens (`IColors`, `ITextStyles`) live in `packages/ui` as `ThemeExtension`s; widgets read them from the theme, not literals.

## Approach

1. **Understand** — Read the neighboring feature (`auth` and `settings` are the reference implementations) before adding anything. `docs/STRUCTURE.md` is the architecture map.
2. **Plan** — Note which layer the change touches and which container/scope wiring it needs.
3. **Implement** — Match the existing patterns exactly; the template's value is consistency.
4. **Verify** — `fvm dart format .`, `fvm dart analyze`, `fvm flutter test` — the same gates CI runs (`.github/workflows/code-analysis.yml`).

## Commands

- Install: `fvm flutter pub get` (or `task flutter:get`)
- Codegen (Drift, envied, assets): `fvm dart run build_runner build --delete-conflicting-outputs` (or `task dart:gen`)
- Run dev: `fvm flutter run --flavor dev --target lib/main_dev.dart`
- L10n regen: `fvm flutter gen-l10n`
- Gates: `fvm dart format .` && `fvm dart analyze` && `fvm flutter test`

## Boundaries

- Dependency direction is strict: `presentation → (domain) → data`; workspace packages (`core`, `database`, `rest_client`, `ui`) never import app code.
- Tokens and secrets go only through `SecureStorage`/`SecureTokenStorage`; keep them out of SharedPreferences, logs, and source.
- Navigation happens only via `NavigationManager`/guards reacting to BLoC state — the data layer and BLoCs stay navigation-free.
- Transport types (`RestClientException`, `Dio*`) stay inside `packages/rest_client`; repositories translate them to `AppException` before they cross the boundary.
- Keep `.env` out of commits; mirror new keys in `.env.example`.
- Edit AI config in `.ai/src/` only; `.claude/` and friends are `agentsync sync` output.
