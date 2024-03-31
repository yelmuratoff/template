/// Common extensions for [String] class.
extension StringExtension on String {
  /// Returns a new string with the first [length] characters of this string.
  String limit(int length) =>
      length < this.length ? substring(0, length) : this;

  /// Returns a new string with the first character capitalized.
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}
