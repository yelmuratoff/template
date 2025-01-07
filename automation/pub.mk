# Makefile for managing dependencies in a Flutter project using Flutter Version Manager (FVM).

.PHONY: pub-get pub-outdated pub-upgrade pub-upgrade-major

# Fetches the latest dependencies
pub-get:
	@echo "* Fetching latest dependencies *"
	@fvm flutter pub get

# Upgrades dependencies to the latest compatible versions
pub-upgrade:
	@echo "* Upgrading dependencies *"
	@fvm flutter pub upgrade

# Upgrades dependencies to the latest major versions
pub-upgrade-major:
	@echo "* Upgrading dependencies to latest major versions *"
	@fvm flutter pub upgrade --major-versions

# Checks for outdated dependencies after upgrading
pub-outdated: pub-upgrade
	@echo "* Checking for outdated dependencies *"
	@fvm flutter pub outdated
