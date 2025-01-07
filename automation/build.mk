# Added comments and fixed grammatical errors.
# Makefile for building Flutter applications for Android, iOS, and Web.

.PHONY: build-android build-web build-ios prod-apk dev-apk prod-appbundle dev-appbundle

# Build Android APK with prod flavor
build-android: clean
	@echo "Building Android APK"
	@fvm flutter build apk --flavor prod --target lib/main.dart --obfuscate --split-debug-info=build

# Build Web app using Skia and PWA offline-first strategy
build-web: clean
	@echo "Building Web app"
	@fvm flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true --no-pub --no-source-maps --pwa-strategy offline-first

# Build iOS IPA with prod flavor
build-ios: clean
	@echo "Building iOS IPA"
	@fvm flutter build ipa --flavor prod --no-pub

# Build APK with prod flavor
prod-apk:
	@echo "Building APK with prod flavor"
	@fvm flutter build apk --flavor prod --target lib/main.dart --obfuscate --split-debug-info=build --release

# Build APK with dev flavor
dev-apk:
	@echo "Building APK with dev flavor"
	@fvm flutter build apk --flavor dev --target lib/main_dev.dart --obfuscate --split-debug-info=build --release

# Build appbundle with prod flavor
prod-appbundle:
	@echo "Building appbundle with prod flavor"
	@fvm flutter build appbundle --flavor prod --target lib/main.dart --obfuscate --split-debug-info=build

# Build appbundle with dev flavor
dev-appbundle:
	@echo "Building appbundle with dev flavor"
	@fvm flutter build appbundle --flavor dev --target lib/main_dev.dart --obfuscate --split-debug-info=build
