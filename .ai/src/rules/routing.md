# Routing Rules

This project routes with `yx_navigation` + `yx_navigation_flutter` — not `go_router` and not raw `Navigator` pushes. Navigation is business-logic-first and runs without a `BuildContext`.

## Structure

- Routes are declared as constants in `lib/src/app/router/routes/app_routes.dart`; widgets reference `AppRoutes.*`, never path strings.
- `AppRouterSchema` (`lib/src/app/router/app_router_schema.dart`) maps each route to its widget, including the `indexedStack(root)` with tab outlets.
- `NavigationManager` (`lib/src/app/router/navigation_manager.dart`) owns the root `RouteNodeStateManager` and the guard pipeline, and exposes intent methods (`openRoot()`, `openAuth()`, `openSettings()`). New navigation flows get a named method here.

## Guards

- Guards live in `lib/src/app/router/guards/` as pure-Dart `RouteNodeGuard` classes; pass state in as closures (`isAuthenticated: () => ...`) so each guard stays unit-testable without Flutter.
- Declaration-level guards in the schema are ignored when a state manager is injected — register guards in `NavigationManager`, not on route declarations.
- Auth redirects flow through `AuthGuard`; re-evaluation on login/revoke is driven by `NavigationManager` subscribing to `AuthBloc.stream`.

## Discipline

- The data layer and BLoCs never navigate. The revoke chain is the model: interceptor clears tokens → `TokenStorage.changes` emits `null` → `AuthBloc` emits `Unauthenticated` → `NavigationManager` routes to auth.
- Imperative `showDialog`/picker `push`/`pop` pairs work through `NavigatorCompatibilityOverrides` layered in `MaterialContext` — keep them for transient UI only.
