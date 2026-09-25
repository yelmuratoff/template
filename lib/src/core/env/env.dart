/// Build-time configuration injected with `--dart-define-from-file`.
///
/// Values come from the gitignored `env/config_<flavor>.json`; mirror every
/// new key in `env/config.example.json`. A key missing from the file reads as
/// an empty string.
abstract final class Env {
  static const String apiUrl = String.fromEnvironment('API_URL');
}
