import '../../domain/entities/safety_settings.dart';
import '../local_models/safety_settings_cache.dart';

extension SafetySettingsToCacheMapper on SafetySettings {
  SafetySettingsCache toCache({
    required String cacheScopeUserId,
    required DateTime cachedAtUtc,
  }) {
    return SafetySettingsCache()
      ..cacheScopeUserId = cacheScopeUserId
      ..cachedAtUtc = cachedAtUtc.toUtc()
      ..dailyDeadlineLocalTime = dailyDeadlineLocalTime
      ..gracePeriodMinutes = gracePeriodMinutes
      ..reminderBeforeMinutes = reminderBeforeMinutes
      ..autoAlertDelayMinutes = autoAlertDelayMinutes
      ..isMonitoringEnabled = isMonitoringEnabled
      ..isAutoAlertEnabled = isAutoAlertEnabled
      ..isDefault = isDefault;
  }
}

extension SafetySettingsCacheToDomainMapper on SafetySettingsCache {
  SafetySettings toDomain() {
    return SafetySettings(
      dailyDeadlineLocalTime: dailyDeadlineLocalTime,
      gracePeriodMinutes: gracePeriodMinutes,
      reminderBeforeMinutes: reminderBeforeMinutes,
      autoAlertDelayMinutes: autoAlertDelayMinutes,
      isMonitoringEnabled: isMonitoringEnabled,
      isAutoAlertEnabled: isAutoAlertEnabled,
      isDefault: isDefault,
    );
  }
}
