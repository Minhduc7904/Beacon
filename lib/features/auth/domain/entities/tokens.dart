class Tokens {
  final String accessToken;
  final String refreshToken;
  final DateTime? accessTokenExpiresAt;

  Tokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
  });
}
