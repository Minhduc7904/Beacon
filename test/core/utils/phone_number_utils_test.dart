import 'package:beacon_app/core/utils/phone_number_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneNumberUtils', () {
    test('sanitize xóa các ký tự phân tách được hỗ trợ', () {
      final result = PhoneNumberUtils.sanitize(' (091) 234-56.78 ');

      expect(result, '0912345678');
    });

    test('isValidVietnamMobile trả về true với số di động nội địa Việt Nam', () {
      final result = PhoneNumberUtils.isValidVietnamMobile('0912345678');

      expect(result, isTrue);
    });

    test('isValidVietnamMobile trả về true với số bắt đầu bằng 84 và +84', () {
      expect(PhoneNumberUtils.isValidVietnamMobile('84912345678'), isTrue);
      expect(PhoneNumberUtils.isValidVietnamMobile('+84912345678'), isTrue);
    });

    test('isValid trả về false với đầu số Việt Nam không được hỗ trợ', () {
      final result = PhoneNumberUtils.isValid('0112345678');

      expect(result, isFalse);
    });

    test('isValid chỉ chấp nhận E.164 quốc tế khi bật flag allowInternational', () {
      const phone = '+14155552671';

      expect(PhoneNumberUtils.isValid(phone), isFalse);
      expect(PhoneNumberUtils.isValid(phone, allowInternational: true), isTrue);
    });

    test('toE164Vietnam chuyển các định dạng Việt Nam được hỗ trợ sang E.164', () {
      expect(PhoneNumberUtils.toE164Vietnam('0912345678'), '+84912345678');
      expect(PhoneNumberUtils.toE164Vietnam('84912345678'), '+84912345678');
      expect(PhoneNumberUtils.toE164Vietnam('+84912345678'), '+84912345678');
    });

    test('toE164Vietnam trả về null với số điện thoại không hợp lệ', () {
      final result = PhoneNumberUtils.toE164Vietnam('0112345678');

      expect(result, isNull);
    });
  });
}
