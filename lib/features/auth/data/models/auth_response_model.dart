import 'tokens_model.dart';
import 'user_model.dart';

class AuthResponseModel {
  final TokensModel tokens;
  final UserModel user;

  AuthResponseModel({required this.tokens, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      tokens: TokensModel.fromJson(json['tokens'] as Map<String, dynamic>),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
