class EmailUtils {
  EmailUtils._();

  static final RegExp _emailRegex = RegExp(
    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    caseSensitive: false,
  );

  static String sanitize(String input) {
    return input.trim();
  }

  static bool isValid(String input) {
    final sanitized = sanitize(input);
    return _emailRegex.hasMatch(sanitized);
  }
}
