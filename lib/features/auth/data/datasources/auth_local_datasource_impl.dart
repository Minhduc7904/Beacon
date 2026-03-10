import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/local_storage.dart';
import 'auth_local_datasource.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final LocalStorage _storage;

  AuthLocalDatasourceImpl(this._storage);

  @override
  Future<void> saveAccessToken(String token) {
    return _storage.setString(StorageKeys.accessToken, token);
  }

  @override
  Future<String?> getAccessToken() {
    return _storage.getString(StorageKeys.accessToken);
  }

  @override
  Future<void> saveRefreshToken(String token) {
    return _storage.setString(StorageKeys.refreshToken, token);
  }

  @override
  Future<String?> getRefreshToken() {
    return _storage.getString(StorageKeys.refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.remove(StorageKeys.accessToken);
    await _storage.remove(StorageKeys.refreshToken);
  }
}
