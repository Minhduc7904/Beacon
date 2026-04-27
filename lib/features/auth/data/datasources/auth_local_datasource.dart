abstract class AuthLocalDatasource {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();

  Future<void> saveAccessTokenExpiresAt(DateTime? expiresAt);
  Future<DateTime?> getAccessTokenExpiresAt();

  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();

  Future<void> clearTokens();
}
