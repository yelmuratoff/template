# Architecture Rules

## Layers & Placement

- Each feature lives under `lib/src/features/<name>/` with `data/` (+ optional `domain/`) and `presentation/`; dependency direction is strictly `presentation → (domain) → data`.
- Repository *interfaces* (`IAuthRepository`-style) live in `domain/repositories/`; implementations in `data/repositories/`. Datasource interfaces live in `data/data_source/interface/`, implementations beside them.
- Add a use-case layer only when concrete business-logic complexity earns it; by default BLoCs talk to repositories directly.
- DTOs live in `data/models/`, are immutable, and serve as the only model — no separate entity or mapping layer until a concrete need splits them.
- App-wide plumbing goes to `lib/src/app/` (router, theme, root widgets); shared utilities to `lib/src/common/`; infrastructure (database schema, env, l10n, assets) to `lib/src/core/`.

## Workspace Packages

- `packages/core` (AppException family, FileService), `packages/database` (Drift executor, PreferencesDao, SecureStorage), `packages/rest_client` (Dio wrapper, auth interceptor), `packages/ui` (theme + reusable widgets). A package never imports app code.
- `ui` widgets take strings and images as parameters — keep l10n and asset coupling in the app, out of the package.
- Graduate a folder to a package only when it is shared across features, needs an independent test cycle, or wants separate ownership.

## Dependency Injection

- Create every app-wide dependency exactly once in `CompositionRoot.compose()` (`lib/src/features/initialization/logic/composition_root.dart`); hold it in `DependenciesContainer` or `RepositoriesContainer` (`lib/src/features/initialization/models/`).
- Read dependencies from context: `context.dependencies.<name>`, or through feature scopes (`AuthScope.of`, `UserScope.userOf`, `SettingsScope.themeOf`).
- Constructor-inject everything. `GetIt`, `riverpod`, `getx`, and static singletons stay out of this codebase — the absence is deliberate and documented in `README.md`.

## Conventions

- Models and BLoCs are hand-written; reserve `build_runner` codegen for Drift, `envied`, and assets. DTOs use Dart Data Class Generator-style `fromMap`/`toMap`.
- Constructors may bind private fields via named parameters (Dart 3.10+): `AuthBloc({required this.repository, required this._tokenStorage})`.
- User-visible strings come from gen-l10n (`L10n` / generated localizations), with keys present in all three ARBs (en/ru/kk).
