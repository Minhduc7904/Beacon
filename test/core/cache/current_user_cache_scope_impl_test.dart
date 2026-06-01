import 'package:beacon_app/core/cache/current_user_cache_scope_impl.dart';
import 'package:beacon_app/core/constants/storage_keys.dart';
import 'package:beacon_app/core/storage/secure_storage.dart';
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
  late CurrentUserCacheScopeImpl cacheScope;

  setUp(() {
    storage = FakeSecureStorage();
    cacheScope = CurrentUserCacheScopeImpl(storage);
  });

  group('CurrentUserCacheScopeImpl', () {
    test('lưu và đọc current user id bằng secure storage key', () async {
      await cacheScope.saveCurrentUserId(' user-1 ');

      final result = await cacheScope.getCurrentUserId();

      expect(result, 'user-1');
      expect(storage.values[StorageKeys.currentUserId], 'user-1');
    });

    test('trả về null khi current user id chưa có hoặc rỗng', () async {
      expect(await cacheScope.getCurrentUserId(), isNull);

      storage.values[StorageKeys.currentUserId] = ' ';

      expect(await cacheScope.getCurrentUserId(), isNull);
    });

    test('clear current user id không ảnh hưởng token hiện có', () async {
      storage.values[StorageKeys.currentUserId] = 'user-1';
      storage.values[StorageKeys.accessToken] = 'access-token';
      storage.values[StorageKeys.refreshToken] = 'refresh-token';

      await cacheScope.clearCurrentUserId();

      expect(storage.values.containsKey(StorageKeys.currentUserId), isFalse);
      expect(storage.values[StorageKeys.accessToken], 'access-token');
      expect(storage.values[StorageKeys.refreshToken], 'refresh-token');
    });

    test('save current user id rỗng sẽ clear scope hiện có', () async {
      storage.values[StorageKeys.currentUserId] = 'user-1';

      await cacheScope.saveCurrentUserId(' ');

      expect(storage.values.containsKey(StorageKeys.currentUserId), isFalse);
    });
  });
}
