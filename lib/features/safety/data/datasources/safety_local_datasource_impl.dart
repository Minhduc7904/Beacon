import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../local_models/monthly_checkins_cache.dart';
import '../local_models/safety_settings_cache.dart';
import 'safety_local_datasource.dart';

class SafetyLocalDatasourceImpl implements SafetyLocalDatasource {
  final AppDatabase _database;

  SafetyLocalDatasourceImpl(this._database);

  @override
  Future<SafetySettingsCache?> getSettings({
    required String cacheScopeUserId,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      return await _database.read((isar) {
        return isar
            .collection<SafetySettingsCache>()
            .getByCacheScopeUserId(scope);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> upsertSettings(SafetySettingsCache cache) async {
    try {
      cache.cacheScopeUserId = _requireCacheScopeUserId(
        cache.cacheScopeUserId,
      );
      await _database.write<void>((isar) async {
        await isar
            .collection<SafetySettingsCache>()
            .putByCacheScopeUserId(cache);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<MonthlyCheckinsCache?> getMonthlyCheckins({
    required String cacheScopeMonthKey,
  }) async {
    try {
      final key = _requireCacheKey(cacheScopeMonthKey);
      return await _database.read((isar) {
        return isar
            .collection<MonthlyCheckinsCache>()
            .getByCacheScopeMonthKey(key);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> upsertMonthlyCheckins(MonthlyCheckinsCache cache) async {
    try {
      cache.cacheScopeUserId = _requireCacheScopeUserId(
        cache.cacheScopeUserId,
      );
      cache.cacheScopeMonthKey = _requireCacheKey(cache.cacheScopeMonthKey);

      await _database.write<void>((isar) async {
        await isar
            .collection<MonthlyCheckinsCache>()
            .putByCacheScopeMonthKey(cache);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  String _requireCacheScopeUserId(String cacheScopeUserId) {
    final scope = cacheScopeUserId.trim();
    if (scope.isEmpty) {
      throw const CacheException(message: 'Missing cache scope user id');
    }

    return scope;
  }

  String _requireCacheKey(String cacheKey) {
    final key = cacheKey.trim();
    if (key.isEmpty) {
      throw const CacheException(message: 'Missing cache key');
    }

    return key;
  }
}
