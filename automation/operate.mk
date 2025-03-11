# Makefile for project setup, maintenance, and automation tasks.

.PHONY: first-run clean splash prepare icon google-localizations setup format clean version doctor deep-clean install-pods setup-ios

# First-time setup and run
first-run: prepare run

# Generate splash screens using flutter_native_splash
splash: pub-get
	@echo "* Generating Splash screens *"
	@fvm dart run flutter_native_splash:create

# Generate Google Localizations
google-localizations:
	@echo "* Getting dependencies for Google Localizer *"
	@fvm dart pub get --directory=./tool/google_localizer
	@echo "* Generating automated localizations *"
	@fvm dart ./tool/google_localizer/main.dart "./lib/src/core/l10n/"

# Format code and apply fixes
format:
	@dart format --fix .

# General setup tasks
setup:
	@echo "* Running general setup tasks *"
	@fvm flutter clean
	@fvm flutter pub get
	@fvm dart run build_runner build --delete-conflicting-outputs

# iOS-specific setup tasks
setup-ios:
	@echo "* Running iOS setup tasks *"
	@cd ios && pod deintegrate && pod repo update && pod update && cd ..
	@fvm flutter clean
	@fvm flutter pub get
	@fvm dart run build_runner build --delete-conflicting-outputs
	@cd ios && pod install && cd ..
