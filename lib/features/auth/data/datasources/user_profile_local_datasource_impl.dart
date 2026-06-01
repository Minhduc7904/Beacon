import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../local_models/user_profile_cache.dart';
import 'user_profile_local_datasource.dart';

class UserProfileLocalDatasourceImpl implements UserProfileLocalDatasource {
  final AppDatabase _database;

  UserProfileLocalDatasourceImpl(this._database);

  @override
  Future<UserProfileCache?> getProfile({
    required String cacheScopeUserId,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      return await _database.read((isar) {
        return isar.collection<UserProfileCache>().getByCacheScopeUserId(scope);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> upsertProfile(UserProfileCache cache) async {
    try {
      cache.cacheScopeUserId = _requireCacheScopeUserId(
        cache.cacheScopeUserId,
      );
      await _database.write<void>((isar) async {
        await isar.collection<UserProfileCache>().putByCacheScopeUserId(cache);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> deleteProfile({
    required String cacheScopeUserId,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      await _database.write<void>((isar) async {
        await isar
            .collection<UserProfileCache>()
            .deleteByCacheScopeUserId(scope);
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
}
