cd ios
pod deintegrate
pod repo update
pod update
cd ..
fvm flutter clean
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
cd ios
pod install