import '../local_models/monthly_checkins_cache.dart';
import '../local_models/safety_settings_cache.dart';

abstract class SafetyLocalDatasource {
  Future<SafetySettingsCache?> getSettings({
    required String cacheScopeUserId,
  });

  Future<void> upsertSettings(SafetySettingsCache cache);

  Future<MonthlyCheckinsCache?> getMonthlyCheckins({
    required String cacheScopeMonthKey,
  });

  Future<void> upsertMonthlyCheckins(MonthlyCheckinsCache cache);
}
