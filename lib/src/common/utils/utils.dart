import 'dart:convert';

final class AppUtils {
  /// `formatPrettyJson` - This function formats a map of strings as a pretty
  /// JSON string.
  static String formatPrettyJson(Map<String, String> data) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }
}
