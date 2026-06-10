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

## Контекст для новой сессии (прочитать перед работой)

**Проект**: `base_starter` — Flutter starter-шаблон, feature-first Clean Architecture (presentation → optional domain → data). Flutter **3.44.1 / Dart 3.12.1 через fvm** — все команды с префиксом `fvm`. Flavors: prod (`lib/main.dart`) и dev (`lib/main_dev.dart`). Линт очень строгий (analysis_options: strict-casts/inference/raw-types + pyramid_lint + custom_lint, 80 символов строка).

**Режим работы**: выполнять **по одной фазе за сессию** (у пользователя лимиты), после фазы — чекпоинт, коммит, обновить чекбоксы и секцию DONE этого файла. Коммиты — Conventional Commits, без AI-атрибуции.

**Конвенция кода (важно)**: пользователь перевёл конструкторы на **private named parameters** (Dart 3.10+): `AuthBloc({required this.repository, required this._tokenStorage})` — новый код писать так же, без ручных `: _field = field` инициализаторов. Модели/BLoC пишутся руками (без freezed); DTO — hand-written `fromMap`/`toMap`.

**Поток инициализации**: `main.dart` → `bootstrap.dart` (`ISpect.run`, root error handlers `_installRootErrorHandlers`) → `AppRunner.initializeAndRun` (`lib/src/app/logic/app_runner.dart`) → `CompositionRoot.compose()` (`lib/src/features/initialization/logic/composition_root.dart`) → `DependenciesFactory.create()` (`.../factories/dependencies_factories.dart`) возвращает `ComposedDependencies` record (dependencies + repositories) → `App` widget оборачивает `DependenciesScope` (InheritedWidget, доступ `context.dependencies` через `lib/src/common/utils/extensions/context_extension.dart`) → `SettingsScope` → `MaterialContext` (`lib/src/app/presentation/widgets/material_context.dart`) с Octopus-роутером.

**Что уже есть после Фаз 1–3** (новые/переработанные файлы):
- `lib/src/core/exceptions/` — sealed `AppException` + part-файлы: `network_exception.dart`, `timeout_exception.dart` (`TimeoutAppException`), `parse_exception.dart`, `cache_exception.dart`, `revoked_token_exception.dart` (+ старые `invalid_data_format.dart`, `no_data_exception.dart`)
- `lib/src/core/database/src/preferences/secure_storage.dart` — `SecureStorage` + `FlutterSecureStorageWrapper`
- `lib/src/core/rest_client/auth/token_storage.dart` — `TokenStorage` + `SecureTokenStorage` (broadcast `changes`)
- `lib/src/core/rest_client/auth/auth_interceptor.dart` — `AuthInterceptor extends QueuedInterceptor` (инварианты в dartdoc файла)
- `lib/src/core/rest_client/exceptions/rest_client_exception.dart` — семейство + новый `RequestTimeoutException`
- `lib/src/core/rest_client/dio_rest_client/src/dio_client.dart` — единый Dio с таймаутами; `.../rest_client_dio.dart` — требует готовый `Dio`
- `DependenciesContainer` (`lib/src/features/initialization/models/dependencies.dart`) теперь держит: sharedPreferences, **secureStorage, tokenStorage, appConfig**, packageInfo, restClient, authBloc, userCubit, settingsBloc
- Тесты: `test/core/rest_client/{auth_interceptor,token_storage,rest_client_base}_test.dart`, `test/core/storage/secure_storage_test.dart`; агрегатор `test/base_test.dart`. Стек: mocktail + package:checks, Given/When/Then-имена

**Карта файлов для оставшихся фаз**:
- Фаза 4: `lib/src/features/auth/data/data_source/{auth/remote_data_source.dart, user/remote_data_source.dart, user/local_data_source.dart}` + интерфейсы в `data_source/interface/`; репозитории `lib/src/features/auth/data/repositories/{auth/auth_repository.dart, user/local_repository.dart, user/remote_repository.dart}`; домен-интерфейсы `lib/src/features/auth/domain/repositories/`; DTO `lib/src/features/auth/data/models/user.dart` (`UserDTO`); контейнер `lib/src/features/initialization/models/repositories.dart` + фабрика `repositories_factories.dart`; helper `lib/src/common/utils/extensions/bloc_extension.dart` (`handleException`)
- Фаза 5: `lib/src/features/auth/presentation/bloc/auth/{auth_bloc,auth_event,auth_state}.dart` (bloc + part-файлы), `lib/src/features/auth/presentation/bloc/user/user_cubit.dart` (state = `UserDTO?`, заменить на UserBloc), `lib/src/features/settings/presentation/bloc/settings_bloc.dart`; `Bloc.transformer = sequential()` глобально стоит в `app_runner.dart` — per-event трансформеры его уточняют
- Фаза 6: роутер в `lib/src/app/router/` (`routes/router.dart` — enum Routes с OctopusRoute, `guards/`, `enums/root_tabs_enum.dart`, `widgets/route_wrapper.dart`); `RootScreen` с табами — `lib/src/app/presentation/screens/root_screen.dart`; splash — `lib/src/features/initialization/presentation/page/splash.dart` (сейчас сам читает tokenStorage и роутит); 12 файлов импортируют octopus
- Фаза 7: эталон скоупа — `lib/src/features/settings/presentation/controller/settings_scope.dart` (InheritedModel + контроллер-интерфейс); `PageLifecycleModel` — `lib/src/common/services/page_lifecycle_model.dart`; `SettingsScreenModel` — `.../settings/presentation/controller/settings_model.dart`

**yx_navigation справка (Фаза 6)**: пакеты `yx_navigation` + `yx_navigation_flutter` ^1.0.0 (pub.dev, publisher dev.go.yandex, MIT). Pure-Dart ядро: `RouteNode` (иммутабельное дерево), `RouteNodeStateManager` (мутации/подписки), `NavigationController`, guards (`GuardResult next/redirect/cancel`), URI-сериализация для deep links. Flutter-слой: `RouterSchema`, `RouteDeclaration.routeBuilder()/scheme()/indexedStack`, `RouteBuilder.widget()/outlet`, `NavigatorOutlet`, интеграция `MaterialApp.router`, compat-слой Navigator 1.0. `RouteNodeStateManager` инжектится через `schema.build(stateManagerConfiguration: ...)` — навигация без BuildContext. Доки в репозитории: github.com/yandex/city-services-pub.

---

## ✅ Фаза 1 — pubspec: обновление + чистка (DONE, commit `e303e1d`)

- [x] **Flutter SDK 3.35.7 → 3.44.1** (Dart 3.12.1) через `fvm use 3.44.1` — без этого новые версии пакетов не резолвились (старый SDK капал analyzer 7.x, build_runner 2.7 и т.д.)
- [x] `flutter pub upgrade --major-versions` — обновлено 73 пакета (dio, drift 2.33, flutter_secure_storage 10.x, envied 1.3, build_runner 2.15, flutter_gen_runner 5.14)
- [x] `pyramid_lint` 3.0 переведён на новый analyzer plugin API; добавлены dev: `checks`, `fake_async`
- [x] Добавлен `clock` в dependencies (использовался транзитивно), `meta` запинен `^1.16.0`
- [x] Удалены: `analyzer: any`, `rxdart`, `stream_transform`, `group_button`, `pure`, `platform_info`, `share_plus`, `device_info_plus`
- [x] Кодген перегенерирован; `l10n.yaml` без deprecated `synthetic-package`
- [x] Починки под новый тулчейн: 5 удалённых lint-правил из analysis_options; `parameter_assignments` в material_context и двух vendored flutter_toast; deprecated `encryptedSharedPreferences`
- [x] Чекпоинт + коммит

Отклонения: ispect остался `5.2.0-dev.19` (осознанный пин автора).

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

## ✅ Фаза 4 — data layer: маппинг ошибок, cache/fresh split (DONE)

- [x] Datasources (`features/auth/data/data_source/**`): убраны бессмысленные `catch (e) { rethrow; }`; в remote-датасорсах (`auth`, `user`) падение парсинга (`UserDTO.fromMap`, `TokenPair.fromJson`) → `Error.throwWithStackTrace(ParseException, st)`; RestClientException теперь пролетает в репозиторий без обёртки
- [x] **Фикс бага**: `UserLocalDataSource.write` — двойное кодирование устранено (`json.encode(user.toMap())`, null → удаление ключа через `setIfNullRemove`); чтение/запись кэша юзера восстановлены. Интерфейс `ILocalUserDataSource` уточнён (`Future<void>` для write/clear)
- [x] Репозитории (`auth_repository.dart`, `user_repository.dart`): на границе `on RestClientException catch (e, st)` → `ISpect.logger.handle` → `e.toAppException()` → `Error.throwWithStackTrace`. Маппинг вынесен в **общий extension** `RestClientExceptionMapper` (`core/rest_client/exceptions/rest_client_exception_mapper.dart`, реальное дублирование на 2 репо): `ConnectionException`→`NetworkException`, `RequestTimeoutException`→`TimeoutAppException`, `WrongResponseTypeException`→`ParseException`, `CustomBackendException` и прочие — возвращаются как есть (UI нужен payload бэкенда)
- [x] Слиты user-репозитории: `LocalUserRepository`+`RemoteUserRepository` → один `UserRepository` (`getCachedUser()` / `getFreshUser()` пишет кэш / `clearCache()`); интерфейс `IUserRepository` в `domain/repositories/user/user_repository.dart`; старые 4 файла (data+domain local/remote) удалены; обновлены `RepositoriesContainer`, обе фабрики, `UserCubit` (мёртвый `write()` удалён — был только в закомментированном вызове). Local-датасорс на повреждённом кэше бросает `CacheException` (storage-сбой), репозиторий его пропускает
- [x] `bloc_extension.dart` `handleException`: exhaustive switch по sealed `AppException` (record-деструктуризация → `onError`), затем `RestClientException`, затем unknown-tier `ISpect.logger.handle` + `onError(e.toString(), e, null)`
- [x] Тесты: `test/features/auth/auth_repository_test.dart` (каждый подтип RestClientException → ожидаемый AppException + сохранённый cause/statusCode/stack; CustomBackendException пролетает as-is; success-пути), `test/features/auth/user_repository_test.dart` (cached без remote; fresh обновляет кэш; transport-fail → AppException без записи кэша; corrupt cache → CacheException; clear делегирует). Добавлены в `base_test.dart`. Итого 78 тестов зелёные
- [x] Чекпоинт + коммит

## ✅ Фаза 5 — BLoC (DONE)

- [x] `AuthBloc` (part-файлы `auth_event.dart`/`auth_state.dart` остаются): states → `Initial/Loading/Authenticated/Unauthenticated/Error(message, cause)`; вместо одного `on<AuthEvent>` — per-event регистрации с трансформерами: `LoginAuthEvent`+`LogoutAuthEvent` → `droppable()` (спам кнопки), `CheckStatusAuthEvent` (новое, читает `tokenStorage.read()`; splash переключится в Фазе 6) → `restartable()`. `GetCurrentUserAuthEvent` удалён (мёртвый)
- [x] Revoke-цепочка: в конструкторе подписка на `tokenStorage.changes`; `null` при Authenticated → внутреннее `_TokenRevokedAuthEvent` → emit `Unauthenticated`; отписка в `close()`. Замыкает E2E: 401 на refresh → interceptor clear → stream null → AuthBloc → Unauthenticated → (Фаза 6) гард уводит на /auth
- [x] Политика обработки ошибок вынесена в один helper `guard` (extension `BlocGuardExtension` рядом с `handleException` в `bloc_extension.dart`); каждый handler сжат до однострочной обёртки `guard(emit:, errorState:, reportBug: onError, () async {...})`, каждый BLoC объявляет одну фабрику error-состояния (`_error`), три `_emitError` удалены. Tier'ы: `on AppException` → Error state; `on RestClientException` → Error state (backend отверг запрос — известный сценарий, напр. неверный пароль через `CustomBackendException`, который осознанно пролетает репозиторий насквозь и НЕ является `AppException`); `on Object` → Error state + `reportBug` (баг — в observer). Все три нормализуются через `handleException` (лог один раз). Поправить tier'ы теперь в одном месте
  - `reportBug` принимает `onError` блока тиром: `Bloc.onError` `@protected` и из extension недоступен (`invalid_use_of_protected_member`), поэтому защищённый доступ остаётся внутри подкласса (tearoff `onError` легален в самом BLoC), а extension лишь вызывает переданный колбэк — без rethrow (он бы дополнительно ронял событие в zone)
  - `errorState` получает сам exception первым аргументом: `ErrorSettingsState.cause` non-null `Object` и тащит `appTheme/locale` из текущего `state`, поэтому его фабрика — instance-метод (closure над `state`), кладёт исходный `error`; auth/user используют нормализованные `message`/`cause`. SettingsBloc теперь тоже на `guard` (трёхуровневый, средний tier у него мёртв — локальные репо `RestClientException` не бросают, но политика единая)
- [x] `UserCubit` → `UserBloc`: sealed states `Initial/Loading/Loaded(user)/Error`, события `FetchUserEvent` (`restartable()`, cached-then-fresh через слитый `UserRepository`) и `ClearUserEvent` (`sequential()`, замена `clear()` из кубита); `user_cubit.dart` удалён
- [x] `SettingsBloc`: форма states остаётся (multi-step с сохранением payload); per-event `sequential()`, двухуровневый catch + `ISpect.logger.handle` через `_emitError` (голый `rethrow` после emit убран)
- [x] Wiring: `dependencies.dart` (`userCubit` → `userBloc` + toString), обе фабрики, `app_runner.dart` (`BlocProvider.value`), `material_context.dart` (`blocRead<UserBloc>().add(FetchUserEvent())`), `auth_screen.dart` (arm `UnauthenticatedAuthState`, мёртвый комментарий про `userCubit.write` убран)
- [x] Тесты: `auth_bloc_test.dart` (login → [Loading, Authenticated] + save; NetworkException → [Loading, Error] + save не вызван; два быстрых Login → репозиторий 1 раз; CheckStatus с/без токена; revoke через `changes`→null → Unauthenticated; logout → clear + Unauthenticated; `CustomBackendException` → [Loading, Error] и observer НЕ получает `onError`; неожиданный `Exception` → [Loading, Error] И observer получает его — оба через recording-observer), `user_bloc_test.dart` (cached→fresh; fresh-fail при кэше → Loaded+Error; без кэша Loading→Loaded; clear), `settings_bloc_test.dart` (theme/locale success + CacheException failure). Итого 120 тестов зелёные
- [x] Чекпоинт + коммит

## ⬜ Фаза 6 — роутер: Octopus → yx_navigation 1.0.0

- [ ] **Шаг 0, spike (полдня)**: добавить `yx_navigation` + `yx_navigation_flutter`; в scratch widget-тесте проверить: `RouteDeclaration.indexedStack` + `RouteBuilder.outlet` дают (а) сохранение состояния табов, (б) push `settings` внутри profile-таба, (в) guard-редирект. Доки: github.com/yandex/city-services-pub (quick_start, route_declarations, guards, compatibility_architecture). **Fallback-лестница**: ручной `IndexedStack` на одном route → nested `RouteDeclaration.scheme` на таб → отмена фазы (не связана с Фазами 1–5, остаёмся на Octopus)
- [ ] `router/routes/app_routes.dart`: статические `YxRoute` константы (splash, auth, root, home-tab, profile-tab, home, profile, settings)
- [ ] `router/app_router_schema.dart`: `RouterSchema` — splash, auth, `indexedStack(root)` с двумя outlet-табами
- [ ] `router/guards/auth_guard.dart`: `RouteNodeGuard` — неавторизован и цель не auth/splash → redirect auth; авторизован и цель auth → redirect root. `isAuthenticated` — closure на `authBloc.state is Authenticated`, гард pure-Dart юнит-тестируем
- [ ] `router/navigation_manager.dart`: инжектируемый поверх `RouteNodeStateManager` (`openRoot/openAuth/openSettings/pop`); координатор подписан на AuthBloc states → навигация без BuildContext (revoke приземляет на auth)
- [ ] `material_context.dart`: `schema.build(stateManagerConfiguration: ...)`; проверить совместимость `ISpectNavigatorObserver`; `OctopusTools` удалить
- [ ] `splash.dart` → тупой экран: restore сессии = `CheckStatusAuthEvent` в AuthBloc; first-run wipe → в composition (`DependenciesFactory`)
- [ ] **Долг из Фазы 5**: `material_context.dart` сейчас безусловно диспатчит `FetchUserEvent` в `initState` — на холодном старте без сессии это гарантированный 401 → revoke-шум. Запуск fetch юзера привязать к `AuthenticatedAuthState` (координатор навигации / в Фазе 7 — `UserScope` от authState), а не к монтированию `MaterialApp`. Убрать вызов из `material_context.dart`
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
| pyramid_lint vs новый analyzer | Миграция на pyramid_lint 3.0 и новый analyzer plugin API ✅ |
| flutter_secure_storage v10 breaking | Изолировано интерфейсом `SecureStorage` (1 файл) ✅ |
| Ложный логаут на флаки-сети | Revoke только на 401/403 от refresh; покрыто тестом ✅ |

## Архитектурные решения (зафиксировано)

- **Refresh-мьютекс**: `QueuedInterceptor` сериализует обработку ошибок; дедупликация — сравнением stale access-токена из заголовка упавшего запроса с текущим в storage («уже ротирован» → реюз). Completer-лок не нужен: ретраи идут через bare Dio и не реентерят интерцептор.
- **Revoke-канал**: `TokenStorage.changes` (broadcast stream) — единственный канал «сессия умерла»; interceptor пишет, AuthBloc слушает, роутер реагирует на state. Никаких навигаций из data-слоя.
- **Composition**: всё строится один раз в `DependenciesFactory` → `ComposedDependencies` record; репозитории больше не создаются дважды.
- **Сохраняем как есть** (уже соответствует правилам, не трогать): hand-written DTO, `PreferencesDao` (typed-обёртка над SharedPreferences), `Isolate.run` для JSON >1000 байт в `RestClientBase.decodeResponse`, `SettingsScope`, локальный пакет `packages/ui` (темы через ThemeExtension), gen-l10n (ARB в `lib/src/core/l10n/translations`, en/ru/kk), Drift (`lib/src/core/database/src/app_database.dart`, TodosTable), envied (`lib/src/core/env/`).
- **Известные нюансы**: два vendored файла `flutter_toast.dart` (в `common/presentation/widgets/toaster/` и `.../dialogs/toaster/`) — форкнутый код, стиль не выравнивать; `DioInterceptor` (`dio_rest_client/src/interceptor/dio_interceptor.dart`) локализует сообщения об ошибках через `L10n` — спорное место, но трогаем только в рамках Фазы 4 (если станет мёртвым — удалить); `.env` объявлен в pubspec assets.
