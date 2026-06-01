import 'package:beacon_app/features/safety/data/mappers/monthly_checkins_cache_mapper.dart';
import 'package:beacon_app/features/safety/data/models/monthly_checkin_model.dart';
import 'package:beacon_app/features/safety/data/models/monthly_checkins_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonthlyCheckinsCacheMapper', () {
    test('map monthly checkins thành cache theo user/month', () {
      final cachedAtUtc = DateTime.utc(2026, 6, 1, 8, 30);
      final monthly = MonthlyCheckinsModel(
        year: 2026,
        month: 6,
        fromDate: DateTime(2026, 6),
        toDate: DateTime(2026, 6, 30),
        totalCount: 1,
        items: [
          MonthlyCheckinModel(
            id: 'checkin-1',
            dailySafetyRecordId: 'record-1',
            checkinDate: DateTime(2026, 6, 2),
            checkedInAtUtc: DateTime.utc(2026, 6, 2, 12),
            type: 'manual',
            note: null,
            mood: '😊',
            latitude: null,
            longitude: null,
          ),
        ],
      );

      final cache = monthly.toCache(
        cacheScopeUserId: 'user-1',
        cachedAtUtc: cachedAtUtc,
      );

      expect(cache.cacheScopeMonthKey, 'user-1:2026:06');
      expect(cache.cacheScopeUserId, 'user-1');
      expect(cache.year, 2026);
      expect(cache.month, 6);
      expect(cache.totalCount, 1);
      expect(cache.cachedAtUtc, cachedAtUtc);
      expect(cache.itemsJson, contains('checkin-1'));
    });

    test('map cache thành domain và không đưa metadata cache vào entity', () {
      final monthly = MonthlyCheckinsModel(
        year: 2026,
        month: 6,
        fromDate: DateTime(2026, 6),
        toDate: DateTime(2026, 6, 30),
        totalCount: 1,
        items: [
          MonthlyCheckinModel(
            id: 'checkin-1',
            dailySafetyRecordId: 'record-1',
            checkinDate: DateTime(2026, 6, 2),
            checkedInAtUtc: DateTime.utc(2026, 6, 2, 12),
            type: 'manual',
            note: 'ok',
            mood: '😊',
            latitude: 10.1,
            longitude: 106.2,
          ),
        ],
      );
      final cache = monthly.toCache(
        cacheScopeUserId: 'user-1',
        cachedAtUtc: DateTime.utc(2026, 6, 1, 8, 30),
      );

      final domain = cache.toDomain();

      expect(domain.year, 2026);
      expect(domain.month, 6);
      expect(domain.totalCount, 1);
      expect(domain.items.single.id, 'checkin-1');
      expect(domain.items.single.mood, '😊');
      expect(domain.items.single.latitude, 10.1);
      expect(domain.items.single.longitude, 106.2);
    });
  });
}
