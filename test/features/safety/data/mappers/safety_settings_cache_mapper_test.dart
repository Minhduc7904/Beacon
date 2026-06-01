import 'package:beacon_app/features/safety/data/mappers/safety_settings_cache_mapper.dart';
import 'package:beacon_app/features/safety/data/models/safety_settings_model.dart';
import 'package:beacon_app/features/safety/domain/entities/safety_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SafetySettingsCacheMapper', () {
    test('map model thành cache với scope user và metadata cache', () {
      final settings = SafetySettingsModel(
        dailyDeadlineLocalTime: '22:30',
        gracePeriodMinutes: 15,
        reminderBeforeMinutes: 45,
        autoAlertDelayMinutes: 10,
        isMonitoringEnabled: true,
        isAutoAlertEnabled: false,
        isDefault: false,
      );
      final cachedAtUtc = DateTime.utc(2026, 6, 1, 8, 30);

      final cache = settings.toCache(
        cacheScopeUserId: 'user-1',
        cachedAtUtc: cachedAtUtc,
      );

      expect(cache.cacheScopeUserId, 'user-1');
      expect(cache.cachedAtUtc, cachedAtUtc);
      expect(cache.dailyDeadlineLocalTime, settings.dailyDeadlineLocalTime);
      expect(cache.gracePeriodMinutes, settings.gracePeriodMinutes);
      expect(cache.reminderBeforeMinutes, settings.reminderBeforeMinutes);
      expect(cache.autoAlertDelayMinutes, settings.autoAlertDelayMinutes);
      expect(cache.isMonitoringEnabled, settings.isMonitoringEnabled);
      expect(cache.isAutoAlertEnabled, settings.isAutoAlertEnabled);
      expect(cache.isDefault, settings.isDefault);
    });

    test('map cache thành domain và không đưa metadata cache vào entity', () {
      final settings = SafetySettings(
        dailyDeadlineLocalTime: '21:00',
        gracePeriodMinutes: 20,
        reminderBeforeMinutes: 30,
        autoAlertDelayMinutes: 5,
        isMonitoringEnabled: false,
        isAutoAlertEnabled: false,
        isDefault: true,
      );
      final cache = settings.toCache(
        cacheScopeUserId: 'user-1',
        cachedAtUtc: DateTime.utc(2026, 6, 1, 8, 30),
      );

      final domain = cache.toDomain();

      expect(domain.dailyDeadlineLocalTime, '21:00');
      expect(domain.gracePeriodMinutes, 20);
      expect(domain.reminderBeforeMinutes, 30);
      expect(domain.autoAlertDelayMinutes, 5);
      expect(domain.isMonitoringEnabled, isFalse);
      expect(domain.isAutoAlertEnabled, isFalse);
      expect(domain.isDefault, isTrue);
    });
  });
}
