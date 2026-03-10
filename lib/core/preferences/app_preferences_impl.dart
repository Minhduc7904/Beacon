import '../constants/storage_keys.dart';
import '../storage/local_storage.dart';
import 'app_preferences.dart';

class AppPreferencesImpl implements AppPreferences {
  final LocalStorage _storage;

  AppPreferencesImpl(this._storage);

  @override
  Future<void> setDarkMode({required bool isDark}) {
    return _storage.setBool(StorageKeys.isDarkMode, value: isDark);
  }

  @override
  Future<bool> isDarkMode() async {
    return await _storage.getBool(StorageKeys.isDarkMode) ?? false;
  }
}
