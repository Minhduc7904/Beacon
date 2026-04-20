class PhoneNumberUtils {
  PhoneNumberUtils._();

  static final RegExp _separatorRegex = RegExp(r'[\s().-]');

  // Vietnam mobile numbers, supports local (0...), 84..., and +84... forms.
  static final RegExp _vietnamMobileRegex = RegExp(
    r'^(?:\+84|84|0)(?:3[2-9]|5(?:2|5|6|8|9)|7(?:0|6|7|8|9)|8[1-9]|9[0-9])\d{7}$',
  );

  // International format (E.164) for future extension.
  static final RegExp _internationalE164Regex = RegExp(r'^\+[1-9]\d{7,14}$');

  static String sanitize(String input) {
    return input.trim().replaceAll(_separatorRegex, '');
  }

  static bool isValidVietnamMobile(String input) {
    final sanitized = sanitize(input);
    return _vietnamMobileRegex.hasMatch(sanitized);
  }

  static bool isValidInternational(String input) {
    final sanitized = sanitize(input);
    return _internationalE164Regex.hasMatch(sanitized);
  }

  static bool isValid(String input, {bool allowInternational = false}) {
    if (isValidVietnamMobile(input)) {
      return true;
    }

    if (allowInternational && isValidInternational(input)) {
      return true;
    }

    return false;
  }

  static String? toE164Vietnam(String input) {
    final sanitized = sanitize(input);

    if (!isValidVietnamMobile(sanitized)) {
      return null;
    }

    if (sanitized.startsWith('+84')) {
      return sanitized;
    }

    if (sanitized.startsWith('84')) {
      return '+$sanitized';
    }

    if (sanitized.startsWith('0')) {
      return '+84${sanitized.substring(1)}';
    }

    return null;
  }
}
