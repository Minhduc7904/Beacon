abstract class AppPreferences {
  Future<void> setDarkMode({required bool isDark});
  Future<bool> isDarkMode();
}
