import 'package:beacon_app/core/constants/storage_keys.dart';
import 'package:beacon_app/core/storage/secure_storage.dart';
import 'package:beacon_app/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSecureStorage implements SecureStorage {
  final Map<String, String> values = {};

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    return values[key];
  }

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    values.clear();
  }
}

void main() {
  late FakeSecureStorage storage;
  late AuthLocalDatasourceImpl datasource;

  setUp(() {
    storage = FakeSecureStorage();
    datasource = AuthLocalDatasourceImpl(storage);
  });

  group('AuthLocalDatasourceImpl', () {
    test('lưu và đọc access token bằng đúng storage key', () async {
      await datasource.saveAccessToken('access-token');

      final token = await datasource.getAccessToken();

      expect(token, 'access-token');
      expect(storage.values[StorageKeys.accessToken], 'access-token');
    });

    test('trả về null khi access token chưa có', () async {
      final token = await datasource.getAccessToken();

      expect(token, isNull);
    });

    test('lưu và đọc refresh token bằng đúng storage key', () async {
      await datasource.saveRefreshToken('refresh-token');

      final token = await datasource.getRefreshToken();

      expect(token, 'refresh-token');
      expect(storage.values[StorageKeys.refreshToken], 'refresh-token');
    });

    test('trả về null khi refresh token chưa có', () async {
      final token = await datasource.getRefreshToken();

      expect(token, isNull);
    });

    test('lưu expiresAt theo ISO-8601 và đọc lại thành DateTime', () async {
      final expiresAt = DateTime.utc(2026, 5, 26, 12, 30);

      await datasource.saveAccessTokenExpiresAt(expiresAt);
      final result = await datasource.getAccessTokenExpiresAt();

      expect(result, expiresAt);
      expect(
        storage.values[StorageKeys.accessTokenExpiresAt],
        expiresAt.toIso8601String(),
      );
    });

    test('xóa expiresAt key khi lưu expiresAt null', () async {
      storage.values[StorageKeys.accessTokenExpiresAt] =
          DateTime.utc(2026).toIso8601String();

      await datasource.saveAccessTokenExpiresAt(null);
      final result = await datasource.getAccessTokenExpiresAt();

      expect(result, isNull);
      expect(
        storage.values.containsKey(StorageKeys.accessTokenExpiresAt),
        isFalse,
      );
    });

    test('trả về null khi expiresAt chưa có hoặc là chuỗi rỗng', () async {
      expect(await datasource.getAccessTokenExpiresAt(), isNull);

      storage.values[StorageKeys.accessTokenExpiresAt] = '';

      expect(await datasource.getAccessTokenExpiresAt(), isNull);
    });

    test('trả về null khi expiresAt không parse được', () async {
      storage.values[StorageKeys.accessTokenExpiresAt] = 'not-a-date';

      final result = await datasource.getAccessTokenExpiresAt();

      expect(result, isNull);
    });

    test(
      'clearTokens xóa các key auth nhưng không xóa key không liên quan',
      () async {
        storage.values[StorageKeys.accessToken] = 'access-token';
        storage.values[StorageKeys.refreshToken] = 'refresh-token';
        storage.values[StorageKeys.accessTokenExpiresAt] =
            DateTime.utc(2026).toIso8601String();
        storage.values[StorageKeys.isDarkMode] = 'true';

        await datasource.clearTokens();

        expect(storage.values.containsKey(StorageKeys.accessToken), isFalse);
        expect(storage.values.containsKey(StorageKeys.refreshToken), isFalse);
        expect(
          storage.values.containsKey(StorageKeys.accessTokenExpiresAt),
          isFalse,
        );
        expect(storage.values[StorageKeys.isDarkMode], 'true');
      },
    );
  });
}
