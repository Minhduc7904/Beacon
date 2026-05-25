import 'package:beacon_app/core/utils/email_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmailUtils', () {
    test('sanitize cắt khoảng trắng ở đầu và cuối email', () {
      final result = EmailUtils.sanitize('  user@example.com  ');

      expect(result, 'user@example.com');
    });

    test('isValid trả về true với email viết hoa thường lẫn lộn', () {
      final result = EmailUtils.isValid('User.Name+Tag@Example.COM');

      expect(result, isTrue);
    });

    test('isValid trả về false khi thiếu ký tự at', () {
      final result = EmailUtils.isValid('user.example.com');

      expect(result, isFalse);
    });

    test('isValid trả về false khi thiếu hậu tố domain', () {
      final result = EmailUtils.isValid('user@example');

      expect(result, isFalse);
    });

    test('isValid trả về false khi email chứa khoảng trắng', () {
      final result = EmailUtils.isValid('user name@example.com');

      expect(result, isFalse);
    });
  });
}
