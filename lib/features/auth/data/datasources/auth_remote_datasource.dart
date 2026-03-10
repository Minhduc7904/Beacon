import '../models/auth_response_model.dart';
import '../models/tokens_model.dart';

abstract class AuthRemoteDatasource {
  /// Đăng nhập, trả về [AuthResponseModel] gồm tokens và user.
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  });

  /// Đăng ký tài khoản mới, trả về [AuthResponseModel] gồm tokens và user.
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  /// Đăng xuất — gọi API invalidate token phía server.
  Future<void> logout({required String refreshToken});

  /// Làm mới accessToken từ refreshToken.
  Future<TokensModel> refreshToken({required String refreshToken});
}