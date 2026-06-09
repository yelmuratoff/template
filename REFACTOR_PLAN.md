# Refactor Plan: актуализация base_starter

Полный рефакторинг по слоям под правила проекта: typed-исключения, инжектируемый secure storage, rest client + token refresh с мьютексом, маппинг ошибок в data layer, BLoC с трансформерами, миграция роутера Octopus → yx_navigation, presentation (Screen/View + Scope), обновление зависимостей, тесты на критические потоки.

Ветка: `refactor/actualize-template`. Решения ратифицированы: yx_navigation вместо Octopus; зависимости — последние stable; ispect остаётся на dev-пине (собственный пакет, новее stable); тестами покрывается рефакторимое ядро (token refresh — все пути).

**Чекпоинт после каждой фазы** (коммит только на зелёном):

```bash
fvm flutter pub get
fvm dart format lib test packages/ui/lib --set-exit-if-changed
fvm flutter analyze   # 0 issues
fvm flutter test      # green
```

---

## ✅ Фаза 1 — pubspec: обновление + чистка (DONE, commit `e303e1d`)

- [x] **Flutter SDK 3.35.7 → 3.44.1** (Dart 3.12.1) через `fvm use 3.44.1` — без этого новые версии пакетов не резолвились (старый SDK капал analyzer 7.x, build_runner 2.7 и т.д.)
- [x] `flutter pub upgrade --major-versions` — обновлено 73 пакета (dio, drift 2.33, flutter_secure_storage 10.x, envied 1.3, build_runner 2.15, custom_lint 0.8, flutter_gen_runner 5.14)
- [x] `mocktail`, `custom_lint` → dev_dependencies; добавлены dev: `checks`, `fake_async`
- [x] Добавлен `clock` в dependencies (использовался транзитивно), `meta` запинен `^1.16.0`
- [x] Удалены: `analyzer: any`, `rxdart`, `stream_transform`, `group_button`, `pure`, `platform_info`, `share_plus`, `device_info_plus`
- [x] Кодген перегенерирован; `l10n.yaml` без deprecated `synthetic-package`
- [x] Починки под новый тулчейн: 5 удалённых lint-правил из analysis_options; `parameter_assignments` в material_context и двух vendored flutter_toast; deprecated `encryptedSharedPreferences`
- [x] Чекпоинт + коммит

Отклонения: ispect остался `5.2.0-dev.19` (осознанный пин автора); pyramid_lint `2.4.0`, не 3.0.0 (3.x требует analyzer_plugin ^0.14.9, несовместим с custom_lint 0.8).

## ✅ Фаза 2 — исключения, secure storage, root error handlers (DONE, commit `81c8ca1`)

- [x] Part-файлы `core/exceptions/`: `NetworkException` (message, cause, statusCode), `TimeoutAppException`, `ParseException`, `CacheException`, `RevokedTokenException` — все final, расширяют sealed `AppException`, Equatable props
- [x] `core/database/src/preferences/secure_storage.dart`: интерфейс `SecureStorage {read/write/delete/deleteAll}` + `FlutterSecureStorageWrapper` — каждый метод через `_guard`: `on Exception` → `ISpect.logger.handle` → `Error.throwWithStackTrace(CacheException)`. Проглоченных catch больше нет
- [x] `bootstrap.dart`: `_installRootErrorHandlers()` — fallback `FlutterError.onError` + `PlatformDispatcher.onError` → `ISpect.logger.handle` (ISpect.run ставит свои только при `kISpectEnabled`; в prod-сборке без него иначе ошибки терялись); `onZonedError` → `ISpect.logger.handle`; мёртвый Firebase-код удалён
- [x] `AppConfigManager`: static singleton (`initialize`/`instance`) → обычный конструктор, инжектится через контейнер
- [x] `SecureStorage` + `AppConfigManager` в `DependenciesContainer`; splash берёт их из `context.dependencies`
- [x] Тест `test/core/storage/secure_storage_test.dart`: успешный read, CacheException с сохранённым cause/stack при падении платформы, delegate delete/deleteAll
- [x] Чекпоинт + коммит

## ✅ Фаза 3 — RestClient + token refresh (DONE, commits `b2de6db`, `fc45ccd`)

- [x] `core/rest_client/auth/token_storage.dart`: `TokenStorage {read/save/clear, Stream<TokenPair?> changes, dispose}` + `SecureTokenStorage`. Фиксы: `clear()` удаляет ключ (раньше писалась строка `"null"`); corrupt JSON при read → log + reset + null (не брикает запуск)
- [x] `core/rest_client/auth/auth_interceptor.dart`: `QueuedInterceptor`. Инварианты: N очередных 401 → ровно 1 refresh (сериализация очереди + проверка «токен уже ротирован» по stale-заголовку); ровно 1 ретрай на исходный запрос через bare `plainDio` (структурно нет рекурсии); 401/403 от `/auth/refresh` → `tokenStorage.clear()` (stream emits null) + `RevokedTokenException`; 401 на ретрае → revoke; transport-ошибка refresh → rethrow БЕЗ revoke (флаки-сеть не разлогинивает); нечитаемый token store не блокирует запрос (идёт без авторизации)
- [x] `dio_client.dart`: inline-refresh и `SecureStorageManager` удалены; интерцепторы через конструктор; явные таймауты в `BaseOptions` (connect 15s, send/receive 30s)
- [x] `rest_client_dio.dart`: принимает готовый `Dio` (раньше строил новый DioClient на каждый запрос); таймауты Dio → новый `RequestTimeoutException` (подтип RestClientException), connectionError → `ConnectionException`
- [x] Composition: `RestClientFactory` строит цепочку один раз (SecureTokenStorage → plainDio → AuthInterceptor → DioClient → RestClientDio), возвращает record; `DependenciesFactory` возвращает `ComposedDependencies` — двойное создание репозиториев в `CompositionRoot` устранено; `TokenStorage` в контейнере
- [x] `AuthBloc` (минимально, полный рефакторинг в Фазе 5): инжектится `TokenStorage`; login → `save`, logout → `clear`
- [x] Удалены: `secure_storage_manager.dart`, `AppUtils.exit()`; из `DioInterceptor` убран вызов exit на 401 (401 теперь владение AuthInterceptor)
- [x] Тесты: `auth_interceptor_test.dart` — 8 сценариев (header attach; unauthenticated при сломанном store; refresh+retry; 3×401 → 1 refresh; revoke при 401 на ретрае; revoke при 401 от refresh-эндпоинта; НЕ-revoke при сетевой ошибке; non-401 не трогается); `token_storage_test.dart` — 5 сценариев (round-trip, null, corrupt→reset+emit, save→emit, clear→emit). Итого 56 тестов зелёные
- [x] Чекпоинт + коммит

## ⬜ Фаза 4 — data layer: маппинг ошибок, cache/fresh split

- [ ] Datasources (`features/auth/data/data_source/**`): убрать бессмысленные `catch (e) { rethrow; }`; падение `UserDTO.fromMap` → `Error.throwWithStackTrace(ParseException, st)`
- [ ] **Фикс бага**: `UserLocalDataSource.write` двойное кодирование — `json.encode(user?.toJson())`, где `toJson()` уже возвращает String; чтение кэша юзера из-за этого сломано. Писать `json.encode(user?.toMap())`, null → удаление ключа
- [ ] Репозитории (`auth_repository.dart` и user): на границе `on RestClientException catch (e, st)` → `ISpect.logger.handle` → маппинг: `ConnectionException`→`NetworkException`, `RequestTimeoutException`→`TimeoutAppException`, `WrongResponseTypeException`→`ParseException`, `CustomBackendException` остаётся (UI нужен payload бэкенда). Бросать через `Error.throwWithStackTrace`
- [ ] Слить user-репозитории: `LocalUserRepository`+`RemoteUserRepository` → один `UserRepository` с `getCachedUser()` / `getFreshUser()` (fresh пишет кэш) / `clearCache()`; интерфейс в `domain/repositories/user/user_repository.dart`; обновить `RepositoriesContainer`, фабрики, `UserCubit`
- [ ] `bloc_extension.dart` `handleException`: сначала exhaustive switch по sealed `AppException`, затем `RestClientException`, затем fallback `onError(e.toString(), e, null)` + `ISpect.logger.handle` для unknown-tier
- [ ] Тесты: `auth_repository_test.dart` (каждый подтип RestClientException → ожидаемый AppException, stack сохранён, logger вызван), `user_repository_test.dart` (cached без remote; fresh обновляет кэш; corrupt cache → CacheException)
- [ ] Чекпоинт + коммит

## ⬜ Фаза 5 — BLoC

- [ ] `AuthBloc` (part-файлы `auth_event.dart`/`auth_state.dart` остаются): states → `Initial/Loading/Authenticated/Unauthenticated/Error(message, cause)`; вместо одного `on<AuthEvent>` — per-event регистрации с трансформерами: `LoginAuthEvent`+`LogoutAuthEvent` → `droppable()` (спам кнопки), `CheckStatusAuthEvent` (новое, заменяет чтение токена в splash) → `restartable()`
- [ ] Revoke-цепочка: в конструкторе подписка на `tokenStorage.changes`; `null` при Authenticated → внутреннее `_TokenRevokedAuthEvent` → emit `Unauthenticated`; отписка в `close()`. Это замыкает E2E: 401 на refresh → interceptor clear → stream null → AuthBloc → Unauthenticated → (Фаза 6) гард уводит на /auth
- [ ] Двухуровневый catch в каждом handler: `on AppException catch (e, st)` → Error state (известные); `on Object catch (e, st)` → Error state + `onError(e, st)` (баги — в observer)
- [ ] `UserCubit` → `UserBloc`: sealed states `Initial/Loading/Loaded(user)/Error`, событие `FetchUserEvent` с `restartable()`, cached-then-fresh через слитый `UserRepository`
- [ ] `SettingsBloc`: форма states остаётся (соответствует правилам — multi-step с сохранением payload); добавить двухуровневый catch + `ISpect.logger.handle` (сейчас голый rethrow после emit), явный `sequential()` на каждом событии
- [ ] Wiring: `dependencies.dart` (`userCubit` → `userBloc`), фабрики, `material_context.dart:56` (`blocRead<UserCubit>().get()`), `auth_screen.dart` (listener arms)
- [ ] Тесты: `auth_bloc_test.dart` (login success → [Loading, Authenticated] + save вызван; NetworkException → [Loading, Error]; два быстрых Login → репозиторий 1 раз (droppable); changes emits null → Unauthenticated), `user_bloc_test.dart` (порядок cached→fresh; fresh-fail при наличии кэша), `settings_bloc_test.dart` (theme/locale success + failure)
- [ ] Чекпоинт + коммит

## ⬜ Фаза 6 — роутер: Octopus → yx_navigation 1.0.0

- [ ] **Шаг 0, spike (полдня)**: добавить `yx_navigation` + `yx_navigation_flutter`; в scratch widget-тесте проверить: `RouteDeclaration.indexedStack` + `RouteBuilder.outlet` дают (а) сохранение состояния табов, (б) push `settings` внутри profile-таба, (в) guard-редирект. Доки: github.com/yandex/city-services-pub (quick_start, route_declarations, guards, compatibility_architecture). **Fallback-лестница**: ручной `IndexedStack` на одном route → nested `RouteDeclaration.scheme` на таб → отмена фазы (не связана с Фазами 1–5, остаёмся на Octopus)
- [ ] `router/routes/app_routes.dart`: статические `YxRoute` константы (splash, auth, root, home-tab, profile-tab, home, profile, settings)
- [ ] `router/app_router_schema.dart`: `RouterSchema` — splash, auth, `indexedStack(root)` с двумя outlet-табами
- [ ] `router/guards/auth_guard.dart`: `RouteNodeGuard` — неавторизован и цель не auth/splash → redirect auth; авторизован и цель auth → redirect root. `isAuthenticated` — closure на `authBloc.state is Authenticated`, гард pure-Dart юнит-тестируем
- [ ] `router/navigation_manager.dart`: инжектируемый поверх `RouteNodeStateManager` (`openRoot/openAuth/openSettings/pop`); координатор подписан на AuthBloc states → навигация без BuildContext (revoke приземляет на auth)
- [ ] `material_context.dart`: `schema.build(stateManagerConfiguration: ...)`; проверить совместимость `ISpectNavigatorObserver`; `OctopusTools` удалить
- [ ] `splash.dart` → тупой экран: restore сессии = `CheckStatusAuthEvent` в AuthBloc; first-run wipe → в composition (`DependenciesFactory`)
- [ ] Обновить: `auth_screen`, `home_screen` (убрать `wrappedRoute`), `profile_screen`, `context_extension` (`pop()`), `error_router_screen`, `root_screen` → `RootView` от `RouteIndexedStackBuilder`
- [ ] Удалить: `router/routes/router.dart`, `router/guards/tab.dart`, `router/guards/auth.dart` (пустой), `router/enums/root_tabs_enum.dart`, `router/widgets/route_wrapper.dart`; pubspec: −octopus
- [ ] Тесты: `auth_guard_test.dart` (pure Dart), `navigation_manager_test.dart` (мутации дерева через stream), widget-smoke (роутер + fake auth → табы рендерятся и переключаются)
- [ ] Чекпоинт + коммит + ручной smoke: `fvm flutter run --flavor dev -t lib/main_dev.dart` — splash → auth → login → табы → settings push → restart → restore → симуляция revoke → auth

## ⬜ Фаза 7 — presentation: Screen/View + Scope-виджеты

- [ ] `features/auth/presentation/auth_scope.dart`: интерфейс `AuthController {state, login(email, password), logout()}`; `AuthScope.of(context)`, `AuthScope.stateOf(context)` (ScopeData getter, Of-суффикс); внутри BlocBuilder над AuthBloc из `DependenciesScope` + InheritedWidget. Эталон — существующий `SettingsScope` (InheritedModel)
- [ ] `features/auth/presentation/user_scope.dart`: `UserScope.userOf(context)`, `fetch()` dispatch
- [ ] Screen/View split: `auth_screen.dart` → `AuthScreen` (wiring: listeners, dialogs) + `_AuthView` (чистый layout); `settings_screen.dart` — убрать `PageLifecycleModel`/`SettingsScreenModel` (логика debug-диалога в State); `profile_screen.dart` → StatelessWidget + `ProfileView` (данные из UserScope, кнопка logout через AuthScope — впервые прогоняет user-фичу end-to-end); `home_screen.dart` почистить
- [ ] `app_runner.dart`: удалить `MultiBlocProvider`/`BlocProvider.value` (скоупы читают из DependenciesScope); убрать вложенную shadow-функцию `initializeAndRun`
- [ ] `context_extension.dart`: удалить `provide*`-хелперы и `blocWatch`/`blocRead`; удалить `page_lifecycle_model.dart`, `settings_model.dart`; `provider` из pubspec
- [ ] Тесты: `auth_scope_test.dart` (scope отдаёт state, `login()` диспатчит в fake bloc); widget-тесты `ProfileView`/`AuthView` (поведение: onTap → callback, не пиксели)
- [ ] Чекпоинт + коммит

## ⬜ Фаза 8 — финальный проход

- [ ] `fvm flutter pub outdated` повторно; убедиться что `flutter_easyloading`, `iconsax_plus`, `auto_size_text`, `gap` ещё используются (иначе удалить)
- [ ] Актуализировать `docs/STRUCTURE.md` и `README.md`: новый роутер, схема исключений, DI-граф, секция token refresh
- [ ] Полная верификация: format, analyze, полный `flutter test`, debug-сборки обоих flavors, ручной smoke-сценарий из Фазы 6
- [ ] Финальный коммит

---

## Риски

| Риск | Митигировано |
|---|---|
| yx_navigation ~1 месяц, доки по табам/outlet неполные | Spike в Фазе 6 Шаг 0; fallback-лестница вплоть до отмены фазы |
| ispect dev-пин vs новый dio | Обновлены вместе в Фазе 1 — analyze чистый ✅ |
| pyramid_lint vs новый analyzer | Взят 2.4.0 (максимум совместимого) ✅ |
| flutter_secure_storage v10 breaking | Изолировано интерфейсом `SecureStorage` (1 файл) ✅ |
| Ложный логаут на флаки-сети | Revoke только на 401/403 от refresh; покрыто тестом ✅ |

## Архитектурные решения (зафиксировано)

- **Refresh-мьютекс**: `QueuedInterceptor` сериализует обработку ошибок; дедупликация — сравнением stale access-токена из заголовка упавшего запроса с текущим в storage («уже ротирован» → реюз). Completer-лок не нужен: ретраи идут через bare Dio и не реентерят интерцептор.
- **Revoke-канал**: `TokenStorage.changes` (broadcast stream) — единственный канал «сессия умерла»; interceptor пишет, AuthBloc слушает, роутер реагирует на state. Никаких навигаций из data-слоя.
- **Composition**: всё строится один раз в `DependenciesFactory` → `ComposedDependencies` record; репозитории больше не создаются дважды.
