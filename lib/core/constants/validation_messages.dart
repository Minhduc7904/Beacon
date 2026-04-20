class ErrorMessages {
    ErrorMessages._();

  static const String noProfileChanges =
      'Không có thông tin nào được thay đổi';

  static const String familyNameRequired = 'Họ không được để trống';
  static const String givenNameRequired = 'Tên không được để trống';

  static const String emailRequired = 'Email không được để trống';
  static const String emailInvalidFormat = 'Email không đúng định dạng';

  static const String phoneRequired = 'Số điện thoại không được để trống';
  static const String phoneInvalidVietnam =
      'Số điện thoại Việt Nam không hợp lệ';
  static const String phoneInvalidE164 =
      'Số điện thoại chưa đúng định dạng E.164';

  static const String checkPhoneValidationError =
      'Số điện thoại để trống hoặc sai định dạng';
  static const String checkEmailValidationError =
      'Email để trống hoặc sai định dạng';

  static const String loginValidationError =
      'Username hoặc password để trống hoặc vượt quá độ dài cho phép';
  static const String loginInvalidCredentials =
      'Sai username hoặc password';
  static const String accountInactive = 'Tài khoản đã bị vô hiệu hóa';

  static const String registerValidationError =
      'Dữ liệu đăng ký không hợp lệ';
  static const String registerUsernameExists =
      'Tên đăng nhập đã được sử dụng';
  static const String registerEmailExists = 'Email đã được sử dụng';
  static const String registerPhoneExists =
      'Số điện thoại đã được sử dụng';
  static const String registerFailedFallback =
      'Đăng ký thất bại, vui lòng thử lại';
  static const String registerUsernameTakenEnglish =
      'username is already taken.';

  static const String unauthorized = 'Phiên đăng nhập đã hết hạn';
  static const String userNotFound = 'Không tìm thấy người dùng';

  static const String updateMeValidationError =
      'Dữ liệu hồ sơ không hợp lệ';
  static const String updateMeEmailAlreadyInUse =
      'Email đã được sử dụng bởi tài khoản khác';
  static const String updateMePhoneAlreadyInUse =
      'Số điện thoại đã được sử dụng bởi tài khoản khác';

  static const String updateAvatarValidationError =
      'Ảnh không hợp lệ hoặc vượt quá dung lượng cho phép';
  static const String updateAvatarUploadFailed =
      'Tải ảnh đại diện thất bại, vui lòng thử lại';

  static const String postMediaUploadValidationError =
      'File không hợp lệ hoặc vượt quá dung lượng cho phép';
  static const String postMediaInvalidFileType =
      'Loại file không được hỗ trợ';
  static const String postMediaFileTooLarge =
      'File vượt quá dung lượng cho phép';
  static const String postMediaUploadFailed =
      'Upload thất bại. Vui lòng thử lại';
}
