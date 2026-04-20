class AuthErrorCodeMapper {
  AuthErrorCodeMapper._();

  static String? mapCheckPhoneCode(String code) {
    switch (code) {
      case 'VALIDATION_ERROR':
        return 'Số điện thoại để trống hoặc sai định dạng';
      default:
        return null;
    }
  }

  static String? mapCheckEmailCode(String code) {
    switch (code) {
      case 'VALIDATION_ERROR':
        return 'Email để trống hoặc sai định dạng';
      default:
        return null;
    }
  }

  static String? mapLoginCode(String code) {
    switch (code) {
      case 'VALIDATION_ERROR':
        return 'Username hoặc password để trống hoặc vượt quá độ dài cho phép';
      case 'INVALID_CREDENTIALS':
        return 'Tên đăng nhập hoặc tài khoản không đúng';
      case 'ACCOUNT_INACTIVE':
        return 'Tài khoản đã bị vô hiệu hóa';
      default:
        return null;
    }
  }
}
