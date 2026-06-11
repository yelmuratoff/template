# BLoC Rules

## Structure

- One `<feature>_bloc.dart` with `part '<feature>_event.dart'` and `part '<feature>_state.dart'`; see `lib/src/features/auth/presentation/bloc/auth/` for the reference shape.
- Events and states are hand-written sealed hierarchies with `const` constructors. Naming: `<Variant><Feature>State` / `<Variant><Feature>Event` (`LoadingAuthState`, `LoginAuthEvent`); internal events get a leading underscore (`_TokenRevokedAuthEvent`).
- Use `EquatableMixin` only on types whose fields affect equality; switch over states exhaustively with Dart 3 `switch`.

## Concurrency

- Pick the transformer per event semantics: `droppable()` for non-stacking actions (login tap-spam), `restartable()` for latest-wins (status checks, search), `sequential()` when ordering matters. Default to `sequential()` when unsure.

## Errors

- Wrap event handlers in the shared `guard` helper (`lib/src/common/utils/extensions/bloc_extension.dart`): known `AppException`s become an error state; anything else also goes to `reportBug` (pass the bloc's own `onError`).
- `guard`/`handleException` is the single place a failure is logged — the data layer that re-types and rethrows stays silent, so each failure is logged exactly once.
- Session restore (`AuthBloc._readSession`) deliberately bypasses `guard` and recovers to `Unauthenticated`; keep that exception local to auth.

## Presentation Wiring

- Expose a bloc to a subtree through a typed scope widget (`AuthScope`, `UserScope`, `SettingsScope` pattern): a controller interface, `of`/`stateOf` statics, an `InheritedWidget` keyed on state. Screens dispatch through the controller, never through the raw bloc.
- The bloc instance is created in `CompositionRoot` and injected into the scope at mount — keeps the scope testable with a fake bloc.
- Keep navigation and dialogs out of states; `NavigationManager` subscribes to bloc streams and routes from there.
- Ephemeral widget-local state (toggles, text input, tab index) stays in `StatefulWidget`/`ValueNotifier`, not a bloc.
