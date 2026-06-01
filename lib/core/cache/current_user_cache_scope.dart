abstract class CurrentUserCacheScope {
  Future<String?> getCurrentUserId();

  Future<void> saveCurrentUserId(String userId);

  Future<void> clearCurrentUserId();
}
