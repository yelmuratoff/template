.PHONY: build-android build-web build-ios

build-android: clean
	@echo "Building Android APK"
	@fvm flutter build apk --flavor prod --target lib/main.dart --obfuscate --split-debug-info=build

build-web: clean
	@echo "Building Web app"
	@fvm flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true --no-pub --no-source-maps --pwa-strategy offline-first

build-ios: clean
	@echo "Building iOS IPA"
	@fvm flutter build ipa --flavor prod --no-pub

prod-apk:
	@echo "Build apk with prod flavor"
	@fvm flutter build apk --flavor prod --target lib/main.dart --obfuscate --split-debug-info=build --release

dev-apk:
	@echo "Build apk with dev flavor"
	@fvm flutter build apk --flavor dev --target lib/main_dev.dart --obfuscate --split-debug-info=build --release

prod-appbundle:
	@echo "Build appbundle with prod flavor"
	@fvm flutter build appbundle --flavor prod --target lib/main.dart --obfuscate --split-debug-info=build

dev-appbundle:
	@echo "Build appbundle with dev flavor"
	@fvm flutter build appbundle --flavor dev --target lib/main_dev.dart --obfuscate --split-debug-info=build