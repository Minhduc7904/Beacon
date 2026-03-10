abstract class LocalStorage {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);

  Future<void> setBool(String key, {required bool value});
  Future<bool?> getBool(String key);

  Future<void> remove(String key);
  Future<void> clearAll();
}
