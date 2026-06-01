import '../local_models/safety_settings_cache.dart';

abstract class SafetyLocalDatasource {
  Future<SafetySettingsCache?> getSettings({
    required String cacheScopeUserId,
  });

  Future<void> upsertSettings(SafetySettingsCache cache);
}
