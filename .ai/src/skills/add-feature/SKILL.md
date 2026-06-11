---
name: "add-feature"
description: >-
  Use this skill when adding a new feature, screen, flow, or data-backed module
  to this app — including requests phrased as "add a screen for X", "build the
  orders page", "create a new module", "новая фича", "добавь экран". It walks
  the project's feature-first layout end-to-end: data source + repository with
  error mapping, BLoC with the guard helper, typed scope widget, wiring into
  CompositionRoot/containers, and a yx_navigation route with guards.
---

# Add a Feature

Scaffold a feature following the project's reference implementations: `lib/src/features/auth/` (full data + domain + presentation) and `lib/src/features/settings/` (data + presentation). Read the closest analog before writing.

## Steps

1. **Layout** — create `lib/src/features/<name>/` with:
   - `data/models/` — immutable DTO with hand-written `fromMap`/`toMap` (Dart Data Class Generator style; no `freezed`).
   - `data/data_source/interface/` — `I<Name>DataSource` abstract interface; implementation beside it in `data/data_source/`. Remote datasources depend on `RestClientBase` (never raw `Dio`) and throw typed exceptions.
   - `domain/repositories/` — `I<Name>Repository` interface; implementation in `data/repositories/` wrapping every datasource call in `mapRestErrors(...)` (see `AuthRepository`).
   - `presentation/bloc/<name>/` — `<name>_bloc.dart` with `part '<name>_event.dart'` / `part '<name>_state.dart'`; sealed states named `<Variant><Name>State` (Initial/Loading/Loaded/Error); handlers wrapped in the `guard` extension with an explicit transformer (`droppable`/`restartable`/`sequential`).
2. **Scope** — add `presentation/<name>_scope.dart` mirroring `AuthScope`: a controller interface, `of`/`stateOf` statics via `context.inhOf`, an `InheritedWidget` keyed on state, the bloc injected through the constructor.
3. **Wire DI** — add the repository to `RepositoriesContainer` (`features/initialization/models/repositories.dart`), the bloc (if app-lifetime) to `DependenciesContainer` (`models/dependencies.dart`), and construct both in `CompositionRoot.compose()` (`logic/composition_root.dart`).
4. **Route** — add the route constant to `lib/src/app/router/routes/app_routes.dart`, map it to the screen in `app_router_schema.dart`, and expose an intent method on `NavigationManager` (`openX()`). Guard rules go into `NavigationManager`'s pipeline, not route declarations.
5. **Strings** — every user-visible string gets a key in all three ARBs (`lib/src/core/l10n/translations/intl_{en,ru,kk}.arb`); regenerate with `fvm flutter gen-l10n`.
6. **Tests** — mirror the structure under `test/features/<name>/`: repository error-mapping per exception type, bloc success + failure paths, scope widget test with a fake bloc. Use `mocktail` + `package:checks`.
7. **Verify** — `fvm dart format .` && `fvm dart analyze` && `fvm flutter test`.

## Gotchas

- Routing is `yx_navigation`, not `go_router` — there is no `context.go()`; navigation flows through `NavigationManager` and reacts to bloc streams.
- Provide blocs via scope widgets, not `BlocProvider` in feature UI; the bloc is created in `CompositionRoot` and passed into the scope at mount.
- Declaration-level guards in `AppRouterSchema` are ignored because a state manager is injected — registering one there silently does nothing.
- `guard` already logs each failure once; adding `ISpect.logger.handle` in the datasource/repository duplicates log entries.
- State/event classes need `const` constructors and (when fields matter) `EquatableMixin` — without equality the scope's `updateShouldNotify` fires on every emit.
