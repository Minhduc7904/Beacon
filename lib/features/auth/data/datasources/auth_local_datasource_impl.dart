import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/secure_storage.dart';
import 'auth_local_datasource.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SecureStorage _storage;

  AuthLocalDatasourceImpl(this._storage);

  @override
  Future<void> saveAccessToken(String token) {
    return _storage.write(StorageKeys.accessToken, token);
  }

  @override
  Future<String?> getAccessToken() {
    return _storage.read(StorageKeys.accessToken);
  }

  @override
  Future<void> saveAccessTokenExpiresAt(DateTime? expiresAt) async {
    if (expiresAt == null) {
      await _storage.delete(StorageKeys.accessTokenExpiresAt);
      return;
    }

    await _storage.write(
      StorageKeys.accessTokenExpiresAt,
      expiresAt.toIso8601String(),
    );
  }

  @override
  Future<DateTime?> getAccessTokenExpiresAt() async {
    final raw = await _storage.read(StorageKeys.accessTokenExpiresAt);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  @override
  Future<void> saveRefreshToken(String token) {
    return _storage.write(StorageKeys.refreshToken, token);
  }

  @override
  Future<String?> getRefreshToken() {
    return _storage.read(StorageKeys.refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(StorageKeys.accessToken);
    await _storage.delete(StorageKeys.refreshToken);
    await _storage.delete(StorageKeys.accessTokenExpiresAt);
  }
}
