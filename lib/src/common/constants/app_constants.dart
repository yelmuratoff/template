import 'package:base_starter/src/core/env/env.dart';

/// `AppConstants` is a class that holds all the
/// base `static` constants used in the app.
final class AppConstants {
  /// Rebrand via `dart run tool/rename_app.dart` — it rewrites these values.
  static const String appName = 'Base';

  static const String appIdentifier = 'kz.app.template';

  static const String baseUrl = Env.apiUrl;
}
