import 'tokens_model.dart';
import 'user_model.dart';

class AuthResponseModel {
  final String message;
  final TokensModel tokens;
  final UserModel user;

  AuthResponseModel({
    required this.message,
    required this.tokens,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: '',
      tokens: TokensModel.fromJson(json),
      user: UserModel.fromJson(json),
    );
  }
}
