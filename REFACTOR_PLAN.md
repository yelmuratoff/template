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

**Поток инициализации**: `main.dart` → `bootstrap.dart` (`ISpect.run`, root error handlers `_installRootErrorHandlers`) → `AppRunner.initializeAndRun` (`lib/src/app/logic/app_runner.dart`) → `CompositionRoot.compose()` (`lib/src/features/initialization/logic/composition_root.dart`) — единая точка сборки графа простыми приватными методами (`_createConfig/_createRestClient/_createRepositories/_createSettingsBloc`), возвращает `CompositionResult` (dependencies + repositories + ms) → `App` widget оборачивает `DependenciesScope` (InheritedWidget, доступ `context.dependencies` через `lib/src/common/utils/extensions/context_extension.dart`) → `SettingsScope` → `MaterialContext` (`lib/src/app/presentation/widgets/material_context.dart`) с Octopus-роутером.

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
- [x] Политика обработки ошибок вынесена в один helper `guard` (extension `BlocGuardExtension` рядом с `handleException` в `bloc_extension.dart`); каждый handler сжат до однострочной обёртки `guard(emit:, errorState:, reportBug: onError, () async {...})`, каждый BLoC объявляет одну фабрику error-состояния (`_error`), три `_emitError` удалены. **Два tier'а** (после введения `BackendException`, см. ниже): `on AppException` → Error state (одно семейство, маппер репозитория тотальный); `on Object` → Error state + `reportBug` (баг — в observer). Нормализация через `handleException` (лог один раз). Поправить политику теперь в одном месте
  - `reportBug` принимает `onError` блока тиром: `Bloc.onError` `@protected` и из extension недоступен (`invalid_use_of_protected_member`), поэтому защищённый доступ остаётся внутри подкласса (tearoff `onError` легален в самом BLoC), а extension лишь вызывает переданный колбэк — без rethrow (он бы дополнительно ронял событие в zone)
  - `errorState` получает сам exception первым аргументом: `ErrorSettingsState.cause` non-null `Object` и тащит `appTheme/locale` из текущего `state`, поэтому его фабрика — instance-метод (closure над `state`), кладёт исходный `error`; auth/user используют нормализованные `message`/`cause`. SettingsBloc тоже на `guard` (политика единая)
- [x] **Упрощение течи `CustomBackendException` (вместе с фиксом)**: добавлен `BackendException extends AppException` (`message` + `error`-payload + `statusCode` + `cause`); маппер `toAppException()` стал **тотальным** (`AppException`, не `Object`). Контракт репозитория больше не протекает транспортным типом (`RestClientException` не встречается вне `core/rest_client`), `handleException` потерял ветку `RestClientException`, `guard` потерял средний tier. `CustomBackendException` остаётся транспортным типом (его кидает `RestClientDio`), но дальше репозитория не уходит
  - **Уточнение маппинга (ниты Фазы 8, занесены сюда)**: только `CustomBackendException` → `BackendException` (бэкенд ответил структурированной ошибкой, payload нужен UI). `ClientException` (безответный клиентский сбой — cancel/badCertificate/ошибка encode-decode/catch-all `on Object`) → `NetworkException`, а не `BackendException` («backend rejected» был неверным ярлыком). Мёртвый `InternalServerException` (нигде не бросался) удалён из sealed-семейства и switch'а. Тест `ClientException → NetworkException` добавлен
- [x] `UserCubit` → `UserBloc`: sealed states `Initial/Loading/Loaded(user)/Error`, события `FetchUserEvent` (`restartable()`, cached-then-fresh через слитый `UserRepository`) и `ClearUserEvent` (`sequential()`, замена `clear()` из кубита); `user_cubit.dart` удалён
- [x] `SettingsBloc`: форма states остаётся (multi-step с сохранением payload); per-event `sequential()`, двухуровневый catch + `ISpect.logger.handle` через `_emitError` (голый `rethrow` после emit убран)
- [x] Wiring: `dependencies.dart` (`userCubit` → `userBloc` + toString), обе фабрики, `app_runner.dart` (`BlocProvider.value`), `material_context.dart` (`blocRead<UserBloc>().add(FetchUserEvent())`), `auth_screen.dart` (arm `UnauthenticatedAuthState`, мёртвый комментарий про `userCubit.write` убран)
- [x] Тесты: `auth_bloc_test.dart` (login → [Loading, Authenticated] + save; NetworkException → [Loading, Error] + save не вызван; два быстрых Login → репозиторий 1 раз; CheckStatus с/без токена; revoke через `changes`→null → Unauthenticated; logout → clear + Unauthenticated; `CustomBackendException` → [Loading, Error] и observer НЕ получает `onError`; неожиданный `Exception` → [Loading, Error] И observer получает его — оба через recording-observer), `user_bloc_test.dart` (cached→fresh; fresh-fail при кэше → Loaded+Error; без кэша Loading→Loaded; clear), `settings_bloc_test.dart` (theme/locale success + CacheException failure). Итого 120 тестов зелёные
- [x] Чекпоинт + коммит

## ✅ Фаза 6 — роутер: Octopus → yx_navigation 1.0.0 (DONE)

- [x] **Шаг 0, spike**: `yx_navigation` + `yx_navigation_flutter` ^1.0.0 добавлены; API сверен с исходниками пакета и эталонным примером `example/.../06_driver_app_with_tabs_and_profile.dart` (idентичный кейс: indexedStack-табы + nested push + guard). Подход — **Business-Logic-First**: `RouteNodeStateManager` инжектится, гард-пайплайн строится из роутов (без виджетов). Проверки (а)/(б)/(в) закрыты тестами на уровне дерева состояния + рендера `RootView`
- [x] `router/routes/app_routes.dart`: `abstract final AppRoutes` с `YxRoute` константами (splash, auth, root, home-tab, profile-tab, home, profile, settings)
- [x] `router/app_router_schema.dart`: `AppRouterSchema extends RouterSchema` — только маппинг роут→виджет (splash, auth, `indexedStack(root)` с двумя outlet-табами home-tab/profile-tab; CounterCubit инжектится `BlocProvider` в декларации home). Гарды декларации игнорируются при инжекте stateManager — живут в `NavigationManager`
- [x] `router/guards/auth_guard.dart`: `AuthGuard implements RouteNodeGuard` — неавторизован и цель не auth/splash → redirect auth; авторизован и цель auth → redirect root. `isAuthenticated` — closure (`authBloc.state is AuthenticatedAuthState`), pure-Dart юнит-тестируем
- [x] `router/guards/tab_init_guard.dart`: `TabInitGuard` — сидит первый ребёнок outlet-таба (NavigateToIndexedStackNodeGuard создаёт узлы табов пустыми; без сидирования outlet рендерит пустой навигатор)
- [x] `router/navigation_manager.dart`: владеет `RouteNodeStateManager` (контейнер id `app` → дети = top-level страницы; гарды: RedirectRouteNodeGuard + AuthGuard + NavigateToIndexedStackNodeGuard + 2× TabInitGuard). Координатор подписан на `AuthBloc.stream`: Authenticated → `openRoot()` + `FetchUserEvent`; Unauthenticated → `openAuth()`. `openSettings()` — push settings в profile-tab. Навигация без BuildContext (revoke приземляет на auth). Инжектится через `DependenciesContainer`
- [x] `material_context.dart`: `AppRouterSchema().build(stateManagerConfiguration: ...)` от `navigationManager.stateManager`; `ISpectNavigatorObserver` через `NavigatorConfiguration.navigatorObservers`; `OctopusTools` и безусловный `FetchUserEvent` (долг Фазы 5) удалены; `YxRouterConfig.dispose()` в `dispose()`
- [x] `splash.dart` → тупой экран: `CheckStatusAuthEvent` в `initState`; first-run wipe перенесён в `CompositionRoot.compose()`
- [x] Обновлены: `auth_screen` (statement-switch listener, навигация снята — её ведёт координатор), `home_screen` (убраны `HomeTab`/`BucketNavigator`/`wrappedRoute`), `profile_screen` (StatelessWidget, settings через `navigationManager.openSettings()`), `settings_screen` (без `title`, pop через context, logout-нав снят), `context_extension.pop()` (через `YxNavigation.navigatorOf().maybePop()`), `error_router_screen` (`openRoot()`), `root_screen` → `RootView` от `RouteIndexedStackBuilder`
- [x] Удалены: `router/routes/router.dart`, `router/guards/tab.dart`, `router/guards/auth.dart`, `router/enums/root_tabs_enum.dart`, `router/widgets/route_wrapper.dart`, `router/utils/utils.dart` (+ пустые папки); pubspec: −octopus
- [x] Тесты: `auth_guard_test.dart` (6 сценариев, pure Dart), `navigation_manager_test.dart` (5: splash-старт, Authenticated→root+2 таба seeded, Authenticated→FetchUser, Unauthenticated→auth, openSettings→profile-tab; реальный гард-пайплайн через mock AuthBloc/UserBloc), `root_view_test.dart` (2: рендер табов, tap→setActiveRoute). Добавлены в `base_test.dart`. Итого 148 тестов зелёные
- [x] Чекпоинт (format/analyze 0 issues/test green) + коммит
- [x] **Ручной smoke выполнен**: `fvm flutter run --flavor dev -t lib/main_dev.dart` — приложение запускается, login → табы, диалоги открываются/закрываются. Найден и закрыт пробел: дефолтный `NavigatorOverrides` yx_navigation разрешает императивный `push`, но молча отклоняет парный `pop` (`showDialog`/пикеры зависали) — фикс: `NavigationConfigProvider(navigatorOverrides: NavigatorCompatibilityOverrides())` поверх `MaterialApp.router` в `material_context.dart` (commit `57aa600`); фикс постоянный, на нём держатся прод-диалоги (`change_environment.dart`). Попутно обновлён Android Gradle-тулчейн до wrapper 8.9 (commit `c2f47d2`) — debug-сборка разблокирована

## ✅ Фаза 7 — presentation: Screen/View + Scope-виджеты (DONE)

- [x] `features/auth/presentation/auth_scope.dart`: интерфейс `AuthController {state, login(email, password), logout()}`; `AuthScope.of(context, {listen})` (контроллер) + `AuthScope.stateOf(context)` (реактивный read, Of-суффикс); State реализует контроллер, BlocBuilder над инжектируемым `AuthBloc` → `_InheritedAuthScope` (updateShouldNotify по state). **Отклонение от формулировки**: bloc инжектится через конструктор (`authBloc:`), а не читается из `DependenciesScope` внутри — точное повторение эталона `SettingsScope` (тот тоже принимает `settingsBloc:`); `app.dart` сорсит его из `result.dependencies`. Это и юнит-тестируемо (fake bloc без сборки всего контейнера), и совпадает с эталоном
- [x] `features/auth/presentation/user_scope.dart`: `UserScope.of/stateOf/userOf(context)` (userOf → `LoadedUserState.user` или null), `fetch()` dispatch; та же форма (инжектируемый `UserBloc`, `_InheritedUserScope`)
- [x] Скоупы смонтированы в `app.dart` под `SettingsScope`: `AuthScope(authBloc:) → UserScope(userBloc:) → MaterialContext`. Роуты — потомки `MaterialApp.router`, поэтому `*.of(context)` достаёт скоупы выше `MaterialApp` (как и `SettingsScope`)
- [x] Screen/View split: `auth_screen.dart` → `AuthScreen` (`BlocListener` на `context.dependencies.authBloc` для лоадера/тоста, login через `AuthScope.of().login()`) + публичный `AuthView` (чистый layout, `onLoginPressed`); `profile_screen.dart` → `ProfileScreen` (Stateless: `UserScope.userOf` для данных, `AuthScope.of().logout()`, `navigationManager.openSettings()`) + `ProfileView` (чистый: user name/email + logout/настройки колбэки) — впервые прогоняет user-фичу end-to-end; `settings_screen.dart` — `PageLifecycleModel`/`SettingsScreenModel` убраны, tap-счётчик → `int _tapNumber` в State, `BlocListener<AuthBloc>` привязан к `bloc: context.dependencies.authBloc`. `home_screen.dart` проверен — уже чистый после Фазы 6 (CounterCubit через `BlocProvider` в декларации роута, не трогаем)
  - **Решение по слушателям**: диалоги (лоадер/тост) остаются на `BlocListener`, привязанном к `context.dependencies.authBloc` — это санкционированный правилом `bloc` механизм и он устойчив к гонке «координатор сменил роут раньше, чем сработал листенер» (листенер успевает до фактического анмаунта экрана). Скоупы дают реактивные reads (`stateOf`/`userOf`) и dispatch (`login`/`logout`/`fetch`) для потребителей, не желающих знать про bloc; `ProfileScreen` — чистый scope-потребитель (контейнер только для навигации)
- [x] `app_runner.dart`: `MultiBlocProvider`/`BlocProvider.value` удалены (скоупы держат blocs сами); вложенная shadow-функция `initializeAndRun` развёрнута в тело метода; импорт `flutter_bloc` → `bloc` (нужен только `Bloc.transformer`)
- [x] `context_extension.dart`: удалены `provide`/`provideOnce`/`provideOrNull`/`provideOnceOrNull`/`blocWatch`/`blocRead` + импорт `provider`; удалены `page_lifecycle_model.dart`, `settings_model.dart`; `provider` убран из pubspec (больше нигде не использовался)
- [x] Тесты: `auth_scope_test.dart` (отдаёт state; ребилд зависимых при смене state; `login()`/`logout()` диспатчат событие в mock bloc), `user_scope_test.dart` (`userOf` отдаёт загруженного юзера / null; `fetch()` диспатчит), `auth_view_test.dart` (tap login → колбэк), `profile_view_test.dart` (рендер name/email; tap настроек/logout → колбэки). Добавлены в `base_test.dart`. Полный прогон зелёный (178 тестов)
- [x] Чекпоинт (format/analyze 0 issues/test green) + коммит

## ⬜ Фаза 8 — финальный проход

- [x] (сделано досрочно в рамках Фазы 5) Удалён мёртвый `DioInterceptor` (локализовал ошибки через `L10n` на транспортном слое — нарушение слоёв; после Фазы 3 никем не создавался) вместе с `ExceptionKeys` и блоком `@_Errors_messages` в трёх ARB; l10n перегенерирован
- [ ] `fvm flutter pub outdated` повторно; убедиться что `flutter_easyloading`, `iconsax_plus`, `auto_size_text`, `gap` ещё используются (иначе удалить)
- [x] Хвосты ревью Фазы 7: `App` → `StatelessWidget` (мёртвый `App.attach()` и no-op `_AppState.dispose()` удалены); `'Home'`/`'Profile'` в `root_screen.dart` → `L10n.current.home`/`.profile` (items больше не `const`; `root_view_test` грузит `L10n.load(en)`); `splash.dart` — `Color(0xff1468AD)` → `context.theme.colorScheme.primary`
- [x] **Решено** (трактуем как `Unauthenticated`, consistent с recover-from-corruption): `_onCheckStatus` больше не идёт через `guard` — приватный `_readSession()` ловит `on Exception` (вкл. `CacheException`), логирует через `ISpect.logger.handle` и возвращает `UnauthenticatedAuthState`; `Error`-подтипы пролетают (краш → репорт). Сплэш не зависает. Тест `recovers to [Loading, Unauthenticated] when the token read fails` (+ observer НЕ получает onError) добавлен
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
- **Composition**: всё строится один раз приватными методами `CompositionRoot.compose()` → `CompositionResult`; репозитории больше не создаются дважды.
- **Сохраняем как есть** (уже соответствует правилам, не трогать): hand-written DTO, `PreferencesDao` (typed-обёртка над SharedPreferences), `Isolate.run` для JSON >1000 байт в `RestClientBase.decodeResponse`, `SettingsScope`, локальный пакет `packages/ui` (темы через ThemeExtension), gen-l10n (ARB в `lib/src/core/l10n/translations`, en/ru/kk), Drift (`lib/src/core/database/src/app_database.dart`, TodosTable), envied (`lib/src/core/env/`).
- **Известные нюансы**: два vendored файла `flutter_toast.dart` (в `common/presentation/widgets/toaster/` и `.../dialogs/toaster/`) — форкнутый код, стиль не выравнивать; `.env` объявлен в pubspec assets. (Мёртвый `DioInterceptor` удалён в рамках Фазы 5.)
- **Церемония фабрик — упрощено** (по явному решению): `Factory`/`AsyncFactory` интерфейсы и 5 классов-фабрик (`DependenciesFactory`/`RestClientFactory`/`ConfigManagerFactory`/`SettingsBlocFactory`/`RepositoriesFactory`) заменены приватными async-методами `CompositionRoot`; оба файла `factories/*.dart` удалены. `InitializationHook` обрезан до `onInitialized` + `onError` (живые: лог завершения и экран ошибки с ретраем); мёртвый `onInit` (никогда не вызывался) и церемониальный `onInitializing(name)`/per-step лог «🌀 Inited X» убраны. `CompositionRoot` больше не держит `hook`.
