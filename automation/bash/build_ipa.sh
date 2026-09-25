./bash/setup_ios.sh
fvm flutter build ipa --target lib/main.dart --dart-define-from-file=env/config_prod.json --obfuscate --split-debug-info=build --no-tree-shake-icons