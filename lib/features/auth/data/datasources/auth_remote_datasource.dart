import '../models/auth_response_model.dart';
import '../models/tokens_model.dart';
import '../models/user_profile_model.dart';

abstract class AuthRemoteDatasource {
  /// Kiểm tra email còn khả dụng để đăng ký.
  Future<bool> checkEmailAvailable({required String email});

  /// Kiểm tra số điện thoại còn khả dụng để đăng ký.
  Future<bool> checkPhoneAvailable({required String phoneNumber});

  /// Đăng nhập, trả về [AuthResponseModel] gồm tokens và user.
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  });

  /// Đăng ký tài khoản mới, trả về [AuthResponseModel] gồm tokens và user.
  Future<AuthResponseModel> register({
    required String email,
    required String confirmPassword,
    required String familyName,
    required String givenName,
    required String username,
    required String password,
    required String phoneNumber,
  });

  /// Đăng xuất — gọi API invalidate token phía server.
  Future<void> logout({required String refreshToken});

  /// Làm mới accessToken từ refreshToken.
  Future<TokensModel> refreshToken({required String refreshToken});

  /// Lấy profile người dùng hiện tại từ access token.
  Future<UserProfileModel> getMe();

  /// Cập nhật thông tin profile người dùng hiện tại.
  Future<UserProfileModel> updateMe({
    String? familyName,
    String? givenName,
    String? email,
    String? phoneNumber,
  });

  /// Cập nhật avatar người dùng bằng file ảnh.
  Future<UserProfileModel> updateMyAvatar({required String filePath});

  /// Đăng ký hoặc cập nhật push token của thiết bị hiện tại.
  Future<void> updateFcmToken({
    required String token,
    required String platform,
  });

  /// Thu hồi push token của thiết bị hiện tại.
  Future<void> deleteFcmToken({required String token});
}
