import 'package:beacon_app/core/database/app_database.dart';
import 'package:beacon_app/core/errors/exceptions.dart';
import 'package:beacon_app/features/safety/data/datasources/safety_local_datasource_impl.dart';
import 'package:beacon_app/features/safety/data/local_models/monthly_checkins_cache.dart';
import 'package:beacon_app/features/safety/data/local_models/safety_settings_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

class FakeAppDatabase implements AppDatabase {
  int readCount = 0;
  int writeCount = 0;

  @override
  Future<T> read<T>(Future<T> Function(Isar isar) action) {
    readCount++;
    throw StateError('read should not be called');
  }

  @override
  Future<T> write<T>(Future<T> Function(Isar isar) action) {
    writeCount++;
    throw StateError('write should not be called');
  }

  @override
  Future<void> clearAll() async {}

  @override
  Future<void> close() async {}
}

void main() {
  group('SafetyLocalDatasourceImpl', () {
    test('không đọc database khi cacheScopeUserId rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = SafetyLocalDatasourceImpl(database);

      await expectLater(
        datasource.getSettings(cacheScopeUserId: ' '),
        throwsA(isA<CacheException>()),
      );
      expect(database.readCount, 0);
    });

    test('không ghi database khi cacheScopeUserId rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = SafetyLocalDatasourceImpl(database);
      final cache = SafetySettingsCache()..cacheScopeUserId = '';

      await expectLater(
        datasource.upsertSettings(cache),
        throwsA(isA<CacheException>()),
      );
      expect(database.writeCount, 0);
    });
    test('không đọc monthly checkins khi cache key rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = SafetyLocalDatasourceImpl(database);

      await expectLater(
        datasource.getMonthlyCheckins(cacheScopeMonthKey: ' '),
        throwsA(isA<CacheException>()),
      );
      expect(database.readCount, 0);
    });

    test('không ghi monthly checkins khi cache key rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = SafetyLocalDatasourceImpl(database);
      final cache = MonthlyCheckinsCache()
        ..cacheScopeUserId = 'user-1'
        ..cacheScopeMonthKey = '';

      await expectLater(
        datasource.upsertMonthlyCheckins(cache),
        throwsA(isA<CacheException>()),
      );
      expect(database.writeCount, 0);
    });
  });
}
