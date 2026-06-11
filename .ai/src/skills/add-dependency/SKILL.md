---
name: "add-dependency"
description: >-
  Use this skill when registering a new app-wide dependency — a service, client,
  repository, bloc, or manager that must be available across features — even
  when phrased as "where do I put this service", "make X available everywhere",
  "inject Y", "как прокинуть зависимость". Covers the project's Pure DI flow:
  DependenciesContainer / RepositoriesContainer fields, construction in
  CompositionRoot.compose(), and reading via context.dependencies or a scope.
---

# Add an App-Wide Dependency

Wire a dependency through the single composition root. There is no service locator — registration is a container field plus one construction site.

## Steps

1. Add a `final` field for it to `DependenciesContainer` in `lib/src/features/initialization/models/dependencies.dart` — or to `RepositoriesContainer` in `repositories.dart` if it's a repository.
2. Construct it inside `CompositionRoot.compose()` (`lib/src/features/initialization/logic/composition_root.dart`): extend the relevant `_create*` method (`_createRestClient`, `_createRepositories`, `_createSettingsBloc`) or add a new one, then pass the instance into the container constructor.
3. Order matters: storage and config first (`SharedPreferences`, `SecureStorage`, `AppConfigManager`), then network, then repositories, then blocs that consume them. Slot the new dependency after everything it consumes.
4. Read it from widgets via `context.dependencies.<name>` (`DependenciesScope`); from other constructor-injected classes, pass it explicitly as a constructor argument.
5. If it needs async setup, `await` it inside `compose()` — the splash screen already holds the first frame while composition runs.

## Gotchas

- Reaching for `GetIt`/`riverpod`/a static singleton is the tempting wrong move — the project deliberately rejects service locators; every dependency is a container field.
- Cheap stateless helpers don't belong in the container — construct them at the call site; register only shared-state or expensive-to-build objects.
- A bloc goes into `DependenciesContainer` only when it is app-lifetime (like `AuthBloc`); screen-scoped blocs are created where their scope mounts.
- After adding a pub package, run `fvm flutter pub get`, then `fvm dart analyze` — the workspace shares one lockfile across `packages/*`.
