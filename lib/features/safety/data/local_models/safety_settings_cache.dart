import 'package:isar/isar.dart';

part 'safety_settings_cache.g.dart';

@collection
class SafetySettingsCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.value)
  late String cacheScopeUserId;

  late DateTime cachedAtUtc;

  late String dailyDeadlineLocalTime;
  late int gracePeriodMinutes;
  late int reminderBeforeMinutes;
  late int autoAlertDelayMinutes;
  late bool isMonitoringEnabled;
  late bool isAutoAlertEnabled;
  late bool isDefault;
}
