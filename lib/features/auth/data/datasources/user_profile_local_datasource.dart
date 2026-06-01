import '../local_models/user_profile_cache.dart';

abstract class UserProfileLocalDatasource {
  Future<UserProfileCache?> getProfile({
    required String cacheScopeUserId,
  });

  Future<void> upsertProfile(UserProfileCache cache);

  Future<void> deleteProfile({
    required String cacheScopeUserId,
  });
}
