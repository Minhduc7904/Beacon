import '../../domain/entities/tokens.dart';

class TokensModel extends Tokens {
  TokensModel({
    required super.accessToken,
    required super.refreshToken,
    required super.accessTokenExpiresAt,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    final expiresAtRaw = json['accessTokenExpiresAt'] as String?;

    return TokensModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessTokenExpiresAt: expiresAtRaw != null
          ? DateTime.tryParse(expiresAtRaw)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'accessTokenExpiresAt': accessTokenExpiresAt?.toIso8601String(),
    };
  }
}
