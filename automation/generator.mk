# Makefile for managing code generation and localization using build_runner and Flutter's l10n.

.PHONY: gen-build gen-clean gen-watch gen-l10n

# Run build_runner to generate code
gen-build: pub-get
	@echo "* Running build_runner for code generation *"
	@fvm dart run build_runner build --delete-conflicting-outputs

# Clean build_runner generated files
gen-clean:
	@echo "* Cleaning build_runner generated files *"
	@fvm dart run build_runner clean

# Run build_runner in watch mode for continuous code generation
gen-watch:
	@echo "* Running build_runner in watch mode *"
	@fvm dart run build_runner watch

# Generate localization files using Flutter's l10n tool
gen-l10n:
	@echo "* Generating localization files *"
	@fvm flutter gen-l10n