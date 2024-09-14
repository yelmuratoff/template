.PHONY: first-run clean splash prepare icon google-localizations setup format clean version doctor deep-clean install-pods

first-run: prepare run

splash: pub-get
	@echo "* Generating Splash screens *"
	@fvm dart run flutter_native_splash:create

google-localizations:
	@echo "* Getting dependencies for google localizer *"
	@fvm dart pub get --directory=./tool/google_localizer
	@echo "* Generating automated localizations *"
	@fvm dart ./tool/google_localizer/main.dart "./lib/src/core/l10n/"

format:
	@dart format --fix .

setup:
	@echo "* Getting dependencies for setup tool *"
	@fvm flutter clean
	@fvm flutter pub get
	@fvm dart run build_runner build --delete-conflicting-outputs

setup-ios:
	@cd ios && pod deintegrate && pod repo update && pod update && cd ..
	@fvm flutter clean
	@fvm flutter pub get
	@fvm dart run build_runner build --delete-conflicting-outputs
	@cd ios && pod install && cd ..