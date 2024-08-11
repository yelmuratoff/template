# Starter template for one module apps

This is a highly adaptable Flutter starter kit, designed with an ideal layout and equipped with libraries that can be utilized in a wide variety of applications.

To utilize this repository, simply click on the "Use this template" button. The subsequent instructions will guide you through the process of integrating and deploying this starter within your projects.

**Remember: Keep your code simple and easy to read. It should be straightforward to test and modify. A bit more effort to achieve this goal is always worthwhile.**

**Important:** A pure architecture based project with SOLID principles. But there are a couple of differences:
   - We don't use Entity, DTO (model) takes two responsibilities, as in the future there will be a possibility to use macros.
   - We don't use ValueObject as it is only necessary for complex objects that can be used in different parts of the application.
   - We don't use UseCase because there is no complex business logic in the project that requires additional processing.
   - We don't use GetIt, because it is antipattern. Read more: https://lazebny.io/avoid-these-dart-libraries/#get_it
      Instead, we use a simple DI container that is easy to maintain and expand.


## Features

- 🔥 Included in the ISpect tool
   - ✅ Draggable button for route to ISpect page, manage Inspector tools
   - ✅ Localizations: ru, en. (I will add more translations in the future.)
   - ✅ Talker logger implementation: BLoC, Dio, Routing, Provider
   - ✅ Feedback builder
   - ✅ Debug tools
   - ✅ Cache manager
   - ✅ Device and app info
- 🧜 Flexible design, easy to expand, and simple to maintain
- 📦 Collection of reliable and tested libraries
- 🚛 Pre-configured GitHub Actions and GitLab CI
- 🚀 State-of-the-art, feature-oriented architecture
- 📌 Comprehensive documentation with an exciting roadmap ahead
- 🐛 Bug reporting, error tracking, and analytical capabilities
- 😌 Themes and additional amenities

## How to guides

### .env config
1. You must add .env file to .gitignore
2. Add you API url and other configs to .env file
3. Add fields also to .env.example file
4. Configure env in `lib/src/common/configs/env/env.dart`. Like this:
```dart
final class Env {
 @EnviedField(varName: 'FIELD_NAME', useConstantCase: true)
  static const String fieldName = _Env.fieldName;
}
```  

And you can use it:
```dart
static const String fieldName = Env.fieldName;
```

### How to enable DEV mode

1. Go to Settings page
2. Tap on the project version 10 times
3. You will see the toast modal with options to enable DEV/PROD mode

### How to use ISpect

Simple example of use `ISpect`<br>
You can manage ISpect using `ISpect.read(context)`.
Put this code in your project at an screen and learn how it works. 😊

<div style="display: flex; flex-direction: row; align-items: flex-start; justify-content: flex-start;">
  <img src="https://github.com/K1yoshiSho/packages_assets/blob/main/assets/ispect/preview_usage.gif?raw=true"
  alt="ISpect's example" width="250" style="margin-right: 10px;"/>
</div>


### How to run

1. Click `Use this template` button
2. Clone this repository via `git clone`
3. Run `fvm install`
4. Run `fvm dart run build_runner build --delete-conflicting-outputs`
5. Decide which platforms your app will be running on
6. Run `chmod a+x automation/bash/create_app.sh && ./automation/bash/create_app.sh --id com.example.app`
7. Run `fvm flutter pub get` to install all dependencies
8. Run `fvm flutter run` to run your app
9. For other tasks (like build bundle, ipa) use: `ctrl + shift + p` -> `Run Task`

### How to add a new dependency

**This section describes how to add a new dependency to your app.** Please, check the [initialization](#initialization) section before.

1. Open `lib/src/common/di/containers/dependencies.dart`
2. Add new dependency to `Dependencies` container
3. Go to `lib/src/feature/initialization/logic/initialization_steps.dart`
4. Add new entry to the map and write down all the logic needed to initialize your dependency and set it in the `Dependencies` object
5. Now, you can use the dependency in the app receiving it from context: `context.dependencies.name`

### How do add flavors correctly:
You can use template from `very_good_cli``.

**Note:** use this for android inside `settings.gradle`:
```
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "7.3.0" apply false
    id "org.jetbrains.kotlin.android" version "1.8.22" apply false
}
```

---

Based on the Sizzle Starter.