/// A REST client for making HTTP requests.
abstract class RestClient {
  /// Sends a GET request to the given [path].
  Future<Map<String, Object?>> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  });

  /// Sends a POST request to the given [path].
  Future<Map<String, Object?>> post(
    String path, {
    required Object? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  });

  /// Sends a PUT request to the given [path].
  Future<Map<String, Object?>> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  });

  /// Sends a DELETE request to the given [path].
  Future<Map<String, Object?>> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  });

  /// Sends a PATCH request to the given [path].
  Future<Map<String, Object?>> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    bool returnFullData = false,
  });
}
