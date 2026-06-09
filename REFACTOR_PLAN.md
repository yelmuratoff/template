# Refactor Plan: актуализация base_starter

Полный рефакторинг по слоям: исключения, secure storage, rest client + token refresh, data layer, BLoC, роутер (Octopus → yx_navigation), presentation, зависимости, тесты.

**Чекпоинт после каждой фазы** (коммит только на зелёном):

```bash
fvm flutter pub get
fvm dart format lib test packages/ui/lib --set-exit-if-changed
fvm flutter analyze   # 0 issues
fvm flutter test      # green
```

---

## Фаза 1 — pubspec: обновление + чистка

- [ ] `flutter pub outdated` → обновить все пакеты до последних stable (dio, flutter_secure_storage, ispect-семейство с dev-пинов, drift, envied, lint-цепочка)
- [ ] `mocktail`, `custom_lint` → dev_dependencies; добавить dev: `checks`, `fake_async`
- [ ] Добавить `clock` в dependencies (используется composition_root, сейчас транзитивный)
- [ ] Удалить: `analyzer: any`, `rxdart`, `stream_transform`, `group_button`, `pure`, `platform_info`, `share_plus`, `device_info_plus`; `meta` → `^1.x`
- [ ] `provider` и `octopus` пока оставить (уходят в Фазах 7 и 6)
- [ ] `build_runner build --delete-conflicting-outputs`; починить компиляцию (secure storage options, ispect API)
- [ ] Чекпоинт + коммит

## Фаза 2 — исключения, инжектируемый secure storage, root error handlers

- [ ] Part-файлы `app_exception.dart`: `NetworkException`, `TimeoutAppException`, `ParseException`, `CacheException`, `RevokedTokenException` (message, cause, statusCode?)
- [ ] `core/database/src/preferences/secure_storage.dart`: интерфейс `SecureStorage` + `FlutterSecureStorageWrapper` (try/catch → `ISpect.logger.handle` → `Error.throwWithStackTrace(CacheException)`)
- [ ] `bootstrap.dart`: `onZonedError` → `ISpect.logger.handle`; явные `FlutterError.onError` / `PlatformDispatcher.onError`; удалить закомментированный Firebase-код
- [ ] `AppConfigManager`: убрать static singleton → конструкторная инъекция через контейнер
- [ ] `SecureStorage` в `DependenciesContainer`
- [ ] Тест: `test/core/storage/secure_storage_test.dart`
- [ ] Чекпоинт + коммит

## Фаза 3 — RestClient + token refresh (критический поток)

- [ ] `core/rest_client/auth/token_storage.dart`: `TokenStorage {read/save/clear, Stream<TokenPair?> changes}` + `SecureTokenStorage` (фикс бага записи `"null"`; corrupt JSON → log + clear)
- [ ] `core/rest_client/auth/auth_interceptor.dart`: `QueuedInterceptor` + Completer-мьютекс; N×401 → 1 refresh; 1 ретрай на запрос; refresh через bare Dio (без рекурсии); 401/403 от refresh → clear + `RevokedTokenException`; сетевые ошибки refresh → rethrow без revoke
- [ ] `dio_client.dart`: удалить inline-refresh и `SecureStorageManager`; интерцепторы через конструктор
- [ ] `rest_client_dio.dart`: принимать готовый `Dio` (убить создание клиента на каждый запрос); таймауты → отдельный кейс
- [ ] Composition: одна сборка refreshDio → SecureTokenStorage → AuthInterceptor → DioClient → RestClientDio; убрать дублирующий вызов `RepositoriesFactory`
- [ ] Удалить `secure_storage_manager.dart`, `AppUtils.exit()`
- [ ] Тесты: `auth_interceptor_test.dart` (5 сценариев: header, мьютекс, bounded retry, revoke, no-revoke-on-network), `token_storage_test.dart`; переименовать rest_client_test
- [ ] Чекпоинт + коммит

## Фаза 4 — data layer: маппинг ошибок, cache/fresh split

- [ ] Datasources: убрать `catch (e) { rethrow; }`; `fromMap` падение → `ParseException`; фикс двойного `json.encode` в `UserLocalDataSource.write`
- [ ] Репозитории: `on RestClientException` → log → маппинг в `AppException`-подтипы (`Error.throwWithStackTrace`)
- [ ] Слить user-репозитории → один `UserRepository` (`getCachedUser`/`getFreshUser`/`clearCache`); обновить контейнеры и фабрики
- [ ] `handleException` в `bloc_extension.dart`: exhaustive switch по sealed `AppException` → `RestClientException` → fallback + log
- [ ] Тесты: `auth_repository_test.dart`, `user_repository_test.dart`
- [ ] Чекпоинт + коммит

## Фаза 5 — BLoC

- [ ] `AuthBloc`: states `Initial/Loading/Authenticated/Unauthenticated/Error`; per-event регистрации с трансформерами (`Login`/`Logout` → droppable, `CheckStatus` → restartable); `TokenStorage` в конструктор; подписка на `tokenStorage.changes` → `_TokenRevokedAuthEvent` → `Unauthenticated`; двухуровневый catch
- [ ] `UserCubit` → `UserBloc` (sealed states, restartable fetch, cached-then-fresh через merged `UserRepository`)
- [ ] `SettingsBloc`: двухуровневый catch + `ISpect.logger.handle`, явные `sequential()`
- [ ] Обновить wiring: `dependencies.dart`, фабрики, `material_context.dart`, `auth_screen.dart`
- [ ] Тесты: `auth_bloc_test.dart` (incl. droppable и revoke→Unauthenticated), `user_bloc_test.dart`, `settings_bloc_test.dart`
- [ ] Чекпоинт + коммит

## Фаза 6 — роутер: Octopus → yx_navigation

- [ ] **Spike**: `RouteDeclaration.indexedStack` + outlets воспроизводят табы/push/guard (fallback: ручной IndexedStack → nested scheme → отмена фазы)
- [ ] `router/routes/app_routes.dart` — статические `YxRoute` константы
- [ ] `router/app_router_schema.dart` — `RouterSchema` (splash, auth, indexedStack root с табами)
- [ ] `router/guards/auth_guard.dart` — `RouteNodeGuard` redirect-логика (pure Dart)
- [ ] `router/navigation_manager.dart` — инжектируемый поверх `RouteNodeStateManager`; координатор AuthBloc → навигация без context
- [ ] `material_context.dart`: schema.build(...); `splash.dart` → тупой экран, restore через `CheckStatusAuthEvent`; first-run wipe → composition
- [ ] Обновить: `auth_screen`, `home_screen`, `profile_screen`, `context_extension` (`pop`), `error_router_screen`, `root_screen` → `RootView`
- [ ] Удалить octopus-файлы (`router.dart`, `guards/tab.dart`, `guards/auth.dart`, `root_tabs_enum.dart`, `route_wrapper.dart`); pubspec: −octopus +yx_navigation +yx_navigation_flutter
- [ ] Тесты: `auth_guard_test.dart`, `navigation_manager_test.dart`, widget-smoke роутера
- [ ] Чекпоинт + коммит + ручной smoke (`flutter run --flavor dev`)

## Фаза 7 — presentation: Screen/View + Scope-виджеты

- [ ] `auth_scope.dart`: `AuthController {state, login, logout}`, `AuthScope.of/stateOf` (эталон — SettingsScope)
- [ ] `user_scope.dart`: `UserScope.userOf(context)`, `fetch()`
- [ ] Screen/View split: auth, settings (убрать `PageLifecycleModel`/`SettingsScreenModel`), profile (StatelessWidget + UserScope + logout), home
- [ ] `app_runner.dart`: удалить `MultiBlocProvider`; убрать вложенную shadow-функцию `initializeAndRun`
- [ ] `context_extension.dart`: убрать `provide*`, `blocWatch`/`blocRead`; удалить `page_lifecycle_model.dart`, `settings_model.dart`; `provider` из pubspec
- [ ] Тесты: `auth_scope_test.dart`, widget-тесты `ProfileView`/`AuthView`
- [ ] Чекпоинт + коммит

## Фаза 8 — финальный проход

- [ ] `flutter pub outdated` повторно; проверить использование `flutter_easyloading`, `iconsax_plus`, `auto_size_text`, `gap`
- [ ] Актуализировать `docs/STRUCTURE.md`, `README.md`
- [ ] Полная верификация: format, analyze, test, debug-сборки flavors, ручной smoke
- [ ] Финальный коммит

---

## Риски

| Риск | Митигировано |
|---|---|
| yx_navigation ~1 месяц, доки по табам неполные | Spike в Фазе 6; fallback-лестница вплоть до отмены фазы |
| ispect stable vs новый dio | Обновляются вместе в Фазе 1, ломается сразу на analyze |
| pyramid_lint vs новый analyzer | Выбросить pyramid_lint, не держать toolchain |
| flutter_secure_storage v10 breaking | Изолировано интерфейсом `SecureStorage` |
| Ложный логаут на флаки-сети | Revoke только на 401/403 от refresh; покрыто тестом |
