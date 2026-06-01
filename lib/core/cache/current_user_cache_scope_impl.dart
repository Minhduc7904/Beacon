import '../constants/storage_keys.dart';
import '../storage/secure_storage.dart';
import 'current_user_cache_scope.dart';

class CurrentUserCacheScopeImpl implements CurrentUserCacheScope {
  final SecureStorage _storage;

  CurrentUserCacheScopeImpl(this._storage);

  @override
  Future<String?> getCurrentUserId() async {
    final value = await _storage.read(StorageKeys.currentUserId);
    final userId = value?.trim();
    if (userId == null || userId.isEmpty) {
      return null;
    }

    return userId;
  }

  @override
  Future<void> saveCurrentUserId(String userId) async {
    final normalized = userId.trim();
    if (normalized.isEmpty) {
      await clearCurrentUserId();
      return;
    }

    await _storage.write(StorageKeys.currentUserId, normalized);
  }

  @override
  Future<void> clearCurrentUserId() {
    return _storage.delete(StorageKeys.currentUserId);
  }
}
