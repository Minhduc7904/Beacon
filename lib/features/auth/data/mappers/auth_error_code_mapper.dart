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

  static String? mapMeCode(String code) {
    switch (code) {
      case 'UNAUTHORIZED':
        return 'Phiên đăng nhập đã hết hạn';
      case 'USER_NOT_FOUND':
        return 'Không tìm thấy người dùng';
      default:
        return null;
    }
  }

  static String? mapUpdateMeCode(String code) {
    switch (code) {
      case 'VALIDATION_ERROR':
        return 'Dữ liệu hồ sơ không hợp lệ';
      case 'USER_NOT_FOUND':
        return 'Không tìm thấy người dùng';
      case 'EMAIL_ALREADY_IN_USE':
        return 'Email đã được sử dụng bởi tài khoản khác';
      case 'PHONE_ALREADY_IN_USE':
        return 'Số điện thoại đã được sử dụng bởi tài khoản khác';
      default:
        return null;
    }
  }

  static String? mapUpdateAvatarCode(String code) {
    switch (code) {
      case 'VALIDATION_ERROR':
        return 'Ảnh không hợp lệ hoặc vượt quá dung lượng cho phép';
      case 'USER_NOT_FOUND':
        return 'Không tìm thấy người dùng';
      case 'UPLOAD_FAILED':
        return 'Tải ảnh đại diện thất bại, vui lòng thử lại';
      default:
        return null;
    }
  }
}
