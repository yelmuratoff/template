# Base Starter

This is an immensely adaptable Flutter starter, crafted with an ideally predetermined layout and encompassing libraries that can be used across a vast array of applications.

To take advantage of this repository, simply click on the "Use this template" button. The subsequent instructions will guide you through the process of integrating and deploying this starter within your distinct projects.

Based on the Sizzle Starter.

## Features

- 🔥 Rapid installation process
- 🧜 Designed to be flexible, easy to expand, and simple to maintain
- 📦 Assortment of reliable and tested libraries
- 🚛 GitHub Actions and GitLab CI pre-configured
- 🚀 Cutting-edge, feature-oriented architecture
- 📌 Comprehensive documentation and exciting roadmap ahead
- 🐛 Bug reporting, error tracking and analytical capabilities
- 😌 Themes and additional amenities...

## How to guides

### How to run

1. Click `Use this template` button
2. Clone this repository via `git clone`
3. Run `fvm install`
4. Run `fvm dart run build_runner build --delete-conflicting-outputs`
5. Decide which platforms your app will be running on
6. Run `chmod a+x bash/enable_native.sh && ./bash/enable_native.sh --id com.example.app`
7. Run `fvm flutter pub get` to install all dependencies
8. Run `fvm flutter run` to run your app
9. For other tasks (like build bundle, ipa) use: `ctrl + shift + p` -> `Run Task`

### How to add a new dependency

**This section describes how to add a new dependency to your app.** Please, check the [initialization](#initialization) section before.

1. Open `lib/src/feature/initialization/model/dependencies.dart`
2. Add new dependency to `DependenciesMutable` and `DependenciesImmutable`
3. Go to `lib/src/feature/initialization/logic/initialization_steps.dart`
4. Add new entry to the map and write down all the logic needed to initialize your dependency and set it in the `DependenciesMutable` object
5. Now, you can use the dependency in the app receiving it from context.

### How do add flavors correctly:
You can use template from `very_good_cli``.