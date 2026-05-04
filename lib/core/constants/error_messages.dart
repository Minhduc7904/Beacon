class ErrorMessages {
  ErrorMessages._();

  static const String noProfileChanges = 'Không có thông tin nào được thay đổi';

  static const String familyNameRequired = 'Họ không được để trống';
  static const String givenNameRequired = 'Tên không được để trống';

  static const String emailRequired = 'Email không được để trống';
  static const String emailInvalidFormat = 'Email không đúng định dạng';

  static const String usernameRequired = 'Tên đăng nhập không được để trống';
  static const String passwordRequired = 'Mật khẩu không được để trống';
  static const String passwordTooShort = 'Mật khẩu phải có ít nhất 8 ký tự';

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
  static const String loginInvalidCredentials = 'Sai username hoặc password';
  static const String accountInactive = 'Tài khoản đã bị vô hiệu hóa';

  static const String registerValidationError = 'Dữ liệu đăng ký không hợp lệ';
  static const String registerUsernameExists = 'Tên đăng nhập đã được sử dụng';
  static const String registerEmailExists = 'Email đã được sử dụng';
  static const String registerPhoneExists = 'Số điện thoại đã được sử dụng';
  static const String registerFailedFallback =
      'Đăng ký thất bại, vui lòng thử lại';

  static const String unauthorized = 'Phiên đăng nhập đã hết hạn';
  static const String userNotFound = 'Không tìm thấy người dùng';

  static const String updateMeValidationError = 'Dữ liệu hồ sơ không hợp lệ';
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
  static const String postMediaInvalidFileType = 'Loại file không được hỗ trợ';
  static const String postMediaFileTooLarge =
      'File vượt quá dung lượng cho phép';
  static const String postMediaUploadFailed =
      'Upload thất bại. Vui lòng thử lại';

  static const String checkinValidationError = 'Dữ liệu check-in không hợp lệ';
  static const String checkinMediaNotFound = 'Không tìm thấy ảnh đính kèm';
  static const String checkinAlreadyCheckedIn = 'Bạn đã check-in hôm nay rồi';

  static const String safetySettingsValidationError =
      'Dữ liệu cài đặt an toàn không hợp lệ';
  static const String safetyDeadlineInvalidFormat =
      'Giờ giới hạn phải đúng định dạng HH:mm';
  static const String safetyGracePeriodOutOfRange =
      'Thời gian gia hạn phải từ 0 đến 1440 phút';
  static const String safetyReminderBeforeOutOfRange =
      'Thời gian nhắc trước phải từ 0 đến 1440 phút';
  static const String safetyAutoAlertDelayOutOfRange =
      'Thời gian trì hoãn cảnh báo phải từ 0 đến 1440 phút';
  // Friend requests
  static const String friendRequestValidationError =
      'Dữ liệu lời mời kết bạn không hợp lệ';
  static const String friendRequestSelfNotAllowed =
      'Không thể gửi lời mời kết bạn cho chính mình';
  static const String friendRequestDuplicate =
      'Đã có lời mời kết bạn đang chờ xử lý';
  static const String friendRequestAlreadyFriends =
      'Hai người dùng đã là bạn bè';
  static const String friendRequestNotFound =
      'Không tìm thấy lời mời kết bạn';
  static const String friendRequestForbidden =
      'Bạn không có quyền xử lý lời mời kết bạn này';
  static const String friendRequestNotPending =
      'Lời mời kết bạn đã được xử lý trước đó';

  // Friends
  static const String friendNotFound =
      'Không tìm thấy bạn bè hoặc người dùng không còn trong danh sách bạn bè';
  static const String friendTypeValidationError =
      'Loại bạn bè không hợp lệ (chỉ nhận giá trị từ 0 đến 3)';

  // Message groups
  static const String messageGroupValidationError =
      'Nội dung tin nhắn không hợp lệ';
  static const String messageGroupForbidden =
      'Bạn không phải thành viên của nhóm chat này';
  static const String messageGroupNotFound = 'Không tìm thấy nhóm chat';
}
