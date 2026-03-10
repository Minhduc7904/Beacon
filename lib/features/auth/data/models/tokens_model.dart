import '../../domain/entities/tokens.dart';

class TokensModel extends Tokens {
  TokensModel({required String accessToken, required String refreshToken})
    : super(accessToken: accessToken, refreshToken: refreshToken);

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }
}
